select
    product_id,
    product_category_name,
    cast(product_weight_g as numeric) as product_weight_g,
    cast(product_length_cm as numeric) as product_length_cm,
    cast(product_height_cm as numeric) as product_height_cm,
    cast(product_width_cm as numeric) as product_width_cm
from {{ source('raw', 'products') }}