Commands to build the images:

- docker build -t chumaky/postgres_mssql_fdw:16.2_fdw2.0.3 -f v16/postgres_mssql.docker v16
- docker build -t chumaky/postgres_mysql_fdw:16.2_fdw2.9.1 -f v16/postgres_mysql.docker v16
- docker build -t chumaky/postgres_mongo_fdw:16.2_fdw5.5.1 -f v16/postgres_mongo.docker v16
