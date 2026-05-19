-- models/marts/dim_seller.sql
select
    seller_id,
    city,
    state,
    region,
    zip_code
from {{ ref('stg_sellers') }}
