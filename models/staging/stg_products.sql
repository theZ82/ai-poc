-- models/staging/stg_products.sql
-- Joins PT category names to English translation
with products as (
    select * from {{ ref('olist_products_dataset') }}
),
translations as (
    select * from {{ ref('product_category_name_translation') }}
)
select
    p.product_id,
    coalesce(
        t.product_category_name_english,
        p.product_category_name,
        'uncategorized'
    )                                          as category_name,
    p.product_weight_g                         as weight_g,
    p.product_photos_qty                       as photos_qty,
    (
        p.product_length_cm *
        p.product_height_cm *
        p.product_width_cm
    )::numeric(12,2)                           as volume_cm3
from products p
left join translations t
    on p.product_category_name = t.product_category_name
where p.product_id is not null
