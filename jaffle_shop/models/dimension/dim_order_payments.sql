with payments as (

    select * from {{ ref('stg_payments') }}

),

order_payments as (

    select
        order_id,
        payment_date,

        sum(payment_amount) as total_amount_paid

    from payments
    -- Filter by successful payments only
    where payment_status <> 'fail'
    group by 1, 2

)

select * from order_payments