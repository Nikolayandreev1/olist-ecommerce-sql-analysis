/*
 Data Quality Checks
This script performs basic validation checks
to ensure the integrity of the Olist dataset
-- before running analytical queries.
*/
set search_path to olist;



-- 1. Row count validation
-- Check the number of records in each table

select 'customers' as table_name, count(*) from customers
union all
select 'orders', count(*) from orders
union all
select 'order_items', count(*) from order_items
union all
select 'products', count(*) from products
union all
select 'payments', count(*) from payments
union all
select 'category_translation', count(*) from category_translation;



-- 2. Check for NULL values in primary keys
-- Primary keys should never contain NULL values

select count(*) as null_customer_ids
from customers
where customer_id is null;

select count(*) as null_order_ids
from orders
where order_id is null;

select count(*) as null_product_ids
from products
where product_id is null;



-- 3. Foreign key integrity checks
-- Ensure that relationships between tables are valid

-- Orders without matching customers

select count(*) as orders_without_customer
from orders o
left join customers c
    on o.customer_id = c.customer_id
where c.customer_id is null;


-- Order items without matching orders

select count(*) as order_items_without_order
from order_items oi
left join orders o
    on oi.order_id = o.order_id
where o.order_id is null;


-- Order items without matching products

select count(*) as  order_items_without_product
from order_items oi
left join products p
    on oi.product_id = p.product_id
where p.product_id is null;



-- 4. Price validation
-- Ensure product prices are valid

-- Negative prices (should not exist)

select count(*) as negative_prices
from order_items
where price < 0;


-- Zero prices (may indicate free items or data issues)

select count(*) as zero_prices
from order_items
where price = 0;



-- 5. Check missing timestamps
-- Orders should have purchase timestamps

select count(*) as missing_purchase_timestamp
from orders
where order_purchase_timestamp is null;



-- 6. Consistency check
-- Verify that each order is linked to a customer

select
    count(distinct o.order_id) as total_orders,
    count(distinct c.customer_id) as total_customers
from orders o
join customers c
    on o.customer_id = c.customer_id;