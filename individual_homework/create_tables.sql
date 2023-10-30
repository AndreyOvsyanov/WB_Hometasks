-- Создание таблицы user_actions
CREATE TABLE user_actions (
    user_id INT NOT NULL,
    session_id INT NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    element_name VARCHAR(255),
    action_id INT,
    revenue INT
    PRIMARY KEY(user_id, session_id)
);

-- Создание таблицы sessions
CREATE TABLE sessions (
    session_id INT SERIAL PRIMARY KEY,
    platform VARCHAR(10)  -- Платформа (desktop или mobile)
);

-- Создание таблицы actions
CREATE TABLE actions (
	action_id SERIAL PRIMARY KEY,
  	action_name VARCHAR(255)
);