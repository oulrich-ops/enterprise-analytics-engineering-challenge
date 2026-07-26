select
    geolocation_zip_code_prefix,
    cast(geolocation_lat as numeric) as geolocation_lat,
    cast(geolocation_lng as numeric) as geolocation_lng,
    geolocation_city,
    geolocation_state
from {{ source('raw', 'geolocation') }}