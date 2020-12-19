### Base de Datos
Inicialmente se tiene una base de datos que será el sujeto de estudio, se eligieron PostgreSQL y ORACLE como SGBD.

#### Esquemas
Los esquemas definidos para las operaciones son:

PostgreSQL:
  - Public: Esquema donde se encuentran definidas las tablas transaccionales
  - Stage: Esquema donde se encuentran definidas las tablas de conversión al esqueman star
  - Star: Esquema que contiene las tablas dimensionales y de hechos que almacenan toda la información procesada resultantes.

Oracle:
  - Ventas: Esquema donde se encuentran definidas las tablas transaccionales
  - Stage: Esquema donde se encuentran definidas las tablas de conversión al esqueman star
  - Star: Esquema que contiene las tablas dimensionales y de hechos que almacenan toda la información procesada

#### Tablas
a parte de las tablas definidas para el proceso de ETL se utilizará una única tabla de Auditoria, para el registro de eventos generados cada ves que se realize el proceso de migración.

- [Tablas del esquema Public/ventas]()
- [Tablas del esquema Stage]()
- [Tablas del esquema Star]()
