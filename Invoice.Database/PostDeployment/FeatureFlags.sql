/*
 Feature Flags Script
 Configure feature flags for the application
 Can be environment-specific
*/

-- Example: Create a feature flags table (if needed)
/*
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FeatureFlags')
BEGIN
	CREATE TABLE [dbo].[FeatureFlags]
	(
		[FeatureId] INT IDENTITY(1,1) PRIMARY KEY,
		[FeatureName] NVARCHAR(100) NOT NULL UNIQUE,
		[IsEnabled] BIT NOT NULL DEFAULT 0,
		[Description] NVARCHAR(500) NULL,
		[ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
	

END;
*/

-- Example: Set feature flags
/*
MERGE INTO [dbo].[FeatureFlags] AS Target
USING (VALUES
	('NewCheckoutFlow', 1, 'Enable new checkout process'),
	('EmailNotifications', 1, 'Send email notifications'),
	('BetaFeatures', 0, 'Enable beta features')
) AS Source (FeatureName, IsEnabled, Description)
ON Target.FeatureName = Source.FeatureName
WHEN MATCHED THEN
	UPDATE SET 
		IsEnabled = Source.IsEnabled,
		Description = Source.Description,
		ModifiedDate = GETUTCDATE()
WHEN NOT MATCHED BY TARGET THEN
	INSERT (FeatureName, IsEnabled, Description)
	VALUES (Source.FeatureName, Source.IsEnabled, Source.Description);
*/

PRINT 'Feature flags configured successfully.';
