# Build Images

```sh
docker build -t chumaky/postgres_mssql_fdw:16.2_fdw2.0.3 -f v16/postgres_mssql.docker .
docker build -t chumaky/postgres_mysql_fdw:16.2_fdw2.9.1 -f v16/postgres_mysql.docker .
docker build -t chumaky/postgres_mongo_fdw:16.2_fdw5.5.1 -f v16/postgres_mongo.docker .
docker build -t chumaky/postgres_oracle_fdw:16.2_fdw2.6.0 -f v16/postgres_oracle.docker .
docker build -t chumaky/postgres_sqlite_fdw:16.2_fdw2.4.0 -f v16/postgres_sqlite.docker .
docker build -t chumaky/postgres_duckdb_fdw:16.3_fdw1.0.0 -f v16/postgres_duckdb.docker .
```