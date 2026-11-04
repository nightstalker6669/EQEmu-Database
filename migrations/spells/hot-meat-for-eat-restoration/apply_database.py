#!/usr/bin/env python3
"""Original Meat for Eat task component; default offline plan only."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path


def digest(value):
    return hashlib.sha256(json.dumps(value,sort_keys=True,default=str).encode()).hexdigest()


def require(condition,message):
    if not condition:
        raise RuntimeError(message)


def save(path,value):
    with os.fdopen(os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600),'w') as f:
        json.dump(value,f,indent=2,default=str);f.write('\n');f.flush();os.fsync(f.fileno())
    fd=os.open(path.parent,os.O_RDONLY|os.O_DIRECTORY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--apply',action='store_true')
    p.add_argument('--config',type=Path)
    p.add_argument('--quest-root',type=Path)
    p.add_argument('--receipt-dir',type=Path)
    p.add_argument('--host',default='127.0.0.1')
    p.add_argument('--port',type=int,default=3306)
    args=p.parse_args()
    d=json.loads(Path(__file__).with_name('data.json').read_text())
    require(d['task']['id']==920130 and d['task']['title']=='Meat for Eat','Wrong task')
    require(d['task']['reward_points']==0 and d['task']['reward_id_list']=='','Unexpected item/currency reward')
    require(d['task']['faction_reward']==680 and d['task']['faction_amount']==5,'Wrong faction reward')
    require([a['activityid'] for a in d['activities']]==[0,1,2,3] and all(a['taskid']==920130 for a in d['activities']),'Wrong activity scope')
    if not args.apply:
        print(json.dumps({'mode':'offline_plan','database_connected':False,'task_id':920130,
            'activity_count':4,'DreamMote_reward':False,'existing_delivery_helper_reused':True}))
        return
    require(args.config and args.quest_root and args.receipt_dir,'--apply requires private config, quest-root and new receipt-dir')
    helper=args.quest_root/'lua_modules/achievement_native_delivery_handin.lua'
    require(helper.is_file() and hashlib.sha256(helper.read_bytes()).hexdigest()==d['required_delivery_helper_sha256'],'Reviewed delivery helper changed/missing')
    args.receipt_dir.mkdir(mode=0o700,parents=True,exist_ok=False)
    cfg=json.loads(args.config.read_text())['server']['database']
    require(cfg['db']=='peq_housing_test','Wrong database')
    import pymysql
    c=pymysql.connect(host=args.host,port=args.port,user=cfg['username'],password=cfg['password'],
        database=cfg['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    receipt={'target':cfg['db'],'time_utc':datetime.now(timezone.utc).isoformat(),
        'payload_sha256':digest(d),'before':{'tasks':[],'task_activities':[]},
        'after':{'tasks':[d['task']],'task_activities':d['activities']}}
    try:
        with c.cursor() as cur:
            cur.execute('SELECT DATABASE() AS target')
            require(cur.fetchone()['target']=='peq_housing_test','Wrong live target')
            cur.execute("SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tasks','task_activities')")
            engines=cur.fetchall()
            require(len(engines)==2 and all(r['ENGINE']=='InnoDB' for r in engines),'Nontransactional mutation tables')
            cur.execute('SELECT * FROM tasks WHERE id=920130 OR title=%s FOR UPDATE',('Meat for Eat',))
            require(not cur.fetchall(),'Task ID/title already exists')
            cur.execute('SELECT * FROM task_activities WHERE taskid=920130 FOR UPDATE')
            require(not cur.fetchall(),'Activity ID already used')
            cur.execute('SELECT id FROM tasks WHERE replay_timer_group=920130 OR request_timer_group=920130 FOR UPDATE')
            require(not cur.fetchall(),'Timer group already used')
            cur.execute('SELECT id,name FROM npc_types WHERE id IN (700000,700013,700016) ORDER BY id LOCK IN SHARE MODE')
            require(list(cur.fetchall())==d['required_actors'],'Original actors changed')
            cur.execute('SELECT id,Name FROM items WHERE id=17576 LOCK IN SHARE MODE')
            require(cur.fetchone()==d['required_item'],'Native meat identity changed')
            cur.execute('SELECT * FROM faction_list WHERE id=680 LOCK IN SHARE MODE')
            require(cur.fetchone()==d['required_faction'],'Faction base changed')
            cur.execute('SELECT * FROM faction_list_mod WHERE faction_id=680 ORDER BY id LOCK IN SHARE MODE')
            require(list(cur.fetchall())==d['required_faction_mods'],'Faction modifiers changed')
            cur.execute('SELECT zoneidnumber,short_name,min_status FROM zone WHERE zoneidnumber=700 LOCK IN SHARE MODE')
            require(cur.fetchone()==d['preserved_zone'],'Zone access changed')
            save(args.receipt_dir/'prepared.json',receipt)
            for table,rows in receipt['after'].items():
                for row in rows:
                    keys=list(row)
                    cur.execute('INSERT INTO `'+table+'` ('+','.join('`'+k+'`' for k in keys)+') VALUES ('+','.join(['%s']*len(keys))+')',tuple(row[k] for k in keys))
                    require(cur.rowcount==1,'Unexpected insert count')
            cur.execute('SELECT * FROM tasks WHERE id=920130')
            require(digest(cur.fetchone())==digest(d['task']),'Task postimage mismatch')
            cur.execute('SELECT * FROM task_activities WHERE taskid=920130 ORDER BY activityid')
            require(digest(list(cur.fetchall()))==digest(d['activities']),'Activities postimage mismatch')
        c.commit()
        receipt['status']='COMMITTED_ORIGINAL_MEAT_FOR_EAT_TASK_COMPONENT'
        save(args.receipt_dir/'completed.json',receipt)
        print(receipt['status'])
    except BaseException:
        c.rollback()
        # Reconcile prepared-only receipts against actual rows before further
        # action; never blindly retry after an ambiguous commit/receipt failure.
        raise
    finally:
        c.close()


if __name__=='__main__':
    main()
