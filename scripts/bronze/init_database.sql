/*
Script Purpose : 
this script creates a new database names "datawarehouse" after checking if it already exists.
if the database exists, it is dropped amd recreated , Additionally the script sets up three schemas 
within the database : 'bronze' , 'silver' , 'gold'.

*/
use master; 
go

if exists (select 1 from sys.databases where name ='datawarehouse')
begin 
  -- orces it into single-user mode, meaning only one connection (yours) && forcibly disconnects all other users and rolls back their transactions immediately
alter database datawarehouse set single_user with rollback immediate;
drop database datawarehouse ; 
end; 
go 



create database DataWarehouse;
go
use DataWarehouse; 

-- create the schema of the datawarehouse  : 
go
create schema bronze; 
go
create schema silver;
go
create schema gold; 