SET DEFINE OFF
CREATE TABLE YW_AL_STAGE ( Activity_Period NUMBER(38),
Operating_Airline VARCHAR2(128),
Operating_Airline_IATA_Code VARCHAR2(26),
Published_Airline VARCHAR2(128),
Published_Airline_IATA_Code VARCHAR2(128),
GEO_Summary VARCHAR2(128),
GEO_Region VARCHAR2(128),
Activity_Type_Code VARCHAR2(128),
Price_Category_Code VARCHAR2(128),
Terminal_Description VARCHAR2(128),
Boarding_Area VARCHAR2(128),
Passenger_Count NUMBER(38));

/* .ctl .sh and .bat files are found in /Users/wangyiming/Desktop/Database Design and Management/Alaska Airlines/Alaska Airlines stage. */

select * from yw_al_stage
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

______________________________________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________
create sequence seq_al_activity_type

select activity_type_id, activity_type_code
from al_activity_type

insert into al_activity_type (activity_type_id, activity_type_code)
select seq_al_activity_type.nextval, activity_type_code
from ((
       select distinct activity_type_code
       from yw_al_stage
       where activity_type_code is not null)
       minus
       select activity_type_code
       from al_activity_type)

select * from al_activity_type
-------------------------------------------
create sequence seq_al_price_category

select price_category_id, price_category_code from al_price_category

insert into al_price_category (price_category_id, price_category_code)
select seq_al_price_category.nextval, price_category_code
from ((
      select distinct price_category_code
      from yw_al_stage
      where price_category_code is not null)
      minus
      select price_category_code 
      from al_price_category)
 
select * from al_price_category
-------------------------------------------
create sequence seq_al_terminal

select terminal_id, terminal_description from al_terminal

insert into al_terminal (terminal_id, terminal_description)
select seq_al_terminal.nextval, terminal_description
from ((
      select distinct terminal_description
      from yw_al_stage
      where terminal_description is not null)
      minus
      select terminal_description 
      from al_terminal)

select * from al_terminal
-------------------------------------------
create sequence seq_al_geo_region

select geo_region_id, geo_region from al_geo_region

insert into al_geo_region (geo_region_id, geo_region)
select seq_al_geo_region.nextval, geo_region
from ((
      select distinct geo_region
      from yw_al_stage
      where geo_region is not null)
      minus 
      select geo_region 
      from al_geo_region)
      
select * from al_geo_region
-------------------------------------------
create sequence seq_al_boarding

select boarding_id, boarding_area from al_boarding

insert into al_boarding (boarding_id, boarding_area)

select seq_al_boarding.nextval, boarding_area
from ((
      select distinct boarding_area
      from yw_al_stage
      where boarding_area is not null)
      minus
      select boarding_area 
      from al_boarding)
      
select * from al_boarding
-------------------------------------------
create sequence seq_al_geo_summary

select geo_summary_id, geo_summary from al_geo_summary

insert into al_geo_summary (geo_summary_id, geo_summary)
select seq_al_geo_summary.nextval, geo_summary
from ((
      select distinct geo_summary
      from yw_al_stage
      where geo_summary is not null)
      minus
      select geo_summary 
      from al_geo_summary)
      
select * from al_geo_summary
-------------------------------------------
create sequence seq_al_airline

select airline_id, airline, airline_iata_code from al_airline

insert into al_airline (airline_id, airline, airline_iata_code)
select seq_al_airline.nextval,
       operating_airline, 
       operating_airline_iata_code
from ((
      select distinct operating_airline, 
       operating_airline_iata_code
      from yw_al_stage
      where operating_airline is not null)
      minus
      select airline, airline_iata_code 
      from al_airline)
      
select * from al_airline
-------------------------------------------
--one way (not recommended)
create sequence seq_al_activity

insert into al_activity (activity_id, activity_period, passenger_count, operating_airline_id, published_airline_id, 
                         geo_region_id, geo_summary_id, activity_type_id, terminal_id, boarding_id, price_category_id)
select seq_al_activity.nextval, 
       activity_period, 
       passenger_count,
       (select airline_id from al_airline where airline = i_operating_airline),--operating_airline
       (select airline_id from al_airline where airline = i_published_airline), --published_airline
       (select geo_region_id from al_geo_region where geo_region = i_geo_region), --geo_region_id, --geo_region
       (select geo_summary_id from al_geo_summary where geo_summary = i_geo_summary), --geo_summary
       (select activity_type_id from al_activity_type where activity_type_code = i_activity_type_code), --activity_type_id, --activity_type_code
       (select terminal_id from al_terminal where terminal_description = i_terminal_description), --need to look up terminal description
       (select boarding_id from al_boarding where boarding_area = i_boarding_area),  --need to look up boarding_area
       (select price_category_id from al_price_category where price_category_code = i_price_category_code)-- price_category_id --need to look up price_category_code
from ((
       select distinct activity_period, 
       passenger_count,
       operating_airline i_operating_airline, 
       published_airline i_published_airline, 
       geo_region i_geo_region, 
       geo_summary i_geo_summary, 
       activity_type_code i_activity_type_code, 
       terminal_description i_terminal_description, 
       boarding_area i_boarding_area, 
       price_category_code i_price_category_code
       from yw_al_stage
       where activity_period is not null)
       minus
      (select to_number(activity_period), 
       passenger_count, 
       al_airline.airline operating_airline, 
       al_airline.airline published_airline,
       geo_region, 
       geo_summary, 
       activity_type_code, 
       terminal_description, 
       boarding_area, 
       price_category_code
      from al_activity
      left join al_airline on al_activity.operating_airline_id = al_airline.airline_id
      left join al_airline on al_activity.published_airline_id = al_airline.airline_id
      left join al_geo_region using (geo_region_id)
      left join al_geo_summary using (geo_summary_id)
      left join al_activity_type using (activity_type_id)
      left join al_terminal using (terminal_id)
      left join al_boarding using (boarding_id)
      left join al_price_category using (price_category_id)
      ))

-------------------------------------------
--another way
create sequence seq_al_activity

insert into al_activity (activity_id, activity_period, passenger_count, operating_airline_id, published_airline_id, 
                         geo_region_id, geo_summary_id, activity_type_id, terminal_id, boarding_id, price_category_id)
select seq_al_activity.nextval, 
       activity_period, 
       passenger_count,
       operating_airline_id,
       published_airline_id,
       geo_region_id,
       geo_summary_id,
       activity_type_id,
       terminal_id,
       boarding_id,
       price_category_id
from(    
       (select distinct activity_period, 
       passenger_count,
       al_airline.airline_id as operating_airline_id,
       al_airline.airline_id as published_airline_id,
       geo_region_id,
       geo_summary_id,
       activity_type_id,
       terminal_id,
       boarding_id,
       price_category_id
       from yw_al_stage
       
       left join al_airline on (yw_al_stage.operating_airline = al_airline.airline)
       left join al_airline on (yw_al_stage.published_airline = al_airline.airline)
       left join al_geo_region using (geo_region)
       left join al_geo_summary using (geo_summary)
       left join al_activity_type using (activity_type_code)
       left join al_terminal using (terminal_description)
       left join al_boarding using (boarding_area)
       left join al_price_category using (price_category_code)
       where activity_period is not null
       )
      
       minus
       
       select activity_period, 
       passenger_count, 
       operating_airline_id, 
       published_airline_id,
       geo_region_id, 
       geo_summary_id, 
       activity_type_id, 
       terminal_id, 
       boarding_id, 
       price_category_id
       from al_activity
    )       

-------------------------------------------

select count(*) from al_activity

alter table al_activity
add activity_period_temp number

update al_activity
set activity_period_temp = to_number(activity_period)

update al_activity
set activity_period = null

alter table al_activity
modify activity_period number

update al_activity
set activity_period = activity_period_temp

alter table al_activity
drop column activity_period_temp

-------------------------------------------
--queries
select passenger_count, count(*) from al_activity
group by passenger_count
having count(*)>1

delete from al_activity
where rowid not in (
select min(rowid) from al_activity
group by passenger_count
--having count(*) > 1)

select * from al_activity

select count(*) from yw_al_stage
where activity_period is not null

select count(*) from al_activity

select count(distinct activity_id) from al_activity
