/*
customer analysis

 this script analyzes customer purchasing behavior
 including repeat purchases and customer retention
*/
set search_path to olist;

-- calculate number of orders per customer

with orders_per_customer as (
    select
        c.customer_unique_id,
        count(distinct o.order_id) as orders_per_customer
    from customers c
    join orders o
        on o.customer_id = c.customer_id
    where o.order_purchase_timestamp is not null
      and o.order_status in ('delivered','shipped')
    group by c.customer_unique_id
)
-- calculate repeat purchase metrics
select
    count(distinct customer_unique_id) as total_customers,
    count(*) filter (
        where orders_per_customer > 1
    ) as returning_customers,
    round(
        count(*) filter (
            where orders_per_customer > 1
        )::numeric
        /
        count(distinct customer_unique_id),
        4
    ) as repeat_purchase_rate
from orders_per_customer;

--distribution of orders per customer

with orders_per_customer as (
    select
        c.customer_unique_id,
        count(distinct o.order_id) as orders_per_customer
    from customers c
    join orders o
        on o.customer_id = c.customer_id
    where o.order_purchase_timestamp is not null
      and o.order_status in ('delivered','shipped')
    group by c.customer_unique_id
)
select
    orders_per_customer,
    count(*) as customers
from orders_per_customer
where orders_per_customer <=3 
group by orders_per_customer
order by orders_per_customer;
