USE AdventureWorks2012

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'u_findColumn') 
	DROP PROCEDURE [dbo].[u_findColumn]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	Example usage:
		EXEC dbo.u_findcolumn '%sales%'
*/
CREATE PROC [dbo].[u_findColumn]
		@partialname NVARCHAR(128)
AS
	BEGIN
	SELECT	sc.name				[ColumnName]
			, t.name			[Type]			
			, CASE 
				sc.is_nullable	
				WHEN 1 THEN 'True'
				WHEN 0 THEN 'False'
			  END
			[Nullable]			
			, sc.max_length		[Length]
			, sc.precision		[Precision]							
			, ss.name			[SchemaName]
			, st.name			[TableName]	
	FROM sys.columns sc
	INNER JOIN sys.tables st	ON sc.object_id = st.object_id
	INNER JOIN sys.schemas ss	ON ss.schema_id = st.schema_id
	INNER JOIN sys.types t		ON t.user_type_id = sc.user_type_id
	WHERE sc.name like @partialname
END


