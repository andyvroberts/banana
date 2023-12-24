# Introduction
Microsoft Analysis Services currently has 3 products.  They all use the Vertipaq data engine and can be queried using DAX functions.   A DAX function usually results in the creation of a Measure for analytic purposes, or creation of Comparisons for operational purposes.   
https://learn.microsoft.com/en-us/analysis-services/analysis-services-overview?view=asallproducts-allversions  

The products are:
1. SQL Server Analysis Services (SSAS)
2. Azure Analysis Services (AAS)
3. Power BI

Power BI can connect to the databases (models) from both on-premises (SSAS) and Azure (AAS) models.  

## Component Definitions
### Vertipaq / xVelocity
This is the *columnar* in-memory database used by Microsoft to store and *compress* data within Tabular Models.  

A Vertipaq database is created and embedded in:
- SSAS server when you create a Model
- Excel, when you create a local copy of SSAS data using Power Pivot
- Power BI Models that contain imported data 

Vertipaq provides several mechanisms for optimising data storage, this lists some of them:
- Value Encoding of columns, stores data in as few bytes as possible
- Dictionary Encoding of repeated data values by replacing text with numerical values, which are translated back by dictionary lookup
- Run-length Encoding, where a repeated and contiguously stored column value is only stored once, and the number of occurrences (the run length) is stated.  For exmaple, low-cardinaltity columns such as frequently occuring flags.


### Data Analysis Expressions (DAX)
A column-oriented, declarative, query synatax.  DAX has two main purposes:
1. Aggregation (to create measures)
2. Filters (to drill down or to make comparisons)

#### Aggregation
Measures are calculated by performing aggregations on Facts.  
```
MonthlySales = CALCULATE ( SUM ( Prices[Price] ), BusinessDate[Sale Month])
```

#### Filter
In order to compare an aggregation of a Fact by Dimensions, use a _Filter_ expression.  
```
1999Sales = CALCULATE ( SUM ( Prices[Price] ), 
    FILTER ( BusinessDate, [Sale Year] = 1999 ) )
```


#### Data Refresh
All calculated columns are re-created whenever the database table is refreshed.  
All aggregations are only computed at runtime and so have no persistant storage.  

### Direct Query
The ability to convert DAX forumula's into relational SQL queries that can run directly on:
- A SQL Server database
- A Parquet file

However, relational queries are row-oriented and so using Direct Query may result in reduced performance, when compared to DAX statements that run against the Vertipaq database.  


