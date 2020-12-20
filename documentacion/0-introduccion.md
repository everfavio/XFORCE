### Introducción

Un almacen de datos es considerado como una colección de datos orientada a un determiando ámbito, integrado, no volátil, y variable en el tiempo, que ayuda. Se trata, sobre todo, de un historial completo de la organización más allá de la información transaccional y operacional, almacenado en una base de datos diseñada para favorecer el análisis y la divulgación eficiente de datos. Por otra parte Kimball la define como "una copia de los datos transaccionales estructurados especificamente para consultas y análisis". Actualmente uno de los mayores impedimentos para contruir este tipo de almacenes de datos es la falta de conocimiento de metodologías adecuadas para su implementación y la disciplina para cumplirlas.
####  Metodologias Actuales
Entre la mayoría dos metodologías, la de Kimball y la de Inmon son las mas utlizadas desde  el punto de vista arquitectónico, la mayor diferencia entre los dos autores es el sentido de la construcción del DW, esto es comenzando por los Data marts o ascendente (Bottom-up, Kimball) o comenzando con todo el DW desde el principio, o descendente (TopDown, Inmon).
Por otra parte, la metodología de Inmon se basa en conceptos bien conocidos del diseño de bases de datos relacionales a metodología para la construcción de un sistema de este tipo es la habitual para construir un sistema de información, utilizando las herramientas habituales, al contrario de la de Kimball, que se basa en un modelado dimensional (no normalizado)

#### Metodología Adoptada
La metodología adoptada es la de Kimball, por ser la ideal a la practica de negocios planteada de tal forma se plantea un enfoque de mayor a menor, muy versatil y las herramientas necesarias que ayudan a la implementación de un ***Data Warehouse*** , acorde a la implementación de datamarts e integrandolos en un almacen de datos.


#### Metodología de Ralph Kimball
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
