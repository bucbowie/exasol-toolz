import os, sys
try:
	from pyexasol import ExaConnection
except:
	os.system('pip install pyexasol')
	from pyexasol import ExaConnection

con = ExaConnection(dsn="192.168.1.158", user='sys', password='exasol')
data = con.export_to_pandas('SELECT * from EXA_DBA_AUDIT_SESSIONS WHERE LOGIN_TIME > (SELECT ADD_SECONDS(CURRENT_TIMESTAMP, -184000))')
print(data)
