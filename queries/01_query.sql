SELECT
	product_name,
	unit_price
FROM
	products
WHERE
	(unit_price BETWEEN 20 AND 50)
	AND discontinued = 0
ORDER BY
	unit_price DESC