-- JDBC drivers
-- postgres: https://jdbc.postgresql.org/download/postgresql-42.7.3.jar
-- mysql: https://dev.mysql.com/downloads/connector/j/
-- select Platform Independent (Architecture Independent) from the dropdown
-- download the tar.gz file and extract the jar file - mysql-connector-j-9.0.0.jar
-- mount local folder with drivers to "/drivers" in container on run.


CREATE EXTENSION jdbc_fdw;

-- postgres public server
CREATE SERVER rnacentral
FOREIGN DATA WRAPPER jdbc_fdw
OPTIONS (
		drivername 'org.postgresql.Driver',
		url 'jdbc:postgresql://hh-pgsql-public.ebi.ac.uk:5432/pfmegrnargs',
		querytimeout '60',
		jarfile '/drivers/postgresql-42.7.3.jar',
		maxheapsize '512'
);


CREATE USER MAPPING
FOR PUBLIC
SERVER rnacentral
OPTIONS (
    username 'reader',
    password 'NWDMCE5xdipIjRrp'
);

CREATE FOREIGN TABLE rnacen_xref (
    dbid smallint NOT NULL,
    created integer NOT NULL,
    last integer NOT NULL,
    upi character varying(26) NOT NULL,
    version_i integer NOT NULL,
    deleted character(1) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    userstamp character varying(20) NOT NULL,
    ac character varying(300) NOT NULL,
    version integer,
    taxid bigint,
    id bigint
)
SERVER rnacentral
OPTIONS (
    schema_name 'rnacen',
    table_name 'xref'
);

/*
SELECT *
FROM rnacen_xref
LIMIT 10;
*/

-- mysql public server
CREATE SERVER rfam
FOREIGN DATA WRAPPER jdbc_fdw
OPTIONS (
		drivername 'com.mysql.jdbc.Driver',
		url 'jdbc:mysql://mysql-rfam-public.ebi.ac.uk:4497/Rfam',
		querytimeout '60',
		jarfile '/drivers/mysql-connector-j-9.0.0.jar',
		maxheapsize '512'
);


CREATE USER MAPPING
FOR PUBLIC
SERVER rfam
OPTIONS (
    username 'rfamro',
    password ''
);

CREATE FOREIGN TABLE rfam_taxonomy (
    ncbi_id bigint,
    species varchar(100),
    tax_string varchar,
    tree_display_name varchar(100),
    align_display_name varchar(50)
)
SERVER rfam
OPTIONS (
    schema_name 'Rfam',
    table_name 'taxonomy'
);

/*
select * 
  from rfam_taxonomy
  limit 10
;
*/