-- SETEAMOS POR DEFECTO A stage
SET search_path TO stage;
ALTER database xforce_orders_online SET search_path TO stage;
-- creando la funcion

create or replace function two_etl_stage_dim_empleado()
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
    nombre_proceso = 'two_etl_stage_dim_empleado';
    cantidad_registros = 0;
    -- limpieza de suppliers
    truncate table  stage_star_dim_empleado;
    insert into stage_star_dim_empleado (
      idw_empleado      ,
      id_empleado       ,
      nombre_completo   ,
      nombre_contacto   ,
      title             ,
      ciudad            ,
      region            ,
      pais              ,
      fecha_inicio      ,
      fecha_fin         ,
      vigente
    )
    select
    coalesce(
      (select idw_empleado
      from star.dim_empleado
      where id_empleado = stp.employeeid
    ), -1 ) idw_empleado,
    stp.employeeid,
    CONCAT(stp.titleofcourtesy, ' ', stp.firstname, ' ', stp.lastname),
    stp.homephone,
    -- cast (stp.quantityperunit as integer) quantityperunit,
    stp.title,
    stp.city,
    stp.region,
    stp.country,
    now() fecha_inicio,
    now() fecha_fin,
    true vigente
    from
      stage_trans_employees stp;
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

-- select two_etl_stage_dim_empleado()
-- select * from stage_star_dim_empleado;
-- select * from log_de_procesos;
