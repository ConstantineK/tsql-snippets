
IF OBJECT_ID('tempdb..#sp_who') IS NOT NULL 
	DROP TABLE #sp_who

CREATE TABLE 	#sp_who
(
	spid int, 
	ecid int, 
	status varchar(100), 
	loginname varchar(1000), 
	hostname varchar(1000), 
	blk int, 
	dbname varchar(1000), 
	cmd varchar(max), 
	request_id int
)

INSERT #sp_who
(
				spid, 
				ecid, 
				status, 
				loginname, 
				hostname, 
				blk, 
				dbname, 
				cmd, 
				request_id
)
EXEC sp_who

SELECT *
FROM #sp_who 
WHERE dbname = db_name(db_id())