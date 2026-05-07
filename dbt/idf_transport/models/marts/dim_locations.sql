with fact_location_ids as (

    select distinct
        location_id
    from {{ ref('stg_transport_validations') }}
    where location_id is not null

),

current_locations as (

    select
        location_id,
        location_name,
        transport_mode,
        line_names,
        x_coordinate,
        y_coordinate
    from {{ ref('stg_locations') }}

),

fallback_location_names as (

    select
        location_id,
        fallback_location_name
    from {{ ref('stg_location_name_from_validations') }}

)

select
    f.location_id,
    coalesce(c.location_name, fl.fallback_location_name) as location_name,
    c.transport_mode,
    c.line_names,
    c.x_coordinate,
    c.y_coordinate,
    case
        when c.location_id is not null then true
        else false
    end as is_in_current_reference,
    case
        when c.location_name is null
         and fl.fallback_location_name is not null then true
        else false
    end as is_name_from_validation_fallback,
    case
        when c.x_coordinate is not null
         and c.y_coordinate is not null then true
        else false
    end as has_coordinates

from fact_location_ids f
left join current_locations c
    on f.location_id = c.location_id
left join fallback_location_names fl
    on f.location_id = fl.location_id