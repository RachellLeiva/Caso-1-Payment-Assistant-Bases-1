# Caso-1-Payment-Assistant-Bases-1

## Estudiantes : <br>
  Rachell Leiva Abarca 2024220640 <br>
  Daniel Stiben Sequeira Requenes 2023282470



# Scripts

### Links a los scripts:

#### [Creación de la base de datos](https://github.com/RachellLeiva/Caso-1-Payment-Assistant-Bases-1/blob/main/creacion_database.sql)
#### [Llenado de datos](https://github.com/RachellLeiva/Caso-1-Payment-Assistant-Bases-1/blob/main/llenado_de_datos.sql)
#### [Consultas](https://github.com/RachellLeiva/Caso-1-Payment-Assistant-Bases-1/blob/main/consultas.sql)

## Script 1
### Listar todos los usuarios de la plataforma que esten activos con su nombre completo, email, país de procedencia, y el total de cuánto han pagado en subscripciones desde el 2024 hasta el día de hoy, dicho monto debe ser en colones (20+ registros)

```sql
SELECT 
u.name AS 'Nombre Completo',
u.email AS 'Correo Electrónico',
c.name AS 'País de Procedencia',
SUM(
    CASE 
        WHEN pp.recurrency_type = 'Mensual' THEN 
                    CASE 
                        WHEN us.startdate < '2024-01-01' 
                            THEN TIMESTAMPDIFF(MONTH, '2024-01-01', NOW()) 
                        ELSE TIMESTAMPDIFF(MONTH, us.startdate, NOW()) 
                    END * pp.amount
            WHEN pp.recurrency_type = 'Anual'
                THEN 
                    CASE 
                        -- Si la fecha de inicio fue antes del 2024, pero hubo una renovación en 2024
                        WHEN us.startdate < '2024-01-01' 
                            THEN 
                                CASE 
                                    WHEN YEAR(DATE_ADD(us.startdate, INTERVAL 1 YEAR)) = 2024 
                                        THEN pp.amount
                                    WHEN YEAR(DATE_ADD(us.startdate, INTERVAL 2 YEAR)) = 2024 
                                        THEN pp.amount
                                    ELSE 0
                                END
                        -- Si inició en 2024
                        WHEN YEAR(us.startdate) = 2024 
                            THEN pp.amount
                        ELSE 0
                    END
            ELSE 0
        END
    ) AS 'Total Pagado (en colones)'
FROM 
    users u
JOIN 
    countries c ON u.countries_country_id = c.country_id
JOIN 
    users_suscription us ON u.id_user = us.id_user
JOIN 
    plan_person ppn ON u.id_user = ppn.id_user
JOIN 
    plan_prices pp ON ppn.id_plan_person = pp.id_plan_person
WHERE 
    us.enabled = 1
GROUP BY 
    u.id_user
ORDER BY 
    `Total Pagado (en colones)` DESC; 
```

|Nombre Completo|Correo Electrónico|País de Procedencia|Total Pagado (en colones)|
|---------------|------------------|-------------------|-------------------------|
|User-7         |user7@example.com |Japón              |62400                    |
|User-13        |user13@example.com|Estados Unidos     |55000                    |
|User-3         |user3@example.com |México             |55000                    |
|User-17        |user17@example.com|Estados Unidos     |52800                    |
|User-5         |user5@example.com |México             |49500                    |
|User-15        |user15@example.com|Japón              |49500                    |
|User-20        |user20@example.com|Estados Unidos     |46200                    |
|User-19        |user19@example.com|México             |46200                    |
|User-9         |user9@example.com |Japón              |46200                    |
|User-11        |user11@example.com|México             |44000                    |
|User-1         |user1@example.com |Canadá             |44000                    |
|User-6         |user6@example.com |Costa Rica         |38500                    |
|User-16        |user16@example.com|Costa Rica         |28000                    |
|User-8         |user8@example.com |Costa Rica         |16000                    |
|User-18        |user18@example.com|Canadá             |16000                    |
|User-4         |user4@example.com |México             |15000                    |
|User-14        |user14@example.com|Canadá             |15000                    |
|User-12        |user12@example.com|Costa Rica         |12000                    |
|User-2         |user2@example.com |Japón              |12000                    |
|User-10        |user10@example.com|Costa Rica         |11000                    |



## Script 2 
### Listar todas las personas con su nombre completo e email, los cuales le queden menos de 15 días para tener que volver a pagar una nueva subscripción
```sql
SELECT 
    u.name AS nombre,
    u.email
FROM 
    users u
JOIN 
    users_suscription us ON u.id_user = us.id_user
WHERE 
    us.enabled = 1
    AND (
        (DATE_ADD(us.startdate, INTERVAL 1 MONTH) BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 15 DAY)
            AND us.suscription_id IN 
            (SELECT suscription_id FROM plan_prices WHERE recurrency_type = 'Mensual')
        )
        OR
        (DATE_ADD(us.startdate, INTERVAL 1 YEAR) BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 15 DAY)
            AND us.suscription_id IN 
            (SELECT suscription_id FROM plan_prices WHERE recurrency_type = 'Anual')
        ) );
```

|nombre |email             |
|-------|------------------|
|User-1 |user1@example.com |
|User-3 |user3@example.com |
|User-4 |user4@example.com |
|User-5 |user5@example.com |
|User-6 |user6@example.com |
|User-8 |user8@example.com |
|User-11|user11@example.com|
|User-13|user13@example.com|
|User-15|user15@example.com|
|User-17|user17@example.com|
|User-18|user18@example.com|
|User-19|user19@example.com|
|User-20|user20@example.com|


## Script 3

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



## Script 4

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




