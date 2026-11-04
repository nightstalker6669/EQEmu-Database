#!/usr/bin/env python3
"""Manual Cragbeak DB repair; default offline plan, no database connection."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, default=str).encode()).hexdigest()


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def save(path, value):
    with os.fdopen(os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600), 'w') as f:
        json.dump(value, f, indent=2, default=str)
        f.write('\n')
        f.flush()
        os.fsync(f.fileno())
    fd = os.open(path.parent, os.O_RDONLY | os.O_DIRECTORY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--apply', action='store_true')
    p.add_argument('--config', type=Path)
    p.add_argument('--receipt-dir', type=Path)
    p.add_argument('--host', default='127.0.0.1')
    p.add_argument('--port', type=int, default=3306)
    args = p.parse_args()
    data = json.loads(Path(__file__).with_name('data.json').read_text())
    tables = {'loottable': ('id', 30396003), 'lootdrop': ('id', 30397002),
              'loottable_entries': ('loottable_id', 30396003),
              'lootdrop_entries': ('lootdrop_id', 30397002)}
    require(set(data['inserts']) == set(tables), 'Unexpected table scope')
    require(data['npc_before']['id'] == 752234 and data['npc_before']['name'] == '#Cragbeak', 'Wrong NPC')
    require(set(data['npc_patch']) == {'hp', 'mindmg', 'maxdmg', 'loottable_id'}, 'Unexpected NPC fields')
    require(data['npc_patch']['loottable_id'] == 30396003, 'Wrong reserved loot binding')
    require([r['item_id'] for r in data['inserts']['lootdrop_entries']] == [76550,76551,76552,76553], 'Unknown mote identity')
    if not args.apply:
        print(json.dumps({'mode':'offline_plan', 'database_connected':False,
                          'npc_id':752234, 'loot_rows':sum(map(len,data['inserts'].values())),
                          'contains_configurable_estimates':True}))
        return
    require(args.config and args.receipt_dir, '--apply requires private --config and new --receipt-dir')
    args.receipt_dir.mkdir(mode=0o700, parents=True, exist_ok=False)
    config = json.loads(args.config.read_text())['server']['database']
    require(config['db'] == 'peq_housing_test', 'Wrong database')
    import pymysql
    c = pymysql.connect(host=args.host, port=args.port, user=config['username'],
        password=config['password'], database=config['db'], autocommit=False,
        cursorclass=pymysql.cursors.DictCursor)
    receipt = {'time_utc':datetime.now(timezone.utc).isoformat(), 'target':config['db'],
               'payload_sha256':digest(data), 'before':{}, 'inserts':data['inserts']}
    try:
        with c.cursor() as cur:
            cur.execute('SELECT DATABASE() AS target')
            require(cur.fetchone()['target'] == 'peq_housing_test', 'Wrong live target')
            for table in ['npc_types', *tables]:
                cur.execute('SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=%s', (table,))
                engine = cur.fetchone()
                require(engine and engine['ENGINE'] == 'InnoDB', 'Nontransactional table: '+table)
            cur.execute('SELECT * FROM npc_types WHERE id=752234 FOR UPDATE')
            npc = cur.fetchone()
            require(digest(npc) == data['npc_before_sha256'], 'NPC changed')
            cur.execute('SELECT * FROM spells_new WHERE id=33544 LOCK IN SHARE MODE')
            require(digest(cur.fetchone()) == data['spell_before_sha256'], 'Native spell changed')
            cur.execute('SELECT id,Name FROM items WHERE id IN (76550,76551,76552,76553) ORDER BY id LOCK IN SHARE MODE')
            require(list(cur.fetchall()) == data['required_items'], 'Native mote identities changed')
            # Reserve absent definitions and every possible existing consumer of
            # these IDs. A dangling reference must not acquire unintended loot.
            cur.execute('SELECT id FROM npc_types WHERE loottable_id=30396003 LIMIT 1 FOR UPDATE')
            require(not cur.fetchone(), 'Reserved table already has NPC consumer')
            cur.execute('SELECT id FROM global_loot WHERE loottable_id=30396003 LIMIT 1 FOR UPDATE')
            require(not cur.fetchone(), 'Reserved table already has global loot consumer')
            cur.execute('SELECT loottable_id FROM loottable_entries WHERE lootdrop_id=30397002 LIMIT 1 FOR UPDATE')
            require(not cur.fetchone(), 'Reserved drop already has table consumer')
            for table, (key, ident) in tables.items():
                cur.execute('SELECT * FROM `'+table+'` WHERE `'+key+'`=%s FOR UPDATE', (ident,))
                require(not cur.fetchall(), 'Reserved ID already used in '+table)
            receipt['before']['npc_types'] = npc
            receipt['after_npc'] = dict(npc, **data['npc_patch'])
            save(args.receipt_dir/'prepared.json', receipt)
            for table, rows in data['inserts'].items():
                for row in rows:
                    columns = list(row)
                    sql = 'INSERT INTO `'+table+'` ('+','.join('`'+v+'`' for v in columns)+') VALUES ('+','.join(['%s']*len(columns))+')'
                    cur.execute(sql, tuple(row[v] for v in columns))
                    require(cur.rowcount == 1, 'Unexpected insert count')
            patch = data['npc_patch']
            cur.execute('UPDATE npc_types SET hp=%s,mindmg=%s,maxdmg=%s,loottable_id=%s WHERE id=752234',
                        tuple(patch[k] for k in ['hp','mindmg','maxdmg','loottable_id']))
            require(cur.rowcount == 1, 'Unexpected NPC update count')
            cur.execute('SELECT * FROM npc_types WHERE id=752234')
            require(digest(cur.fetchone()) == digest(receipt['after_npc']), 'NPC readback mismatch')
            for table, (key, ident) in tables.items():
                order = ' ORDER BY item_id' if table == 'lootdrop_entries' else ''
                cur.execute('SELECT * FROM `'+table+'` WHERE `'+key+'`=%s'+order, (ident,))
                require(digest(list(cur.fetchall())) == digest(data['inserts'][table]), 'Loot readback mismatch: '+table)
        c.commit()
        receipt['status'] = 'COMMITTED_CRAGBEAK_CONFIGURABLE_RECONSTRUCTION'
        save(args.receipt_dir/'completed.json', receipt)
        print(receipt['status'])
    except BaseException:
        c.rollback()
        # Prepared without completed may be ambiguous after commit/receipt I/O
        # failure. Inspect exact postimages before any further action; no retry.
        raise
    finally:
        c.close()


if __name__ == '__main__':
    main()
