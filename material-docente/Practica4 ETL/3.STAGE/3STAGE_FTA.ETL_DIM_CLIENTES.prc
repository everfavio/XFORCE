CREATE OR REPLACE PROCEDURE ETL_DIM_CLIENTES IS

  -- VARIABLES GENERALES
--DECLARE 
  V_NOMBRE_PROCESO   VARCHAR2(30):= 'ETL_DIM_CLIENTES';
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

       
     
    FOR V_REG IN ( SELECT IDW_CLIENTES,ID_CLIENTE,NOMBRE,AP_PATERNO,AP_MATERNO
                   ,ID_SUBRUBRO,SUBRUBRO,ID_CANAL_SISTEMA
                    ,ID_RUBRO,RUBRO
                   FROM STG_DIM_CLIENTES
                   MINUS
                   SELECT IDW_CLIENTES,ID_CLIENTE,NOMBRE,AP_PATERNO,AP_MATERNO
                   ,ID_SUBRUBRO,SUBRUBRO,ID_CANAL_SISTEMA
                   ,ID_RUBRO,RUBRO
                   FROM STAR.DIM_CLIENTES)
LOOP
    
         IF V_REG.IDW_CLIENTES !='-1' THEN
    
            UPDATE  STAR.DIM_CLIENTES
            SET  ID_CLIENTE = V_REG.ID_CLIENTE
            ,NOMBRE = V_REG.NOMBRE
            ,AP_PATERNO = V_REG.AP_PATERNO
            ,AP_MATERNO = V_REG.AP_MATERNO
            ,SUBRUBRO = V_REG.SUBRUBRO
            ,ID_CANAL_SISTEMA= V_REG.ID_CANAL_SISTEMA
            ,ID_RUBRO= V_REG.ID_RUBRO
            ,RUBRO= V_REG.RUBRO
                   WHERE IDW_CLIENTES = V_REG.IDW_CLIENTES       ;

            COMMIT;
            V_TOTAL_DIFERENCIAS := V_TOTAL_DIFERENCIAS+1;
       END IF;
    
END LOOP ;



/************ SI NO EXISTE DIFERENCIAS SIGNIFICA QUE EXISTEN NUEVOS REGISTROS ***/
    INSERT /*+ NOLOGGING APPEND */ INTO STAR.DIM_CLIENTES (IDW_CLIENTES,ID_CLIENTE,NOMBRE,AP_PATERNO,AP_MATERNO,
                                        ID_SUBRUBRO,SUBRUBRO,
                                        ID_RUBRO,RUBRO,  ID_CANAL_SISTEMA, START_DATE, END_DATE, FLAG, USER_DW)
    SELECT SEQ_IDW_CLI.NEXTVAL IDW_CLIENTE,ID_CLIENTE,NOMBRE,AP_PATERNO,AP_MATERNO,
                                        ID_SUBRUBRO,SUBRUBRO
                                       ,ID_RUBRO,RUBRO,
                                        1 ID_CANAL_SISTEMA, SYSDATE START_DATE,SYSDATE END_DATE,1 FLAG,SYS_CONTEXT('ENV','OS_USER') USER_DW
    FROM STG_DIM_CLIENTES
    WHERE IDW_CLIENTES = -1;
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
