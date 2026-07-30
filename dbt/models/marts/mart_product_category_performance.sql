{{ config(materialized='table') }}

with fact as (
    select * from {{ ref('fct_order_items') }}
),

product as (
    select * from {{ ref('dim_product') }}
)

select
    date_trunc(f.order_purchase_date, month) as month_start,
    coalesce(p.product_category_name_english, 'unknown') as product_category,
    count(distinct f.order_id) as nb_orders,
    count(*) as nb_items_sold,
    sum(f.item_total_value) as revenue,
    round(avg(f.price), 2) as avg_item_price,
    round(avg(f.review_score), 2) as avg_review_score

from fact f
left join product p on p.product_key = f.product_key
group by month_start, product_category
order by month_start, revenue desc