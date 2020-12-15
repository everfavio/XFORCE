CREATE OR REPLACE PROCEDURE ETL_DIM_TIEMPO IS

  -- VARIABLES GENERALES
--DECLARE
  V_NOMBRE_PROCESO   VARCHAR2(30):= 'ETL_DIM_TIEMPO';
  V_FEC_INICIO       DATE;
  V_FEC_FIN          DATE;
  V_COMENTARIO 	   	 VARCHAR2(255);
  V_CANT_REG         NUMBER(10)  := 0;
  V_CORRECTO         VARCHAR2(1) := 'N'; -- INDICADOR DE QUE SI EL PROCESO ESTA CORRECTO O NO
    -- VARIABLES DEL PROCESO

  v_total_diferencias	 NUMBER(10) := 0;

BEGIN
  v_fec_inicio := SYSDATE;

  -- CODIGO DEL PROCESO

	
--	EXECUTE IMMEDIATE 'TRUNCATE TABLE ETL_DIM_TIEMPO';
    INSERT /*+ NOLOGGING APPEND */ INTO STAR.DIM_TIEMPO (FECHA, DIA, DIA_SEMANA_CORTO, DIA_SEMANA, DIA_LABORAL, DIA_FERIADO, SEMANA_MES, SEMANA_ANIO, MES, MES_CADENA, PERIODO, TRIMESTRE, SEMESTRE, ANIO)
    SELECT FECHA, DIA, DIA_SEMANA_CORTO, DIA_SEMANA, DIA_LABORAL, DIA_FERIADO, SEMANA_MES, SEMANA_ANIO, MES, MES_CADENA, PERIODO, TRIMESTRE, SEMESTRE, ANIO
    FROM STG_DIM_TIEMPO;

    V_CANT_REG:= SQL%ROWCOUNT;
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
     COMMIT	 ;



END;
