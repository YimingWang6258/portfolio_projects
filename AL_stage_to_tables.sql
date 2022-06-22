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
--1.Best season/month for Alaska airlines?
create materialized view best_month_MV
--drop materialized view best_month_MV
as
select month, count(*) flight_number, 
rank() over(order by count(*) desc) flight_nmbr_rank
from 
    (
    --select substr(to_char(activity_period),-2) as month
    select trim(to_char(to_date(activity_period, 'YYYY/MM'), 'Month' )) as month
    from al_activity
    )
group by month
order by flight_number desc

create index indx_best_month_MV_id on best_month_MV(flight_nmbr_rank)

select * from best_month_MV
where flight_nmbr_rank = 1