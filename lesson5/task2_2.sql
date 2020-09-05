-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

select date_format(str_to_date(concat_ws('-', year(now()), date_format(birthday_at, '%m-%d')), '%Y-%m-%d'), '%W'), count(*)
from users
group by 1;