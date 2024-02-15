WITH category_stats AS (
SELECT
	c.category_name,
	AVG(p.unit_price) AS category_avg_price,
	PERCENTILE_CONT(0.5) WITHIN GROUP (
	ORDER BY p.unit_price) AS category_median_price
FROM
	categories c
INNER JOIN products p ON
	c.category_id = p.category_id
WHERE
	p.discontinued = 0
GROUP BY
	c.category_name
)
SELECT
	c.category_name,
	p.product_name,
	p.unit_price,
	CAST(cs.category_avg_price AS DECIMAL(10,
	2)) AS category_avg_price,
	CAST(cs.category_median_price AS DECIMAL(10,
	2)) AS category_median_price,
	CASE
		WHEN p.unit_price < cs.category_avg_price THEN 'Below Average'
		WHEN p.unit_price = cs.category_avg_price THEN 'Equal Average'
		ELSE 'Over Average'
	END AS position_avg_price,
	CASE
		WHEN p.unit_price < cs.category_median_price THEN 'Below Median'
		WHEN p.unit_price = cs.category_median_price THEN 'Equal Median'
		ELSE 'Over Median'
	END AS position_median_price
FROM
	products p
INNER JOIN categories c ON
	p.category_id = c.category_id
INNER JOIN category_stats cs ON
	c.category_name = cs.category_name
WHERE
	p.discontinued = 0
ORDER BY
	c.category_name ASC,
	p.product_name ASC;
