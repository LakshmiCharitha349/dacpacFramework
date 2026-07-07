/*
 Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
			   SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

PRINT 'Starting Post-Deployment...';

-- Reference Data (always run)
PRINT 'Loading reference data...';
:r .\ReferenceData.sql

-- Test Data (development environment only)
IF '$(Environment)' = 'development'
BEGIN
	PRINT 'Loading test data for development environment...';
	:r .\TestData.sql
END
ELSE
BEGIN
	PRINT 'Skipping test data (not in development environment).';
END;

-- Feature Flags
PRINT 'Configuring feature flags...';
:r .\FeatureFlags.sql

PRINT 'Post-Deployment Complete.';
