CREATE OR REPLACE PROCEDURE ETL_DIM_PRODUCTOS IS

  -- VARIABLES GENERALES
--DECLARE
  V_NOMBRE_PROCESO   VARCHAR2(30):= 'ETL_DIM_PRODUCTOS';
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
    FOR V_REG IN ( SELECT IDW_PRODUCTOS,ID_PRESENTACION
                          ,PRESENTACION
                          ,TAMANIO
                          ,ID_PRODUCTO
                          ,PRODUCTO
                          ,FAMILIA
                          ,DURACION
                   FROM STG_DIM_PRODUCTOS
                   MINUS
                   SELECT IDW_PRODUCTOS,ID_PRESENTACION
                          ,PRESENTACION
                          ,TAMANIO
                          ,ID_PRODUCTO
                          ,PRODUCTO
                          ,FAMILIA
                          ,DURACION
                   FROM STAR.DIM_PRODUCTOS)
LOOP
    
        --- si encuentre el codigo en la dim , quiere decir que existe cambios en los campos
        -- si no encuentra el codigo quiere decir que es un nuevo registro que se debe insertar
         
    
      IF V_REG.IDW_PRODUCTOS !='-1' THEN
    
        UPDATE  STAR.DIM_PRODUCTOS
        SET   PRESENTACION = V_REG.PRESENTACION
             ,TAMANIO = V_REG.TAMANIO
             ,ID_PRODUCTO = V_REG.ID_PRODUCTO
             ,PRODUCTO = V_REG.PRODUCTO
             ,FAMILIA = V_REG.FAMILIA
             ,DURACION= V_REG.DURACION 
        WHERE   IDW_PRODUCTOS   = V_REG.IDW_PRODUCTOS;
             
        COMMIT;
   /************ SI NO EXISTE DIFERENCIAS SIGNIFICA QUE EXISTEN NUEVOS REGISTROS ***/

    V_TOTAL_DIFERENCIAS := V_TOTAL_DIFERENCIAS+1;
    END IF ;
COMMIT;

END LOOP ;

    INSERT INTO STAR.DIM_PRODUCTOS (IDW_PRODUCTOS
                          ,ID_PRESENTACION
                          ,PRESENTACION
                          ,TAMANIO
                          ,ID_PRODUCTO
                          ,PRODUCTO
                          ,FAMILIA
                          ,DURACION
                          ,START_DATE, END_DATE, FLAG, USER_DWH, ID_CANAL_SISTEMA
                         )
    SELECT  SEQ_IDW_PROD.NEXTVAL IDW_PRODUCTO
                          ,ID_PRESENTACION
                          ,PRESENTACION
                          ,TAMANIO
                          ,ID_PRODUCTO
                          ,PRODUCTO
                          ,FAMILIA
                          ,DURACION
                          , SYSDATE START_DATE, SYSDATE END_DATE, 1 FLAG, SYS_CONTEXT('ENV','OS_USER') USER_DWH
                          ,1 ID_CANAL_SISTEMA
    FROM STG_DIM_PRODUCTOS
    WHERE IDW_PRODUCTOS = -1 ;
  V_CANT_REG:= SQL%ROWCOUNT;
  
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
