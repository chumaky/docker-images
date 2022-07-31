create schema mysql_fdw;
create extension mysql_fdw schema mysql_fdw;

create schema oracle_fdw;
create extension oracle_fdw schema oracle_fdw;


create server oracle foreign data wrapper oracle_fdw options (dbserver '//oracle:1521/orclpdb1.localdomain');
create user mapping for postgres server oracle options (user 'test', password 'test');
create foreign table oratab (id int options (key 'true')) server oracle options (schema 'TEST', table 'T');

create server mysql foreign data wrapper mysql_fdw options (host 'mysql', port '3306');
create user mapping for postgres server mysql options (username 'root', password 'root');
create schema mysql;

-- mysql startup takes approx 30 secs to initialize the database
-- in contrast postgres starts within second
-- we have to try import schema for one minute before raising an error
do $$
declare
   v_steps  int := 12;
   v_sleep  int := 5;
   idx      int;
begin
   for idx in 1..v_steps
   loop
      begin
         import foreign schema dev from server mysql into mysql;
         raise info using message = 'schema "dev" succesfully imported';
         exit;
      exception
         when others then
            raise info using message = concat('error code: ', sqlstate, ', message: ', sqlerrm);
            raise warning using message = 'mysql db is not initialized yet. sleeping for ' || v_sleep || ' seconds...';
            perform pg_sleep(v_sleep);
      end;
   end loop;
end;
$$;


