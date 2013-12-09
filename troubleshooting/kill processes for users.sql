
declare @username varchar(max) = 'ConstantineK'

if object_id('tempdb..#processes') is not null
drop table #processes

create table #processes (
	spid int,
	status varchar(100),
	login varchar(200),
	hostname varchar(200),
	blkby varchar(200),
	dbname varchar(200),
	command varchar(200),
	cputime int,
	diskio int,
	lastbatch varchar(200),
	programname varchar(200),
	spid1 int,
	requestid int
)
insert #processes
Exec sp_who2


select 'kill '+CONVERT(VARCHAR(MAX),spid)+CHAR(13)+CHAR(10)+' GO'
from #processes
where dbname like db_name
and login like @username
