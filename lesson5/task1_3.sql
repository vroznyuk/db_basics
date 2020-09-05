-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
-- 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
-- Однако нулевые запасы должны выводиться в конце, после всех записей.

-- Заполним таблицу storehouses
delete from storehouses;
insert into storehouses (name)
  values ('ТЦ "Буденновский"'),
		 ('На ул. Ленинская Слобода');

-- Заполним таблицу storehouses_products
delete from storehouses_products;
insert into storehouses_products (storehouse_id, product_id, value)
	select s.id, p.id, 0 -- чтобы точно где-то были 0
	from storehouses s left join products p on true
	where p.id IN (2, 6)
	union all
	select s.id, p.id, round(rand() * 10)
	from storehouses s left join products p on true
	where p.id NOT IN (2, 6);

-- выводим с заданной сортировкой
select *
from storehouses_products
order by if(value > 0, 0, 1), value;