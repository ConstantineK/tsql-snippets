Set-Location -Path "~\Dropbox\github\tsql-snippets\powershell-sql\run_script_on_all_dbs"
Push-Location
Import-Module “sqlps” -DisableNameChecking
Pop-Location

$serverName = "example-pc"

# Assembly code and timeout taken from http://blogs.technet.com/b/heyscriptingguy/archive/2013/05/06/10-tips-for-the-sql-server-powershell-scripter.aspx
add-type -AssemblyName "Microsoft.SqlServer.ConnectionInfo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
add-type -AssemblyName "Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
add-type -AssemblyName "Microsoft.SqlServer.SMOExtended, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
add-type -AssemblyName "Microsoft.SqlServer.SqlEnum, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
add-type -AssemblyName "Microsoft.SqlServer.Management.Sdk.Sfc, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop


New-Variable -name "sqlServer" -Value $(new-object ("Microsoft.SqlServer.Management.Smo.Server") $serverName)
$sqlServer.ConnectionContext.StatementTimeout = 0 

foreach ($name in $sqlserver.databases.name)
{
	# maybe change over to sqlcmd.exe, what I am reading is that this may have a few problems that are easier avoided than worked with
	<#
	Invoke-Sqlcmd # need to change this over to 
			-InputFile sqlfile.sql 
			-Database $name 
			-Hostname localhost 
			-QueryTimeout 65535 # apparently this will time out after 30 seconds without this
	
	
		Wow, I didnt think there would be so many different methods to make this happen, I need to read more into 
		http://stackoverflow.com/questions/83410/how-do-i-call-an-sql-server-stored-procedure-from-powershell
		
		Tried out sqlcmd and found that the returned types dont give me a very nice little data row so, going to do more googling.
	#>
	
	if ($name -ne 'master' -and $name -ne 'msdb' -and $name -ne 'ReportServer' -and $name -ne 'ReportServerTempDB' -and $name -ne 'TempDB' -and $name -ne 'model')
	{
		$result = $(Invoke-Sqlcmd -InputFile sqlfile.sql -Database $name)
		foreach ($row in $result)
		{
			Write-Host $row.name
		}
		
	}
	
}