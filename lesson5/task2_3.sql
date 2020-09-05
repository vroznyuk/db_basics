-- Подсчитайте произведение чисел в столбце таблицы.


select round(exp(sum(ln(value))))
from storehouses_products
where value > 0;