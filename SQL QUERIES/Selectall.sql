USE RetailDW;
GO

-- ============================================
-- Dimension Tables
-- ============================================
SELECT * FROM dbo.DimCustomer;
SELECT * FROM dbo.DimProduct;
SELECT * FROM dbo.DimStore;

-- ============================================
-- Fact Table
-- ============================================
SELECT * FROM dbo.FactSales;

-- ============================================
-- Staging Tables
-- ============================================
SELECT * FROM dbo.stg_Customers;
SELECT * FROM dbo.stg_Products;
SELECT * FROM dbo.stg_Stores;
SELECT * FROM dbo.stg_Sales;

-- ============================================
-- Rejected Records
-- ============================================
SELECT * FROM dbo.RejectedRecords;

-- ============================================
-- Audit Log
-- ============================================
SELECT * FROM dbo.AuditLog ORDER BY AuditID;

-- ============================================
-- File Imports
-- ============================================
SELECT * FROM dbo.FileImports ORDER BY FileImportID;


