-- Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

select *
from users
where lower(date_format(birthday_at, '%M')) in ('may', 'august')