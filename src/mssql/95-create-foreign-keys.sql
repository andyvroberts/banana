ALTER TABLE property_price 
    ADD CONSTRAINT price_to_business_date_fk FOREIGN KEY (price_date_id)
    REFERENCES business_date (id);

ALTER TABLE property_price 
    ADD CONSTRAINT price_to_property_location_fk FOREIGN KEY (property_location_id)
    REFERENCES property_location (id);

ALTER TABLE property_price 
    ADD CONSTRAINT price_to_property_address_fk FOREIGN KEY (property_address_id)
    REFERENCES property_address (id);

ALTER TABLE property_price 
    ADD CONSTRAINT price_to_property_type_fk FOREIGN KEY (property_type_id)
    REFERENCES property_type (id);

ALTER TABLE property_price 
    ADD CONSTRAINT price_to_land_ownership_fk FOREIGN KEY (land_ownership_id)
    REFERENCES land_ownership (id);

ALTER TABLE property_price 
    ADD CONSTRAINT price_to_new_build_fk FOREIGN KEY (new_build_id)
    REFERENCES new_build (id);
