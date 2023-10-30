-- Конверсия от просмотра страницы к клику на элемент
SELECT
    platform,
    SUM(CASE WHEN action_name = 'Page View' THEN 1 ELSE 0 END) as page_view,
    SUM(CASE WHEN action_name = 'Click' THEN 1 ELSE 0 END) as click,
    ROUND((SUM(CASE WHEN action_name = 'Click' THEN 1 ELSE 0 END)::FLOAT / 
    SUM(CASE WHEN action_name = 'Page View' THEN 1 ELSE 0 END))::NUMERIC, 2) as click_to_page_view_conversion
FROM user_actions u_a
JOIN sessions s ON u_a.session_id =  s.session_id
JOIN actions acts ON u_a.action_id = acts.action_id
GROUP BY platform;

-- Конверсия от клика на элемент к добавлению в корзину
SELECT
    platform,
    SUM(CASE WHEN action_name = 'Click' THEN 1 ELSE 0 END) as click,
    SUM(CASE WHEN action_name = 'Add to Cart' THEN 1 ELSE 0 END) as add_to_cart,
    ROUND((SUM(CASE WHEN action_name = 'Add to Cart' THEN 1 ELSE 0 END)::FLOAT / 
    SUM(CASE WHEN action_name = 'Click' THEN 1 ELSE 0 END))::NUMERIC, 2) as click_to_add_to_cart_conversion
FROM user_actions u_a
JOIN sessions s ON u_a.session_id =  s.session_id
JOIN actions acts ON u_a.action_id = acts.action_id
GROUP BY platform;

-- Конверсия от добавления в корзину к завершению заказа
SELECT
    platform,
    SUM(CASE WHEN action_name = 'Add to Cart' THEN 1 ELSE 0 END) as add_to_cart,
    SUM(CASE WHEN action_name = 'Complete Order' THEN 1 ELSE 0 END) as complete_order,
    ROUND((SUM(CASE WHEN action_name = 'Complete Order' THEN 1 ELSE 0 END)::FLOAT / 
    SUM(CASE WHEN action_name = 'Add to Cart' THEN 1 ELSE 0 END))::NUMERIC, 2) as add_2_complete_conversion
FROM user_actions u_a
JOIN sessions s ON u_a.session_id =  s.session_id
JOIN actions acts ON u_a.action_id = acts.action_id
GROUP BY platform;