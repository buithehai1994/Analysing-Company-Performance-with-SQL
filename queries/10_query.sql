SELECT
	categories.category_name,
	CONCAT(employees.first_name,
	' ',
	employees.last_name) AS full_name,
	CAST(SUM(order_details.quantity * (1 - order_details.discount)) AS NUMERIC(10,
	2)) AS total_sales_amount_including_discount,
	CAST((SUM(order_details.quantity * (1 - order_details.discount))) /
          NULLIF(SUM(SUM(order_details.quantity * (1 - order_details.discount))) OVER(PARTITION BY employees.employee_id),
	0) * 100 AS NUMERIC(10,
	5)) AS percentage_of_total_sales_per_employee,
	CAST((SUM(order_details.quantity * (1 - order_details.discount))) /
          NULLIF(SUM(SUM(order_details.quantity * (1 - order_details.discount))) OVER(PARTITION BY categories.category_name),
	0) * 100 AS NUMERIC(10,
	5)) AS percentage_of_total_sales_per_category
FROM
	employees
INNER JOIN
    orders ON
	employees.employee_id = orders.employee_id
INNER JOIN
    order_details ON
	orders.order_id = order_details.order_id
INNER JOIN
    products ON
	order_details.product_id = products.product_id
INNER JOIN
    categories ON
	products.category_id = categories.category_id
GROUP BY
	categories.category_name,
	employees.employee_id,
	full_name
ORDER BY
	categories.category_name ASC,
	total_sales_amount_including_discount DESC;
