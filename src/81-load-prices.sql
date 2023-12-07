-- ----------------------------------------------------------------------------
-- LOAD the Price FACTS.
-- 
-- 
-- ----------------------------------------------------------------------------
WITH 
    price_date AS
    (
        SELECT id, date_yyyymmdd FROM business_date
    ),
    property_location AS
    (
        SELECT id, paon, saon, street, postcode, town, district, county
            FROM property_location
    )
INSERT INTO property_price
    (price_date_id, property_location_id, price)
SELECT
    pd.id, pl.id, pp.price 
FROM 
    prices_csv pp 
INNER JOIN
    price_date pd ON pd.date_yyyymmdd = COALESCE(FORMAT(pp.price_date, 'yyyyMMdd'), NULL)
INNER JOIN 
    property_location pl ON pl.paon = COALESCE(pp.paon, NULL) AND
                            pl.saon = COALESCE(pp.saon, NULL) AND
                            pl.street = COALESCE(pp.street, NULL) AND 
                            pl.postcode = COALESCE(pp.postcode, NULL) AND 
                            pl.town = COALESCE(pp.town, NULL) AND 
                            pl.district = COALESCE(pp.district, NULL) AND
                            pl.county = COALESCE(pp.county, NULL)
;