-- Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT p.name product_name, c.name catalog_name
FROM products p JOIN catalogs c ON p.catalog_id = c.id;