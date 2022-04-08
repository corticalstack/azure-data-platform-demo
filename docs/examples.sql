-- Create table with hash distribution and partition 
 CREATE TABLE [wwi_mcw].[SaleSmall]
  (
    [TransactionId] [uniqueidentifier]  NOT NULL,
    [CustomerId] [int]  NOT NULL,
    [ProductId] [smallint]  NOT NULL,
    [Quantity] [tinyint]  NOT NULL,
    [Price] [decimal](9,2)  NOT NULL,
    [TotalAmount] [decimal](9,2)  NOT NULL,
    [TransactionDateId] [int]  NOT NULL,
    [ProfitAmount] [decimal](9,2)  NOT NULL,
    [Hour] [tinyint]  NOT NULL,
    [Minute] [tinyint]  NOT NULL,
    [StoreId] [smallint]  NOT NULL
  )
  WITH
  (
    DISTRIBUTION = HASH ( [CustomerId] ),
    CLUSTERED COLUMNSTORE INDEX,
    PARTITION
    (
      [TransactionDateId] RANGE RIGHT FOR VALUES (
        20180101, 20180201, 20180301, 20180401, 20180501, 20180601, 20180701, 20180801, 20180901, 20181001, 20181101, 20181201,
        20190101, 20190201, 20190301, 20190401, 20190501, 20190601, 20190701, 20190801, 20190901, 20191001, 20191101, 20191201)
    )
  );


select count(TransactionId) from wwi_mcw.SaleSmall;


CREATE TABLE [wwi_mcw].[CustomerInfo]
 (
   [UserName] [nvarchar](100)  NULL,
   [Gender] [nvarchar](10)  NULL,
   [Phone] [nvarchar](50)  NULL,
   [Email] [nvarchar](150)  NULL,
   [CreditCard] [nvarchar](21)  NULL
 )
 WITH
 (
   DISTRIBUTION = REPLICATE,
   CLUSTERED COLUMNSTORE INDEX
 )
 GO


select * from wwi_mcw.CustomerInfo;


CREATE TABLE [wwi_mcw].[CampaignAnalytics]
(
    [Region] [nvarchar](50)  NULL,
    [Country] [nvarchar](30)  NOT NULL,
    [ProductCategory] [nvarchar](50)  NOT NULL,
    [CampaignName] [nvarchar](500)  NOT NULL,
    [Analyst] [nvarchar](25) NULL,
    [Revenue] [decimal](10,2)  NULL,
    [RevenueTarget] [decimal](10,2)  NULL,
    [City] [nvarchar](50)  NULL,
    [State] [nvarchar](25)  NULL
)
WITH
(
    DISTRIBUTION = HASH ( [Region] ),
    CLUSTERED COLUMNSTORE INDEX
);  


select count(Region) from wwi_mcw.CampaignAnalytics;


select * from wwi_mcw.Product;


SELECT
    TransactionDate, ProductId,
    CAST(SUM(ProfitAmount) AS decimal(18,2)) AS [(sum) Profit],
    CAST(AVG(ProfitAmount) AS decimal(18,2)) AS [(avg) Profit],
    SUM(Quantity) AS [(sum) Quantity]
FROM
    OPENROWSET(
        BULK 'https://asadatalake{SUFFIX}.dfs.core.windows.net/wwi-02/sale-small/Year=2010/Quarter=Q4/Month=12/Day=20101231/sale-small-20101231-snappy.parquet',
        FORMAT='PARQUET'
    ) AS [r] GROUP BY r.TransactionDate, r.ProductId;



SELECT
    COUNT_BIG(*)
FROM
    OPENROWSET(
        BULK 'https://asadatalake{SUFFIX}.dfs.core.windows.net/wwi-02/sale-small/Year=2019/*/*/*/*',
        FORMAT='PARQUET'
    ) AS [r];



CREATE TABLE [wwi].[Product]
(
    ProductId SMALLINT NOT NULL,
    Seasonality TINYINT NOT NULL,
    Price DECIMAL(6,2),
    Profit DECIMAL(6,2)
)
WITH
(
    DISTRIBUTION = REPLICATE
);

create login [asa.sql.workload01] with password = '#PASSWORD#'
create login [asa.sql.workload02] with password = '#PASSWORD#'

if not exists(select * from sys.database_principals where name = 'asa.sql.workload01') create user [asa.sql.workload01] from login [asa.sql.workload01]
if not exists(select * from sys.database_principals where name = 'asa.sql.workload02') create user [asa.sql.workload02] from login [asa.sql.workload02]
if not exists(select * from sys.database_principals where name = 'ceo') create user [CEO] without login;

execute sp_addrolemember 'db_datareader', 'asa.sql.workload01' 
execute sp_addrolemember 'db_datareader', 'asa.sql.workload02' 
execute sp_addrolemember 'db_datareader', 'CEO' 

if not exists(select * from sys.database_principals where name = 'DataAnalystMiami') create user [DataAnalystMiami] without login
if not exists(select * from sys.database_principals where name = 'DataAnalystSanDiego')create user [DataAnalystSanDiego] without login
if not exists(select * from sys.schemas where name='wwi_mcw') EXEC('create schema [wwi_mcw] authorization [dbo]')

create master key
create table [wwi_mcw].[Product](ProductId SMALLINT NOT NULL,Seasonality TINYINT NOT NULL,Price DECIMAL(6,2),Profit DECIMAL(6,2))WITH(DISTRIBUTION = REPLICATE)
CREATE TABLE [wwi_mcw].[ProductQuantityForecast]([ProductId] [int]  NOT NULL, [TransactionDate] [int]  NOT NULL, [Hour] [int]  NOT NULL,[TotalQuantity] [int]  NOT NULL) WITH ( DISTRIBUTION = REPLICATE)
INSERT INTO [wwi_mcw].[ProductQuantityForecast] VALUES (100, 20201209, 10, 0)


-- https://github.com/microsoft/MCW-Azure-Synapse-Analytics-and-AI/blob/main/Hands-on%20lab/environment-setup/automation/sql/02_sqlpool01_ml.sql 

CREATE DATABASE SCOPED CREDENTIAL StorageCredential WITH IDENTITY = 'SHARED ACCESS SIGNATURE',SECRET = '#DATALAKESTORAGEKEY#'
CREATE EXTERNAL DATA SOURCE ASAMCWModelStorage WITH (LOCATION = 'wasbs://wwi-02@#DATALAKESTORAGEACCOUNTNAME#.blob.core.windows.net',CREDENTIAL = StorageCredential,TYPE = HADOOP)
CREATE EXTERNAL FILE FORMAT csv WITH (FORMAT_TYPE = DELIMITEDTEXT,FORMAT_OPTIONS (FIELD_TERMINATOR = ',',STRING_DELIMITER = '',DATE_FORMAT = '',USE_TYPE_DEFAULT = False))
CREATE EXTERNAL TABLE [wwi_mcw].[ASAMCWMLModelExt]([Model] [varbinary](max) NULL)WITH(LOCATION='/ml/onnx-hex', DATA_SOURCE = ASAMCWModelStorage ,FILE_FORMAT = csv ,REJECT_TYPE = VALUE ,REJECT_VALUE = 0)
CREATE TABLE [wwi_mcw].[ASAMCWMLModel]([Id] [int] IDENTITY(1,1) NOT NULL,[Model] [varbinary](max) NULL,[Description] [varchar](200) NULL)WITH(DISTRIBUTION = REPLICATE,HEAP)


SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://csdataresearchsshnsst.dfs.core.windows.net/landing/retail/wwi/sales/2018/Quarter=Q1/Month=1/Day=20180101/sale-small-20180101-snappy.parquet',
        FORMAT = 'PARQUET'
    ) AS [result]


-- perform aggregates and grouping operations to better understand the data 
SELECT
    TransactionDate, ProductId,
    CAST(SUM(ProfitAmount) AS decimal(18,2)) AS [(sum) Profit],
    CAST(AVG(ProfitAmount) AS decimal(18,2)) AS [(avg) Profit],
    SUM(Quantity) AS [(sum) Quantity]
FROM
    OPENROWSET(
        BULK 'https://csdataresearchsshnsst.dfs.core.windows.net/landing/retail/wwi/sales/2018/Quarter=Q1/Month=1/Day=20180101/sale-small-20180101-snappy.parquet',
        FORMAT='PARQUET'
    ) AS [r] GROUP BY r.TransactionDate, r.ProductId;



-- Figure out how many records are contained within the Parquet files for 2019 data. This information is important for planning how we optimize for importing the data into Azure Synapse Analytics. 
SELECT
    COUNT_BIG(*)
FROM
    OPENROWSET(
        BULK 'https://csdataresearchsshnsst.dfs.core.windows.net/landing/retail/wwi/sales/2019/*/*/*/*',
        FORMAT='PARQUET'
    ) AS [r];


/* A common format for exporting and storing data is with text-based files. These can delimit text files such as CSV as well as JSON structured data files. Azure Synapse Analytics also provides ways of querying into these types of raw files to gain valuable insights into the data without having to wait for them to be processed. 
   Note on this query we are querying only a single file. Azure Synapse Analytics allows you to query across a series of CSV files (structured identically) by using wildcards in the path to the file(s).*/
SELECT
   csv.*
FROM
    OPENROWSET(
        BULK 'https://csdataresearchsshnsst.dfs.core.windows.net/landing/retail/wwi/product/product.csv',
        FORMAT='CSV',
        FIRSTROW = 1
    ) WITH (
        ProductID INT,
        Seasonality INT,
        Price DECIMAL(10,2),
        Profit DECIMAL(10,2)
    ) as csv



-- You are also able to perform aggregations on this csv data 
SELECT
    Seasonality,
    SUM(Price) as TotalSalesPrice,
    SUM(Profit) as TotalProfit
FROM
    OPENROWSET(
        BULK 'https://csdataresearchsshnsst.dfs.core.windows.net/landing/retail/wwi/product/product.csv',
        FORMAT='CSV',
        FIRSTROW = 1
    ) WITH (
        ProductID INT,
        Seasonality INT,
        Price DECIMAL(10,2),
        Profit DECIMAL(10,2)
    ) as csv
GROUP BY
    csv.Seasonality


-- Query JSON data 
SELECT
    products.*
FROM
    OPENROWSET(
        BULK 'https://asadatalake{SUFFIX}.dfs.core.windows.net/wwi-02/product-json/json-data/*.json',
        FORMAT='CSV',
        FIELDTERMINATOR ='0x0b',
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b'
    )
    WITH (
        jsonContent NVARCHAR(200)
    ) AS [raw]
CROSS APPLY OPENJSON(jsonContent)
WITH (
    ProductId INT,
    Seasonality INT,
    Price DECIMAL(10,2),
    Profit DECIMAL(10,2)
) AS products



/* Example of column level security.
   It is important to identify data columns of that hold sensitive information. Types of sensitive information could be social security numbers, email addresses, credit card numbers, financial totals, and more. Azure Synapse Analytics allows you define permissions that prevent users or roles select privileges on specific columns. */
select  Top 100 * from wwi.CampaignAnalytics
where City is not null and state is not null


SELECT Name as [User2] FROM sys.sysusers WHERE name = N'DataAnalystMiami';

REVOKE SELECT ON wwi.CampaignAnalytics FROM DataAnalystMiami;


-- This provides DataAnalystMiami access to all the columns of the Sale table but Revenue. 
GRANT SELECT ON wwi.CampaignAnalytics([Analyst], [CampaignName], [Region], [State], [City], [RevenueTarget]) TO DataAnalystMiami;


-- Then, to check if the security has been enforced, we execute the following query with current User As 'DataAnalystMiami', this will result in an error since DataAnalystMiami doesn't have select access to the Revenue column. 
EXECUTE AS USER ='DataAnalystMiami';
select TOP 100 * from wwi.CampaignAnalytics;


-- The following query will succeed since we are not including the Revenue column in the query. 
EXECUTE AS USER ='DataAnalystMiami';
select [Analyst],[CampaignName], [Region], [State], [City], [RevenueTarget] from wwi.CampaignAnalytics;


-- Whereas, the CEO of the company should be authorized with all the information present in the warehouse */
Revert;
GRANT SELECT ON wwi.CampaignAnalytics TO CEO; 

EXECUTE AS USER ='CEO'
select * from wwi.CampaignAnalytics
Revert;





/* Example of row level security.
   In many organizations it is important to filter certain rows of data by user. In the case of WWI, they wish to have data analysts only see their data. In the campaign analytics table, there is an Analyst column that indicates to which analyst that row of data belongs. In the past, organizations would create views for each analyst - this was a lot of work and unnecessary overhead. Using Azure Synapse Analytics, you can define row level security that compares the user executing the query to the Analyst column, filtering the data so they only see the data destined for them.
   Row level Security (RLS) in Azure Synapse enables us to use group membership to control access to rows in a table.
   Azure Synapse applies the access restriction every time the data access is attempted from any user.
*/

UPDATE wwi.CampaignAnalytics SET [Analyst] = 'DataAnalystMiami' where [Region] = 'South East' AND [Country] = 'US'
UPDATE wwi.CampaignAnalytics SET [Analyst] = 'DataAnalystSanDiego' where [Region] = 'Far West' AND [Country] = 'US'


SELECT DISTINCT Analyst, Region FROM wwi.CampaignAnalytics order by Analyst ;


/* Scenario: WWI requires that an Analyst only see the data for their own data from their own region. The CEO should see ALL data. 
   In the Campaign table, there is an Analyst column that we can use to filter data to a specific Analyst value. */

/* We will define this filter using what is called a Security Predicate. This is an inline table-valued function that allows
    us to evaluate additional logic, in this case determining if the Analyst executing the query is the same as the Analyst
    specified in the Analyst column in the row. The function returns 1 (will return the row) when a row in the Analyst column is the same as the user executing the query (@Analyst = USER_NAME()) or if the user executing the query is the CEO user (USER_NAME() = 'CEO')
    whom has access to all data.
*/


-- Review any existing security predicates in the database
SELECT * FROM sys.security_predicates


--Step:2 Create a new Schema to hold the security predicate, then define the predicate function. It returns 1 (or True) when
--  a row should be returned in the parent query.
GO
CREATE SCHEMA Security
GO
CREATE FUNCTION Security.fn_securitypredicate(@Analyst AS sysname)  
    RETURNS TABLE  
WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS fn_securitypredicate_result
    WHERE @Analyst = USER_NAME() OR USER_NAME() = 'CEO'
GO
-- Now we define security policy that adds the filter predicate to the Sale table. This will filter rows based on their login name.
CREATE SECURITY POLICY SalesFilter  
ADD FILTER PREDICATE Security.fn_securitypredicate(Analyst)
ON wwi_mcw.CampaignAnalytics
WITH (STATE = ON);

------ Allow SELECT permissions to the Sale Table.------
GRANT SELECT ON wwi_mcw.CampaignAnalytics TO CEO, DataAnalystMiami, DataAnalystSanDiego;

-- Step:3 Let us now test the filtering predicate, by selecting data from the Sale table as 'DataAnalystMiami' user.
EXECUTE AS USER = 'DataAnalystMiami'
SELECT * FROM wwi_mcw.CampaignAnalytics;
revert;
-- As we can see, the query has returned rows here Login name is DataAnalystMiami

-- Step:4 Let us test the same for  'DataAnalystSanDiego' user.
EXECUTE AS USER = 'DataAnalystSanDiego';
SELECT * FROM wwi_mcw.CampaignAnalytics;
revert;
-- RLS is working indeed.

-- Step:5 The CEO should be able to see all rows in the table.
EXECUTE AS USER = 'CEO';  
SELECT * FROM wwi_mcw.CampaignAnalytics;
revert;
-- And he can.

--Step:6 To disable the security policy we just created above; we execute the following:
ALTER SECURITY POLICY SalesFilter  
WITH (STATE = OFF);

DROP SECURITY POLICY SalesFilter;
DROP FUNCTION Security.fn_securitypredicate;
DROP SCHEMA Security;


/* Dynamic data masking
   As an alternative to column level security, SQL Administrators also have the option of masking sensitive data. This will result in data being obfuscated when returned in queries. The data is still stored in a pristine state in the table itself. SQL Administrators can grant unmask privileges to users that have permissions to see this data. 
   Dynamic data masking helps prevent unauthorized access to sensitive data by enabling customers to designate how much of the sensitive data to reveal with minimal impact on the application layer. */


/* Scenario: WWI has identified sensitive information in the CustomerInfo table. They would like us to
    obfuscate the CreditCard and Email columns of the CustomerInfo table to DataAnalysts */

-- Step:1 Let's first get a view of CustomerInfo table.
SELECT TOP (100) * FROM wwi_mcw.CustomerInfo;

-- Step:2 Let's confirm that there are no Dynamic Data Masking (DDM) applied on columns.
SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function  
FROM sys.masked_columns AS c  
JOIN sys.tables AS tbl
    ON c.[object_id] = tbl.[object_id]  
WHERE is_masked = 1
    AND tbl.name = 'CustomerInfo';
-- No results returned verify that no data masking has been done yet.

-- Step:3 Now let's mask 'CreditCard' and 'Email' Column of 'CustomerInfo' table.
ALTER TABLE wwi_mcw.CustomerInfo  
ALTER COLUMN [CreditCard] ADD MASKED WITH (FUNCTION = 'partial(0,"XXXX-XXXX-XXXX-",4)');
GO
ALTER TABLE wwi_mcw.CustomerInfo
ALTER COLUMN Email ADD MASKED WITH (FUNCTION = 'email()');
GO
-- The columns are successfully masked.

-- Step:4 Let's see Dynamic Data Masking (DDM) applied on the two columns.
SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function  
FROM sys.masked_columns AS c  
JOIN sys.tables AS tbl
    ON c.[object_id] = tbl.[object_id]  
WHERE is_masked = 1
    AND tbl.name ='CustomerInfo';

-- Step:5 Now, let's grant SELECT permission to 'DataAnalystMiami' on the 'CustomerInfo' table.
GRANT SELECT ON wwi_mcw.CustomerInfo TO DataAnalystMiami;  

-- Step:6 Logged in as  'DataAnalystMiami' let's execute the select query and view the result.
EXECUTE AS USER = 'DataAnalystMiami';  
SELECT * FROM wwi_mcw.CustomerInfo;

-- Step:7 Let's remove the data masking using UNMASK permission
GRANT UNMASK TO DataAnalystMiami;
EXECUTE AS USER = 'DataAnalystMiami';  
SELECT *
FROM wwi_mcw.CustomerInfo;
revert;
REVOKE UNMASK TO DataAnalystMiami;  

----step:8 Reverting all the changes back to as it was.
ALTER TABLE wwi_mcw.CustomerInfo
ALTER COLUMN CreditCard DROP MASKED;
GO
ALTER TABLE wwi_mcw.CustomerInfo
ALTER COLUMN Email DROP MASKED;
GO



-- Making predictions from model
DROP PROCEDURE wwi.ForecastProductQuantity
GO

CREATE PROCEDURE wwi.ForecastProductQuantity
AS
BEGIN

SELECT
    CAST([ProductId] AS [bigint]) AS [ProductId],
    CAST([TransactionDate] AS [bigint]) AS [TransactionDate],
    CAST([Hour] AS [bigint]) AS [Hour]
INTO [wwi].[#ProductQuantityForecast]
FROM [wwi].[ProductQuantityForecast];

SELECT *
INTO [wwi].[#Pred]
FROM PREDICT (MODEL = (SELECT [model] FROM [wwi].[Model] WHERE [ID] = 'cs-eur-research-dsd-synw-saleconsolidated-20220322020225-Best:1'),
            DATA = [wwi].[#ProductQuantityForecast],
            RUNTIME = ONNX) WITH ([variable_out1] [real])

MERGE [wwi].[ProductQuantityForecast] AS target  
            USING (select * from [wwi].[#Pred]) AS source (TotalQuantity, ProductId, TransactionDate, Hour)  
        ON (target.ProductId = source.ProductId and target.TransactionDate = source.TransactionDate and target.Hour = source.Hour)  
            WHEN MATCHED THEN
                UPDATE SET target.TotalQuantity = CAST(source.TotalQuantity AS [bigint]);
END
GO


EXEC
wwi.ForecastProductQuantity

SELECT  
    *
FROM
    wwi.ProductQuantityForecast


create login [asa.sql.workload01] with password = 'MyPassword123'
create login [asa.sql.workload02] with password = 'MyPassword123'


-- List logins on master database
select sp.name as login,
       sp.type_desc as login_type,
       sl.password_hash,
       sp.create_date,
       sp.modify_date,
       case when sp.is_disabled = 1 then 'Disabled'
            else 'Enabled' end as status
from sys.server_principals sp
left join sys.sql_logins sl
          on sp.principal_id = sl.principal_id
where sp.type not in ('G', 'R')
order by sp.name;


--First, let's confirm that there are no queries currently being run by users logged in as CEONYC or AnalystNYC.

SELECT s.login_name, r.[Status], r.Importance, submit_time,
start_time ,s.session_id FROM sys.dm_pdw_exec_sessions s
JOIN sys.dm_pdw_exec_requests r ON s.session_id = r.session_id
WHERE s.login_name IN ('asa.sql.workload01','asa.sql.workload02') and Importance
is not NULL AND r.[status] in ('Running','Suspended')
--and submit_time>dateadd(minute,-2,getdate())
ORDER BY submit_time ,s.login_name


/* For a programmatic experience when monitoring SQL Analytics via T-SQL, the service provides a set of Dynamic Management Views (DMVs). These views are useful when actively troubleshooting and identifying performance bottlenecks with your workload.
   All logins to your data warehouse are logged to sys.dm_pdw_exec_sessions. This DMV contains the last 10,000 logins. The session_id is the primary key and is assigned sequentially for each new logon. */
SELECT * FROM sys.dm_pdw_exec_sessions where status <> 'Closed' and session_id <> session_id();


SELECT *
FROM sys.dm_pdw_exec_requests
WHERE status not in ('Completed','Failed','Cancelled')
  AND session_id <> session_id()
ORDER BY submit_time DESC;


-- Find top 10 longest running queries
SELECT TOP 10 *
FROM sys.dm_pdw_exec_requests
ORDER BY total_elapsed_time DESC;


-- To simplify the lookup of a query in the sys.dm_pdw_exec_requests table, use LABEL to assign a comment to your query, which can be looked up in the sys.dm_pdw_exec_requests view. To test using the labels, replace the script in the query window with the following:
SELECT *
FROM sys.tables
OPTION (LABEL = 'My Query');


-- Find a query with the Label 'My Query'
-- Use brackets when querying the label column, as it is a key word
SELECT  *
FROM sys.dm_pdw_exec_requests
WHERE [label] = 'My Query';


-- retrieve the query's distributed SQL (DSQL) plan from sys.dm_pdw_request_steps. Be sure to replace the QID##### with the Request_ID from previous query
SELECT * FROM sys.dm_pdw_request_steps
WHERE request_id = 'QID####'
ORDER BY step_index;


-- Generate more data up to current date for World Wide Importers example db
-- https://www.mytecbits.com/microsoft/sql-server/installing-wideworldimporters-sample-database
EXECUTE DataLoadSimulation.PopulateDataToCurrentDate
   @AverageNumberOfCustomerOrdersPerDay = 25,
   @SaturdayPercentageOfNormalWorkDay = 20,
   @SundayPercentageOfNormalWorkDay = 10,
   @IsSilentMode = 1,
   @AreDatesPrinted = 1;


SELECT
	Invoices.InvoiceID
	,InvoiceLineID
	,InvoiceLines.StockItemID
	,[Invoice Quantity]			=InvoiceLines.Quantity
	,Orders.OrderID
	,OrderLineID
	,[Order Quantity]			=OrderLines.Quantity
FROM
	Sales.Invoices
	JOIN Sales.InvoiceLines		ON InvoiceLines.InvoiceID	=Invoices.InvoiceID
	JOIN Sales.Orders			ON Orders.OrderID			=Invoices.OrderID
	LEFT JOIN Sales.OrderLines	ON
		OrderLines.OrderID = Orders.OrderID
		AND OrderLines.StockItemID = InvoiceLines.StockItemID
WHERE InvoiceLines.Quantity = OrderLines.Quantity;