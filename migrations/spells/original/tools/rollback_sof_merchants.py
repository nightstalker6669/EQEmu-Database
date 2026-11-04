#!/usr/bin/env python3
"""Plan/undo only stage011 changes owned by a successful installer receipt."""
import argparse
import hashlib
import json
from pathlib import Path
from install import ROOT, equal, sql_key

STAGE = '011-sof-faction-merchants'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--db-config', type=Path, required=True)
    parser.add_argument('--backup', type=Path, required=True, help='Successful installer backup directory')
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    import pymysql
    config = json.loads(args.db_config.read_text())
    if not set(config) <= {'host', 'port', 'user', 'password', 'database', 'unix_socket'} or not {'user', 'database'} <= set(config):
        parser.error('Invalid database configuration fields')
    manifest = json.loads((ROOT / 'manifest.json').read_text())
    stage = next(s for s in manifest['stages'] if s['name'] == STAGE)
    raw = (ROOT / stage['path']).read_bytes()
    sha = hashlib.sha256(raw).hexdigest()
    receipt = json.loads((args.backup / 'receipt.json').read_text())
    if sha != stage['sha256'] or not receipt['applied'] or receipt['payload_sha256'].get(stage['path']) != sha:
        raise RuntimeError('Payload or successful installer receipt differs')
    payload = json.loads(raw)
    changes = json.loads((args.backup / 'changes.json').read_text())
    inserted = [(t, r) for t, r in changes['new_rows'] if r in payload['inserts'].get(t, [])]
    updates = [u for u in changes['updates'] if u in payload['updates']]
    deleted = [d for d in changes.get('deleted_rows', []) if d in payload['deletes']]
    report = {'stage': STAGE, 'groups_removed': len(inserted), 'updates_restored': len(updates),
              'rows_restored': len(deleted), 'applied': False, 'already_rolled_back': False,
              'no_owned_changes': not (inserted or updates or deleted)}
    connection = pymysql.connect(**config, autocommit=False, cursorclass=pymysql.cursors.DictCursor)
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT GET_LOCK('rof2_spells_install',0) AS locked")
            if cursor.fetchone()['locked'] != 1:
                raise RuntimeError('Another spell content operation holds the lock')
            after, before = [], []
            for table, row in inserted:
                key = {k: row[k] for k in manifest['primary_keys'][table]}
                where, values = sql_key(key)
                cursor.execute(f'SELECT * FROM `{table}` WHERE {where} FOR UPDATE', values)
                actual = cursor.fetchone()
                after.append(actual == row)
                before.append(actual is None)
            for update in updates:
                where, values = sql_key(update['key'])
                cursor.execute(f"SELECT * FROM `{update['table']}` WHERE {where} FOR UPDATE", values)
                actual = cursor.fetchone()
                identity = actual is not None and all(actual[k] == v for k, v in update['identity'].items())
                after.append(identity and all(equal(actual[k], v) for k, v in update['after'].items()))
                before.append(identity and all(equal(actual[k], v) for k, v in update['before'].items()))
            for deletion in deleted:
                where, values = sql_key(deletion['key'])
                cursor.execute(f"SELECT * FROM `{deletion['table']}` WHERE {where} FOR UPDATE", values)
                actual = cursor.fetchone()
                after.append(actual is None)
                before.append(actual == deletion['before'])
            if all(before):
                report['already_rolled_back'] = not report['no_owned_changes']
                connection.rollback()
                print(json.dumps(report, indent=2))
                return
            if not all(after):
                raise RuntimeError('Stage011 rows were customized or partially restored; no rollback performed')
            for requirement in payload['required_merchant_inventories']:
                cursor.execute('SELECT * FROM merchantlist WHERE merchantid=%s ORDER BY slot FOR UPDATE',
                               (requirement['merchantid'],))
                if cursor.fetchall() != requirement['after']:
                    raise RuntimeError('Merchant inventory changed since install; no rollback performed')
            for table, row in inserted:
                if table != 'npc_faction':
                    raise RuntimeError('Unexpected owned insert type')
                expected = sorted(u['key']['id'] for u in updates if u['table'] == 'npc_types'
                                  and u['after'].get('npc_faction_id') == row['id'])
                cursor.execute('SELECT id FROM npc_types WHERE npc_faction_id=%s ORDER BY id FOR UPDATE', (row['id'],))
                if [r['id'] for r in cursor.fetchall()] != expected:
                    raise RuntimeError('New faction group has another NPC consumer')
                cursor.execute('SELECT npc_faction_id FROM npc_faction_entries WHERE npc_faction_id=%s FOR UPDATE', (row['id'],))
                if cursor.fetchone():
                    raise RuntimeError('New faction group acquired kill/assist entries')
            if not args.apply:
                connection.rollback()
                print(json.dumps(report, indent=2))
                return
            for update in reversed(updates):
                where, values = sql_key(update['key'])
                fields = update['before']
                cursor.execute(f"UPDATE `{update['table']}` SET " + ','.join(f'`{k}`=%s' for k in fields) +
                               ' WHERE ' + where, tuple(fields.values()) + values)
            for deletion in deleted:
                row = deletion['before']
                cursor.execute(f"INSERT INTO `{deletion['table']}` (" + ','.join(f'`{k}`' for k in row) +
                               ') VALUES (' + ','.join(['%s'] * len(row)) + ')', tuple(row.values()))
            for table, row in reversed(inserted):
                where, values = sql_key({k: row[k] for k in manifest['primary_keys'][table]})
                cursor.execute(f'DELETE FROM `{table}` WHERE {where}', values)
            connection.commit()
            report['applied'] = True
            print(json.dumps(report, indent=2))
    except Exception:
        connection.rollback()
        raise
    finally:
        with connection.cursor() as cursor:
            cursor.execute("SELECT RELEASE_LOCK('rof2_spells_install')")
        connection.close()


if __name__ == '__main__':
    main()
