select distinct
    payment_type,
    {{ dbt_utils.generate_surrogate_key(['payment_type']) }} as payment_type_key
from {{ ref('stg_order_payments') }}