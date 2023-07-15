/* 1. Используя операторы языка SQL, создайте таблицу “sales”. Заполните ее данными*/ 

-- Проверка на существование и создание новой схемы
DROP DATABASE IF EXISTS hw_2;
CREATE DATABASE hw_2;

-- Выбираем созданную схему
USE hw_2;

-- Создаем таблицу
DROP TABLE IF EXISTS sales;
CREATE TABLE sales
(
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	order_date DATE NOT NULL,
	count_product INT NOT NULL
);

-- Заполняем таблицу данными
INSERT INTO sales (order_date, count_product)
VALUES
('2022-01-01','156'),
('2022-01-02','180'),
('2022-01-03','21'),
('2022-01-04','124'),
('2022-01-05','341');

/* 2.  Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва : 
меньше 100  -    Маленький заказ
от 100 до 300 - Средний заказ
больше 300  -     Большой заказ*/ 

SELECT 
id AS 'id заказа',
CASE 
	WHEN count_product < 100 THEN 'Маленький заказ'
    WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
    WHEN count_product > 300 THEN 'Большой заказ'
END AS 'Тип заказа'
FROM sales;

/* 3. Создайте таблицу “orders”, заполните ее значениями */

DROP TABLE IF EXISTS orders;
CREATE TABLE orders
(
id SERIAL PRIMARY KEY,
employee_id VARCHAR(8) NOT NULL,
amount DECIMAL(5,2) NOT NULL,
order_status VARCHAR(20) NOT NULL
);

INSERT INTO orders (employee_id, amount, order_status)
VALUES
('e03','15.00','OPEN'),
('e01','25.50','OPEN'),
('e05','100.70','CLOSED'),
('e02','22.18','OPEN'),
('e04','9.50','CANCELLED');

/* Выберите все заказы. В зависимости от поля order_status выведите столбец full_order_status:
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED -  «Order is cancelled» */

SELECT
id AS 'id заказа',
employee_id AS 'id сотрудника',
amount AS 'цена',
IF (order_status = 'OPEN', 'Order is in open state',
	IF (order_status = 'CLOSED', 'Order is closed', 'Order is cancelled'))
AS 'статус заказа'
FROM orders;
	

