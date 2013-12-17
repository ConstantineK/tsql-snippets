# Going to try and make a deep dive inspector of one database

param (
	$dbname = 'TSQL2012',
	$badListFile = "$home\Dropbox\github\tsql-snippets\powershell-sql\deepdive\badlist.txt"
)
cls


add-type -AssemblyName "Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
if ($sqlServer -eq $null) # added because powergui really wants to keep this variable in scope even though a powershell window wont, still an awesome program http://powergui.org
{
	New-Variable -name "sqlServer" -Value $(new-object ("Microsoft.SqlServer.Management.Smo.Server") $serverName) -Scope script
	$sqlServer.ConnectionContext.StatementTimeout = 65000 
}
$skipDB = $(Get-Content $badListFile)

$db = $sqlServer.Databases | where {$skipDB -notcontains $_.name}

Write-Debug $("dbname:" + $dbname)
foreach($name in $db.Name){
	Write-Debug $("database unfiltered:" + $name)
}

$check = 0
foreach ($database in $db) {
	if ($database.name -eq $dbname)
	{			
		Write-Host $("Database: " + $database.Name)
		Write-Host $("Size: " + $database.Size + "MB")		
		write-host $("Last backup date: "+$database.LastBackupDate)
		write-host $("Active connections: " + $database.ActiveConnections)
		Write-Host $("Autoshrink: " + $database.AutoShrink)
		Write-Host $("Auto Update Stats: " + $database.AutoUpdateStatisticsEnabled)
		Write-Host $("Date Created: " + $database.CreateDate)
		#$db.DatabaseOptions	
		$check ++
	}
}
if ($check > 0) {Write-Host "Couldn't find a db with that name"}