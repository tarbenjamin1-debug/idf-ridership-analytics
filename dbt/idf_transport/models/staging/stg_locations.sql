with raw_locations as (

    select *
    from {{ source('raw_transport', 'LOCATIONS') }}

)

select
    id_ref_zdc as location_id,
    NOM_ZDA as location_name,
    MODE_ as transport_mode,
    RES_COM as line_names,
    X as x_coordinate,
    Y as y_coordinate

from raw_locations

qualify row_number() over (
    partition by id_ref_zdc
    order by id_ref_zdc
) = 1