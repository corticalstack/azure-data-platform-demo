CREATE TABLE AdventureWorks.sales_order_header
(
    SalesOrderID int NOT NULL,
    RevisionNumber int NOT NULL,
    OrderDate nvarchar(4000) NOT NULL,
    DueDate nvarchar(4000) NULL,
    ShipDate nvarchar(4000) NULL,
    Status int NULL,
    OnlineOrderFlag bit NULL,
    SalesOrderNumber nvarchar(4000) NULL,
    PurchaseOrderNumber nvarchar(4000) NULL,
    AccountNumber nvarchar(4000) NULL,
    CustomerID int NULL,
    ShipToAddressID int NULL,
    BillToAddressID int NULL,
    ShipMethod nvarchar(4000) NULL,
    CreditCardApprovalCode nvarchar(4000) NULL,
    SubTotal decimal(10,5) NULL,
    TaxAmt decimal(10,5) NULL,
    Freight decimal(10,5) NULL,
    TotalDue decimal(10,5) NULL,
    Comment nvarchar(100) NULL,
    rowguid nvarchar(40) NULL,
    ModifiedDate nvarchar(30) NULL,
    OrderYear int NULL,
    OrderMonth int NULL
)
WITH
(
    DISTRIBUTION = HASH ( CustomerID ),
    CLUSTERED COLUMNSTORE INDEX
);  


drop table [AdventureWorks].[sales_order_header]