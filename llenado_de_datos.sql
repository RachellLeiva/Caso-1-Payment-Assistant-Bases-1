--Insertamos 5 países a la tabla de países
INSERT INTO countries (name, country_id) VALUES
('Costa Rica', 1),
('Estados Unidos', 2),
('México', 3),
('Japón', 4),
('Canadá', 5);

--Insertamos 3 idiomas a la tabla de idiomas
INSERT INTO languages (name, culture,id_language) VALUES
('Español',"ES", 1),
('Inglés',"EN", 2),
('Japonés',"JP",3);

-- Insertamos 50 usuarios en la tabla users
DELIMITER //

CREATE PROCEDURE crear_usuarios()
BEGIN
    DECLARE i INT DEFAULT 1;
    -- bucle para insrtar--
    WHILE i <= 50 DO
        -- generar valores aleatorios
        SET @id_user = i + 50;
        SET @name = CONCAT('User-', i);
        SET @cedula = LPAD(FLOOR(RAND() * 1000000000), 9, '0');
        SET @password = UNHEX(SHA2(CONCAT('password', i), 256)); 
        SET @id_language = FLOOR(1 + RAND() * 3);
		SET @countries_country_id = FLOOR(1 + RAND() * 5);
        SET @email = CONCAT('user', i, '@example.com'); 
        -- insertar el usuario en la tabla
        INSERT INTO mydb.users (id_user, name, cedula, contraseña, id_language,countries_country_id, email)
        VALUES (@id_user, @name, @cedula, @password, @id_language,@countries_country_id, @email);

        SET i = i + 1;
    END WHILE;
END//

DELIMITER ;

CALL crear_usuarios();

--Insertamos los horarios de los planes
INSERT INTO schedules (id_schedules, name, recurrency_type, `repeat`, end_type, repetitions, end_date)
VALUES
(1, 'Plan Básico', 'Mensual', 1, 'Ilimitado', 'NA', NULL),
(2, 'Plan Premium', 'Anual', 1, 'Ilimitado', 'NA', NULL),
(3, 'Plan Estándar', 'Mensual', 1, 'Ilimitado', 'NA', NULL),
(4, 'Plan Pro', 'Anual', 1, 'Ilimitado', 'NA', NULL);
DELIMITER //

--LLenamos la tabla de suscripción de usuarios con 20 registros
CREATE PROCEDURE llenar_users_suscription()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 20 DO
        INSERT INTO users_suscription (suscription_id, description, logo_url, startdate, enddate, deleted, enabled, id_user)
        VALUES 
        (i, 
         CASE MOD(i, 4)
             WHEN 0 THEN 'Plan Básico'
             WHEN 1 THEN 'Plan Premium'
             WHEN 2 THEN 'Plan Estándar'
             ELSE 'Plan Pro'
         END,
         CONCAT('url_logo', MOD(i, 4) + 1), DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 90) DAY), NULL, 0, 1, 50 + i);
        SET i = i + 1;
    END WHILE;
END//

--LLenamos la tabla de plan por persona con 20 registros y relacionada a las tablas anteriores
CREATE PROCEDURE llenar_plan_person()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 20 DO
        INSERT INTO plan_person (id_plan_person, adquisition_date, enabled, id_user, id_schedules)
        VALUES 
        (100 + i,DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 120) DAY),1, 50 + i,MOD(i, 4) + 1);
        SET i = i + 1;
    END WHILE;
END//

--LLenamos la tabla de precios de plan con 20 registros y relacionada a las tablas anteriores
CREATE PROCEDURE llenar_plan_prices()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 20 DO
        INSERT INTO plan_prices (id_plan_prices, amount, recurrency_type, posttime, enddate, current, id_user_suscription, id_plan_person)
        VALUES 
        (i,
         CASE MOD(i, 4)
             WHEN 0 THEN 4000
             WHEN 1 THEN 12000
             WHEN 2 THEN 5000
             ELSE 15000
         END,
         CASE MOD(i, 4)
             WHEN 0 THEN 'Mensual'
             WHEN 1 THEN 'Anual'
             WHEN 2 THEN 'Mensual'
             ELSE 'Anual'
         END,
         DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 100) DAY),
         DATE_ADD('2024-06-01', INTERVAL FLOOR(RAND() * 100) DAY),
         1, i, 100 + i);
        SET i = i + 1;
    END WHILE;
END//

DELIMITER ;

CALL llenar_users_suscription();
CALL llenar_plan_person();
CALL llenar_plan_prices();



-- insertamos registros en la tabla ai_sessions
INSERT INTO mydb.ai_sessions (session_uuid, bot_id, bot_alias_id, start_time, id_user) VALUES
(UUID(), 'bot-1', 'alias-1', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 1), 
(UUID(), 'bot-2', 'alias-2', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 2),  
(UUID(), 'bot-3', 'alias-3', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 3), 
(UUID(), 'bot-4', 'alias-4', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 4), 
(UUID(), 'bot-5', 'alias-5', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 5), 
(UUID(), 'bot-6', 'alias-1', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 1),  
(UUID(), 'bot-7', 'alias-2', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 2), 
(UUID(), 'bot-8', 'alias-3', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 1), 
(UUID(), 'bot-9', 'alias-4', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 1), 
(UUID(), 'bot-10', 'alias-5', NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 2); 

-- insertamos tipos de errores
INSERT INTO error_types (error_type_id, name, description) VALUES
(1, 'Intent Recognition Failure', 'La IA no pudo reconocer la intencion correctamente.'),
(2, 'Low Confidence Response', 'La IA respondio con baja confianza en su respuesta.'),
(3, 'Hallucination', 'La IA genero informacion incorrecta o inventada.'),
(4, 'Misunderstood Command', 'La IA malinterpreto un comando del usuario.'),
(5, 'Incorrect Slot Filling', 'La IA asigno valores incorrectos a los parametros solicitados.');




-- Insertamos errores en un bucle
DELIMITER //

CREATE PROCEDURE llenar_datos_errores()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 100 DO
        SET @error = FLOOR(1 + (RAND() * 5));  -- Escoge un error entre 1 y 5
        SET @confidence = ROUND(RAND(), 2);    -- Genera confianza entre 0.00 y 1.00
        SET @session = FLOOR(1 + (RAND() * 10)); -- Simula sesiones entre 1 y 10
        SET @occurrences = FLOOR(1 + (RAND() * 5)); -- Ocurrencias entre 1 y 5
        SET @time = NOW() - INTERVAL FLOOR(RAND() * 30) DAY; -- Errores de los últimos 30 días

        INSERT INTO ai_errors (confidence, timestamp, occurrence_count, error_type_id, session_id)
        VALUES (@confidence, @time, @occurrences, @error, @session);

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

-- Ejecutamos la funcion para insertar los datos
CALL llenar_datos_errores();



INSERT INTO mydb.log_types (id_log_type, name, ref_1_des, ref_2_des, val_1_des, val_2_des) VALUES
(1, 'login', 'user_id', 'session_id', 'ip_address', 'browser'),
(2, 'logout', 'user_id', 'session_id', 'ip_address', 'browser'),
(3, 'login failure', 'user_id', 'attempts', 'ip_address', 'reason'),
(4, 'change pass', 'user_id', 'admin_id', 'old_password', 'new_password'),
(5, 'enable permission', 'user_id', 'admin_id', 'permission', 'status'),
(6, 'cancel order', 'user_id', 'order_id', 'reason', 'refund_amount'),
(7, 'create order', 'user_id', 'order_id', 'amount', 'items'),
(8, 'update profile', 'user_id', 'field', 'old_value', 'new_value'),
(9, 'delete account', 'user_id', 'admin_id', 'reason', 'backup_data'),
(10, 'system restart', 'server_id', 'admin_id', 'reason', 'uptime');


INSERT INTO mydb.log_sources (id_log_source, name) VALUES
(1, 'database'),
(2, 'mobile app'),
(3, 'node tracker'),
(4, 'lambda aws'),
(5, 'redis'),
(6, 'api gateway'),
(7, 'cloudfront'),
(8, 'elasticsearch'),
(9, 'kafka'),
(10, 's3 bucket');


INSERT INTO mydb.log_severities (id_log_severity, name) VALUES
(1, 'info'),
(2, 'warning'),
(3, 'error'),
(4, 'critical'),
(5, 'debug');

DELIMITER //

CREATE PROCEDURE llenar_logs(IN num_logs INT)
BEGIN
    DECLARE i INT DEFAULT 0;

    -- obtener el nmero de registros en las tablas de referencia
    DECLARE log_types_count INT;
    DECLARE log_sources_count INT;
    DECLARE log_severities_count INT;

    SELECT COUNT(*) INTO log_types_count FROM mydb.log_types;
    SELECT COUNT(*) INTO log_sources_count FROM mydb.log_sources;
    SELECT COUNT(*) INTO log_severities_count FROM mydb.log_severities;

    -- bucle para insertar logs
    WHILE i < num_logs DO
        -- generar valores aleatorios controlados
        SET @id_logs = (SELECT IFNULL(MAX(id_logs), 0) FROM mydb.logs) + 1;
        SET @description = CONCAT('Log description ', FLOOR(RAND() * 1000));
        SET @posttime = NOW() - INTERVAL FLOOR(RAND() * 365) DAY;
        SET @computer = CONCAT('PC-', FLOOR(RAND() * 100));
        SET @user_name = CONCAT('User-', FLOOR(RAND() * 100));
        SET @trace = CONCAT('Trace-', FLOOR(RAND() * 1000));
        SET @reference_id_1 = FLOOR(RAND() * 1000000);
        SET @reference_id_2 = FLOOR(RAND() * 1000000);
        SET @value_1 = CONCAT('Value1-', FLOOR(RAND() * 100));
        SET @value_2 = CONCAT('Value2-', FLOOR(RAND() * 100));
        SET @checksum = UNHEX(SHA2(CONCAT(v_description, v_posttime, v_computer), 256));
        SET @id_log_type = FLOOR(1 + RAND() * log_types_count);
        SET @id_log_source = FLOOR(1 + RAND() * log_sources_count);
        SET @id_log_severity = FLOOR(1 + RAND() * log_severities_count);

        -- insertar el registro en la tabla logs
        INSERT INTO mydb.logs (
            id_logs, description, posttime, computer, user_name, trace,
            reference_id_1, reference_id_2, value_1, value_2, checksum,
            id_log_type, id_log_source, id_log_severity
        ) VALUES (
            @id_logs, @description, @posttime, @computer, @user_name, @trace,
            @reference_id_1, @reference_id_2, @value_1, @value_2, @checksum,
            @id_log_type, @id_log_source, @id_log_severity
        );

        SET i = i + 1;
    END WHILE;
END//

DELIMITER ;

CALL llenar_logs(1000);

