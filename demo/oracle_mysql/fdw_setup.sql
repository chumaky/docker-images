-- install extensions
CREATE SCHEMA mysql_fdw;
CREATE EXTENSION mysql_fdw SCHEMA mysql_fdw;

CREATE SCHEMA oracle_fdw;
CREATE EXTENSION oracle_fdw SCHEMA oracle_fdw;

-- create foreign servers
CREATE SERVER oracle FOREIGN DATA WRAPPER oracle_fdw OPTIONS (dbserver '//oracle:1521/xepdb1');
CREATE USER MAPPING FOR postgres SERVER oracle OPTIONS (user 'test', password 'test');
CREATE SCHEMA oracle;

CREATE SERVER mysql FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host 'mysql', port '3306');
CREATE USER MAPPING FOR postgres SERVER mysql OPTIONS (username 'test', password 'test');
CREATE SCHEMA mysql;

-- import foreign schemas
SELECT datero.import_foreign_schema('dev', 'mysql', 'mysql');
SELECT datero.import_foreign_schema('TEST', 'oracle', 'oracle');

-- heterogeneous sql based view
CREATE OR REPLACE VIEW user_profiles AS
SELECT u.id             AS user_id
     , u.name           AS name
     , p.role           AS role
  FROM mysql.users      u
 INNER JOIN
       oracle.profiles  p
    ON u.id             = p.user_id
;