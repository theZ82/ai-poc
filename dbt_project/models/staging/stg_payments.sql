-- models/staging/stg_payments.sql
with source as (
    select * from {{ ref('olist_order_payments_dataset') }}
)
select
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value::numeric(12,2) as payment_value
from source
where order_id is not null
  and payment_value > 0
