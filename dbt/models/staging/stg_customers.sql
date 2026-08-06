-- intentionally broken to test Slack CI failure notification
select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    this_column_does_not_exist
from {{ source('raw', 'customers') }}