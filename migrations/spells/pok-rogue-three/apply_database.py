#!/usr/bin/env python3
"""Propose three qualified PoK Rogue tomes on existing Blane; source only by default; offline by default."""
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
    action=p.add_mutually_exclusive_group();action.add_argument('--apply',action='store_true');action.add_argument('--readback',action='store_true')
    p.add_argument('--config',type=Path);p.add_argument('--receipt-dir',type=Path)
    p.add_argument('--host',default='127.0.0.1');p.add_argument('--port',type=int,default=3306);args=p.parse_args()
    d=json.loads(Path(__file__).with_name('data.json').read_text());rows=d['inserts']
    require([(r['merchantid'],r['slot'],r['item']) for r in rows]==[(202156,29,119621),(202156,30,119624),(202156,31,119715)],'Wrong stock identities')
    require(all(r['faction_required']==-1100 and r['alt_currency_cost']==0 and r['min_expansion']==18 and r['language_required']==-1 and r['language_skill_required']==0 for r in rows),'Era/cost/qualified language policy changed')
    require(len(d['merchant_before'])==28 and max(r['slot'] for r in d['merchant_before'])==28,'Baseline stock count/last slot changed')
    require(d['npc'][0]['class']==41 and d['npc'][0]['alt_currency_id']==0 and all(i['price']>0 for i in d['items']),'Wrong native platinum merchant contract')
    require([(i['id'],i['scrolleffect']) for i in d['items']]==[(119621,19871),(119624,19874),(119715,22540)],'Wrong native item/spell mapping')
    require([r['classes9'] for r in d['spells']]==[83,85,85] and all(s['rank']==1 for s in d['spells']),'Wrong native class/level/rank')
    if not (args.apply or args.readback):
        print(json.dumps({'mode':'offline_plan','database_connected':False,'inserts':3,'before_stock_rows':28,'after_stock_rows':31,'new_slots':[29,30,31],'min_expansion':18,'membership_qualification':'periodrole_lineage_plus_currentnamedstock_inference'}));return
    require(args.config and args.receipt_dir,'Private config and fresh receipt directory required')
    args.receipt_dir.mkdir(mode=0o700,parents=True,exist_ok=False)
    cfg=json.loads(args.config.read_text())['server']['database'];require(cfg['db']=='peq_housing_test','Wrong database')
    import pymysql
    c=pymysql.connect(host=args.host,port=args.port,user=cfg['username'],password=cfg['password'],database=cfg['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    receipt={'time_utc':datetime.now(timezone.utc).isoformat(),'target':cfg['db'],'payload_sha256':digest(d),'before':d,'inserts':rows}
    try:
        with c.cursor() as q:
            q.execute('SELECT DATABASE() AS target');require(q.fetchone()['target']=='peq_housing_test','Wrong actual target')
            q.execute("SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='merchantlist'");require(q.fetchone()['ENGINE']=='InnoDB','Nontransactional merchant table')
            reads={'npc':'SELECT * FROM npc_types WHERE id=202156','merchant_before':'SELECT * FROM merchantlist WHERE merchantid=202156 ORDER BY slot','items':'SELECT * FROM items WHERE id IN (119621,119624,119715) ORDER BY id','spells':'SELECT * FROM spells_new WHERE id IN (19871,19874,22540) ORDER BY id','merchant_consumers':'SELECT id,merchant_id,class,alt_currency_id,npc_faction_id FROM npc_types WHERE merchant_id=202156 ORDER BY id'}
            for key,sql in reads.items():
                q.execute(sql+' FOR UPDATE');expected=d[key]+rows if args.readback and key=='merchant_before' else d[key]
                require(digest(list(q.fetchall()))==digest(expected),'Full preimage/postimage changed: '+key)
            if args.readback:
                c.rollback();receipt['status']='INDEPENDENT_FULL_POSTIMAGE_READBACK_PASS';save(args.receipt_dir/'readback.json',receipt);print(receipt['status']);return
            q.execute('SELECT * FROM merchantlist WHERE merchantid=202156 AND (slot IN (29,30,31) OR item IN (119621,119624,119715)) FOR UPDATE');require(not q.fetchall(),'Target slot/item already exists')
            save(args.receipt_dir/'prepared.json',receipt)
            for row in rows:
                keys=list(row);q.execute('INSERT INTO merchantlist ('+','.join('`'+k+'`' for k in keys)+') VALUES ('+','.join(['%s']*len(keys))+')',[row[k] for k in keys]);require(q.rowcount==1,'Insert count mismatch')
            q.execute('SELECT * FROM merchantlist WHERE merchantid=202156 ORDER BY slot');require(digest(list(q.fetchall()))==digest(d['merchant_before']+rows),'Full31stock postimage mismatch')
        c.commit();receipt['status']='COMMITTED_THREE_QUALIFIED_POK_ROGUE_STOCK_ROWS';save(args.receipt_dir/'completed.json',receipt);print(receipt['status'])
    except BaseException:
        c.rollback()
        # Prepared-only may mean successful commit followed by receipt I/O failure.
        # Reconcile exact full postimages before any new mutation; never retry blindly.
        raise
    finally:c.close()


if __name__=='__main__':main()
