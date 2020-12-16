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

select two_etl_stage_dim_producto()
select two_etl_stage_dim_cliente();
select two_etl_stage_dim_empleado();
select two_etl_stage_dim_geografia();
select two_etl_stage_dim_producto();
select two_etl_stage_dim_repartidor();
select two_etl_stage_dim_tiempo();
select two_etl_stage_fact_order('2020-01-01'::date, '2020-02-01'::date);

select three_etl_star_dim_cliente();
select three_etl_star_dim_empleado();
select three_etl_star_dim_geografia();




select * from log_de_procesos;
truncate  table log_de_procesos;


select * from stage_star_dim_producto;
select * from stage_star_dim_geografia;
select * from stage_star_dim_empleado;
select * from stage_star_dim_cliente;
select * from stage_star_dim_cliente;
select * from star.dim_cliente;
select * from star.dim_empleado;


