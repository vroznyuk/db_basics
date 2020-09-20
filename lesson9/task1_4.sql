-- Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

DELETE t1 FROM task3_calendar t1 JOIN (SELECT * FROM task3_calendar ORDER BY created_at DESC LIMIT 5, 1) t2 ON t1.created_at <= t2.created_at;