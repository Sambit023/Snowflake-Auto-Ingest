-- Create Database & Schemas
CREATE DATABASE TB1;
CREATE OR REPLACE SCHEMA LANDING_ZONE;
CREATE OR REPLACE SCHEMA CURATED_ZONE;
CREATE OR REPLACE SCHEMA CONSUMPTION_ZONE;

SHOW SCHEMAS;

-- CREATE ORDER, ITEM AND CUSTOMER TABLE IN LANDING ZONE
USE SCHEMA LANDING_ZONE;
CREATE OR REPLACE TRANSIENT TABLE LANDING_ITEM(
        item_id varchar,
        item_desc varchar,
        start_date varchar,
        end_date varchar,
        price varchar,
        item_class varchar,
        item_CATEGORY varchar)
    COMMENT = 'This is item table with in landing schema';

CREATE OR REPLACE TRANSIENT TABLE LANDING_CUSTOMER(
        customer_id varchar,
        salutation varchar,
        first_name varchar,
        last_name varchar,
        birth_day varchar,
        birth_month varchar,
        birth_year varchar,
        birth_country varchar,
        email_address varchar)
    COMMENT = 'This is customer table with in landing schema';

CREATE OR REPLACE TRANSIENT TABLE LANDING_ORDER(
        order_date varchar,
        order_time varchar,
        item_id varchar,
        item_desc varchar,
        customer_id varchar,
        salutation varchar,
        first_name varchar,
        last_name varchar,
        store_id varchar,
        store_name varchar,
        order_quantity varchar,
        sale_price varchar,
        disount_amt varchar,
        coupon_amt varchar,
        net_paid varchar,
        net_paid_tax varchar,
        net_profit varchar)
    COMMENT = 'This is order table with in landing schema';

SHOW TABLES;

-- CREATE FILE FORMAT
create or replace file format my_csv_vi_webui
type = 'csv' 
compression = 'auto' 
field_delimiter = ',' 
record_delimiter = '\n' 
skip_header = 1
field_optionally_enclosed_by = '\042' 
null_if = ('\\N');

/* CREATE OR REPLACE FILE FORMAT MY_CSV
TYPE = 'CSV'
COMPRESSION = 'AUTO'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '\042'
NULL_IF = ('\\N');
*/
-- LOAD DATA VIA WEB-UI
SELECT * FROM LANDING_ZONE.LANDING_CUSTOMER LIMIT 5;
SELECT COUNT(*)FROM LANDING_ZONE.LANDING_CUSTOMER; -- 2000

SELECT * FROM LANDING_ZONE.LANDING_ITEM LIMIT 5;
SELECT COUNT(*) FROM LANDING_ZONE.LANDING_ITEM; -- 100

SELECT * FROM LANDING_ZONE.LANDING_ORDER LIMIT 5;
SELECT COUNT(*) FROM LANDING_ZONE.LANDING_ORDER; -- 10000

show tables;

truncate table LANDING_CUSTOMER;
truncate table LANDING_ITEM;
truncate table LANDING_ORDER;