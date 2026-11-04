#!/usr/bin/env python3
"""Original Expedition first-completion component; default offline plan only."""
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
    d=json.loads(Path(__file__).with_name('data.json').read_text());rows=d['inserts']
    require({k:len(v) for k,v in rows.items()}=={'tasks':1,'task_activities':4,'rewards':1,'reward_options':1,'reward_option_entries':1,'reward_sets':1,'reward_sources':1},'Unexpected row scope')
    t=rows['tasks'][0];reward=rows['rewards'][0]
    require(t['id']==920131 and t['repeatable']==0 and t['min_level']==80,'Wrong task/component eligibility')
    require(t['reward_method']==3 and t['reward_points']==0 and t['reward_id_list']=='','Duplicate/incorrect payout route')
    require(reward['reward_id']==3839201311 and reward['reward_type']==4 and reward['reward_data_id']==22 and reward['amount']==5,'Wrong native Mote reward')
    require(rows['reward_sets']==[{'reward_set_id':920131,'title':'An Expedition Gone Awry','enabled':1}] and rows['reward_sources']==[{'source_type':2,'source_id':920131,'reward_set_id':920131,'enabled':1}],'Missing native set/source bindings')
    require(rows['reward_options'][0]['common_to_all']==1 and rows['reward_options'][0]['reward_set_id']==920131,'Not a fixed common reward')
    require(rows['reward_option_entries'][0]=={'reward_set_id':920131,'option_id':1,'sequence':1,'reward_id':3839201311},'Reward link changed')
    if not args.apply:
        print(json.dumps({'mode':'offline_plan','database_connected':False,'task_id':920131,
            'database_inserts':10,'native_Dream_Motes':5,'repeat_enabled':False,'new_global_or_CPP_event':False}))
        return
    require(args.config and args.quest_root and args.receipt_dir,'--apply requires private config, quest-root and new receipt-dir')
    helper=args.quest_root/'lua_modules/achievement_native_delivery_handin.lua'
    require(helper.is_file() and hashlib.sha256(helper.read_bytes()).hexdigest()==d['required_delivery_helper_sha256'],'Reviewed delivery helper changed')
    for name in d['required_absent_runtime_paths']:
        f=args.quest_root/name
        require(not f.exists() and not f.is_symlink(),'Existing callback/module would conflict: '+name)
    args.receipt_dir.mkdir(mode=0o700,parents=True,exist_ok=False)
    cfg=json.loads(args.config.read_text())['server']['database']
    require(cfg['db']=='peq_housing_test','Wrong database')
    import pymysql
    c=pymysql.connect(host=args.host,port=args.port,user=cfg['username'],password=cfg['password'],
        database=cfg['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    receipt={'target':cfg['db'],'time_utc':datetime.now(timezone.utc).isoformat(),'payload_sha256':digest(d),
        'before':{k:[] for k in rows},'after':rows}
    try:
        with c.cursor() as cur:
            cur.execute('SELECT DATABASE() AS target')
            require(cur.fetchone()['target']=='peq_housing_test','Wrong live target')
            cur.execute("SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tasks','task_activities','rewards','reward_options','reward_option_entries','reward_sets','reward_sources')")
            engines=cur.fetchall()
            require(len(engines)==7 and all(r['ENGINE']=='InnoDB' for r in engines),'Nontransactional mutation tables')
            checks=[('SELECT * FROM reward_sets WHERE reward_set_id=920131 FOR UPDATE',()),
                ('SELECT * FROM reward_sources WHERE (source_type=2 AND source_id=920131) OR reward_set_id=920131 FOR UPDATE',()),
                ('SELECT * FROM reward_source_entries WHERE (source_type=2 AND source_id=920131) OR reward_id=3839201311 FOR UPDATE',()),
                ('SELECT * FROM tasks WHERE id=920131 OR title=%s FOR UPDATE',('An Expedition Gone Awry',)),
                ('SELECT * FROM task_activities WHERE taskid=920131 FOR UPDATE',()),
                ('SELECT * FROM rewards WHERE reward_id=3839201311 FOR UPDATE',()),
                ('SELECT * FROM reward_options WHERE reward_set_id=920131 FOR UPDATE',()),
                ('SELECT * FROM reward_option_entries WHERE reward_set_id=920131 OR reward_id=3839201311 FOR UPDATE',()),
                ('SELECT id FROM tasks WHERE replay_timer_group=920131 OR request_timer_group=920131 FOR UPDATE',())]
            for sql,params in checks:
                cur.execute(sql,params);require(not cur.fetchall(),'Task/reward/timer namespace already used')
            cur.execute("SELECT ruleset_id,rule_name,rule_value FROM rule_values WHERE rule_name='TaskSystem:RecordCompletedTasks' ORDER BY ruleset_id LOCK IN SHARE MODE")
            require(list(cur.fetchall())==d['required_task_completion_rules'],'Native completed-task recording changed')
            cur.execute('SELECT id,name,class,level,race,loottable_id FROM npc_types WHERE id IN (700047,700056,700062,700075,700141,700142) ORDER BY id LOCK IN SHARE MODE')
            require(list(cur.fetchall())==d['required_actors'],'Original actor identities changed')
            cur.execute('SELECT id,Name,itemtype FROM items WHERE id IN (49186,52149) ORDER BY id LOCK IN SHARE MODE')
            require(list(cur.fetchall())==d['required_items'],'Journal/currency item identity changed')
            cur.execute('SELECT * FROM alternate_currency WHERE id=22 OR item_id=52149 LOCK IN SHARE MODE')
            require(list(cur.fetchall())==[d['required_currency']],'Native currency mapping changed')
            cur.execute('SELECT * FROM faction_list WHERE id=680 LOCK IN SHARE MODE')
            require(cur.fetchone()==d['required_faction'],'Faction base changed')
            cur.execute('SELECT * FROM faction_list_mod WHERE faction_id=680 ORDER BY id LOCK IN SHARE MODE')
            require(list(cur.fetchall())==d['required_faction_mods'],'Faction modifiers changed')
            cur.execute('SELECT zoneidnumber,short_name,min_status FROM zone WHERE zoneidnumber=700 LOCK IN SHARE MODE')
            require(cur.fetchone()==d['preserved_zone'],'Zone access changed')
            cur.execute('SELECT s.id,e.npcID,s.zone,s.version,s.x,s.y,s.z,s.heading FROM spawnentry e JOIN spawn2 s USING(spawngroupID) WHERE e.npcID=700141 ORDER BY s.id LOCK IN SHARE MODE')
            require(digest(list(cur.fetchall()))==digest(d['preserved_corpse_spawns']),'Corpse exploration footprint changed')
            cur.execute('SELECT d.* FROM lootdrop_entries d JOIN loottable_entries t USING(lootdrop_id) WHERE t.loottable_id=95436 AND d.item_id=49186 ORDER BY d.lootdrop_id LOCK IN SHARE MODE')
            require(digest(list(cur.fetchall()))==digest(d['required_journal_loot_entries']),'Existing journal loot changed')
            save(args.receipt_dir/'prepared.json',receipt)
            for table,entries in rows.items():
                for row in entries:
                    keys=list(row)
                    cur.execute('INSERT INTO `'+table+'` ('+','.join('`'+k+'`' for k in keys)+') VALUES ('+','.join(['%s']*len(keys))+')',tuple(row[k] for k in keys))
                    require(cur.rowcount==1,'Unexpected insert count')
            reads={'reward_sets':'SELECT * FROM reward_sets WHERE reward_set_id=920131',
                'reward_sources':'SELECT * FROM reward_sources WHERE source_type=2 AND source_id=920131',
                'tasks':'SELECT * FROM tasks WHERE id=920131',
                'task_activities':'SELECT * FROM task_activities WHERE taskid=920131 ORDER BY activityid',
                'rewards':'SELECT * FROM rewards WHERE reward_id=3839201311',
                'reward_options':'SELECT * FROM reward_options WHERE reward_set_id=920131 ORDER BY option_id',
                'reward_option_entries':'SELECT * FROM reward_option_entries WHERE reward_set_id=920131 ORDER BY option_id,sequence'}
            for table,sql in reads.items():
                cur.execute(sql);require(digest(list(cur.fetchall()))==digest(rows[table]),'Postimage mismatch: '+table)
        c.commit();receipt['status']='COMMITTED_ORIGINAL_EXPEDITION_FIRST_COMPLETION_COMPONENT'
        save(args.receipt_dir/'completed.json',receipt);print(receipt['status'])
    except BaseException:
        c.rollback()
        # A prepared-only receipt can be a commit followed by receipt I/O
        # failure: inspect exact postimages before further action, never retry.
        raise
    finally:
        c.close()


if __name__=='__main__':
    main()
