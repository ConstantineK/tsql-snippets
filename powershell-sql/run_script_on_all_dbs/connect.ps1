$serverName = "example-pc"
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
# this is dirty, but it means when I run it the variable is available in the posh session, so I run this file and then do what I want
New-Variable  -name "sqlServer" -Value $(new-object ("Microsoft.SqlServer.Management.Smo.Server") $serverName) -scope global
