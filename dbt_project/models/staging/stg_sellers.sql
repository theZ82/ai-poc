-- models/staging/stg_sellers.sql
with source as (
    select * from {{ ref('olist_sellers_dataset') }}
)
select
    seller_id,
    seller_zip_code_prefix as zip_code,
    seller_city            as city,
    seller_state           as state,
    case seller_state
        when 'SP' then 'Southeast' when 'RJ' then 'Southeast'
        when 'MG' then 'Southeast' when 'ES' then 'Southeast'
        when 'RS' then 'South'     when 'PR' then 'South'
        when 'SC' then 'South'
        when 'BA' then 'Northeast' when 'PE' then 'Northeast'
        when 'CE' then 'Northeast' when 'MA' then 'Northeast'
        else 'Other'
    end as region
from source
where seller_id is not null
