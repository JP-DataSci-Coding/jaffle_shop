with order_payments as (

    select * from {{ ref('dim_order_payments') }}

),

customer_orders as (

    select * from {{ ref('dim_customer_orders') }}

),

customer_orders_and_payments as (

    select
        co.order_id,
        co.customer_id,
        co.order_date,
        co.order_status,
        co.customer_first_name,
        co.customer_last_name_initial,
        sum(op.payment_amount) as total_amount_paid,
        max(op.payment_date) as finalised_order_payment_date
    from order_payments op
    -- LEFT JOIN order_payments to customer_orders to include all customers who have made an order.
    left join customer_orders co
    on op.order_id = co.order_id
    group by 1, 2, 3, 4, 5, 6

)

select * from customer_orders_and_payments