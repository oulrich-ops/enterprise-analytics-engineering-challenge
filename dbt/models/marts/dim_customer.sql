with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select customer_id, order_purchase_at
    from {{ ref('stg_orders') }}
),

customer_orders as (
    select
        c.*,
        o.order_purchase_at,
        row_number() over (
            partition by c.customer_unique_id
            order by o.order_purchase_at desc
        ) as rn
    from customers c
    left join orders o on o.customer_id = c.customer_id
)

select
    {{ dbt_utils.generate_surrogate_key(['customer_unique_id']) }} as customer_key,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
from customer_orders
where rn = 1