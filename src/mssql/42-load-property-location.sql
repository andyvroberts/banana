-- ----------------------------------------------------------------------------
-- MERGE INTO PROPERTY LOCATION DIMENSION TABLE.
-- 
-- 
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS property_location_load;

CREATE PROCEDURE property_location_load
AS 
    MERGE INTO property_location AS tgt
        USING 
        (
            SELECT DISTINCT TRIM(postcode) AS postcode, TRIM(locality) AS locality 
                FROM prices_csv
            UNION
            SELECT NULL AS postcode, NULL AS locality
			EXCEPT
			SELECT postcode, locality FROM property_location
        )
        AS src (postcode, locality)
        ON tgt.postcode = src.postcode AND tgt.locality = src.locality
    WHEN NOT MATCHED 
        THEN
            INSERT (postcode, locality) 
            VALUES (src.postcode, src.locality);
;