-- ----------------------------------------------------------------------------
-- LOAD the Price FACTS.
-- 
-- 
-- ----------------------------------------------------------------------------
INSERT INTO property_price 
    (
        price_date_id, 
        property_location_id, 
        property_address_id, 
        property_type_id, 
        land_ownership_id,
        new_build_id,
        price
    )
SELECT
    ad.id, al.id, aa.id, at.id, ao.id, ab.id, pp.price 
FROM 
    prices_csv pp 
LEFT OUTER JOIN
    (
        SELECT id, date_yyyymmdd FROM business_date
    ) 
    AS ad ON ISNULL(ad.date_yyyymmdd, 1) = ISNULL(FORMAT(pp.price_date, 'yyyyMMdd'), 1)
LEFT OUTER JOIN 
    (
        SELECT id, postcode, locality FROM property_location
    )
    AS al ON ISNULL(al.postcode, 1) = ISNULL(pp.postcode, 1) AND 
             ISNULL(al.locality, 1) = ISNULL(pp.locality, 1)
LEFT OUTER JOIN 
    (
        SELECT id, paon, saon, street, postcode, town, district, county
        FROM property_address
    )
    AS aa ON ISNULL(aa.paon, 1) = ISNULL(pp.paon, 1) AND
             ISNULL(aa.saon, 1) = ISNULL(pp.saon, 1) AND
             ISNULL(aa.street, 1) = ISNULL(pp.street, 1) AND 
             ISNULL(aa.postcode, 1) = ISNULL(pp.postcode, 1) AND 
             ISNULL(aa.town, 1) = ISNULL(pp.town, 1) AND 
             ISNULL(aa.district, 1) = ISNULL(pp.district, 1) AND 
             ISNULL(aa.county, 1) = ISNULL(pp.county, 1)
LEFT OUTER JOIN 
    (
        SELECT id, type_flag FROM property_type
    )
    AS at ON ISNULL(at.type_flag, 1) = ISNULL(pp.property_type, 1)
LEFT OUTER JOIN 
    (
        SELECT id, ownership_type FROM land_ownership
    )
    AS ao ON ISNULL(ao.ownership_type, 1) = ISNULL(pp.land_ownership, 1)
LEFT OUTER JOIN 
    (
        SELECT id, new_build_flag FROM new_build
    )
    ab ON ISNULL(ab.new_build_flag, 1) = ISNULL(pp.new_build, 1)
;
