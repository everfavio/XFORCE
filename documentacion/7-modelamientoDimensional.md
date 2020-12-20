
# 7. Modelamiento Dimensional

Modelado dimensional (DM en inglés) nombra un conjunto de técnicas y conceptos utilizados en el diseño de almacenes de datos. Se considera que es diferente del Modelo entidad-relación. El modelado de dimensiones no implica necesariamente una base de datos relacional, el mismo enfoque de modelado, a nivel lógico, se puede utilizar para cualquier forma física, tal como archivos de base de datos multidimensional o planas. Según el consultor de almacenamiento de datos Ralph Kimball, 1 el modelado dimensional es una técnica de diseño de bases de datos destinadas a apoyar a las consultas de los usuarios finales en un almacén de datos. Se orienta en torno a la comprensibilidad y rendimiento. Según él, aunque el modelo entidad relacional orientado a transacciones es muy útil para la captura de transacción, se debe evitar en la entrega al usuario final.

El modelado dimensional siempre utiliza los conceptos de hechos (medidas) y dimensiones (contexto). Los hechos son normalmente (pero no siempre) los valores numéricos que se pueden agregar, y las dimensiones son grupos de jerarquías y descriptores que definen los hechos. Por ejemplo, la cantidad de ventas es un hecho; marca de tiempo, producto, NoRegistro, NoTienda, etc., son elementos de dimensiones. Los modelos dimensionales son construidos por el área de proceso de negocio, por ejemplo, las ventas en tiendas, inventarios, reclamaciones, etc. Debido a que las diferentes áreas de proceso de negocio comparten algunas pero no todas las dimensiones, la eficiencia en el diseño , la operación y la coherencia, se logra usando tablas de dimensión, es decir, usando una copia de la dimensión compartida. El término "tablas de dimensión" se originó por Ralph Kimball.

#### Modelos dimensionales identificados:

Para el caso analizado se observan las siguientes dimensiones, hechos:
- dim_tiempo : Dimension tiempo contiene lo referido a las diferentes variantes de tiempo en todos sus casos posibles.

- dim_cliente : Dimension cliente, especifica los datos de los potenciales clientes y sus atributos propios que los identifica en el ambito de estudio.

- dim_empleado : Dimension empleado, muestra las caracteristicas propias de los empleados en el sector a desempeñarse.

- dim repartidor : Dimension repartidor, provee el detalle de distribución mediante entes ya sean granulares o de mayor capacidad, para con los productos.

- dim_geografia : Dimension geografia, especifica los puntos geograficos sobre los que interactuan las demas dimensiones.

- dim_producto : Dimension producto, señala la caraterización propia de los distintos y variados productos dentro el sistema mismo.

- fact_orden : Tabla de hechos, la transaccional donde se reflejan los movimientos e interacciones entre las diferentes dimensiones, proveyendo las ordenes realizadas de los clientes sobre los diferentes productos, incluyendo su forma de distribucion.



![](img/start.png)
