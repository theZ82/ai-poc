-- models/marts/dim_customer.sql
select
    customer_id,
    customer_unique_id,
    city,
    state,
    region,
    zip_code
from {{ ref('stg_customers') }}
