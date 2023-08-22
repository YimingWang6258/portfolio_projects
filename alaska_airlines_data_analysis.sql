______________________________________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________

--1.Best season/month for Alaska airlines?
create view season_view
as
    select month, flight_number,
    case when 2 < month and month < 6 then 'spring'
    when 5 < month and month < 9 then 'summer'
    when 8 < month and month < 12 then 'fall'
    else 'winter'
    end season
    from 
    (select month, count(*) flight_number
    from 
        (
        --select substr(to_char(activity_period),-2) as month
        select to_char(to_date(activity_period, 'YYYY/MM'), 'MM' ) as month
        from al_activity
        )
    group by month
    order by month)

create materialized view best_season_MV
as
select season, sum(flight_number) sum_flight_number,
rank() over(order by sum(flight_number) desc) rank
from season_view
group by season

select * from best_season_MV
where rank = 1

create index indx_best_season_MV_id on best_season_MV(rank)
--drop index indx_best_season_MV_id
-------------------------------------------
--1.Best season/month for Alaska airlines?
create materialized view pivot_month_MV
as
select *
from 
    (
    select airline, trim(to_char(to_date(activity_period, 'YYYY/MM'), 'Month')) month
    from al_activity
    join al_airline
    on operating_airline_id = airline_id
    )
pivot 
    (
    count(*)
    for month in ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')
    )

select * from pivot_month_MV
where airline = 'Alaska Airlines'

create index indx_pivot_month_MV_id on pivot_month_MV(airline)
-------------------------------------------
--2.which destination region is the most popular?
create materialized view popular_destination_MV
as
select geo_region,total_flight, region_flight, region_flight/total_flight pct,  
rank () over(order by region_flight desc) popular_rank
from (
    with popular_destination as
        (select geo_region, count(*) flight_number
        from al_activity
        join al_geo_region
        using (geo_region_id)
        group by geo_region)
    select sum(flight_number) over() total_flight, 
    sum(flight_number) over(partition by geo_region) region_flight, 
    geo_region from popular_destination
    )

select * from popular_destination_MV
where popular_rank = 1

create index indx_popular_destination_MV_id on popular_destination_MV(popular_rank)
-------------------------------------------
--3.If Alaska Airlines increases flights, domestic or international? Which one is more profitable?
create materialized view profitability_MV
as
select geo_summary, count(*) flight_nmbr, price_category_code, 
sum (passenger_count) sum_passenger, 
rank() over(order by sum (passenger_count)desc) profitability_rank
from (
        select * from al_geo_summary
        join al_activity using (geo_summary_id)
        join al_price_category using (price_category_id)
      )
group by geo_summary, price_category_code

create index indx_profitability_MV_id on profitability_MV(profitability_rank)

select * from profitability_MV
where profitability_rank = 1
