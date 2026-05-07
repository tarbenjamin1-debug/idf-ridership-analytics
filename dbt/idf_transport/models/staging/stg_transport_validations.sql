with raw_validations as (

    select *
    from {{ source('raw_transport', 'RAW_VALIDATION') }}

)

select
    cast(JOUR as date) as validation_date,
    ID_ZDC as location_id,
    LIBELLE_ARRET as libelle_arret,
    CODE_STIF_RES as reseau_id,
    CODE_STIF_ARRET as stop_id,
    CODE_STIF_TRNS as transporter_id,
    CATEGORIE_TITRE as subscription_type,
    NB_VALD as number_validations
from raw_validations
where ID_ZDC is not null

