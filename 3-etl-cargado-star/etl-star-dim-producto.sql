-- SETEAMOS POR DEFECTO A stage
SET search_path TO stage;
ALTER database xforce_orders_online SET search_path TO stage;
-- creando la funcion
create or replace function three_etl_star_dim_producto()
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
  -- auxiliares
  declare contador_diferencias integer;
  declare fila_producto record;
  declare  cursor_productos cursor for
    select
      idw_producto    ,
      id_producto     ,
      nombre_producto ,
      precio_unitario ,
      cantidad_unidad ,
      id_categoria    ,
      categoria       ,
      id_proveedor    ,
      proveedor       ,
      ciudad_proveedor,
      pais_proveedor  ,
      region_proveedor,
      nombre_contacto 
    from stage_star_dim_producto
    except
    select 
     idw_producto    ,
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
     nombre_contacto  
    from star.dim_producto;
  --body del procediiento
  BEGIN
    fecha_inicio = now()::timestamp;
    nombre_proceso = 'etl_star_dim_producto';
    cantidad_registros = 0;
    contador_diferencias = 0;
    -- encontrar las diferencias
    open cursor_productos; 
    loop
      fetch cursor_productos into fila_producto;
      exit when not found;
      if(fila_producto.idw_producto <> -1) then 
        -- actualizando diferentes
        update star.dim_producto
        set
          id_producto      = fila_producto.id_producto      ,
          nombre_producto  = fila_producto.nombre_producto  ,
          precio_unitario  = fila_producto.precio_unitario  ,
          cantidad_unidad  = fila_producto.cantidad_unidad  ,
          id_categoria     = fila_producto.id_categoria     ,
          categoria        = fila_producto.categoria        ,
          id_proveedor     = fila_producto.id_proveedor     ,
          proveedor        = fila_producto.proveedor        ,
          ciudad_proveedor = fila_producto.ciudad_proveedor ,
          pais_proveedor   = fila_producto.pais_proveedor   ,
          region_proveedor = fila_producto.region_proveedor ,
          nombre_contacto  = fila_producto.nombre_contacto  
        where idw_producto = fila_producto.idw_producto;
        contador_diferencias = contador_diferencias + 1;
      end if;
    end loop; 
    close cursor_productos;
    -- cargar los nuevos
    insert into star.dim_producto(
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
     nombre_contacto ,
      fecha_inicio    ,
      fecha_fin       ,
      vigente
    )
    select  
     dp.id_producto      ,
     dp.nombre_producto  ,
     dp.precio_unitario  ,
     dp.cantidad_unidad  ,
     dp.id_categoria     ,
     dp.categoria        ,
     dp.id_proveedor     ,
     dp.proveedor        ,
     dp.ciudad_proveedor ,
     dp.pais_proveedor   ,
     coalesce(dp.region_proveedor , '-'),
     dp.nombre_contacto , 
     dp.fecha_inicio    ,
     dp.fecha_fin       ,
     dp.vigente
    from
    stage_star_dim_producto dp
    where dp.idw_producto = -1;
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
