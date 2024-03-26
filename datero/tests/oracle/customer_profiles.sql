conn sys/admin@//localhost:1521/xepdb1 as sysdba
create user oracle identified by oracle default tablespace users temporary tablespace temp quota unlimited on users;
grant connect to oracle;
grant create table to oracle;

-- next commands have to be executed under "oracle" user
conn oracle/oracle@//localhost:1521/xepdb1
create table customer_profiles(id int, customer_id int, category varchar(10));
alter table customer_profiles add constraint p_pk primary key (id);

insert into customer_profiles values (1, 1, 'Bronze');
insert into customer_profiles values (2, 2, 'Silver');
insert into customer_profiles values (3, 3, 'Gold');
