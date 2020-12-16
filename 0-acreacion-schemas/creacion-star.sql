GRANT ALL ON SCHEMA star TO postgres;
SET search_path TO star;
-- SETEAMOS POR DEFECTO A star
ALTER database xforce_orders_online SET search_path TO star;



CREATE TABLE dim_cliente(
    idw_cliente        serial            NOT NULL,
    id_cliente         int4            NOT NULL,
    cliente            varchar(100)    NOT NULL,
    nombre_contacto    varchar(200)    NOT NULL,
    ciudad             varchar(200),
    region             varchar(100)    NOT NULL,
    pais               varchar(100)    NOT NULL,
    fecha_inicio       date            NOT NULL,
    fecha_fin          date,
    vigente            boolean         NOT NULL,
    CONSTRAINT "PK1_3" PRIMARY KEY (idw_cliente)
)
;

-- 
-- TABLE: dim_empleado 
--

CREATE TABLE dim_empleado(
    idw_empleado       serial            NOT NULL,
    id_empleado        int4            NOT NULL,
    nombre_completo    varchar(500)    NOT NULL,
    nombre_contacto    varchar(200)    NOT NULL,
    title              varchar(200),
    ciudad             varchar(150)    NOT NULL,
    region             varchar(100)    NOT NULL,
    pais               varchar(100)    NOT NULL,
    fecha_inicio       date            NOT NULL,
    fecha_fin          date,
    vigente            boolean         NOT NULL,
    CONSTRAINT "PK1_3_1" PRIMARY KEY (idw_empleado)
)
;



-- 
-- TABLE: dim_geografia 
--

CREATE TABLE dim_geografia(
    idw_geografia    serial            NOT NULL,
    ciudad           varchar(100)    NOT NULL,
    region           varchar(100)    NOT NULL,
    pais             varchar(100)    NOT NULL,
    fecha_inicio     date            NOT NULL,
    fecha_fin        date,
    vigente          boolean         NOT NULL,
    CONSTRAINT "PK1" PRIMARY KEY (idw_geografia)
)
;



-- 
-- TABLE: dim_producto 
--

CREATE TABLE dim_producto(
    idw_producto        serial              NOT NULL,
    id_producto         int4              NOT NULL,
    nombre_producto     varchar(100)      NOT NULL,
    precio_unitario     numeric(19, 2)    NOT NULL,
    cantidad_unidad     numeric(10, 0),
    id_categoria        int4              NOT NULL,
    categoria           varchar(100)      NOT NULL,
    id_proveedor        int4              NOT NULL,
    proveedor           varchar(180)      NOT NULL,
    ciudad_proveedor    varchar(100)      NOT NULL,
    pais_proveedor      varchar(100)      NOT NULL,
    region_proveedor    varchar(100)      NOT NULL,
    nombre_contacto     varchar(100),
    fecha_inicio        date              NOT NULL,
    fecha_fin           date,
    vigente             boolean           NOT NULL,
    CONSTRAINT "PK1_1" PRIMARY KEY (idw_producto)
)
;



-- 
-- TABLE: dim_repartidor 
--

CREATE TABLE dim_repartidor(
    idw_repartidor    serial            NOT NULL,
    id_repartidor     int4            NOT NULL,
    repartidor        varchar(200)    NOT NULL,
    ciudad            varchar(200),
    region            varchar(100)    NOT NULL,
    pais              varchar(100)    NOT NULL,
    fecha_inicio      date            NOT NULL,
    fecha_fin         date,
    vigente           boolean         NOT NULL,
    CONSTRAINT "PK1_3_2" PRIMARY KEY (idw_repartidor)
)
;



-- 
-- TABLE: dim_tiempo 
--

CREATE TABLE dim_tiempo(
    fecha              date       NOT NULL,
    gestion            int4       NOT NULL,
    mes                int4       NOT NULL,
    periodo            int4,
    semestre           int4,
    trimestre          int4       NOT NULL,
    quincena           int4       NOT NULL,
    bimestre           int4,
    dia_literal        varchar,
    mes_literal         varchar,
    fecha_inicio       date       NOT NULL,
    fecha_fin          date,
    vigente            boolean    NOT NULL,
    CONSTRAINT "PK1_2" PRIMARY KEY (fecha)
)
;



-- 
-- TABLE: fact_orden 
--

CREATE TABLE fact_orden(
    id_orden                 serial              NOT NULL,
    flete                    numeric(19, 2),
    ciudad_entrega           varchar(15),
    region_entrega           varchar(15),
    pais_entrega             varchar(100),
    importe_venta_total      numeric(16, 2)    NOT NULL,
    id_orden_detalle         int4,
    precio_unitario          numeric(16, 2)    NOT NULL,
    cantidad                 numeric(10, 2)    NOT NULL,
    descuento                numeric(5, 2),
    importe_venta_detalle    numeric(10, 0),
    idw_cliente              int4              NOT NULL,
    idw_empleado             int4              NOT NULL,
    idw_repartidor           int4              NOT NULL,
    idw_producto             int4              NOT NULL,
    idw_geografia            int4              NOT NULL,
    fecha_pedido         date              NOT NULL,
    fecha_entrega        date              NOT NULL,
    fecha_requerido      date              NOT NULL,
    origen                varchar(20) 
)
;



-- 
-- TABLE: fact_orden 
--

ALTER TABLE fact_orden ADD CONSTRAINT "Refdim_cliente6" 
    FOREIGN KEY (idw_cliente)
    REFERENCES dim_cliente(idw_cliente)
;

ALTER TABLE fact_orden ADD CONSTRAINT "Refdim_empleado7" 
    FOREIGN KEY (idw_empleado)
    REFERENCES dim_empleado(idw_empleado)
;

ALTER TABLE fact_orden ADD CONSTRAINT "Refdim_repartidor8" 
    FOREIGN KEY (idw_repartidor)
    REFERENCES dim_repartidor(idw_repartidor)
;

ALTER TABLE fact_orden ADD CONSTRAINT "Refdim_producto9" 
    FOREIGN KEY (idw_producto)
    REFERENCES dim_producto(idw_producto)
;

ALTER TABLE fact_orden ADD CONSTRAINT "Refdim_geografia10" 
    FOREIGN KEY (idw_geografia)
    REFERENCES dim_geografia(idw_geografia)
;

ALTER TABLE fact_orden ADD CONSTRAINT "Refdim_tiempo11" 
    FOREIGN KEY (fecha_pedido)
    REFERENCES dim_tiempo(idw_tiempo)
;

ALTER TABLE fact_orden ADD CONSTRAINT "Refdim_tiempo12" 
    FOREIGN KEY (fecha_requerido)
    REFERENCES dim_tiempo(idw_tiempo)
;

ALTER TABLE fact_orden ADD CONSTRAINT "Refdim_tiempo13" 
    FOREIGN KEY (fecha_entrega)
    REFERENCES dim_tiempo(idw_tiempo)
;


