create schema sqlite_fdw;
create extension sqlite_fdw schema sqlite_fdw;
create server sqlite foreign data wrapper sqlite_fdw options (database '/tmp/test.db');
create foreign table users(id int options (key 'true'), name varchar) server sqlite;
