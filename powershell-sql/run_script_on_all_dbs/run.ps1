foreach ($name in $sqlserver.databases.name)
{
	Invoke-Sqlcmd -InputFile sqlfile.sql -Database $name -Hostname localhost -QueryTimeout 5000
	
}

