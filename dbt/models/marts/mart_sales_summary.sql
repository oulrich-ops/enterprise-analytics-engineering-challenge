with fact as (
    select * from {{ ref('fct_order_items') }}
)

select
    order_purchase_date,
    date_trunc(order_purchase_date, week) as week_start,
    date_trunc(order_purchase_date, month) as month_start,
    date_trunc(order_purchase_date, quarter) as quarter_start,

    count(distinct order_id) as nb_orders,
    count(*) as nb_items,
    sum(item_total_value) as revenue,
    sum(price) as revenue_excl_freight,
    sum(freight_value) as freight_revenue,
    round(sum(item_total_value) / nullif(count(distinct order_id), 0), 2) as avg_order_value

from fact
group by order_purchase_date, week_start, month_start, quarter_start