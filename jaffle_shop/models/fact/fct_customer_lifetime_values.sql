with order_payments as (

    select * from {{ ref('dim_order_payments') }}

),

customer_orders as (

    select * from {{ ref('dim_customer_orders') }}

),

customer_lifetime_values as (

    select
        co.customer_id,
        co.order_id,
        co.order_date,
        -- Customer Lifetime Values should be cumulative by order dates.
        sum(op.total_amount_paid) over (partition by co.customer_id order by co.order_date) as customer_lifetime_value

    from order_payments op
    -- LEFT JOIN order_payments to customer_orders to include all customers who have made an order.
    left join customer_orders co
    on op.order_id = co.order_id
    
)

select * from customer_lifetime_values
