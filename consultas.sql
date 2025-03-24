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


