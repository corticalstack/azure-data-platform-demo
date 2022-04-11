select * from AdventureWorks.Customer;


/* Scenario: WWI requires that an Analyst only see the data for their own data from their own region. The CEO should see ALL data.
    In the Sale table, there is an Analyst column that we can use to filter data to a specific Analyst value. */

/* We will define this filter using what is called a Security Predicate. This is an inline table-valued function that allows
    us to evaluate additional logic, in this case determining if the Analyst executing the query is the same as the Analyst
    specified in the Analyst column in the row. The function returns 1 (will return the row) when a row in the Analyst column is the same as the user executing the query (@Analyst = USER_NAME()) or if the user executing the query is the CEO user (USER_NAME() = 'CEO')
    whom has access to all data.
*/

-- Review any existing security predicates in the database
select * from sys.security_predicates

-- New security schema to persist the security predicate
create schema Security
go


-- A predicate function returning TRUE (1) when a row should be returned in the parent query
create function Security.fn_securitypredicate(@CompanyName as NVARCHAR(128))  
    returns table  
with SCHEMABINDING  
as  
    return select 1 as fn_securitypredicate_result
    where @CompanyName = 'A Bike Store' and USER_NAME() = 'EnterpriseArchitectureTeam'
    or USER_NAME() = 'HeadDataAnalytics'
go

go
create security policy CustomerFilter  
    add filter PREDICATE Security.fn_securitypredicate(CompanyName)
    on AdventureWorks.Customer
    with (state = ON);
go

grant select on AdventureWorks.Customer TO HeadDataAnalytics, EnterpriseArchitectureTeam;

-- Select from the customer table as the 'EnterpriseArchitectureTeam' user, number of rows should be greatly restricted
execute as user = 'EnterpriseArchitectureTeam'
select * from AdventureWorks.Customer;
revert;


-- Step:5 The CEO should be able to see all rows in the table.
execute as user = 'HeadDataAnalytics';  
select * from AdventureWorks.Customer;
revert;
-- And he can.

--Step:6 To disable the security policy we just created above; we execute the following:
alter SECURITY POLICY CustomerFilter  
with (state = OFF);

drop security policy CustomerFilter;
drop function Security.fn_securitypredicate;
drop schema Security;