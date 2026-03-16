/*
E-commerce SQL Analytics Project
Schema Definition

This script creates the database schema and tables required
to analyze the Brazilian Olist e-commerce dataset.

Tables created:
- customers
- orders
- products
- order_items
- payments
- category_translation
*/


select current_database();

drop schema if exists olist cascade;
create schema olist;
set search_path to olist;


/*
TABLE: customers

Stores customer information.

customer_id         → order-level customer identifier
customer_unique_id  → real unique customer identifier
*/

create table customers (
 customer_id         text primary key,
 customer_unique_id  text not null,
 customer_zip_code_prefix int,
 customer_city       text, 
 customer_state      text
 );


/*
TABLE: orders

Contains order-level information.
Each row represents a single order.
*/

create table orders (
 order_id            text primary key,
 customer_id         text not null references customers(customer_id),
 order_status        text, 
 order_purhcase_timestamp      timestamp,
 order_approved_at             timestamp, 
 order_delivered_carrier_date  timestamp, 
 order_delivered_customer_date timestamp, 
 order_estimated_delivery_date timestamp
 );


/*
TABLE: products

Contains product attributes.
*/

create table products (
  product_id               text primary key,
  product_category_name    text,
  product_name_length      int,
  product_description_length int,
  product_photos_qty       int,
  product_weight_g         int,
  product_length_cm        int,
  product_height_cm        int,
  product_width_cm         int
);


/*
TABLE: category_translation

Mapping table used to translate product categories
from Portuguese to English.
*/


create table category_translation (
  product_category_name         text primary key,
  product_category_name_english text
);



/*
TABLE: order_items

Contains item-level information for each order.
An order can contain multiple products.
*/

create table order_items (
  order_id           text not null references orders(order_id),
  order_item_id      int not null,
  product_id         text not null references products(product_id),
  seller_id          text,
  shipping_limit_date timestamp,
  price              numeric(12,2),
  freight_value      numeric(12,2),
  primary key (order_id, order_item_id)
);


/*
TABLE: payments

Contains payment information for orders.

Some orders may have multiple payment records.
*/


create table payments (
  order_id          text not null  references orders(order_id),
  payment_sequential int not null,
  payment_type      text, 
  payment_installments int ,
  payment_value     numeric(12,2),
  primary key (order_id, payment_sequential)
);

--DATA CLEANING

--Ensure order_purchase_timestamp has correct type.

alter table olist.orders
alter column order_purchase_timestamp type timestamp
using order_purchase_timestamp::timestamp;

