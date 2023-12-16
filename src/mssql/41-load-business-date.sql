-- ----------------------------------------------------------------------------
-- MERGE INTO BUSINESS DATE DIMENSION TABLE.
-- 
-- 
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS business_date_load;

CREATE PROCEDURE business_date_load
AS 
    WITH all_dates AS 
    (
        SELECT DISTINCT 
            FORMAT(price_date, 'yyyyMMdd') AS price_date,
            FORMAT(price_date, 'd MMMM yyyy') AS format_date
        FROM prices_csv
    )
    MERGE INTO business_date AS tgt
        USING 
        (
            SELECT price_date, format_date FROM all_dates
        )
        AS src(price_date, format_date)
        ON tgt.date_yyyymmdd = src.price_date
    WHEN NOT MATCHED 
        THEN
            INSERT (date_yyyymmdd, date_display) 
            VALUES (price_date, format_date)
;