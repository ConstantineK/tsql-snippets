<#
	Idea:
		Make it easy to export reports and get dependent stored procedures exported as well
		
		1. Take a path and a report server as params
		2. Get the XML data for the report and save it as an RDL file into a folder
		4. Scan the XML data for the command text and find the stored procedure
		5. Check the datasource for the report for which database it is pointing at, or get it from a param
		6. Get the stored procedure text and save it as a file in the same folder
		7. Success! (optionally, zip it all up)
		

#>

<#

	Query to get the XML data for a report (at least on a native mode 2008R2 server):
	
	DECLARE @name NVARCHAR(MAX)='ChartReport',
			@path NVARCHAR(MAX) = '/ChartReport'

	SELECT CAST(CAST(c.Content AS VARBINARY(MAX)) AS XML) [ReportData], c.Name, c.Path
	FROM ReportServer.dbo.Catalog c
	WHERE 	c.Name = @name
	AND		c.Path	LIKE @path+'%'
	

#>
param (
	$server,
	$title,
	$saveloc="$home\savedata\filename.test",
	$zipopt
)

Import-Module 'sqlps'

$dataquery = @"
		DECLARE @name NVARCHAR(MAX)='ChartReport',
				@path NVARCHAR(MAX) = '/ChartReport'

	SELECT CAST(CAST(c.Content AS VARBINARY(MAX)) AS XML) [ReportData], c.Name, c.Path
	FROM ReportServer.dbo.Catalog c
	WHERE 	c.Name = @name
	AND c.Path	LIKE @path+'%'
"@

Invoke-SQLCMD -Query $dataquery |  Export-Clixml $saveloc 