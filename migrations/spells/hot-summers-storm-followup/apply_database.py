#!/usr/bin/env python3
"""Restore one period-confirmed Rotharran rank I scroll; offline by default."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path


def digest(v):
    return hashlib.sha256(json.dumps(v,sort_keys=True,default=str).encode()).hexdigest()


def require(ok,msg):
    if not ok:
        raise RuntimeError(msg)


def save(path,value):
    with os.fdopen(os.open(path,os.O_CREAT|os.O_EXCL|os.O_WRONLY,0o600),'w') as f:
        json.dump(value,f,indent=2,default=str);f.write('\n');f.flush();os.fsync(f.fileno())
    fd=os.open(path.parent,os.O_DIRECTORY|os.O_RDONLY)
    try:os.fsync(fd)
    finally:os.close(fd)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--apply',action='store_true');p.add_argument('--config',type=Path)
    p.add_argument('--receipt-dir',type=Path);p.add_argument('--host',default='127.0.0.1')
    p.add_argument('--port',type=int,default=3306);args=p.parse_args()
    d=json.loads(Path(__file__).with_name('data.json').read_text());row=d['insert']
    require(row['merchantid']==700070 and row['slot']==356 and row['item']==125184,'Wrong insert identity')
    require(row['alt_currency_cost']==30 and row['faction_required']==0 and row['content_flags'] is None,'Default cost/gate changed')
    require(d['item'][0]['scrolleffect']==25495 and d['spell'][0]['classes4']==89 and d['spell'][0]['rank']==1,'Wrong native spell')
    if not args.apply:
        print(json.dumps({'mode':'offline_plan','database_connected':False,'inserts':1,'item':125184,'spell':25495,'class':'RNG89','cost_and_standing':'configurable30Motes/Indifferent'}));return
    require(args.config and args.receipt_dir,'Private config and new receipt directory required')
    args.receipt_dir.mkdir(mode=0o700,parents=True,exist_ok=False)
    cfg=json.loads(args.config.read_text())['server']['database'];require(cfg['db']=='peq_housing_test','Wrong database')
    import pymysql
    c=pymysql.connect(host=args.host,port=args.port,user=cfg['username'],password=cfg['password'],database=cfg['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    receipt={'time_utc':datetime.now(timezone.utc).isoformat(),'target':cfg['db'],'payload_sha256':digest(d),'before':d,'insert':row}
    try:
        with c.cursor() as q:
            q.execute('SELECT DATABASE() AS target');require(q.fetchone()['target']=='peq_housing_test','Wrong actual target')
            q.execute("SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='merchantlist'");require(q.fetchone()['ENGINE']=='InnoDB','Nontransactional merchant table')
            reads={'npc':'SELECT * FROM npc_types WHERE id=700070','merchant_before':'SELECT * FROM merchantlist WHERE merchantid=700070 ORDER BY slot','item':'SELECT * FROM items WHERE id=125184','spell':'SELECT * FROM spells_new WHERE id=25495','currency':'SELECT * FROM alternate_currency WHERE id=22 OR item_id=52149','merchant_consumers':'SELECT id,merchant_id,class,alt_currency_id,npc_faction_id FROM npc_types WHERE merchant_id=700070 ORDER BY id'}
            for k,s in reads.items():
                q.execute(s+' FOR UPDATE');require(digest(list(q.fetchall()))==digest(d[k]),'Preimage changed: '+k)
            q.execute('SELECT * FROM merchantlist WHERE merchantid=700070 AND (slot=356 OR item=125184) FOR UPDATE');require(not q.fetchall(),'Target already exists')
            save(args.receipt_dir/'prepared.json',receipt)
            keys=list(row);q.execute('INSERT INTO merchantlist ('+','.join('`'+k+'`' for k in keys)+') VALUES ('+','.join(['%s']*len(keys))+')',tuple(row[k] for k in keys));require(q.rowcount==1,'Insert count mismatch')
            q.execute('SELECT * FROM merchantlist WHERE merchantid=700070 ORDER BY slot');require(digest(list(q.fetchall()))==digest(d['merchant_before']+[row]),'Full merchant postimage mismatch')
        c.commit();receipt['status']='COMMITTED_ONE_ORIGINAL_SUMMERS_STORM_STOCK_ROW';save(args.receipt_dir/'completed.json',receipt);print(receipt['status'])
    except BaseException:
        c.rollback()
        # Prepared-only can mean commit followed by receipt I/O failure.
        # Reconcile exact postimages before further action; never retry blindly.
        raise
    finally:c.close()


if __name__=='__main__':main()
