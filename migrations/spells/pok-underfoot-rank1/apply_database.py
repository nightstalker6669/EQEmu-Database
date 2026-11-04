#!/usr/bin/env python3
"""Guarded PoK source components; offline plan by default. Publication must precede coordinated apply."""
import argparse
from datetime import datetime, timezone
from pathlib import Path
import hashlib,json,os
from collections import Counter
from decimal import Decimal
from fractions import Fraction

def require(ok,message):
    if not ok: raise RuntimeError(message)

def digest(value):
    return hashlib.sha256(json.dumps(value,sort_keys=True,default=str).encode()).hexdigest()

def same(actual,expected,label):
    # Exact numeric values may have different int/float representations in source JSON
    # and database FLOAT columns. Rational comparison adds no tolerance or rounding.
    # Type tags preserve strings, nulls, bools and all other nonnumeric identities.
    def scalar(value):
        if type(value) in (int,float,Decimal):
            return ('number',Fraction(value))
        return (type(value).__module__,type(value).__qualname__,repr(value))
    def rows(values):
        return Counter(tuple(sorted((key,scalar(value)) for key,value in row.items())) for row in values)
    require(rows(actual)==rows(expected),'Full row mismatch: '+label)

def save(path,value):
    with os.fdopen(os.open(path,os.O_CREAT|os.O_EXCL|os.O_WRONLY,0o600),'w') as f:
        json.dump(value,f,indent=2,default=str);f.write('\n');f.flush();os.fsync(f.fileno())
    fd=os.open(path.parent,os.O_DIRECTORY|os.O_RDONLY)
    try: os.fsync(fd)
    finally: os.close(fd)

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--component',choices=['existing','tomes','new'],required=True)
    action=p.add_mutually_exclusive_group();action.add_argument('--apply',action='store_true');action.add_argument('--readback',action='store_true')
    p.add_argument('--config',type=Path);p.add_argument('--receipt-dir',type=Path)
    p.add_argument('--host',default='127.0.0.1');p.add_argument('--port',type=int,default=3306)
    a=p.parse_args();root=Path(__file__).resolve().parent
    d=json.loads((root/({'existing':'existing-vendors.json','tomes':'existing-tomes.json','new':'new-providers.json'}[a.component])).read_text())
    stock=d['merchant_inserts'];tables=d['npc_payload']['tables'] if a.component=='new' else {}
    mids=sorted({r['merchantid'] for r in stock});itemids=sorted(r['id'] for r in d['required_items']);spellids=sorted(r['id'] for r in d['required_spells'])
    require(len(stock)=={'existing':9,'tomes':2,'new':43}[a.component],'Unexpected stock count')
    require(all(r['min_expansion']==18 and r['max_expansion']==-1 and r['alt_currency_cost']==0 and r['language_required']==-1 for r in stock),'Era/cost/language contract changed')
    require(all(r['price']>0 for r in d['required_items']),'Native item price must stay positive')
    require(len({(r['merchantid'],r['slot']) for r in stock})==len(stock),'Duplicate stock keys')
    im={r['id']:r for r in d['required_items']};sm={r['id']:r for r in d['required_spells']}
    for t in d['native_targets']:
        require(im[t['item_id']]['scrolleffect']==t['spell_id'] and sm[t['spell_id']]['rank']==1 and sm[t['spell_id']]['classes'+str(t['class_id'])]==t['level'],'Native identity/level changed')
    if a.component=='new':
        require(set(tables)=={'npc_types','spawngroup','spawnentry','spawn2'} and all(len(v)==12 for v in tables.values()),'Actor component incomplete')
        require(mids==list(range(202900,202912)) and all(r['min_expansion']==18 for r in tables['spawn2']),'Actor allocation/era changed')
    if not (a.apply or a.readback):
        print(json.dumps({'mode':'offline_plan','database_connected':False,'component':a.component,'stock_inserts':len(stock),'actor_inserts':sum(map(len,tables.values())),'total_inserts':len(stock)+sum(map(len,tables.values()))}));return
    require(a.config and a.receipt_dir,'Private config and new receipt directory required')
    a.receipt_dir.mkdir(mode=0o700,parents=True,exist_ok=False)
    cfg=json.loads(a.config.read_text())['server']['database'];require(cfg['db']=='peq_housing_test','Wrong configured target')
    import pymysql
    c=pymysql.connect(host=a.host,port=a.port,user=cfg['username'],password=cfg['password'],database=cfg['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    receipt={'utc':datetime.now(timezone.utc).isoformat(),'component':a.component,'target':cfg['db'],'payload_sha256':digest(d),'payload':d}
    committed=False
    try:
        with c.cursor() as q:
            q.execute('SET TRANSACTION ISOLATION LEVEL SERIALIZABLE');c.begin()
            def read(sql,args=()):
                q.execute(sql,args);return list(q.fetchall())
            def byids(table,field,ids):
                values=read('SELECT * FROM `'+table+'` WHERE `'+field+'` IN ('+','.join(['%s']*len(ids))+')',ids)
                if table=='items':
                    # Saved full item snapshots serialize these DB datetime metadata
                    # fields via default=str. Preserve that exact timestamp text only.
                    for row in values:
                        for metadata in ('updated','verified'):
                            if isinstance(row.get(metadata),datetime):
                                row[metadata]=str(row[metadata])
                return values
            require(read('SELECT DATABASE() AS target')[0]['target']=='peq_housing_test','Wrong actual target')
            for table in ['merchantlist']+list(tables):
                engine=read('SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=%s',(table,))
                require(len(engine)==1 and engine[0]['ENGINE']=='InnoDB','Nontransactional write table: '+table)
            same(byids('items','id',itemids),d['required_items'],'native item definitions/prices')
            same(byids('spells_new','id',spellids),d['required_spells'],'native spell definitions/levels')
            same(read("SELECT zoneidnumber,short_name,min_status FROM zone WHERE zoneidnumber=202"),[d['required_zone']],'PoK zone access')
            if a.component!='new':
                same(byids('npc_types','id',mids),d['required_npcs'],'existing actors')
                consumer_columns='id,name,merchant_id,class' if a.component=='existing' else 'id,merchant_id,class,alt_currency_id,npc_faction_id'
                same(read('SELECT '+consumer_columns+' FROM npc_types WHERE merchant_id IN ('+','.join(['%s']*len(mids))+')',mids),d['merchant_consumers'],'sole merchant consumers')
                spawnids=[r['id'] for r in d['required_spawns']]
                same(read('SELECT s.*,e.npcID,e.chance FROM spawn2 s JOIN spawnentry e ON e.spawngroupID=s.spawngroupID WHERE s.id IN ('+','.join(['%s']*len(spawnids))+')',spawnids),d['required_spawns'],'existing placements')
                prior=[r for rows in d['merchant_before'].values() for r in rows]
                same(byids('merchantlist','merchantid',mids),prior+stock if a.readback else prior,'existing full merchant stock')
            else:
                # Exact reserved namespaces and dangling consumers; no broad scans.
                if not a.readback:
                    names=[r['name'] for r in tables['npc_types']]
                    require(not read('SELECT id,name FROM npc_types WHERE name IN ('+','.join(['%s']*len(names))+')',names),'New provider name already exists')
                    for sql in d['namespace_guard_sql'].split(';'):
                        if sql.strip(): require(not read(sql),'Reserved namespace collision')
                else:
                    for table,rows in tables.items():
                        field='spawngroupID' if table=='spawnentry' else 'id'
                        same(byids(table,field,[r[field] for r in rows]),rows,table+' full postimages')
                    same(byids('merchantlist','merchantid',mids),stock,'new full merchant stock')
                    consumers=read('SELECT id,merchant_id FROM npc_types WHERE merchant_id BETWEEN 202900 AND 202911')
                    same(consumers,[{'id':r['id'],'merchant_id':r['merchant_id']} for r in tables['npc_types']],'new sole merchant consumers')
            if a.readback:
                receipt['status']='INDEPENDENT_FULL_POSTIMAGE_READBACK_PASS';c.rollback();save(a.receipt_dir/'readback.json',receipt);print(receipt['status']);return
            save(a.receipt_dir/'prepared.json',receipt)
            # Full actor component first; never commit empty merchant actors separately.
            for table,rows in list(tables.items())+[('merchantlist',stock)]:
                for row in rows:
                    keys=list(row)
                    q.execute('INSERT INTO `'+table+'` ('+','.join('`'+k+'`' for k in keys)+') VALUES ('+','.join(['%s']*len(keys))+')',[row[k] for k in keys])
                    require(q.rowcount==1,'Insert count mismatch: '+table)
            for table,rows in tables.items():
                field='spawngroupID' if table=='spawnentry' else 'id'
                same(byids(table,field,[r[field] for r in rows]),rows,table+' transaction postimage')
            same(byids('merchantlist','merchantid',mids),(prior if a.component!='new' else [])+stock,'full merchant transaction postimage')
        c.commit();committed=True;receipt['status']='COMMITTED_'+a.component.upper()+'_POK_COMPONENT';save(a.receipt_dir/'completed.json',receipt);print(receipt['status'])
    except BaseException:
        c.rollback()
        # A missing completion receipt can mean commit succeeded but receipt I/O failed.
        # Reconcile exact full postimages before any subsequent mutation; never retry blindly.
        if committed: print('COMMIT SUCCEEDED; completion receipt failed. Reconcile before further action.')
        raise
    finally: c.close()

if __name__=='__main__':main()
