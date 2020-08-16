create schema mysql_fdw;
create extension mysql_fdw schema mysql_fdw;
create server mysql foreign data wrapper mysql_fdw options (host 'mysql', port '3306');
create user mapping for postgres server mysql options (username 'root', password 'root');
create schema mysql;
import foreign schema dev from server mysql into mysql;
