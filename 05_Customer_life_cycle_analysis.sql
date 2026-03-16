/*
-- cohort analysis

this script performs customer cohort retention analysis.

logic:
1. identify valid completed orders
2. find the first purchase date for each customer
3. assign each customer to a cohort month
4. calculate months since first purchase
5. compute retention rates
6. pivot results into a cohort matrix (m0 to m6)

*/
set search_path to olist;


-- 
-- step 1: filter valid orders
-- 
with valid_orders as (
    select 
        order_id,
        customer_id,
        order_purchase_timestamp
    from orders
    where order_purchase_timestamp is not null
      and order_status in ('delivered', 'shipped')
),
-- 
-- step 2: find first purchase date for each customer
-- 
first_purchase as (
    select 
        c.customer_unique_id,
        min(vo.order_purchase_timestamp::timestamp) as first_purchase_date
    from valid_orders vo
    join customers c
        on vo.customer_id = c.customer_id
    group by c.customer_unique_id
),
-- 
-- step 3: assign cohort month
-- 
cohort as (
    select 
        customer_unique_id,
        first_purchase_date,
        date_trunc('month', first_purchase_date) as cohort_month
    from first_purchase
),
-- 
-- step 4: attach all customer orders to the cohort
-- 
customer_orders as (
    select 
        c.customer_unique_id,
        vo.order_purchase_timestamp,
        date_trunc('month', vo.order_purchase_timestamp) as order_month,
        ch.cohort_month
    from valid_orders vo
    join customers c
        on vo.customer_id = c.customer_id
    join cohort ch
        on c.customer_unique_id = ch.customer_unique_id
),
-- 
-- step 5: calculate month index
-- month_index = number of months since first purchase
-- 
cohort_index as (
    select
        customer_unique_id,
        cohort_month,
        order_month,
        date_part('month', age(order_month, cohort_month)) as month_index
    from customer_orders
),
-- 
-- step 6: count active customers by cohort and month
-- 
retention as (
    select
        cohort_month,
        month_index,
        count(distinct customer_unique_id) as active_customers
    from cohort_index
    group by cohort_month, month_index
),
-- 
-- step 7: get original cohort size
-- month_index = 0 represents the first purchase month
-- 
cohort_size as (
    select 
        cohort_month,
        active_customers as cohort_customers
    from retention
    where month_index = 0
),
-- 
-- step 8: calculate retention rate percentage
-- keep only the first 7 months (m0 to m6)
-- 
retention_rates as (
    select
        r.cohort_month,
        r.month_index,
        r.active_customers,
        cs.cohort_customers,
        round(
            100.0 * r.active_customers::numeric / cs.cohort_customers,
            2
        ) as retention_rate_pct
    from retention r
    join cohort_size cs
        on r.cohort_month = cs.cohort_month
    where r.month_index <= 6
)
-- 
-- final output: cohort retention matrix
-- m0 = first purchase month
-- m1 = one month after first purchase
-- .
-- m6 = six months after first purchase
-- 
select
    cohort_month,
    max(case when month_index = 0 then retention_rate_pct end) as m0,
    max(case when month_index = 1 then retention_rate_pct end) as m1,
    max(case when month_index = 2 then retention_rate_pct end) as m2,
    max(case when month_index = 3 then retention_rate_pct end) as m3,
    max(case when month_index = 4 then retention_rate_pct end) as m4,
    max(case when month_index = 5 then retention_rate_pct end) as m5,
    max(case when month_index = 6 then retention_rate_pct end) as m6
from retention_rates
group by cohort_month
order by cohort_month;




/*
 
cohort retention analysis (long format)

this query calculates cohort retention rates
by cohort month and month index.

output format:
cohort_month | month_index | retention_rate_pct
*/
set search_path to olist;

-- step 1: filter valid orders

with valid_orders as (
    select
        order_id,
        customer_id,
        order_purchase_timestamp
    from orders
    where order_purchase_timestamp is not null
      and order_status in ('delivered','shipped')
),
-- step 2: find first purchase date per customer
first_purchase as (
    select
        c.customer_unique_id,
        min(vo.order_purchase_timestamp) as first_purchase_date
    from valid_orders vo
    join customers c
        on vo.customer_id = c.customer_id
    group by c.customer_unique_id
),
-- step 3: assign cohort month
cohort as (
    select
        customer_unique_id,
        date_trunc('month', first_purchase_date) as cohort_month
    from first_purchase
),
-- step 4: attach orders to cohort
customer_orders as (
    select
        c.customer_unique_id,
        date_trunc('month', vo.order_purchase_timestamp) as order_month,
        ch.cohort_month
    from valid_orders vo
    join customers c
        on vo.customer_id = c.customer_id
    join cohort ch
        on c.customer_unique_id = ch.customer_unique_id
),
-- step 5: calculate month index
cohort_index as (
    select
        customer_unique_id,
        cohort_month,
        order_month,
        date_part('month', age(order_month, cohort_month)) as month_index
    from customer_orders
),
-- step 6: count active customers
retention as (
    select
        cohort_month,
        month_index,
        count(distinct customer_unique_id) as active_customers
    from cohort_index
    group by cohort_month, month_index
),
-- step 7: cohort size
cohort_size as (
    select
        cohort_month,
        active_customers as cohort_customers
    from retention
    where month_index = 0
)
-- final output
select
    r.cohort_month,
    r.month_index,
    r.active_customers,
    cs.cohort_customers,
    round(
        100.0 * r.active_customers::numeric / cs.cohort_customers,
        2
    ) as retention_rate_pct
from retention r
join cohort_size cs
    on r.cohort_month = cs.cohort_month
where r.month_index <= 6
order by r.cohort_month, r.month_index;





