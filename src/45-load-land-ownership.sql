-- ----------------------------------------------------------------------------
-- MERGE INTO LAND OWNERSHIP DIMENSION TABLE.
-- 
-- 
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS land_ownership_load;

CREATE PROCEDURE land_ownership_load
AS 
    MERGE INTO land_ownership AS tgt
        USING 
        (
            SELECT DISTINCT TRIM(land_ownership) AS land_ownership FROM prices_csv
            UNION
            SELECT NULL AS ownership_type
			EXCEPT
			SELECT ownership_type FROM land_ownership
        )
        AS src(ownership_type)
        ON tgt.ownership_type = src.ownership_type
    WHEN NOT MATCHED 
        THEN
            INSERT (ownership_type) 
            VALUES (src.ownership_type)
;