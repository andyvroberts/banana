-- ----------------------------------------------------------------------------
-- Property Type for SSAS model.
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW PropertyType
AS
SELECT
    id AS ID,
    type_desc AS [Property Type]
FROM 
    property_type
;