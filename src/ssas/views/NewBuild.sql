-- ----------------------------------------------------------------------------
-- New Build for SSAS model.
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW NewBuild
AS
SELECT
    id AS ID,
    CASE new_build_flag
    WHEN 'Y' THEN 'Yes'
    WHEN 'N' THEN 'No'
    ELSE '' END AS [Is New Build]
FROM 
    new_build
;