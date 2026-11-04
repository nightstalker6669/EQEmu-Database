#!/usr/bin/env python3
"""Restore original Rotharran spell stock; default offline plan only."""
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
    before=d['merchant_before'];after=d['merchant_after'];added=d['merchant_inserts']
    spell_items={i['id'] for i in d['required_items']}
    require(d['npc_before']['id']==700070 and d['npc_patch']=={'alt_currency_id':22,'npc_faction_id':920680},'Wrong NPC scope')
    require(len(before)==308 and len(after)==355 and len(added)==47 and len(spell_items)==197,'Wrong catalogue scope')
    require(all(r['merchantid']==700070 for r in before+after),'Wrong merchant scope')
    old={r['slot']:r for r in before};new={r['slot']:r for r in after}
    require(len(new)==355 and len({r['item'] for r in after if r['item'] in spell_items})==197,'Duplicate/missing stock')
    for slot,row in old.items():
        changed={k for k in row if row[k]!=new[slot][k]}
        require(changed <= {'faction_required','alt_currency_cost','content_flags'},'Unrelated stock field change')
        if row['item'] not in spell_items:
            require(changed=={'content_flags'} and new[slot]['content_flags']==d['nonspell_pending_flag'],'Nonspell data change')
    require(sum(r['item'] not in spell_items for r in after)==158,'Nonspell scope changed')
    if not args.apply:
        print(json.dumps({'mode':'offline_plan','database_connected':False,'spell_count':197,
                          'spell_inserts':47,'existing_stock_updates':308,'npc_updates':1,
                          'preserved_unavailable_nonspell_count':158}))
        return
    require(args.config and args.receipt_dir,'--apply requires private --config and fresh --receipt-dir')
    args.receipt_dir.mkdir(mode=0o700,parents=True,exist_ok=False)
    cfg=json.loads(args.config.read_text())['server']['database']
    require(cfg['db']=='peq_housing_test','Wrong database')
    import pymysql
    c=pymysql.connect(host=args.host,port=args.port,user=cfg['username'],password=cfg['password'],
        database=cfg['db'],autocommit=False,cursorclass=pymysql.cursors.DictCursor)
    receipt={'target':cfg['db'],'time_utc':datetime.now(timezone.utc).isoformat(),
             'payload_sha256':digest(d),'merchant_before':before,'merchant_after':after,
             'npc_before':d['npc_before'],'npc_after':dict(d['npc_before'],**d['npc_patch'])}
    try:
        with c.cursor() as cur:
            cur.execute('SELECT DATABASE() AS target')
            require(cur.fetchone()['target']=='peq_housing_test','Wrong live target')
            cur.execute("SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('npc_types','merchantlist')")
            engines=cur.fetchall()
            require(len(engines)==2 and all(r['ENGINE']=='InnoDB' for r in engines),'Nontransactional mutation tables')
            cur.execute('SELECT * FROM npc_types WHERE id=700070 FOR UPDATE')
            require(digest(cur.fetchone())==d['npc_before_sha256'],'NPC changed')
            cur.execute('SELECT id FROM npc_types WHERE merchant_id=700070 ORDER BY id FOR UPDATE')
            require(list(cur.fetchall())==[{'id':700070}],'Other merchant consumer')
            cur.execute('SELECT * FROM merchantlist WHERE merchantid=700070 ORDER BY slot FOR UPDATE')
            require(digest(list(cur.fetchall()))==d['merchant_before_sha256'],'Stock changed')
            cur.execute('SELECT * FROM alternate_currency WHERE id=22 OR item_id=52149 LOCK IN SHARE MODE')
            require(list(cur.fetchall())==[d['currency']],'Currency identity changed')
            cur.execute('SELECT id,Name,itemtype FROM items WHERE id=52149 LOCK IN SHARE MODE')
            require(cur.fetchone()==d['required_currency_item'],'Native currency item changed')
            cur.execute('SELECT * FROM faction_list WHERE id=680 LOCK IN SHARE MODE')
            require(cur.fetchone()==d['faction'],'Faction base changed')
            cur.execute('SELECT * FROM faction_list_mod WHERE faction_id=680 ORDER BY id LOCK IN SHARE MODE')
            require(list(cur.fetchall())==d['faction_mods'],'Faction race modifiers changed')
            cur.execute('SELECT * FROM npc_faction WHERE id=920680 LOCK IN SHARE MODE')
            require(cur.fetchone()==d['group'],'Faction group changed')
            cur.execute('SELECT * FROM content_flags WHERE flag_name=%s FOR UPDATE',(d['nonspell_pending_flag'],))
            require(not cur.fetchall(),'Pending stock flag already defined; stop')
            for i,s in zip(d['required_items'],d['required_spells']):
                cur.execute('SELECT id,Name,scrolleffect,classes FROM items WHERE id=%s LOCK IN SHARE MODE',(i['id'],))
                require(cur.fetchone()==i,'Native spell item changed')
                cols=','.join('classes'+str(n) for n in range(1,17))
                cur.execute('SELECT id,name,`rank`,'+cols+' FROM spells_new WHERE id=%s LOCK IN SHARE MODE',(s['id'],))
                live=cur.fetchone()
                require(live is not None,'Native spell absent')
                levels={str(n):live['classes'+str(n)] for n in range(1,17) if 1<=live['classes'+str(n)]<=100}
                require(live['id']==s['id'] and live['name']==s['name'] and live['rank']==s['rank'] and levels==s['class_levels'],'Spell identity/learning level changed')
            save(args.receipt_dir/'prepared.json',receipt)
            writes=0
            for slot,row in old.items():
                nxt=new[slot]
                if row==nxt: continue
                cur.execute('UPDATE merchantlist SET faction_required=%s,alt_currency_cost=%s,content_flags=%s WHERE merchantid=700070 AND slot=%s',
                    (nxt['faction_required'],nxt['alt_currency_cost'],nxt['content_flags'],slot))
                require(cur.rowcount==1,'Unexpected stock update count');writes+=1
            for row in added:
                keys=list(row)
                cur.execute('INSERT INTO merchantlist ('+','.join('`'+k+'`' for k in keys)+') VALUES ('+','.join(['%s']*len(keys))+')',tuple(row[k] for k in keys))
                require(cur.rowcount==1,'Unexpected stock insert count');writes+=1
            cur.execute('UPDATE npc_types SET alt_currency_id=22,npc_faction_id=920680 WHERE id=700070')
            require(cur.rowcount==1,'Unexpected NPC update count');writes+=1
            cur.execute('SELECT * FROM npc_types WHERE id=700070')
            require(digest(cur.fetchone())==digest(receipt['npc_after']),'NPC postimage mismatch')
            cur.execute('SELECT * FROM merchantlist WHERE merchantid=700070 ORDER BY slot')
            require(digest(list(cur.fetchall()))==digest(after),'Stock postimage mismatch')
            receipt['writes']=writes
        c.commit()
        receipt['status']='COMMITTED_ORIGINAL_ROTHARRAN_197_SPELL_STOCK'
        save(args.receipt_dir/'completed.json',receipt)
        print(json.dumps({'status':receipt['status'],'writes':writes}))
    except BaseException:
        c.rollback()
        # A prepared-only receipt may represent commit followed by receipt I/O
        # failure; inspect exact postimages before further action, never retry.
        raise
    finally:
        c.close()


if __name__=='__main__':
    main()
