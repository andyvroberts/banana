# Introduction
In order to build an SSAS tabular model, Visual Studio is required, and in particular both sql server data tools and the *analysis services projects 2022* package which contains the VS templates.  
https://marketplace.visualstudio.com/items?itemName=ProBITools.MicrosoftAnalysisServicesModelingProjects2022  

Double-click the vsix file to install it into VS.   Once you create a new "analysis services tabular" project, set the compatibility level to the latest (1600, which is SQL Server 2022).  

## Manage the VS Project
Once the project is created, change some settings in the  model.bim file, 
- Set *integrated workspace* to TRUE
- Set *workspace retention* to "unload from memory"

### Integrated Workspace [Database]
For the duration of the development process, a setting of TRUE means that a working database is created in Visual Studio memory, simplifying the development process. If the model is larger than RAM, set it to FALSE, which means the SQL Server instance is used.

If using the workspace database, copy the *workspace server* name from the model.bim and connect to the database using SSMS.  This makes it easier to see the database structure.  

## Create the Model
### Import Data
From the *Tabular Model Explorer*, right click on "Data Sources" and connect/get data.  
Select all the PricesPaid database tables and import.  This loads all the data into the model (in memory).  

### Filter Data on Import
If required, you can add filters on each table before import.  This runs a Power Query dialogue, letting you apply some transformations and/or filters on the source data.

The Power Query dialogue also lets you:
- rename the table
- limit the number of rows imported
- select specific columns from the table
- view the transformation declarations in the advanced editor

### Semantic Layer Changes
#### 1. Business Date (Dimension)
When importing the business date table, rename these columns:
- display_date = Sale Date
- date_yyyy = Sale Year

Make this transformation:
- create a new column to give each sale month it's wordy name
- name the column Sale Month

This is the resulting Power Query statement:
```
each 
    if [date_mm] = 1 then "January" else 
    if [date_mm] = 2 then "February" else 
    if [date_mm] = 3 then "March" else 
    if [date_mm] = 4 then "April" else 
    if [date_mm] = 5 then "May" else 
    if [date_mm] = 6 then "June" else
    if [date_mm] = 7 then "July" else
    if [date_mm] = 8 then "August" else
    if [date_mm] = 9 then "September" else
    if [date_mm] = 10 then "October" else
    if [date_mm] = 11 then "November" else
    if [date_mm] = 12 then "December" 
else [date_mm]
```

#### 2. Land Ownership (Dimension)
When importing the land ownership table make these column changes
- rename: ownership desc = land Use Type
- remove: ownership type

### Memory Usage
VS used 6GB of RAM whilst loading the tables.  The original CSV data file is 4.8GB and the SQL Server database is 5GB.  If you only have 16GB of memory, this may be a problem, so 32GB is recommended if you want to try this development.  