{{
  config(
    materialized='incremental',
    unique_key=['order_id', 'order_item_id'],
    partition_by={
      "field": "order_purchase_date",
      "data_type": "date",
      "granularity": "month"
    },
    cluster_by=["seller_key"],
    incremental_strategy='merge'
  )
}}

with order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
    {% if is_incremental() %}
    where order_purchase_at > (select max(order_purchase_at) from {{ this }})
    {% endif %}
),

customers as (
    select customer_id, customer_unique_id from {{ ref('stg_customers') }}
),

dim_customer as (
    select * from {{ ref('dim_customer') }}
),

dim_seller as (
    select * from {{ ref('dim_seller') }}
),

dim_product as (
    select * from {{ ref('dim_product') }}
),

-- Le paiement est porté au niveau de la commande, pas de l'article.
-- On agrège pour éviter un fan-out lors de la jointure vers order_items.
payments_agg as (
    select
        order_id,
        sum(payment_value) as order_total_payment_value,
        max(payment_installments) as order_max_installments,
        min(case when payment_sequential = 1 then payment_type end) as primary_payment_type
    from {{ ref('stg_order_payments') }}
    group by order_id
),

dim_payment_type as (
    select * from {{ ref('dim_payment_type') }}
),

-- Un même order_id peut porter plusieurs avis dans les données brutes.
-- On garde le plus récent.
reviews_agg as (
    select
        order_id,
        review_score,
        row_number() over (
            partition by order_id
            order by review_created_at desc
        ) as rn
    from {{ ref('stg_order_reviews') }}
    qualify rn = 1
),

final as (
    select
        oi.order_id,
        oi.order_item_id,

        dc.customer_key,
        ds.seller_key,
        dp.product_key,
        dpt.payment_type_key,

        cast(o.order_purchase_at as date) as order_purchase_date,
        o.order_purchase_at,
        o.order_delivered_customer_at,
        o.order_estimated_delivery_at,

        date_diff(
            cast(o.order_delivered_customer_at as date),
            cast(o.order_purchase_at as date),
            day
        ) as delivery_days,

        date_diff(
            cast(o.order_delivered_customer_at as date),
            cast(o.order_estimated_delivery_at as date),
            day
        ) as delay_vs_estimate_days,

        oi.price,
        oi.freight_value,
        oi.price + oi.freight_value as item_total_value,

        pa.order_total_payment_value,
        pa.order_max_installments,

        ra.review_score

    from order_items oi
    inner join orders o on o.order_id = oi.order_id
    left join customers c on c.customer_id = o.customer_id
    left join dim_customer dc on dc.customer_unique_id = c.customer_unique_id
    left join dim_seller ds on ds.seller_id = oi.seller_id
    left join dim_product dp on dp.product_id = oi.product_id
    left join payments_agg pa on pa.order_id = oi.order_id
    left join dim_payment_type dpt on dpt.payment_type = pa.primary_payment_type
    left join reviews_agg ra on ra.order_id = oi.order_id
)

select * from final