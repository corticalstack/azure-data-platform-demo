CREATE TABLE AdventureWorks.sales_order_detail
(
    SalesOrderID int NOT NULL,
    SalesOrderDetailID int NOT NULL,
    OrderQty int NOT NULL,
    ProductID int NOT NULL,
    UnitPrice money NOT NULL,
    UnitPriceDiscount money NOT NULL,
    LineTotal decimal(38,6) NULL,
    rowguid nvarchar(4000) NULL,
    ModifiedDate nvarchar(30) NULL
)
WITH
(
    DISTRIBUTION = HASH ( SalesOrderID ),
    CLUSTERED COLUMNSTORE INDEX
);  
