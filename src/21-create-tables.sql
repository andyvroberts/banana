-- ----------------------------------------------------------------------------
-- DROP BEFORE CREATE
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.prices_csv;
DROP TABLE IF EXISTS dbo.property_location;
DROP TABLE IF EXISTS dbo.property_address;
DROP TABLE IF EXISTS dbo.property_type;
DROP TABLE IF EXISTS dbo.land_ownership;
DROP TABLE IF EXISTS dbo.new_build;
DROP TABLE IF EXISTS dbo.business_date;

-- ----------------------------------------------------------------------------
-- CSV IMPORT
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.prices_csv
(
    rowkey VARCHAR(38),
    price INT,
    price_date DATETIME,
    postcode VARCHAR(10),
    property_type CHAR(1),
    new_build CHAR(1),
    land_ownership CHAR(1),
    paon VARCHAR(256),
    saon VARCHAR(256),
    street VARCHAR(128),
    locality VARCHAR(128),
    town VARCHAR(128),
    district VARCHAR(128),
    county VARCHAR(128),
    ppd_category CHAR(1),
    record_type CHAR(1)
);

-- ----------------------------------------------------------------------------
-- DIMENSIONS
-- ----------------------------------------------------------------------------
CREATE TABLE property_location 
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    postcode VARCHAR(10),
    locality VARCHAR(128)
);

CREATE TABLE property_address
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    paon VARCHAR(256),
    saon VARCHAR(256),
    street VARCHAR(128),
    postcode VARCHAR(10),
    town VARCHAR(128),
    district VARCHAR(128),
    county VARCHAR(128),
);

CREATE TABLE property_type 
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    type_flag CHAR(1)
);

CREATE TABLE land_ownership 
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    ownership_type CHAR(1)
);

CREATE TABLE new_build 
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    new_build_flag CHAR(1)
);

CREATE TABLE business_date
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    date_yyyymmdd VARCHAR(8),
    date_mm AS CAST(SUBSTRING(date_yyyymmdd,5,2) AS INT),
    date_yyyy AS CAST(SUBSTRING(date_yyyymmdd,1,4) AS INT),
);

