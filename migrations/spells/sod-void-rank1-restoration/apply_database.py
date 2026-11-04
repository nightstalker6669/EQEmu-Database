#!/usr/bin/env python3
"""Original Void B-G rank I stock component; default offline plan only."""
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
        json.dump(value,f,indent=2,default=str)
        f.write('\n');f.flush();os.fsync(f.fileno())
    fd=os.open(path.parent,os.O_RDONLY|os.O_DIRECTORY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--apply',action='store_true')
    p.add_argument('--config',type=Path)
    p.add_argument('--receipt-dir',type=Path)
    p.add_argument('--host',default='127.0.0.1')
    p.add_argument('--port',type=int,default=3306)
    args=p.parse_args()
    d=json.loads(Path(__file__).with_name('data.json').read_text())
    ids=[460000,461000,462000,463000,464000,465000]
    require([r['id'] for r in d['npc_before']]==ids,'Wrong NPC scope')
    require(len(d['native_identities'])==77 and len(d['merchant_inserts'])==278,'Wrong stock scope')
    require({r['merchantid'] for r in d['merchant_inserts']}==set(ids),'Wrong merchant scope')
    require(all(r['spell']['rank']==1 for r in d['native_identities']),'Non-rankI spell')
    require(d['required_currency']=={'id':15,'item_id':103000},'Wrong currency')
    if not args.apply:
        print(json.dumps({'mode':'offline_plan','database_connected':False,'stock_inserts':278,
            'npc_binding_updates':6,'ordinary_Void_access_restored':False,'VoidA_or_rankIII_changes':False}))
        return
    require(args.config and args.receipt_dir,'--apply requires private --config and new --receipt-dir')
    args.receipt_dir.mkdir(mode=0o700,parents=True,exist_ok=False)
    cfg=json.loads(args.config.read_text())['server']['database']
    require(cfg['db']=='peq_housing_test','Wrong database')
    import pymysql
    c=pymysql.connect(host=args.host,port=args.port,user=cfg['username'],password=cfg['password'],
        database=cfg['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    placeholders=','.join(['%s']*len(ids))
    receipt={'target':cfg['db'],'time_utc':datetime.now(timezone.utc).isoformat(),'payload_sha256':digest(d),
        'npc_before':d['npc_before'],'merchant_before':[],'merchant_after':d['merchant_inserts'],
        'npc_after':[dict(r,merchant_id=r['id'],alt_currency_id=15) for r in d['npc_before']]}
    try:
        with c.cursor() as cur:
            cur.execute('SELECT DATABASE() AS target')
            require(cur.fetchone()['target']=='peq_housing_test','Wrong live target')
            cur.execute("SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('npc_types','merchantlist')")
            engines=cur.fetchall()
            require(len(engines)==2 and all(r['ENGINE']=='InnoDB' for r in engines),'Nontransactional mutation tables')
            cur.execute('SELECT * FROM npc_types WHERE id IN ('+placeholders+') ORDER BY id FOR UPDATE',tuple(ids))
            require(digest(list(cur.fetchall()))==d['npc_before_sha256'],'Original NPCs changed')
            cur.execute('SELECT id FROM npc_types WHERE merchant_id IN ('+placeholders+') FOR UPDATE',tuple(ids))
            require(not cur.fetchall(),'Reserved merchant already has consumer')
            cur.execute('SELECT * FROM merchantlist WHERE merchantid IN ('+placeholders+') FOR UPDATE',tuple(ids))
            require(not cur.fetchall(),'Reserved stock already exists')
            cur.execute('SELECT * FROM npc_types WHERE id=459000 LOCK IN SHARE MODE')
            require(digest(cur.fetchone())==digest(d['preserved_voidA']),'VoidA preimage changed')
            cur.execute('SELECT zoneidnumber,short_name,min_status FROM zone WHERE zoneidnumber BETWEEN 459 AND 465 ORDER BY zoneidnumber LOCK IN SHARE MODE')
            require(list(cur.fetchall())==d['preserved_zones'],'Zone access preimages changed')
            cur.execute('SELECT e.npcID,s.zone,s.version,s.spawngroupID FROM spawnentry e JOIN spawn2 s USING(spawngroupID) WHERE e.npcID IN ('+placeholders+') ORDER BY e.npcID,s.id LOCK IN SHARE MODE',tuple(ids))
            require(list(cur.fetchall())==d['preserved_spawns'],'Original placements changed')
            cur.execute('SELECT * FROM alternate_currency WHERE id=15 OR item_id=103000 LOCK IN SHARE MODE')
            require(list(cur.fetchall())==[d['required_currency']],'Native currency binding changed')
            cur.execute('SELECT id,Name,itemtype FROM items WHERE id=103000 LOCK IN SHARE MODE')
            require(cur.fetchone()==d['required_currency_item'],'Native coin changed')
            cols=','.join('classes'+str(i) for i in range(1,17))
            for identity in d['native_identities']:
                item=identity['item'];spell=identity['spell']
                cur.execute('SELECT id,Name,scrolleffect,classes FROM items WHERE id=%s LOCK IN SHARE MODE',(item['id'],))
                require(cur.fetchone()==item,'Native scroll changed')
                cur.execute('SELECT id,name,`rank`,'+cols+' FROM spells_new WHERE id=%s LOCK IN SHARE MODE',(spell['id'],))
                live=cur.fetchone();require(live is not None,'Native spell missing')
                levels={str(i):live['classes'+str(i)] for i in range(1,17) if 1<=live['classes'+str(i)]<=100}
                require(live['name']==spell['name'] and live['rank']==1 and levels==spell['class_levels'],'Native spell/class level changed')
            save(args.receipt_dir/'prepared.json',receipt)
            for row in d['merchant_inserts']:
                keys=list(row)
                cur.execute('INSERT INTO merchantlist ('+','.join('`'+k+'`' for k in keys)+') VALUES ('+','.join(['%s']*len(keys))+')',tuple(row[k] for k in keys))
                require(cur.rowcount==1,'Unexpected stock insert count')
            for npc in ids:
                cur.execute('UPDATE npc_types SET merchant_id=%s,alt_currency_id=15 WHERE id=%s AND merchant_id=0 AND alt_currency_id=0',(npc,npc))
                require(cur.rowcount==1,'Unexpected original vendor update count')
            cur.execute('SELECT * FROM npc_types WHERE id IN ('+placeholders+') ORDER BY id',tuple(ids))
            require(digest(list(cur.fetchall()))==digest(receipt['npc_after']),'NPC postimage mismatch')
            cur.execute('SELECT * FROM merchantlist WHERE merchantid IN ('+placeholders+') ORDER BY merchantid,slot',tuple(ids))
            require(digest(list(cur.fetchall()))==digest(receipt['merchant_after']),'Stock postimage mismatch')
        c.commit()
        receipt['status']='COMMITTED_ORIGINAL_VOID_BG_RANKI_STOCK_COMPONENT'
        save(args.receipt_dir/'completed.json',receipt)
        print(receipt['status'])
    except BaseException:
        c.rollback()
        # Prepared without completed can be commit followed by receipt I/O
        # failure. Inspect exact rows before any further action, never retry.
        raise
    finally:
        c.close()


if __name__=='__main__':
    main()
