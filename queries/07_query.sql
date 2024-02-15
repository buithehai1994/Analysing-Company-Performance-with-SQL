SELECT
	c.category_name,
	s.country,
	SUM(p.unit_in_stock) AS total_units_in_stock,
	SUM(p.unit_on_order) AS total_units_on_order,
	SUM(p.reorder_level) AS total_reorder_level,
	CASE
		WHEN s.country IN ('Italy', 'Sweden', 'Germany', 'Finland', 'France', 'Denmark', 'Norway', 'Netherlands', 'UK', 'Spain') THEN 'Europe'
		WHEN s.country IN('USA', 'Canada', 'Brazil') THEN 'America'
		WHEN s.country IN ('Singapore', 'Japan', 'Australia') THEN 'Asia-Pacific'
	END AS
    	supplier_region
FROM
	suppliers s
INNER JOIN
    products p ON
	s.supplier_id = p.supplier_id
INNER JOIN
    categories c ON
	p.category_id = c.category_id
GROUP BY
	s.country,
	c.category_name
ORDER BY
	c.category_name ASC,
	s.country ASC,
	total_reorder_level ASC