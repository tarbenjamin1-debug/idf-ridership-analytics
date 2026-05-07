with validation_location_labels as (

    select
        location_id,
        libelle_arret as fallback_location_name,
        row_number() over (
            partition by location_id
            order by validation_date desc, libelle_arret
        ) as rn
    from {{ ref('stg_transport_validations') }}
    where location_id is not null
      and libelle_arret is not null

)

select
    location_id,
    fallback_location_name
from validation_location_labels
where rn = 1