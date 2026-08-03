-- test ci workflow actionner (slim ci test 2026-08-03)
select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
from {{ source('raw', 'customers') }}