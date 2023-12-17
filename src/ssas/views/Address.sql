-- ----------------------------------------------------------------------------
-- Address for SSAS model.
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW PropertyAddress
AS
SELECT
    id AS ID,
    LOWER(CONCAT_WS(' ', saon, paon, street)) AS [Address],
    postcode AS [Postcode],
    LOWER(town) AS [Town],
    LOWER(district) AS [District],
    LOWER(county) AS [County]
FROM 
    property_address
;