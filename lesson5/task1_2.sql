-- Таблица users была неудачно спроектирована. 
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

-- Копия таблицы для тренировки
CREATE TABLE users_ (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(16),
  updated_at VARCHAR(16)
) COMMENT = 'Покупатели - тест';

-- Даты преобразуем в "плохой" вид - строка dd.mm.yyyy hh:mi
insert into users_ (name, birthday_at, created_at, updated_at)
	select name, birthday_at, date_format(created_at, "%d.%m.%Y %H:%i"), date_format(updated_at, "%d.%m.%Y %H:%i")
	from users;

-- Преобразуем даты в "правильный" формат - строка yyyy-mm-dd hh:mi
update users_
set created_at = date_format(str_to_date(created_at, "%d.%m.%Y %H:%i"), "%Y-%m-%d %H:%i"),
    updated_at = date_format(str_to_date(updated_at, "%d.%m.%Y %H:%i"), "%Y-%m-%d %H:%i");

-- Изменяем тип столбцов
alter table users_ modify created_at DATETIME;
alter table users_ modify updated_at DATETIME;

