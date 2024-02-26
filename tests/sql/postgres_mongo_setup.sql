create schema mongo_fdw;
create extension mongo_fdw schema mongo_fdw;
create server mongo foreign data wrapper mongo_fdw options (address 'mongo', port '27017', authentication_database 'admin');
create user mapping for postgres server mongo options (username 'root', password 'root');

create foreign table users
( _id    name
, id     int
, name   text
) server mongo;
