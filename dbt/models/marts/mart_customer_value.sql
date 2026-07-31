{{ config(materialized='table') }}

with fact as (
    select * from {{ ref('fct_order_items') }}
),

customer as (
    select * from {{ ref('dim_customer') }}
)

select
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,

    date_trunc(min(f.order_purchase_date), month) as acquisition_month,

    count(distinct f.order_id) as nb_orders,
    count(*) as nb_items_purchased,

    sum(f.item_total_value) as lifetime_value,
    round(avg(f.item_total_value), 2) as avg_item_value,
    round(sum(f.item_total_value) / nullif(count(distinct f.order_id), 0), 2) as avg_order_value,

    min(f.order_purchase_date) as first_purchase_date,
    max(f.order_purchase_date) as last_purchase_date,

    round(avg(f.review_score), 2) as avg_review_score_given,

    case when count(distinct f.order_id) > 1 then true else false end as is_repeat_customer

from fact f
inner join customer c on c.customer_key = f.customer_key
group by c.customer_unique_id, c.customer_state, c.customer_city