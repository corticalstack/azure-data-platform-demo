CREATE OR ALTER VIEW AdventureWorks.v_fact_sales AS
SELECT S.SalesOrderID,
S.OrderDate,
S.Status,
SD.ProductID,
S.CustomerID,
SUM(SD.LineTotal) TotalCost
FROM OPENROWSET(
        BULK 'abfss://enriched@csresearchdpolaplakest.dfs.core.windows.net/erpcore/AdventureWorks/SalesOrderHeader',
        FORMAT = 'DELTA'
    ) AS S
INNER JOIN OPENROWSET(
        BULK 'abfss://enriched@csresearchdpolaplakest.dfs.core.windows.net/erpcore/AdventureWorks/SalesOrderDetail',
        FORMAT = 'DELTA'
    ) AS SD
ON S.SalesOrderID = SD.SalesOrderID
GROUP BY
S.SalesOrderID,
S.OrderDate,
S.Status,
SD.ProductID,
S.CustomerID

CREATE OR ALTER VIEW AdventureWorks.v_customer
AS
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://enriched@csresearchdpolaplakest.dfs.core.windows.net/erpcore/AdventureWorks/Customer',
        FORMAT = 'DELTA'
    ) AS r

CREATE OR ALTER VIEW AdventureWorks.v_sales_order_header
AS
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://enriched@csresearchdpolaplakest.dfs.core.windows.net/erpcore/AdventureWorks/SalesOrderHeader',
        FORMAT = 'DELTA'
    ) AS r;

CREATE OR ALTER VIEW AdventureWorks.v_sales_order_detail
AS
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://enriched@csresearchdpolaplakest.dfs.core.windows.net/erpcore/AdventureWorks/SalesOrderDetail',
        FORMAT = 'DELTA'
    ) AS r;

CREATE OR ALTER VIEW AdventureWorks.v_product
AS
SELECT
    ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, ProductCategoryID, ProductModelID, SellStartDate, SellEndDate
FROM
    OPENROWSET(
        BULK 'abfss://enriched@csresearchdpolaplakest.dfs.core.windows.net/erpcore/AdventureWorks/Product',
        FORMAT = 'DELTA'
    ) AS r;

CREATE OR ALTER VIEW AdventureWorks.v_product_category
AS
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://enriched@csresearchdpolaplakest.dfs.core.windows.net/erpcore/AdventureWorks/ProductCategory',
        FORMAT = 'DELTA'
    ) AS r;

CREATE OR ALTER VIEW AdventureWorks.v_product_model
AS
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://enriched@csresearchdpolaplakest.dfs.core.windows.net/erpcore/AdventureWorks/ProductModel',
        FORMAT = 'DELTA'
    ) AS r;
