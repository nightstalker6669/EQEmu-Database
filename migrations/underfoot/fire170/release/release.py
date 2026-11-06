#!/usr/bin/env python3
"""Finite Fire170 data helpers. Default is offline description. No DDL or automatic retry."""
import argparse,json,hashlib,struct,sys,os,datetime
from pathlib import Path
import fire170_db as b
ROOT=Path(__file__).resolve().parent
FLAG_TABLES=('tasks','reward_sets','reward_sources','rewards','reward_options')
FIRE_TABLES=('rof2_fire_run_actions','rof2_fire_run_item_origins','rof2_fire_construct_death_receipts')
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(n):return json.loads((ROOT/n).read_text())
def fail(message):raise RuntimeError(message)
def identity(q,authority):
 i=b.identity(q)
 expected=authority.get('expected_database_identity',{})
 if not expected or any(i.get(k)!=v for k,v in expected.items()) or set(expected)!={'schema_name','server_hostname','server_id','server_port'}:fail('Wrong serving database or incomplete exact identity')
 return i
def canonical_row(t,row,snap):
 result={}
 for col in snap['tables'][t]['columns']:
  k=col['Field'];v=row[k];typ=col['Type'].lower()
  if v is not None and typ.startswith('float'):
   if ',' in typ:v=round(float(v),int(typ.split(',')[1].split(')')[0]))
   v=struct.pack('!f',float(v)).hex()
  elif v is not None and any(typ.startswith(z) for z in ('tinyint','smallint','mediumint','int','bigint')):v=int(v)
  elif v is not None and typ.startswith(('decimal','double')):v=str(v)
  result[k]=v
 return result
def same(t,actual,expected,snap):
 return sorted(b.packed(canonical_row(t,z,snap)) for z in actual)==sorted(b.packed(canonical_row(t,z,snap)) for z in expected)
def expected_rows(target,active=False):
 rows=json.loads(json.dumps(target['tables']))
 if active:
  for t in FLAG_TABLES:
   for z in rows[t]:z['enabled']=1
 return rows
def projection(t,snap):
 # FLOAT text output has fewer significant digits than its stored binary32 value.
 # Widen the stored value in SQL before transmission; the exact binary32 comparator stays unchanged.
 return ','.join(('CAST('+b.ident(c['Field'])+' AS DOUBLE) AS '+b.ident(c['Field'])) if c['Type'].lower().startswith('float') else b.ident(c['Field']) for c in snap['tables'][t]['columns'])
def full_scope(q,snap,locking=False):
 return {t:b.query(q,'SELECT '+projection(t,snap)+' FROM '+b.ident(t)+' WHERE '+s['scope']+(' FOR UPDATE' if locking else '')) for t,s in snap['tables'].items()}
def row_differences(t,actual,expected,snap):
 keys=snap['tables'][t]['primary_key'];key=lambda z:tuple(z[k] for k in keys)
 am={key(z):z for z in actual};em={key(z):z for z in expected};diff=[]
 if len(am)!=len(actual) or len(em)!=len(expected):diff.append({'table':t,'primary_key':None,'column':'*','kind':'duplicate_PK','expected_rows':len(expected),'observed_rows':len(actual)})
 for pk in sorted(set(am)|set(em),key=repr):
  a=am.get(pk);e=em.get(pk);identity=dict(zip(keys,pk))
  if a is None or e is None:diff.append({'table':t,'primary_key':identity,'column':'*','expected':e,'observed':a,'kind':'missing_or_unexpected_row'});continue
  ac=canonical_row(t,a,snap);ec=canonical_row(t,e,snap)
  for col in snap['tables'][t]['columns']:
   k=col['Field']
   if ac[k]!=ec[k]:diff.append({'table':t,'primary_key':identity,'column':k,'SQL_type':col['Type'],'expected':e[k],'observed':a[k],'expected_schema_canonical':ec[k],'observed_schema_canonical':ac[k]})
 return diff
def require_rows(t,actual,expected,snap,receipt_dir,context):
 if not same(t,actual,expected,snap):
  b.save(receipt_dir/'postimage-mismatch.private.json',{'context':context,'table':t,'differences':row_differences(t,actual,expected,snap),'expected_full_rows':expected,'observed_full_rows':actual})
  fail(context+': '+t+'; exact PK/column/expected/observed saved in postimage-mismatch.private.json')
def check_schema(q,snap):
 for t,s in snap['tables'].items():
  if b.query(q,'SHOW FULL COLUMNS FROM '+b.ident(t))!=s['columns']:fail('Schema drift: '+t)
  p=[z['COLUMN_NAME'] for z in b.query(q,"SELECT COLUMN_NAME FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=%s AND INDEX_NAME='PRIMARY' ORDER BY SEQ_IN_INDEX",(t,))]
  eng=b.query(q,'SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=%s',(t,))[0]['ENGINE']
  if p!=s['primary_key'] or eng!='InnoDB':fail('PK/engine drift: '+t)
def no_consumers(q,snap,activation=False):
 for k,v in snap['checks'].items():
  if int(b.query(q,v['SQL'])[0]['n']):fail('Namespace/consumer/reference occupied: '+k)
 found={z['TABLE_NAME'] for z in b.query(q,"SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN('rof2_fire_run_actions','rof2_fire_run_item_origins','rof2_fire_construct_death_receipts')")}
 if activation and found!=set(FIRE_TABLES):fail('Required separately installed Fire foundation tables absent')
 for t in found:
  if int(b.query(q,'SELECT COUNT(*) AS n FROM '+b.ident(t))[0]['n']):fail('Fire custody/history exists; preserve and stop: '+t)
def world_expected(snap,target,active):
 row=dict(snap['world_font_preimage'][0])
 if active:row.update(target['activation_only_existing_world_update']['selected_fields'])
 return row
def pk_where(t,row,snap):
 keys=snap['tables'][t]['primary_key'];return ' AND '.join(b.ident(k)+' <=> %s' for k in keys),tuple(row[k] for k in keys)
def check_input(target,snap):
 if sum(map(len,target['tables'].values()))!=254:fail('Allowlist row count changed')
 for t,rows in target['tables'].items():
  fields={c['Field'] for c in snap['tables'][t]['columns']}
  for z in rows:
   if set(z)!=fields:fail('Target does not specify full current row: '+t)
   for c in snap['tables'][t]['columns']:
    if z[c['Field']] is None and c['Null']=='NO':fail('Unresolved target NULL: '+t+'.'+c['Field'])
 if any(z['respawntime']!=21601 or z['variance']!=0 or 'enabled' in z for z in target['tables']['spawn2']):fail('Spawn timing/actual schema contract changed')
 if any(z['spawn_limit']!=1 for z in target['tables']['spawngroup']):fail('Group cap changed')
 if any(z['enabled']!=0 for t in FLAG_TABLES for z in target['tables'][t]):fail('Staging enable flags must be zero')
def write_flags(q,rows,snap,to):
 for t in FLAG_TABLES:
  for z in rows[t]:
   where,args=pk_where(t,z,snap);q.execute('UPDATE '+b.ident(t)+' SET enabled=%s WHERE '+where+' AND enabled=%s',(to,*args,1-to))
   if q.rowcount!=1:fail('Flag CAS refused: '+t)
def write_world(q,before,after,snap):
 changed={k:v for k,v in after.items() if v!=before[k]}
 if not changed:fail('World activation has no transition')
 # Compare each captured value in its actual schema domain; no epsilon or dropped field.
 types={c['Field']:c['Type'].lower() for c in snap['tables']['doors']['columns']}
 predicates=[b.ident(k)+' <=> '+('CAST(%s AS FLOAT)' if types[k].startswith('float') else '%s') for k in before]
 q.execute('UPDATE doors SET '+','.join(b.ident(k)+'=%s' for k in changed)+' WHERE id=35650 AND '+' AND '.join(predicates),(*changed.values(),*before.values()))
 if q.rowcount!=1:fail('World Font full-row CAS refused')
def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--phase',choices=['stage','activate','rollback_activation','rollback_stage'],required=True);ap.add_argument('--execute',action='store_true');ap.add_argument('--authority',type=Path);ap.add_argument('--authority-sha256');ap.add_argument('--receipt-dir',type=Path);ap.add_argument('--config',type=Path);ap.add_argument('--config-sha256');ap.add_argument('--host',default='127.0.0.1');ap.add_argument('--port',type=int,default=3306);args=ap.parse_args()
 if not args.execute:
  print(json.dumps({'phase':args.phase,'status':'OFFLINE_ONLY_NO_DB_CONNECTION','authority_required':True,'no_automatic_retry':True}));return
 if not all([args.authority,args.authority_sha256,args.receipt_dir,args.config,args.config_sha256]):fail('Exact separate authority and new receipt directory required')
 if sha(args.authority)!=args.authority_sha256:fail('Authority hash mismatch')
 authority=json.loads(args.authority.read_text());manifest=load('SOURCE-HELPER-MANIFEST.json')
 if authority.get('phase')!=args.phase or authority.get('manifest_sha256')!=sha(ROOT/'SOURCE-HELPER-MANIFEST.json') or authority.get('authorization')!='EXPLICIT_COORDINATOR_ONE_USE_GO':fail('Not exact phase authority')
 if len(authority.get('source_publication_commit',''))!=40 or authority.get('admission_held') is not True or authority.get('owned_consumers_quiesced') is not True:fail('Publication/admission/quiescence authority absent')
 for p,pin in manifest['files'].items():
  if sha(ROOT/p)!=pin['sha256']:fail('Pinned artifact drift: '+p)
 if manifest['status']!='PREPARED_NOT_APPLIED_REQUIRES_SEPARATE_AUTHORITY':fail('Preparation is blocked')
 if args.phase=='activate':
  for k in ['matched_code_install_receipt','foundation_install_receipt','cache_restart_plan']:
   pin=authority.get(k,{})
   if not pin.get('path') or sha(pin['path'])!=pin.get('sha256'):fail('Missing exact activation dependency: '+k)
  # cache_restart_plan is a future procedure, NOT a completed enabled-data cache receipt.
  # Native fresh-process/cache verification follows activation while admission stays held.
 target=load('target-rows.json');snap=load('schema-contract.json');check_input(target,snap)
 # This durable marker consumes this exact authority before opening any database connection.
 marker=ROOT/('authority-'+args.authority_sha256+'.consumed.private.json');b.save(marker,{'phase':args.phase,'authority_sha256':args.authority_sha256,'automatic_retry':False})
 args.receipt_dir.mkdir(mode=0o700,parents=False,exist_ok=False);b.save(args.receipt_dir/'intent.private.json',{'phase':args.phase,'authority':str(args.authority),'authority_sha256':args.authority_sha256,'manifest_sha256':sha(ROOT/'SOURCE-HELPER-MANIFEST.json')})
 if sha(args.config)!=args.config_sha256 or authority.get('config_sha256')!=args.config_sha256:fail('Effective configuration changed')
 settings=json.loads(args.config.read_text())['server'];cfg=settings['database']
 if settings.get('content_database') and settings['content_database']!=cfg:fail('Separate content target requires a new exact contract')
 conn=None;committed=False;result={'phase':args.phase,'status':'STOPPED_NO_RETRY','commit_returned':False};lockname='rof2_fire170_exact_release'
 try:
  conn=b.connect(cfg,args.host,args.port)
  with conn.cursor() as q:
   result['identity']=identity(q,authority);q.execute('SELECT GET_LOCK(%s,0) AS acquired',(lockname,));
   if q.fetchone()['acquired']!=1:fail('Another Fire data writer owns the release lock')
   check_schema(q,snap);no_consumers(q,snap,args.phase=='activate');q.execute("SET SESSION sql_mode=CONCAT(@@sql_mode,',STRICT_ALL_TABLES')");q.execute('SET TRANSACTION ISOLATION LEVEL SERIALIZABLE');q.execute('START TRANSACTION');check_schema(q,snap);no_consumers(q,snap,args.phase=='activate')
   before=full_scope(q,snap,True);wb=b.query(q,'SELECT * FROM doors WHERE id=35650 FOR UPDATE')
   if len(wb)!=1:fail('World Font identity absent or ambiguous')
   start_active=args.phase=='rollback_activation';want=expected_rows(target,start_active)
   for t,rows in before.items():
    if args.phase=='stage':
     if rows:fail('Staging namespace now occupied: '+t)
    else:require_rows(t,rows,want[t],snap,args.receipt_dir,'Owned full postimage/foreign references changed')
   expected_world=world_expected(snap,target,start_active)
   require_rows('doors',wb,[expected_world],snap,args.receipt_dir,'Existing world Font preimage changed')
   b.save(args.receipt_dir/'before.private.json',{'tables':before,'world_font':wb})
   if args.phase=='stage':
    for t,rows in target['tables'].items():
     for z in rows:
      q.execute('INSERT INTO '+b.ident(t)+' ('+','.join(b.ident(k) for k in z)+') VALUES ('+','.join(['%s']*len(z))+')',tuple(z.values()))
      if q.rowcount!=1:fail('Insert row count mismatch')
   elif args.phase in ['activate','rollback_activation']:
    to=1 if args.phase=='activate' else 0;write_flags(q,want,snap,to);write_world(q,expected_world,world_expected(snap,target,bool(to)),snap)
   else:
    # Only exact staged, disabled, unused rows may be removed; never player/history rows.
    for t in reversed(list(target['tables'])):
     for z in target['tables'][t]:
      where,params=pk_where(t,z,snap);q.execute('DELETE FROM '+b.ident(t)+' WHERE '+where,params)
      if q.rowcount!=1:fail('Guarded delete row count mismatch')
   after=full_scope(q,snap,True);wa=b.query(q,'SELECT * FROM doors WHERE id=35650');endactive=args.phase=='activate';expected=expected_rows(target,endactive)
   for t,rows in after.items():
    require_rows(t,rows,[] if args.phase=='rollback_stage' else expected[t],snap,args.receipt_dir,'In-transaction full postimage mismatch')
   require_rows('doors',wa,[world_expected(snap,target,endactive)],snap,args.receipt_dir,'World postimage mismatch')
   no_consumers(q,snap,args.phase=='activate');conn.commit();committed=True;result['commit_returned']=True;b.save(args.receipt_dir/'committed.private.json',{'phase':args.phase,'commit_returned':True})
  conn.close();conn=None
  # Independent fresh read-only proof, closed before returning.
  conn=b.connect(cfg,args.host,args.port)
  with conn.cursor() as q:
   identity(q,authority);q.execute('SET TRANSACTION READ ONLY');q.execute('START TRANSACTION WITH CONSISTENT SNAPSHOT');after=full_scope(q,snap);wa=b.query(q,'SELECT * FROM doors WHERE id=35650');check_schema(q,snap)
   for t,rows in after.items():
    require_rows(t,rows,[] if args.phase=='rollback_stage' else expected[t],snap,args.receipt_dir,'Independent postimage mismatch')
   require_rows('doors',wa,[world_expected(snap,target,endactive)],snap,args.receipt_dir,'Independent world postimage mismatch')
   b.save(args.receipt_dir/'independent-postimages.private.json',{'tables':after,'world_font':wa});conn.rollback();result['status']='COMMITTED_INDEPENDENT_EXACT_POSTIMAGE_PASS'
 except BaseException as exc:
  result.update(error_type=type(exc).__name__,error=str(exc),commit_returned=committed);raise
 finally:
  if conn:
   try:conn.rollback();conn.close()
   except Exception:pass
  result.update(connections_closed=True,automatic_retry=False,automatic_inverse=False,admission_release_authorized=False)
  if args.phase=='activate':result.update(activation_boundary='DATA_ONLY_ADMISSION_MUST_REMAIN_HELD',cache_restart_plan_sha256=authority['cache_restart_plan']['sha256'],enabled_data_fresh_process_cache_verification='REQUIRED_AFTER_ACTIVATION_BEFORE_ADMISSION_RELEASE_NOT_PERFORMED_BY_DATABASE_HELPER')
  b.save(args.receipt_dir/'final-receipt.private.json',result)
if __name__=='__main__':main()
