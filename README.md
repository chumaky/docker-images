# About
Postgres database images with different foreign data wrapper (FDW) extensions installed.
Individual images with single FDW installed are used as a building blocks for the all inclusive image which contains all FDWs.
Multiple FDWs allow to access data from different by nature datasources within single `SELECT` statement.

In terms of classical definitions, it turns `postgres` into a [federated database system](https://en.wikipedia.org/wiki/Federated_database_system) which implements [SQL/MED](https://en.wikipedia.org/wiki/SQL/MED) extension of `SQL` standard. 
In more modern terms, it implements [data virtualization](https://en.wikipedia.org/wiki/Data_virtualization) feature.

> ## LATEST UPDATES
> With introduced recently [postgres_jdbc_fdw](#individual-fdw-images) image it's possible to connect to any datasource which has `JDBC` driver available.
This opens doors to almost any datasource from `postgres` database!
>
> Latest addition of [postgres_duckdb_fdw](#individual-fdw-images) enables connectivity to the awesome [DuckDB](https://duckdb.org/) database.
It in turn allows to query JSON, Excel, Parquet, and many other file types with SQL.

This approach is implemented in [Datero](https://datero.tech) data platform.
It's built on top of `postgres` database image with multiple `FDWs` isntalled.
It also provides GUI for setting up datasource connections and `SQL` editor.
Without any coding you could quickly setup data hub and start exploring your data.

Product is containerized and thus could be installed on-prem or in any cloud.
Demo is available in Datero [tutorial](https://datero.tech/docs/tutorial).
For more details, please check Datero [docs](https://datero.tech/docs).


# Contents
- [How It Works](#how-it-works)
- [Individual FDW images](#individual-fdw-images)
  - [Demo](#individual-fdws-demo)
  - [Available tags](#available-tags)
- [Datero image](#datero-image)
  - [Demo](#demo)
  - [Available tags](#available-image-tags)
- [Image building](#image-building)
- [Image sizing](#image-sizing)
- [Contribution](#contribution)


## How It Works
`Postgres` database has such a nice feature as `Foreign Data Wrapper`.
It allows to access data from some external source.
Be it some other database or just file. In case of database it might be `SQL` or `NoSQL` one.
There are plenty of different open source `FDW` extensions available.

What this project does is just compile and pack individual `FDW` extensions into the default postgres image.
Afterwards, uses these images to create all inclusive image which contains all `FDWs`.

Depending on your needs you could use either individual `FDW` image or all inclusive one.
In both cases you will have `postgres` database with `FDW` extension(s) available for installation/enablement.
All you have to do is enable corresponding extensions, put your credentials to the external datasources and start join them from inside postgres :)


## Individual FDW images
> Addition of `postgres_jdbc_fdw` image opens doors to any data source which has `JDBC` driver available.
Which is pretty much any database!

FDW official repo|Image|Dockerfile|Demo compose/schell script
-|-|-|-
[mysql_fdw](https://github.com/EnterpriseDB/mysql_fdw)|[postgres_mysql_fdw](https://hub.docker.com/r/chumaky/postgres_mysql_fdw)|[postgres_mysql.docker](v16/postgres_mysql.docker)|[postgres_mysql_compose.yml](tests/postgres_mysql_compose.yml)
[oracle_fdw](https://github.com/laurenz/oracle_fdw)|[postgres_oracle_fdw](https://hub.docker.com/r/chumaky/postgres_oracle_fdw)|[postgres_oracle.docker](v16/postgres_oracle.docker)|[postgres_oracle_compose.yml](tests/postgres_oracle_compose.yml)
[sqlite_fdw](https://github.com/pgspider/sqlite_fdw)|[postgres_sqlite_fdw](https://hub.docker.com/r/chumaky/postgres_sqlite_fdw)|[postgres_sqlite.docker](v16/postgres_sqlite.docker)|[postgres_sqlite_compose.sh](tests/postgres_sqlite_compose.sh)
[mongo_fdw](https://github.com/EnterpriseDB/mongo_fdw)|[postgres_mongo_fdw](https://hub.docker.com/r/chumaky/postgres_mongo_fdw)|[postgres_mongo.docker](v16/postgres_mongo.docker)|[postgres_mongo_compose.yml](tests/postgres_mongo_compose.yml)
[tds_fdw](https://github.com/tds-fdw/tds_fdw)|[postgres_mssql_fdw](https://hub.docker.com/r/chumaky/postgres_mssql_fdw)|[postgres_mssql.docker](v16/postgres_mssql.docker)|[postgres_mssql_compose.yml](tests/postgres_mssql_compose.yml)
[redis_fdw](https://github.com/pg-redis-fdw/redis_fdw)|[postgres_redis_fdw](https://hub.docker.com/r/chumaky/postgres_redis_fdw)|[postgres_redis.docker](v16/postgres_redis.docker)|[postgres_redis_compose.yml](tests/postgres_redis_compose.yml)
[jdbc_fdw](https://github.com/pgspider/jdbc_fdw)|[postgres_jdbc_fdw](https://hub.docker.com/r/chumaky/postgres_jdbc_fdw)|[postgres_jdbc.docker](v16/postgres_jdbc.docker)|[postgres_jdbc_setup.sql](tests/sql/postgres_jdbc_setup.sql)
[duckdb_fdw](https://github.com/alitrack/duckdb_fdw)|[postgres_duckdb_fdw](https://hub.docker.com/r/chumaky/postgres_duckdb_fdw)|[postgres_duckdb.docker](v16/postgres_duckdb.docker)|[postgres_duckdb_compose.yml](tests/postgres_duckdb_compose.yml)

File naming pattern is as follow:
- `postgres_<dbname>.docker`
  - Base image building file referenced in docker's documentation as `Dockerfile`.
- `postgres_<dbname>_compose.yml`
  - Compose files to showcase a demo how to connect from `postgres` to different databases such as `mysql`.

For example, `postgres_mysql.docker` file specifies `postgres` database with `mysql_fdw` extension installed.
It will make it listed in `pg_available_extensions` system view but you still have to install it onto specific database as _extension_ via `CREATE EXTENSION` command.
Consequently, `postgres_mysql_compose.yml` file launches `postgres` and `mysql` databases within the same network as `postgres` and `mysql` hosts.

### Individual FDWs Demo
- [Postgres with MySQL](https://chumaky.team/blog/postgres-mysql-fdw)
- [Postgres with Oracle](https://chumaky.team/blog/postgres-oracle-fdw)
- [Postgres with SQLite](https://chumaky.team/blog/postgres-sqlite-fdw)
- [Postgres with MongoDB](https://chumaky.team/blog/postgres-mongodb-fdw)
- [Postgres with MSSQL](https://chumaky.team/blog/postgres-mssql-fdw)


### Available tags
Tag naming pattern is `<postgres_version>_fdw<fdw_version>`. For example, `15.2_fdw2.9.0` tag for `postgres_mysql_fdw` image means postgres `15.2` version with `2.9.0` fdw version installed.


<details>
  <summary>Click to expand...</summary>

  > **IMPORTANT:** Docker doesn't support auto builds feature for free anymore.
  Also it doesn't show any digest or statistics for manually pushed tags.
  Nevertheless, these tags are fetchable and safe to use.
  Please check **Tags** tab at Docker hub to see custom tags available.

  Image|Tag
  -|-
  postgres_mysql_fdw|latest
  postgres_mysql_fdw|17.0_fdw2.9.2
  postgres_mysql_fdw|16.5_fdw2.9.1
  postgres_mysql_fdw|16.4_fdw2.9.1
  postgres_mysql_fdw|16.3_fdw2.9.1
  postgres_mysql_fdw|16.2_fdw2.9.1
  postgres_mysql_fdw|15.2_fdw2.9.0
  -|-
  postgres_sqlite_fdw|latest
  postgres_sqlite_fdw|16.3_fdw2.4.0
  postgres_sqlite_fdw|16.2_fdw2.4.0
  postgres_sqlite_fdw|15.2_fdw2.3.0
  -|-
  postgres_oracle_fdw|latest
  postgres_oracle_fdw|16.3_fdw2.6.0
  postgres_oracle_fdw|16.2_fdw2.6.0
  postgres_oracle_fdw|15.2_fdw2.5.0
  -|-
  postgres_mssql_fdw|latest
  postgres_mssql_fdw|16.3_fdw2.0.3 (from master branch)
  postgres_mssql_fdw|16.2_fdw2.0.3 (from master branch)
  postgres_mssql_fdw|15.2_fdw2.0.3
  -|-
  postgres_tds_fdw|latest
  postgres_tds_fdw|16.3_fdw2.0.3 (from master branch)
  postgres_tds_fdw|16.2_fdw2.0.3 (from master branch)
  postgres_tds_fdw|15.2_fdw2.0.3
  -|-
  postgres_mongo_fdw|latest
  postgres_mongo_fdw|17.0_fdw5.5.2
  postgres_mongo_fdw|16.5_fdw5.5.1
  postgres_mongo_fdw|16.3_fdw5.5.1
  postgres_mongo_fdw|16.2_fdw5.5.1
  postgres_mongo_fdw|15.2_fdw5.5.0
  -|-
  postgres_redis_fdw|latest
  postgres_redis_fdw|16.3_fdw16.3.0
  postgres_redis_fdw|16.2_fdw16.2.0
  -|-
  postgres_jdbc_fdw|latest
  postgres_jdbc_fdw|16.3_fdw0.4.0
  postgres_jdbc_fdw|16.2_fdw0.4.0

  Image|Tag|DuckDB lib version
  -|-|-
  postgres_duckdb_fdw|latest|1.1.3
  postgres_duckdb_fdw|17.0_fdw1.1.2|1.1.3
  postgres_duckdb_fdw|16.3_fdw1.0.0|1.0.0
  postgres_duckdb_fdw|16.2_fdw1.0.0|1.0.0
  postgres_duckdb_fdw|16.2_fdw2.1.1|0.10.2

</details>


## Datero image
Datero engine image is built on top of individual postgres [images](#individual-fdw-images) with single FDW installed.
It's a mix image which contains all supported FDW extensions available for installation.

Image|Dockerfile
-|-
[datero_engine](https://hub.docker.com/r/chumaky/datero_engine)|[datero_engine.docker](datero/datero_engine_v16.docker)

Included FDWs:
Data Source|FDW
-|-
Oracle | oracle_fdw
TDS (MSSQL & Sybase) | tds_fdw
Mysql | mysql_fdw
Mongo | mongo_fdw
Redis | redis_fdw
DuckDB | duckdb_fdw
SQLite | sqlite_fdw
Postgres (built-in) | postgres_fdw
Flat Files (built-in) | file_fdw


### Demo
The most detailed demo is available in Datero [tutorial](https://datero.tech/docs/tutorial/).

A couple of simple demos are available in `demo` folder:
- [MSSQL - Mongo - SQLite](demo/mssql_mongo_sqlite/)
- [Oracle - Mysql](demo/oracle_mysql/)

Navigate to the `demo` folder and execute from it `docker-compose up -d`.
It will spin-up a few containers with postgres one at the end.
Inside postgres container there will be a view created in `public` schema.
That view will be joining data from foreign tables which are pointed to different source databases.


### Available image tags
Tag naming pattern corresponds one to one to the official postgres tags.

> Please check **Tags** tab at Docker hub to see custom tags available.

Image|Tag|Postgres
-|-|-
datero_engine|latest|16.3
datero_engine|16.3|16.3
datero_engine|16.2|16.2
datero_engine|15.2|15.2
datero_engine|14.4|14.4

### Compatibility Matrix
Table below shows which FDW version is included into which Datero release.
If there is no official FDW release available, version could be derived from some branch or commit hash.
For example, `TDS` FDW is built from `master` branch and `Redis` FDW is built from `REL_16_STABLE` branch.

There are also two built-in FDWs are available by default: `postgres_fdw` and `file_fdw`.
They are part of the official postgres distribution.

<details>
  <summary>Click to expand...</summary>

  Datero|Postgres|FDW|Version
  -|-|-|-
  16.3|16.3|mysql_fdw|2.9.1
  16.3|16.3|oracle_fdw|2.6.0
  16.3|16.3|sqlite_fdw|2.4.0
  16.3|16.3|mongo_fdw|5.5.1
  16.3|16.3|tds_fdw|2.0.3 (master branch)
  16.3|16.3|redis_fdw|16.3.0 (REL_16_STABLE branch)
  16.3|16.3|duckdb_fdw|1.0.0
  -|-|-|-
  16.2|16.2|mysql_fdw|2.9.1
  16.2|16.2|oracle_fdw|2.6.0
  16.2|16.2|sqlite_fdw|2.4.0
  16.2|16.2|mongo_fdw|5.5.1
  16.2|16.2|tds_fdw|2.0.3 (master branch)
  16.2|16.2|redis_fdw|16.2.0 (REL_16_STABLE branch)
  16.2|16.2|duckdb_fdw|2.1.1 (ahuarte47:main_9x-10x-support branch)
  -|-|-|-
  15.2|15.2|mysql_fdw|2.9.0
  15.2|15.2|oracle_fdw|2.5.0
  15.2|15.2|sqlite_fdw|2.3.0
  15.2|15.2|mongo_fdw|5.5.0
  15.2|15.2|tds_fdw|2.0.3
  -|-|-|-
  14.4|14.4|mysql_fdw|2.8.0
  14.4|14.4|oracle_fdw|2.4.0
  14.4|14.4|sqlite_fdw|2.1.1
  14.4|14.4|mongo_fdw|5.4.0
  14.4|14.4|tds_fdw|2.0.2
</details>


## Image building
Build image tagged as `postgres_mysql` and launch `pg_fdw_test` container from it
```sh
$ docker build -t postgres_mysql -f postgres_mysql.docker

$ docker run -d --name pg_fdw_test -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres_mysql
6d6beb18e5b7036c058b2160bb9b57adf9011301658217abf67bea64471f5056

$ docker ps
CONTAINER ID  IMAGE                            COMMAND   CREATED        STATUS            PORTS                   NAMES
6d6beb18e5b7  localhost/postgres_mysql:latest  postgres  4 seconds ago  Up 4 seconds ago  0.0.0.0:5432->5432/tcp  pg_fdw_test
```

Login into the database and check that `mysql_fdw` is available for installation
```sh
$ docker exec -it pg_fdw_test psql postgres postgres
```
```sql
psql (12.4)
Type "help" for help.

postgres=# select * from pg_available_extensions where name = 'mysql_fdw';
   name    | default_version | installed_version |                     comment
-----------+-----------------+-------------------+--------------------------------------------------
 mysql_fdw | 1.1             |                   | Foreign data wrapper for querying a MySQL server
(1 row)
```

## Image sizing
Table below shows additional size of the _decompressed_ images compared to the official postgres image.
Each FDW is compiled from sources.

Starting from 16.4 Postgres version there is multi-stage build introduced for docker files.
Now, FDW compilation is happening in the first stage and only binaries are copied to the final image.
This allows greatly reduce the final image size.
Now it differs only by the size of the FDW binaries themselves.
For example, `postgres_mysql_fdw` image size is only 3 MB bigger than the official `postgres` image.

For the 16.3 Postgres version and below there were cleanup commands executed after the compilation to minimize the image size.
But it wasn't cleanup everything.
Hence, added size is not 100% consisted of actual compiled FDW binaries.

The FDW images that blows up in size the most are `postgres_jdbc_fdw` and `postgres_oracle_fdw`.
The `postgres_jdbc_fdw` image requires JRE to be installed. 
This is the main reason for the size increase. 
As for `postgres_oracle_fdw`, it requires oracle client to be present on the host machine.
The most minimal in size oracle client is _basic_ instant client. But even it adds 81 MB to the image size.

Currently, `datero_engine` image contains all FDWs except `postgres_jdbc_fdw`.
The `jdbc_fdw` connector capabilities are under investigation.
Once it will be proved that it is stable and reliable, it will be included into the `datero_engine` image as well.

Image|Tag|Size, MB|Additional Size, MB|Size Grow, %
-|-|-|-|-
postgres|17.0|434|0|0
postgres_mysql_fdw|17.0_fdw2.9.2|437|3|0.7
postgres_mongo_fdw|17.0_fdw5.5.2|441|7|1.6
postgres_duckdb_fdw|17.0_fdw1.1.2|497|63|14.5
-|-|-|-|-
postgres|16.5|432|0|0
postgres_mysql_fdw|16.5_fdw2.9.1|435|3|0.7
postgres_mongo_fdw|16.5_fdw5.5.1|437|5|1.2
-|-|-|-|-
postgres|16.4|432|0|0
postgres_mysql_fdw|16.4_fdw2.9.1|434|2|0.5
-|-|-|-|-
postgres|16.3|432|0|0
postgres_tds_fdw|16.3_fdw2.0.3|455|23|5
postgres_redis_fdw|16.3_fdw16.3.0|455|23|5
postgres_mongo_fdw|16.3_fdw5.5.1|468|36|8
postgres_sqlite_fdw|16.3_fdw2.4.0|478|46|11
postgres_mysql_fdw|16.3_fdw2.9.1|489|57|13
postgres_duckdb_fdw|16.3_fdw1.0.0|513|81|19
postgres_oracle_fdw|16.3_fdw2.6.0|617|185|43
postgres_jdbc_fdw|16.3_fdw0.4.0|882|450|104
-|-|-|-|-
datero_engine|16.3|676|244|56


## Contribution
Any contribution is highly welcomed.
If you implementing new fdw image please keep corresponding file names accordingly to described pattern.

If you want to request some image to be prepared feel free to raise an issue for that.
List of available `FDW` implementations could be found on official postgres [wiki](https://wiki.postgresql.org/wiki/Foreign_data_wrappers).