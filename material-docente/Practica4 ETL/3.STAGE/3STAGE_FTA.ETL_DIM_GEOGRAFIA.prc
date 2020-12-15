CREATE OR REPLACE PROCEDURE ETL_DIM_GEOGRAFIA IS

  -- VARIABLES GENERALES
--DECLARE 
  V_NOMBRE_PROCESO   VARCHAR2(30):= 'ETL_DIM_GEOGRAFIA';
  V_FEC_INICIO       DATE;
  V_FEC_FIN          DATE;
  V_COMENTARIO       VARCHAR2(255);
  V_CANT_REG         NUMBER(10)  := 0;
  V_CORRECTO         VARCHAR2(1) := 'N'; -- INDICADOR DE QUE SI EL PROCESO ESTA CORRECTO O NO
  V_VFILENAME        VARCHAR2(30);
  V_FONO_SMS         VARCHAR2(10) := 'XXXXX';

  -- VARIABLES DEL PROCESO

  v_total_diferencias    NUMBER(10) := 0;

BEGIN
  v_fec_inicio := SYSDATE;

  -- CODIGO DEL PROCESO

  
    FOR V_REG IN ( SELECT  idw_geografia, id_ciudad, ciudad, id_departamento,departamento,USER_DWH
                   FROM  STG_DIM_GEOGRAFIA
                   MINUS
                   SELECT  idw_geografia, id_ciudad, ciudad, id_departamento,departamento,USER_DWH
                   FROM STAR.DIM_GEOGRAFIA)
LOOP
    
    
      IF V_REG.IDW_GEOGRAFIA !='-1' THEN
    
        UPDATE  STAR.DIM_GEOGRAFIA
        SET  ID_DEPARTAMENTO = V_REG.ID_DEPARTAMENTO
            ,DEPARTAMENTO = V_REG.DEPARTAMENTO
            ,ID_CIUDAD = V_REG.ID_CIUDAD
            ,CIUDAD = V_REG.CIUDAD
            ,USER_DWH =V_REG.USER_DWH
          WHERE IDW_GEOGRAFIA = V_REG.IDW_GEOGRAFIA ;
        COMMIT;
    V_TOTAL_DIFERENCIAS := V_TOTAL_DIFERENCIAS+1;
    END IF ;

END LOOP ;

    INSERT INTO STAR.DIM_GEOGRAFIA (idw_geografia, id_ciudad, ciudad, id_departamento,departamento
    ,USER_DWH)
    SELECT SEQ_IDW_GEO.NEXTVAL idw_geografia, id_ciudad, ciudad, id_departamento,departamento,USER_DWH 
    FROM STG_DIM_GEOGRAFIA
    WHERE IDW_GEOGRAFIA = -1;
    V_CANT_REG := SQL%ROWCOUNT;
    
    COMMIT;

    
  -- FIN CODIGO DEL PROCESO

  v_fec_fin    := SYSDATE;
  v_comentario := 'EL PROCESO '||v_nombre_proceso||' ESTA OK ACTUALIZADOS :'||V_TOTAL_DIFERENCIAS ||' NUEVOS : ' ||V_CANT_REG;
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
