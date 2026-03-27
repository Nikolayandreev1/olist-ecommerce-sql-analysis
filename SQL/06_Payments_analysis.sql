-- Payment method distribution
set search_path to olist;

select
    payment_type,
    count(*) as total_payments
from payments
group by payment_type
order by total_payments desc;


-- Revenue by payment type

select
    payment_type,
    round(sum(payment_value),2) as revenue
from payments
group by payment_type
order by revenue desc;

-- Installment usage

select
    payment_installments,
    count(*) as orders
from payments
group by payment_installments
order by payment_installments;