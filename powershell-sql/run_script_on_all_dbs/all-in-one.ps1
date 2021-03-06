Set-Location -Path "$home\Dropbox\github\tsql-snippets\powershell-sql\run_script_on_all_dbs"

#	This top zone sets up the variables for the script to run. 
#
#	I am working on moving the configuration to another file to make mistakes more apparent when modifying configuration, and making sure to test if they input sane information

$serverName = "example-pc"
$badListFile = ".\badlist.txt"
$dontRun = $(Get-Content $badListFile).split("`r`n") # not robust enough atm, if they use line endings other than carriage return newline
$sqlfile = ".\sqlfile.sql"

#
#	Dont touch anything under here
#

Push-Location
	Import-Module "sqlps" -DisableNameChecking
Pop-Location

# add-type assemblies taken from http://blogs.technet.com/b/heyscriptingguy/archive/2013/05/06/10-tips-for-the-sql-server-powershell-scripter.aspx however I might not need it for this script
add-type -AssemblyName "Microsoft.SqlServer.ConnectionInfo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
add-type -AssemblyName "Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
add-type -AssemblyName "Microsoft.SqlServer.SMOExtended, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
add-type -AssemblyName "Microsoft.SqlServer.SqlEnum, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
add-type -AssemblyName "Microsoft.SqlServer.Management.Sdk.Sfc, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop

if ($sqlServer -eq $null) # added because powergui really wants to keep this variable in scope even though a powershell window wont, still an awesome program http://powergui.org
{
	New-Variable -name "sqlServer" -Value $(new-object ("Microsoft.SqlServer.Management.Smo.Server") $serverName) -Scope script
	$sqlServer.ConnectionContext.StatementTimeout = 0 # timeout taken from http://blogs.technet.com/b/heyscriptingguy/archive/2013/05/06/10-tips-for-the-sql-server-powershell-scripter.aspx
}


	foreach ($name in $sqlserver.databases.name)
	{			
		if ($dontRun -notcontains $name)
		{
			$result = $(Invoke-Sqlcmd -InputFile $sqlfile -Database $name -QueryTimeout 65000)
			
			foreach ($row in $result)
			{
				Write-Host $row.name
			}
			
		}
		
	}
