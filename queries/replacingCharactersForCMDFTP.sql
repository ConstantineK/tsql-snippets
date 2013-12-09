DECLARE @replaceCode		nvarchar(max), 
		@paramDef			nvarchar(max), 
		@String				nvarchar(max),
		@variable			nvarchar(max)

SET @replaceCode = N'SELECT @String = REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
							REPLACE(
						@String
						,''^'',''^^'')
						,''%'',''%%'')
						,''&'',''^&'')	 
						,''<'',''^<'')	 
						,''>'',''^>'')	 
						,''|'',''^|'')	 
						,'''''''',''^'''''')	 
						,''`'',''^`'')	 
						,'','',''^,'')	 
						,'';'',''^;'')	 
						,''='',''^='')	 
						,''('',''^('')	 
						,'')'',''^)'')	 
						,''!'',''^^!'')	 
						,''\'',''\\'')	 
						,''['',''\['')	 
						,'']'',''\]'')	 
						,''"'',''^&'')'
SET @paramdef = N'@String NVARCHAR(MAX) OUTPUT'
SET @String = 'test&ham$haha*^'''
EXEC sp_executesql @replaceCode, @paramdef, @String = @String OUTPUT
SELECT @String
