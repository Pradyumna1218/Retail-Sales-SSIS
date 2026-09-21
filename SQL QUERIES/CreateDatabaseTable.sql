CREATE DATABASE RetailDW;
GO

USE RetailDW;
GO

CREATE TABLE dbo.DimCustomer (
    CustomerKey     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,   -- surrogate key
    CustomerID      VARCHAR(10)       NOT NULL,               -- business key from source file
    CustomerName    VARCHAR(100)      NOT NULL,
    Email           VARCHAR(100)      NULL,
    City            VARCHAR(50)       NULL,
    State           VARCHAR(50)       NULL,
    CreatedDate     DATETIME          NOT NULL DEFAULT GETDATE(),
    ModifiedDate    DATETIME          NOT NULL DEFAULT GETDATE(),

    CONSTRAINT UQ_DimCustomer_CustomerID UNIQUE (CustomerID)
);
GO

CREATE TABLE dbo.DimProduct (
    ProductKey      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,   -- surrogate key
    ProductID       VARCHAR(10)       NOT NULL,               -- business key from source file
    ProductName     VARCHAR(100)      NOT NULL,
    Category        VARCHAR(50)       NULL,
    Price           DECIMAL(12,2)     NOT NULL,
    CreatedDate     DATETIME          NOT NULL DEFAULT GETDATE(),
    ModifiedDate    DATETIME          NOT NULL DEFAULT GETDATE(),

    CONSTRAINT UQ_DimProduct_ProductID UNIQUE (ProductID)
);
GO

CREATE TABLE dbo.DimStore (
    StoreKey        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,   -- surrogate key
    StoreID         VARCHAR(10)       NOT NULL,               -- business key from source file
    StoreName       VARCHAR(100)      NOT NULL,
    City            VARCHAR(50)       NULL,
    State           VARCHAR(50)       NULL,

    CONSTRAINT UQ_DimStore_StoreID UNIQUE (StoreID)
);
GO

-- ============================================
-- Fact Table
-- ============================================

CREATE TABLE dbo.FactSales (
    SalesKey        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,   -- surrogate key
    SaleID          INT               NOT NULL,               -- business key from source file
    SaleDate        DATE              NOT NULL,
    CustomerKey     INT               NOT NULL,
    ProductKey      INT               NOT NULL,
    StoreKey        INT               NOT NULL,
    Quantity        INT               NOT NULL,
    UnitPrice       DECIMAL(12,2)     NOT NULL,
    TotalAmount     AS (Quantity * UnitPrice) PERSISTED,
    LoadDate        DATETIME          NOT NULL DEFAULT GETDATE(),

    CONSTRAINT UQ_FactSales_SaleID UNIQUE (SaleID),   -- enforces no duplicate sales transactions
    CONSTRAINT FK_FactSales_Customer FOREIGN KEY (CustomerKey) REFERENCES dbo.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_Product  FOREIGN KEY (ProductKey)  REFERENCES dbo.DimProduct(ProductKey),
    CONSTRAINT FK_FactSales_Store    FOREIGN KEY (StoreKey)    REFERENCES dbo.DimStore(StoreKey)
);
GO



CREATE TABLE dbo.stg_Customers (
    CustomerID      VARCHAR(50)     NULL,
    CustomerName    VARCHAR(200)    NULL,
    Email           VARCHAR(200)    NULL,
    City            VARCHAR(100)    NULL,
    State           VARCHAR(100)    NULL,
    SourceFileName  VARCHAR(255)    NULL,
    LoadedDate      DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.stg_Products (
    ProductID       VARCHAR(50)     NULL,
    ProductName     VARCHAR(200)    NULL,
    Category        VARCHAR(100)    NULL,
    Price           VARCHAR(50)     NULL,
    SourceFileName  VARCHAR(255)    NULL,
    LoadedDate      DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.stg_Stores (
    StoreID         VARCHAR(50)     NULL,
    StoreName       VARCHAR(200)    NULL,
    City            VARCHAR(100)    NULL,
    State           VARCHAR(100)    NULL,
    SourceFileName  VARCHAR(255)    NULL,
    LoadedDate      DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.stg_Sales (
    SaleID          VARCHAR(50)     NULL,
    SaleDate        VARCHAR(50)     NULL,
    CustomerID      VARCHAR(50)     NULL,
    ProductID       VARCHAR(50)     NULL,
    StoreID         VARCHAR(50)     NULL,
    Quantity        VARCHAR(50)     NULL,
    UnitPrice       VARCHAR(50)     NULL,
    SourceFileName  VARCHAR(255)    NULL,
    LoadedDate      DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================
-- FileImports Table
-- ============================================

CREATE TABLE dbo.FileImports (
    FileImportID     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FileName         VARCHAR(255)      NOT NULL,
    ArchivePath      VARCHAR(500)      NULL,
    FileImportStatus VARCHAR(50)       NOT NULL,   -- Received / Successfully Loaded / Failed
    CreatedDate      DATETIME          NOT NULL DEFAULT GETDATE(),
    UpdatedDate      DATETIME          NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================
-- Rejected Records Table (per assignment spec: SourceFile, Business Key, ErrorReason, ErrorDate)
-- ============================================

CREATE TABLE dbo.RejectedRecords (
    RejectedRecordID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SourceFile       VARCHAR(255)      NOT NULL,
    RecordKey        VARCHAR(100)      NULL,        -- e.g. the CustomerID/ProductID/SaleID that failed
    SourceTable      VARCHAR(50)       NULL,        -- Customers / Products / Stores / Sales (helps filtering)
    ErrorReason      VARCHAR(500)      NOT NULL,
    RawData          VARCHAR(MAX)      NULL,        -- optional: full original row for debugging
    ErrorDate        DATETIME          NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================
-- Audit Table (per assignment spec)
-- ============================================

CREATE TABLE dbo.AuditLog (
    AuditID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PackageName      VARCHAR(200)      NOT NULL,
    SourceFile       VARCHAR(255)      NULL,
    StartTime        DATETIME          NULL,
    EndTime          DATETIME          NULL,
    Status           VARCHAR(50)       NULL,        -- Success / Failed / PartialSuccess
    RecordsRead      INT               NULL,
    RecordsInserted  INT               NULL,
    RecordsRejected  INT               NULL,
    ErrorMessage     VARCHAR(MAX)      NULL
);
GO