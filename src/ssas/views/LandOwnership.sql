-- ----------------------------------------------------------------------------
-- Land Ownership for SSAS model.
-- ----------------------------------------------------------------------------
CREATE VIEW LandOwnership
AS
SELECT
    id AS ID,
    ownership_desc AS LandUseType
FROM 
    land_ownership
;