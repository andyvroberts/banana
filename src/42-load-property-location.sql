-- ----------------------------------------------------------------------------
-- MERGE INTO PROPERTY LOCATION DIMENSION TABLE.
-- EXEC property_location_load (6 seconds, creates 1.9million rows).
-- ----------------------------------------------------------------------------
CREATE PROCEDURE property_location_load
AS 
    MERGE INTO property_location AS tgt
        USING 
        (
            SELECT DISTINCT postcode, locality FROM prices_csv
            UNION
            SELECT NULL AS postcode, NULL AS locality
        )
        AS src
        ON tgt.postcode = src.postcode AND tgt.locality = src.locality
    WHEN NOT MATCHED 
        THEN
            INSERT (postcode, locality) 
            VALUES (src.postcode, src.locality)
;