-- --------------------------------------------
-- ЗАПОЛНЕНИЕ ДАННЫМИ
-- --------------------------------------------
DELETE FROM product_rates;
DELETE FROM stock;
DELETE FROM prices;
DELETE FROM editions;
DELETE FROM poduct_features;
DELETE FROM products;
DELETE FROM dict_features;
DELETE FROM categories;
DELETE FROM brands;

-- Производители
INSERT INTO brands (id, brand_name, descript)
  VALUES 	(1, 'Biotherm', 'Biotherm — пионер в области применения биотехнологий в средствах по уходу за кожей.'),
			(2, 'Chanel', 'В представлении не нуждается'),
			(3, 'Dior', 'Кристиан Диор - это классика женской моды. Для нее, женщины, он рисует платья, создает ароматы и придумывает образы, покоряющие сердца своей изысканностью и элегантностью. ');

-- Категории
INSERT INTO categories (id, categ_name, parent_id)
    VALUES 	(1, 'Парфюмерия', NULL),
			(2, 'Макияж', NULL),
            (3, 'Для лица', 2),
            (4, 'Для губ', 2),
            (5, 'Помада', 4),
            (6, 'Блеск', 4),
            (7, 'Карандаши для губ', 4),
            (8, 'Для глаз', 2),
            (9, 'Тушь', 8),
            (10, 'Тени', 8),
            (11, 'Карандаши и подводка', 8),
            (12, 'Для бровей', 8),
            (13, 'Уходовые средства', null),
            (14, 'Уход для лица', 13),
            (15, 'Уход для тела', 13);

-- Универсальный словарь
INSERT INTO dict_features (id, entity, attribute, mnemonic, parent_id, val)
	VALUES 	(1, 'PRODUCT_FEATURES', 'FEATURE_ID', 'GENDER', null, 'Женский'),
			(2,	'PRODUCT_FEATURES',	'FEATURE_ID', 'GENDER', null, 'Мужской'),
			(3,	'PRODUCT_FEATURES',	'FEATURE_ID', 'GENDER', null, 'Унисекс'),
			(4,	'EDITION', 'FEATURE_ID', 'COLOUR', null, 'Цвет'),
			(5,	'EDITION', 'FEATURE_ID', 'VOLUME', null, 'Объем'),
			(6, 'EDITION', 'FEATURE_ID', 'WEIGHT', null, 'Вес'),
			(7,	'EDITION', 'FEATURE_ID', 'QUANTITY', null, 'Количество'),
			(8,	'EDITION', 'UNIT_ID', 'ml', 5, 'мл'),
			(9,	'EDITION', 'UNIT_ID', 'g', 6, 'г'),
			(10,'EDITION', 'UNIT_ID', 'mg',	6, 'мг'),
			(11, 'EDITION', 'UNIT_ID', 'pcs', 7, 'шт.'),
			(12, 'PRODUCT_RATES', 'RATE_ID', 'RATE', null, '1'),
            (13, 'PRODUCT_RATES', 'RATE_ID', 'RATE', null, '2'),
            (14, 'PRODUCT_RATES', 'RATE_ID', 'RATE', null, '3'),
            (15, 'PRODUCT_RATES', 'RATE_ID', 'RATE', null, '4'),
            (16, 'PRODUCT_RATES', 'RATE_ID', 'RATE', null, '5');

-- Товары
INSERT INTO products (id, article, product_name, brand_id, categ_id) 
  VALUES	(1, 'BIO480900', 'Увлажняющий крем Aquasource для сухой кожи', 1, 14),
			(2, 'BIO800700', 'Маска ночная для лица Aquasource Everplump Night', 1, 14),
            (3, 'BIO028010', 'Гель для бритья для нормальной кожи', 1, 14),
            (4, 'BIO918114', 'Крем для рук и ногтей', 1, 15),
            (5, 'BIO240600', 'Дезодорант-спрей Deo Pure Invisible', 1, 15),
            (6, 'BIO901897', 'Дезодорант-стик Deo Pure', 1, 15),
            (7, 'CHA100210', 'Духи N°5 L’EAU', 2, 1),
            (8, 'CHA100230', 'Туалетная вода CHANCE EAU FRAICHE', 2, 1),
            (9, 'CHA100320', 'Туалетная вода ALLURE HOMME', 2, 1),
            (10, 'CHA100330', 'Духи BLEU DE CHANEL HOMME', 2, 1),
            (11, 'F02760001', 'Губная помада ROUGE DIORIFIC', 3, 5),
            (12, 'F02783028', 'Помада для губ Rouge Dior', 3, 5),
            (13, 'F02703009', 'Бальзам для губ Dior Lip Glow', 3, 6),
            (14, 'F77135169', 'Карандаш для губ Dior Contour', 3, 7), 
            (15, 'F69715090', 'Водостойкая тушь для ресниц DiorShow', 3, 9),
            (16, 'F69710090', 'Тушь для ресниц Diorshow New Look', 3, 9),
            (17, 'F77725001', 'Подводка для глаз Diorshow On Stage Liner', 3, 10),
            (18, 'F00094600', 'Гель для душа Fahrenheit', 3, 15),
            (19, 'F00180200', 'Дезодорант-стик Sauvage', 3, 15),
            (20, 'F06233560', 'Успокаивающий лосьон после бритья Dior Homme Derma System', 3, 15),
            (21, 'F09655009', 'Одеколон Fahrenheit Cologne', 3, 1);

-- Варианты выпуска товара            
INSERT INTO editions (id, product_id, feature_id, val, unit_id)
	VALUES	(1, 1, 5, '50', 8),
			(2, 2, 5, '50', 8),
            (3, 3, 5, '150', 8),
            (4, 4, 5, '75', 8),
            (5, 5, 5, '150', 8),
            (6, 6, 6, '40', 9),
            (7, 7, 5, '35', 8),
            (8, 7, 5, '50', 8),
            (9, 8, 5, '35', 8),
            (10, 8, 5, '50', 8),
            (11, 8, 5, '100', 8),
            (12, 8, 5, '150', 8),
            (13, 9, 5, '50', 8),
            (14, 9, 5, '100', 8),
            (15, 9, 5, '150', 8),
            (16, 10, 5, '100', 8),
            (17, 10, 5, '150', 8),
            (18, 11, 4, '001 Диорама 3.5 г', null),
            (19, 11, 4, '005 Триумф 3.5 г', null),
            (20, 11, 4, '014 Дольче Вита 3.5 г', null),
            (21, 12, 4, '028 Actrice, 3.5 г', null),
            (22, 12, 4, '520 Feel Good, 3.5 г', null),
            (23, 12, 4, '844 Trafalgar, 3.5 г', null),
            (24, 13, 4, '102 Матовый ягодный', null),
            (25, 13, 4, '009 Голографический фиолетовый', null),
            (26, 14, 4, '463 Bois de Rose, 1.2 г', null),
            (27, 14, 4, '999 Rouge, 1.2 г', null),
            (28, 15, 4, '090 11.5 мл', null),
            (29, 16, 4, '090 New Look Black, 10 мл', null),
            (30, 17, 4, '461 Matte Pop Green, 0.55 мл', null),
            (31, 17, 4, '176 Matte Purple, 0.55 мл', null),
            (32, 18, 5, '200', 8),
            (33, 19, 6, '75', 9),
            (34, 20, 5, '50', 8),
            (35, 21, 5, '125', 8);
            
--
-- Дальше осмысленные данные заказчиваются
--

-- Цены
CALL generate_prices;
INSERT INTO prices (edition_id, dt_beg, dt_end, price_value)
	SELECT edition_id, date_add(dt_end, INTERVAL 1 DAY), date_add(dt_end, INTERVAL 1 YEAR), ROUND(price_value * 1.1, 2)
	FROM prices;
 
-- Количество на складе 
INSERT INTO stock(edition_id, quantity)
  SELECT id, ROUND(RAND() * (10 - 1), 0)
  FROM editions;
 
-- Доп. характеристики товаров 
INSERT INTO product_features (product_id, feature_id)
  SELECT id, 2 -- товары для мужчин
  FROM products 
  WHERE id IN (3, 9, 10, 18, 19, 20, 21)
  UNION ALL
  SELECT id, 1 -- товары для женщин
  FROM products 
  WHERE id NOT IN (3, 9, 10, 18, 19, 20, 21);

-- Пользователи
INSERT INTO users(first_name, email)
  SELECT CONCAT('username', ROW_NUMBER() OVER()), CONCAT('username', ROW_NUMBER() OVER(), '@mymail.net')
  FROM products
  LIMIT 10;

-- Оценки товаров  
INSERT INTO product_rates(product_id, rate_id, user_id)
	SELECT p.id, ROUND(2 + RAND() * 3, 0) + 11, u.id
	FROM (	SELECT *
			FROM  users
			ORDER BY RAND()
			LIMIT 8) u,
		(	SELECT *
		FROM products
		ORDER BY RAND()
		LIMIT 18) p
	ORDER BY RAND()
	LIMIT 100;