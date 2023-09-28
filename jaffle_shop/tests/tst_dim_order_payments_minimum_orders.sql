-- For tests to pass, the query should return no records.
-- Test is to make sure there are no negative payments, but order 65 has a payment of 0. Left it in for now, but may need to modify test.
select 
    * 
from {{ ref('dim_order_payments') }}
where total_amount_paid < 0
limit 1