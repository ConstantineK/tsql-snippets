
foreach ($name in $sqlserver.databases.name)
{
	# maybe change over to sqlcmd.exe, what I am reading is that this may have a few problems that are easier avoided than worked with
	Invoke-Sqlcmd # need to change this over to 
			-InputFile sqlfile.sql 
			-Database $name 
			-Hostname localhost 
			-QueryTimeout 65535 # apparently this will time out after 30 seconds without this
	
	<#
		Wow, I didnt think there would be so many different methods to make this happen, I need to read more into 
		http://stackoverflow.com/questions/83410/how-do-i-call-an-sql-server-stored-procedure-from-powershell
				
	#>
	
	sqlcmd.exe -s "$sqlserver.name"
	
	
}

