-- ----------------------------------------------------------------------------
-- MERGE INTO PROPERTY TYPE DIMENSION TABLE.
-- 
-- 
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS property_type_load;

CREATE PROCEDURE property_type_load
AS 
    MERGE INTO property_type AS tgt
        USING 
        (
            SELECT DISTINCT TRIM(property_type) AS property_type FROM prices_csv
            UNION
            SELECT NULL AS property_type
			EXCEPT
			SELECT type_flag FROM property_type
        )
        AS src(property_type)
        ON tgt.type_flag = src.property_type
    WHEN NOT MATCHED 
        THEN
            INSERT (type_flag, type_desc) 
            VALUES 
            (
                src.property_type,
                CASE src.property_type
                    WHEN 'D' THEN 'Detached'
                    WHEN 'T' THEN 'Terraced'
                    WHEN 'S' THEN 'Semi-Detached'
                    WHEN 'F' THEN 'Flat'
                ELSE 'Unknown' END
            )
;