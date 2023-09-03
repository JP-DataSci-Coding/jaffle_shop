-- First CTE
with paid_orders as (
select 
    Orders.order_id,
    Orders.customer_id,
    Orders.ORDER_DATE,
    Orders.order_status,
    p.total_amount_paid,
    p.payment_finalized_date,
    C.FIRST_NAME,
    C.last_name_initial
FROM stg_orders as Orders
left join (
    select 
        order_id, 
        max(payment_date) as payment_finalized_date,
        sum(payment_amount) as total_amount_paid
    from stg_payments
    where payment_status <> 'fail'
    group by 1) p 
ON orders.order_id = p.order_id
left join stg_customers C 
on orders.customer_ID = C.customer_id),

-- Second CTE
customer_orders as (
    select 
        C.customer_ID as customer_id, 
        min(ORDER_DATE) as first_order_date, 
        max(ORDER_DATE) as most_recent_order_date, 
        count(ORDERS.order_ID) AS number_of_orders
from stg_customers C
left join stg_orders as Orders
on orders.customer_ID = C.customer_ID
group by 1)

-- Final Statement
select
    p.*,
    ROW_NUMBER() OVER (ORDER BY p.order_id) as transaction_seq,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY p.order_id) as customer_sales_seq,
    CASE 
        WHEN c.first_order_date = p.order_placed_at THEN 'new'
    ELSE 'return' END as nvsr, -- nvsr stands for new vs return. Note! Return here means returning customer.
    x.clv_bad as customer_lifetime_value,
    c.first_order_date as fdos
FROM paid_orders p
left join customer_orders as c USING (customer_id) -- USING is for when the column names are exactly the same.
LEFT OUTER JOIN
(
    select
        p.order_id,
        sum(t2.total_amount_paid) as clv_bad
    from paid_orders p
    left join paid_orders t2 
    /*
    The same customer can have many orders (order IDs) so we need to sum by more than one order, but it is strange the 
    statement used order id instead of customer id.

    bad might indicate that clv has been calculated incorrectly, i.e. we need to use p.customer_id not p.order_id.

    Assume that the clv calculation uses the common formula that takes into account returns.
    */
    on p.customer_id = t2.customer_id and p.order_id >= t2.order_id 
    group by 1
    order by p.order_id
) x 
on x.order_id = p.order_id
ORDER BY order_id