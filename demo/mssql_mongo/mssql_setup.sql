-- paste custom mssql initialization script here
create database test;
go
use test;
go
create table branches(id int, region_id int, name nvarchar(10));
insert into branches values (1, 1, 'Finance');
insert into branches values (2, 1, 'Legal');
insert into branches values (3, 2, 'Manufacturing');
insert into branches values (4, 3, 'IT');
go