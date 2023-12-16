-- ----------------------------------------------------------------------------
-- New Build for SSAS model.
-- ----------------------------------------------------------------------------
CREATE VIEW NewBuild
AS
SELECT
    id AS ID,
    CASE new_build_flag
    WHEN 'Y' THEN 'Yes'
    WHEN 'N' THEN 'No'
    ELSE '' END AS IsNewBuild
FROM 
    new_build
;