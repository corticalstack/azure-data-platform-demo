DROP TABLE AdventureWorks.product
CREATE TABLE AdventureWorks.product
(
    ProductID INT NULL,
    Name nvarchar(4000) NULL,
    ProductNumber nvarchar(4000) NULL,
    Color nvarchar(4000) NULL,
    StandardCost decimal(20,6) NULL,
    ListPrice decimal(20,6) NULL,
    Size nvarchar(4000) NULL,
    Weight decimal(20,6) NULL,
    ProductCategoryID INT NULL,
    ProductModelID INT NULL,
    SellStartDate nvarchar(30) NULL,
    SellEndDate nvarchar(30) NULL,
    DiscontinuedDate nvarchar(30) NULL,
    ThumbNailPhoto nvarchar(4000) NULL,
    ThumbnailPhotoFileName nvarchar(4000) NULL,
    rowguid nvarchar(4000) NULL,
    ModifiedDate nvarchar(30) NULL
)
WITH
(
    DISTRIBUTION = HASH ( ProductID ),
    CLUSTERED COLUMNSTORE INDEX
);