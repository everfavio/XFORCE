select p.nombre_producto,o.ciudad_entrega, o.region_entrega, o.pais_entrega,p.categoria, c.cliente,e.nombre_completo ,
o.fecha_pedido,
t.mes_literal mes_literal_pedido,
t.gestion gestion_pedido,
o.fecha_requerido,
t2.mes_literal mes_literal_requerido,
t2.gestion gestion_requerido,
o.fecha_entrega, 
t3.mes_literal mes_literal_entrega,
t3.gestion gestion_entrega,
o.importe_venta_detalle, o.cantidad 
from 
star.fact_orden o
inner join star.dim_producto p on p.idw_producto = o.idw_producto
inner join star.dim_geografia g on g.idw_geografia = o.idw_geografia
inner join star.dim_tiempo t on t.fecha = o.fecha_pedido
inner join star.dim_tiempo t2 on t2.fecha = o.fecha_requerido
inner join star.dim_tiempo t3 on t3.fecha = o.fecha_entrega
inner join star.dim_cliente c on c.idw_cliente = o.idw_cliente
inner join star.dim_empleado e  on e.idw_empleado = o.idw_empleado



\d star.dim_producto
\d star.fact_orden
\d star.dim_cliente
\d star.dim_empleado


