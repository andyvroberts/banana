# Banana
Dimensional modelling of the UK Land Registry **property prices** file into a SQL Server database.

Creation of an SSAS reporting cube (tabular) using the dimensional model as a data source.


## Land Registry Prices Paid Data
The data is pulished by the UK ONS.  
https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads  

| Column | Col Type | Info |
|- |- |- |
|Rowkey|GUID|source file guid|
|Price|Whole Number|£ with no decimals|
|Price Date|Date & Time|dd/mm/yyyy hh:mi:ss|
|Postcode|String|Post Office Sorting Key|
|Property Type|Code|D=detached, T=terraced, S=semi, F=flat|
|New Build Flag|Yes/No Flag|Y=yes, N=no|
|Land Ownership Type|Code|F=freehold, L=leasehold|
|PAON|String|Primary Address Object|
|SAON|String|Secondary Address Object (if a property is sub-divided, such as Flats)|
|Street|String|Street Name|
|Locality|String|Other Region Name|
|Town|String|Postal Town|
|District|String|Postal District|
|County|String|Local Governing Region|
|PPD Category|Code|Land Registry Data Category|
|Record Type|Code|Land Registry Record Type.  A=add, U=update, D=delete|

