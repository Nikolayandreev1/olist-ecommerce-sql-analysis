/*
product analysis

-this script analyzes product and category performance
- using valid completed orders only.

-metrics included:
-top categories by revenue
-top products by revenue
-average price by category
*/

set search_path to olist;


-- 1. top 10 categories by revenue

-- this query shows which product categories generate
-- the highest total revenue, including freight value.

with valid_orders as (
    select
        order_id
    from orders
    where order_purchase_timestamp is not null
      and order_status in ('delivered', 'shipped')
)
select
    coalesce(ct.product_category_name_english, p.product_category_name) as category,
    round(sum(oi.price + oi.freight_value), 2) as revenue
from valid_orders vo
join order_items oi
    on vo.order_id = oi.order_id
join products p
    on oi.product_id = p.product_id
left join category_translation ct
    on p.product_category_name = ct.product_category_name
group by coalesce(ct.product_category_name_english, p.product_category_name)
order by revenue desc
limit 10;



-- 2. top 10 products by revenue

-- this query identifies the best-performing products
-- based on total revenue, including freight value.

with valid_orders as (
    select
        order_id
    from orders
    where order_purchase_timestamp is not null
      and order_status in ('delivered', 'shipped')
)
select
    p.product_id,
    coalesce(ct.product_category_name_english, p.product_category_name) as category,
    round(sum(oi.price + oi.freight_value), 2) as revenue
from valid_orders vo
join order_items oi
    on vo.order_id = oi.order_id
join products p
    on oi.product_id = p.product_id
left join category_translation ct
    on p.product_category_name = ct.product_category_name
group by
    p.product_id,
    coalesce(ct.product_category_name_english, p.product_category_name)
order by revenue desc
limit 10;



-- 3. average price by category

-- this query calculates the average item price
-- within each product category, along with the number
-- of items sold.

with valid_orders as (
    select
        order_id
    from orders
    where order_purchase_timestamp is not null
      and order_status in ('delivered', 'shipped')
)
select
    coalesce(ct.product_category_name_english, p.product_category_name) as category,
    round(avg(oi.price), 2) as avg_category_price,
    count(*) as items_sold
from valid_orders vo
join order_items oi
    on vo.order_id = oi.order_id
join products p
    on oi.product_id = p.product_id
left join category_translation ct
    on p.product_category_name = ct.product_category_name
group by coalesce(ct.product_category_name_english, p.product_category_name)
order by avg_category_price desc;


