CREATE EXTERNAL TABLE [AdventureWorks].[summary_sales]
with (
    location = 'SummarySales',
    DATA_SOURCE = LakeAdventureWorks,
    file_format = ParquetFileFormat
)
AS
select * 
from SalesOrderHeader

CREATE EXTERNAL DATA SOURCE LakeAdventureWorks
WITH ( LOCATION = 'abfss://enriched@csresearchdpolaplakest.dfs.core.windows.net/erpcore/AdventureWorks/')

CREATE EXTERNAL FILE FORMAT ParquetFileFormat
WITH
(  
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)