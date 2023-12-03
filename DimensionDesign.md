# Dimensional Models
Within databases, a dimensional model is data organised in relational tables, but optimised for aggregation and grouping operations on Facts.

A Fact is usually some numerical value.  For example, a property Price.  
However, this is not a strict rule, as in some complex circumstances, a fact may also be a date or sometimes a string code value.

A Dimension is additional, related, or relevent business information that is associated to a Fact.  For example, the Month a property was sold, or the Geographic Region of that property.

A Dimension is used to filter (exclude or include) Fact values, and performing such an operation usually creates measures.  For example, Total Monthly Sales.  In this case, the Price is the Fact and the Sale Date is the Dimension. These are combined to generate a Measure.

Many Dimensional data models located within databases are directly queried by by automated processes and jobs.  These types of models usually exist for large-scale batch processing as an intermmediate stage between the source data and some product of calculated values.  A good example is financial risk calculations.

Other Dimensional models are required for reporting or other end-user analytics.  In these cases it is common for Dimensional models to also be loaded into consumer friendly tools.  In the case of the Microsoft SQL Server stack, these are tabular model examples:
- for older implementations, SSAS Cubes.
- for newer implementations, Power BI models,
  
## Creating a Fact
Facts are the first items that need to be identified from the source data.  
Each fact should be measurable.  

| Column | Type | Example | Measure Types |
|- |- |- |- | 
|Price |Amount | 1,750,000 |Sum, Avg, Min, Max, Count |

Within the Land Registry Prices file, only the *Price* element matches this criteria.  And so this is our simple and single Fact.  

### Non-Aggregating Facts
Whilst it is certainly possible to create Dimensional models where the Fact cannot be aggregated, I would not recommend it.   

A widely used example is the requirement to store and report on Monthly Balances, be they billing or bank account balances, etc.  These non-aggegating facts are ideally suited to being organised into data-marts.  

#### Data-Marts
There are many definitions for data-marts, but the one characteristic they all have in common is that they contain *Subject-Specific* data.  These marts can be modelled in two ways:  
- As a small relational model
- As a single de-normalised entity

Modern data storage and organisation methods favour the de-normalised approach, as these can be more easily consumed by analytic tools such as Power BI or consumed by big-data processes.  

### Fact Keys
Fact tables do not require a primary key.  
There is no required access path to just a single record within a Fact table, and there is no requirement to enforce technical (*surrogate*) uniqueness of rows.  


## Creating a Dimension
The Dimensions are created from required source data that are not Facts. However, there must be an known relation between the Fact and its Dimensions.   There are two ways to create Dimensions:  
1. A Dimension is extracted from de-normalised data that also contains the Fact.
2. A Dimension is linked to a Fact in the data source, by means of:
    - A mandatory Foreign Key: the Dimension will always exist.
    - An optional Foreign Key: the Dimension may sometimes exist.
    - A matching identifier between the Fact and another data entity within the source data, but where there is no explicit Foreign Key: the Dimension may sometimes exist.

<br> 
  
| Column | Type | Example |
|- |- |- |
|Price Date|Date|21/11/1998 00:00:00|
|Postcode|Postal Sorting Code|MK3 9AU|
|Property Type|Single character code|D, L, F|
|New Build Flag|Y or N Code|Y=yes, N=no|
|Land Ownership Type|Single character Code|F or L|
|PAON|Varying String|Flat 3a|
|SAON|Varying String|45|
|Street|Varying String|Elmtree Road|
|Locality|Name|Ashburnham|
|Town|Varying String|Ashburnham|
|District|Varying String|Waltham Under Lyme|
|County|Name|Essex|
|PPD Category|Single character Code|A|
|Record Type|Single Character Code|A, U, D|
  

The next stage is to create Dimension entities (tables) from our list of Dimension data elements.  
In order to create the most useful ones, you must understand how the data wihtin the model will be used.  

Regardless of the Dimensional model purpose, be it batch data processing or end-user analytics, this activity is closer to Business Analysis than it is to database design.  

### Dimension Keys
There are only two types of keys required for Dimensions.
1. Surrogate (primary key)
2. Business (sometimes called Natural)

A **Surrogate** key has only one very specific function.  

It provides an index lookup, for the database engine to join Dimension tables to Fact tables.  This key should always be an integer, as small as can possibly be managed given the expected number of rows.  The technical reason for this is that a digit is usually stored by RDBMS software in half a byte, whereas an alphanumeric character requires 1 full byte.  For example, a Dimension with 10 million rows will require at most, 4 bytes per surrogate key entry in its index.

The index created on a surrogate key must be extremely compact, as this will vastly improve the efficiency when performing a filter operation of a Fact by picking one or more Dimension values.  Some database systems use bitmap-indexes to make these even smaller and more efficient, however SQL Server does not.

A **Business** key has two very specific functions.  

It provides the uniqueness for the updates or inserts of data rows into the Dimension table.  Any new data with the same business key will be treated as an update (or a new version) for an existing record.  Otherwise a new Dimension record will be created. 

When loading Facts, it provides a lookup between the source data and the recently created Dimension, in order to find the Dimension Surrogate key that is inserted into the Fact record.  


## Dimension Tables
The most common problem with Dimensions in these models, is what to do with changes to the Dimension data values over time.  For example, given an address, some Streets may be renamed.  

This creates problems.  How do we accomodate that change if we need to refer to the previous street name when calculating historical statistics.  Or perhaps all historical calculation results need to be presented as the current street name.  There are several ways to solve this, using SCD (slowly changing Dimension) types:
|SCD Type|Additional Columns|Result|
|- |- |- |
|1|None|All data elements are overwritten and no history is kept.  Evey calculation has a current context only.|
|2|Start & End dates|The current record has a NULL end date.  All previous records have a populated start and end date, which can be used to see historical perspectives.|
|3|Previous Value|The dimension record can hold previous values by repeating the same column multiple times (e.g. 3 street name columns for 3 historical versions).  Any older history is lost.|

Dimensions within the same model may be created with different SCD types, depending on the requirements.  But if Dimensional models are always rebuilt to only show the current context, then only SCD Type 1 is needed.  This is the example we will create below.  

A final note on Dimension names.  You may create tables prefixed or suffixed by the word *Dim*.  This is OK.  Alternatively the difference between Facts and Dimension may also be apparent from their names.  In the examples below, we will not prefix names with Fact or Dim.

### Property Location
Requirement: Provide statistical calculations on price, by Postcode, or the combination of Postcode and one of its localities.  
SCD type 1
|Data Element|Key Type|Index|
|- |- |- |
|ID|Surrogate|Primary|
|Postcode|Business/Natural|None|
|Locality|Business/Natural|None|

### Property Address
Requirement: Provide statistical calculations on price, by any element of an address.  For example, by Town or County or Street name.  
SCD type 1
|Data Element|Key Type|Index|
|- |- |- |
|ID|Surrogate|Primary|
|PAON|Business/Natural|None|
|SAON|Business/Natural|None|
|Street|Business/Natural|None|
|Postcode|Business/Natural|None|
|Town|Business/Natural|None|
|District|Business/Natural|None|
|County|Business/Natural|None|

As can be deduced from the busines key, an address dimension may have the side-effect of combining multiple records in the source data into a single Address.  The result may be the incorrect association of multiple actual properties to just a single address in this model, leading to incorrect aggregations.

There is no modeling solution to this problem, the data must be quality checked prior to being used, and either corrected or excluded from the implementation.  

### Property Type
Requirement: Provide statistical calculations on price, by grouping on properties that are houses, flats, etc.  
SCD type 1.
|Data Element|Key Type|Index|
|- |- |- |
|ID|Surrogate|Primary|
|Property Type|Business/Natural|None|

### Land Ownership Type
Requirement: Provide statistical calculations on price, by grouping on properties that are either Lease or Free-holds.  
SCD type 1.
|Data Element|Key Type|Index|
|- |- |- |
|ID|Surrogate|Primary|
|Land Ownership Type|Business/Natural|None|

### New Build Flag
Requirement: Provide statistical calculations on price, by grouping on properties that are new or old (existing).  
SCD type 1.
|Data Element|Key Type|Index|
|- |- |- |
|ID|Surrogate|Primary|
|New Build Flag|Business/Natural|None|

### Business Date
Requirement: Provide the ability to group and aggregate prices by sale date, month and/or year.  
SCD type 1.
|Data Element|Key Type|Index|
|- |- |- |
|ID|Surrogate|Primary|
|Date YYYYMMDD|Business/Natural|Unique|
|Date MM||None|
|Date YYYY||None|  

It is common in Dimensional models to have at least one date/time entity, as there is usually more than one business date related to the Facts, either reported or used in calculations.  One Date Dimension can be used to satisfy all required dates.   
For this reason, it is also sometimes optimal to pre-populate a Date Dimension from the earliest date required, to several years in the future, removing the need to continually rebuild/reload the table in the database.  

### Null Dimensions
Within the Land Registry Property Prices dataset, there are many instances where an entire Dimension record has a NULL value.  A good example is the *Locality*, and in rarer occasions, the *Postcode*.   

To know if this matters or not, the model designer must understand if queries will be made to specifically capture measures regarding negative conditions.  
For example, what is the sum of property prices in January, which have no captured Postcode?   

The answer to this question may identify those data values which will skew statistical analysis.  

If this is important then a Dimension record must be created where the Business key of that Dimension is Null:  
- For a single column key, there is a valid corresponding Surrogate key where the column is Null.
- Fro a composite colulmn key, there is a valid corresponding Surrogate key where all columns are Null.

This will allow queries on the Fact table to group/filter by a Null *Locality* and *Postcode*.

Sometimes, a non-null string value can be substituted instead of Null, but this provides no additional beneift.  Most RDBMS optimizers provide very good IS NULL / NOT NULL predicate filtering.  

<br> 


## Indexing
### Fact Table Indexes
One index is required for each Surrogate Dimension key.  This is the same as the standard practice of indexing foreign keys.  

### Dimension Table Indexes
A primary key in a Dimension, is an index on the Surrogate key.  
  
In addition, an index should be created on each business key (be it constructed from a single column or composite columns).  


### SQL Server Clustered Indexes
We should mention this as it is specific to SQL Server.  Any database table may have just one clustered index.  This is not really an index in the traditional sense, but an organisation strategy for the table rows.  The clustered column provided in the index specification is the order in which the table data is stored.  For exmaple, if we were to create one on the Land Ownership Type, then the table rows would first contain all the Freehold records (contiguously) and then all the Leasehold records (contiguously).   

Dimensional data models are not good candidates for Clustered Indexes, due to the variety of access patterns from the many dimensional filters that can be applied to queries.  

<br> 

## SQL Server Features for Dimensional Models
### Temporal Tables
An RDMBS feature that creates a second physical table within which SQL Server automatically captures previous versions of an entire Dimension table row, and makes the history relatively easy to query.    
https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables?view=sql-server-ver16  

This could be a useful feature in circumstances where tools such as Power BI are directly connected to the database tables.

