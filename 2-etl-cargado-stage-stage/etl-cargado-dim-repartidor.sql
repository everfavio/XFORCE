-- SETEAMOS POR DEFECTO A stage
SET search_path TO stage;
ALTER database xforce_orders_online SET search_path TO stage;
-- creando la funcion

create or replace function two_etl_stage_dim_repartidor()
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
    -- para el logueador
  declare nombre_proceso varchar;
  declare fecha_inicio timestamp;
  declare fecha_fin timestamp;
  declare comentario varchar;
  declare cantidad_registros integer;
  declare correcto boolean;
  --body del procediiento
  BEGIN
    fecha_inicio = now()::timestamp;
    nombre_proceso = 'one_etl_stage_dim_producto';
    cantidad_registros = 0;
    -- limpieza de suppliers
    truncate table  stage_star_dim_producto;
    insert into stage_star_dim_producto (
      idw_producto     ,
      id_producto      ,
      nombre_producto  ,
      precio_unitario  ,
      cantidad_unidad  ,
      id_categoria     ,
      categoria        ,
      id_proveedor     ,
      proveedor        ,
      ciudad_proveedor ,
      pais_proveedor   ,
      region_proveedor ,
      nombre_contacto  ,
      fecha_inicio     ,
      fecha_fin        ,
      vigente         
    )
    select 
    coalesce(
      (select idw_producto
      from star.dim_producto
      where id_producto = stp.productid
      and id_categoria = stp.categoryid
      and id_proveedor = stp.supplierid
    ), -1 ) idw_producto,
    stp.productid,
    stp.productname,
    stp.unitprice,
    -- cast (stp.quantityperunit as integer) quantityperunit,
    12,
    stp.categoryid,
    stc.categoryname,
    stp.supplierid,
    sts.companyname,
    sts.city,
    sts.country,
    sts.region,
    sts.contactname,
    now() fecha_inicio,
    now() fecha_final,
    true vigente
    from
      stage_trans_products stp
      inner join stage_trans_categories stc on stc.categoryid = stp.categoryid
      inner join stage_trans_suppliers sts on sts.supplierid = stp.supplierid;    
    -- 
    GET DIAGNOSTICS cantidad_registros = ROW_COUNT;
    fecha_fin = now()::timestamp;
    comentario = FORMAT('El proceso %s termino correctamente', nombre_proceso);
    correcto = true;
    -- llamar al logueador
    perform log_procesos( nombre_proceso, comentario , cantidad_registros , correcto , fecha_inicio, fecha_fin );
    RETURN true;
    -- tratamiento de excepciones
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
    -- llamar al logueador
    correcto = false;
    fecha_fin = now()::timestamp;
    cantidad_registros = 0;
    comentario = FORMAT('La exepcion es %s %s %s %s ', err_context, error_pg_exception_detail, err_column_name, error_message_text);
    perform log_procesos( nombre_proceso, comentario , cantidad_registros , correcto , fecha_inicio, fecha_fin );
    return false;
  END;
$$ language plpgsql;

-- select two_etl_stage_dim_producto()
-- select * from stage_star_dim_producto;
-- select * from log_de_procesos;
