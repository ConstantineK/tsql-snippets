USE AdventureWorks2012

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'u_findtable') 
	DROP PROCEDURE dbo.u_findtable
GO

/*
	Example usage:
		EXEC dbo.u_findtable '%TransactionHistoryA%'
*/
CREATE PROC dbo.u_findtable
		@partialName NVARCHAR(128)
AS
	BEGIN
	SELECT	
			 ss.name+'.'+st.name	[fqTableName]	
	INTO #results
	FROM sys.tables st
	INNER JOIN sys.schemas ss ON ss.schema_id = st.schema_id
	WHERE st.name like @partialname
	
	
	DECLARE @resultCount INT = (SELECT COUNT(*) FROM #results)

	IF @resultCount = 0
	BEGIN
		SELECT 'No Tables Found'
	END
	IF @resultCount =1 
	BEGIN
		DECLARE @name NVARCHAR(128) = (SELECT r.[fqTableName] FROM #results r )
		EXEC sp_help @name
	END
	IF @resultCount > 1
	BEGIN
		SELECT [fqTableName]
		FROM #results
	END

END



