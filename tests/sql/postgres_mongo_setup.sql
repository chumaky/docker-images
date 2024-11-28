create extension mongo_fdw;
create server mongo foreign data wrapper mongo_fdw options (address 'mongo', port '27017', authentication_database 'admin');
create user mapping for postgres server mongo options (username 'root', password 'root');

create foreign table users
( _id    name
, id     int
, name   text
) server mongo;

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
