-- ----------------------------------------------------------------------------
-- Land Ownership for SSAS model.
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW LandOwnership
AS
SELECT
    id AS ID,
    ownership_desc AS [Land Use Type]
FROM 
    land_ownership
;