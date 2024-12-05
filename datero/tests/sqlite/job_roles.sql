drop table if exists job_roles;
create table job_roles(id int primary key, name text, department_id int);

insert
  into job_roles
values (1, 'owner', 1)
     , (2, 'manager', 2)
     , (3, 'salesman', 3)
;

-- database file is created via "sqlite3 job_roles.db < job_roles.sql" command
