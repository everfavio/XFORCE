
INSERT INTO STG_DIM_GEOGRAFIA VALUES ( -1, 500,'LA PAZ', 700, 'LA PAZ' ,'Nando' ) ;
INSERT INTO STG_DIM_GEOGRAFIA VALUES ( -1, 501,'EL ALTO', 700, 'LA PAZ' ,'Nando' ) ;

--SELECT * FROM STG_DIM_GEOGRAFIA
UPDATE STG_DIM_GEOGRAFIA
SET CIUDAD ='ARTIGA'
WHERE CIUDAD ='ARTIGAS';
COMMIT;


SELECT  idw_geografia, id_ciudad, ciudad, id_departamento,departamento,USER_DWH
FROM  STG_DIM_GEOGRAFIA
MINUS
SELECT  idw_geografia, id_ciudad, ciudad, id_departamento,departamento,USER_DWH
FROM STAR4.DIM_GEOGRAFIA
                   
                   
                   