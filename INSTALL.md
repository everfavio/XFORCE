# Instalación del proyecto

### 1. Creación de esquemas

### 2. Otorgacion de permisos

### 3. Copia de estructuras

###  4. Creación del Logger

###  5. Llenado del stage
```sql

--ejecutar despues de los 0's


-- llamando copiers

select one_etl_stage_categories();
select one_etl_stage_customers();
select one_etl_stage_employees();
select one_etl_stage_orderdetails();
select one_etl_stage_orders();
select one_etl_stage_products();
select one_etl_stage_shippers();
select one_etl_stage_suppliers();
```
#### Llenado de las dims del stage
```sql
select two_etl_stage_dim_producto()
select two_etl_stage_dim_cliente();
select two_etl_stage_dim_empleado();
select two_etl_stage_dim_geografia();
select two_etl_stage_dim_producto();
select two_etl_stage_dim_repartidor();
select two_etl_stage_dim_tiempo();
```
#### Llenado de las dims de star
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
truncate  table log_de_procesos;

select * from star.dim_tiempo;
select * from star.dim_repartidor;
select * from star.dim_geografia;
select * from star.fact_orden;
select * from stage_star_dim_producto;
select * from stage_star_dim_geografia;
select * from stage_star_dim_empleado;
select * from stage_star_dim_cliente;
select * from stage_star_fact_orden;
select distinct shipcity, shipregion,shipcountry from stage_trans_orders;
select distinct shipcity, shipregion,shipcountry from public.orders;
select * from star.dim_cliente;
select * from star.dim_empleado('2020-01-01'::date, '2020-02-01'::date);
select * from star.fact_orden;
```

