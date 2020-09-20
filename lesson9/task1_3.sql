-- Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

use shop;
create table if not exists task3_calendar 
  (created_at DATE
  );
 
insert into task3_calendar 
  values ('2018-07-23'),
		 ('2018-08-01'),
         ('2018-08-04'),
         ('2018-08-16'),
         ('2018-08-17'),
         ('2019-01-10'),
         ('2019-08-01');
  
-- это решение не универсальное
SELECT seq.dt, 
	   IFNULL((SELECT 1 FROM task3_calendar WHERE created_at = seq.dt), 0)
FROM (SELECT ADDDATE('2018-08-01', @i := @i + 1 ) AS dt FROM (SELECT @i := -1) t, products p1, products p2 LIMIT 31) seq