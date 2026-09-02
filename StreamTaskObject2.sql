use database tb1;
use schema curated_zone;

create or replace stream curated_item_strm 
on table curated_zone.curated_item;

create or replace stream curated_customer_strm 
on table curated_zone.curated_customer;

create or replace stream curated_order_strm 
on table curated_zone.curated_order;

show streams;

--  
use schema consumption_zone;

create or replace task item_consumption_tsk
  warehouse = compute_wh 
  schedule  = '4 minute'
when
    system$stream_has_data('tb1.curated_zone.curated_item_strm')
as
  merge into tb1.consumption_zone.item_dim item_dim
  using tb1.curated_zone.curated_item_strm curated_item_stm on
  item_dim.item_id = curated_item_stm.item_id and 
  item_dim.start_date = curated_item_stm.start_date and 
  item_dim.item_desc = curated_item_stm.item_desc
when matched 
  and curated_item_stm.METADATA$ACTION = 'INSERT'
  and curated_item_stm.METADATA$ISUPDATE = 'TRUE'
  then update set 
      item_dim.end_date = curated_item_stm.end_date,
      item_dim.price = curated_item_stm.price,
      item_dim.item_class = curated_item_stm.item_class,
      item_dim.item_category = curated_item_stm.item_category
when matched 
  and curated_item_stm.METADATA$ACTION = 'DELETE'
  and curated_item_stm.METADATA$ISUPDATE = 'FALSE'
  then update set 
      item_dim.active_flag = 'N',
      item_dim.updated_timestamp = current_timestamp()
when not matched 
  and curated_item_stm.METADATA$ACTION = 'INSERT'
  and curated_item_stm.METADATA$ISUPDATE = 'FALSE'
then 
  insert (
    item_id,
    item_desc,
    start_date,
    end_date,
    price,
    item_class,
    item_category) 
  values (
    curated_item_stm.item_id,
    curated_item_stm.item_desc,
    curated_item_stm.start_date,
    curated_item_stm.end_date,
    curated_item_stm.price,
    curated_item_stm.item_class,
    curated_item_stm.item_category);



create or replace task customer_consumption_tsk
    warehouse = compute_wh 
schedule  = '5 minute'
when
  system$stream_has_data('tb1.curated_zone.curated_customer_strm')
as
  merge into tb1.consumption_zone.customer_dim customer_dim
  using tb1.curated_zone.curated_customer_strm curated_customer_stm on
  customer_dim.customer_id = curated_customer_stm.customer_id 
when matched 
  and curated_customer_stm.METADATA$ACTION = 'INSERT'
  and curated_customer_stm.METADATA$ISUPDATE = 'TRUE'
  then update set 
      customer_dim.salutation = curated_customer_stm.salutation,
      customer_dim.first_name = curated_customer_stm.first_name,
      customer_dim.last_name = curated_customer_stm.last_name,
      customer_dim.birth_day = curated_customer_stm.birth_day,
      customer_dim.birth_month = curated_customer_stm.birth_month,
      customer_dim.birth_year = curated_customer_stm.birth_year,
      customer_dim.birth_country = curated_customer_stm.birth_country,
      customer_dim.email_address = curated_customer_stm.email_address
when matched 
  and curated_customer_stm.METADATA$ACTION = 'DELETE'
  and curated_customer_stm.METADATA$ISUPDATE = 'FALSE'
  then update set 
      customer_dim.active_flag = 'N',
      customer_dim.updated_timestamp = current_timestamp()
when not matched 
  and curated_customer_stm.METADATA$ACTION = 'INSERT'
  and curated_customer_stm.METADATA$ISUPDATE = 'FALSE'
then 
  insert (
    customer_id ,
    salutation ,
    first_name ,
    last_name ,
    birth_day ,
    birth_month ,
    birth_year ,
    birth_country ,
    email_address ) 
  values (
    curated_customer_stm.customer_id ,
    curated_customer_stm.salutation ,
    curated_customer_stm.first_name ,
    curated_customer_stm.last_name ,
    curated_customer_stm.birth_day ,
    curated_customer_stm.birth_month ,
    curated_customer_stm.birth_year ,
    curated_customer_stm.birth_country ,
    curated_customer_stm.email_address);



create or replace task order_fact_tsk
warehouse = compute_wh 
schedule  = '6 minute'
when
  system$stream_has_data('tb1.curated_zone.curated_order_strm')
as
insert overwrite into tb1.consumption_zone.order_fact (
order_date,
customer_dim_key ,
item_dim_key ,
order_count,
order_quantity ,
sale_price ,
disount_amt ,
coupon_amt ,
net_paid ,
net_paid_tax ,
net_profit) 
select 
      co.order_date,
      cd.customer_dim_key ,
      id.item_dim_key,
      count(1) as order_count,
      sum(co.order_quantity) ,
      sum(co.sale_price) ,
      sum(co.disount_amt) ,
      sum(co.coupon_amt) ,
      sum(co.net_paid) ,
      sum(co.net_paid_tax) ,
      sum(co.net_profit)  
  from tb1.curated_zone.curated_order co 
    join tb1.consumption_zone.customer_dim cd on cd.customer_id = co.customer_id
    join tb1.consumption_zone.item_dim id on id.item_id = co.item_id and id.item_desc = co.item_desc and id.end_date is not null
    group by 
        co.order_date,
        cd.customer_dim_key ,
        id.item_dim_key
        order by co.order_date;


show tasks;

alter task item_consumption_tsk resume;
alter task customer_consumption_tsk resume;
alter task order_fact_tsk resume;
        

select *  from table(information_schema.task_history()) 
where name in ('ITEM_CONSUMPTION_TSK' ,'CUSTOMER_CONSUMPTION_TSK','ORDER_FACT_TSK')
order by scheduled_time;
