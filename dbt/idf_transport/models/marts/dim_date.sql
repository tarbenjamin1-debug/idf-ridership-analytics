{{ config(materialized='table') }}

{% set start_date = var('dim_date_start', '2019-01-01') %}
{% set end_date = var('dim_date_end', '2099-12-31') %}

with bounds as (

    select
        to_date('{{ start_date }}') as start_date,
        to_date('{{ end_date }}') as end_date

),

date_spine as (

    select
        dateadd(
            day,
            seq4(),
            b.start_date
        ) as full_date
    from bounds b,
         table(generator(rowcount => 36525))

),

final as (

    select
        to_number(to_char(full_date, 'YYYYMMDD')) as date_key,
        full_date,

        extract(year from full_date) as year_number,
        extract(quarter from full_date) as quarter_number,
        extract(month from full_date) as month_number,
        extract(day from full_date) as day_number,

        to_char(full_date, 'YYYY-MM') as year_month,
        to_char(full_date, 'MON') as month_short_name,
        to_char(full_date, 'MMMM') as month_name,

        extract(dayofweekiso from full_date) as day_of_week_iso,
        to_char(full_date, 'DY') as day_short_name,
        trim(to_char(full_date, 'DAY')) as day_name,

        extract(dayofyear from full_date) as day_of_year,
        extract(weekiso from full_date) as iso_week_number,
        extract(yearofweekiso from full_date) as iso_week_year,

        date_trunc('week', full_date) as week_start_date,
        date_trunc('month', full_date) as month_start_date,
        last_day(full_date, 'month') as month_end_date,

        date_trunc('quarter', full_date) as quarter_start_date,
        last_day(dateadd(month, 2, date_trunc('quarter', full_date)), 'month') as quarter_end_date,

        date_trunc('year', full_date) as year_start_date,
        last_day(full_date, 'year') as year_end_date,

        case when extract(dayofweekiso from full_date) in (6, 7) then true else false end as is_weekend,
        case when extract(dayofweekiso from full_date) between 1 and 5 then true else false end as is_weekday

    from date_spine
    cross join bounds
    where full_date <= bounds.end_date

)

select *
from final
order by full_date