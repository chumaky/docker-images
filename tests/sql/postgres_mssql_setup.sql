create extension tds_fdw;
create server mssql foreign data wrapper tds_fdw options (servername 'mssql', port '1433', database 'test');
create user mapping for postgres server mssql options (username 'sa', password 'Mssql_2019');

create foreign table banner(version text)
server mssql
options (query 'select @@version as version')
;

create foreign table users(id int, name varchar)
server mssql
options (query 'select * from users')
;

do $$
declare
   c_max_iterations constant int := 10;
   c_sleep_interval constant int := 5;
   v_rows int;
   i int := 0;
   r record;
begin
   while i < c_max_iterations loop
      begin
         select count(*) into v_rows from users;
         raise notice 'users table row count: %', v_rows;

         if v_rows != 3 then
            raise notice 'waiting for seed data to be inserted...';
            perform pg_sleep(c_sleep_interval);
            i := i + 1;
            continue;
         end if;

         raise notice 'data:';
         for r in select users.* from users order by id loop
            raise notice 'id=%, name=%', r.id, r.name;
         end loop;

         exit;
      exception
         when others then
            raise notice 'error: %', SQLERRM;
            perform pg_sleep(c_sleep_interval);
            i := i + 1;
      end;
   end loop;
end;
$$;
