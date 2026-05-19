-- models/marts/fact_order_items.sql
-- Grain: one row per order line item
-- Central fact table — all analysis starts here

with order_items as (select * from {{ ref('stg_order_items') }}),
     orders      as (select * from {{ ref('stg_orders') }}),

payments as (
    -- One dominant payment per order (highest value wins)
    select distinct on (order_id)
        order_id,
        payment_type,
        payment_installments,
        payment_value
    from {{ ref('stg_payments') }}
    order by order_id, payment_value desc
),

reviews as (
    -- One review per order (most recent)
    select distinct on (order_id)
        order_id,
        review_score
    from {{ ref('stg_reviews') }}
    order by order_id, reviewed_at desc
)

select
    -- Surrogate PK
    md5(oi.order_id || '-' || oi.order_item_id::text)
        as order_item_sk,

    -- Foreign keys
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    o.customer_id,
    to_char(o.ordered_at::date, 'YYYYMMDD')::int as date_id,

    -- Order attributes
    o.order_status,
    o.ordered_at,
    o.delivered_at,
    o.estimated_delivery_at,

    -- Delivery performance: negative = early, positive = late, null = not delivered
    case
        when o.delivered_at is not null and o.estimated_delivery_at is not null
        then extract(day from o.delivered_at - o.estimated_delivery_at)::int
    end as delivery_delta_days,

    -- Payment
    p.payment_type,
    p.payment_installments,
    p.payment_value,

    -- Measures
    oi.price,
    oi.freight_value,
    oi.revenue,        -- = price + freight_value (CANONICAL REVENUE METRIC)

    -- Review
    r.review_score

from order_items oi
inner join orders   o  on oi.order_id = o.order_id
left  join payments p  on oi.order_id = p.order_id
left  join reviews  r  on oi.order_id = r.order_id
