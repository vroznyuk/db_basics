-- Рейтинг товаров в разрезе категории
WITH t AS ( SELECT c.id, COUNT(r.rate_id) cnt
			FROM products p 
				INNER JOIN categories c ON c.id = p.categ_id 
                LEFT JOIN product_rates r ON r.product_id = p.id
			GROUP BY c.categ_name
		  )
	SELECT c.categ_name, p.product_name, IF(t.cnt = 0, 0, COALESCE(total_product_rate(p.id), 0)/t.cnt)
	FROM products p
		INNER JOIN categories c ON c.id = p.categ_id
		INNER JOIN t ON t.id = c.id
ORDER BY 1, 3 DESC;

-- Товары, получившие хотя бы одну оценку и отсутствующие на складе
SELECT p.id, p.descript, COUNT(r.rate_id)
FROM product_rates r 
	RIGHT JOIN products p ON p.id = r.product_id
WHERE NOT EXISTS ( 	SELECT 1
					FROM editions e 
						INNER JOIN stock s ON s.edition_id = e.id 
					WHERE e.product_id = p.id
					AND s.quantity > 0
			   	 )
GROUP BY p.id, p.descript
HAVING  COUNT(r.rate_id) > 0;

-- Пользователи, поставившие наименьшее количество оценок 
SELECT u.first_name, count(r.rate_id)
FROM users u
	INNER JOIN product_rates r ON r.user_id = u.id
GROUP BY u.first_name
HAVING count(r.rate_id) = (	SELECT MIN(t.cnt) 
							FROM (	SELECT user_id, COUNT(rate_id) cnt
									FROM product_rates
									GROUP BY user_id
									HAVING COUNT(rate_id) > 0
								) t
						 )
ORDER BY 1;
    
