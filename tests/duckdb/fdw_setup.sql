create extension duckdb_fdw;
create server duckdb foreign data wrapper duckdb_fdw options (database '/home/data/json_files.duckdb');
import foreign schema public from server duckdb into public;
create foreign table json_files (duck bigint) server duckdb options (table 'json_files_v');
