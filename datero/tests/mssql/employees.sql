create database hr;
go
use hr;
go

create table employees (id int, name varchar(100), job_id int);
go

merge
 into employees as target
using
(
   values (1, 'John', 1)
        , (2, 'Bob', 2)
        , (3, 'Lisa', 3)
) as source (id, name, job_id)
on target.id = source.id
when not matched
then
   insert ( id
          , name
          , job_id
          )
   values ( source.id
          , source.name
          , source.job_id
          )
;
go
