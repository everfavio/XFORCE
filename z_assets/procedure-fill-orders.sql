-- SETEAMOS POR DEFECTO A stage
SET search_path TO public;
ALTER database xforce_orders_online SET search_path TO public;

create or replace function fill_orders(month integer, year integer)
returns boolean
as $$
--para errores
declare err_context text;
declare err_column_name text;
declare error_returned_sqlstate text;
declare error_message_text text;
declare error_constraint_name text;
declare error_pg_datatype_name text;
declare error_table_name text;
declare error_pg_exception_detail text;
declare error_pg_exception_hint text;
-- para llenar orders
-- y details
declare count integer;
declare _orderid_creado integer;
declare _orderdetailid_creado integer;
declare _product record;
declare _productid integer;
-- auxiliaries
declare _random_day integer;
declare _string_date varchar;
declare _date date;
begin
count = 0;
LOOP
    -- some computations
    IF count >= 100000 THEN
        EXIT;  -- exit loop
    END IF;
    -- generando la fechas
    _random_day = round(random() * 24 + 1);
    _string_date = _random_day || '-' || month || '-' || year;
    _date = to_date(_string_date, 'DD-MM-YYYY');
    insert into orders (
                      customerid  ,  
                      employeeid  ,  
                      orderdate   ,  
                      requireddate,  
                      shippeddate ,  
                      shipvia     ,  
                      freight     ,  
                      shipname    ,  
                      shipaddress ,  
                      shipcity    ,  
                      shipregion  ,  
                      shippostalcode,
                      shipcountry )
  values(
      round(random() * 9 + 1),
      round(random() * 8 + 1),
      _date,
      _date + interval '1' day,
      _date + interval '2' day, 
      round(random() * 2 + 1 ),
      round(random() * 99 + 1),
      'IVAN MUJICA',
      'LAS DELIZIAS 123',
      'EL ALTO',
      'LA PAZ',
      '591',
      'BOLIVIA'
    ) returning orderid INTO _orderid_creado;
    RAISE INFO '---------->>orden % creadas', _orderid_creado ;
    -- para detalles
    -- calculamos el id producto
    _productid = round(random() * 56 + 1);
    -- recuperamos el producto
    select * into _product from products where productid = _productid limit 1;
    -- insertamos el registro
    insert into orderdetails (
        productid     ,
        orderid       ,
        unitprice     ,
        quantity      ,
        discount      
    )
    values(
      _productid,
      _orderid_creado,
      _product.unitprice,
      round(random() * 50 + 1),
      0        
    ) returning orderdetailid into _orderdetailid_creado;
    raise info 'orden  % creada, detail % creado', _orderid_creado,  _orderdetailid_creado;
    count = count + 1;
  END LOOP;
  return true;
  EXCEPTION
   WHEN SQLSTATE '22003' THEN
       RAISE EXCEPTION  'El valor númerico enviado para uno de los campos es demasiado grande. Por favor revise sus datos.';
   WHEN OTHERS then
   GET STACKED DIAGNOSTICS err_context = PG_CONTEXT,
                          error_table_name = TABLE_NAME,
                          error_pg_exception_detail = PG_EXCEPTION_DETAIL,
                          err_column_name = COLUMN_NAME,
                          error_message_text = MESSAGE_TEXT,
                          error_returned_sqlstate = RETURNED_SQLSTATE ;
        RAISE INFO 'Error Nombre:%',SQLERRM;
        RAISE INFO 'Error estado:%', SQLSTATE;
        RAISE exception 'Error :%', error_message_text;
     return false;
  END;
$$ language plpgsql;

select fill_orders(2, 2020); 
select count(*) from public.orders;

