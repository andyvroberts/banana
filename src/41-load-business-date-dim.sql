-- ----------------------------------------------------------------------------
-- MERGE INTO BUSINESS DATE DIMENSION TABLE.
-- EXEC business_date_load (10 seconds, creates 10.5k rows).
-- ----------------------------------------------------------------------------
CREATE PROCEDURE business_date_load
AS 
    WITH all_dates AS 
    (
        SELECT DISTINCT FORMAT(price_date, 'yyyyMMdd') AS price_date
        FROM prices_csv
    )
    MERGE INTO business_date AS tgt
        USING 
        (
            SELECT price_date FROM all_dates
        )
        AS src(price_date)
        ON tgt.date_yyyymmdd = src.price_date
    WHEN NOT MATCHED 
        THEN
            INSERT (date_yyyymmdd) 
            VALUES (price_date)
;