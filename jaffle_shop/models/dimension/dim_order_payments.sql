with payments as (

    select * from {{ ref('stg_payments') }}

),

order_payments as (

    select
        order_id,
        payment_date,
        payment_amount
    from payments
    -- Filter by successful payments only
    where payment_status <> 'fail'

)

select * from order_payments