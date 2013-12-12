param(
		[string]$serverName = "example-pc", 
		[string]$propertyFile = 'propertyfile.csv', 
		[string]$dbFile = 'databases.csv'
)

Set-Location -Path "$home\Dropbox\github\tsql-snippets\powershell-sql\run_script_on_all_dbs"

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

# initial data from http://technet.microsoft.com/en-us/library/ee692794.aspx
$a = 
@{Expression={$_.DisplayName};Label="Property"},
@{Expression={$_.ConfigValue};Label="Value"}, `
@{Expression={$_.Description};Label="Description"}

[array]$sprocs

# still need to understand objects in posh and use some of the more terse syntax, I am too used to string manipulation instead of object manipulation
$sqlServer.Databases | where {$dontrun -NotContains $_} | 
	foreach $_ {			
		Write-Host $_
		foreach ($proc in $_.StoredProcedures){
			
			IF ($proc.IsSystemObject -eq $false){					
					$sprocs+=$proc.Name					
				}
			
		}
		
		
} 
ForEach-Object {$sprocs | select $_ } | out-file "items.csv"

$sqlServer.Configuration.Properties | Export-Csv $propertyFile -NoTypeInformation
$sqlServer.Databases | Export-Csv $dbFile -NoTypeInformation
