-- ----------------------------------------------------------------------------
-- Address for SSAS model.
-- ----------------------------------------------------------------------------
CREATE VIEW PropertyAddress
AS
SELECT
    id AS ID,
    LOWER(CONCAT_WS(' ', saon, paon, street)) AS Address,
    potcode AS Postcode,
    LOWER(town) AS Town,
    LOWER(district) AS District,
    LOWER(county) AS County
FROM 
    property_address
;