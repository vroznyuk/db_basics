-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

update users
set created_at = NOW()
where created_at is null;

update users
set updated_at = NOW()
where updated_at is null;