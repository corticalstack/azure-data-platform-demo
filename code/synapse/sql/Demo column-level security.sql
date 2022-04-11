/*  HeadDataAnalytics user should be able to view all customer columns
    EnterpriseArchitectureTeam should not be able to see the customer's email address */

-- View existing users
select * from sys.database_principals

-- Create users
if not exists(select * from sys.database_principals where name = 'HeadDataAnalytics') create user [HeadDataAnalytics] without login;
if not exists(select * from sys.database_principals where name = 'EnterpriseArchitectureTeam') create user [EnterpriseArchitectureTeam] without login

select top 100 * from AdventureWorks.customer

revoke select on AdventureWorks.customer FROM EnterpriseArchitectureTeam;
grant select on AdventureWorks.customer([CustomerID], [NameStyle], [Title], [FirstName], [MiddleName], [LastName], [CompanyName]) TO EnterpriseArchitectureTeam;

-- Select will fail as user is restricted to some columns
execute as user ='EnterpriseArchitectureTeam';
select top 100 * from AdventureWorks.customer
revert;


-- The following query will succeed since we are not including the Revenue column in the query.
execute as user ='EnterpriseArchitectureTeam';
select[CustomerID], [NameStyle], [Title] from AdventureWorks.customer
revert;


-- Head of analytics gets to see every customer column
grant select on AdventureWorks.customer to HeadDataAnalytics

-- Step:6 Let us check if our CEO user can see all the information that is present. Assign Current User As 'CEO' and the execute the query
execute as user ='HeadDataAnalytics'
select top 100 * from AdventureWorks.customer
revert;