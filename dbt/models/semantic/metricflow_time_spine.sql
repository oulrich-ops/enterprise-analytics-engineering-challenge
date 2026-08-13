{{
    config(
        materialized = 'table',
    )
}}

with spine as (
    {{
        dbt.date_spine(
            'day',
            "cast('2016-01-01' as date)",
            "cast(dateadd(day, 1, current_date) as date)"
        )
    }}
)

select cast(date_day as date) as date_day
from spine
