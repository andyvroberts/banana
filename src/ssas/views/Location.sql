-- ----------------------------------------------------------------------------
-- Location for SSAS model.
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW Location
AS
SELECT
    id AS ID,
    postcode AS [Postcode],
    LOWER(locality) AS [Locality]
FROM 
    property_location
;