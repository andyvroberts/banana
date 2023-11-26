# SQL Server
Download and install the latest version.  
https://www.microsoft.com/en-us/sql-server/sql-server-downloads  

When creating your first server, set the local machine firewall rules to allow access to SQL Server and Analysis Server network ports.  
https://learn.microsoft.com/en-us/sql/sql-server/install/configure-the-windows-firewall-to-allow-sql-server-access?view=sql-server-ver16  

You can also use SQL Server Management Studio (SSMS), which for this excercise is the method used as we can manage both database servers and analysis servers.  
https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16  

Note: You can also connect to databases from Visual Studio, Azure Data Studio and even VS Code (with the MSSQL plugin).

## Create a Database
During the RDBMS software installation, you should have created a local SQL Server (but not a DB yet) on your machine.  This will be available through the *New Connection* dialogue in SSMS by typing in **localhost** into the Server Name.  

In SSMS, create a new database called PricesPaid.   
https://learn.microsoft.com/en-us/sql/relational-databases/databases/create-a-database?view=sql-server-ver16

### Create External Data Source
To access a CSV file on your local machine, define an external data source location.  
https://learn.microsoft.com/en-us/sql/relational-databases/databases/create-a-database?view=sql-server-ver16 

In order for this to work, you must have Polybase enabled on your SQL Server.  Mine was not, so it must be enabled manually (or via the SQL Server installation dialogue).  
https://learn.microsoft.com/en-gb/sql/relational-databases/polybase/polybase-installation?view=sql-server-ver16#enable 

Run the following  
```
exec sp_configure @configname = 'polybase enabled', @configvalue = 1;
RECONFIGURE;
```




