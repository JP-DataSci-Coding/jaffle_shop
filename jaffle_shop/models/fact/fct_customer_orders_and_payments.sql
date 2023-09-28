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
        op.total_amount_paid,

        max(op.payment_date) as finalised_order_payment_date
        
    from order_payments op
    -- LEFT JOIN order_payments to customer_orders to include all customers who have made an order.
    left join customer_orders co
    on op.order_id = co.order_id
    group by 1, 2, 3, 4, 5, 6, 7

)

{{
 config(
 materialized = 'incremental',
 on_schema_change='fail'
 )
}}

select * from customer_orders_and_payments
where total_amount_paid > 0
-- "this" refers to the fct_customer_orders_and_payments.sql model.
-- "order_date" is for the customers_orders_and_payments table in this case.
{% if is_incremental() %}
    and order_date > (select max(order_date) from {{ this }})
{% endif %} 