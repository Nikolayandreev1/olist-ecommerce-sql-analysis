/*
kpi analysis

this script calculates core business metrics:
- total orders
- total customers
- gmv
- aov
- orders per customer
- monthly revenue
- month-over-month revenue growth
*/
set search_path to olist;

-- 1. core revenue and order metrics
-- this query calculates the main business kpis
-- using only valid completed orders

with valid_orders as (
    select 
        o.order_id,
        c.customer_unique_id
    from orders o
    join customers c
        on c.customer_id = o.customer_id
    where o.order_purchase_timestamp is not null
      and o.order_status in ('delivered', 'shipped')
),
order_totals as (
    select
        vo.order_id,
        vo.customer_unique_id,
        sum(oi.price) as items_total,
        sum(oi.freight_value) as freight_total,
        sum(oi.price + oi.freight_value) as total_with_freight
    from valid_orders vo
    join order_items oi
        on oi.order_id = vo.order_id
    group by vo.order_id, vo.customer_unique_id
)
select
    count(distinct order_id) as total_orders,
    count(distinct customer_unique_id) as total_customers,
    round(sum(items_total), 2) as gmv_items,
    round(sum(total_with_freight), 2) as gmv_with_freight,
    round(avg(items_total), 2) as aov_items,
    round(avg(total_with_freight), 2) as aov_with_freight,
    round(avg(freight_total), 2) as avg_freight_cost,
    round(
        count(distinct order_id)::numeric /
        nullif(count(distinct customer_unique_id), 0),
        3
    ) as orders_per_customer
from order_totals;



-- 2. monthly revenue and mom growth
-- this query calculates monthly revenue and
-- month-over-month growth.

-- the first 4 months and the last month in the dataset may be
-- incomplete, so they are excluded

with valid_orders as (
    select
        order_id,
        order_purchase_timestamp::timestamp as order_ts
    from orders
    where order_purchase_timestamp is not null
      and order_status in ('delivered','shipped')
),
monthly_rev as (
    select
        date_trunc('month', order_ts)::date as month,
        sum(oi.price) as revenue
    from valid_orders vo
    join order_items oi on oi.order_id = vo.order_id
    group by 1
),
numbered_months as (
    select
        month,
        revenue,
        row_number() over (order by month) as month_num
    from monthly_rev
),
revenue_with_lag as (
    select
        month,
        month_num,
        revenue,
        lag(revenue) over (order by month) as prev_revenue
    from numbered_months
)
select
    month,
    round(revenue,2) as revenue,
    round(
        100.0 * (revenue - prev_revenue) /
        nullif(prev_revenue,0),
        2
    ) as mom_growth_pct
from revenue_with_lag
where month_num >= 5 and month_num <=23
order by month;