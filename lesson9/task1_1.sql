-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции

START TRANSACTION;

-- По-хорошему здесь нужен список столбцов, но я точно знаю, что таблицы имеют одинаковую структуру, поэтому опущу список
INSERT INTO sample.users 
  SELECT *
  FROM shop.users
  WHERE id = 1;

DELETE FROM shop.users WHERE id = 1;

COMMIT;