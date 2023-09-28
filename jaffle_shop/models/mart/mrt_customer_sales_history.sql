with customer_orders_and_payments as (

    select * from {{ ref('fct_customer_orders_and_payments') }}

),

customer_lifetime_orders as (

    select * from {{ ref('fct_customer_lifetime_orders') }}

),

customer_lifetime_values as (

    select * from {{ ref('fct_customer_lifetime_values') }}

),

customer_sales_history as (

    select
        cop.*,

        row_number() over (order by cop.order_id) as order_sequence,

        row_number() over (partition by cop.customer_id order by cop.order_id) as customer_order_sequence,

        case 
            when clo.customer_first_order_date = cop.order_date then 'new'
            else 'returning' 
        end as new_or_returning_customer,
        
        clo.customer_first_order_date,
        clv.customer_lifetime_value
    from customer_orders_and_payments cop
    left join customer_lifetime_orders clo
    on cop.customer_id = clo.customer_id
    left join customer_lifetime_values clv
    on cop.order_id = clv.order_id
    order by customer_id, order_date

)

select * from customer_sales_history