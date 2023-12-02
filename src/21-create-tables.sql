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
    id IDENTITY (1,1) PRIMARY KEY,
    postcode VARCHAR(10),
    locality VARCHAR(10)
);

CREATE TABLE property_address
(
    id IDENTITY (1,1) PRIMARY KEY,
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
    id IDENTITY (1,1) PRIMARY KEY,
    type_flag CHAR(1)
);
