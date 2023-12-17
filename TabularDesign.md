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

## Mode 1: Create the Model
### Import Data via Data Source
From the *Tabular Model Explorer*, right click on "Data Sources" and connect/get data.  
Select all the PricesPaid database tables and import.  This loads all the data into the model (in memory).  

### Import Data via Expressions
From the *Tabular Model Explorer*, right click on "Expressions" and enter a SQL query, embedded within a Power Query.  


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
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_business_date = Source{[Schema="dbo",Item="business_date"]}[Data],
    #"Renamed Columns" = Table.RenameColumns(dbo_business_date,{{"date_display", "Sale Date"}, {"date_yyyy", "Sale Year"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns", "Sale Month", 
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
)
in
    #"Added Custom"
```

#### 2. Land Ownership (Dimension)
When importing the land ownership table make these column changes:
- rename: ownership desc = land use type
- remove: ownership type

Power Query:
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_land_ownership = Source{[Schema="dbo",Item="land_ownership"]}[Data],
    #"Renamed Columns" = Table.RenameColumns(dbo_land_ownership,{{"ownership_desc", "Land Use Type"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{"ownership_type"})
in
    #"Removed Columns"
```

#### 3. New Build (Dimension)
When importing the new build table make these column changes:
- create a new column called New Build with a value of Yes, No or blank
- remove: new_build_desc

Power Query:
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_new_build = Source{[Schema="dbo",Item="new_build"]}[Data],
    #"Renamed Columns" = Table.RenameColumns(dbo_new_build,{{"new_build_desc", "new_build_desc"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns", "New Build", 
    each 
        if [new_build_flag] = "Y" then "Yes" else
        if [new_build_flag] = "N" then "No" 
    else ""),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"new_build_desc"})
in
    #"Removed Columns"
```

#### 4. Property Address (Dimension)
When importing the addresses table make these column changes:
- create a new address column with concatenates paon, saon and street
- alter the new address column to be Capital Case (not all uppercase)
- remove the paon, saon and street
- rename: town to Town, and capitalise the word(s)
- rename: district to Districe and capitalise the word(s)
- rename: county to County and capitalise the word(s)

Power Query:
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_property_address = Source{[Schema="dbo",Item="property_address"]}[Data],
    #"Added Custom" = Table.AddColumn(dbo_property_address, "Address", 
    each 
        Text.Proper(Text.Lower(Text.Combine({[saon], [paon], [street]}, " ")))
    ),
    #"Renamed Columns" = Table.RenameColumns(#"Added Custom",{{"town", "Town"}}),
    #"Capitalized Each Word" = Table.TransformColumns(
        #"Renamed Columns",{{"Town", Text.Proper, type text}}),
    #"Renamed Columns1" = Table.RenameColumns(
        #"Capitalized Each Word",{{"district", "District"}}),
    #"Capitalized Each Word1" = Table.TransformColumns(
        #"Renamed Columns1",{{"District", Text.Proper, type text}}),
    #"Renamed Columns2" = Table.RenameColumns(
        #"Capitalized Each Word1",{{"county", "County"}}),
    #"Capitalized Each Word2" = Table.TransformColumns(
        #"Renamed Columns2",{{"County", Text.Proper, type text}}),
    #"Removed Columns" = Table.RemoveColumns(
        #"Capitalized Each Word2",{"paon", "saon", "street"})
in
    #"Removed Columns"
```

#### 5. Property Location (Dimension)
When importing the property locations, make these column changes:
- rename: locality to Locality, and capitalise the word(s)
- rename: postcode to Postcode

Power Query:
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_property_location = Source{[Schema="dbo",Item="property_location"]}[Data],
    #"Renamed Columns" = Table.RenameColumns(dbo_property_location,{{"locality", "Locality"}}),
    #"Capitalized Each Word" = Table.TransformColumns(
        #"Renamed Columns",{{"Locality", Text.Proper, type text}}),
    #"Renamed Columns1" = Table.RenameColumns(
        #"Capitalized Each Word",{{"postcode", "Postcode"}})
in
    #"Renamed Columns1"
```

#### 6. Property Type (Dimension)
When importing the property locations, make these column changes:
- rename: type desc to Property Type
- remove: type flag

Power Query:
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_property_type = Source{[Schema="dbo",Item="property_type"]}[Data],
    #"Renamed Columns" = Table.RenameColumns(dbo_property_type,{{"type_desc", "Property Type"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{"type_flag"})
in
    #"Removed Columns"
```

#### 7. Property Price (Fact)
Using the *Expressions* dialogue, create a new Query called "Prices".  In the editor dialogue, you must remember to right click the query name on the left-hand menu and tick the "Create Table" option, otherwise the expression will not actually create a table in the model.  

Power Query
```
= Value.NativeQuery(#"SQL/localhost;PricesPaid", "SELECT * FROM dbo.property_price")
```

Note: in order to rename any price columns, the transform must be hand coded into an more extensive Power Query.  

### Create Relationships
Foreign key relationships are only imported into the model, if you import all tables at once.  For example, click on every table from the "Data Sources" in the model explorer in VS before clicking on the 'import' button.  

After following the process described above, we now have to manually add all the relationships in the *Diagram View* canvas in VS.

So by right-clicking on each Dimension table in turn, you can quickly relate the dimension ID columns to the correct Fact table column.  

#### Manage Relationships
From the *Tabular Model Explorer*, right click on "Relationships" and choose "Manage Relationships".  From here create the same 1:m FKs between the Dimensions and Prices table.  

In an SSAS model, there can be only 1 active relationship between tables.  The active relationship is the one that can be used by Power Pivot or Query in Excel or Power BI for aggregations or other analytic functions.  Due to this, it is recommended that a strict Dimensional (or snowflake) model is created in SSAS.

For example, if a Fact table had two dates, a Sales date and a Payment date which both had relationships to a single Date Dimension, then only one of them can be used by the model (the one specifically marked as active in the model designer).

There are two possible solutions to this issue:
1. Create multiple copies of the Dimension from the datababase (e.g. a Sales Date + Payment Date Dimensions)
2. Create a calculated table (using DAX) by right-clicking on the "Tables" folder.  This copies the existing SSAS model table into a duplicate with a different name

It should also be mentioned that the creation of measures (aggregations and functions) using DAX is also best suited to strict Dimensional models.  For example, DAX syntax cannot support many to many relationships and performs poorly with wide de-normalised tables.  

The optimal format for an SSAS (or Power BI) tabular model is transactional data (Facts) connected to Dimensions that provide the ability to slice and filter using DAX functions.  

## Mode 2: Create the Model
Everything in Mode 1 can be pre-built in advance by using SQL Views.  
Views are used to disconnect the SSAS model from the database tables.  This protects the model from database changes and so reduces the number of times the SSAS model must be refreshed in the VS project, by developers.

Using views is the recommended approach, and so we will go back and create a Semantic Layer in the Prices Paid database, by using Views to include/exclude columns, rename columns, and to create the custom logic for some of the new fields we created in Mode 1.

### Import Data via Data Source
From the *Tabular Model Explorer*, right click on "Data Sources" and connect/get data.  
Select all the PricesPaid database views and import.  This loads all the data into the model (in memory) but still does not create the FK relationships.

In the SSAS model:
1. Create the relationships between the Fact and its Dimensions
2. Perform transformations that cannot be accomplished in SQL Server (e.g. Proper case)
3. Ensure the SSAS model can correclty sort of price date (e.g. Year and Month in calendar order)

These are the simpler Power Queries:  
#### 1. BusinessDate (Dimension)
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_BusinessDate = Source{[Schema="dbo",Item="BusinessDate"]}[Data],
    #"Changed Type" = Table.TransformColumnTypes(dbo_BusinessDate,{{"Date Sort", Int64.Type}})
in
    #"Changed Type"
```
#### 2. LandOwnership (Dimension)
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_LandOwnership = Source{[Schema="dbo",Item="LandOwnership"]}[Data]
in
    dbo_LandOwnership
```
#### 3. NewBuild (Dimension)
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_NewBuild = Source{[Schema="dbo",Item="NewBuild"]}[Data]
in
    dbo_NewBuild
```
#### 4. PropertyAddress (Dimension)
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_PropertyAddress = Source{[Schema="dbo",Item="PropertyAddress"]}[Data],
    #"Capitalized Each Word" = Table.TransformColumns(
        dbo_PropertyAddress,{
            {"Address", Text.Proper, type text}, 
            {"Town", Text.Proper, type text}, 
            {"District", Text.Proper, type text}, 
            {"County", Text.Proper, type text}
        }
    )
in
    #"Capitalized Each Word"
```
#### 5. Location (Dimension)
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_Location = Source{[Schema="dbo",Item="Location"]}[Data],
    #"Capitalized Each Word" = Table.TransformColumns(dbo_Location,{
        {"Locality", Text.Proper, type text}})
in
    #"Capitalized Each Word"
```
#### 6. PropertyType (Dimension)
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_PropertyType = Source{[Schema="dbo",Item="PropertyType"]}[Data]
in
    dbo_PropertyType
```
#### 7. Prices (Fact)
```
let
    Source = #"SQL/localhost;PricesPaid",
    dbo_Prices = Source{[Schema="dbo",Item="Prices"]}[Data]
in
    dbo_Prices
```

## Measures


<br>

### Memory Usage
VS used 6GB of RAM whilst loading the tables.  The original CSV data file is 4.8GB and the SQL Server database is 5GB.  If you only have 16GB of memory, this may be a problem, so 32GB is recommended if you want to try this development.  