USE DW_Ventes_AW;
GO

SELECT 'Bronze.SalesOrderHeader' AS TableName, COUNT(*) AS Rows FROM Bronze.SalesOrderHeader
UNION ALL SELECT 'Bronze.SalesOrderDetail', COUNT(*) FROM Bronze.SalesOrderDetail
UNION ALL SELECT 'Bronze.Customer',         COUNT(*) FROM Bronze.Customer
UNION ALL SELECT 'Bronze.Product',          COUNT(*) FROM Bronze.Product
UNION ALL SELECT 'Silver.SalesOrderHeader', COUNT(*) FROM Silver.SalesOrderHeader
UNION ALL SELECT 'Silver.SalesOrderDetail', COUNT(*) FROM Silver.SalesOrderDetail
UNION ALL SELECT 'Silver.Customer',         COUNT(*) FROM Silver.Customer
UNION ALL SELECT 'Silver.Product',          COUNT(*) FROM Silver.Product
UNION ALL SELECT 'Gold.DimDate',            COUNT(*) FROM Gold.DimDate
UNION ALL SELECT 'Gold.DimCustomer',        COUNT(*) FROM Gold.DimCustomer
UNION ALL SELECT 'Gold.DimProduct',         COUNT(*) FROM Gold.DimProduct
UNION ALL SELECT 'Gold.DimTerritory',       COUNT(*) FROM Gold.DimTerritory
UNION ALL SELECT 'Gold.DimSalesPerson',     COUNT(*) FROM Gold.DimSalesPerson
UNION ALL SELECT 'Gold.FactSales',          COUNT(*) FROM Gold.FactSales;
