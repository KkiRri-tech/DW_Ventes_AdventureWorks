USE DW_Ventes_AW;
GO

DELETE FROM Gold.FactSales;
DELETE FROM Gold.DimCustomer;
DELETE FROM Gold.DimProduct;
DELETE FROM Gold.DimTerritory;
DELETE FROM Gold.DimSalesPerson;
GO

SET IDENTITY_INSERT Gold.DimSalesPerson ON;
INSERT INTO Gold.DimSalesPerson (SalesPersonKey, SalesPersonID, FullName, TerritoryID, SalesQuota, CommissionPct)
VALUES (-1, -1, 'Online / No Salesperson', NULL, NULL, 0);
SET IDENTITY_INSERT Gold.DimSalesPerson OFF;
GO

INSERT INTO Gold.DimTerritory (TerritoryID, TerritoryName, CountryCode, Region)
SELECT TerritoryID, TerritoryName, CountryCode, Region
FROM Silver.Territory;

INSERT INTO Gold.DimCustomer (CustomerID, CustomerType, FullName, TerritoryID, StartDate, IsCurrent)
SELECT CustomerID, CustomerType, FullName, TerritoryID, GETDATE(), 1
FROM Silver.Customer;

INSERT INTO Gold.DimProduct (ProductID, ProductName, Color, ProductLine,
                             SubcategoryName, CategoryName, StandardCost,
                             ListPrice, IsDiscontinued, StartDate, IsCurrent)
SELECT ProductID, ProductName, Color, ProductLine,
       SubcategoryName, CategoryName, StandardCost,
       ListPrice, IsDiscontinued, GETDATE(), 1
FROM Silver.Product;

INSERT INTO Gold.DimSalesPerson (SalesPersonID, FullName, TerritoryID, SalesQuota, CommissionPct)
SELECT SalesPersonID, FullName, TerritoryID, SalesQuota, CommissionPct
FROM Silver.SalesPerson;

INSERT INTO Gold.FactSales (
    DateKey, CustomerKey, ProductKey, TerritoryKey, SalesPersonKey,
    SalesOrderID, SalesOrderDetailID,
    OrderQty, UnitPrice, UnitPriceDiscount, LineTotal, StandardCost, IsOnlineOrder
)
SELECT
    CAST(CONVERT(NVARCHAR, h.OrderDate, 112) AS INT),
    dc.CustomerKey,
    dp.ProductKey,
    dt.TerritoryKey,
    ISNULL(dsp.SalesPersonKey, -1),
    h.SalesOrderID,
    d.SalesOrderDetailID,
    d.OrderQty,
    d.UnitPrice,
    d.UnitPriceDiscount,
    d.LineTotal,
    p.StandardCost,
    h.IsOnlineOrder
FROM Silver.SalesOrderDetail d
JOIN Silver.SalesOrderHeader  h   ON h.SalesOrderID    = d.SalesOrderID
JOIN Gold.DimCustomer         dc  ON dc.CustomerID     = h.CustomerID    AND dc.IsCurrent = 1
JOIN Gold.DimProduct          dp  ON dp.ProductID      = d.ProductID     AND dp.IsCurrent = 1
JOIN Gold.DimTerritory        dt  ON dt.TerritoryID    = h.TerritoryID
LEFT JOIN Gold.DimSalesPerson dsp ON dsp.SalesPersonID = h.SalesPersonID
JOIN Silver.Product           p   ON p.ProductID       = d.ProductID;
GO
