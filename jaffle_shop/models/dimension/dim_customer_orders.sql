with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

customer_orders as (

    select 
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.order_status,
        customers.customer_first_name,
        customers.customer_last_name_initial
    from customers
    -- LEFT JOIN customers to orders, so it includes every customer, even if they have not yet made an order.
    left join orders
    on customers.customer_id = orders.customer_id
    
)

select * from customer_orders


