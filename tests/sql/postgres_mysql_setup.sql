create extension mysql_fdw;
create server mysql foreign data wrapper mysql_fdw options (host 'mysql', port '3306');
create user mapping for postgres server mysql options (username 'root', password 'root');

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
         import foreign schema dev from server mysql into public;
         raise info using message = 'schema "dev" succesfully imported';
         exit;
      exception
         when others then
            raise warning using message = 'mysql db is not initialized yet. sleeping for ' || v_sleep || ' seconds...';
            perform pg_sleep(v_sleep);
      end;
   end loop;
end;
$$;


do $$
declare
   c_max_iterations constant int := 10;
   c_sleep_interval constant int := 5;
   i int := 0;
   r record;
begin
   while i < c_max_iterations loop
      begin
         raise notice 'users table row count: %', (select count(*) from users);

         raise notice 'before:';
         for r in select users.* from users order by id loop
            raise notice 'id=%, name=%', r.id, r.name;
         end loop;

         raise notice '';
         raise notice 'operations:';
         raise notice 'insert into users (id, name) values (4, ''asdf'');';
         insert into users (id, name) values (4, 'asdf');

         raise notice 'update users set name = ''qwer'' where id = 2;';
         update users set name = 'qwer' where id = 2;

         raise notice 'delete from users where id = 1;';
         delete from users where id = 1;

         raise notice '';
         raise notice 'after:';
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

