{{
    config(
        materialized = 'incremental',
        unique_key = ['validation_date', 'reseau_id', 'stop_id','location_id', 'transporter_id', 'subscription_type'],
        on_schema_change = 'fail'
    )
}}

with validations as (

    select
        validation_date,
        to_number(to_char(validation_date, 'YYYYMMDD')) as date_key,
        location_id,
        reseau_id,
        stop_id,
        transporter_id,
        subscription_type,
        number_validations
    from {{ ref('stg_transport_validations') }}

    {% if is_incremental() %}
        where validation_date > (
            select coalesce(max(validation_date), '1900-01-01')
            from {{ this }}
        )
    {% endif %}

)

select
    {{ dbt_utils.generate_surrogate_key([
        'validation_date',
        'reseau_id',
        'stop_id',
        'location_id',
        'transporter_id',
        'subscription_type'
    ]) }} as validation_id,
    date_key,
    validation_date,
    location_id,
    reseau_id,
    stop_id,
    transporter_id,
    subscription_type,
    number_validations
from validations