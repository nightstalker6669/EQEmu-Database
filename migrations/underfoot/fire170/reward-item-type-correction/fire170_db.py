"""Minimal DB/receipt utility; requires PyMySQL. No connection at import."""
import base64,datetime,decimal,hashlib,json,os,re
import pymysql
def typed(v):
 if isinstance(v,bytes):return {'__type__':'bytes','base64':base64.b64encode(v).decode()}
 if isinstance(v,decimal.Decimal):return {'__type__':'decimal','value':str(v)}
 if isinstance(v,(datetime.datetime,datetime.date,datetime.time)):return {'__type__':type(v).__name__,'value':v.isoformat()}
 if isinstance(v,datetime.timedelta):return {'__type__':'timedelta','seconds':str(v.total_seconds())}
 if isinstance(v,dict):return {k:typed(x) for k,x in v.items()}
 if isinstance(v,(list,tuple)):return [typed(x) for x in v]
 return v

def packed(v):return json.dumps(typed(v),sort_keys=True,separators=(',',':'),ensure_ascii=False).encode()
def digest(v):return hashlib.sha256(packed(v)).hexdigest()
def save(path,v):
 b=json.dumps(typed(v),indent=2,ensure_ascii=False).encode()+b'\n'
 with os.fdopen(os.open(path,os.O_CREAT|os.O_EXCL|os.O_WRONLY,0o600),'wb') as f:f.write(b);f.flush();os.fsync(f.fileno())
 fd=os.open(path.parent,os.O_DIRECTORY|os.O_RDONLY)
 try:os.fsync(fd)
 finally:os.close(fd)
 return hashlib.sha256(b).hexdigest()
def ident(x):
 if not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*',x):raise ValueError('Invalid source identifier')
 return '`'+x+'`'
def ints(values):return ','.join(str(int(x)) for x in sorted(set(values)))
def identity(cursor):
 cursor.execute('SELECT DATABASE() AS schema_name,@@hostname AS server_hostname,@@port AS server_port,@@server_id AS server_id,@@version AS server_version,@@read_only AS server_read_only')
 return cursor.fetchone()
def query(cursor,sql,args=None):cursor.execute(sql,args);return list(cursor.fetchall())
def connect(cfg,host,port):return pymysql.connect(host=host,port=port,user=cfg['username'],password=cfg['password'],database=cfg['db'],autocommit=True,cursorclass=pymysql.cursors.DictCursor,charset='utf8mb4',connect_timeout=10,read_timeout=60,write_timeout=60)

