
/* COPIAMOS LA ESTRUCTURA ***/

DROP TABLE STG_PRODUCTOS

CREATE TABLE STG_PRODUCTOS
AS
SELECT * FROM DISTRIBUIDOR.PRODUCTOS
WHERE ROWNUM <1 

CREATE OR REPLACE PROCEDURE  PKG_EJEMPLOS_PRODUCTOS

AS

BEGIN 

TRUNCATE TABLE STG_PRODUCTOS;

INSERT INTO STG_PRODUCTOS --  DESTINO 
SELECT * FROM  DISTRIBUIDOR.PRODUCTOS ;-- ORIGEN
COMMIT;

EXCEPTION 
WHEN OTHERS NULL;


END;


/*** QUERY DA LA CONEXION DEL USUARIO *******/
select Sys_Context('USERENV','OS_USER') from dual

TRUNCATE TABLE STG_PRODUCTOS;
EXEC PKG_EJEMPLOS_PRODUCTOS;
select * from dual


INSERT INTO  STG_DIM_GEOGRAFIA(IDW_GEOGRAFIA, ID_CIUDAD, CIUDAD, ID_DEPARTAMENTO, DEPARTAMENTO,USER_DWH)
SELECT NVL((SELECT  A.IDW_GEOGRAFIA  IDW_GEOGRAFIA
            FROM STAR4.DIM_GEOGRAFIA A
            WHERE  A.id_ciudad = C.ID_CIUDAD
            AND  A.id_departamento = D.ID_DEPTO),-1) AS IDW_GEOGRAFIA
 , C.ID_CIUDAD, C.NOM_CIUDAD, D.ID_DEPTO, D.NOM_DEPTO ,Sys_Context('USERENV','OS_USER')
    FROM STG_CIUDADES C
    ,STG_DEPARTAMENTO D
    WHERE  C.ID_DEPTO =D.ID_DEPTO;
    COMMIT;
    


SELECT COUNT(1) FROM STG_PRODUCTOS -- DESTINO
 
SELECT COUNT(1) FROM DISTRIBUIDOR.PRODUCTOS --ORIGEN



