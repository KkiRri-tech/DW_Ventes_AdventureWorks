USE DW_Ventes_AW;
GO

CREATE SCHEMA Silver;
GO

CREATE TABLE Silver.SalesOrderHeader (
    SalesOrderID  INT          NOT NULL PRIMARY KEY,
    OrderDate     DATE         NOT NULL,
    ShipDate      DATE,
    OrderYear     INT          NOT NULL,
    OrderMonth    INT          NOT NULL,
    OrderQuarter  INT          NOT NULL,
    IsOnlineOrder BIT          NOT NULL,
    CustomerID    INT          NOT NULL,
    SalesPersonID INT,
    TerritoryID   INT          NOT NULL,
    SubTotal      DECIMAL(18,2) NOT NULL,
    TaxAmt        DECIMAL(18,2) NOT NULL,
    Freight       DECIMAL(18,2) NOT NULL,
    TotalDue      DECIMAL(18,2) NOT NULL,
    OrderStatus   NVARCHAR(20) NOT NULL,
    LoadDate      DATETIME DEFAULT GETDATE()
);

CREATE TABLE Silver.SalesOrderDetail (
    SalesOrderDetailID INT           NOT NULL PRIMARY KEY,
    SalesOrderID       INT           NOT NULL,
    ProductID          INT           NOT NULL,
    SpecialOfferID     INT           NOT NULL,
    OrderQty           INT           NOT NULL,
    UnitPrice          DECIMAL(18,2) NOT NULL,
    UnitPriceDiscount  DECIMAL(5,4)  NOT NULL DEFAULT 0,
    LineTotal          DECIMAL(18,2) NOT NULL,
    LoadDate           DATETIME DEFAULT GETDATE()
);

CREATE TABLE Silver.Customer (
    CustomerID   INT          NOT NULL PRIMARY KEY,
    CustomerType NVARCHAR(20) NOT NULL,
    FullName     NVARCHAR(150),
    TerritoryID  INT,
    LoadDate     DATETIME DEFAULT GETDATE()
);

CREATE TABLE Silver.Product (
    ProductID        INT           NOT NULL PRIMARY KEY,
    ProductName      NVARCHAR(50)  NOT NULL,
    Color            NVARCHAR(15)  NOT NULL DEFAULT 'N/A',
    StandardCost     DECIMAL(18,2) NOT NULL DEFAULT 0,
    ListPrice        DECIMAL(18,2) NOT NULL DEFAULT 0,
    ProductLine      NVARCHAR(20)  NOT NULL DEFAULT 'N/A',
    SubcategoryName  NVARCHAR(50)  NOT NULL DEFAULT 'Unknown',
    CategoryName     NVARCHAR(50)  NOT NULL DEFAULT 'Unknown',
    IsDiscontinued   BIT           NOT NULL DEFAULT 0,
    LoadDate         DATETIME DEFAULT GETDATE()
);

CREATE TABLE Silver.Territory (
    TerritoryID   INT          NOT NULL PRIMARY KEY,
    TerritoryName NVARCHAR(50) NOT NULL,
    CountryCode   NVARCHAR(3)  NOT NULL,
    Region        NVARCHAR(50) NOT NULL,
    LoadDate      DATETIME DEFAULT GETDATE()
);

CREATE TABLE Silver.SalesPerson (
    SalesPersonID INT           NOT NULL PRIMARY KEY,
    FullName      NVARCHAR(150),
    TerritoryID   INT,
    SalesQuota    DECIMAL(18,2),
    CommissionPct DECIMAL(5,4)  NOT NULL DEFAULT 0,
    LoadDate      DATETIME DEFAULT GETDATE()
);
GO
