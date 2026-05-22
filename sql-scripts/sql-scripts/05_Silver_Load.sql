USE DW_Ventes_AW;
GO

DELETE FROM Silver.SalesOrderDetail;
DELETE FROM Silver.SalesOrderHeader;
DELETE FROM Silver.Customer;
DELETE FROM Silver.Product;
DELETE FROM Silver.Territory;
DELETE FROM Silver.SalesPerson;
GO

INSERT INTO Silver.SalesOrderHeader
SELECT
    SalesOrderID,
    CAST(OrderDate AS DATE),
    CAST(ShipDate  AS DATE),
    YEAR(OrderDate),
    MONTH(OrderDate),
    DATEPART(QUARTER, OrderDate),
    OnlineOrderFlag,
    CustomerID,
    SalesPersonID,
    TerritoryID,
    CAST(SubTotal  AS DECIMAL(18,2)),
    CAST(TaxAmt    AS DECIMAL(18,2)),
    CAST(Freight   AS DECIMAL(18,2)),
    CAST(TotalDue  AS DECIMAL(18,2)),
    CASE Status
        WHEN 1 THEN 'In Process'
        WHEN 2 THEN 'Approved'
        WHEN 3 THEN 'Backordered'
        WHEN 4 THEN 'Rejected'
        WHEN 5 THEN 'Shipped'
        WHEN 6 THEN 'Cancelled'
        ELSE 'Unknown'
    END,
    GETDATE()
FROM Bronze.SalesOrderHeader
WHERE SalesOrderID IS NOT NULL
  AND OrderDate    IS NOT NULL
  AND CustomerID   IS NOT NULL;

INSERT INTO Silver.SalesOrderDetail
SELECT
    SalesOrderDetailID,
    SalesOrderID,
    ProductID,
    ISNULL(SpecialOfferID, 1),
    OrderQty,
    CAST(UnitPrice         AS DECIMAL(18,2)),
    CAST(UnitPriceDiscount AS DECIMAL(5,4)),
    CAST(LineTotal         AS DECIMAL(18,2)),
    GETDATE()
FROM Bronze.SalesOrderDetail
WHERE SalesOrderDetailID IS NOT NULL
  AND SalesOrderID       IS NOT NULL
  AND ProductID          IS NOT NULL
  AND OrderQty > 0;

INSERT INTO Silver.Customer
SELECT
    c.CustomerID,
    CASE
        WHEN c.PersonID IS NOT NULL THEN 'Individual'
        WHEN c.StoreID  IS NOT NULL THEN 'Store'
        ELSE 'Unknown'
    END,
    ISNULL(LTRIM(RTRIM(
        ISNULL(p.FirstName,'') + ' ' +
        ISNULL(p.MiddleName+' ','') +
        ISNULL(p.LastName,'')
    )), 'Unknown'),
    c.TerritoryID,
    GETDATE()
FROM Bronze.Customer c
LEFT JOIN Bronze.Person p ON p.BusinessEntityID = c.PersonID
WHERE c.CustomerID IS NOT NULL;

INSERT INTO Silver.Product
SELECT
    p.ProductID,
    ISNULL(p.Name, 'Unknown'),
    ISNULL(p.Color, 'N/A'),
    ISNULL(CAST(p.StandardCost AS DECIMAL(18,2)), 0),
    ISNULL(CAST(p.ListPrice    AS DECIMAL(18,2)), 0),
    CASE p.ProductLine
        WHEN 'R' THEN 'Road'
        WHEN 'M' THEN 'Mountain'
        WHEN 'T' THEN 'Touring'
        WHEN 'S' THEN 'Standard'
        ELSE 'N/A'
    END,
    ISNULL(sc.Name, 'Unknown'),
    ISNULL(cat.Name,'Unknown'),
    CASE WHEN p.SellEndDate IS NOT NULL THEN 1 ELSE 0 END,
    GETDATE()
FROM Bronze.Product p
LEFT JOIN Bronze.ProductSubcategory sc  ON sc.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN Bronze.ProductCategory    cat ON cat.ProductCategoryID   = sc.ProductCategoryID
WHERE p.ProductID IS NOT NULL;

INSERT INTO Silver.Territory
SELECT
    TerritoryID, Name, CountryRegionCode, [Group], GETDATE()
FROM Bronze.SalesTerritory
WHERE TerritoryID IS NOT NULL;

INSERT INTO Silver.SalesPerson
SELECT
    sp.BusinessEntityID,
    ISNULL(LTRIM(RTRIM(
        ISNULL(p.FirstName,'') + ' ' +
        ISNULL(p.LastName,'')
    )), 'Unknown'),
    sp.TerritoryID,
    CAST(ISNULL(sp.SalesQuota, 0)    AS DECIMAL(18,2)),
    CAST(ISNULL(sp.CommissionPct, 0) AS DECIMAL(5,4)),
    GETDATE()
FROM Bronze.SalesPerson sp
LEFT JOIN Bronze.Person p ON p.BusinessEntityID = sp.BusinessEntityID
WHERE sp.BusinessEntityID IS NOT NULL;
GO
