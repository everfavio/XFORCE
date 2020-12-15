-- SETEAMOS POR DEFECTO A stage
SET search_path TO stage;
ALTER database xforce_orders_online SET search_path TO stage;

CREATE TABLE  log_de_procesos
    (nombre_proceso VARCHAR(50),
     fec_inicio timestamp,
     fec_fin timestamp,
     comentario VARCHAR(500),
     cantidad_registros int4,
     correcto boolean);

create or replace function log_procesos(
  nombre_proceso varchar,
  comentario varchar,
  cantidad_registros integer,
  correcto boolean,
	fec_inicio timestamp,
     fec_fin timestamp
)
returns boolean
as $$
begin
    insert into stage.log_de_procesos(nombre_proceso,comentario,cantidad_registros,correcto,fec_inicio,fec_fin) values(
      nombre_proceso,
      comentario,
      cantidad_registros,
      correcto,
			fec_inicio,
			fec_fin
      );
  return true;
  END;
$$ language plpgsql;
