# SQL Server DacFx/SqlPackage Implementation Plan

---

## ✅ **CI/CD with GitHub Actions - COMPLETED!**

### 🎉 **GitHub Actions Setup Summary:**

**What Was Accomplished:**
1. ✅ Created GitHub account and repository: `DacpacFramework`
2. ✅ Initialized Git repository locally
3. ✅ Created .gitignore for Visual Studio and SQL projects
4. ✅ Pushed Invoice.Database code to GitHub
5. ✅ Created GitHub Actions workflow: `.github/workflows/deploy.yml`
6. ✅ Configured automated build pipeline
7. ✅ First automated build triggered successfully

**GitHub Actions Workflow:**
- **Trigger:** Automatic on push to `main` branch
- **Runner:** Windows latest
- **Build Steps:**
  1. Checkout code from GitHub
  2. Setup MSBuild
  3. Build Invoice.Database.sqlproj
  4. Verify .dacpac created
  5. Upload .dacpac as artifact (stored 30 days)

**Repository URL:**
```
https://github.com/YOUR-USERNAME/DacpacFramework
```

**View Workflows:**
```
https://github.com/YOUR-USERNAME/DacpacFramework/actions
```

**Key Files Created:**
- `.gitignore` - Excludes build outputs and temp files
- `.github/workflows/deploy.yml` - CI/CD pipeline configuration

**What Happens on Every Push:**
1. Developer pushes code to GitHub
2. GitHub Actions detects changes
3. Workflow automatically starts
4. MSBuild compiles .sqlproj
5. .dacpac artifact created and stored
6. You get email notification of success/failure

**Next Steps (Optional):**
- Add deployment stage to deploy to Azure SQL Database
- Add approval gates for production deployments
- Add database testing stage
- Configure branch protection rules

---

## 📚 **Key Concepts Learned:**

1. MSBuild - Takes configuration files (.sqlproj) and creates artifacts (.dacpac)
2. SqlPackage - Deploys .dacpac files to SQL Server
3. .dacpac files - Deployable database packages
4. Pre/Post Deployment Scripts - Execute code before/after schema changes
5. SQLCMD Variables - Environment-specific configuration (Environment=development)
6. Reference Data - Production data loaded via MERGE (idempotent)
7. Test Data - Development-only data loaded conditionally
8. **CI/CD Pipeline** - Automated build, test, and deployment
9. **GitHub Actions** - CI/CD platform integrated with GitHub
10. **Artifacts** - Build outputs stored and versioned

---

## ✅ **STEP 3: Build and Deploy - COMPLETED!**

### 🎉 **Deployment Summary:**

**Date Completed:** [Today's Date]

**What Was Accomplished:**
1. ✅ Built Invoice.Database.sqlproj using MSBuild
2. ✅ Generated Invoice.Database.dacpac artifact (50+ KB)
3. ✅ Installed SqlPackage as .NET global tool
4. ✅ Deployed .dacpac to LocalDB: `(localdb)\MSSQLLocalDB`
5. ✅ Created **InvoiceDB** database successfully

**Database Objects Created:**
- ✅ 2 Tables: Customer, Order
- ✅ 3 Stored Procedures: usp_GetCustomers, usp_InsertCustomer, usp_UpdateCustomer
- ✅ 1 View: vw_CustomerOrders
- ✅ 1 User-Defined Type: CustomerTableType

**Data Loaded:**
- ✅ Reference Data: 3 customers (ACME Corp, TechStart Inc, Global Solutions)
- ✅ Test Data: 5 test customers + 4 test orders (development environment)

**Connection String Used:**
```
Server=(localdb)\MSSQLLocalDB;Database=InvoiceDB;Integrated Security=True;
```

**Verification Tests Passed:**
- ✅ Database exists and is ONLINE
- ✅ Tables created successfully
- ✅ Stored procedures created successfully
- ✅ Data loaded correctly
- ✅ usp_GetCustomers executed successfully

**Key Commands Used:**
```powershell
# Build
msbuild Invoice.Database\Invoice.Database.sqlproj /p:Configuration=Release

# Deploy
sqlpackage /Action:Publish /SourceFile:Invoice.Database\bin\Release\Invoice.Database.dacpac /TargetServerName:(localdb)\MSSQLLocalDB /TargetDatabaseName:InvoiceDB /Variables:Environment=development
```

**Next Steps:** See STEP 4 below for SQLCMD Variables, STEP 5 for Advanced Deployment, STEP 6 for MSBuild Orchestration

---

## Quick Verification Commands

### Verify Database
```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -Q "SELECT name AS DatabaseName, state_desc AS State, create_date AS Created FROM sys.databases WHERE name = 'InvoiceDB'"
```

### Verify Tables
```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -d "InvoiceDB" -Q "SELECT TABLE_SCHEMA + '.' + TABLE_NAME AS TableName, TABLE_TYPE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_NAME"
```

### Test Stored Procedure
```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -d "InvoiceDB" -Q "EXEC dbo.usp_GetCustomers"
```

---

# SQL Server DacFx/SqlPackage Implementation Plan

## STEP 1: Installing SSDT and SQL Server

### Part A: Install SQL Server Data Tools (SSDT)

**1. Open Visual Studio Installer**
- Close Visual Studio if open
- Press Windows key → Type "Visual Studio Installer" → Launch it

**2. Modify Your VS 2026 Installation**
- Click **"Modify"** button next to Visual Studio Enterprise 2026

**3. Install Required Workloads**
Under **Workloads** tab:
- ☑ **"Data storage and processing"** (includes SSDT)
- ☑ **"ASP.NET and web development"** (already installed)

Under **Individual components** tab, search and verify:
- ☑ **"SQL Server Data Tools"**
- ☑ **"SQL Server integration"**  
- ☑ **"LocalDB"** (under Database engines section)

**4. Click "Modify"** and wait (5-15 minutes)

**5. Restart Visual Studio**

---

### Part B: Install SQL Server Express 2022 or LocalDB

**Option 1: SQL Server Express 2022 (Recommended)**
1. Download: https://www.microsoft.com/en-us/sql-server/sql-server-downloads
2. Click **"Download now"** under **Express** edition (free)
3. Run installer → Choose **"Basic"** installation
4. Accept license → Choose location → Click **Install** (5-10 minutes)
5. Note the **Connection String** shown at the end
6. Optional: Install **SSMS** (SQL Server Management Studio) if prompted

**Option 2: LocalDB (Lightweight - may already be installed)**
- LocalDB should be installed with SSDT
- We'll verify in next section

---

### Part C: Verify SSDT Installation

**Restart Visual Studio**, then:
1. **File** → **New** → **Project**
2. Search: **"SQL Server"**
3. ✅ You should see: **"SQL Server Database Project"** template

If you see this template → **SSDT is installed correctly!**

---

### Part D: Verify SQL Server Installation

**Open PowerShell Terminal in VS** (Ctrl+` or View → Terminal)

**For LocalDB:**
```powershell
# Check if LocalDB is installed
sqllocaldb info

# Start the default instance
sqllocaldb start MSSQLLocalDB

# Test connection
sqlcmd -S "(localdb)\MSSQLLocalDB" -Q "SELECT @@VERSION"
```

**For SQL Server Express:**
```powershell
# Test connection
sqlcmd -S "localhost\SQLEXPRESS" -Q "SELECT @@VERSION"
```

**Expected Output:**
```
Microsoft SQL Server 2022 (RTM) - 16.0.1000.6 (X64)
...
(1 rows affected)
```

---

### Part E: Troubleshooting

**If sqlcmd is not found:**
```powershell
# Add SQL tools to PATH
$env:Path += ";C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn"
# Or restart terminal
```

**If LocalDB won't start:**
```powershell
sqllocaldb delete MSSQLLocalDB
sqllocaldb create MSSQLLocalDB
sqllocaldb start MSSQLLocalDB
```

---

### ✅ STEP 1 Checklist

Before proceeding, confirm:
- [ ] Visual Studio has "Data storage and processing" workload
- [ ] SQL Server Database Project template exists in VS
- [ ] SQL Server Express OR LocalDB installed
- [ ] `sqlcmd` command works and returns version info

**Once all items are checked, reply "step 1 complete" to proceed to Step 2!**

---

## STEP 2: Create Database Project & Structure

**✅ COMPLETED - Project Created!**

### What Was Created:
- ✅ Project renamed to: **Invoice.Database**
- ✅ Folder structure created
- ✅ Database objects added:
  - 2 Tables: Customer, Order
  - 3 Stored Procedures: usp_GetCustomers, usp_InsertCustomer, usp_UpdateCustomer
  - 1 View: vw_CustomerOrders
  - 1 User-Defined Type: CustomerTableType
- ✅ Pre-Deployment scripts configured
- ✅ Post-Deployment scripts with reference data and test data
- ✅ SQLCMD Variables configured: Environment, TargetDatabaseName, BackupEnabled

**Next Step: Build and test the project!**

---

## STEP 2 ORIGINAL GUIDE: Create Database Project & Structure

### Create Project
- File → New → Project → SQL Server Database Project
- Name: `Invoice.Database`
- Location: `C:\Users\gsm416\workspace\DacpacFramework\`

### Folder Structure
```
Invoice.Database/
├── Security/
├── dbo/
│   ├── Tables/
│   ├── Stored Procedures/
│   ├── Views/
│   ├── Functions/
│   └── User Defined Types/
├── PreDeployment/
│   ├── Script.PreDeployment.sql
│   └── BreakingChanges.sql
├── PostDeployment/
│   ├── Script.PostDeployment.sql
│   ├── ReferenceData.sql
│   ├── TestData.sql
│   └── FeatureFlags.sql
└── Build/
```

### Sample Objects

**File: dbo/Tables/Customer.sql**

**File: dbo/Tables/Order.sql**
**File: dbo/Stored Procedures/usp_GetCustomers.sql**

**File: dbo/Stored Procedures/usp_InsertCustomer.sql**
**File: dbo/Views/vw_CustomerOrders.sql**

## STEP 3: Pre/Post Deployment Scripts

### PreDeploy Script
**File: PreDeployment/Script.PreDeployment.sql**
- Set Build Action: **PreDeploy**
```sql
/*
 Pre-Deployment Script
 This file is executed before the main deployment
*/
PRINT 'Starting Pre-Deployment...';

-- Include breaking changes
:r .\BreakingChanges.sql

PRINT 'Pre-Deployment Complete.';
```

**File: PreDeployment/BreakingChanges.sql**
```sql
-- Handle breaking changes here
-- Example: Rename column, split data, etc.
/*
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'OldColumnName')
BEGIN
	EXEC sp_rename 'dbo.Customer.OldColumnName', 'NewColumnName', 'COLUMN';
END;
*/
```

### PostDeploy Script
**File: PostDeployment/Script.PostDeployment.sql**
- Set Build Action: **PostDeploy**
```sql
/*
 Post-Deployment Script
 This file is executed after the main deployment
*/
PRINT 'Starting Post-Deployment...';

-- Reference Data (always)
:r .\ReferenceData.sql

-- Test Data (dev only)
IF '$(Environment)' = 'development'
BEGIN
	PRINT 'Loading test data...';
	:r .\TestData.sql
END;

-- Feature Flags
:r .\FeatureFlags.sql

PRINT 'Post-Deployment Complete.';
```

**File: PostDeployment/ReferenceData.sql**
```sql
-- Idempotent reference data using MERGE
MERGE INTO [dbo].[Customer] AS Target
USING (VALUES
	(1, 'ACME Corp', 'info@acme.com'),
	(2, 'TechStart Inc', 'contact@techstart.com')
) AS Source (CustomerId, CustomerName, Email)
ON Target.CustomerId = Source.CustomerId
WHEN MATCHED THEN
	UPDATE SET CustomerName = Source.CustomerName, Email = Source.Email
WHEN NOT MATCHED BY TARGET THEN
	INSERT (CustomerName, Email) VALUES (Source.CustomerName, Source.Email);
```

**File: PostDeployment/TestData.sql**
```sql
-- Test data for development only
IF NOT EXISTS (SELECT 1 FROM [dbo].[Customer] WHERE CustomerName = 'Test Customer 1')
BEGIN
	INSERT INTO [dbo].[Customer] (CustomerName, Email)
	VALUES ('Test Customer 1', 'test1@example.com'),
		   ('Test Customer 2', 'test2@example.com');
END;
```

**File: PostDeployment/FeatureFlags.sql**
```sql
-- Feature flags table and data
-- (Create table in main schema, populate here)
PRINT 'Feature flags configured.';
```

---

## STEP 4: SQLCMD Variables

### Method 1: Visual Studio UI
1. Right-click project → Properties
2. Go to **SQLCMD Variables** tab
3. Add variables:
   - `Environment` = `development`
   - `TargetDatabaseName` = `InvoiceDB`
   - `BackupEnabled` = `False`

### Method 2: Edit .sqlproj Directly
```xml
<ItemGroup>
  <SqlCmdVariable Include="Environment">
	<DefaultValue>development</DefaultValue>
  </SqlCmdVariable>
  <SqlCmdVariable Include="TargetDatabaseName">
	<DefaultValue>InvoiceDB</DefaultValue>
  </SqlCmdVariable>
  <SqlCmdVariable Include="BackupEnabled">
	<DefaultValue>False</DefaultValue>
  </SqlCmdVariable>
</ItemGroup>
```

### Method 3: PowerShell Deployment
```powershell
SqlPackage /Action:Publish /SourceFile:Invoice.Database.dacpac `
  /TargetServerName:(localdb)\MSSQLLocalDB `
  /TargetDatabaseName:InvoiceDB `
  /Variables:Environment=development
```

### Use Variables in SQL
```sql
IF '$(Environment)' = 'production'
BEGIN
	PRINT 'Production mode';
END
ELSE
BEGIN
	PRINT 'Non-production mode';
END;
```

### Test Variables Script
**File: TestVariables.sql**
```sql
PRINT 'Environment: $(Environment)';
PRINT 'Database: $(TargetDatabaseName)';
PRINT 'Backup Enabled: $(BackupEnabled)';
```

---

## STEP 5: Build & Deploy

### Build .dacpac
```powershell
# In project directory
msbuild Invoice.Database.sqlproj /p:Configuration=Release

# Output: bin\Release\Invoice.Database.dacpac
```

### Deploy via Visual Studio
1. Right-click project → **Publish**
2. Edit connection → Server: `(localdb)\MSSQLLocalDB`
3. Database: `InvoiceDB`
4. Click **Publish**

### Deploy via PowerShell
```powershell
# Set variables
$dacpacPath = ".\bin\Release\Invoice.Database.dacpac"
$serverName = "(localdb)\MSSQLLocalDB"
$databaseName = "InvoiceDB"

# Deploy using SqlPackage
SqlPackage /Action:Publish `
  /SourceFile:$dacpacPath `
  /TargetServerName:$serverName `
  /TargetDatabaseName:$databaseName `
  /Variables:Environment=development
```

### Verify Deployment
```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -d InvoiceDB -Q "SELECT name FROM sys.tables"
sqlcmd -S "(localdb)\MSSQLLocalDB" -d InvoiceDB -Q "EXEC usp_GetCustomers"
```

---

## STEP 6: MSBuild Orchestration Project

### Create Orchestration Project
```powershell
dotnet new console -n Invoice.Database.Deploy -f net10.0
cd Invoice.Database.Deploy
dotnet add package Microsoft.SqlServer.DacFx --version 162.4.92
```

### File: Deploy.proj (MSBuild)
```xml
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup>
	<Environment Condition="'$(Environment)'==''">development</Environment>
	<ServerName Condition="'$(ServerName)'==''">localhost\SQLEXPRESS</ServerName>
	<DatabaseName Condition="'$(DatabaseName)'==''">InvoiceDB</DatabaseName>
	<DacpacPath>..\Invoice.Database\bin\$(Configuration)\Invoice.Database.dacpac</DacpacPath>
  </PropertyGroup>

  <Target Name="Build">
	<MSBuild Projects="..\Invoice.Database\Invoice.Database.sqlproj" Properties="Configuration=$(Configuration)" />
  </Target>

  <Target Name="Deploy" DependsOnTargets="Build">
	<Exec Command="SqlPackage /Action:Publish /SourceFile:$(DacpacPath) /TargetServerName:$(ServerName) /TargetDatabaseName:$(DatabaseName) /Variables:Environment=$(Environment)" />
  </Target>

  <Target Name="DeployTwice" DependsOnTargets="Deploy">
	<Message Text="Running deployment second time for idempotency..." />
	<Exec Command="SqlPackage /Action:Publish /SourceFile:$(DacpacPath) /TargetServerName:$(ServerName) /TargetDatabaseName:$(DatabaseName) /Variables:Environment=$(Environment)" />
  </Target>
</Project>
```

### Execute Deployment
```powershell
# Build and deploy
msbuild Deploy.proj /t:Deploy /p:Configuration=Release /p:Environment=development

# Deploy twice (idempotency test)
msbuild Deploy.proj /t:DeployTwice /p:Configuration=Release /p:Environment=development
```

---

## Quick Reference Commands

```powershell
# Build
msbuild Invoice.Database.sqlproj /p:Configuration=Release

# Deploy
SqlPackage /Action:Publish /SourceFile:Invoice.Database.dacpac /TargetServerName:(localdb)\MSSQLLocalDB /TargetDatabaseName:InvoiceDB

# Generate Script (no deploy)
SqlPackage /Action:Script /SourceFile:Invoice.Database.dacpac /TargetServerName:(localdb)\MSSQLLocalDB /TargetDatabaseName:InvoiceDB /OutputPath:deploy.sql

# Extract existing database to .dacpac
SqlPackage /Action:Extract /SourceServerName:(localdb)\MSSQLLocalDB /SourceDatabaseName:InvoiceDB /TargetFile:InvoiceDB.dacpac

# Generate diff report
SqlPackage /Action:DeployReport /SourceFile:Invoice.Database.dacpac /TargetServerName:(localdb)\MSSQLLocalDB /TargetDatabaseName:InvoiceDB /OutputPath:report.xml
```

---

## Troubleshooting

### SqlPackage not found
```powershell
# Add to PATH or use full path
$env:Path += ";C:\Program Files\Microsoft SQL Server\160\DAC\bin"
```

### Connection issues
```powershell
# Test connection
sqlcmd -S "(localdb)\MSSQLLocalDB" -Q "SELECT @@VERSION"

# Restart LocalDB
sqllocaldb stop MSSQLLocalDB
sqllocaldb start MSSQLLocalDB
```

### Build errors
- Ensure .sqlproj has correct DSP (Database Schema Provider)
- Check circular dependencies
- Verify all files have Build Action set correctly

---

**END OF PLAN**
