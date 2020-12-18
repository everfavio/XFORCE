-- SETEAMOS POR DEFECTO A stage
SET search_path TO stage;
ALTER database xforce_orders_online SET search_path TO stage;
-- creando la funcion
CREATE OR REPLACE FUNCTION "stage"."three_etl_fact_order"("_fecha_inicio" date, "_fecha_final" date)
  RETURNS boolean 
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
  -- auxiliares
  declare fecha_max date;
    declare fecha_min date;
    declare contador integer;
    declare cantidad_dias integer;
    declare fecha_actual date;
  --body del procediiento
  BEGIN
    fecha_inicio = now()::timestamp;
    nombre_proceso = 'three_etl_fact_order';
    cantidad_registros = 0;
    contador = 0;
    -- limpieza de la fact
    -- delete from star.fact_orden 
    -- where fecha_pedido between  _fecha_inicio and _fecha_final;
      insert into star.fact_orden (
        id_orden             ,
        flete                ,
        ciudad_entrega       ,
        region_entrega       ,
        pais_entrega         ,
        importe_venta_total  ,
        id_orden_detalle     ,
        precio_unitario      ,
        cantidad             ,
        descuento            ,
        importe_venta_detalle,
        idw_cliente          ,
        idw_empleado         ,
        idw_repartidor       ,
        idw_producto         ,
        idw_geografia        ,
        fecha_pedido     ,
        fecha_entrega    ,
        fecha_requerido ,
        origen 
      ) 
    select
        id_orden             ,
        flete                ,
        ciudad_entrega       ,
        region_entrega       ,
        pais_entrega         ,
        importe_venta_total  ,
        id_orden_detalle     ,
        precio_unitario      ,
        cantidad             ,
        descuento            ,
        importe_venta_detalle,
        idw_cliente          ,
        idw_empleado         ,
        idw_repartidor       ,
        idw_producto         ,
        idw_geografia        ,
        fecha_pedido     ,
        fecha_entrega    ,
        fecha_requerido ,
        origen 
    from
      stage_star_fact_orden o
			where concat(origen,id_orden) not in (select concat(origen,id_orden) from star.fact_orden);
      --TODO no se filtra por rango de fechas tmb?
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

-- select two_etl_stage_dim_tiempo()
-- select * from stage_star_dim_tiempo;
-- select * from log_de_procesos;
