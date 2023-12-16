ALTER TABLE property_price 
    DROP CONSTRAINT price_to_business_date_fk;

ALTER TABLE property_price 
    DROP CONSTRAINT price_to_property_location_fk;

ALTER TABLE property_price 
    DROP CONSTRAINT price_to_property_address_fk;

ALTER TABLE property_price 
    DROP CONSTRAINT price_to_property_type_fk;

ALTER TABLE property_price 
    DROP CONSTRAINT price_to_land_ownership_fk;

ALTER TABLE property_price 
    DROP CONSTRAINT price_to_new_build_fk;
