CREATE TABLE AdventureWorks.product_model
(
    ProductModelID INT NOT NULL,
    Name nvarchar(4000) NULL,
    CatalogDescription nvarchar(4000) NULL,
    rowguid nvarchar(4000) NULL,
    ModifiedDate nvarchar(30) NULL
)
WITH
(
    HEAP,  
    DISTRIBUTION = REPLICATE  
);
