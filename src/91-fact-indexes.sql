CREATE INDEX price_date_ix ON property_price (price_date_id);

CREATE INDEX price_location_ix ON property_price (price_locataion_id);

CREATE INDEX price_address_ix ON property_price (property_address_id);

CREATE INDEX price_type_ix ON property_price (property_type_id);

CREATE INDEX price_ownership_ix ON property_price (land_ownership_id);

CREATE INDEX price_build_ix ON property_price (new_build_id);
