-- SETEAMOS POR DEFECTO A stage
SET search_path TO stage;
ALTER database xforce_orders_online SET search_path TO stage;

drop table stage_trans_shippers ;
drop table stage_trans_customers;
drop table stage_trans_employees;
drop table stage_trans_suppliers;
drop table stage_trans_categories;
drop table stage_trans_products ;
drop table stage_trans_orders ;
drop table stage_trans_orderdetails;

-- copiamos estructura del modelo estrella

drop table stage_star_dim_cliente     ;
drop table stage_star_dim_empleado    ;
drop table stage_star_dim_geografia   ;
drop table stage_star_dim_producto    ;
drop table stage_star_dim_repartidor  ;
drop table stage_star_dim_tiempo      ;
drop table stage_star_fact_orden      ;
