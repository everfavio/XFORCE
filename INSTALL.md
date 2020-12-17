# Instalación del proyecto

Posicionarse en el psql cli nativo de postgresql 
### Creación de esquemas
!importante esto solo debe hacerse una vez
```sql
 \i 0-acreacion-schemas/creacion-stage-star.sql
 \i 0-acreacion-schemas/creacion-star.sql
```
### Otorgacion de permisos
! importante esto solo debe hacerse una vez
```sql
 \i 0-acreacion-schemas/grant-to-stage-from-star.sql
```
### Copia de estructuras 
[Opcional] hacer limpieza del stage.
```sql
 \i 0-copia-estructuras/limpia-stage.sql
 \i 0-copia-estructuras/copia-estructuras.sql
```
###  Creación del Logger
!importante si ya tiene el logueador creado no es necesario
```sql
 \i 0-copia-estructuras/creacion-logueador.sql
```

##  Llenado del stage con las fuentes originales
### creacion de los funciones para el volcado
```sql
 \i 1-etl-copia-tablas/etl-copia-categories.sql
 \i 1-etl-copia-tablas/etl-copia-customers.sql
 \i 1-etl-copia-tablas/etl-copia-employees.sql
 \i 1-etl-copia-tablas/etl-copia-orderdetails.sql
 \i 1-etl-copia-tablas/etl-copia-orders.sql
 \i 1-etl-copia-tablas/etl-copia-products.sql
 \i 1-etl-copia-tablas/etl-copia-shippers.sql
 \i 1-etl-copia-tablas/etl-copia-suppliers.sql
```
### Ejecucion de las funciones
```sql
select one_etl_stage_categories();
select one_etl_stage_customers();
select one_etl_stage_employees();
select one_etl_stage_orderdetails();
select one_etl_stage_orders();
select one_etl_stage_products();
select one_etl_stage_shippers();
select one_etl_stage_suppliers();
```
## Llenado de las dims del stage

### Creacion de las funciones de volcado

```sql
 \i 2-etl-cargado-stage-stage/etl-cargado-dim-cliente.sql
 \i 2-etl-cargado-stage-stage/etl-cargado-dim-empleado.sql
 \i 2-etl-cargado-stage-stage/etl-cargado-dim-geografia.sql
 \i 2-etl-cargado-stage-stage/etl-cargado-dim-producto.sql
 \i 2-etl-cargado-stage-stage/etl-cargado-dim-repartidor.sql
 \i 2-etl-cargado-stage-stage/etl-cargado-dim-tiempo.sql
 \i 2-etl-cargado-stage-stage/etl-cargado-fact_order.sql
```

### Llamada a las funciones 
```sql
select two_etl_stage_dim_producto();
select two_etl_stage_dim_cliente();
select two_etl_stage_dim_empleado();
select two_etl_stage_dim_geografia();
select two_etl_stage_dim_producto();
select two_etl_stage_dim_repartidor();
select two_etl_stage_dim_tiempo();
```

### Volcado de las dims en star
```sql
select three_etl_star_dim_cliente();
select three_etl_star_dim_empleado();
select three_etl_star_dim_geografia();
select three_etl_star_dim_producto();
select three_etl_star_dim_tiempo();
select three_etl_star_dim_repartidor();
```
#### llenado fact en stage
```sql
select two_etl_stage_fact_order('2020-01-01'::date, '2020-02-01'::date);
```
#### llenado fact star FINAL
```sql
select three_etl_fact_order('2020-01-01'::date, '2020-02-01'::date);
```

### verificaciones
```sql
select * from log_de_procesos;

select * from star.dim_tiempo;
select * from star.dim_repartidor;
select * from star.dim_geografia;
select * from star.fact_orden;
select * from stage_star_dim_producto;
select * from stage_star_dim_geografia;
select * from stage_star_dim_empleado;
select * from stage_star_dim_cliente;
select * from stage_star_fact_orden;
select * from star.dim_cliente;
select * from star.fact_orden;
```

