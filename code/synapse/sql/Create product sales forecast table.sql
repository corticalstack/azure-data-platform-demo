CREATE TABLE [AdventureWorks].[product_sales_forecast]
(
	[OrderDate] [int] NULL,
	[ProductID] [int] NOT NULL,
	[OrderQty] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO


INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220501,822,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220601,822,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220701,822,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220801,822,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220901,822,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20221001,822,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20221101,822,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20221201,822,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220501,742,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220601,742,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220701,742,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220801,742,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220901,742,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20221001,742,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20221101,742,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20221201,742,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220501,836,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220601,836,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220701,836,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220801,836,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20220901,836,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20221001,836,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20221101,836,0);

INSERT INTO [AdventureWorks].[product_sales_forecast] VALUES (20221201,836,0);