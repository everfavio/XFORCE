[<-volver al índice](../README.md#indice)
# 6. Estándares de Desarrollo para el Proyecto
### Convenciones de nombramiento

En programación de computadoras, una convención de nomenclatura es un conjunto de reglas para elegir la secuencia de caracteres que se utilizará para identificadores que denotan variables, tipos, funciones y otras entidades en el código fuente y la documentación.

Las razones para usar una convención de nomenclatura (en lugar de permitir que los programadores elijan cualquier secuencia de caracteres) incluyen las siguientes:

  - Reducir el esfuerzo necesario para leer y comprender el código fuente;

  - Permitir que las revisiones de código se centren en cuestiones más importantes que discutir sobre la sintaxis y los estándares de nombres.

  - Permitir que las herramientas de revisión de la calidad del código centren sus informes principalmente en cuestiones importantes distintas de las preferencias de estilo y sintaxis.

### Snake case - underscore
Snake case (estilizado como snake_case) se refiere al estilo de escritura en el que cada espacio se reemplaza por un carácter de subrayado (_) y la primera letra de cada palabra escrita en minúsculas. Es una convención de nomenclatura comúnmente utilizada en informática, por ejemplo, para nombres de variables y subrutinas, y para nombres de archivos, será la nomenclatura utilizada para la asignación de nombres de los elementos del proyecto.

### Estándares de Tablas
Los Nombres de la Tablas para su creación mantendrán el siguiente estándar::

[tipo] _ [nombre] _ [negocio]

[tipo]: El tipo describe si la tabla es Dimensión, Hecho u otro.

[nombre]: Describe el nombre de la tabla.

[negocio]: Especifica si fuese necesario el nombre del negocio al que pertenece la tabla.

Para la creación de los mismos puede referirse [aca](/0-acreacion-schemas "enlace")

### Estándares de Campos
Para los campos no se realizará ningún tipo de especificación para los nombres debido a la variedad que pueden tener pero básicamente mantendrá un estándar como se muestra a continuación:
 
[descripcion] _ [nombre_campo] _ [descripcion_2]

[descripcion] – [descripcion_2]: Especifica si fuese necesario una descripción abreviada corta.
[nombre_campo]: Especifica el Nombre del Campo.

Para la creación de los mismos puede referirse [aca](/0-copia-estructuras "enlace")

### Estándares de Funciones y Procedimientos Almacenados
Para las funciones y procedimientos almacenados se utlizo la notacion underscore manteniendo las minusculas comom predominantes.

[descripcion] _ [nombre_campo] _ [descripcion_2]
[DESCRIPCION] – [descripcion_2]: Especifica si fuese necesario una descripción abreviada corta.
[nombre_campo]: Especifica el Nombre del Campo en letra minuscula.

Para la creación de los mismos puede referirse [aca](/1-etl-copia-tablas "enlace")

Para la creación de los mismos puede referirse [aca](/2-etl-cargado-stage-stage "enlace")

Para la creación de los mismos puede referirse [aca](/3-etl-cargado-star "enlace")

### Estándares ETL
En cuanto a ETL se utlizo la notacion underscore manteniendo las minusculas comom predominantes.

[descripcion] _ [nombre_campo] _ [descripcion_2]
[descripcion] – [descripcion_2]: Especifica si fuese necesario una descripción abreviada corta.
[nombre_campo]: Especifica el Nombre del Campo en letra minuscula..

Para la creación de los mismos puede referirse [aca](/1-etl-copia-tablas "enlace")

Para la creación de los mismos puede referirse [aca](/2-etl-cargado-stage-stage "enlace")

Para la creación de los mismos puede referirse [aca](/3-etl-cargado-star "enlace")

[<-volver al índice](../README.md#indice)