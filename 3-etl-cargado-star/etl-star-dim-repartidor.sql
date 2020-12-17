-- SETEAMOS POR DEFECTO A stage
SET search_path TO stage;
ALTER database xforce_orders_online SET search_path TO stage;
-- creando la funcion
create or replace function three_etl_star_dim_repartidor()
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
  declare fila_repartidor record;
  declare  cursor_repartidors cursor for
    select
      idw_repartidor  ,
      id_repartidor   ,
      repartidor      ,
      ciudad          ,
      region          ,
      pais
    from stage_star_dim_repartidor
    except
    select
      idw_repartidor  ,
      id_repartidor   ,
      repartidor      ,
      ciudad          ,
      region          ,
      pais
    from star.dim_repartidor;
  --body del procediiento
  BEGIN
    fecha_inicio = now()::timestamp;
    nombre_proceso = 'etl_star_dim_repartidor';
    cantidad_registros = 0;
    contador_diferencias = 0;
    -- encontrar las diferencias
    open cursor_repartidors;
    loop
      fetch cursor_repartidors into fila_repartidor;
      exit when not found;
      if(fila_repartidor.idw_repartidor <> -1) then
        -- actualizando diferentes
        update star.dim_repartidor
        set
          id_repartidor = fila_repartidor.id_repartidor   ,
          repartidor    = fila_repartidor.repartidor      ,
          ciudad        = fila_repartidor.ciudad          ,
          region        = fila_repartidor.region          ,
          pais          = fila_repartidor.pais
        where idw_repartidor = fila_repartidor.idw_repartidor;
        contador_diferencias = contador_diferencias + 1;
      end if;
    end loop;
    close cursor_repartidors;
    -- cargar los nuevos
    insert into star.dim_repartidor(
      id_repartidor   ,
      repartidor      ,
      ciudad          ,
      region          ,
      pais            ,
      fecha_inicio    ,
      fecha_fin       ,
      vigente
    )
    select
      dr.id_repartidor   ,
      dr.repartidor      ,
      dr.ciudad          ,
      coalesce(dr.region, '-'),
      dr.pais            ,
      dr.fecha_inicio    ,
      dr.fecha_fin       ,
      dr.vigente
    from
    stage_star_dim_repartidor dr
    where dr.idw_repartidor = -1;
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
