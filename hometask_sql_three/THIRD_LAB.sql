-- 1 Задание

-- Основной запрос

SELECT
    city,
    CASE
        WHEN age >= 0 AND age <= 20 THEN 'young'
        WHEN age >= 21 AND age <= 49 THEN 'adult'
        WHEN age >= 50 THEN 'old'
    END AS age_category,
    COUNT(*) AS customer_count
FROM users
GROUP BY city, age_category
ORDER BY city, customer_count DESC, age_category;

-- Задание 2

SELECT 
  category,
  ROUND(AVG(price)::NUMERIC, 2) avg_price
FROM products prds 
WHERE LOWER(prds.name) LIKE '%hair%' OR LOWER(prds.name) LIKE '%home%'
GROUP BY prds.category;

-- В выборке учитываются две категории товаров, поскольку остальные товары под другими категориями не попали под LIKE

-- Задание 3

WITH sellers_info AS (
  SELECT 
    seller_id,
    COUNT(DISTINCT category) total_categ,
    ROUND(AVG(rating)::NUMERIC, 2) avg_rating,
    SUM(revenue) total_revenue
  FROM sellers
  WHERE category != 'Bedding'
  GROUP BY seller_id
  ORDER BY 1
), sellers_by_rich_and_poor AS (
  SELECT
    *,
    CASE 
      WHEN total_categ > 1 AND total_revenue > 50000 THEN 'rich'
      WHEN total_categ > 1 AND total_revenue < 50000 THEN 'poor'
    END seller_type
  FROM sellers_info
)

SELECT * FROM sellers_by_rich_and_poor
WHERE seller_type IS NOT NULL;

-- 4 Задание

WITH sellers_info AS (
  SELECT 
    seller_id,
    COUNT(category) total_categ,
    ROUND(AVG(rating)::NUMERIC, 2) avg_rating,
    SUM(revenue) total_revenue
  FROM sellers
  WHERE category != 'Bedding'
  GROUP BY seller_id
  ORDER BY 1
), sellers_by_rich_and_poor AS (
  SELECT
    *,
    CASE 
      WHEN total_categ > 1 AND total_revenue > 50000 THEN 'rich'
      WHEN total_categ > 1 AND total_revenue < 50000 THEN 'poor'
    END seller_type
  FROM sellers_info
), seller_poors AS (
  SELECT *
  FROM sellers
  WHERE seller_id IN (SELECT seller_id FROM sellers_by_rich_and_poor WHERE seller_type = 'poor')
)

-- Отчитываю от 25.10.2023

SELECT 
  seller_id, 
  MAX(
    FLOOR(
      (to_date('25/10/2023', 'DD/MM/YYYY') - to_date(date_reg, 'DD/MM/YYYY')) / 30
    )
  ) month_from_registration,
  (
    SELECT MAX(delivery_days) - MIN(delivery_days) FROM seller_poors
  ) max_delivery_difference
FROM seller_poors
GROUP BY seller_id
ORDER BY 1;

-- 5 Задание

WITH sellers_info AS (
  SELECT 
    seller_id,
    COUNT(category) total_categ,
    SUM(revenue) total_revenue
  FROM sellers
  WHERE EXTRACT(YEAR FROM to_date(date_reg, 'DD/MM/YYYY')) = 2022
  GROUP BY seller_id
), sellers_and_categoryes AS (
  SELECT seller_id, category 
  FROM sellers 
  WHERE seller_id IN (SELECT seller_id FROM sellers_info WHERE total_categ = 2 AND total_revenue > 75000) AND
      EXTRACT(YEAR FROM to_date(date_reg, 'DD/MM/YYYY')) = 2022
  ORDER BY 1, 2
)

SELECT seller_id, STRING_AGG(category, ' - ') AS category_pair FROM sellers_and_categoryes GROUP BY seller_id;

