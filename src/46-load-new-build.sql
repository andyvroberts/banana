-- ----------------------------------------------------------------------------
-- MERGE INTO NEW BUILD FLAG DIMENSION TABLE.
-- 
-- 
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS new_build_load;

CREATE PROCEDURE new_build_load
AS 
    MERGE INTO new_build AS tgt
        USING 
        (
            SELECT DISTINCT TRIM(new_build) AS new_build FROM prices_csv
            UNION
            SELECT NULL AS new_build
			EXCEPT
			SELECT new_build_flag FROM new_build
        )
        AS src(new_build)
        ON tgt.new_build_flag = src.new_build
    WHEN NOT MATCHED 
        THEN
            INSERT (new_build_flag) 
            VALUES (src.new_build)
;