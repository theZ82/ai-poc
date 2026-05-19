-- models/marts/dim_date.sql
-- Date spine covering full Olist range 2016-2019
with spine as (
    select generate_series(
        '2016-01-01'::date,
        '2019-12-31'::date,
        '1 day'::interval
    )::date as date_day
)
select
    to_char(date_day, 'YYYYMMDD')::int  as date_id,
    date_day,
    extract(year    from date_day)::int as year,
    extract(quarter from date_day)::int as quarter,
    extract(month   from date_day)::int as month,
    trim(to_char(date_day, 'Month'))    as month_name,
    extract(week    from date_day)::int as week,
    extract(dow     from date_day)::int as day_of_week,
    trim(to_char(date_day, 'Day'))      as day_name,
    extract(dow from date_day) in (0,6) as is_weekend,
    to_char(date_day, 'YYYY-"Q"Q')      as year_quarter,
    to_char(date_day, 'YYYY-MM')        as year_month
from spine
