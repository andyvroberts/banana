-- ----------------------------------------------------------------------------
-- MERGE INTO PROPERTY ADDRESS DIMENSION TABLE.
-- 
-- 
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS property_address_load;

CREATE PROCEDURE property_address_load
AS 
    WITH src AS 
    (
        SELECT DISTINCT TRIM(paon) AS paon, TRIM(saon) AS saon, TRIM(street) AS street, 
                        TRIM(postcode) AS postcode, TRIM(town) AS town, 
                        TRIM(district) AS district, TRIM(county) AS county
            FROM prices_csv
        UNION 
        SELECT NULL AS paon, NULL AS saon, NULL AS street, NULL AS postcode,
            NULL AS town, NULL AS district, NULL AS county
    )
    INSERT INTO property_address
        (
            paon, saon, street, postcode, town, district, county
        )
        SELECT paon, saon, street, postcode, town, district, county 
            FROM src
        EXCEPT 
        SELECT paon, saon, street, postcode, town, district, county
            FROM property_address
;