USE RetailDW;
GO

-- ============================================
-- Clear all data from every table
-- Order matters: child/dependent tables first,
-- then parent tables (because of Foreign Keys)
-- ============================================

DELETE FROM dbo.FactSales;

DELETE FROM dbo.stg_Customers;
DELETE FROM dbo.stg_Products;
DELETE FROM dbo.stg_Stores;
DELETE FROM dbo.stg_Sales;

DELETE FROM dbo.DimCustomer;
DELETE FROM dbo.DimProduct;
DELETE FROM dbo.DimStore;

DELETE FROM dbo.RejectedRecords;
DELETE FROM dbo.AuditLog;
DELETE FROM dbo.FileImports;
GO

-- ============================================
-- Reset identity counters back to 1
-- ============================================

DBCC CHECKIDENT ('dbo.FactSales', RESEED, 0);
DBCC CHECKIDENT ('dbo.DimCustomer', RESEED, 0);
DBCC CHECKIDENT ('dbo.DimProduct', RESEED, 0);
DBCC CHECKIDENT ('dbo.DimStore', RESEED, 0);
DBCC CHECKIDENT ('dbo.RejectedRecords', RESEED, 0);
DBCC CHECKIDENT ('dbo.AuditLog', RESEED, 0);
DBCC CHECKIDENT ('dbo.FileImports', RESEED, 0);
GO