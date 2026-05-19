-- models/marts/dim_product.sql
select
    product_id,
    category_name,
    weight_g,
    volume_cm3,
    photos_qty
from {{ ref('stg_products') }}
