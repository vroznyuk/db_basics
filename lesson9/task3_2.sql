-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.
USE shop;
DELIMITER ;;

-- то же самое и для UPDATE
DROP TRIGGER IF EXISTS check_on_insert;;
CREATE TRIGGER check_on_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.desription IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error on INSERT: name and description cannot be NULL simultaneously';
    END IF;
END;;

INSERT INTO products (name, desription, price)
  VALUES (null, null, 1000);;