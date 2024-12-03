#!/bin/bash
for i in {1..50};
do
    /opt/mssql-tools18/bin/sqlcmd -S mssql -No -U sa -P Mssql_2019 -d master -i mssql_setup.sql
    if [ $? -eq 0 ]
    then
        echo "setup completed"
        /opt/mssql-tools18/bin/sqlcmd -S mssql -No -U sa -P Mssql_2019 -d test -Q "select * from branches"
        break
    else
        echo "not ready yet..."
        sleep 1
    fi
done