DROP INDEX IF EXISTS property_location_ix ON property_location;

DROP INDEX IF EXISTS property_address_ix ON property_address;

DROP INDEX IF EXISTS property_type_ix ON property_type;

DROP INDEX IF EXISTS land_ownership_ix ON land_ownership;

DROP INDEX IF EXISTS new_buid_ix ON new_build;

DROP INDEX IF EXISTS business_date_ix ON business_date



CREATE INDEX property_location_ix ON property_location (postcode, locality);

CREATE INDEX property_address_ix ON property_address 
    (
        paon, saon, street, postcode, town, district, county
    );

CREATE UNIQUE INDEX property_type_ix ON property_type (type_flag);

CREATE UNIQUE INDEX land_ownership_ix ON land_ownership (ownership_type);

CREATE UNIQUE INDEX new_buid_ix ON new_build (new_build_flag);

CREATE UNIQUE INDEX business_date_ix ON business_date (date_yyyymmdd);
