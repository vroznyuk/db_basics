-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
USE shop;

CREATE OR REPLACE VIEW v_products_in_catalogs
AS 
	SELECT p.name "prod_name", c.name "cat_name"
	FROM products p, catalogs c
	WHERE p.catalog_id = c.id;

SELECT *
FROM v_products_in_catalogs;