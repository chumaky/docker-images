tag=$1

if [ -z "$tag" ]
then
  tag=latest
fi

rm -rf ./test.db
sqlite3 test.db < ./sql/sqlite_setup.sql

podman run -d --rm --name postgres_sqlite_test \
           -p 5432:5432 -e POSTGRES_PASSWORD=postgres \
           -v ./test.db:/tmp/test.db:z \
           -v ./sql/postgres_sqlite_setup.sql:/docker-entrypoint-initdb.d/postgres_sqlite_setup.sql:z \
           docker.io/toleg/postgres_sqlite_fdw:${tag}

podman exec postgres_sqlite_test chmod o+w /tmp/test.db

podman ps
