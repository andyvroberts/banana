-- ----------------------------------------------------------------------------
-- MERGE INTO PROPERTY ADDRESS DIMENSION TABLE.
-- SCD type 1 does not require a MERGE.
-- 
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS dbo.property_address_load;

CREATE PROCEDURE property_address_load
AS 
    WITH src AS 
    (
        SELECT DISTINCT paon, saon, street, postcode, town, district, county
            FROM prices_csv
        UNION 
        SELECT NULL AS paon, NULL AS saon, NULL AS street, NULL AS postcode,
            NULL AS town, NULL AS district, NULL AS county
    )
    INSERT INTO dbo.property_address
        (
            paon, saon, street, postcode, town, district, county
        )
        SELECT paon, saon, street, postcode, town, district, county 
            FROM src
        EXCEPT 
        SELECT paon, saon, street, postcode, town, district, county
            FROM dbo.property_address
;