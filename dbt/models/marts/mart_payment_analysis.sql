{{ config(materialized='table') }}

with fact as (
    select * from {{ ref('fct_order_items') }}
),

payment_type as (
    select * from {{ ref('dim_payment_type') }}
),

orders_payment as (
    select distinct
        order_id,
        payment_type_key,
        order_total_payment_value,
        order_max_installments,
        date_trunc(order_purchase_date, month) as month_start
    from fact
)

select
    month_start,
    coalesce(pt.payment_type, 'unknown') as payment_type,
    count(*) as nb_orders,
    sum(op.order_total_payment_value) as total_revenue,
    round(avg(op.order_total_payment_value), 2) as avg_order_value,
    round(avg(op.order_max_installments), 1) as avg_installments

from orders_payment op
left join payment_type pt on pt.payment_type_key = op.payment_type_key
group by month_start, payment_type
order by month_start, total_revenue desc