
/******  PARA OBTENER EL SCRIPT DE TABLAS DE GRANTS *******/
SELECT 'GRANT SELECT, INSERT, UPDATE ,DELETE ON '||TABLE_NAME || ' TO STAGE;'  FROM USER_TABLES


GRANT SELECT, INSERT, UPDATE ,DELETE ON AGG_VENTA TO STAGE;
GRANT SELECT, INSERT, UPDATE ,DELETE ON DIM_CLIENTES TO STAGE;
GRANT SELECT, INSERT, UPDATE ,DELETE ON DIM_GEOGRAFIA TO STAGE;
GRANT SELECT, INSERT, UPDATE ,DELETE ON DIM_PRODUCTOS TO STAGE;
GRANT SELECT, INSERT, UPDATE ,DELETE ON DIM_TIEMPO TO STAGE;
GRANT SELECT, INSERT, UPDATE ,DELETE ON FACT_VENTA TO STAGE;

ALTER TABLE DIM_CLIENTES MODIFY USER_DW VARCHAR2(50)