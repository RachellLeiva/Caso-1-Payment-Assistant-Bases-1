-- ########
-- Script 1
-- ########
SELECT 
u.name AS 'Nombre Completo',
u.email AS 'Correo Electrónico',
c.name AS 'País de Procedencia',
    SUM(
        CASE 
            WHEN pp.recurrency_type = 'Mensual'
                THEN 
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
-- ########
-- Script 2
-- ########
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
        )
    );
-- ########
-- Script 3
-- ########

SELECT user_name, COUNT(user_name) AS usos FROM logs
GROUP BY user_name
ORDER BY usos DESC
LIMIT 15;

SELECT user_name, COUNT(user_name) AS usos FROM logs
GROUP BY user_name
ORDER BY usos ASC
LIMIT 15;

-- ########
-- Script 4
-- ########

SELECT sessions.bot_alias_id AS bot_alias,
		types.name AS error_type, types.description,
		SUM(errors.occurrence_count) AS total_occurrences, 
		MIN(errors.timestamp) AS first_occurrence, 
		MAX(errors.timestamp) AS last_occurrence
FROM ai_errors errors
JOIN error_types types ON errors.error_type_id = types.error_type_id
JOIN ai_sessions sessions ON errors.session_id = sessions.session_id
WHERE errors.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW()
GROUP BY errors.session_id, errors.error_type_id
ORDER BY total_occurrences DESC;


