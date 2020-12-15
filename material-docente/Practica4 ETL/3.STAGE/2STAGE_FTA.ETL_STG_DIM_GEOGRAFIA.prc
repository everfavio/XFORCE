CREATE OR REPLACE PROCEDURE ETL_STG_DIM_GEOGRAFIA IS

  -- VARIABLES GENERALES
--DECLARE 
  V_NOMBRE_PROCESO   VARCHAR2(30):= 'ETL_STG_DIM_GEOGRAFIA';
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

    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_DIM_GEOGRAFIA';
    
         
 INSERT INTO  STG_DIM_GEOGRAFIA(IDW_GEOGRAFIA, ID_CIUDAD, CIUDAD, ID_DEPARTAMENTO, DEPARTAMENTO,USER_DWH)
SELECT NVL((SELECT  A.IDW_GEOGRAFIA  IDW_GEOGRAFIA
            FROM STAR4.DIM_GEOGRAFIA A
            WHERE  A.id_ciudad = C.ID_CIUDAD
            AND  A.id_departamento = D.ID_DEPTO),-1) AS IDW_GEOGRAFIA
 , C.ID_CIUDAD, C.NOM_CIUDAD, D.ID_DEPTO, D.NOM_DEPTO ,Sys_Context('USERENV','OS_USER')
    FROM STG_CIUDADES C
    ,STG_DEPARTAMENTO D
    WHERE  C.ID_DEPTO =D.ID_DEPTO;
       
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
