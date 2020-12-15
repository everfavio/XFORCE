CREATE OR REPLACE PROCEDURE ETL_STG_DIM_CLIENTES IS

  -- VARIABLES GENERALES
--DECLARE 
  V_NOMBRE_PROCESO   VARCHAR2(30):= 'ETL_STG_DIM_CLIENTES';
  V_FEC_INICIO       DATE;
  V_FEC_FIN          DATE;
  V_COMENTARIO       VARCHAR2(255);
  V_CANT_REG         NUMBER(10)  := 0;
  V_CORRECTO         VARCHAR2(1) := 'N'; -- INDICADOR DE QUE SI EL PROCESO ESTA CORRECTO O NO
    -- VARIABLES DEL PROCESO

  v_total_diferencias    NUMBER(10) := 0;

BEGIN
  v_fec_inicio := SYSDATE;

  -- CODIGO DEL PROCESO

 
    EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_DIM_CLIENTES';
    
    INSERT INTO STG_DIM_CLIENTES (IDW_CLIENTES, ID_CLIENTE, NOMBRE, AP_PATERNO, AP_MATERNO, CI, ID_SUBRUBRO, SUBRUBRO, ID_RUBRO, RUBRO, ID_CANAL_SISTEMA, START_DATE, END_DATE, FLAG, USER_DW)
    
    SELECT NVL( (SELECT IDW_CLIENTES 
                  FROM STAR.DIM_CLIENTES
                    WHERE ID_CLIENTE  = SCR.ID_CLIENTE
                    AND ID_SUBRUBRO = SR.ID_SUBRUBRO
                    AND  ID_RUBRO  =RU.ID_RUBRO ) ,-1) IDW_CLIENTE
                    ,  SCR.ID_CLIENTE, 'AAAA' NOMBRE_CLIENTE
                    ,'AAAA' AP_PATERNO,
                    'AAAA' AP_MATERNO,
                    'AAAA' CI
                    ,SR.ID_SUBRUBRO
                    ,SR.NOM_SUBRUBRO
                    ,RU.ID_RUBRO
                    ,RU.NOM_RUBRO
                    , 1 ID_CANAL_SISTEMA
                    , SYSDATE START_DATE
                    , SYSDATE END_DATE
                    ,1 FLAG
                    , Sys_Context('USERENV','OS_USER') USER_DW      
    FROM STG_RUBROS RU
    ,STG_SUBRUBROS SR
    ,STG_CLIENTES_RUBROS SCR
    WHERE  RU.ID_RUBRO =SR.ID_RUBRO
    AND SR.ID_SUBRUBRO = SCR.ID_SUBRUBRO ;
     V_CANT_REG := SQL%ROWCOUNT;
    COMMIT;
    
 
    
    
  -- FIN CODIGO DEL PROCESO

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
