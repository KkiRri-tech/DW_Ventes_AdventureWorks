USE DW_Ventes_AW;
GO

CREATE SCHEMA Gold;
GO

CREATE TABLE Gold.DimDate (
    DateKey     INT          NOT NULL PRIMARY KEY,
    FullDate    DATE         NOT NULL,
    Day         INT          NOT NULL,
    Month       INT          NOT NULL,
    MonthName   NVARCHAR(10) NOT NULL,
    Quarter     INT          NOT NULL,
    Year        INT          NOT NULL,
    IsWeekend   BIT          NOT NULL DEFAULT 0
);

CREATE TABLE Gold.DimCustomer (
    CustomerKey  INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID   INT          NOT NULL,
    CustomerType NVARCHAR(20) NOT NULL,
    FullName     NVARCHAR(150),
    TerritoryID  INT,
    StartDate    DATE         NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    EndDate      DATE,
    IsCurrent    BIT          NOT NULL DEFAULT 1
);

CREATE TABLE Gold.DimProduct (
    ProductKey      INT IDENTITY(1,1) PRIMARY KEY,
    ProductID       INT           NOT NULL,
    ProductName     NVARCHAR(50)  NOT NULL,
    Color           NVARCHAR(15)  NOT NULL DEFAULT 'N/A',
    ProductLine     NVARCHAR(20)  NOT NULL DEFAULT 'N/A',
    SubcategoryName NVARCHAR(50)  NOT NULL DEFAULT 'Unknown',
    CategoryName    NVARCHAR(50)  NOT NULL DEFAULT 'Unknown',
    StandardCost    DECIMAL(18,2) NOT NULL DEFAULT 0,
    ListPrice       DECIMAL(18,2) NOT NULL DEFAULT 0,
    IsDiscontinued  BIT           NOT NULL DEFAULT 0,
    StartDate       DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    EndDate         DATE,
    IsCurrent       BIT           NOT NULL DEFAULT 1
);

CREATE TABLE Gold.DimTerritory (
    TerritoryKey  INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID   INT          NOT NULL,
    TerritoryName NVARCHAR(50) NOT NULL,
    CountryCode   NVARCHAR(3)  NOT NULL,
    Region        NVARCHAR(50) NOT NULL
);

CREATE TABLE Gold.DimSalesPerson (
    SalesPersonKey INT IDENTITY(1,1) PRIMARY KEY,
    SalesPersonID  INT           NOT NULL,
    FullName       NVARCHAR(150),
    TerritoryID    INT,
    SalesQuota     DECIMAL(18,2),
    CommissionPct  DECIMAL(5,4)  NOT NULL DEFAULT 0
);

CREATE TABLE Gold.FactSales (
    FactSalesKey       BIGINT IDENTITY(1,1) PRIMARY KEY,
    DateKey            INT           NOT NULL REFERENCES Gold.DimDate(DateKey),
    CustomerKey        INT           NOT NULL REFERENCES Gold.DimCustomer(CustomerKey),
    ProductKey         INT           NOT NULL REFERENCES Gold.DimProduct(ProductKey),
    TerritoryKey       INT           NOT NULL REFERENCES Gold.DimTerritory(TerritoryKey),
    SalesPersonKey     INT           NOT NULL REFERENCES Gold.DimSalesPerson(SalesPersonKey),
    SalesOrderID       INT           NOT NULL,
    SalesOrderDetailID INT           NOT NULL,
    OrderQty           INT           NOT NULL,
    UnitPrice          DECIMAL(18,2) NOT NULL,
    UnitPriceDiscount  DECIMAL(5,4)  NOT NULL DEFAULT 0,
    LineTotal          DECIMAL(18,2) NOT NULL,
    StandardCost       DECIMAL(18,2) NOT NULL DEFAULT 0,
    GrossMargin        AS (LineTotal - (StandardCost * OrderQty)) PERSISTED,
    IsOnlineOrder      BIT           NOT NULL DEFAULT 0,
    LoadDate           DATETIME DEFAULT GETDATE()
);

CREATE INDEX IX_Fact_Date      ON Gold.FactSales(DateKey);
CREATE INDEX IX_Fact_Customer  ON Gold.FactSales(CustomerKey);
CREATE INDEX IX_Fact_Product   ON Gold.FactSales(ProductKey);
CREATE INDEX IX_Fact_Territory ON Gold.FactSales(TerritoryKey);
GO

-- Populate DimDate
DECLARE @d DATE = '2010-01-01';
WHILE @d <= '2026-12-31'
BEGIN
    INSERT INTO Gold.DimDate VALUES (
        CAST(CONVERT(NVARCHAR,@d,112) AS INT),
        @d,
        DAY(@d),
        MONTH(@d),
        DATENAME(MONTH,@d),
        DATEPART(QUARTER,@d),
        YEAR(@d),
        CASE WHEN DATEPART(WEEKDAY,@d) IN (1,7) THEN 1 ELSE 0 END
    );
    SET @d = DATEADD(DAY,1,@d);
END
GO
