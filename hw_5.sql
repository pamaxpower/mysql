USE les_4;

/* Задача 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол),
которые не старше 20 лет.
*/

-- Создание представления

CREATE OR REPLACE VIEW info_users AS
SELECT 
	u.id,
    u.firstname AS 'Имя', 
    u.lastname AS 'Фамилия',
    p.hometown AS 'Город',
    p.gender AS 'Пол',
    (YEAR(CURRENT_DATE)-YEAR(p.birthday)) AS 'Возраст'
FROM users u 
JOIN profiles p ON p.user_id = u.id
WHERE (YEAR(CURRENT_DATE)-YEAR(p.birthday)) <= 20
GROUP BY u.id;

-- Просмотр представления 

SELECT * FROM info_users;

/* Задача 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный 
список пользователь, указав указать имя и фамилию пользователя, количество отправленных сообщений 
и место в рейтинге (первое место у пользователя с максимальным количеством сообщений) . 
(используйте DENSE_RANK)*/

SELECT
	u.id,
	CONCAT (u.firstname, ' ', u.lastname) AS 'Пользователь',
    COUNT(m.from_user_id) AS 'Кол-во сообщений',
    DENSE_RANK() OVER (ORDER BY COUNT(m.from_user_id) DESC) AS 'Рейтинг'
FROM users u
LEFT JOIN messages m ON m.from_user_id = u.id
GROUP BY u.id;

/* Задача 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) 
и найдите разницу дат отправления между соседними сообщениями, получившегося списка. 
(используйте LEAD или LAG)*/ 

SELECT
	body AS 'Текст сообщения',
    created_at AS 'Время создания текущего сообщения',
    LAG(created_at, 1, 'сообщений не было') OVER(ORDER BY created_at) AS 'Время создания предыдущего сообщения',
    TIME_TO_SEC(TIMEDIFF (created_at, LAG(created_at) OVER(ORDER BY created_at))) AS 'Разница в секундах'
FROM messages
;
