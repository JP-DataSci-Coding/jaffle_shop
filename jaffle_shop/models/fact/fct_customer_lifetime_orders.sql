with customer_orders as (
    
    select * from {{ ref('dim_customer_orders') }}

),

customer_lifetime_orders as (
    select 
        co.customer_id,

        min(co.order_date) as customer_first_order_date,

        max(co.order_date) as customer_most_recent_order_date,

        count(co.order_id) as customer_total_number_of_orders
        
    from customer_orders as co
    group by 1
)

select * from customer_lifetime_orders