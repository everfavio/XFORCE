-- SETEAMOS POR DEFECTO A stage
SET search_path TO stage;
ALTER database xforce_orders_online SET search_path TO stage;
-- creando la funcion
create or replace function two_etl_stage_dim_tiempo()
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
  declare fecha_max date;
    declare fecha_min date;
    declare contador integer;
    declare cantidad_dias integer;
    declare fecha_actual date;
  --body del procediiento
  BEGIN
    fecha_inicio = now()::timestamp;
    nombre_proceso = 'two_etl_stage_dim_tiempo';
    cantidad_registros = 0;
    contador = 0;
    -- limpieza de tiempo
    truncate table  stage_star_dim_tiempo;
    -- buscando los maximos y minimos 
    select min(orderdate) fecha_min, max(shippeddate) fecha_max, 
    (max(shippeddate) - min(orderdate)) + 15 cantidad_dias
    into  fecha_min,fecha_max, cantidad_dias
    from stage.stage_trans_orders;
    fecha_actual = fecha_min;
    loop
      if contador >= cantidad_dias then 
        exit;
      end if;
      contador = contador + 1;
      insert into stage_star_dim_tiempo (
        fecha        ,
        gestion      ,
        mes          ,
        periodo      ,
        semestre     ,
        trimestre    ,
        quincena     ,
        bimestre     ,
        dia_literal  ,
        mes_literal  ,
        fecha_inicio ,
        fecha_fin    ,
        vigente     
      ) 
      select 
      coalesce(
      (select fecha
      from star.dim_tiempo
      where fecha = fecha_actual::date 
      ), fecha_actual ) fecha,
      extract (YEAR FROM fecha_actual),
      extract (MONTH FROM fecha_actual),
      extract (MONTH FROM fecha_actual),
      1 semestre,
      extract (QUARTER FROM fecha_actual),
      1 quincena,
      1 bimestre,
      to_char(fecha_actual, 'Day'),
      to_char(fecha_actual, 'Month'),
      now(),
      now(),
      true vigente;
      fecha_actual = fecha_min + interval '1' day * contador;
    end loop; 
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

-- select two_etl_stage_dim_tiempo()
-- select * from stage_star_dim_tiempo;
-- select * from log_de_procesos;
