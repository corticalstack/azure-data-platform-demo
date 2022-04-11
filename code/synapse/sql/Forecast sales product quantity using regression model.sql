-- Create a stored procedure for storing the scoring script.
CREATE PROCEDURE AdventureWorks.ForecastSalesProductQuantity
AS
BEGIN
-- Select input scoring data and assign aliases.
WITH InputData AS
(
    SELECT
        CAST([OrderDate] AS [bigint]) AS [OrderDate],
        CAST([ProductID] AS [bigint]) AS [ProductID]
    FROM [AdventureWorks].[product_sales_forecast]
)
-- Using T-SQL Predict command to score machine learning models. 
SELECT *
FROM PREDICT (MODEL = (SELECT [model] FROM [AdventureWorks].[ForecastModel] WHERE [ID] = 'cs-eur-research-dp-synw-aw_forecast_product_sales-20220411063203-Best:1'),
              DATA = InputData,
              RUNTIME = ONNX) WITH ([variable_out1] [real])
END
GO

-- Execute the above stored procedure.
EXEC AdventureWorks.ForecastSalesProductQuantity