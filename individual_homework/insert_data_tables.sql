-- Добавление данных в таблицу actions
INSERT INTO actions (action_name) VALUES
('Page View'), ('Click'), ('Add to Cart'), ('Complete Order');

-- Добавление данных в таблицу sessions
INSERT INTO sessions (platform)
SELECT
	UNNEST(array['desktop', 'mobile']) as platform
FROM generate_series(1, 10);

-- Добавление данных в таблицу user_actions
INSERT INTO user_actions (user_id, session_id, element_name, action_id, revenue)
SELECT
	floor(random() * 10 + 1) as user_id,
    floor(random() * 20 + 1) as session_id,
    md5(random()::text) || 'WB' AS element_name,
    floor(random() * 4 + 1) as action_id,
    floor(random() * 1000 + 1) as revenue
FROM generate_series(1, 100);