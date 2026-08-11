with fact as (
    select * from {{ ref('fct_order_items') }}
),

seller as (
    select * from {{ ref('dim_seller') }}
)

select
    date_trunc(f.order_purchase_date, month) as month_start,
    s.seller_id,
    s.seller_state,
    s.seller_city,

    count(distinct f.order_id) as nb_orders,
    count(*) as nb_items_sold,
    sum(f.item_total_value) as total_revenue,

    round(avg(f.delivery_days), 1) as avg_delivery_days,
    round(avg(f.delay_vs_estimate_days), 1) as avg_delay_vs_estimate,
    round(
        countif(f.delay_vs_estimate_days > 0) / nullif(count(*), 0) * 100,
        1
    ) as pct_late_deliveries,

    round(avg(f.review_score), 2) as avg_review_score

from fact f
inner join seller s on s.seller_key = f.seller_key
group by month_start, s.seller_id, s.seller_state, s.seller_city