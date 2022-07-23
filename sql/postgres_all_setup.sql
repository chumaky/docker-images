create schema mongo_fdw;
create extension mongo_fdw schema mongo_fdw;

create schema tds_fdw;
create extension tds_fdw schema tds_fdw;

create schema file_fdw;
create extension file_fdw schema file_fdw;

create schema postgres_fdw;
create extension postgres_fdw schema postgres_fdw;

-- TODO: make "mysql", "oracle" and "sqlite" FDWs part of "postgres_fdw" image
--create schema mysql_fdw;
--create extension mysql_fdw schema mysql_fdw;

--create schema oracle_fdw;
--create extension oracle_fdw schema oracle_fdw;

--create schema sqlite_fdw;
--create extension sqlite_fdw schema sqlite_fdw;
