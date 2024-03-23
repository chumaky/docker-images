create schema redis_fdw;
create extension redis_fdw schema redis_fdw;
create server redis foreign data wrapper redis_fdw options (address 'redis', port '6379');
create user mapping for postgres server redis /*options (password '')*/;

create foreign table users(key text, val text[])
server redis
options (database '0', tabletype 'hash', tablekeyprefix 'users:')
;

