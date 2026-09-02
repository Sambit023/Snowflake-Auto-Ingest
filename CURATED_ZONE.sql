USE DATABASE TB1;
USE SCHEMA CURATED_ZONE;

create or replace transient table curated_customer (
      customer_pk number autoincrement,
      customer_id varchar(18),
      salutation varchar(10),
      first_name varchar(20),
      last_name varchar(30),
      birth_day number,
      birth_month number,
      birth_year number,
      birth_country varchar(20),
      email_address varchar(50)
    ) comment ='this is customer table with in curated schema';


create or replace transient table curated_item (
      item_pk number autoincrement,
      item_id varchar(16),
      item_desc varchar,
      start_date date,
      end_date date,
      price number(7,2),
      item_class varchar(50),
      item_category varchar(50)
    ) comment ='this is item table with in curated schema';


create or replace transient table curated_order (
      order_pk number autoincrement,
      order_date date,
      order_time varchar,
      item_id varchar(16),
      item_desc varchar,
      customer_id varchar(18),
      salutation varchar(10),
      first_name varchar(20),
      last_name varchar(30),
      store_id varchar(16),
      store_name VARCHAR(50),
      order_quantity number,
      sale_price number(7,2),
      disount_amt number(7,2),
      coupon_amt number(7,2),
      net_paid number(7,2),
      net_paid_tax number(7,2),
      net_profit number(7,2)
    ) comment ='this is order table with in curated schema';

SHOW TABLES;

-- MOVING DATA FROM LANDING ZONE TO CURATED ZONE TABLES 
insert into TB1.CURATED_ZONE.CURATED_CUSTOMER (
      customer_id ,
      salutation ,
      first_name ,
      last_name ,
      birth_day ,
      birth_month ,
      birth_year ,
      birth_country ,
      email_address ) 
    select 
      customer_id ,
      salutation ,
      first_name ,
      last_name ,
      birth_day ,
      birth_month ,
      birth_year ,
      birth_country ,
      email_address 
    from TB1.LANDING_ZONE.LANDING_CUSTOMER;


insert into TB1.CURATED_ZONE.CURATED_ITEM (
        item_id,
        item_desc,
        start_date,
        end_date,
        price,
        item_class,
        item_category) 
    select 
        item_id,
        item_desc,
        TO_DATE(start_date,'YYYY-MM-DD'),
        TO_DATE(end_date,'YYYY-MM-DD'),
        price,
        item_class,
        item_category
    from TB1.LANDING_ZONE.LANDING_ITEM;


insert into TB1.CURATED_ZONE.CURATED_ORDER (
      order_date ,
      order_time ,
      item_id ,
      item_desc ,
      customer_id ,
      salutation ,
      first_name ,
      last_name ,
      store_id ,
      store_name ,
      order_quantity ,
      sale_price ,
      disount_amt ,
      coupon_amt ,
      net_paid ,
      net_paid_tax ,
      net_profit) 
    select 
      TO_DATE(order_date,'YYYY-MM-DD'),
      order_time ,
      item_id ,
      item_desc ,
      customer_id ,
      salutation ,
      first_name ,
      last_name ,
      store_id ,
      store_name ,
      order_quantity ,
      sale_price ,
      disount_amt ,
      coupon_amt ,
      net_paid ,
      net_paid_tax ,
      net_profit  
  from TB1.LANDING_ZONE.LANDING_ORDER;


SELECT * FROM CURATED_ZONE.CURATED_CUSTOMER LIMIT 5;
SELECT COUNT(*)FROM CURATED_ZONE.CURATED_CUSTOMER;

SELECT * FROM CURATED_ZONE.CURATED_ITEM LIMIT 5;
SELECT COUNT(*) FROM CURATED_ZONE.CURATED_ITEM;

SELECT * FROM CURATED_ZONE.CURATED_ORDER LIMIT 5;
SELECT COUNT(*) FROM CURATED_ZONE.CURATED_ORDER;


truncate table CURATED_CUSTOMER;
truncate table CURATED_ITEM;
truncate table CURATED_ORDER;

show tables;