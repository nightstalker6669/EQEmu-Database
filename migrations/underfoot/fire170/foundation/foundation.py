#!/usr/bin/env python3
"""Fire170 exact three-table foundation source helper. No DDL transaction fiction."""
import argparse,json,hashlib,re
from pathlib import Path
import fire170_db as b
ROOT=Path(__file__).resolve().parent
TABLES=('rof2_fire_construct_death_receipts','rof2_fire_run_actions','rof2_fire_run_item_origins')
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(n):return json.loads((ROOT/n).read_text())
def require(ok,msg):
 if not ok:raise RuntimeError(msg)
def dtype(s):return re.sub(r'\b(tinyint|smallint|mediumint|int|bigint)\(\d+\)',r'\1',s.lower()).replace(' ','')
# Parse only the finite CHECK grammar used by the three pinned source statements.
# Preserve AND/OR precedence rather than stripping semantically significant parentheses.
class Check:
 def __init__(self,s):
  self.ts=re.findall(r'[a-z_][a-z_0-9]*|\d+|[(),=]',s.lower().replace('`',''));self.i=0
  compact=re.sub(r'\s+','',s.lower().replace('`',''));require(''.join(self.ts)==compact,'Unsupported CHECK token')
 def take(self,t=None):
  require(self.i<len(self.ts),'Incomplete CHECK');v=self.ts[self.i]
  if t:require(v==t,'Unexpected CHECK token')
  self.i+=1;return v
 def peek(self):return self.ts[self.i] if self.i<len(self.ts) else None
 def merge(self,op,items):
  flat=[]
  for z in items:
   if z[0]==op:flat.extend(z[1:])
   else:flat.append(z)
  return (op,*flat) if len(flat)>1 else flat[0]
 def expr(self):
  out=[self.term()]
  while self.peek()=='or':self.take();out.append(self.term())
  return self.merge('or',out)
 def term(self):
  out=[self.atom()]
  while self.peek()=='and':self.take();out.append(self.atom())
  return self.merge('and',out)
 def atom(self):
  if self.peek()=='(':
   self.take();v=self.expr();self.take(')');return v
  name=self.take();op=self.take()
  if op=='=':return ('eq',name,self.take())
  if op=='in':
   self.take('(');vals=[self.take()]
   while self.peek()==',':self.take();vals.append(self.take())
   self.take(')');return ('in',name,*vals)
  require(op=='is','Unsupported CHECK operation');neg=False
  if self.peek()=='not':self.take();neg=True
  self.take('null');return ('not_null' if neg else 'null',name)
 def parsed(self):
  out=self.expr();require(self.i==len(self.ts),'Trailing CHECK token');return out
def checktree(s):return Check(s).parsed()
def inspect(q,t,contract):
 exists=b.query(q,'SELECT TABLE_TYPE,ENGINE,TABLE_COLLATION FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=%s',(t,))
 if not exists:return None
 require(len(exists)==1 and exists[0]['TABLE_TYPE']=='BASE TABLE' and exists[0]['ENGINE']=='InnoDB','Unknown table/view/engine: '+t)
 expect=contract[t];cols=b.query(q,'SHOW FULL COLUMNS FROM '+b.ident(t));require(len(cols)==len(expect['columns']),'Column count drift: '+t)
 for a,e in zip(cols,expect['columns']):
  require(a['Field']==e['name'] and dtype(a['Type'])==dtype(e['type']) and a['Null']==e['nullable'] and a['Extra'].lower()==e['extra'] and a['Comment']=='','Column definition drift: '+t+'.'+e['name'])
  require((None if a['Default'] is None else str(a['Default']))==e['default'],'Column default drift: '+t+'.'+e['name'])
  require(a['Collation'] is None or a['Collation']==exists[0]['TABLE_COLLATION'],'Column collation override: '+t)
 schema_collation=b.query(q,'SELECT DEFAULT_COLLATION_NAME AS c FROM information_schema.SCHEMATA WHERE SCHEMA_NAME=DATABASE()')[0]['c'];require(exists[0]['TABLE_COLLATION']==schema_collation,'Table collation differs from source default context: '+t)
 indexes=b.query(q,'SHOW INDEX FROM '+b.ident(t));actual={}
 for z in indexes:
  require(z['Index_type']=='BTREE' and z['Sub_part'] is None and z['Collation']=='A','Unexpected index expression/type: '+t)
  actual.setdefault(z['Key_name'],{'unique':not bool(z['Non_unique']),'columns':[]})['columns'].append((int(z['Seq_in_index']),z['Column_name']))
 actual={k:{'unique':v['unique'],'columns':[n for _,n in sorted(v['columns'])]} for k,v in actual.items()}
 require(actual==expect['indexes'],'Index/PK drift: '+t)
 checks=b.query(q,'SELECT CONSTRAINT_NAME,CHECK_CLAUSE FROM information_schema.CHECK_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME=%s',(t,));require({z['CONSTRAINT_NAME']:checktree(z['CHECK_CLAUSE']) for z in checks}=={k:checktree(v) for k,v in expect['checks'].items()},'CHECK definition drift: '+t)
 constraints=b.query(q,"SELECT CONSTRAINT_TYPE FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=%s",(t,));require(all(z['CONSTRAINT_TYPE'] in ('PRIMARY KEY','UNIQUE','CHECK') for z in constraints),'Unknown FK/constraint: '+t)
 require(not b.query(q,'SELECT TRIGGER_NAME FROM information_schema.TRIGGERS WHERE EVENT_OBJECT_SCHEMA=DATABASE() AND EVENT_OBJECT_TABLE=%s',(t,)),'Unknown trigger: '+t)
 require(not b.query(q,'SELECT PARTITION_NAME FROM information_schema.PARTITIONS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=%s AND PARTITION_NAME IS NOT NULL',(t,)),'Unexpected partitioning: '+t)
 ddl=b.query(q,'SHOW CREATE TABLE '+b.ident(t))[0]['Create Table'];count=int(b.query(q,'SELECT COUNT(*) AS n FROM '+b.ident(t))[0]['n'])
 return {'table':t,'DDL':ddl,'DDL_sha256':hashlib.sha256(ddl.encode()).hexdigest(),'row_count':count,'schema_exact':True}
def identity(q,a):
 i=b.identity(q);e=a.get('expected_database_identity',{});require(set(e)=={'schema_name','server_hostname','server_id','server_port'} and all(i[k]==v for k,v in e.items()),'Wrong database or incomplete target identity');return i
def connect(args,cfg):return b.connect(cfg,args.host,args.port)
def verify_new_connection(args,cfg,a,t,contract):
 c=connect(args,cfg)
 try:
  with c.cursor() as q:
   identity(q,a);q.execute('SET TRANSACTION READ ONLY');q.execute('START TRANSACTION WITH CONSISTENT SNAPSHOT');value=inspect(q,t,contract);c.rollback();return value
 finally:c.close()
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--phase',choices=['install_or_verify','verify','recover_empty_owned'],required=True);p.add_argument('--execute',action='store_true');p.add_argument('--authority',type=Path);p.add_argument('--authority-sha256');p.add_argument('--config',type=Path);p.add_argument('--config-sha256');p.add_argument('--host',default='127.0.0.1');p.add_argument('--port',type=int,default=3306);p.add_argument('--receipt-dir',type=Path);args=p.parse_args()
 if not args.execute:print(json.dumps({'status':'OFFLINE_ONLY_NO_DB_CONNECTION','phase':args.phase}));return
 require(all([args.authority,args.authority_sha256,args.config,args.config_sha256,args.receipt_dir]),'Exact authority/config/receipt paths required');require(sha(args.authority)==args.authority_sha256,'Authority pin mismatch');a=json.loads(args.authority.read_text());mp=ROOT/'SOURCE-HELPER-MANIFEST.json';m=load(mp.name)
 require(a.get('authorization')=='EXPLICIT_COORDINATOR_ONE_USE_GO' and a.get('phase')==args.phase and a.get('manifest_sha256')==sha(mp) and len(a.get('source_publication_commit',''))==40,'Not exact published phase authority');require(a.get('admission_held') is True and a.get('owned_consumers_quiesced') is True,'Admission/writer hold absent')
 for n,v in m['files'].items():require(sha(ROOT/n)==v['sha256'],'Source drift: '+n)
 require(sha(args.config)==args.config_sha256==a.get('config_sha256'),'Config drift');settings=json.loads(args.config.read_text())['server'];cfg=settings['database'];require(not settings.get('content_database') or settings['content_database']==cfg,'Separate content target requires new contract')
 contract=load('schema-contract.json');installation=None
 if args.phase=='recover_empty_owned':
  pin=a.get('installation_receipt',{});require(pin.get('path') and sha(pin['path'])==pin.get('sha256'),'Exact prior installation receipt required');installation=json.loads(Path(pin['path']).read_text());require(installation.get('manifest_sha256')==sha(mp) and installation.get('phase')=='install_or_verify' and installation.get('status') in ('INSTALL_OR_VERIFY_COMPLETE_INDEPENDENT_PASS','STOPPED_NO_RETRY'),'Installation ownership receipt invalid')
 b.save(ROOT/('authority-'+args.authority_sha256+'.consumed.private.json'),{'phase':args.phase,'authority_sha256':args.authority_sha256});args.receipt_dir.mkdir(mode=0o700,exist_ok=False);b.save(args.receipt_dir/'intent.private.json',{'authority_sha256':args.authority_sha256,'phase':args.phase,'manifest_sha256':sha(mp),'DDL_is_not_atomic':True})
 result={'status':'STOPPED_NO_RETRY','phase':args.phase,'manifest_sha256':sha(mp),'created_tables':[],'dropped_tables':[],'per_table':{},'automatic_retry':False,'automatic_inverse':False};c=None
 try:
  c=connect(args,cfg)
  with c.cursor() as q:
   result['identity']=identity(q,a);q.execute("SELECT GET_LOCK('rof2_fire170_exact_release',0) AS acquired");require(q.fetchone()['acquired']==1,'Fire release writer lock occupied')
   # Validate ALL preexisting tables before the first implicit-commit DDL.
   before={t:inspect(q,t,contract) for t in TABLES};b.save(args.receipt_dir/'before.private.json',before)
   if args.phase=='recover_empty_owned':
    owned=installation['created_tables'];require(owned and set(owned)<=set(TABLES) and len(owned)==len(set(owned)),'No receipt-owned created tables')
    for t in owned:
     require(t in installation.get('per_table',{}) and installation['per_table'][t].get('schema_exact') is True and installation['per_table'][t].get('row_count')==0,'No durable independent created ownership: '+t)
     require(before[t] and before[t]['row_count']==0 and before[t]['DDL_sha256']==installation['per_table'][t]['DDL_sha256'],'Owned table changed/nonempty; preserve: '+t)
     refs=b.query(q,'SELECT TABLE_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE REFERENCED_TABLE_SCHEMA=DATABASE() AND REFERENCED_TABLE_NAME=%s',(t,));require(not refs,'Incoming FK dependency; preserve: '+t)
   elif args.phase=='verify':require(all(before.values()),'Foundation table absent')
   for t in TABLES:
    if args.phase=='recover_empty_owned':
     if t not in installation['created_tables']:continue
     b.save(args.receipt_dir/(t+'.drop-intent.private.json'),{'table':t,'owned_installation_receipt_sha256':a['installation_receipt']['sha256'],'before':before[t]})
     # WRITE lock prevents insertion between final empty/schema check and DROP.
     q.execute('LOCK TABLES '+b.ident(t)+' WRITE')
     try:
      live=inspect(q,t,contract);require(live and live['row_count']==0 and live['DDL_sha256']==before[t]['DDL_sha256'],'Last-moment table change; preserve: '+t);q.execute('DROP TABLE '+b.ident(t));result['dropped_tables'].append(t)
     finally:q.execute('UNLOCK TABLES')
     post=verify_new_connection(args,cfg,a,t,contract);require(post is None,'Independent DROP readback failed');result['per_table'][t]={'absent':True};b.save(args.receipt_dir/(t+'.dropped.private.json'),{'table':t,'independent_absence':True});continue
    if before[t] is None:
     require(args.phase=='install_or_verify','Absent foundation cannot verify');filename=contract[t]['source_file'];raw=(ROOT/filename).read_text();sql=re.search(r'CREATE TABLE\s+'+t+r'\s*\(.*?\)\s*ENGINE=InnoDB;',raw,re.S).group(0)
     b.save(args.receipt_dir/(t+'.create-intent.private.json'),{'table':t,'source_sha256':sha(ROOT/filename),'preimage_absent':True,'implicit_commit':True})
     q.execute(sql) # Exactly once for this table/authority. No IF NOT EXISTS/ALTER/REPLACE.
     post=verify_new_connection(args,cfg,a,t,contract);require(post is not None and post['row_count']==0,'Independent CREATE verification failed');result['created_tables'].append(t);result['per_table'][t]=post;b.save(args.receipt_dir/(t+'.created.private.json'),post)
    else:
     post=verify_new_connection(args,cfg,a,t,contract);require(post is not None,'Preexisting foundation disappeared');result['per_table'][t]=post;b.save(args.receipt_dir/(t+'.verified-existing.private.json'),post)
   result['status']={'install_or_verify':'INSTALL_OR_VERIFY_COMPLETE_INDEPENDENT_PASS','verify':'VERIFY_COMPLETE_INDEPENDENT_PASS','recover_empty_owned':'EMPTY_OWNED_RECOVERY_COMPLETE_INDEPENDENT_PASS'}[args.phase]
 except BaseException as exc:result.update(error_type=type(exc).__name__,error=str(exc));raise
 finally:
  if c:c.close()
  result.update(connections_closed=True,DDL_transaction_atomic=False);b.save(args.receipt_dir/'final-receipt.private.json',result)
if __name__=='__main__':main()
