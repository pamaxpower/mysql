DROP DATABASE IF EXISTS hw_6;
CREATE DATABASE hw_6;

USE Hw_6;
-- пользователи
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

INSERT INTO users (id, firstname, lastname, email) VALUES 
(1, 'Reuben', 'Nienow', 'arlo50@example.org'),
(2, 'Frederik', 'Upton', 'terrence.cartwright@example.org'),
(3, 'Unique', 'Windler', 'rupert55@example.org'),
(4, 'Norene', 'West', 'rebekah29@example.net'),
(5, 'Frederick', 'Effertz', 'von.bridget@example.net'),
(6, 'Victoria', 'Medhurst', 'sstehr@example.net'),
(7, 'Austyn', 'Braun', 'itzel.beahan@example.com'),
(8, 'Jaida', 'Kilback', 'johnathan.wisozk@example.com'),
(9, 'Mireya', 'Orn', 'missouri87@example.org'),
(10, 'Jordyn', 'Jerde', 'edach@example.com');

/* Задание 1. Создайте таблицу users_old, аналогичную таблице users. 
Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users
 в таблицу users_old. (использование транзакции с выбором commit или rollback – обязательно).*/

-- Создаем таблицу
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, 
    firstname varchar(50), 
    lastname varchar(50), 
    email varchar(120)
);

-- Процедура переноса

 DROP PROCEDURE IF EXISTS transfer_users;
DELIMITER //
CREATE PROCEDURE transfer_users(IN users_id INT)
BEGIN
    -- Определение переменной для проверки существования пользователя
    DECLARE users_count INT;
    -- Проверка наличия пользователя в таблице users
    SELECT COUNT(*) INTO users_count FROM users WHERE id = users_id;
    -- Перенос пользователя из таблицы users в users_old
    IF users_count > 0 THEN
        INSERT INTO users_old SELECT * FROM users WHERE id = users_id;
        DELETE FROM users WHERE id = users_id;
        -- Фиксация изменений
        COMMIT;
        SELECT 'Пользователь успешно перенесен.';
    ELSE
        -- Отмена изменений
        ROLLBACK;
        SELECT 'Пользователь не найден.';
    END IF;
END //
DELIMITER ;

-- Вызов проедуры
 CALL transfer_users(1);
 
 -- Проверка таблиц
 SELECT * FROM users;
 SELECT * FROM users_old;
 
/* Задание 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

DELIMITER //
CREATE FUNCTION hello() RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    DECLARE current_hour INT;
    DECLARE greeting VARCHAR(20);
    SET current_hour = HOUR(CURRENT_TIME());
    IF (current_hour >= 6 AND current_hour < 12) THEN
        SET greeting = 'Доброе утро';
    ELSEIF (current_hour >= 12 AND current_hour < 18) THEN
        SET greeting = 'Добрый день';
    ELSEIF (current_hour >= 18 AND current_hour < 24) THEN
        SET greeting = 'Добрый вечер';
    ELSE
        SET greeting = 'Доброй ночи';
    END IF;
    RETURN greeting;
END //
DELIMITER ;

-- Вызов функции
SELECT hello();

/* Задание 3.  Создайте таблицу logs типа Archive. 
Пусть при каждом создании записи в таблицах users, communities и messages в таблицу logs
 помещается время и дата создания записи, название таблицы, идентификатор первичного ключа.*/

-- Создаем таблицу logs
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
    -- id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    table_name VARCHAR(255) NOT NULL,
    pk_id BIGINT NOT NULL
) ENGINE=ARCHIVE;

CREATE
	TRIGGER insert_user_log
AFTER INSERT ON users FOR EACH ROW
	INSERT INTO logs (table_name, pk_id) VALUES ('users', NEW.id);
    
CREATE
	TRIGGER insert_communities_log
AFTER INSERT ON communities FOR EACH ROW
	INSERT INTO logs (table_name, pk_id) VALUES ('communities', NEW.id);

CREATE
	TRIGGER insert_messages_log
AFTER INSERT ON messages FOR EACH ROW
	INSERT INTO logs (table_name, pk_id) VALUES ('messages', NEW.id);
