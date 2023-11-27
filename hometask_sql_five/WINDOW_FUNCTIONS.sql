-- Задание №1

/*
CREATE TABLE test (
	point_id INT,
  	city VARCHAR,
  	country VARCHAR
);

INSERT INTO test(point_id, city, country) VALUES
(1, 'Moscow', 'Russia'),
(2, 'Saint-Petersburg', 'Russia'),
(3, 'Astana', 'Kazahstan'),
(4, 'Karaganda', 'Kazahstan'),
(5, 'Perm', 'Russia'),
(6, 'Ufa', 'Russia'),
(7, 'Novosibirsk', 'Russia'),
(8, 'Almaly', 'Kazahstan'),
(9, 'Yaroslavl', 'Russia'),
(10, 'Kaliningrad', 'Russia');
*/

-- Запрос выводит порядковый номер города, который был представлен в алфавитном порядке, учитывая повторяющиеся города
SELECT DISTINCT city, ROW_NUMBER() OVER(ORDER BY city) AS rownum
FROM test
order by city;

-- Запрос выводит порядковый номер города без учёта уникальных городов
Select city, ROW_number() OVER(order by city) AS rownum
from test;

-- Указывает страну и порядковый номер относительно записи городов в таблице
Select distinct country, ROW_number() OVER(order by country) AS rownum
from test;

-- Указываем город и порядковый номер относительно страны в таблице и порядку, в котором он существует
select city, ROW_number() OVER(order by country) AS rownum
from test;

-- Задание №2

-- Сотрудники с максимальной зарплатой без оконок

SELECT _s1.first_name, _s1.last_name, _s1.salary, _s1.industry, _t1.name_ighest_sal FROM "Salary"_s1
LEFT JOIN (
  SELECT _s.industry, CONCAT(_s.first_name, ' ', _s.last_name) name_ighest_sal FROM "Salary" _s
  JOIN (
    SELECT industry, MAX(salary) max_salary_in_industry FROM "Salary"
    GROUP BY industry
  ) _t USING (industry)
  WHERE _s.salary = _t.max_salary_in_industry
) _t1 USING (industry)
ORDER BY 4;

-- Сотрудники с максимальной зарплатой с оконками

SELECT 
	_s.first_name,
    _s.last_name,
    _s.salary,
    _s.industry,
    FIRST_VALUE(CONCAT(_s.first_name, ' ', _s.last_name)) OVER (PARTITION BY industry ORDER BY salary DESC) name_ighest_sal
FROM "Salary" _s;

-- Сотрудники с минимальной зарплатой без оконок

SELECT _s1.first_name, _s1.last_name, _s1.salary, _s1.industry, _t1.name_min_sal FROM "Salary"_s1
LEFT JOIN (
  SELECT _s.industry, CONCAT(_s.first_name, ' ', _s.last_name) name_min_sal FROM "Salary" _s
  JOIN (
    SELECT industry, MIN(salary) min_salary_in_industry FROM "Salary"
    GROUP BY industry
  ) _t USING (industry)
  WHERE _s.salary = _t.min_salary_in_industry
) _t1 USING (industry)
ORDER BY 4;

-- Сотрудники с минимальной зарплатой с оконками

SELECT 
	_s.first_name,
    _s.last_name,
    _s.salary,
    _s.industry,
    FIRST_VALUE(CONCAT(_s.first_name, ' ', _s.last_name)) OVER (PARTITION BY industry ORDER BY salary) name_min_sal
FROM "Salary" _s;

-- Задание №3

SELECT 
	_t."SHOPNUMBER",
    _t."CITY",
    _t."ADDRESS",
    SUM(_t."QTY") "SUM_QTY",
    SUM(_t."QTY" * "PRICE"::INT) "SUM_QTY_PRICE"
FROM (
  SELECT * FROM "SALES" _sls
  LEFT JOIN "SHOPS" _sps
  USING ("SHOPNUMBER")
  LEFT JOIN "GOODS" _g
  USING ("ID_GOOD")
  WHERE _sls."DATE" = '1/2/2016'
) _t
GROUP BY _t."SHOPNUMBER", _t."CITY", _t."ADDRESS"
ORDER BY 1;

-- Задание №4

SELECT 
    "DATE" "DATE_",
    "CITY",
    SUM(sales) / total_sales AS "SUM_SALES_REL"
FROM (
    SELECT 
        "DATE",
        "CITY",
        "CATEGORY",
        SUM("QTY"::INT * "PRICE") AS sales,
        SUM("QTY"::INT * "PRICE") OVER (PARTITION BY "DATE", "CITY") AS total_sales
    FROM (
    	SELECT * FROM "SALES" _sls
        LEFT JOIN "SHOPS" _sps
        USING ("SHOPNUMBER")
        LEFT JOIN "GOODS" _g
        USING ("ID_GOOD")
        WHERE "CATEGORY" = 'ЧИСТОТА'
    ) 
    GROUP BY 
        "DATE", "CITY", "CATEGORY", "QTY", "PRICE"
) subquery
GROUP BY 
    "DATE_", "CITY", total_sales;

SELECT 
	"DATE",
    "CITY",
    SUM("QTY"::INT * "PRICE") "SUM_SALES_REL"
FROM (
	SELECT * FROM "SALES" _sls
    LEFT JOIN "SHOPS" _sps
    USING ("SHOPNUMBER")
    LEFT JOIN "GOODS" _g
    USING ("ID_GOOD")
  	WHERE "CATEGORY" = 'ЧИСТОТА'
) _t
GROUP BY
	"DATE", "CITY"
ORDER BY
	1
    
-- Задание №5

SELECT "DATE" "DATE_", "SHOPNUMBER", "ID_GOOD" FROM (
  SELECT 
      "DATE",
      "SHOPNUMBER",
      "ID_GOOD",
      RANK() OVER (PARTITION BY "DATE", "SHOPNUMBER" ORDER BY SUM("QTY") DESC) _rank
  FROM (
      SELECT * FROM "SALES" _sls
      LEFT JOIN "SHOPS" _sps
      USING ("SHOPNUMBER")
      LEFT JOIN "GOODS" _g
      USING ("ID_GOOD")
  ) _t
  GROUP BY "DATE", "SHOPNUMBER", "ID_GOOD"
) _t1
WHERE _rank <= 3

-- Задание №6

WITH prev_and_current AS (
    SELECT
        _t."DATE" AS DATE_,
        _t."SHOPNUMBER" AS SHOPNUMBER,
        _t."CATEGORY" AS CATEGORY,
        _t."QTY"::INT * _t."PRICE" AS SALES_RUB,
        LAG(_t."DATE") OVER (PARTITION BY _t."SHOPNUMBER", _t."CATEGORY" ORDER BY _t."DATE") AS PREV_DATE
    FROM (
        SELECT * FROM "SALES" _sls
        LEFT JOIN "SHOPS" _sps
        USING ("SHOPNUMBER")
        LEFT JOIN "GOODS" _g
        USING ("ID_GOOD")
  	) _t
    WHERE
        _t."CITY" = 'СПб'
)
SELECT
    DATE_,
    SHOPNUMBER,
    CATEGORY,
    SUM(SALES_RUB) AS PREV_SALES
FROM
    prev_and_current
WHERE
    DATE_ = PREV_DATE
GROUP BY
    DATE_,
    SHOPNUMBER,
    CATEGORY;
    
-- Задание №7

/*
-- Создание таблицы query
CREATE TABLE query (
    searchid SERIAL PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    userid INT,
    ts TIMESTAMP,
    devicetype VARCHAR(255),
    deviceid INT,
    query VARCHAR(255)
);
*/

/*
-- Вставка данных
INSERT INTO query (searchid, year, month, day, userid, ts, devicetype, deviceid, query)
VALUES
    (1, 2023, 11, 27, 1, '2023-11-27 10:00:00'::TIMESTAMP, 'android', 1, 'к'),
    (2, 2023, 11, 27, 1, '2023-11-27 11:00:00'::TIMESTAMP, 'iphone', 2, 'ку'),
    (3, 2023, 11, 27, 2, '2023-11-27 12:00:00'::TIMESTAMP, 'android', 1, 'куп'),
    (4, 2023, 11, 27, 1, '2023-11-27 13:00:00'::TIMESTAMP, 'iphone', 2, 'купить'),
    (5, 2023, 11, 27, 2, '2023-11-27 14:00:00'::TIMESTAMP, 'android', 1, 'купить кур'),
    (6, 2023, 11, 27, 3, '2023-11-27 15:00:00'::TIMESTAMP, 'iphone', 2, 'купить куртку'),
    (7, 2023, 11, 27, 2, '2023-11-27 16:00:00'::TIMESTAMP, 'android', 1, 'купить куртку ж'),
    (8, 2023, 11, 27, 2, '2023-11-27 17:00:00'::TIMESTAMP, 'iphone', 2, 'купить куртку жен'),
    (9, 2023, 11, 27, 3, '2023-11-27 18:00:00'::TIMESTAMP, 'android', 1, 'купить куртку женскую'),
    (10, 2023, 11, 27, 1, '2023-11-27 19:00:00'::TIMESTAMP, 'iphone', 2, 'купить куртку м'),
    (11, 2023, 11, 28, 1, '2023-11-28 8:00:00'::TIMESTAMP, 'android', 1, 'купить куртку муж'),
    (12, 2023, 11, 28, 1, '2023-11-28 9:00:00'::TIMESTAMP, 'iphone', 2, 'купить куртку мужскую'),
    (13, 2023, 11, 28, 2, '2023-11-28 9:30:00'::TIMESTAMP, 'android', 1, 'купить куртку мужскую л'),
    (14, 2023, 11, 28, 1, '2023-11-28 10:00:00'::TIMESTAMP, 'iphone', 2, 'купить куртку мужскую лет'),
    (15, 2023, 11, 28, 1, '2023-11-28 11:00:00'::TIMESTAMP, 'android', 1, 'купить куртку мужскую летнюю'),
    (16, 2023, 11, 28, 3, '2023-11-28 12:00:00'::TIMESTAMP, 'iphone', 2, 'купить куртку женскую л'),
    (17, 2023, 11, 28, 1, '2023-11-28 13:00:00'::TIMESTAMP, 'android', 1, 'купить куртку женскую летнюю'),
    (18, 2023, 11, 28, 2, '2023-11-28 14:00:00'::TIMESTAMP, 'iphone', 2, 'купить куртку женскую з'),
    (19, 2023, 11, 28, 1, '2023-11-28 15:00:00'::TIMESTAMP, 'android', 1, 'купить куртку женскую зим'),
    (20, 2023, 11, 28, 3, '2023-11-28 16:00:00'::TIMESTAMP, 'iphone', 2, 'купить куртку женскую зимнюю')
*/

WITH ranked_queries AS (
    SELECT
        year,
        month,
        day,
        userid,
        ts,
        devicetype,
        deviceid,
        query,
        LEAD(query) OVER (PARTITION BY userid, deviceid ORDER BY ts) AS next_query,
        LEAD(ts) OVER (PARTITION BY userid, deviceid ORDER BY ts) AS next_ts,
        CASE
            WHEN LEAD(ts) OVER (PARTITION BY userid, deviceid ORDER BY ts) IS NULL THEN 1
            WHEN LEAD(ts) OVER (PARTITION BY userid, deviceid ORDER BY ts) - ts > INTERVAL '3 minutes' THEN 1
            WHEN LENGTH(query) < LENGTH(LEAD(query) OVER (PARTITION BY userid, deviceid ORDER BY ts)) 
                 AND LEAD(ts) OVER (PARTITION BY userid, deviceid ORDER BY ts) - ts > INTERVAL '1 minute' THEN 2
            ELSE 0
        END AS is_final
    FROM query
    WHERE devicetype = 'android' AND
          year = 2023 AND
          month = 11 AND
          day = 27
)
SELECT
    year,
    month,
    day,
    userid,
    ts,
    devicetype,
    deviceid,
    query,
    next_query,
    is_final
FROM ranked_queries
WHERE is_final IN (1, 2);
