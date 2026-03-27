-- Import Olist dataset CSV files

set search_path to olist;

-- Import customers

copy customers
from '/path/olist_customers_dataset.csv'
delimiter ','
CSV header;

-- Import orders

copy orders
from '/path/olist_orders_dataset.csv'
delimiter ','
CSV header;

-- Import products

copy products
from '/path/olist_products_dataset.csv'
delimiter ','
csv header;

-- Import order items

copy order_items
from '/path/olist_order_items_dataset.csv'
delimiter ','
csv header;

-- Import payments

copy payments
from '/path/olist_order_payments_dataset.csv'
delimiter ','
CSV header;

-- Import category translation

copy category_translation
from '/path/product_category_name_translation.csv'
delimiter ','
CSV header;