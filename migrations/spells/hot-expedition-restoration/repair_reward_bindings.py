#!/usr/bin/env python3
"""Repair only missing native set/source bindings after the original eight inserts."""
import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
from apply_database import digest, require, save


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--apply',action='store_true')
    p.add_argument('--config',type=Path);p.add_argument('--receipt-dir',type=Path)
    p.add_argument('--host',default='127.0.0.1');p.add_argument('--port',type=int,default=3306);args=p.parse_args()
    d=json.loads(Path(__file__).with_name('data.json').read_text());rows=d['inserts']
    require(rows['reward_sets']==[{'reward_set_id':920131,'title':'An Expedition Gone Awry','enabled':1}],'Wrong reward set')
    require(rows['reward_sources']==[{'source_type':2,'source_id':920131,'reward_set_id':920131,'enabled':1}],'Wrong task binding')
    if not args.apply:
        print(json.dumps({'mode':'offline_plan','database_connected':False,'repair_inserts':2,'existing_rows_preserved':8}));return
    require(args.config and args.receipt_dir,'Private config/new receipt-dir required')
    args.receipt_dir.mkdir(mode=0o700,parents=True,exist_ok=False)
    cfg=json.loads(args.config.read_text())['server']['database'];require(cfg['db']=='peq_housing_test','Wrong DB')
    import pymysql
    c=pymysql.connect(host=args.host,port=args.port,user=cfg['username'],password=cfg['password'],database=cfg['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    receipt={'time_utc':datetime.now(timezone.utc).isoformat(),'target':cfg['db'],'data_sha256':digest(d),'before':{},'insert':{k:rows[k] for k in ['reward_sets','reward_sources']}}
    reads={'tasks':'SELECT * FROM tasks WHERE id=920131','task_activities':'SELECT * FROM task_activities WHERE taskid=920131 ORDER BY activityid','rewards':'SELECT * FROM rewards WHERE reward_id=3839201311','reward_options':'SELECT * FROM reward_options WHERE reward_set_id=920131 ORDER BY option_id','reward_option_entries':'SELECT * FROM reward_option_entries WHERE reward_set_id=920131 ORDER BY option_id,sequence','reward_sets':'SELECT * FROM reward_sets WHERE reward_set_id=920131','reward_sources':'SELECT * FROM reward_sources WHERE source_type=2 AND source_id=920131'}
    try:
        with c.cursor() as q:
            q.execute('SELECT DATABASE() AS target');require(q.fetchone()['target']=='peq_housing_test','Wrong live DB')
            q.execute("SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('reward_sets','reward_sources')");engines=q.fetchall();require(len(engines)==2 and all(r['ENGINE']=='InnoDB' for r in engines),'Nontransactional target')
            for table,sql in reads.items():
                q.execute(sql+' FOR UPDATE');actual=list(q.fetchall());receipt['before'][table]=actual
                require(digest(actual)==digest([] if table in ['reward_sets','reward_sources'] else rows[table]),'Preimage mismatch: '+table)
            q.execute('SELECT * FROM reward_sources WHERE reward_set_id=920131 FOR UPDATE');require(not q.fetchall(),'Unexpected other source consumer')
            q.execute('SELECT * FROM reward_source_entries WHERE (source_type=2 AND source_id=920131) OR reward_id=3839201311 FOR UPDATE');require(not q.fetchall(),'Unexpected automatic payout consumer')
            save(args.receipt_dir/'prepared.json',receipt)
            for table in ['reward_sets','reward_sources']:
                row=rows[table][0];keys=list(row)
                q.execute('INSERT INTO '+table+' ('+','.join('`'+k+'`' for k in keys)+') VALUES ('+','.join(['%s']*len(keys))+')',tuple(row[k] for k in keys));require(q.rowcount==1,'Insert count')
            receipt['after']={}
            for table,sql in reads.items():
                q.execute(sql);actual=list(q.fetchall());require(digest(actual)==digest(rows[table]),'Postimage mismatch: '+table);receipt['after'][table]=actual
        c.commit();receipt['status']='COMMITTED_TWO_MISSING_NATIVE_REWARD_BINDINGS_EXISTING_EIGHT_UNCHANGED';save(args.receipt_dir/'completed.json',receipt);print(receipt['status'])
    except BaseException:
        c.rollback()
        # Prepared-only requires reconciliation, never a blind retry.
        raise
    finally:c.close()


if __name__=='__main__':main()
