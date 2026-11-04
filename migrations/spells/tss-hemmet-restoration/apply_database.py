#!/usr/bin/env python3
"""Restore Hemmet's original fifteen stock items; default offline plan only."""
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
    rows = data['merchant_inserts']
    require(len(rows)==15 and all(r['merchantid']==399084 for r in rows), 'Unexpected stock scope')
    require([r['slot'] for r in rows]==list(range(1,16)), 'Unexpected slots')
    require([r['item'] for r in rows]==[r['id'] for r in data['required_items']], 'Unexpected item identity')
    require(data['npc_before']['id']==399084 and data['npc_before']['merchant_id']==999999, 'Unexpected NPC binding')
    if not args.apply:
        print(json.dumps({'mode':'offline_plan','database_connected':False,'merchant_id':399084,
                          'stock_inserts':15,'npc_binding_updates':1,'shared_999999_writes':False}))
        return
    require(args.config and args.receipt_dir, '--apply requires private --config and new --receipt-dir')
    args.receipt_dir.mkdir(mode=0o700,parents=True,exist_ok=False)
    config = json.loads(args.config.read_text())['server']['database']
    require(config['db']=='peq_housing_test','Wrong target database')
    import pymysql
    c=pymysql.connect(host=args.host,port=args.port,user=config['username'],password=config['password'],
        database=config['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    receipt={'target':config['db'],'time_utc':datetime.now(timezone.utc).isoformat(),
             'payload_sha256':digest(data),'stock_after':rows,'stock_before':[]}
    try:
        with c.cursor() as cur:
            cur.execute('SELECT DATABASE() AS target')
            require(cur.fetchone()['target']=='peq_housing_test','Wrong live target')
            cur.execute("SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('npc_types','merchantlist')")
            engines=cur.fetchall()
            require(len(engines)==2 and all(r['ENGINE']=='InnoDB' for r in engines),'Nontransactional tables')
            cur.execute('SELECT * FROM npc_types WHERE id=399084 FOR UPDATE')
            npc=cur.fetchone()
            require(digest(npc)==data['npc_before_sha256'],'NPC changed')
            cur.execute('SELECT id FROM npc_types WHERE merchant_id=399084 LIMIT 1 FOR UPDATE')
            require(not cur.fetchone(),'Reserved merchant already has consumer')
            cur.execute('SELECT * FROM merchantlist WHERE merchantid=399084 FOR UPDATE')
            require(not cur.fetchall(),'Reserved stock already exists')
            for item,spell in zip(data['required_items'],data['required_spells']):
                cur.execute('SELECT id,Name,scrolleffect,classes,scrolllevel,scrolllevel2,price FROM items WHERE id=%s LOCK IN SHARE MODE',(item['id'],))
                require(cur.fetchone()==item and item['price']>0,'Item identity/price changed')
                cur.execute('SELECT id,name,`rank`,classes4 FROM spells_new WHERE id=%s LOCK IN SHARE MODE',(spell['id'],))
                require(cur.fetchone()==spell,'Ranger spell identity/level changed')
            receipt['npc_before']=npc
            receipt['npc_after']=dict(npc,merchant_id=399084)
            save(args.receipt_dir/'prepared.json',receipt)
            for row in rows:
                cols=list(row)
                cur.execute('INSERT INTO merchantlist ('+','.join('`'+k+'`' for k in cols)+') VALUES ('+','.join(['%s']*len(cols))+')',tuple(row[k] for k in cols))
                require(cur.rowcount==1,'Unexpected stock insert count')
            cur.execute('UPDATE npc_types SET merchant_id=399084 WHERE id=399084 AND merchant_id=999999')
            require(cur.rowcount==1,'Unexpected NPC update count')
            cur.execute('SELECT * FROM npc_types WHERE id=399084')
            require(digest(cur.fetchone())==digest(receipt['npc_after']),'NPC postimage mismatch')
            cur.execute('SELECT * FROM merchantlist WHERE merchantid=399084 ORDER BY slot')
            require(digest(list(cur.fetchall()))==digest(rows),'Stock postimage mismatch')
        c.commit()
        receipt['status']='COMMITTED_ORIGINAL_HEMMET_FIFTEEN_STOCK_AND_BINDING'
        save(args.receipt_dir/'completed.json',receipt)
        print(receipt['status'])
    except BaseException:
        c.rollback()
        # If completed receipt creation fails after commit, inspect exact rows;
        # never replay a prepared-only attempt blindly.
        raise
    finally:
        c.close()


if __name__=='__main__':
    main()
