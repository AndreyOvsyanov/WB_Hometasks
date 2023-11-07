-- 5. JOIN

-- 1 Задание

-- Не учитываем статус заказа, берём 1 клиента

SELECT DISTINCT _c.name FROM orders_new_3 _o
INNER JOIN customers_new_3 _c USING (customer_id)
WHERE _o.shipment_date::TIMESTAMP - _o.order_date::TIMESTAMP = (
  	SELECT 
    MAX(shipment_date::TIMESTAMP - order_date::TIMESTAMP)
	FROM orders_new_3
)
ORDER BY 1
LIMIT 1;

-- 2 Задание

-- Берём во внимание то, что люди отменяли заказы по прибытию в пункт выдачи, то есть не будем учитывать статус заказа

SELECT
    _c.customer_id,
    _c.name AS customer_name,
    COUNT(_o.order_id) AS order_count,
    AVG(_o.shipment_date::TIMESTAMP - _o.order_date::TIMESTAMP) avg_delivery_time,
    SUM(_o.order_ammount) AS total_order_amount
FROM customers_new_3 _c
JOIN orders_new_3 _o USING(customer_id)
GROUP BY _c.customer_id, _c.name
HAVING COUNT(_o.order_id) = (
  	SELECT MAX(total_orders) FROM (
        SELECT customer_id, COUNT(order_id) total_orders FROM orders_new_3
        GROUP BY customer_id
   	)
)
ORDER BY 5 DESC;

-- 3 Задание

SELECT 
	_c.name,
    _o1.total_orders_delivery,
    _o1.total_order_cancel,
    _o1.total_ammount_cancel,
    _o1.total_orders
FROM customers_new_3 _c
INNER JOIN (
    SELECT 
        _o.customer_id,
        SUM(CASE WHEN EXTRACT(DAY FROM shipment_date::TIMESTAMP - order_date::TIMESTAMP) > 5 THEN 1 ELSE 0 END) total_orders_delivery,
        SUM(CASE WHEN _o.order_status = 'Cancel' THEN 1 ELSE 0 END) total_order_cancel,
        SUM(CASE WHEN _o.order_status = 'Cancel' THEN _o.order_ammount ELSE 0 END) total_ammount_cancel,
        COUNT(_o.order_id) total_orders
    FROM orders_new_3 _o
    WHERE customer_id IN (
        SELECT DISTINCT customer_id FROM orders_new_3
        WHERE EXTRACT(DAY FROM shipment_date::TIMESTAMP - order_date::TIMESTAMP) > 5
        UNION
        SELECT DISTINCT customer_id FROM orders_new_3
        WHERE order_status = 'Cancel'
    )
    GROUP BY _o.customer_id
) _o1 USING(customer_id) ORDER BY 5 DESC;

-- 4 Задание

-- Выполнил это задание при помощи одного SQL-запроса и 2 CTE

WITH total_revenue_categories AS (
	SELECT
  		_p.product_category,
  		SUM(_o.order_ammount) total_revenue_category 
  	FROM orders_2 _o
  	JOIN products_3 _p ON _p.product_id = _o.product_id
  	GROUP BY _p.product_category
  	ORDER BY 2 DESC
), max_products_by_revenue AS (
	SELECT 
  		_t.product_category,
  		(
        	SELECT 
          		product_id 
          	FROM (
                SELECT 
              		_p.product_category,
              		_o.product_id, 
              		SUM(_o.order_ammount) 
              	FROM orders_2 _o
                JOIN products_3 _p ON _o.product_id = _p.product_id
                GROUP BY _p.product_category, _o.product_id
                HAVING _p.product_category = _t.product_category
                ORDER BY 3 DESC
                LIMIT 1
            ) _a
        ) product_max_category
  	FROM total_revenue_categories _t
), category_by_max_total_products AS ( -- Определяет категорию ПРОДУКТА, у которого максимально количестве продаж, суммарный ammount наибольший
  	SELECT _p.product_category FROM products_3 _p
  	JOIN (
        SELECT _o.product_id, SUM(_o.order_ammount) FROM orders_2 _o
        GROUP BY _o.product_id
        ORDER BY 2 DESC
      	LIMIT 1
    ) _t USING (product_id)
)

SELECT
	_t.product_category category,
    _t.total_revenue_category,
    (SELECT * FROM category_by_max_total_products) product_max_from_category,
    _p.product_name product_max_category
FROM total_revenue_categories _t
JOIN max_products_by_revenue _m ON _m.product_category = _t.product_category
JOIN products_3 _p ON _p.product_id = _m.product_max_category
ORDER BY 2 DESC;
