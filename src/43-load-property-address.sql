-- ----------------------------------------------------------------------------
-- MERGE INTO PROPERTY ADDRESS DIMENSION TABLE.
-- EXEC property_address_load (80 seconds, creates 16.1million rows).
-- ----------------------------------------------------------------------------
DROP PROCEDURE property_address_load;

CREATE PROCEDURE property_address_load
AS 
    WITH all_addresses AS 
    (
        SELECT DISTINCT paon, saon, street, postcode, town, district, county
        FROM prices_csv
    )
    MERGE INTO property_address AS tgt
        USING all_addresses     AS src
        ON  tgt.paon = src.paon AND 
            tgt.saon = src.saon AND 
            tgt.street = src.street AND 
            tgt.postcode = src.postcode AND 
            tgt.town = src.town AND 
            tgt.district = src.district AND 
            tgt.county = src.county
    WHEN NOT MATCHED AND NOT EXISTS
        (
            SELECT src.paon, src.saon, src.street, src.street, src.postcode, src.town, src.district, src.county
            EXCEPT
            SELECT tgt.paon, tgt.saon, tgt.street, tgt.street, tgt.postcode, tgt.town, tgt.district, tgt.county
        )
        THEN
            INSERT (paon, saon, street, postcode, town, district, county) 
            VALUES 
            (
                src.paon, 
                src.saon, 
                src.street, 
                src.postcode, 
                src.town, 
                src.district,
                src.county
            );


16,081,212
14,244,288



