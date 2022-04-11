-- AdventureWorks fact for sales
CREATE VIEW AdventureWorks.v_fact_sales AS
SELECT S.SalesOrderID,
S.OrderDate,
S.Status,
SD.ProductID,
S.CustomerID,
SUM(SD.LineTotal) TotalCost
FROM AdventureWorks.sales_order_header S INNER JOIN AdventureWorks.sales_order_detail SD ON S.SalesOrderID = SD.SalesOrderID
GROUP BY
S.SalesOrderID,
S.OrderDate,
S.Status,
SD.ProductID,
S.CustomerID;


-- AdventureWorks dimension for product
CREATE VIEW AdventureWorks.v_dim_product AS
SELECT P.ProductID,
P.Name ProductName,
P.ProductNumber,
P.Color,
PG.Name ProductCategory
FROM AdventureWorks.product P INNER JOIN  AdventureWorks.product_category PG ON P.ProductCategoryID = PG.ProductCategoryID;


-- AdventureWorks dimension for customer
CREATE VIEW AdventureWorks.v_dim_customer AS
SELECT CustomerID, Title, FirstName, MiddleName, LastName, CompanyName, SalesPerson
FROM AdventureWorks.customer;


-- AdventureWorks fact for sales enlarged
CREATE VIEW AdventureWorks.v_fact_sales_enlarged AS
SELECT S.SalesOrderID,
S.OrderDate,
S.Status,
SD.ProductID,
S.CustomerID,
SUM(SD.LineTotal) TotalCost
FROM AdventureWorks.sales_order_header_enlarged S INNER JOIN AdventureWorks.sales_order_detail_enlarged SD ON S.SalesOrderID = SD.SalesOrderID
GROUP BY
S.SalesOrderID,
S.OrderDate,
S.Status,
SD.ProductID,
S.CustomerID;

-- AdventureWorks fact for sales
CREATE VIEW [AdventureWorks].[v_fact_sales_by_product_orderqty]
AS SELECT CAST(CONVERT(char(10), OrderDate, 112) AS BIGINT) AS OrderDate,
SD.ProductID,
SUM(SD.OrderQty) TotalOrderQty
FROM AdventureWorks.sales_order_header_enlarged S INNER JOIN AdventureWorks.sales_order_detail_enlarged SD ON S.SalesOrderID = SD.SalesOrderID
GROUP BY
SD.ProductID,
S.OrderDate;