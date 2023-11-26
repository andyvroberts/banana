CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Polybase2CSV';

CREATE DATABASE SCOPED CREDENTIAL local_csv_file
WITH IDENTITY = 'username', SECRET = 'password';

select * from sys.database_scoped_credentials;

CREATE EXTERNAL DATA SOURCE ppCsv
WITH 
( 
    LOCATION = 'odbc://localhost',
    CONNECTION_OPTIONS = 'Driver=Microsoft Access Text Driver (*.txt, *.csv);Dbq=C:\Users\avrob\Downloads\',
    PUSHDOWN = OFF,
    CREDENTIAL = local_csv_file
);