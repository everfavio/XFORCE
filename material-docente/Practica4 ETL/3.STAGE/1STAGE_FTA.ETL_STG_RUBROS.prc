CREATE OR REPLACE PROCEDURE ETL_STG_RUBROS IS

  -- VARIABLES GENERALES
--DECLARE 
  V_NOMBRE_PROCESO   VARCHAR2(30):= 'ETL_STG_RUBROS';
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

	
	EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_RUBROS';
    INSERT /*+ NOLOGGING APPEND */  INTO STG_RUBROS (ID_RUBRO,NOM_RUBRO)
    SELECT ID_RUBRO,NOM_RUBRO FROM distribuidor.RUBROS;
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
