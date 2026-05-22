USE DW_Ventes_AW;
GO

INSERT INTO Bronze.SalesOrderHeader
SELECT
    SalesOrderID, OrderDate, ShipDate, Status,
    OnlineOrderFlag, CustomerID, SalesPersonID,
    TerritoryID, SubTotal, TaxAmt, Freight, TotalDue,
    GETDATE()
FROM AdventureWorks2022.Sales.SalesOrderHeader;

INSERT INTO Bronze.SalesOrderDetail
SELECT
    SalesOrderID, SalesOrderDetailID, ProductID,
    SpecialOfferID, OrderQty, UnitPrice,
    UnitPriceDiscount, LineTotal, GETDATE()
FROM AdventureWorks2022.Sales.SalesOrderDetail;

INSERT INTO Bronze.Customer
SELECT
    CustomerID, PersonID, StoreID, TerritoryID, GETDATE()
FROM AdventureWorks2022.Sales.Customer;

INSERT INTO Bronze.Person
SELECT
    BusinessEntityID, FirstName, MiddleName, LastName, GETDATE()
FROM AdventureWorks2022.Person.Person
WHERE PersonType IN ('IN', 'SP');

INSERT INTO Bronze.Product
SELECT
    ProductID, Name, ProductNumber, Color, StandardCost,
    ListPrice, ProductLine, Class, ProductSubcategoryID,
    SellStartDate, SellEndDate, GETDATE()
FROM AdventureWorks2022.Production.Product;

INSERT INTO Bronze.ProductSubcategory
SELECT
    ProductSubcategoryID, ProductCategoryID, Name, GETDATE()
FROM AdventureWorks2022.Production.ProductSubcategory;

INSERT INTO Bronze.ProductCategory
SELECT
    ProductCategoryID, Name, GETDATE()
FROM AdventureWorks2022.Production.ProductCategory;

INSERT INTO Bronze.SalesTerritory
SELECT
    TerritoryID, Name, CountryRegionCode, [Group], GETDATE()
FROM AdventureWorks2022.Sales.SalesTerritory;

INSERT INTO Bronze.SalesPerson
SELECT
    BusinessEntityID, TerritoryID, SalesQuota,
    CommissionPct, SalesYTD, GETDATE()
FROM AdventureWorks2022.Sales.SalesPerson;
GO
