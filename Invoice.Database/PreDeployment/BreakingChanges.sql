/*
 Breaking Changes Script
 Handle schema changes that require data migration or special handling
*/

-- Example: Rename a column
/*
IF EXISTS (SELECT 1 FROM sys.columns 
		   WHERE object_id = OBJECT_ID('dbo.Customer') 
		   AND name = 'OldColumnName')
BEGIN
	PRINT 'Renaming column OldColumnName to NewColumnName';
	EXEC sp_rename 'dbo.Customer.OldColumnName', 'NewColumnName', 'COLUMN';
END;
*/

-- Example: Migrate data before dropping a column
/*
IF EXISTS (SELECT 1 FROM sys.columns 
		   WHERE object_id = OBJECT_ID('dbo.Customer') 
		   AND name = 'FullName')
BEGIN
	PRINT 'Migrating FullName to FirstName and LastName';

	UPDATE dbo.Customer
	SET FirstName = LEFT(FullName, CHARINDEX(' ', FullName + ' ') - 1),
		LastName = SUBSTRING(FullName, CHARINDEX(' ', FullName + ' ') + 1, LEN(FullName))
	WHERE FirstName IS NULL;
END;
*/

PRINT 'Breaking changes check complete.';
