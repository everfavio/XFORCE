[<-volver al índice](../README.md#indice)
# 8. Base de Datos

Una base de datos es un conjunto de datos pertenecientes a un mismo contexto y almacenados sistemáticamente para su uso posterior. En este sentido; una biblioteca puede considerar una base de datos compuesta en su mayoría por documentos y textos impresos en papel e indexados para su consulta. Actualmente, y debido al desarrollo tecnológico de campos como la informática y la electrónica, la mayoría de las bases de datos están en formato digital, siendo este un componente electrónico, por tanto se ha desarrollado y se ofrece un amplio rango de soluciones al problema del almacenamiento de datos.

Hay programas denominados sistemas gestores de bases de datos, abreviado SGBD (del inglés Database Management System o DBMS), que permiten almacenar y posteriormente acceder a los datos de forma rápida y estructurada. Las propiedades de estos DBMS, así como su utilización y administración, se estudian dentro del ámbito de la informática.

Inicialmente se tiene una base de datos que será el sujeto de estudio, se eligieron PostgreSQL y ORACLE como DBMS.

![](img/orders_db.PNG)

### Esquemas
Los esquemas definidos para las operaciones son:

PostgreSQL:
  - Public: Esquema donde se encuentran definidas las tablas transaccionales
  - Stage: Esquema donde se encuentran definidas las tablas de conversión al esqueman star
  - Star: Esquema que contiene las tablas dimensionales y de hechos que almacenan toda la información procesada resultantes.

Oracle:
  - Ventas: Esquema donde se encuentran definidas las tablas transaccionales
  - Stage: Esquema donde se encuentran definidas las tablas de conversión al esqueman star
  - Star: Esquema que contiene las tablas dimensionales y de hechos que almacenan toda la información procesada

### Tablas
a parte de las tablas definidas para el proceso de ETL se utilizará una única tabla de Auditoria, para el registro de eventos generados cada ves que se realize el proceso de migración.

- [Tablas del esquema Public/ventas](./9.1-schema-public.md)
- [Tablas del esquema Stage](./9.1-schema-public.md)
- [Tablas del esquema Star](./9.1-schema-public.md)

[<-volver al índice](../README.md#indice)