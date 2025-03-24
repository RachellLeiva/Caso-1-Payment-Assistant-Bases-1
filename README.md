# Caso-1-Payment-Assistant-Bases-1

## Estudiantes : <br>
  Rachell Leiva Abarca 2024220640 <br>
  Daniel Stiben Sequeira Requenes 2023282470

## Solo calificar entregable 1


Esta base de datos es destinada para un payment assistant que por medio de guías de voz y notificaciones realiza pagos de servicios de manera automática cada cierto tiempo establecido, pero antes de realizar el pago debe haber una confirmación.


Entre las tablas relacionadas a las entidades, posee una tabla de servicios suscritos que se conecta a la tabla de users en una relación 1 user a n servicios suscritos, ya que un user puede tener más de un servicio que desea pagar, esta tabla posee las entidades de nombre de servicio del usuario, que permite que la persona lo personalice si desea un nombre especial para identificarlo mejor, otra es el contrato del serivicio que puede ser un número pero como en ocasiones lleva guiones o inclusive letras se pone en varchar apara evitar errores, además, posee un enabled que empieza con un valor 1 al suscribirse al servicio, pero si después desea desactivarlo se cambiaría el valor a 0 indicándolo. 


Esta tabla está conectada a la de servicios disponibles, ya que puede existir diversos servicios, pero no todos los pago o utiliza el user, por tanto la columna presente en este es el nombre del servicio que podría ser pago del AyA, por ejemplo.


Esta tabla de servicios disponibles se conecta a otras dos, una de tipos de servicios que sirve para organizar en categorías los servicios y así sea más sencillo ordenarlos, por tanto la relación es de 1 tipo n servicios disponibles, además, contiene únicamente su id y el nombre del tipo. La otra tabla a la que se conecta es la de la compañía, que tiene únicamente el nombre de la compañía y se relaciona 1 compañía puede tener n servicios disponibles.


Otro grupo de tablas está destinado a las notificaciones, la primera tabla de notificaciones   esta contiene su id, una fecha para la notificación, el contrato del servicio que debe pagar, un monto actual de lo que debe pagar en decimal para que trabaje bien con montos grandes y con decimales, además una confirmación que debe estar en , otra columna es el mensaje que indica la notificación, también el medio por el que se contacta a la empresa, otra contiene el destino de la notificación de igual manera escrito y una con el estado de la notificación.

Esta tabla de notificaciones esta relacionada con user mediante 1 users n notificaciones, también está conectada a los pagos mediante 1 pago n notificaciones ya que puede enviarse más de una notificación. Se conecta además a la de los contactos del user para poder enviar mediante estos las notificaciones.


Además, la tabla de notificaciones se conecta a la de medio de notificación mediante la relación 1 notificación puede tener n medios, esta tabla solo contiene el nombre del medio que puede ser mensaje o notificación push, por ejemplo. 


Por otra parte existe la tabla de recibo de transacción que se conecta a la de transacciones mediante la relación 1 transacción n recibos, esta contiene el id, el url al pdf con el recibo y un deleted que indique si lo eliminaron o no medinate un bit.Esta tabla de recibo se conecta a la de media type de los recibos que contiene el id, el nombre del media type y el player implemente para saber con que ejecutar el archivo del recibo. 





# Script 3

#### Un ranking del top 15 de usuarios que más uso le dan a la aplicación y el top 15 que menos uso le dan a la aplicación
#### Descendente:

```sql
SELECT user_name, COUNT(user_name) AS usos
FROM logs
GROUP BY user_name
ORDER BY usos DESC
LIMIT 15;
```

|user_name|usos|
|---------|----|
|User-60  |18  |
|User-82  |17  |
|User-57  |16  |
|User-19  |16  |
|User-68  |16  |
|User-56  |16  |
|User-92  |16  |
|User-70  |15  |
|User-50  |15  |
|User-39  |14  |
|User-45  |14  |
|User-88  |14  |
|User-52  |14  |
|User-38  |14  |
|User-66  |13  |

#### Ascendente:

```sql
SELECT user_name, COUNT(user_name) AS usos FROM logs
GROUP BY user_name
ORDER BY usos ASC
LIMIT 15;
```

|user_name|usos|
|---------|----|
|User-65  |4   |
|User-75  |4   |
|User-59  |4   |
|User-30  |5   |
|User-84  |6   |
|User-3   |6   |
|User-98  |6   |
|User-22  |6   |
|User-16  |6   |
|User-72  |6   |
|User-6   |6   |
|User-63  |6   |
|User-79  |6   |
|User-32  |6   |
|User-37  |7   |



# Script 4

#### Determinar cuáles son los análisis donde más está fallando la AI, encontrar los casos, situaciones, interpretaciones, halucinaciones o errores donde el usuario está teniendo más problemas en hacer que la AI determine correctamente lo que se desea hacer, rankeando cada problema de mayor a menor cantidad de ocurrencias entre un rango de fechas


```sql
SELECT 
    sessions.bot_alias_id AS bot_alias,
    types.name AS error_type, 
    types.description,
    SUM(errors.occurrence_count) AS total_occurrences, 
    MIN(errors.timestamp) AS first_occurrence, 
    MAX(errors.timestamp) AS last_occurrence
FROM 
    ai_errors errors
JOIN 
    error_types types ON errors.error_type_id = types.error_type_id
JOIN 
    ai_sessions sessions ON errors.session_id = sessions.session_id
WHERE 
    errors.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW()
GROUP BY 
    errors.session_id, errors.error_type_id
ORDER BY 
    total_occurrences DESC;
```


|bot_alias|error_type|description                                                   |total_occurrences|first_occurrence   |last_occurrence    |
|---------|----------|--------------------------------------------------------------|-----------------|-------------------|-------------------|
|alias-4  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |25               |2025-03-02 00:55:39|2025-03-20 00:32:03|
|alias-2  |Misunderstood Command|La IA malinterpretó un comando del usuario.                   |19               |2025-02-26 00:32:03|2025-03-24 00:32:03|
|alias-3  |Hallucination|La IA generó información incorrecta o inventada.              |16               |2025-02-24 00:55:39|2025-03-21 00:55:39|
|alias-4  |Hallucination|La IA generó información incorrecta o inventada.              |16               |2025-03-07 00:32:03|2025-03-20 00:32:03|
|alias-5  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |16               |2025-02-26 00:55:39|2025-03-20 00:55:39|
|alias-4  |Incorrect Slot Filling|La IA asignó valores incorrectos a los parámetros solicitados.|15               |2025-02-23 00:32:03|2025-03-24 00:55:39|
|alias-4  |Misunderstood Command|La IA malinterpretó un comando del usuario.                   |15               |2025-03-04 00:32:03|2025-03-24 00:32:03|
|alias-3  |Misunderstood Command|La IA malinterpretó un comando del usuario.                   |15               |2025-02-28 00:55:39|2025-03-19 00:32:03|
|alias-1  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |14               |2025-02-26 00:55:39|2025-03-12 00:55:39|
|alias-5  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |14               |2025-03-01 00:55:39|2025-03-16 00:55:39|
|alias-5  |Hallucination|La IA generó información incorrecta o inventada.              |13               |2025-03-02 00:55:39|2025-03-23 00:32:03|
|alias-5  |Hallucination|La IA generó información incorrecta o inventada.              |12               |2025-02-23 00:55:39|2025-03-19 00:55:39|
|alias-5  |Incorrect Slot Filling|La IA asignó valores incorrectos a los parámetros solicitados.|12               |2025-02-23 00:32:03|2025-03-20 00:32:03|
|alias-1  |Incorrect Slot Filling|La IA asignó valores incorrectos a los parámetros solicitados.|12               |2025-02-27 00:32:03|2025-03-21 00:55:39|
|alias-5  |Misunderstood Command|La IA malinterpretó un comando del usuario.                   |12               |2025-03-02 00:55:39|2025-03-24 00:32:03|
|alias-2  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |12               |2025-02-24 00:55:39|2025-03-21 00:55:39|
|alias-3  |Incorrect Slot Filling|La IA asignó valores incorrectos a los parámetros solicitados.|11               |2025-02-24 00:55:39|2025-03-16 00:55:39|
|alias-1  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |11               |2025-03-04 00:55:39|2025-03-17 00:32:03|
|alias-2  |Incorrect Slot Filling|La IA asignó valores incorrectos a los parámetros solicitados.|10               |2025-02-26 00:55:39|2025-03-22 00:32:03|
|alias-3  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |10               |2025-03-01 00:55:39|2025-03-17 00:32:03|
|alias-3  |Incorrect Slot Filling|La IA asignó valores incorrectos a los parámetros solicitados.|9                |2025-02-27 00:55:39|2025-03-12 00:55:39|
|alias-1  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |8                |2025-03-02 00:55:39|2025-03-21 00:55:39|
|alias-2  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |8                |2025-03-10 00:55:39|2025-03-23 00:32:03|
|alias-5  |Misunderstood Command|La IA malinterpretó un comando del usuario.                   |7                |2025-03-03 00:55:39|2025-03-09 00:55:39|
|alias-4  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |7                |2025-03-08 00:55:39|2025-03-09 00:55:39|
|alias-2  |Incorrect Slot Filling|La IA asignó valores incorrectos a los parámetros solicitados.|7                |2025-03-15 00:55:39|2025-03-16 00:55:39|
|alias-5  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |7                |2025-02-24 00:32:03|2025-03-12 00:55:39|
|alias-2  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |7                |2025-02-25 00:55:39|2025-03-09 00:32:03|
|alias-4  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |6                |2025-02-23 00:32:03|2025-03-10 00:55:39|
|alias-3  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |6                |2025-02-26 00:55:39|2025-03-07 00:55:39|
|alias-3  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |6                |2025-03-04 00:55:39|2025-03-19 00:55:39|
|alias-5  |Incorrect Slot Filling|La IA asignó valores incorrectos a los parámetros solicitados.|5                |2025-03-14 00:55:39|2025-03-14 00:55:39|
|alias-2  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |5                |2025-03-04 00:55:39|2025-03-10 00:55:39|
|alias-4  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |5                |2025-02-24 00:55:39|2025-03-03 00:55:39|
|alias-5  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |5                |2025-03-18 00:55:39|2025-03-18 00:55:39|
|alias-3  |Intent Recognition Failure|La IA no pudo reconocer la intención correctamente.           |5                |2025-03-05 00:55:39|2025-03-12 00:55:39|
|alias-2  |Misunderstood Command|La IA malinterpretó un comando del usuario.                   |4                |2025-03-13 00:55:39|2025-03-13 00:55:39|
|alias-1  |Hallucination|La IA generó información incorrecta o inventada.              |4                |2025-03-05 00:55:39|2025-03-08 00:55:39|
|alias-3  |Hallucination|La IA generó información incorrecta o inventada.              |4                |2025-03-20 00:55:39|2025-03-21 00:55:39|
|alias-1  |Low Confidence Response|La IA respondió con baja confianza en su respuesta.           |4                |2025-02-28 00:55:39|2025-02-28 00:55:39|
|alias-1  |Misunderstood Command|La IA malinterpretó un comando del usuario.                   |3                |2025-03-21 00:55:39|2025-03-21 00:55:39|
|alias-1  |Hallucination|La IA generó información incorrecta o inventada.              |3                |2025-03-24 00:55:39|2025-03-24 00:55:39|
|alias-4  |Hallucination|La IA generó información incorrecta o inventada.              |3                |2025-03-11 00:55:39|2025-03-11 00:55:39|
|alias-3  |Misunderstood Command|La IA malinterpretó un comando del usuario.                   |1                |2025-03-12 00:55:39|2025-03-12 00:55:39|
|alias-4  |Misunderstood Command|La IA malinterpretó un comando del usuario.                   |1                |2025-03-09 00:55:39|2025-03-09 00:55:39|
|alias-2  |Hallucination|La IA generó información incorrecta o inventada.              |1                |2025-03-23 00:55:39|2025-03-23 00:55:39|
|alias-1  |Incorrect Slot Filling|La IA asignó valores incorrectos a los parámetros solicitados.|1                |2025-03-05 00:55:39|2025-03-05 00:55:39|




