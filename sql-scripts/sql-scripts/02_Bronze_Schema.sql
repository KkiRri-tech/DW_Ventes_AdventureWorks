USE DW_Ventes_AW;
GO

CREATE SCHEMA Bronze;
GO

CREATE TABLE Bronze.SalesOrderHeader (
    SalesOrderID     INT,
    OrderDate        DATETIME,
    ShipDate         DATETIME,
    Status           TINYINT,
    OnlineOrderFlag  BIT,
    CustomerID       INT,
    SalesPersonID    INT,
    TerritoryID      INT,
    SubTotal         MONEY,
    TaxAmt           MONEY,
    Freight          MONEY,
    TotalDue         MONEY,
    LoadDate         DATETIME DEFAULT GETDATE()
);

CREATE TABLE Bronze.SalesOrderDetail (
    SalesOrderID       INT,
    SalesOrderDetailID INT,
    ProductID          INT,
    SpecialOfferID     INT,
    OrderQty           SMALLINT,
    UnitPrice          MONEY,
    UnitPriceDiscount  MONEY,
    LineTotal          NUMERIC(38,6),
    LoadDate           DATETIME DEFAULT GETDATE()
);

CREATE TABLE Bronze.Customer (
    CustomerID   INT,
    PersonID     INT,
    StoreID      INT,
    TerritoryID  INT,
    LoadDate     DATETIME DEFAULT GETDATE()
);

CREATE TABLE Bronze.Person (
    BusinessEntityID INT,
    FirstName        NVARCHAR(50),
    MiddleName       NVARCHAR(50),
    LastName         NVARCHAR(50),
    LoadDate         DATETIME DEFAULT GETDATE()
);

CREATE TABLE Bronze.Product (
    ProductID            INT,
    Name                 NVARCHAR(50),
    ProductNumber        NVARCHAR(25),
    Color                NVARCHAR(15),
    StandardCost         MONEY,
    ListPrice            MONEY,
    ProductLine          NCHAR(2),
    Class                NCHAR(2),
    ProductSubcategoryID INT,
    SellStartDate        DATETIME,
    SellEndDate          DATETIME,
    LoadDate             DATETIME DEFAULT GETDATE()
);

CREATE TABLE Bronze.ProductSubcategory (
    ProductSubcategoryID INT,
    ProductCategoryID    INT,
    Name                 NVARCHAR(50),
    LoadDate             DATETIME DEFAULT GETDATE()
);

CREATE TABLE Bronze.ProductCategory (
    ProductCategoryID INT,
    Name              NVARCHAR(50),
    LoadDate          DATETIME DEFAULT GETDATE()
);

CREATE TABLE Bronze.SalesTerritory (
    TerritoryID       INT,
    Name              NVARCHAR(50),
    CountryRegionCode NVARCHAR(3),
    [Group]           NVARCHAR(50),
    LoadDate          DATETIME DEFAULT GETDATE()
);

CREATE TABLE Bronze.SalesPerson (
    BusinessEntityID INT,
    TerritoryID      INT,
    SalesQuota       MONEY,
    CommissionPct    SMALLMONEY,
    SalesYTD         MONEY,
    LoadDate         DATETIME DEFAULT GETDATE()
);
GO
