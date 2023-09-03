with payments as (

    select 
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status as payment_status,
        -- Amount is stored as cents or pence, so it is converted to dollars or pounds
        amount / 100 as payment_amount,
        created as payment_date
    from raw.stripe_payments
    
)

select * from payments

