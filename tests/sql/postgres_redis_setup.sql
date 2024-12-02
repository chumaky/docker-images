create extension redis_fdw;
create server redis foreign data wrapper redis_fdw options (address 'redis', port '6379');
create user mapping for postgres server redis /*options (password '')*/;

create foreign table users(key text, val text[])
server redis
options (database '0', tabletype 'hash', tablekeyprefix 'users:')
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
            raise notice 'waiting for redis seed data to be inserted...';
            perform pg_sleep(c_sleep_interval);
            i := i + 1;
            continue;
         end if;

         raise notice 'before:';
         for r in select users.* from users order by key loop
            raise notice 'key=%, val=%', r.key, r.val;
         end loop;

         raise notice '';
         raise notice 'operations:';
         raise notice 'insert into users (key, val) values (''users:4'', ''{id,4,name,asdf}'');';
         insert into users (key, val) values ('users:4', '{id,4,name,asdf}');

         raise notice 'update users set val = ''{id,2,name,qwer}'' where key = ''users:2'';';
         update users set val = '{id,2,name,qwer}' where key = 'users:2';

         raise notice 'delete from users where key = ''users:1'';';
         delete from users where key = 'users:1';

         raise notice '';
         raise notice 'after:';
         for r in select users.* from users order by key loop
            raise notice 'key=%, val=%', r.key, r.val;
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
