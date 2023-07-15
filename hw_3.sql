DROP DATABASE IF EXISTS hw_3;
CREATE DATABASE hw_3;

USE hw_3;

DROP TABLE IF EXISTS staff;
CREATE TABLE staff
(
id SERIAL PRIMARY KEY,
firstname VARCHAR(20) NOT NULL,
lastname VARCHAR(20) NOT NULL,
post VARCHAR(20) NOT NULL,
seniority INT NOT NULL,
salary INT NOT NULL,
age INT NOT NULL
);

INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася','Петров','Начальник','40','100000','60'),
('Петр','Власов','Начальник','8','70000','30'),
('Катя','Катина','Инженер','2','70000','19'), # WTF??
('Саша','Сасин','Инженер','12','50000','35'),
('Иван','Иванов','Рабочий','40','30000','59'),
('Петр','Петров','Рабочий','20','25000','40'),
('Сидр','Сидоров','Рабочий','10','20000','35'),
('Антон','Антонов','Рабочий','8','19000','28'),
('Юрий','Юрков','Рабочий','5','15000','25'),
('Максим','Максимов','Рабочий','2','11000','22'),
('Юрий','Галкин','Рабочий','3','12000','24'),
('Людмила','Маркина','Уборщик','10','10000','49');

SELECT * FROM staff;

-- Задание 1. Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания
-- сортировка в порядке возрастания
SELECT *
FROM staff
ORDER BY salary;

-- сортировка в порядке убывания
SELECT *
FROM staff
ORDER BY salary DESC;

-- Задание 2. Выведите 5 максимальных заработных плат (salary)
SELECT *
FROM staff
ORDER BY salary DESC 
LIMIT 5;

-- Задание 3. Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
SELECT post, SUM(salary) AS sum_salary
FROM staff
GROUP BY post;

-- Задание 4. Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
SELECT post, COUNT(post) AS count
FROM staff
WHERE post = 'Рабочий' AND age BETWEEN 24 AND 49;

-- Задание 5. Найдите количество специальностей
-- если речь идет о выводе уникальных специальностей, то так:
SELECT DISTINCT post FROM staff;

-- если именно о количестве, то так:
SELECT COUNT(DISTINCT post) AS count_post FROM staff;

-- Задание 6. Выведите специальности, у которых средний возраст сотрудников меньше 30 лет
SELECT post, AVG(age) AS avg_age
FROM staff
GROUP BY post
HAVING AVG(Age) < 30;



