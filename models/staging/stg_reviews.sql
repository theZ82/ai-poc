-- models/staging/stg_reviews.sql
with source as (
    select * from {{ ref('olist_order_reviews_dataset') }}
)
select
    review_id,
    order_id,
    review_score::int                  as review_score,
    review_creation_date::timestamp    as reviewed_at,
    review_answer_timestamp::timestamp as answered_at
from source
where order_id is not null
  and review_score between 1 and 5
