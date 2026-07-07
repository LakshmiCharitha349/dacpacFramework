/*
 Reference Data Script
 Idempotent reference data using MERGE statements
 Safe to run multiple times
*/

-- Merge Customer reference data
MERGE INTO [dbo].[Customer] AS Target
USING (VALUES
	(1, 'ACME Corporation', 'contact@acme.com', '2024-01-01'),
	(2, 'TechStart Inc', 'info@techstart.com', '2024-01-01'),
	(3, 'Global Solutions LLC', 'hello@globalsolutions.com', '2024-01-01')
) AS Source (CustomerId, CustomerName, Email, CreatedDate)
ON Target.CustomerId = Source.CustomerId
WHEN MATCHED THEN
	UPDATE SET 
		CustomerName = Source.CustomerName,
		Email = Source.Email
WHEN NOT MATCHED BY TARGET THEN
	INSERT (CustomerName, Email, CreatedDate)
	VALUES (Source.CustomerName, Source.Email, Source.CreatedDate);

PRINT 'Reference data loaded successfully.';
