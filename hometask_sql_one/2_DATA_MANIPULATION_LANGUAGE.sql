--1

/*

Порядок написания команд при выборе данных из таблицы в SQL обычно следующий:

1. SELECT
2. FROM
3. WHERE
4. GROUP BY
5. HAVING
6. ORDER BY
7. LIMIT

При выполнении запроса команды выполняются в следующем порядке:

1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. ORDER BY
7. LIMIT


*/

--2

/*

Для удаления строк из таблицы по условию в SQL используется команда DELETE. Например:

DELETE FROM table WHERE condition;
table - название таблицы
condition - условие, по которому будем удалить данные

Команда DELETE удаляет только строки из таблицы и не удаляет саму таблицу. 
Чтобы удалить всю таблицу, надо воспользоваться командой DROP TABLE

*/

--3

SELECT o.user_id user_id, CONCAT(u.first_name, ' ', u.last_name) username FROM orders o
INNER JOIN users u ON u.id = o.user_id
WHERE to_date(_order_date, 'DD/MM/YYYY') BETWEEN '2022-09-01' AND '2022-11-30'
Order BY 2;

--4

ALTER TABLE orders
ADD COLUMN new_price REAL,
ADD COLUMN discount INT DEFAULT 0;

UPDATE orders SET new_price = price;

UPDATE orders o SET new_price = 0.9 * price, discount = 10
WHERE o.price = (SELECT MAX(price) FROM orders);

SELECT * FROM orders;

--5 

DELETE FROM orders WHERE status = 'cancel_order' OR items > 4;

--6

SELECT address FROM (
  	SELECT SUBSTRING(u.email from position('@' in u.email) + 1 for position('.' in u.email) - 1) address, COUNT(*) cnt_address FROM users u
	GROUP BY address
	ORDER BY 2 DESC
) f
LIMIT 3;

--7

/*

SELECT old_price - new_price AS diff 
FROM goods 
WHERE diff > 100

Запрос не отработает
Проблема заключается в том, что в выражении WHERE diff > 100 используется псевдоним diff, 
который был создан в выражении SELECT, 
SQL не позволяет использовать алиасы столбцов из SELECT в WHERE, 
потому что порядок выполнения операторов SQL не позволяет обращаться к алиасам до выполнения фильтрации.

*/

