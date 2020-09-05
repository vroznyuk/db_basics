-- Подсчитайте средний возраст пользователей в таблице users

select avg(floor((TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25))
from users