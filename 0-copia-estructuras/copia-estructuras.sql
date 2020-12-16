-- SETEAMOS POR DEFECTO A stage
SET search_path TO stage;
ALTER database xforce_orders_online SET search_path TO stage;

-- copiamos de la base de datos transaccional

create table stage_trans_shippers as select * from public.shippers limit 0;
create table stage_trans_customers as select * from public.customers limit 0;
create table stage_trans_employees as select * from public.employees limit 0;
create table stage_trans_suppliers as select * from public.suppliers limit 0;
create table stage_trans_categories as select * from public.categories limit 0;
create table stage_trans_products as select * from public.products limit 0;
create table stage_trans_orders as select * from public.orders limit 0;
alter table stage_trans_orders add origen varchar default 'EN LINEA'; -- TIENDA
create table stage_trans_orderdetails as select * from public.orderdetails limit 0;

-- copiamos estructura del modelo estrella

create table stage_star_dim_cliente      as select * from star.dim_cliente   ;
create table stage_star_dim_empleado     as select * from star.dim_empleado  ;
create table stage_star_dim_geografia    as select * from star.dim_geografia ;
create table stage_star_dim_producto     as select * from star.dim_producto  ;
create table stage_star_dim_repartidor   as select * from star.dim_repartidor;
create table stage_star_dim_tiempo       as select * from star.dim_tiempo    ;
create table stage_star_fact_orden       as select * from star.fact_orden    ;



