#!/usr/bin/env python3
"""Five exact Fire item-reward type changes; offline by default, separate one-use authority."""
import argparse,json,hashlib
from pathlib import Path
import fire170_db as b
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(n):return json.loads((ROOT/n).read_text())
def require(ok,msg):
 if not ok:raise RuntimeError(msg)
def snapshot(q,contract,locking=False):
 return {t:b.query(q,'SELECT * FROM '+b.ident(t)+' WHERE '+v['scope']+(' FOR UPDATE' if locking else '')) for t,v in contract['context'].items()}
def sorted_rows(rows):return sorted(b.packed(z) for z in rows)
def identity(q,a):
 i=b.identity(q);e=a.get('expected_database_identity',{});require(set(e)=={'schema_name','server_hostname','server_id','server_port'} and all(i[k]==v for k,v in e.items()),'Wrong target identity');return i
def schema(q,contract):
 require(not b.query(q,"SELECT TRIGGER_NAME FROM information_schema.TRIGGERS WHERE EVENT_OBJECT_SCHEMA=DATABASE() AND EVENT_OBJECT_TABLE='rewards'"),'Unexpected rewards trigger;preserve and stop')
 for t,v in contract['context'].items():
  require(b.query(q,'SHOW FULL COLUMNS FROM '+b.ident(t))==v['columns'],'Schema drift: '+t)
  pk=[z['COLUMN_NAME'] for z in b.query(q,"SELECT COLUMN_NAME FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=%s AND INDEX_NAME='PRIMARY' ORDER BY SEQ_IN_INDEX",(t,))]
  eng=b.query(q,'SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=%s',(t,))[0]['ENGINE'];require(pk==v['primary_key'] and eng=='InnoDB','PK/engine drift: '+t)
def expected(contract,phase,after=False):
 result={t:v['rows'] for t,v in contract['context'].items()};result=json.loads(json.dumps(result));want_after=(phase=='forward')==after
 if want_after:
  for z in result['rewards']:
   if z['reward_id'] in contract['selected_reward_ids']:z['reward_type']=0
 return result
def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--phase',choices=['forward','rollback'],required=True);ap.add_argument('--execute',action='store_true');ap.add_argument('--authority',type=Path);ap.add_argument('--authority-sha256');ap.add_argument('--config',type=Path);ap.add_argument('--config-sha256');ap.add_argument('--host',default='127.0.0.1');ap.add_argument('--port',type=int,default=3306);ap.add_argument('--receipt-dir',type=Path);args=ap.parse_args()
 if not args.execute:print(json.dumps({'status':'OFFLINE_ONLY_NO_DB_CONNECTION','phase':args.phase}));return
 require(all([args.authority,args.authority_sha256,args.config,args.config_sha256,args.receipt_dir]),'Exact GO/config/newreceipt path required');require(sha(args.authority)==args.authority_sha256,'Authority pin mismatch');a=json.loads(args.authority.read_text());mp=ROOT/'SOURCE-HELPER-MANIFEST.json';m=load(mp.name)
 require(a.get('authorization')=='EXPLICIT_COORDINATOR_ONE_USE_GO' and a.get('phase')==args.phase and a.get('manifest_sha256')==sha(mp) and len(a.get('source_publication_commit',''))==40,'No exact published phase GO');require(a.get('admission_held') is True and a.get('zero_clients_verified') is True,'Real admission hold/zero-client evidence required')
 hold=a.get('admission_hold_receipt',{});require(hold.get('path') and sha(hold['path'])==hold.get('sha256'),'Exact actual admissionhold receipt required')
 for n,p in m['files'].items():require(sha(ROOT/n)==p['sha256'],'Source drift: '+n)
 require(sha(args.config)==args.config_sha256==a.get('config_sha256'),'Config drift');settings=json.loads(args.config.read_text())['server'];cfg=settings['database'];require(not settings.get('content_database') or settings['content_database']==cfg,'Separate content database needs new contract')
 contract=load('contract.json');pre=expected(contract,args.phase);post=expected(contract,args.phase,True);sql=(ROOT/('apply.sql' if args.phase=='forward' else 'rollback.sql')).read_text();sql=sql.replace('DELIMITER $$\n','').replace('END$$','END').replace('DELIMITER ;','').strip()
 b.save(ROOT/('authority-'+args.authority_sha256+'.consumed.private.json'),{'authority_sha256':args.authority_sha256,'phase':args.phase});args.receipt_dir.mkdir(mode=0o700,exist_ok=False);b.save(args.receipt_dir/'intent.private.json',{'phase':args.phase,'authority_sha256':args.authority_sha256,'manifest_sha256':sha(mp),'SQL_sha256':sha(ROOT/('apply.sql' if args.phase=='forward' else 'rollback.sql'))})
 c=None;committed=False;result={'phase':args.phase,'status':'STOPPED_NO_RETRY','SQL_invocations':0,'commit_marker_observed':False,'admission_release_authorized':False,'completed_cache_reload_proof':False}
 try:
  # Fresh bounded complete rows/schema/PKs plus durable recoverable backup before exact block.
  c=b.connect(cfg,args.host,args.port)
  with c.cursor() as q:
   result['identity']=identity(q,a);q.execute("SELECT GET_LOCK('rof2_fire170_exact_release',0) AS acquired");require(q.fetchone()['acquired']==1,'Fire writer lock occupied');schema(q,contract);q.execute('SET TRANSACTION READ ONLY');q.execute('START TRANSACTION WITH CONSISTENT SNAPSHOT');before=snapshot(q,contract)
   for t,rows in before.items():require(sorted_rows(rows)==sorted_rows(pre[t]),'Fresh exact full preimage drift: '+t)
   b.save(args.receipt_dir/'before.private.json',before);c.rollback();result['SQL_invocations']=1;q.execute(sql)
   markers=[]
   while True:
    if q.description:markers.extend(list(q.fetchall()))
    if not q.nextset():break
   marker='FIRE170_ITEM_TYPE_'+('FORWARD' if args.phase=='forward' else 'ROLLBACK')+'_COMMITTED_EXACT_POSTIMAGE';require(any(marker in list(z.values()) for z in markers),'COMMIT result uncertain;stop no replay');committed=True;result['commit_marker_observed']=True;b.save(args.receipt_dir/'committed.private.json',{'marker':marker})
  c.close();c=None
  c=b.connect(cfg,args.host,args.port)
  with c.cursor() as q:
   identity(q,a);q.execute('SET TRANSACTION READ ONLY');q.execute('START TRANSACTION WITH CONSISTENT SNAPSHOT');schema(q,contract);after=snapshot(q,contract)
   for t,rows in after.items():require(sorted_rows(rows)==sorted_rows(post[t]),'Independent full postimage mismatch: '+t)
   b.save(args.receipt_dir/'independent-postimages.private.json',after);c.rollback()
  result.update(status='COMMITTED_INDEPENDENT_EXACT_POSTIMAGE_PASS',rewards_updated=5,other_rewards_options_masks_amounts_preserved=True)
 except BaseException as exc:result.update(error_type=type(exc).__name__,error=str(exc),commit_marker_observed=committed);raise
 finally:
  if c:
   try:c.rollback();c.close()
   except Exception:pass
  result.update(connections_closed=True,automatic_retry=False,automatic_inverse=False,Build_scoped_catalogue_reload='REQUIRED_AFTER_CORRECTION_BEFORE_ADMISSION_RELEASE');b.save(args.receipt_dir/'final-receipt.private.json',result)
if __name__=='__main__':main()
