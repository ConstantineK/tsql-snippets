# Going to try and make a deep dive inspector of one database

param (
	$dbname = ("TSQL2012", "AdventureWorks2012"),
	$badListFile = "$home\Dropbox\github\tsql-snippets\powershell-sql\deepdive\badlist.txt"
)
cls


add-type -AssemblyName "Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
if ($sqlServer -eq $null) # added because powergui really wants to keep this variable in scope even though a powershell window wont, still an awesome program http://powergui.org
{
	New-Variable -name "sqlServer" -Value $(new-object ("Microsoft.SqlServer.Management.Smo.Server") $serverName) -Scope script
	$sqlServer.ConnectionContext.StatementTimeout = 65000 
}
# simple way to eliminate master, tempdb, and ReportServer
$skipDB = $(Get-Content $badListFile)
$db = $sqlServer.Databases | where {$skipDB -notcontains $_.name}

foreach($name in $db.Name){
	Write-Debug $("dbname to find: " + $name)
}

[hashtable]$dbinfo=@{}

$check = 0
foreach ($database in $db) {
	if ( $dbname -contains $database.name )
	{			
		$dbinfo.add(
				"$database",
				@{		
					"Current Size"			= $($database.Size.ToString()+"MB");
					"Last Backup Date"		= $database.LastBackupDate;
					"Current Connections"	= $database.ActiveConnections;
					"Auto Shrink"			= $database.AutoShrink;
					"Auto Update Statistics"			= $database.AutoUpdateStatisticsEnabled;
					"Date Created"			= $database.CreateDate;		
					"Space Used"			= $($database.DataSpaceUsage.ToString()+"KB");
					"Owner"					= $database.Owner;
					
				}
			)
		$check ++		
	}
}

$dbinfo.GetEnumerator() | ForEach-Object {
	$_.Key
	$_.Value | ft 
}

if ($check -eq 0) {Write-Host "Couldn't find a db with those names."}

