# About
Postgres database images with different foreign data wrapper extensions installed.

**IMPORTANT:**
> Docker doesn't support auto builds feature for free anymore.
>Also it doesn't show any digest or statistics for manually pushed tags.
> Nevertheless, these tags are fetchable and safe to use.
> Please check **Tags** tab at Docker hub to see custom tags available.


## Contents
- [Docker/Image files](#dockerimage-files)
  - [Initialization files](#initialization-files)
  - [Available tags](#available-tags)
- [All inclusive image](#all-inclusive-image)
  - [Available tags](#available-image-tags)
- [Image building](#image-building)
- [Demos](#demos)
- [Contribution](#contribution)

### Docker/Image files
- `postgres_<dbname>.docker`
  - Base image building file referenced in docker's documentation as `Dockerfile`.
- `postgres_<dbname>_compose.yml`
  - Compose files to showcase a demo how to connect from `postgres` to different databases such as `mysql`.

FDW official repo|Image|Dockerfile|Demo compose/schell script
-|-|-|-
[mysql_fdw](https://github.com/EnterpriseDB/mysql_fdw)|[postgres_mysql_fdw](https://hub.docker.com/r/toleg/postgres_mysql_fdw)|[postgres_mysql.docker](postgres_mysql.docker)|[postgres_mysql_compose.yml](postgres_mysql_compose.yml)
[oracle_fdw](https://github.com/laurenz/oracle_fdw)|[postgres_oracle_fdw](https://hub.docker.com/r/toleg/postgres_oracle_fdw)|[postgres_oracle.docker](postgres_oracle.docker)|[postgres_oracle_compose.yml](postgres_oracle_compose.yml)
[sqlite_fdw](https://github.com/pgspider/sqlite_fdw)|[postgres_sqlite_fdw](https://hub.docker.com/r/toleg/postgres_sqlite_fdw)|[postgres_sqlite.docker](postgres_sqlite.docker)|[postgres_sqlite_compose.sh](postgres_sqlite_compose.sh)
[mongo_fdw](https://github.com/EnterpriseDB/mongo_fdw)|[postgres_mongo_fdw](https://hub.docker.com/r/toleg/postgres_mongo_fdw)|[postgres_mongo.docker](postgres_mongo.docker)|[postgres_mongo_compose.yml](postgres_mongo_compose.yml)
[tds_fdw](https://github.com/tds-fdw/tds_fdw)|[postgres_mssql_fdw](https://hub.docker.com/r/toleg/postgres_mssql_fdw)|[postgres_mssql.docker](postgres_mssql.docker)|[postgres_mssql_compose.yml](postgres_mssql_compose.yml)

For example, `postgres_mysql.docker` file specifies `postgres` database with `mysql_fdw` extension installed.
It will make it listed in `pg_available_extensions` system view but you still have to install it onto specific database as _extension_ via `CREATE EXTENSION` command.
Consequently, `postgres_mysql_compose.yml` file launches `postgres` and `mysql` databases within the same network as `postgres` and `mysql` hosts.


#### Initialization files
`sql` folder contains initialization files that simplifies creation of _foreign data wrapper_ extension and acessing data from an external database. Naming pattern is as follow:
- `<dbname>_setup.sql`
  - Create _non-postgres_ database and populate it with some data
- `postgres_<dbname>_setup.sql`
  - Create foreign data wrapper extension from within `postgres` to connect to `<dbname>` and access data from it.
- `postgres_all_setup.sql`
  - Create all available foreign data wrapper extensions within `postgres` in a separate schemas. Applicable only for [All inclusive image](#all-inclusive-image)


#### Available tags
Tag naming pattern is `<postgres_version>_fdw<fdw_version>`. For example, `13.5_fdw2.7.0` tag for `postgres_mysql_fdw` image means postgres `13.5` version with `2.7.0` fdw version installed.

Image|Tag
-|-
postgres_mysql_fdw|latest
postgres_mysql_fdw|14.2_fdw2.8.0
postgres_mysql_fdw|14.1_fdw2.7.0
postgres_mysql_fdw|13.5_fdw2.7.0
postgres_mysql_fdw|13.3_fdw2.6.0
postgres_sqlite_fdw|latest
postgres_sqlite_fdw|14.1_fdw2.1.1
postgres_sqlite_fdw|13.5_fdw2.1.1
postgres_oracle_fdw|latest
postgres_oracle_fdw|13.4_fdw2.4.0
postgres_mssql_fdw|latest
postgres_mssql_fdw|14.4_fdw2.0.2
postgres_mssql_fdw|14.3_fdw2.0.2
postgres_mssql_fdw|13.1_fdw2.0.2
postgres_mongo_fdw|latest
postgres_mongo_fdw|14.4_fdw5.4.0
postgres_mongo_fdw|14.3_fdw5.4.0
postgres_mongo_fdw|13.3_fdw5.2.9

### All inclusive image
- `postgres_all.docker`
  - All inclusive image which is built on top of individual postgres images with single FDW installed.

#### Available image tags
Tag naming pattern corresponds one to one to the official postgres tags.

Image|Tag
-|-
postgres_fdw|latest
postgres_fdw|14.4
postgres_fdw|14.3

### Image building
**Note:** If you use `docker` then just replace `podman` with `docker` in all commands below.

Build image tagged as `postgres_mysql` and launch `pg_fdw_test` container from it
```sh
$ podman build -t postgres_mysql -f postgres_mysql.docker

$ podman run -d --name pg_fdw_test -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres_mysql
6d6beb18e5b7036c058b2160bb9b57adf9011301658217abf67bea64471f5056

$ podman ps
CONTAINER ID  IMAGE                            COMMAND   CREATED        STATUS            PORTS                   NAMES
6d6beb18e5b7  localhost/postgres_mysql:latest  postgres  4 seconds ago  Up 4 seconds ago  0.0.0.0:5432->5432/tcp  pg_fdw_test
```

Login into the database and check that `mysql_fdw` is available for installation
```sh
$ podman exec -it pg_fdw_test psql postgres postgres
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


### Demos
- [Postgres with MySQL](https://chumaky.team/blog/postgres-mysql-fdw)
- [Postgres with Oracle](https://chumaky.team/blog/postgres-oracle-fdw)
- [Postgres with SQLite](https://chumaky.team/blog/postgres-sqlite-fdw)
- [Postgres with MongoDB](https://chumaky.team/blog/postgres-mongodb-fdw)
- [Postgres with MSSQL](https://chumaky.team/blog/postgres-mssql-fdw)


### Contribution
Any contribution is highly welcomed.
If you implementing new fdw image please keep corresponding file names accordingly to described pattern.

If you want to request some image to be prepared feel free to raise an issue for that.
List of available `FDW` implementations could be found on official postgres [wiki](https://wiki.postgresql.org/wiki/Foreign_data_wrappers).