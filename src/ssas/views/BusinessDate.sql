-- ----------------------------------------------------------------------------
-- Business Dates for SSAS model.
-- ----------------------------------------------------------------------------
CREATE VIEW BusinessDate
AS
SELECT
    id AS ID,
    display_date AS SaleDate,
    CASE date_mm
        WHEN 1 THEN 'Jan'
        WHEN 2 THEN 'Feb'
        WHEN 3 THEN 'Mar'
        WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'Jun'
        WHEN 7 THEN 'Jul'
        WHEN 8 THEN 'Aug'
        WHEN 9 THEN 'Sep'
        WHEN 10 THEN 'Oct'
        WHEN 11 THEN 'Nov'
        WHEN 12 THEN 'Dec'
    ELSE CAST(date_mm AS VARCHAR) END AS SaleMonth,
    date_yyyy AS SaleYear
FROM 
    business_date
;