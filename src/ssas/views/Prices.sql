-- ----------------------------------------------------------------------------
-- Prices for SSAS model.
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW Prices
AS
SELECT
    price_date_id AS [Business Date ID],
    property_location_id AS [Location ID],
    property_address_id AS [Address ID],
    property_type_id AS [Property Type ID],
    land_ownership_id AS [Land Ownership ID],
    new_build_id AS [New Build ID],
    CAST(price AS MONEY) AS [Price]
FROM 
    property_price
;