{{ config(materialized='table') }}

select
    date(usage_start_time) as usage_date,
    date_trunc(date(usage_start_time), month) as usage_month,
    service_name,
    sum(cost) as total_cost,
    currency

from {{ ref('stg_gcp_billing') }}
group by usage_date, usage_month, service_name, currency
order by usage_date desc