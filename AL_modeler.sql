______________________________________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________

CREATE TABLE al_activity (
    activity_id          NUMBER NOT NULL,
    activity_period      NUMBER,
    passenger_count      NUMBER,
    operating_airline_id NUMBER,
    published_airline_id NUMBER,
    geo_region_id        NUMBER NOT NULL,
    geo_summary_id       NUMBER NOT NULL,
    activity_type__id    NUMBER NOT NULL,
    terminal_id          NUMBER NOT NULL,
    boarding_id          NUMBER NOT NULL,
    price_category_id    NUMBER NOT NULL
);

ALTER TABLE al_activity ADD CONSTRAINT al_activity_pk PRIMARY KEY ( activity_id );

CREATE TABLE al_activity_type (
    activity_type__id  NUMBER NOT NULL,
    activity_type_code VARCHAR2(40)
);

ALTER TABLE al_activity_type ADD CONSTRAINT al_activity_type_pk PRIMARY KEY ( activity_type__id );

CREATE TABLE al_airline (
    airline_id        NUMBER NOT NULL,
    airline           VARCHAR2(40),
    airline_iata_code CHAR(2)
);

ALTER TABLE al_airline ADD CONSTRAINT al_airline_pk PRIMARY KEY ( airline_id );

CREATE TABLE al_boarding (
    boarding_id   NUMBER NOT NULL,
    boarding_area CHAR(1)
);

ALTER TABLE al_boarding ADD CONSTRAINT al_boarding_pk PRIMARY KEY ( boarding_id );

CREATE TABLE al_geo_region (
    geo_region_id NUMBER NOT NULL,
    geo_region    VARCHAR2(40)
);

ALTER TABLE al_geo_region ADD CONSTRAINT al_geo_region_pk PRIMARY KEY ( geo_region_id );

CREATE TABLE al_geo_summary (
    geo_summary_id NUMBER NOT NULL,
    geo_summary    VARCHAR2(40)
);

ALTER TABLE al_geo_summary ADD CONSTRAINT al_geo_summary_pk PRIMARY KEY ( geo_summary_id );

CREATE TABLE al_price_category (
    price_category_id   NUMBER NOT NULL,
    price_category_code VARCHAR2(40)
);

ALTER TABLE al_price_category ADD CONSTRAINT al_price_category_pk PRIMARY KEY ( price_category_id );

CREATE TABLE al_terminal (
    terminal_id          NUMBER NOT NULL,
    terminal_description VARCHAR2(40)
);

ALTER TABLE al_terminal ADD CONSTRAINT al_terminal_pk PRIMARY KEY ( terminal_id );

ALTER TABLE al_activity
    ADD CONSTRAINT al_activity_acty_type_fk FOREIGN KEY ( activity_type__id )
        REFERENCES al_activity_type ( activity_type__id );

ALTER TABLE al_activity
    ADD CONSTRAINT al_activity_boarding_fk FOREIGN KEY ( boarding_id )
        REFERENCES al_boarding ( boarding_id );

ALTER TABLE al_activity
    ADD CONSTRAINT al_activity_geo_region_fk FOREIGN KEY ( geo_region_id )
        REFERENCES al_geo_region ( geo_region_id );

ALTER TABLE al_activity
    ADD CONSTRAINT al_activity_geo_summary_fk FOREIGN KEY ( geo_summary_id )
        REFERENCES al_geo_summary ( geo_summary_id );

ALTER TABLE al_activity
    ADD CONSTRAINT al_activity_oairline_fk FOREIGN KEY ( operating_airline_id )
        REFERENCES al_airline ( airline_id );

ALTER TABLE al_activity
    ADD CONSTRAINT al_activity_pairline_fk FOREIGN KEY ( published_airline_id )
        REFERENCES al_airline ( airline_id );

ALTER TABLE al_activity
    ADD CONSTRAINT al_activity_price_cat_fk FOREIGN KEY ( price_category_id )
        REFERENCES al_price_category ( price_category_id );

ALTER TABLE al_activity
    ADD CONSTRAINT al_activity_terminal_fk FOREIGN KEY ( terminal_id )
        REFERENCES al_terminal ( terminal_id );
