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
declare pais text[];
declare region text[];
declare ciudad text[];
declare num_random integer;
begin
count = 0;
pais = ARRAY['Bolivia', 'Bolivia','Bolivia', 'Bolivia', 'Bolivia', 'Bolivia', 'Peru',  'Peru', 'Peru', 'Chile', 'Chile'];
region = ARRAY['La Paz', 'La Paz', 'Santa Cruz','Santa cruz', 'Cochabamba','Cochambamba', 'Puno', 'Lima', 'Cusco','Santiago', 'Iquique'];
ciudad = ARRAY['El Alto','La Paz', 'Santa Cruz', 'Montero', 'Cochabamba', 'Sacaba', 'Puno', 'Lima', 'Cusquito', 'Santiago', 'Iquique'];
LOOP
    -- some computations
    IF count >= 1000 THEN
        EXIT;  -- exit loop
    END IF;
    -- generando la fechas
    _random_day = round(random() * 24 + 1);
    num_random = round(random() * 10 + 1);
    if num_random = 0 then 
      num_random = 1;
    end if;
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
      'Ferando Mujica',
      'Direccion de prueba',
      ciudad[num_random],
      region[num_random],
      '591',
      pais[num_random]
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


select * from public.orders;

select fill_orders(1, 1996); 
select fill_orders(2, 1996); 
select fill_orders(3, 1996); 
select fill_orders(4, 1996); 
select fill_orders(5, 1996); 
select fill_orders(6, 1996); 
select fill_orders(7, 1996); 
select fill_orders(8, 1996); 
select fill_orders(9, 1996); 
select fill_orders(1, 1997); 
select fill_orders(2, 1997); 
select fill_orders(3, 1997); 
select fill_orders(4, 1997); 
select fill_orders(5, 1997); 
select fill_orders(6, 1997); 
select fill_orders(7, 1997); 
select fill_orders(8, 1997); 
select fill_orders(9, 1997); 
select fill_orders(1, 1998); 
select fill_orders(2, 1998); 
select fill_orders(3, 1998); 
select fill_orders(4, 1998); 
select fill_orders(5, 1998); 
select fill_orders(6, 1998); 
select fill_orders(7, 1998); 
select fill_orders(8, 1998); 
select fill_orders(9, 1998); 
select fill_orders(1, 1999); 
select fill_orders(2, 1999); 
select fill_orders(3, 1999); 
select fill_orders(4, 1999); 
select fill_orders(5, 1999); 
select fill_orders(6, 1999); 
select fill_orders(7, 1999); 
select fill_orders(8, 1999); 
select fill_orders(9, 1999); 
select fill_orders(1, 2000); 
select fill_orders(2, 2000); 
select fill_orders(3, 2000); 
select fill_orders(4, 2000); 
select fill_orders(5, 2000); 
select fill_orders(7, 2000); 
select fill_orders(8, 2000); 
select fill_orders(9, 2000); 
select fill_orders(1, 2001); 
select fill_orders(2, 2001); 
select fill_orders(3, 2001); 
select fill_orders(4, 2001); 
select fill_orders(5, 2001); 
select fill_orders(6, 2001); 
select fill_orders(7, 2001); 
select fill_orders(8, 2001); 
select fill_orders(9, 2001); 
select fill_orders(1, 2002); 
select fill_orders(2, 2002); 
select fill_orders(3, 2002); 
select fill_orders(4, 2002); 
select fill_orders(5, 2002); 
select fill_orders(6, 2002); 
select fill_orders(7, 2002); 
select fill_orders(8, 2002); 
select fill_orders(9, 2002); 
select fill_orders(1, 2003); 
select fill_orders(2, 2003); 
select fill_orders(3, 2003); 
select fill_orders(4, 2003); 
select fill_orders(5, 2003); 
select fill_orders(6, 2003); 
select fill_orders(7, 2003); 
select fill_orders(8, 2003); 
select fill_orders(9, 2003); 
select fill_orders(1, 2004); 
select fill_orders(2, 2004); 
select fill_orders(3, 2004); 
select fill_orders(4, 2004); 
select fill_orders(5, 2004); 
select fill_orders(6, 2004); 
select fill_orders(7, 2004); 
select fill_orders(8, 2004); 
select fill_orders(9, 2004); 
select fill_orders(1, 2005); 
select fill_orders(2, 2005); 
select fill_orders(3, 2005); 
select fill_orders(4, 2005); 
select fill_orders(5, 2005); 
select fill_orders(6, 2005); 
select fill_orders(7, 2005); 
select fill_orders(8, 2005); 
select fill_orders(9, 2005); 
select fill_orders(1, 2006); 
select fill_orders(2, 2006); 
select fill_orders(3, 2006); 
select fill_orders(4, 2006); 
select fill_orders(5, 2006); 
select fill_orders(6, 2006); 
select fill_orders(7, 2006); 
select fill_orders(8, 2006); 
select fill_orders(9, 2006); 
select fill_orders(1, 2007); 
select fill_orders(2, 2007); 
select fill_orders(3, 2007); 
select fill_orders(4, 2007); 
select fill_orders(5, 2007); 



select count(*) from public.orders;
select count(*) from public.orderdetails;
truncate table  public.orders cascade;
truncate table  public.orderdetails cascade;
select * from public.orders where shipregion is null;

select * from stage_star_fact_orden where idw_geografia = -1;
select * from stage_star_dim_geografia;
select * from star.dim_geografia;

