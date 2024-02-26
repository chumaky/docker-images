create schema mysql_fdw;
create extension mysql_fdw schema mysql_fdw;
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
            raise warning using message = 'mysql db is not initialized yet. sleeping for ' || v_sleep || ' seconds...';
            perform pg_sleep(v_sleep);
      end;
   end loop;
end;
$$;


