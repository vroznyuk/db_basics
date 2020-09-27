-- Создайте таблицу logs типа Archive. 
-- Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

USE shop;
DELIMITER ;;

DROP TABLE IF EXISTS log;
CREATE TABLE log 
	( src_tbl VARCHAR(64),
	  src_id BIGINT UNSIGNED,
      src_name VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP	
    ) ENGINE=Archive;

DROP TRIGGER IF EXISTS ai_users_log;
CREATE TRIGGER ai_users_log AFTER INSERT ON users
FOR EACH ROW
BEGIN
  INSERT INTO log (src_tbl, src_id, src_name)
	VALUES ('USERS', new.id, new.name);
END;;

DROP TRIGGER IF EXISTS ai_catalogs_log;
CREATE TRIGGER ai_catalogs_log AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
  INSERT INTO log (src_tbl, src_id, src_name)
	VALUES ('CATALOGS', new.id, new.name);
END;;

DROP TRIGGER IF EXISTS ai_products_log;
CREATE TRIGGER ai_products_log AFTER INSERT ON products
FOR EACH ROW
BEGIN
  INSERT INTO log (src_tbl, src_id, src_name)
	VALUES ('PRODUCTS', new.id, new.name);
END;;

INSERT INTO users (name, birthday_at)
  VALUES ('Scott', '1975-11-28');;
  
INSERT INTO catalogs (name)
  VALUES ('Периферия');;

INSERT INTO products (name, price, catalog_id)
  VALUES ('MSI GeForce GTX 970', 9970, 3);;
  
SELECT *
FROM   log;;