# About
Postgres database image with install foreign data wrapper extensions for `mysql`, `sqlite` and `oracle` databases.

## Contents
- [Docker Files](#docker-files)
- [Usage](#usage)
- [Initialization files](#initialization-files)


### Docker files
- `postgres_<dbname>.docker`
  - Base image building file referenced in docker's documentation as `Dockerfile`.
- `postgres_<dbname>_compose.yml`
  - Compose files to showcase a demo how to connect from `postgres` to different databases such as `mysql`.

For example, `postgres_mysql.docker` file specifies `postgres` database with `mysql_fdw` module installed.
It will make it listed in `pg_available_extensions` system view but you still have to install it onto specific database as _extension_ via `CREATE EXTENSION` command.

Consequently, `postgres_mysql_compose.yml` file launches `postgres` and `mysql` databases within the same network as `postgres` and `mysql` hosts.


### Usage
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

Login into database and check that `mysql_fdw` is available for installation
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


### Initialization files
`sql` folder contains initialization files that simplifies creation of _foreign data wrapper_ extension and acessing data from an external database. Naming pattern is as follow:
- `<dbname>_setup.sql`
  - Create _non-postgres_ database and populate it with some data
- `postgres_<dbname> _setup.sql`
  - Create foreign data wrapper extension from within postgres to connect to `<dbname>` and access data from it.

**TODO:** add execution of initialization files as part of instance creation from compose files
