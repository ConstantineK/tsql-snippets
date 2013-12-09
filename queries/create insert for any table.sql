-- Change to the name of the object you would like to generate an insert statement for
DECLARE @GenerateObject nVarchar(128) = 'Products'		



SELECT		TOP 1 
			'INSERT ' + so.name + ' (' + STUFF(d.name,1,1,'')+ ')' [ConcatedList]			
FROM		sys.objects so
INNER JOIN	sys.columns sc ON so.object_id = sc.object_id
CROSS APPLY (
		SELECT ',' +scc.name 
		FROM sys.columns scc
		WHERE scc.object_id = sc.object_id
		ORDER BY scc.name
		FOR XML PATH('')
) d (name)
where		@GenerateObject = so.name
ORDER BY sc.name