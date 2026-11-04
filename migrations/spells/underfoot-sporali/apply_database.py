#!/usr/bin/env python3
"""Sporali joint content installer. Default is an offline plan; runtime owners install quests."""
import argparse
import hashlib
import json
import math
import os
import re
from datetime import date, datetime, timezone
from decimal import Decimal
from pathlib import Path

ROOT = Path(__file__).resolve().parent
ROUTINES = {
    'npc-component': ('source_sporali_conditional_apply', 'sporali_joint_source_authorized',
                      '38502ca0a41c1ecfab551d82b67fc9b8e350aae7841bc357365d463152aaf26e'),
    'agent-component': ('source_desperate_deed_agent_apply', 'desperate_deed_agent_source_authorized',
                        'ca6a134974c95c58e8e4fe76d7193462ae094c42649e9379cfe08a7623a11cbb'),
}
DELIVERY = '85eeb3d426a98e70dd923e9e2bf87ff344c0bf24ecc54ab6d6edc84e924f71a9'
KEYS = {
    'npc_types':['id'], 'spawngroup':['id'], 'spawnentry':['spawngroupID','npcID'],
    'spawn2':['id'], 'loottable':['id'], 'loottable_entries':['loottable_id','lootdrop_id'],
    'lootdrop':['id'], 'lootdrop_entries':['lootdrop_id','item_id'],
    'spawn_conditions':['zone','id'], 'dynamic_zone_templates':['id'], 'tasks':['id'],
    'task_activities':['taskid','activityid'], 'rewards':['reward_id'],
    'reward_sets':['reward_set_id'], 'reward_sources':['source_type','source_id'],
    'reward_options':['reward_set_id','option_id'],
    'reward_option_entries':['reward_set_id','option_id','sequence'],
}

def require(ok, message):
    if not ok:
        raise RuntimeError(message)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def equal(a, b):
    # Receipts use json.dump(default=str); preserve timestamp values while
    # comparing the driver's date/datetime objects to that exact representation.
    if isinstance(a, (datetime, date)):
        a = str(a)
    if isinstance(b, (datetime, date)):
        b = str(b)
    if isinstance(a, dict) and isinstance(b, dict):
        return a.keys() == b.keys() and all(equal(a[k], b[k]) for k in a)
    if isinstance(a, list) and isinstance(b, list):
        return len(a) == len(b) and all(equal(x,y) for x,y in zip(a,b))
    if isinstance(a, (int,float,Decimal)) and isinstance(b, (int,float,Decimal)):
        # Native FLOAT coordinates round on insertion. Same tolerance as pinned NPC SQL.
        if isinstance(a,float) or isinstance(b,float):
            return math.isclose(float(a),float(b),rel_tol=0,abs_tol=0.0002)
        return Decimal(str(a)) == Decimal(str(b))
    return a == b

def save(path, value):
    with os.fdopen(os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600),'w') as f:
        json.dump(value,f,indent=2,default=str); f.write('\n'); f.flush(); os.fsync(f.fileno())
    fd=os.open(path.parent,os.O_RDONLY|os.O_DIRECTORY)
    try: os.fsync(fd)
    finally: os.close(fd)

def where(table, row):
    keys=KEYS[table]
    return ' AND '.join('`'+k+'`=%s' for k in keys), tuple(row[k] for k in keys)

def postimages(cur, data, lock=False):
    out={}
    for table, rows in data.items():
        out[table]=[]
        require(table in KEYS, 'Unknown postimage table')
        cur.execute('SHOW COLUMNS FROM `'+table+'`')
        columns=list(cur.fetchall())
        projection=[]
        for column in columns:
            name=column['Field']
            require(re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*',name), 'Unsafe column identifier')
            quoted='`'+name+'`'
            # Native FLOAT text-protocol output can lose significant digits.
            # Widen only the read projection, retaining the stored value,
            # every field and the existing comparison tolerance unchanged.
            if column['Type'].lower().split('(',1)[0].split()[0]=='float':
                projection.append('CAST('+quoted+' AS DOUBLE) AS '+quoted)
            else:
                projection.append(quoted)
        for row in rows:
            clause,args=where(table,row)
            cur.execute('SELECT '+','.join(projection)+' FROM `'+table+'` WHERE '+clause+
                        (' FOR UPDATE' if lock else ''),args)
            found=list(cur.fetchall())
            require(len(found)==1 and equal(found[0],row),'Full postimage mismatch: '+table)
            out[table].append(found[0])
    return out

def references(cur, refs, lock=False):
    for name, guard in refs.items():
        cur.execute(guard['query']+(' LOCK IN SHARE MODE' if lock else ''))
        require(equal(list(cur.fetchall()),guard['rows']),'Reference drift: '+name)

def active_data(data):
    out=json.loads(json.dumps(data))
    for rows in out.values():
        for row in rows:
            if 'enabled' in row: row['enabled']=1
    return out

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    modes=ap.add_mutually_exclusive_group()
    for mode in ['define-routines','apply','activate','verify']:
        modes.add_argument('--'+mode,action='store_true')
    ap.add_argument('--active',action='store_true',help='Verify enabled postimages; never mutates by itself')
    ap.add_argument('--config',type=Path);ap.add_argument('--quest-root',type=Path)
    ap.add_argument('--receipt-dir',type=Path);ap.add_argument('--expected-bundle-sha256')
    ap.add_argument('--host',default='127.0.0.1');ap.add_argument('--port',type=int,default=3306)
    args=ap.parse_args()
    data=json.loads((ROOT/'combined-data.json').read_text())['inserts']
    spells=json.loads((ROOT/'task-reward-data.draft.json').read_text())['inserts']
    require(sum(map(len,data.values()))==182 and sum(map(len,spells.values()))==82,'Wrong joint scope')
    if not (args.define_routines or args.apply or args.activate or args.verify):
        print(json.dumps({'mode':'offline_plan','rows':182,'database_connected':False}));return
    require(not args.active or args.verify,'--active is only for independent verification')
    require(args.config and args.receipt_dir,'Live mode requires config and NEW receipt directory')
    require(args.expected_bundle_sha256==sha(ROOT/'bundle-manifest.json'),'Exact published bundle required')
    bundle=json.loads((ROOT/'bundle-manifest.json').read_text())
    for name,digest in bundle['files'].items():require(sha(ROOT/name)==digest,'Bundle drift: '+name)
    for component,(_,_,digest) in ROUTINES.items():
        require(sha(ROOT/component/'apply.sql.disabled')==digest,'Wrong NPC routine revision')
    if args.apply or args.activate:
        require(args.quest_root,'Intended quest root required')
        require(sha(args.quest_root/'lua_modules/achievement_native_delivery_handin.lua')==DELIVERY,
                'Shared native delivery helper drift')
        for name in bundle['runtime_files']:
            target=args.quest_root/name
            if args.apply:
                require(not target.exists() and not target.is_symlink(),'Quest path occupied: '+name)
            else:
                candidate=ROOT/('activation/rof2_arthicrex_task_bindings.lua'
                    if name=='lua_modules/rof2_arthicrex_task_bindings.lua' else 'quests/'+name)
                require(not target.is_symlink() and target.is_file() and sha(target)==sha(candidate),
                        'Exact active quest candidate not installed: '+name)
    cfg=json.loads(args.config.read_text())['server']['database']
    require(cfg['db']=='peq_housing_test','Wrong configured database')
    args.receipt_dir.mkdir(parents=True,mode=0o700,exist_ok=False)
    import pymysql
    conn=pymysql.connect(host=args.host,port=args.port,user=cfg['username'],password=cfg['password'],
                         database=cfg['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    receipt={'utc':datetime.now(timezone.utc).isoformat(),'database':cfg['db'],
             'bundle_sha256':args.expected_bundle_sha256,'before':{},'intended_after':data,
             'runtime_cache_acceptance':False,'native_acceptance':False}
    refs=json.loads((ROOT/'reference-preimages.json').read_text())
    try:
        with conn.cursor() as cur:
            cur.execute('SELECT DATABASE() AS target')
            require(cur.fetchone()['target']=='peq_housing_test','Wrong live database')
            if args.define_routines:
                # DDL is OUTSIDE content transaction. A partial definition requires reconciliation.
                for component,(routine,_,_) in ROUTINES.items():
                    cur.execute('SELECT ROUTINE_NAME FROM information_schema.ROUTINES WHERE '
                        'ROUTINE_SCHEMA=DATABASE() AND ROUTINE_NAME=%s',(routine,))
                    require(not list(cur.fetchall()),'Routine exists; reconcile, do not replace: '+routine)
                conn.rollback()
                save(args.receipt_dir/'prepared.json',receipt)
                for component,(routine,_,_) in ROUTINES.items():
                    sql=(ROOT/component/'apply.sql.disabled').read_text()
                    body=sql.split('DELIMITER $$\n',1)[1].split('$$',1)[0].strip()
                    cur.execute(body)
                    save(args.receipt_dir/(routine+'.json'),{'routine':routine,'defined':True})
                save(args.receipt_dir/'completed.json',{'status':'ROUTINES_DEFINED_NO_CONTENT_APPLIED'})
                return
            if args.verify:
                receipt['after']=postimages(cur,active_data(data) if args.active else data)
                references(cur,refs);conn.rollback()
                receipt['status']='PASS_INDEPENDENT_182_ROW_READBACK_NOT_CACHE_OR_NATIVE_ACCEPTANCE'
                save(args.receipt_dir/'readback.json',receipt);print(receipt['status']);return
            conn.begin()
            for table, rows in data.items():
                cur.execute('SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() '
                            'AND TABLE_NAME=%s',(table,))
                require(cur.fetchone()=={'ENGINE':'InnoDB'},'Nontransactional table: '+table)
                cur.execute('SHOW COLUMNS FROM `'+table+'`')
                require({r['Field'] for r in list(cur.fetchall())}==set(rows[0]),'Schema drift: '+table)
            references(cur,refs,lock=True)
            if args.activate:
                receipt['before']=postimages(cur,data,lock=True)
                enabled=active_data(data);receipt['intended_after']=enabled
                save(args.receipt_dir/'prepared.json',receipt)
                for table,rows in data.items():
                    for row in rows:
                        if 'enabled' not in row:continue
                        clause,values=where(table,row)
                        cur.execute('UPDATE `'+table+'` SET enabled=1 WHERE '+clause+' AND enabled=0',values)
                        require(cur.rowcount==1,'Activation compare-and-set failed: '+table)
                receipt['after']=postimages(cur,enabled)
            else:
                for name,query in json.loads((ROOT/'namespace-guards.json').read_text())['empty'].items():
                    cur.execute(query+' FOR UPDATE');found=list(cur.fetchall())
                    require(not found,'Namespace/consumer collision: '+name);receipt['before'][name]=found
                for component,(routine,_,_) in ROUTINES.items():
                    cur.execute('SHOW CREATE PROCEDURE '+routine)
                    installed=cur.fetchone()['Create Procedure']
                    source=(ROOT/component/'apply.sql.disabled').read_text().split('CREATE PROCEDURE ',1)[1].split('$$',1)[0]
                    require(installed[installed.index('BEGIN'):].strip()==source[source.index('BEGIN'):].strip(),
                            'Live routine body differs from source: '+routine)
                receipt['preserved_references']=refs;save(args.receipt_dir/'prepared.json',receipt)
                for _,(routine,flag,_) in ROUTINES.items():
                    cur.execute('SET @'+flag+'=1');cur.callproc(routine)
                    while cur.nextset():pass
                for table,rows in spells.items():
                    for row in rows:
                        cols=list(row)
                        cur.execute('INSERT INTO `'+table+'` ('+','.join('`'+k+'`' for k in cols)+
                                    ') VALUES ('+','.join(['%s']*len(cols))+')',tuple(row[k] for k in cols))
                        require(cur.rowcount==1,'Unexpected insert count: '+table)
                receipt['after']=postimages(cur,data)
            references(cur,refs)
        conn.commit()
        receipt['status']='COMMITTED_ACTIVATION_CACHE_PENDING' if args.activate else 'COMMITTED_182_ROWS_DISABLED'
        save(args.receipt_dir/'completed.json',receipt);print(receipt['status'])
    except BaseException:
        conn.rollback()
        # Prepared-only/uncertain commit means STOP. No automatic retry or player-state cleanup.
        raise
    finally:conn.close()

if __name__=='__main__':main()
