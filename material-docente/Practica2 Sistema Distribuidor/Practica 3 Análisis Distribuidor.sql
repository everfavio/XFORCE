

/* 1. Se desea hacer un seguimiento de las ventas. Esto nos indica las regiones que están en riesgo y necesitan de mayor atención. */

select c.nom_ciudad, sum(importe_venta) importe_venta, sum(costo_venta) ,  (sum(importe_venta)- sum(costo_venta)) margen 
from venta v, ciudades c
where v.id_ciudad = c.id_ciudad
group by c.nom_ciudad
order by importe_venta asc

/* 2. Disminución de los costos.
Se necesita comparar las diferencias entre importes de ventas y costos, de manera de maximizar las ganancias. */

/* Asumiendo que las ventas negativas son devoluciones o son inconsistencias se filtran del análisis de Margen */

SELECT *
FROM venta v 
where importe_venta <0

/* Análisis de Margen  por presentación.*/

select p.nom_presentacion, sum(importe_venta) importe_venta, sum(costo_venta)  costo_venta,  (sum(importe_venta)- sum(costo_venta)) margen , (SUM(importe_venta - costo_venta)/SUM(importe_venta))  Margenpct
from venta v, presentaciones p
where v.id_presentacion = p.id_presentacion
and importe_venta >0
group by p.nom_presentacion
order by importe_venta asc

/*Análisis de Margen  en detalle, se compara el margen promedio con el margen y se filtra aquellos que tienen un 20 % menos del promedio*/

SELECT A.*,((importe_venta - costo_venta)/importe_venta)  Margenpct,t.*,p.NOM_PRESENTACION 
FROM VENTA A, presentaciones p,
   
(SELECT ID_PRESENTACION, AVG(Margenpct) avgMargenpct
FROM (
    SELECT ((importe_venta - costo_venta)/importe_venta)  Margenpct,v.* 
    FROM venta v 
    where importe_venta >0
    )  
  GROUP BY ID_PRESENTACION ) T
WHERE a.id_presentacion = T.id_presentacion
and a.id_presentacion = p.id_presentacion
and (((a.importe_venta - a.costo_venta)/a.importe_venta) - avgMargenpct)/((a.importe_venta - a.costo_venta)/a.importe_venta) >=.10
and importe_venta >0


/*3. Se quiere analizar el stock existente de productos. ¿ Cuánto tiempo alcanzaría el stock?. */

select * 
from stock
WHERE id_presentacion = 630101

/******* Paso 1 , stocks por fecha y presentacion */ 
select fecha,id_presentacion,count(1),sum(stock_unidades) from stock
group by fecha,id_presentacion
order by 1
/******* Paso 2 , Ventas por fecha y presentacion */ 
select trunc(fecha,'mm') ,id_presentacion, count(1),sum(unidades_venta) 
from venta v
where  importe_venta >0
group by trunc(fecha,'mm'),id_presentacion
order by 1





/******* Paso 1 y  2  */ 

select a.fecha,a.id_presentacion , stock_unidades , unidades_venta , stock_unidades - unidades_venta  as  diferencia
from (select fecha,id_presentacion,count(1),sum(stock_unidades)stock_unidades  from stock
group by fecha,id_presentacion
) a
, (select trunc(fecha,'mm') fecha ,id_presentacion, count(1),sum(unidades_venta) unidades_venta 
    from venta v
    where v.importe_venta >0
    group by trunc(fecha,'mm') ,id_presentacion 
  ) b
where a.id_presentacion = b.id_presentacion
and a.fecha =b.fecha 
and (stock_unidades - unidades_venta)  <0

--order by 1

/***** Análisis sumando el total de stocks por mes , de anteriores meses ***/
select a.* ,
 (select sum(stock_unidades) 
                                                                          from  stock s
                                                                          where s.id_presentacion =a.id_presentacion
                                                                          and s.fecha < = a.fecha
                                                                        ) stock_unidades ,
                                                                        
                                                                        (select sum(stock_unidades) 
                                                                          from  stock s
                                                                          where s.id_presentacion =a.id_presentacion
                                                                          and s.fecha < = a.fecha
                                                                        ) - unidades_venta as diferencia
                                                                        
from (select trunc(fecha,'mm') fecha ,id_presentacion, sum(unidades_venta) unidades_venta
    from venta v
    where  importe_venta >0
    group by trunc(fecha,'mm'),id_presentacion       
     )  a                                                                
     
order by 1


/*4. Análisis de mercado.
Interesa medir los volúmenes de venta para los diferentes rubros (mayoristas, supermercados, almacenes y restaurantes) estudiando las variaciones para los distintos períodos.
 */


select to_char(fecha,'YYYYMM') PERIODO,NOM_RUBRO,NOM_SUBRUBRO, sum(importe_venta) importe_venta, sum(costo_venta) costo_venta,  (sum(importe_venta)- sum(costo_venta)) margen 
,round((SUM(importe_venta - costo_venta)/SUM(importe_venta)),2)  Margenpct
from venta v
, clientes_rubros c, subrubros sb , rubros r
where v.id_cliente = c.id_cliente
and c.id_subrubro = sb.id_subrubro
and sb.id_rubro = r.id_rubro
group by  NOM_RUBRO,NOM_SUBRUBRO ,to_char(fecha,'YYYYMM')
ORDER BY 1
