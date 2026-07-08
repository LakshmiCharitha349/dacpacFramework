# SQL Server Database Deployment - Complete Steps

## What We Accomplished
Implemented SQL Server database deployments using DacFx/SqlPackage with automated CI/CD pipeline using GitHub Actions.

---

## Prerequisites Installed

### Software Already Available
- ✅ Visual Studio Enterprise 2026 (18.7.3)
- ✅ SQL Server 2025 Express with LocalDB
- ✅ PowerShell 7
- ✅ Git (for version control)
- ✅ GitHub account

### Tools We Installed
1. **SqlPackage** (.NET global tool)
   ```powershell
   dotnet tool install -g microsoft.sqlpackage
   ```

---

## STEP 1: Verify Installation

### Check LocalDB
```powershell
sqllocaldb info
sqllocaldb start MSSQLLocalDB
sqlcmd -S "(localdb)\MSSQLLocalDB" -Q "SELECT @@VERSION"
```

### Verify SSDT
- File → New → Project → Search "SQL Server Database Project" (template exists = SSDT installed)

---

## STEP 2: Create Database Project

### Create SQL Server Database Project
1. Created project named: **Invoice.Database**
2. Location: `C:\Users\gsm416\workspace\DacpacFramework\`
3. Targeting: SQL Server 2022

### Created Folder Structure
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
├── PostDeployment/
└── Build/
```

### Created Database Objects

**Tables:**
- `dbo/Tables/Customer.sql` - CustomerId (PK), CustomerName, Email, CreatedDate, ModifiedDate
- `dbo/Tables/Order.sql` - OrderId (PK), CustomerId (FK), OrderNumber, OrderDate, TotalAmount, Status

**Stored Procedures:**
- `dbo/Stored Procedures/usp_GetCustomers.sql` - Retrieve all customers
- `dbo/Stored Procedures/usp_InsertCustomer.sql` - Add new customer
- `dbo/Stored Procedures/usp_UpdateCustomer.sql` - Update existing customer

**Views:**
- `dbo/Views/vw_CustomerOrders.sql` - Join Customer and Order tables

**User-Defined Types:**
- `dbo/User Defined Types/CustomerTableType.sql` - Table type for bulk operations

### Created Pre-Deployment Scripts

**PreDeployment/Script.PreDeployment.sql** (Build Action: PreDeploy)
- Main pre-deployment script
- Includes BreakingChanges.sql

**PreDeployment/BreakingChanges.sql**
- Handle schema changes and data migrations

### Created Post-Deployment Scripts

**PostDeployment/Script.PostDeployment.sql** (Build Action: PostDeploy)
- Main post-deployment script
- Includes ReferenceData.sql (always)
- Includes TestData.sql (if Environment=development)
- Includes FeatureFlags.sql

**PostDeployment/ReferenceData.sql**
- Idempotent MERGE statements for production reference data
- Loads: ACME Corp, TechStart Inc, Global Solutions LLC

**PostDeployment/TestData.sql**
- Test data for development environment only
- Loads 5 test customers and 4 test orders

**PostDeployment/FeatureFlags.sql**
- Feature flag configuration

### Added SQLCMD Variables

Added to Invoice.Database.sqlproj:
- `Environment` = `development`
- `TargetDatabaseName` = `InvoiceDB`
- `BackupEnabled` = `False`

---

## STEP 3: Build and Deploy

### Build the Project

**Find MSBuild:**
```powershell
$msbuild = & "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe | Select-Object -First 1
```

**Build .sqlproj:**
```powershell
& $msbuild Invoice.Database\Invoice.Database.sqlproj /p:Configuration=Release /v:minimal
```

**Output:** `Invoice.Database\bin\Release\Invoice.Database.dacpac`

### Install SqlPackage

```powershell
dotnet tool install -g microsoft.sqlpackage
```

### Deploy to LocalDB

```powershell
sqlpackage /Action:Publish `
  /SourceFile:"Invoice.Database\bin\Release\Invoice.Database.dacpac" `
  /TargetServerName:"(localdb)\MSSQLLocalDB" `
  /TargetDatabaseName:"InvoiceDB" `
  /p:IncludeCompositeObjects=True `
  /Variables:Environment=development
```

### Verify Deployment

**Check database exists:**
```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -Q "SELECT name, state_desc FROM sys.databases WHERE name = 'InvoiceDB'"
```

**Check tables:**
```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -d "InvoiceDB" -Q "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES"
```

**Check stored procedures:**
```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -d "InvoiceDB" -Q "SELECT name FROM sys.procedures"
```

**Test stored procedure:**
```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -d "InvoiceDB" -Q "EXEC dbo.usp_GetCustomers"
```

---

## STEP 4: Setup CI/CD with GitHub Actions

### Initialize Git Repository

```powershell
# Initialize Git
git init

# Configure identity
git config user.email "your-email@example.com"
git config user.name "Your Name"

# Create main branch
git branch -M main
```

### Create .gitignore

Created `.gitignore` file to exclude:
- Build outputs (bin/, obj/, *.dacpac)
- Visual Studio files (.vs/, *.user)
- Temporary files

### Commit and Push to GitHub

```powershell
# Add files
git add .

# Commit
git commit -m "Initial commit: Invoice.Database project"

# Add remote (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/DacpacFramework.git

# Push to GitHub
git push -u origin main
```

### Create GitHub Actions Workflow

Created `.github/workflows/deploy.yml`:

**Triggers:**
- On push to main branch
- Manual trigger (workflow_dispatch)

**Jobs:**
1. **Build Job:**
   - Checkout code
   - Setup MSBuild
   - Build Invoice.Database.sqlproj
   - Verify .dacpac created
   - Upload .dacpac as artifact (stored 30 days)

### Push Workflow to GitHub

```powershell
# Add workflow
git add .github/

# Commit
git commit -m "Add GitHub Actions CI/CD workflow"

# Push (triggers first automated build)
git push origin main
```

---

## Final Result

### Local Development
- ✅ InvoiceDB database deployed to LocalDB
- ✅ All tables, stored procedures, views created
- ✅ Reference data and test data loaded
- ✅ Manual build and deploy commands documented

### CI/CD Pipeline
- ✅ Code version controlled in GitHub
- ✅ Automated build on every push
- ✅ .dacpac artifact created and stored
- ✅ Build status visible in GitHub Actions tab

### Connection String
```
Server=(localdb)\MSSQLLocalDB;Database=InvoiceDB;Integrated Security=True;
```

---

## Key Commands Reference

### Build
```powershell
msbuild Invoice.Database\Invoice.Database.sqlproj /p:Configuration=Release
```

### Deploy
```powershell
sqlpackage /Action:Publish /SourceFile:Invoice.Database.dacpac /TargetServerName:(localdb)\MSSQLLocalDB /TargetDatabaseName:InvoiceDB /Variables:Environment=development
```

### Query Database
```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -d "InvoiceDB" -Q "SELECT * FROM Customer"
```

### Git Push (Triggers CI/CD)
```powershell
git add .
git commit -m "Your message"
git push origin main
```

---

## What We Learned

1. **MSBuild** - Compiles .sqlproj and creates .dacpac artifacts
2. **SqlPackage** - Deploys .dacpac files to SQL Server
3. **.dacpac** - Deployable database package (schema only)
4. **Pre/Post Deployment Scripts** - Execute before/after schema changes
5. **SQLCMD Variables** - Environment-specific configuration
6. **CI/CD Pipeline** - Automated build and deployment
7. **GitHub Actions** - Cloud-based CI/CD platform
8. **Git Version Control** - Track database schema changes

---

**END OF STEPS**
