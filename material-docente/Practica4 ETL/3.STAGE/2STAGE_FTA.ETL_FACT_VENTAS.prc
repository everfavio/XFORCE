CREATE OR REPLACE PROCEDURE STAGE.ETL_FACT_VENTAS (PI_FECHA_INICIAL VARCHAR2, PI_FECHA_FINAL VARCHAR2)  IS

  -- VARIABLES GENERALES
--DECLARE
  V_NOMBRE_PROCESO   VARCHAR2(30):= 'ETL_FACT_VENTAS';
  V_FEC_INICIO       DATE;
  V_FEC_FIN          DATE;
  V_COMENTARIO       VARCHAR2(255);
  V_CANT_REG         NUMBER(10)  := 0;
  V_CORRECTO         VARCHAR2(1) := 'N'; -- INDICADOR DE QUE SI EL PROCESO ESTA CORRECTO O NO

  -- VARIABLES DEL PROCESO
  V_FECHA_INICIO DATE;
  V_FECHA_FIN DATE;
  v_total_diferencias    NUMBER(10) := 0;

BEGIN
  v_fec_inicio := SYSDATE;
  
  V_FECHA_INICIO :=TO_DATE(PI_FECHA_INICIAL,'YYYYMMDD');
  V_FECHA_FIN    :=TO_DATE(PI_FECHA_FINAL,'YYYYMMDD');
  -- CODIGO DEL PROCESO

--   EXECUTE IMMEDIATE 'TRUNCATE TABLE  STAR.FACT_VENTA PARTITION(P20191019)  '
    DELETE FROM STAR.FACT_VENTA
    WHERE FECHA BETWEEN V_FECHA_INICIO AND V_FECHA_FIN;
    commit;
-- EXECUTE IMMEDIATE ('ALTER TABLE FACT_VENTAS TRUNCATE PARTITION P' || PI_FECHA_INICIAL ) ; 
    INSERT /*+ NOLOGGING APPEND*/ INTO STAR.FACT_VENTA (FECHA, IDW_CLIENTES, IDW_PRODUCTOS, IDW_GEOGRAFIA, PERIODO, IMPORTE, COSTO_VENTA, UNIDADES_VENTA, FECHA_CARGA, USER_DWH)
    SELECT FECHA, IDW_CLIENTES, IDW_PRODUCTOS, IDW_GEOGRAFIA, PERIODO, IMPORTE, COSTO_VENTA, UNIDADES_VENTA, FECHA_CARGA, USER_DWH
    FROM STAGE.STG_FACT_VENTA;
    
    V_CANT_REG:= SQL%ROWCOUNT;
    COMMIT;
    
  v_fec_fin    := SYSDATE;
  v_comentario := 'EL PROCESO '||v_nombre_proceso||' CULMINO SATISFACTORIAMENTE ';
  v_correcto   := 'S';

  P_Insertar_Info_Proc(v_nombre_proceso,
                       v_fec_inicio,
                       v_fec_fin,
                       v_comentario,
                       v_cant_reg,
                       v_correcto )
                       ;
  COMMIT;

EXCEPTION
   WHEN OTHERS THEN
     v_fec_fin    := SYSDATE;
     v_comentario :=  ('ERROR AL ACTUALIZAR '||v_nombre_proceso||' '||SQLCODE||' '||SQLERRM);
     P_Insertar_Info_Proc(v_nombre_proceso,
                          v_fec_inicio,
                          v_fec_fin,
                          v_comentario,
                          v_cant_reg,
                          v_correcto )
                          ;
     COMMIT  ;



END;
/
