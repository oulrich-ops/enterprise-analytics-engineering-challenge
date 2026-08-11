select
    {{ dbt_utils.generate_surrogate_key(['s.seller_id']) }} as seller_key,
    s.seller_id,
    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state,
    bs.state_name as seller_state_name

from {{ ref('stg_sellers') }} s
left join {{ ref('br_states') }} bs on bs.state_code = s.seller_state