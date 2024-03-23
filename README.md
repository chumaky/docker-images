# About
Postgres database images with different foreign data wrapper (FDW) extensions installed.
Individual images with single FDW installed are used as a building blocks for the all inclusive image which contains all FDWs.
Multiple FDWs allow to access data from different by nature datasources within single `SELECT` statement.

In terms of classical definitions, it turns `postgres` into a [federated database system](https://en.wikipedia.org/wiki/Federated_database_system) which implements [SQL/MED](https://en.wikipedia.org/wiki/SQL/MED) extension of `SQL` standard. 
In more modern terms, it implements [data virtualization](https://en.wikipedia.org/wiki/Data_virtualization) feature.

This approach is implemented in [Datero](https://datero.tech) data platform.
It's built on top of `postgres` database image with multiple `FDWs` isntalled.
It also provides GUI for setting up datasource connections and `SQL` editor.
Without any coding you could quickly setup data hub and start exploring your data.

Product is containerized and thus could be installed on-prem or in any cloud.
For more details, please check Datero [docs](https://datero.tech/docs).

# Contents
- [How It Works](#how-it-works)
- [Demo](#demo)
- [Datero image](#datero-image)
  - [Available tags](#available-image-tags)
- [Individual FDW images](#individual-fdw-images)
  - [Demo](#individual-fdws-demo)
  - [Available tags](#available-tags)
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

## Demo
The most detailed demo is available in Datero [tutorial](https://datero.tech/docs/tutorial/).

A couple of simple demos are available in `demo` folder:
- [MSSQL - Mongo - SQLite](demo/mssql_mongo_sqlite/)
- [Oracle - Mysql](demo/oracle_mysql/)

Navigate to the `demo` folder and execute from it `docker-compose up -d`.
It will spin-up a few containers with postgres one at the end.
Inside postgres container there will be a view created in `public` schema.
That view will be joining data from foreign tables which are pointed to different source databases.


## Datero image
Datero engine image is built on top of individual postgres [images](#individual-fdw-images) with single FDW installed.
It's a mix image which contains all supported FDW extensions available for installation.

Image|Dockerfile
-|-
[datero_engine](https://hub.docker.com/r/chumaky/datero_engine)|[datero_engine.docker](datero/datero_engine_v16.docker)

Included FDWs:
- Oracle
- TDS (MSSQL & Sybase)
- Mysql
- Mongo
- Postgres (built-in)
- Flat Files (built-in)
- SQLite


### Available image tags
Tag naming pattern corresponds one to one to the official postgres tags.

> Please check **Tags** tab at Docker hub to see custom tags available.

Image|Tag|Postgres
-|-|-
datero_engine|latest|16.2
datero_engine|16.2|16.2
datero_engine|15.2|15.2
datero_engine|14.4|14.4

### Compatibility Matrix
Table below shows which FDW version is included into which Datero release.
If there is no official FDW release, version could be specified by the url to the corresponding source zip archive.
Datero new version will be created once all currently included FDWs will release a version which is compatible with the latest `postgres` version.

<details>
  <summary>Click to expand...</summary>

  Datero|Postgres|FDW|Version
  -|-|-|-
  16.2|16.2|Mysql|2.9.1
  16.2|16.2|Oracle|2.6.0
  16.2|16.2|SQLite|2.4.0
  16.2|16.2|Mongo|5.5.1
  16.2|16.2|TDS|master branch (2.0.3)
  -|-|-|-
  15.2|15.2|Mysql|2.9.0
  15.2|15.2|Oracle|2.5.0
  15.2|15.2|SQLite|2.3.0
  15.2|15.2|Mongo|5.5.0
  15.2|15.2|TDS|2.0.3
  -|-|-|-
  14.4|14.4|Mysql|2.8.0
  14.4|14.4|Oracle|2.4.0
  14.4|14.4|SQLite|2.1.1
  14.4|14.4|Mongo|5.4.0
  14.4|14.4|TDS|2.0.2
</details>


## Individual FDW images
File naming pattern is as follow:
- `postgres_<dbname>.docker`
  - Base image building file referenced in docker's documentation as `Dockerfile`.
- `postgres_<dbname>_compose.yml`
  - Compose files to showcase a demo how to connect from `postgres` to different databases such as `mysql`.

FDW official repo|Image|Dockerfile|Demo compose/schell script
-|-|-|-
[mysql_fdw](https://github.com/EnterpriseDB/mysql_fdw)|[postgres_mysql_fdw](https://hub.docker.com/r/chumaky/postgres_mysql_fdw)|[postgres_mysql.docker](v16/postgres_mysql.docker)|[postgres_mysql_compose.yml](tests/postgres_mysql_compose.yml)
[oracle_fdw](https://github.com/laurenz/oracle_fdw)|[postgres_oracle_fdw](https://hub.docker.com/r/chumaky/postgres_oracle_fdw)|[postgres_oracle.docker](v16/postgres_oracle.docker)|[postgres_oracle_compose.yml](tests/postgres_oracle_compose.yml)
[sqlite_fdw](https://github.com/pgspider/sqlite_fdw)|[postgres_sqlite_fdw](https://hub.docker.com/r/chumaky/postgres_sqlite_fdw)|[postgres_sqlite.docker](v16/postgres_sqlite.docker)|[postgres_sqlite_compose.sh](tests/postgres_sqlite_compose.sh)
[mongo_fdw](https://github.com/EnterpriseDB/mongo_fdw)|[postgres_mongo_fdw](https://hub.docker.com/r/chumaky/postgres_mongo_fdw)|[postgres_mongo.docker](v16/postgres_mongo.docker)|[postgres_mongo_compose.yml](tests/postgres_mongo_compose.yml)
[tds_fdw](https://github.com/tds-fdw/tds_fdw)|[postgres_mssql_fdw](https://hub.docker.com/r/chumaky/postgres_mssql_fdw)|[postgres_mssql.docker](v16/postgres_mssql.docker)|[postgres_mssql_compose.yml](tests/postgres_mssql_compose.yml)
[redis_fdw](https://github.com/pg-redis-fdw/redis_fdw)|[postgres_redis_fdw](https://hub.docker.com/r/chumaky/postgres_redis_fdw)|[postgres_redis.docker](v16/postgres_redis.docker)|[postgres_redis_compose.yml](tests/postgres_redis_compose.yml)


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


> **IMPORTANT:** Docker doesn't support auto builds feature for free anymore.
Also it doesn't show any digest or statistics for manually pushed tags.
Nevertheless, these tags are fetchable and safe to use.
Please check **Tags** tab at Docker hub to see custom tags available.

<details>
  <summary>Click to expand...</summary>

  Image|Tag
  -|-
  postgres_mysql_fdw|latest
  postgres_mysql_fdw|16.2_fdw2.9.1
  postgres_mysql_fdw|15.2_fdw2.9.0

  Image|Tag
  -|-
  postgres_sqlite_fdw|latest
  postgres_sqlite_fdw|16.2_fdw2.4.0
  postgres_sqlite_fdw|15.2_fdw2.3.0

  Image|Tag
  -|-
  postgres_oracle_fdw|latest
  postgres_oracle_fdw|16.2_fdw2.6.0
  postgres_oracle_fdw|15.2_fdw2.5.0

  Image|Tag
  -|-
  postgres_mssql_fdw|latest
  postgres_mssql_fdw|16.2_fdw2.0.3 (from master branch)
  postgres_mssql_fdw|15.2_fdw2.0.3

  Image|Tag
  -|-
  postgres_mongo_fdw|latest
  postgres_mongo_fdw|16.2_fdw5.5.1
  postgres_mongo_fdw|15.2_fdw5.5.0

  Image|Tag
  -|-
  postgres_redis_fdw|latest
  postgres_redis_fdw|16.2_fdw16.2.0

</details>


## Image building
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

## Image sizing
Table below shows additional size of the _decompressed_ images compared to the official postgres image.
Each FDW is compiled from sources.
There are cleanup commands are executed after the compilation to minimize the image size.
But there is no guarantee that it will cleanup everything.
Hence, added size is not 100% consist of actual compiled FDW binaries.

Surprisingly, all-inclusive `datero_engine` image is identical in size to the `postgres_oracle_fdw` image.
This is probably because that `oracle_fdw` image generates way more temporary files during the build process.
And these files are not easily identifiable and removable.

In addition, `oracle_fdw` requires some oracle client to be present on the host machine.
This adds 250 MB to the image size.

Anyway, `datero_engine` image contains all FDWs.

Image|Tag|Size, MB|Additional Size, MB|Size Grow, %
-|-|-|-|-
postgres|16.2|431|0|0
postgres_tds_fdw|16.2_fdw2.0.3|455|24|6
postgres_redis_fdw|16.2_fdw16.2.0|455|24|6
postgres_mongo_fdw|16.2_fdw5.5.1|468|37|9
postgres_sqlite_fdw|16.2_fdw2.4.0|477|46|11
postgres_mysql_fdw|16.2_fdw2.9.1|488|57|13
postgres_oracle_fdw|16.2_fdw2.6.0|727|296|69
datero_engine|16.2|727|296|69


## Contribution
Any contribution is highly welcomed.
If you implementing new fdw image please keep corresponding file names accordingly to described pattern.

If you want to request some image to be prepared feel free to raise an issue for that.
List of available `FDW` implementations could be found on official postgres [wiki](https://wiki.postgresql.org/wiki/Foreign_data_wrappers).