use database tb1;
use schema landing_zone;

select count(*) from tb1.landing_zone.landing_order; -- 10000
select count(*) from tb1.landing_zone.landing_item; -- 100
select count(*) from tb1.landing_zone.landing_customer; -- 2000


select count(*) from tb1.landing_zone.land_order_strm;
select count(*) from tb1.landing_zone.land_item_strm; 
select count(*) from tb1.landing_zone.land_customer_strm;



select count(*) from tb1.curated_zone.curated_order;
select count(*) from tb1.curated_zone.curated_item;
select count(*) from tb1.curated_zone.curated_customer;

select count(*) from tb1.consumption_zone.order_fact;
select count(*) from tb1.consumption_zone.item_dim;
select count(*) from tb1.consumption_zone.customer_dim;