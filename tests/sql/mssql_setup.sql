-- paste custom mssql initialization script here
create database test;
go
use test;
go
create table users(id int, name nvarchar(10));
insert into users values (1, 'John');
insert into users values (2, 'Mary');
insert into users values (3, 'Peter');
go