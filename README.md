![](img/img1.jpg)
# X-FORCE
### PROYECTO FINAL (Business Intelligence/ Data Warehouse )
### Resumen
Los almacenes de datos cada dia adquieren mayor importancia, a medida que las orga- nizaciones pasan de esquemas de solo recolección de datos a esquemas de análisis de los mismos. Sin embargo a pesar de la gran difusión de los conceptos relacionados con los almacenes de datos, no existe demasiada información disponible en castellano en cuanto a las metodologías para implementarlos. En este breve artículo intentaremos brindar una explicación general de una de las metodologías más usadas, la metodología de Kimball.

### 1. Introducción 
Un almacen de datos es considerado como una colección de datos orientada a un determiando ámbito, integrado, no volátil, y variable en el tiempo, que ayuda. Se trata, sobre todo, de un historial completo de la organización más allá de la información transaccional y operacional, almacenado en una base de datos diseñada para favorecer el análisis y la divulgación eficiente de datos. Por otra parte Kimball la define como "una copia de los datos transaccionales estructurados especificamente para consultas y análisis". Actualmente uno de los mayores impedimentos para contruir este tipo de almacenes de datos es la falta de conocimiento de metodologías adecuadas para su implementación y la disciplina para cumplirlas.

### 2. Metodologias Actuales
Entre la mayoría dos metodologías, la de Kimball y la de Inmon son las mas utlizadas desde  el punto de vista arquitectónico, la mayor diferencia entre los dos autores es el sentido de la construcción del DW, esto es comenzando por los Data marts o ascendente (Bottom-up, Kimball) o comenzando con todo el DW desde el principio, o descendente (TopDown, Inmon).
Por otra parte, la metodología de Inmon se basa en conceptos bien conocidos del diseño de bases de datos relacionales a metodología para la construcción de un sistema de este tipo es la habitual para construir un sistema de información, utilizando las herramientas habituales, al contrario de la de Kimball, que se basa en un modelado dimensional (no normalizado)

### 3. Metodología Adoptada
La metodología adoptada es la de Kimball, por ser la ideal a la practica de negocios planteada de tal forma se plantea un enfoque de mayor a menor, muy versatil y las herramientas necesarias que ayudan a la implementación de un ***Data Warehouse*** , acorde a la implementación de datamarts e integrandolos en un almacen de datos.

### 4. Metodología de Ralph Kimball 
La metodología se basa en lo que Kimball denomina Ciclo de Vida Dimensional del Negocio (Business Dimensional Lifecycle). Este ciclo de vida del proyecto de DW, está basado en cuatro principios básicos:

- Centrarse en el negocio: Hay que concentrarse en la identificación de los requerimientos del negocio y su valor asociado, y usar estos esfuerzos para desarrollar relaciones sólidas con el negocio, agudizando el análisis del mismo y la competencia consultiva de los implementadores.  
- Construir una infraestructura de información adecuada: Diseñar una base de información única, integrada, fácil de usar, de alto rendimiento donde se reflejará la amplia gama de requerimientos de negocio identificados en la empresa. 
- Realizar entregas en incrementos significativos: crear el almacén de datos (DW) en incrementos entregables. Hay que usa el valor de negocio de cada elemento identificado para determinar el orden de aplicación de los incrementos. En esto la metodología se parece a las metodologías ágiles de construcción de software. 
- Ofrecer la solución completa: proporcionar todos los elementos necesarios para entregar valor a los usuarios de negocios. Para comenzar, esto significa tener un almacén de datos sólido, bien diseñado, con calidad probada, y accesible. También se deberá entregar herramientas de consulta ad hoc, aplicaciones para informes y análisis avanzado, capacitación y soporte.

![](img/Diagrama%20en%20blanco.png)

Los requerimientos del negocio son el soporte inicial de las tareas subsiguientes. En segundo lugar podemos ver tres rutas o caminos que se enfocan en tres diferentes áreas: 

- Tecnología (Camino Superior). Implica tareas relacionadas con
software específico, por ejemplo, Microsoft SQL Analysis Services. 
- Datos (Camino del medio). Se implementa el modelo dimensional, y se desarrolla el subsistema de Extracción, Transformación y Carga (Extract, Transformation, and Load - ETL) para cargar el DW. 
- Aplicaciones de Inteligencia de Negocios (Camino Inferior). En esta ruta se encuentran tareas en las que se diseña y desarrolla las aplicaciones de negocios para los usuarios finales

Estas rutas se combinan cuando se instala finalmente el sistema. Por debajo de la figura se muestra la actividad general de administración del proyecto la cual se puede describir de la siguiente forma:

### 4.1 Planificación 
En este proceso se determina el propósito del proyecto de DW/BI, sus objetivos específicos y el alcance del mismo, los principales riesgos y una aproximación inicial a las necesidades de información.
En la visión de programas y proyectos de Kimball, Proyecto, se refiere a una iteración simple del KLC (Kimball Life Cycle), desde el lanzamiento hasta el despliegue.
Esta tarea incluye las siguientes acciones típicas de un plan de proyecto: 

-  Definir el alcance (entender los requerimientos del negocio).
-  Identificar las tareas
-  Programar las tareas
-  Planificar el uso de los recursos.
-  Asignar la carga de trabajo a los recursos
-  Elaboración de un documento final que representa un plan del proyecto.

Además en esta parte se define cómo realizar la administración o gestión de esta subfase que es todo un proyecto en si mismo, con las siguientes actividades:

- Monitoreo del estado de los procesos y actividades.
- Rastreo de problemas.
- Desarrollo de una plan de comunicación comprensiva que direcciones la empresa y las áreas de TI.

### 4.2 Análisis de Requerimientos
La definición de los requerimientos es en gran medida un proceso de entrevistar al personal de negocio y técnico, pero siempre conviene tener un poco de preparación previa. Se debe aprender tanto como se pueda sobre el negocio, los competidores, la industria y los clientes del mismo. Hay que leer todos los informes posibles de la organización; rastrear los documentos de estrategia interna; entrevistar a los empleados, analizar lo que se dice en la prensa acerca de la organización, la competencia y la industria. Se deben conocer los términos y la terminología del negocio.
Parte del proceso de preparación es averiguar a quién se debe realmente entrevistar. esto normalmente implica examinar cuidadosamente el organigrama de la organización. Hay básicamente cuatro grupos de personas con las que hablar desde el principio: el directivo responsable de tomar las decisiones estratégicas; los administradores intermedios y de negocio responsables de explorar alternativas estratégicas y aplicar decisiones; personal de sistemas, si existen, la gente que realmente sabe qué tipos de problemas informáticos y de datos existen; y por último, la gente que se necesita entrevistar por razones políticas. 

A partir de las entrevistas, podemos identificar temas analíticos y procesos de negocio. Los temas analíticos agrupan requerimientos comunes en un tema común

|  Tema Analitico | Análisis o requerimiento inferido o pedido  |Proceso de negocio o soporte  | Comentarios   |
| ------------ | ------------ | ------------ | ------------ |
|   Planificacion de Ventas| Análisis historico de ordenes de ordenes de revendodores| Ordenes de Compras  | Por cliente por país, por region de ventas    |
|  |Proyección de Ventas  | Ordenes de Compras | La proyección es un proceso de negocio que usa las órdenes como entradas |

Por otra parte, a partir del análisis se puede construir una herramienta de la metodología denominada matriz de procesos/dimensiones, una dimensión es una forma o vista o criterio por medio de cual se pueden sumariar, cruzar o cortar datos numéricos a analizar, datos que se denominan medidas. Esta matriz tiene en sus filas los procesos de negocio
identificados, y en las columnas, las dimensiones identificadas. Finalmente se busca priorizar los requerimientos o procesos de negocios más críticos.

### 4.3 Modelado Dimensional
La creación de un modelo dimensional es un proceso dinámico y altamente iterativo.

![](img/img3.png)








