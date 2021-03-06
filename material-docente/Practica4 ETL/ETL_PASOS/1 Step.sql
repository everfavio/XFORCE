

/*** RUBROS***/
DROP TABLE STG_RUBROS;
/**CREAR  COPIA DE LA ESTRUCTURA */
CREATE TABLE STG_RUBROS
AS
SELECT * FROM DISTRIBUIDOR.RUBROS
WHERE ROWNUM <1


/********* ELIMINAR LOS DATOS PARA HACER LA CARGA ***/
TRUNCATE TABLE STG_RUBROS;
/*** CONSULTAR SI CARGO LOS DATOS ***/

SELECT * FROM STG_RUBROS

EXEC PKG_RUBROS;

/********* CREAMOS UN EJEMPLO DE UN PROCESO DE CARGA DE DATOS***/

CREATE OR REPLACE PROCEDURE PKG_RUBROS AS 
BEGIN

EXECUTE IMMEDIATE 'TRUNCATE TABLE STG_RUBROS';

INSERT /*+ NOLOGGING APPEND */  INTO STG_RUBROS
SELECT * FROM DISTRIBUIDOR.RUBROS;
COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;

END;


