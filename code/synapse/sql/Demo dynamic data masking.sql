select * from AdventureWorks.Customer;

-- Check no Dynamic Data Masking (DDM) applied
select c.name, tbl.name as table_name, c.is_masked, c.masking_function  
from sys.masked_columns AS c  
join sys.tables as tbl
    on c.[object_id] = tbl.[object_id]  
where is_masked = 1
    and tbl.name = 'Customer';


-- Mask customer email address
alter table AdventureWorks.Customer  
alter column EmailAddress add MASKED with (function = 'email()');
GO

-- Verify masking applied
select c.name, tbl.name as table_name, c.is_masked, c.masking_function  
from sys.masked_columns AS c  
join sys.tables as tbl
    on c.[object_id] = tbl.[object_id]  
where is_masked = 1
    and tbl.name = 'Customer';

-- Grant SELECT permission to user 'EnterpriseArchitectureTeam' on table 'Customer'
grant select on AdventureWorks.Customer to EnterpriseArchitectureTeam;  

-- Select from customer as 'EnterpriseArchitectureTeam'
execute as user = 'EnterpriseArchitectureTeam';  
select * from AdventureWorks.Customer

-- Remove the data masking using UNMASK permission
grant UNMASK to EnterpriseArchitectureTeam;
execute as user = 'EnterpriseArchitectureTeam';  
select * from AdventureWorks.Customer
revert;
revoke UNMASK TO EnterpriseArchitectureTeam;  

-- Revert all
alter table AdventureWorks.Customer
alter column EmailAddress drop MASKED;
go
