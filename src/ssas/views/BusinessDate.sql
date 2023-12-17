-- ----------------------------------------------------------------------------
-- Business Dates for SSAS model.
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW BusinessDate
AS
SELECT
    id AS ID,
    date_display AS [Sale Date],
    CONCAT(date_yyyy, FORMAT(date_mm, 'd2')) AS [Date Sort],
    CASE date_mm
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    ELSE CAST(date_mm AS VARCHAR) END AS [Sale Month],
    date_yyyy AS [Sale Year]
FROM 
    business_date
;