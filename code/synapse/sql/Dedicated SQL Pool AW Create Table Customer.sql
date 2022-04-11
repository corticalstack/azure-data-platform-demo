CREATE TABLE AdventureWorks.customer
(
    CustomerID INT NOT NULL,
    NameStyle BIT NULL,
    Title nvarchar(30) NULL,
    FirstName nvarchar(4000) NULL,
    MiddleName nvarchar(4000) NULL,
    LastName nvarchar(4000) NULL,
    Suffix nvarchar(30) NULL,
    CompanyName nvarchar(4000) NULL,
    SalesPerson nvarchar(4000) NULL,
    EmailAddress nvarchar(4000) NULL,
    Phone nvarchar(4000) NULL,
    PasswordHash nvarchar(4000) NULL,
    PasswordSalt nvarchar(4000) NULL,
    rowguid nvarchar(4000) NULL,
    ModifiedDate nvarchar(30) NULL
)
WITH
(
    DISTRIBUTION = HASH ( CustomerID ),
    CLUSTERED COLUMNSTORE INDEX
);  
