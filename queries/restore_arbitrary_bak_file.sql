-- THIS SCRIPT IS FOR NON-PRODUCTIONR RESTORES ONLY, RUN THIS IN PRODUCTION MAY BE A BAD IDEA, RUN AT YOUR OWN RISK
-- ERRORS MAY OCCUR WHEN RUNNING THIS SCRIPT, CONSIDER RUNNING THE RESTORE ON A NEW VERSION OF SQL SERVER OR VERIFYING YOUR BACKUP MEDIA

SET NOCOUNT ON;
DECLARE 
    @backup_filepath NVARCHAR(MAX)
,   @new_db_name NVARCHAR(MAX)
,   @restore_location NVARCHAR(MAX)
,   @restore_with_recovery BIT= 1;

SELECT -- set these values 
    @new_db_name = 'CHANGE ME',
    @backup_filepath = 'CHANGE ME',
    @restore_with_recovery = 1;

-- DONT CHANGE ANYTHING AFTER THIS COMMENT UNLESS YOU KNOW WHAT YOU ARE DOING. 

IF(@backup_filepath <> 'CHANGE ME'
   AND @new_db_name <> 'CHANGE ME')
    BEGIN
        DECLARE 
            @sql NVARCHAR(MAX)
        ,   @file_location_test_db_name NVARCHAR(MAX); 
    
        -- Create database so we can check where it was created, then drop it again.
        -- Other methods are posh or registry stuff, no thanks. 
        -- As we dont know the name of any database on the server dont use a potentially clashing name, use a guid!
        SET @file_location_test_db_name = CONVERT(NVARCHAR(MAX), NEWID());
        SET @sql = 'CREATE DATABASE '+QUOTENAME(@file_location_test_db_name);
        EXEC (@sql);

        SELECT @restore_location = REPLACE(s.physical_name, REVERSE(SUBSTRING(REVERSE(s.physical_name), 1, CHARINDEX('\', REVERSE(s.physical_name))-1)), '')
        FROM sys.master_files s
        WHERE file_id = 1
        AND name = @file_location_test_db_name;
        
        SET @sql = 'DROP DATABASE '+QUOTENAME(@file_location_test_db_name);
        EXEC (@sql);    

        -- Getting information back from the restore with filelistonly
        -- Remember kids, only use variable tables if you have a super low cardinality or dont care about performance    
        DECLARE @backupInfo TABLE
        (LogicalName          NVARCHAR(MAX),
         PhysicalName         NVARCHAR(MAX),
         Type                 CHAR(10),
         FileGroupName        NVARCHAR(MAX),
         Size                 NVARCHAR(MAX),
         MaxSize              NVARCHAR(MAX),
         FileId               NVARCHAR(MAX),
         CreateLSN            NVARCHAR(MAX),
         DropLSN              NVARCHAR(MAX),
         UniqueID             NVARCHAR(MAX),
         ReadOnlyLSN          NVARCHAR(MAX),
         ReadWriteLSN         NVARCHAR(MAX),
         BackupSizeInBytes    NVARCHAR(MAX),
         SourceBlockSize      NVARCHAR(MAX),
         FileGroupID          BIGINT,
         LogGroupGUID         UNIQUEIDENTIFIER,
         DifferentialBaseLSN  NVARCHAR(MAX),
         DifferentialBaseGUID NVARCHAR(MAX),
         IsReadONly           INT,
         IsPresent            INT,
         TDEThumbPrint        NVARCHAR(MAX)
        );
        SET @sql = N'RESTORE FILELISTONLY FROM DISK = '''+@backup_filepath+'''';
        INSERT INTO @backupInfo
        EXEC (@sql);

        -- Format first half of @SQL statement
        SELECT @sql = 'RESTORE DATABASE '+QUOTENAME(@new_db_name)+CHAR(10)+' FROM DISK = '''+@backup_filepath+''''+CHAR(10)+' WITH REPLACE'+CHAR(10);

        -- Do we want the db to come up or stay in recovery mode for further restores?
        IF @restore_with_recovery = 0
            SELECT @sql = @sql+', NORECOVERY'+CHAR(10);

        -- Create a CSV list of logical names so that we can move them to the default directory instead of
        --  where the original database was located
        SELECT @sql = COALESCE(@sql+',', '')+' MOVE '''+logicalname+''' TO '''+@restore_location+logicalname+SUBSTRING(PhysicalName, LEN(PhysicalName)-3, 4)+''''+CHAR(10)
        FROM @backupInfo;
    
        -- print and exec    
        PRINT @sql;
        EXEC (@SQL);
    END;
ELSE
    BEGIN
        SELECT 'Please fill out the default values in the script.';
    END;
