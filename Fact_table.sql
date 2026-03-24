set search_path to olist;

drop table if exists fact_table;

create table fact_table as
with order_items_agg as ( 
   select 
      oi.order_id, 
      sum(oi.price) as order_value ,
      sum(oi.freight_value) as freight_value
   from order_items oi
   group by oi.order_id 
   ),
payment_agg as ( 
   select 
      p.order_id, 
      max(p.payment_type) as payment_type 
   from payments p 
   group by p.order_id 
   ),
category_agg as (
   select 
      oi.order_id,
      min(ct.product_category_name_english) as product_category
   from order_items oi 
   left join products pr on oi.product_id = pr.product_id
   left join category_translation ct 
        on pr.product_category_name = ct.product_category_name 
   group by oi.order_id
   )
   select 
      o.order_id, 
      o.order_purchase_timestamp, 
      c.customer_unique_id, 
      oi.order_value,
      oi.freight_value, 
      (oi.order_value + oi.freight_value) as total_value,
      cat.product_category,
      pay.payment_type,
      DATE_TRUNC('month', o.order_purchase_timestamp) as order_month
   from orders o 
   join customers c on o.customer_id = c.customer_id 
   left join order_items_agg oi on o.order_id = oi.order_id
   left join payment_agg pay on o.order_id = pay.order_id
   left join category_agg cat on o.order_id = cat.order_id 
   where order_purchase_timestamp is not null
      and order_status in ('delivered', 'shipped')
   
      
      
   select count(*) 
   from fact_table
   
   select count (distinct order_id) 
   from fact_table
   
   select order_id, count(*)
from fact_table
group by order_id
having count(*) > 1;
      
   