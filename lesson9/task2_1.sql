-- Создайте двух пользователей которые имеют доступ к базе данных shop.
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.

CREATE USER user1;
GRANT SELECT ON shop.* TO user1; -- только чтение

CREATE USER user2;
GRANT ALL ON shop.* TO user2;

SELECT * FROM mysql.user;

SHOW GRANTS FOR user1;
SHOW GRANTS FOR user2;