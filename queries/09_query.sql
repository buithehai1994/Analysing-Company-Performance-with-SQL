SELECT
	CONCAT(e.first_name,
	' ',
	e.last_name) AS full_name,
	e.title,
	CAST(SUM(od.quantity * (od.unit_price *(1-od.discount))) AS DECIMAL(10,
	2)) AS total_sales_amount_excluding_discount,
	COUNT(DISTINCT o.order_id) AS total_unique_orders,
	COUNT(o.order_id) AS total_orders,
	CAST(SUM(od.quantity * p.unit_price - od.quantity * od.discount) / COUNT(DISTINCT o.order_id) AS DECIMAL(10,
	2)) AS average_product_amount_excluding_discount,
	CAST(SUM(od.quantity * (od.unit_price - od.discount)) / COUNT(DISTINCT o.order_id) AS DECIMAL(10,
	2)) AS average_order_amount_excluding_discount,
	CAST(SUM(od.discount) AS DECIMAL(10,
	2)) AS total_discount_amount,
	CAST(SUM(od.quantity * od.unit_price) AS DECIMAL(10,
	2)) AS total_sales_amount_including_discount,
	CAST((SUM(od.discount) / SUM(od.quantity * od.unit_price)) * 100 AS DECIMAL(10,
	2)) AS total_discount_percentage
FROM
	employees e
INNER JOIN
    orders o ON
	o.employee_id = e.employee_id
INNER JOIN
    order_details od ON
	od.order_id = o.order_id
INNER JOIN
    products p ON
	p.product_id = od.product_id
GROUP BY
	e.employee_id,
	full_name,
	e.title
ORDER BY
	total_sales_amount_including_discount DESC;
