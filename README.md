# About
Postgres database image with installed foreign data wrapper extensions for `mysql`, `sqlite` and `oracle` databases.

## Contents
- [Docker Files](#docker-files)
- [Initialization files](#initialization-files)
- [Image building](#image-building)
- [Demos](#demos)
  - [Postgres with MySQL](#postgres-with-mysql)

### Docker files
- `postgres_<dbname>.docker`
  - Base image building file referenced in docker's documentation as `Dockerfile`.
- `postgres_<dbname>_compose.yml`
  - Compose files to showcase a demo how to connect from `postgres` to different databases such as `mysql`.

For example, `postgres_mysql.docker` file specifies `postgres` database with `mysql_fdw` extension installed.
It will make it listed in `pg_available_extensions` system view but you still have to install it onto specific database as _extension_ via `CREATE EXTENSION` command.

Consequently, `postgres_mysql_compose.yml` file launches `postgres` and `mysql` databases within the same network as `postgres` and `mysql` hosts.


### Initialization files
`sql` folder contains initialization files that simplifies creation of _foreign data wrapper_ extension and acessing data from an external database. Naming pattern is as follow:
- `<dbname>_setup.sql`
  - Create _non-postgres_ database and populate it with some data
- `postgres_<dbname> _setup.sql`
  - Create foreign data wrapper extension from within `postgres` to connect to `<dbname>` and access data from it.


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
**Note:** If you use `docker` then just replace `podman` with `docker` in all commands below.

#### Postgres with MySQL
Start `mysql` and `postgres` instances. It will create inside `mysql` instance `dev` database with single `t(id int)` table and populate it with three values `1, 2, 3`.
```sh
$ podman-compose -f postgres_mysql_compose.yml up -d
```

Connect to `postgres` instance and select from `t` table stored in `mysql` database
```sh
$ podman exec -it postgres_postgres_1 psql postgres postgres
```
```sql
postgres=# select * from mysql.t;
 id
----
  1
  2
  3
(3 rows)
```

`DML` operations also work
```sql
postgres=# insert into mysql.t values (4);
INSERT 0 1
postgres=# delete from mysql.t where id = 1;
DELETE 1
postgres=# select * from mysql.t;
 id
----
  2
  3
  4
(3 rows)
```