DROP DATABASE IF EXISTS beautyshop;
CREATE DATABASE beautyshop;
USE beautyshop;

-- ---------------------------------------------
-- ТАБЛИЦЫ, КЛЮЧИ, ИНДЕКСЫ
-- ---------------------------------------------

DROP TABLE IF EXISTS brands;
CREATE TABLE IF NOT EXISTS brands
    (id SERIAL,
	brand_name VARCHAR(255),
	descript VARCHAR(1023),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY pk_brands(id)
    
    ) COMMENT = 'Производители';

DROP TABLE IF EXISTS categories;
CREATE TABLE IF NOT EXISTS categories
    (id SERIAL,
	categ_name VARCHAR(255),
	descript VARCHAR(1023),
	parent_id BIGINT UNSIGNED, -- ссылка на вышестоящую категорию
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY pk_categories(id)
     
    ) COMMENT = 'Категории';

DROP TABLE IF EXISTS products;
CREATE TABLE IF NOT EXISTS products
    (id SERIAL,
	article VARCHAR(64), -- артикул
	product_name VARCHAR(255),
	descript VARCHAR(1023),
	img_src VARCHAR(1023), -- ссылка на изображение
	brand_id BIGINT UNSIGNED NOT NULL,
	categ_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

	PRIMARY KEY pk_products(id),

	FOREIGN KEY fk_products_brand_id(brand_id) 
		REFERENCES brands(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT,

	FOREIGN KEY fk_products_categ_id(categ_id) 
		REFERENCES categories(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT,

	KEY idx_products_article (article) -- индекс по артикулу

    ) COMMENT = 'Товары';

DROP TABLE IF EXISTS dict_features;
CREATE TABLE IF NOT EXISTS dict_features
    (id SERIAL,
	entity VARCHAR(255) NOT NULL, -- сущность
	attribute VARCHAR(255), -- атрибут сущности
	mnemonic VARCHAR(255) NOT NULL, -- мнемониническое обозначение атрибута
	descript VARCHAR(255),
	val VARCHAR(255) NOT NULL,
	parent_id BIGINT UNSIGNED, -- ссылка на вышестоящее свойство
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY pk_dict_features(id)
     
    ) COMMENT = 'Универсальный справочник свойств';

DROP TABLE IF EXISTS editions;
CREATE TABLE IF NOT EXISTS editions
    (id SERIAL,
	product_id BIGINT UNSIGNED NOT NULL, -- ссылка на продукт
	feature_id	BIGINT UNSIGNED NOT NULL, -- ссылка на тип свойства
	val VARCHAR(255) NOT NULL, -- текстовое обозначение: код цвета, объем, вес, количество
	unit_id BIGINT UNSIGNED, -- единица измерения (ссылка на тип свойства)
	img_src VARCHAR(1023), -- ссылка на изображение 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

	PRIMARY KEY pk_editions(id),

	FOREIGN KEY fk_editions_product_id(product_id) 
		REFERENCES products(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT,

	FOREIGN KEY fk_editions_feature_id(feature_id) 
		REFERENCES dict_features(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT

    ) COMMENT = 'Варианты выпуска товара';

DROP TABLE IF EXISTS prices;
CREATE TABLE IF NOT EXISTS prices
    (edition_id BIGINT UNSIGNED NOT NULL, -- ссылка на вариант выпуска
	dt_beg DATE NOT NULL, -- дата начала действия цены
	dt_end DATE NOT NULL, -- дата окончания действия цены
	price_value	DECIMAL(12, 2), -- значение цены
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

	FOREIGN KEY fk_prices_edition_id(edition_id) 
		REFERENCES editions(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT

    ) COMMENT = 'Цены';
 
DROP TABLE IF EXISTS stock;
CREATE TABLE IF NOT EXISTS stock
    (edition_id BIGINT UNSIGNED NOT NULL, -- ссылка на вариант выпуска
	quantity INT UNSIGNED, -- количество
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

	FOREIGN KEY fk_stock_edition_id(edition_id) 
		REFERENCES editions(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT

    ) COMMENT = 'Количество вариантов выпуска товара';

DROP TABLE IF EXISTS product_features;
CREATE TABLE IF NOT EXISTS product_features
    (product_id BIGINT UNSIGNED NOT NULL, -- ссылка на продукт
	feature_id	BIGINT UNSIGNED NOT NULL, -- ссылка на тип свойства
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

	PRIMARY KEY pk_product_features(product_id, feature_id),

	FOREIGN KEY fk_prod_feat_product_id(product_id) 
		REFERENCES products(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT,

	FOREIGN KEY fk_prod_feat_feature_id(feature_id) 
		REFERENCES dict_features(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT

    ) COMMENT = 'Дополнительные свойства товара';

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
    (id SERIAL,
	surname VARCHAR(50), -- фамилия
	first_name VARCHAR(50) NOT NULL, -- имя
	dt_birth DATE, -- дата рождения
	email VARCHAR(100) NOT NULL, -- адрес электропочты
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY pk_users(id)
    
    ) COMMENT = 'Пользователи';

DROP TABLE IF EXISTS product_rates;
CREATE TABLE IF NOT EXISTS product_rates
    (product_id BIGINT UNSIGNED NOT NULL, -- ссылка на продукт
	rate_id BIGINT UNSIGNED NOT NULL, -- ссылка на тип свойства
	user_id BIGINT UNSIGNED NOT NULL, -- ссылка на пользователя
	commentary VARCHAR(1023), -- текст отзыв
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY pk_product_rates(product_id, rate_id, user_id),

	FOREIGN KEY fk_prod_rates_product_id(product_id) 
		REFERENCES products(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT,

	FOREIGN KEY fk_prod_rates_rate_id(rate_id) 
		REFERENCES dict_features(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT,

	FOREIGN KEY fk_prod_rates_user_id(user_id) 
		REFERENCES users(id) 
		ON UPDATE CASCADE ON DELETE RESTRICT

    ) COMMENT = 'Оценки и отзывы на товар';

-- ---------------------------------------------
-- ТРИГГЕРЫ, ХРАНИМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
-- ---------------------------------------------
DELIMITER ;;
DROP TRIGGER IF EXISTS tr_bi_products;;
CREATE TRIGGER tr_bi_products
	BEFORE INSERT ON products
	FOR EACH ROW
BEGIN
  -- автозаполнение описания товара
  DECLARE v_brand_name VARCHAR(255);
  SELECT brand_name INTO v_brand_name FROM brands WHERE id = NEW.brand_id;
  SET NEW.descript = COALESCE(NEW.descript, CONCAT(v_brand_name, ' ', NEW.product_name));
END;;

-- вспомогательная функция проверки пересечения интервалов
DROP FUNCTION IF EXISTS check_interval;;
CREATE FUNCTION check_interval
	( 	p_edition_id BIGINT UNSIGNED,
		p_dt_beg DATE,
        p_dt_end DATE
    ) RETURNS INT NOT DETERMINISTIC READS SQL DATA
BEGIN
  -- Новый интервал может быть либо раньше самого раннего, либо позже самого позднего.
  -- Поиск дырок между интервалами не будем рассматривать.
  DECLARE v_dt_min, v_dt_max DATE;
  DECLARE v_result INT;
  
  SELECT MIN(dt_beg) INTO v_dt_min FROM prices WHERE edition_id = p_edition_id;
  SELECT MAX(dt_end) INTO v_dt_max FROM prices WHERE edition_id = p_edition_id;	
  
  IF (p_dt_beg > COALESCE(v_dt_max, '1900-01-01')) OR (p_dt_end < COALESCE(v_dt_min, '3000-01-01')) THEN
    SET v_result = 0; -- не пересекается
  ELSE
    SET v_result = 1; -- пересекается
  END IF;
  RETURN v_result;
END;;

DROP TRIGGER IF EXISTS tr_bi_prices;;
CREATE TRIGGER tr_bi_prices
	BEFORE INSERT ON prices
	FOR EACH ROW
BEGIN
  -- Контроль на предмет того, что новый интервал действия цены не пересекается с уже существующими в разрезе формы выпуска товара
  DECLARE v_cnt INT;
  DECLARE v_message VARCHAR(150);
  
  SELECT check_interval(NEW.edition_id, NEW.dt_beg, NEW.dt_end) INTO v_cnt;
  SET v_message = CONCAT('INSERT canceled: incorrect date interval: ', NEW.edition_id, ' ', NEW.dt_beg, ' ', NEW.dt_end);
  
  IF v_cnt = 1 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_message;
  END IF;
  
  -- Контроль на предмет положительной стоимости
  IF NEW.price_value <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled: incorrect price';
  END IF;
END;;

DROP TRIGGER IF EXISTS tr_bu_prices;;
CREATE TRIGGER tr_bu_prices
	BEFORE UPDATE ON prices
	FOR EACH ROW
BEGIN
  -- Контроль на предмет того, что новый интервал действия цены не пересекается с уже существующими в разрезе формы выпуска товара
  DECLARE v_cnt INT;
  SELECT check_interval(NEW.edition_id, NEW.dt_beg, NEW.dt_end) INTO v_cnt;
  
  IF v_cnt = 1 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled: incorrect date interval';
  END IF;
  
  -- Контроль на предмет положительной стоимости
  IF NEW.price_value <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled: incorrect price';
  END IF;
END;;

-- Вспомогательная процедура генерации цен.
-- Цена выбирается случайным образом из диапазона, который зависит от категории.
-- Для товаров, представленных в разных вариантах (кроме цвета), сначала определяется цена для наименьшего объем (количества, веса).
-- Каждый следующий вариант такого товара дороже на 20% предыдущего вариант (в порядке увеличения объема).
DROP PROCEDURE IF EXISTS generate_prices;;
CREATE PROCEDURE generate_prices ()
	NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
  DECLARE v_edition_id INT;
  DECLARE v_product_id INT;
  DECLARE v_categ_id INT;
  DECLARE v_src INT;
  DECLARE cur1_not_found INT DEFAULT 0;
  DECLARE v_price DECIMAL(12,2);

  DECLARE cur1 CURSOR FOR 
	SELECT t.edition_id, p.id product_id, c.id categ_id, src
	FROM categories c, 
		 products p,		
		(	SELECT product_id, MIN(id) edition_id, 1 src
			FROM editions e
			WHERE e.feature_id <> 4 -- кроме вариантов цвета
			GROUP BY product_id
			UNION
			SELECT product_id, id, 2 src
			FROM editions e
			WHERE e.feature_id = 4 -- только варианты цвета
		) t
	WHERE c.id =  p.categ_id AND p.id = t.product_id;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET cur1_not_found = 1;

  OPEN cur1;
  gen1 : LOOP
	FETCH cur1 INTO v_edition_id, v_product_id, v_categ_id, v_src;
	IF cur1_not_found THEN
      SET cur1_not_found = 0;
      LEAVE gen1;
	END IF;
    
    IF v_categ_id = 1 THEN
	  -- 3000-8000
      SET v_price = ROUND(3000 + RAND() * (8000 - 3000 + 1), 2);
    ELSEIF v_categ_id IN (14, 15) THEN
      -- 1000-1500
      SET v_price = ROUND(1000 + RAND() * (1500 - 1000 + 1), 2);
	ELSE
      -- 1500-2500
      SET v_price = ROUND(2500 + RAND() * (2500 - 1500 + 1), 2);
    END IF;
    
	INSERT INTO prices(edition_id, dt_beg, dt_end, price_value)
      VALUES (v_edition_id, date(now()), date_add(date(now()), INTERVAL 1 YEAR), v_price);
	
    -- цикл по остальным вариантам товара
    inner_blk:
    BEGIN
      DECLARE v_id INT;
      DECLARE cur2_not_found INT DEFAULT 0;
      
	  DECLARE cur2 CURSOR FOR 
	    SELECT id
	    FROM editions
        WHERE product_id = v_product_id
          AND id > v_edition_id
          AND v_src = 1
	  ORDER BY CONVERT(val, UNSIGNED); -- сортировка по возрастанию объема (количества, веса)
    
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET cur2_not_found = 1;
      
      OPEN cur2;
      gen2 : LOOP
	    FETCH cur2 INTO v_id;
		IF cur2_not_found THEN
		  SET cur2_not_found = 0;
          CLOSE cur2;
		  LEAVE gen2;
	    END IF;
      
        SET v_price = ROUND(v_price * 1.2, 2); -- увеличиваем цену на 20%
        INSERT INTO prices(edition_id, dt_beg, dt_end, price_value)
          VALUES (v_id, date(now()), date_add(date(now()), INTERVAL 1 YEAR), v_price);
      END LOOP gen2;
    END inner_blk;
  END LOOP gen1;
  CLOSE cur1;
END;;

-- Вычисление общей оценки товара
DROP FUNCTION IF EXISTS total_product_rate;;
CREATE FUNCTION total_product_rate
	( 	p_product_id BIGINT UNSIGNED
    ) RETURNS DECIMAL(3, 1) NOT DETERMINISTIC READS SQL DATA
BEGIN
  DECLARE v_sum INT;
  DECLARE v_count INT;
  DECLARE v_result DECIMAL(3, 1);
  
  SELECT SUM(CONVERT(f.val, UNSIGNED))
  INTO v_sum
  FROM product_rates r, dict_features f
  WHERE r.product_id = p_product_id
    AND r.rate_id = f.id
    AND f.entity = 'PRODUCT_RATES'
    AND f.attribute = 'RATE_ID';

  IF v_sum IS NULL THEN
    SET v_result = NULL;
  ELSE
    SELECT COUNT(*)
    INTO v_count
    FROM product_rates r
    WHERE r.product_id = p_product_id;
    
    SET v_result = ROUND((v_sum/v_count), 1);
  END IF;
  
  RETURN v_result;
END;;

-- ---------------------------------------------
-- ПРЕДСТАВЛЕНИЯ
-- ---------------------------------------------
-- Полный каталог с действующими ценами
CREATE OR REPLACE VIEW v_full_catalog AS
	SELECT c.categ_name, b.brand_name, RTRIM((CONCAT(p.product_name, ' ', e.val, ' ', COALESCE(d1.val, ' ')))) product_full_name, pr.price_value
	FROM categories c
		INNER JOIN products p ON p.categ_id = c.id
		INNER JOIN brands b ON b.id = p.brand_id
		INNER JOIN editions e ON e.product_id = p.id
		INNER JOIN prices pr ON pr.edition_id = e.id
		LEFT JOIN dict_features d1 ON d1.id = e.unit_id
	WHERE date(now()) BETWEEN pr.dt_beg AND pr.dt_end
	ORDER BY b.brand_name, p.product_name, pr.price_value;;

-- Перечень товаров в разрезе принадлежности по полу
CREATE OR REPLACE VIEW v_products_on_gender
AS
	WITH t AS
		(	SELECT id, val
			FROM dict_features 
			WHERE entity = 'PRODUCT_FEATURES'
			AND attribute = 'FEATURE_ID'
			AND mnemonic = 'GENDER'
		)
	SELECT c.categ_name, b.brand_name, p.product_name, t.val
	FROM brands b
		INNER JOIN products p ON p.brand_id = b.id
		INNER JOIN categories c ON c.id = p.categ_id
		INNER JOIN product_features f ON f.product_id = p.id
		INNER JOIN t ON t.id = f.feature_id
	WHERE t.val = 'Мужской'
	UNION ALL
	SELECT c.categ_name, b.brand_name, p.product_name, t.val
	FROM brands b
		INNER JOIN products p ON p.brand_id = b.id
		INNER JOIN categories c ON c.id = p.categ_id
		INNER JOIN product_features f ON f.product_id = p.id
		INNER JOIN t ON t.id = f.feature_id
	WHERE t.val = 'Женский'
	ORDER BY 4, 1, 2, 3;;