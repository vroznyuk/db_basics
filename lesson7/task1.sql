-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT *
FROM shop.users u
WHERE EXISTS ( SELECT 1 FROM shop.orders o
				WHERE o.user_id = u.id);

-- второй вариант
SELECT DISTINCT u.*
FROM shop.users u JOIN shop.orders o ON u.id = o.user_id;

