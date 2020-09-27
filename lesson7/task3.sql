-- Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

SELECT flights.id, city_from.name from_, city_to.name to_
FROM  flights, cities city_from, cities city_to
WHERE flights.from$ = city_from.label
  AND flights.to$ = city_to.label
ORDER BY 1;

/*

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id serial,
  from$ VARCHAR(255) COMMENT 'Откуда',
  to$ VARCHAR(255) COMMENT 'Куда'
) COMMENT = 'Рейсы';

INSERT INTO flights (from$, to$)
	  VALUES ('moscow', 'omsk'),
			 ('novgorod', 'kazan'),
			 ('irkutsk', 'moscow'),
			 ('omsk', 'irkutsk'),
			 ('moscow', 'kazan');

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  label VARCHAR(255) COMMENT 'Метка',
  name VARCHAR(255) COMMENT 'Название'
) COMMENT = 'Города';
 
INSERT INTO cities (label, name)
	VALUES	('moscow', 'Москва'),
			('omsk', 'Омск'),
			('novgorod', 'Новгород'),
            ('kazan', 'Казань'),
            ('irkutsk', 'Иркутск');
*/
