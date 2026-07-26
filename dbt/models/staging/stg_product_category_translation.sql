select
    product_category_name,
    product_category_name_english
from {{ ref('product_category_name_translation') }}