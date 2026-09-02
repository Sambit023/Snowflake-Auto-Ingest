use database tb1;
use schema landing_zone;

create or replace stage my_stage
file_format = 'my_csv_vi_webui';

show stages;

list @my_stage;


drop stage my_stage;

create or replace pipe customer_pipe
auto_ingest = true
as
    copy into LANDING_CUSTOMER from @my_stage/customer/customers.csv
    file_format = (type=csv COMPRESSION=none)
    ON_ERROR = 'CONTINUE';


create or replace pipe item_pipe
auto_ingest = true
as
    copy into LANDING_ITEM from @my_stage/item/items.csv
    file_format = (type=csv COMPRESSION=none)
    ON_ERROR = 'CONTINUE';


create or replace pipe order_pipe
auto_ingest = true
as
    copy into LANDING_ORDER from @my_stage/order/orders.csv
    file_format = (type=csv COMPRESSION=none)
    ON_ERROR = 'CONTINUE';


show pipes;

select system$pipe_status('CUSTOMER_PIPE');
select system$pipe_status('ITEM_PIPE');
select system$pipe_status('ORDER_PIPE');

show tables;