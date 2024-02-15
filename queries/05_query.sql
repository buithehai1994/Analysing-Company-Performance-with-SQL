WITH dat AS (
SELECT
	order_details.order_id,
	orders.order_date,
	products.product_id,
	products.product_name,
	order_details.quantity,
	order_details.unit_price,
	ROW_NUMBER() OVER(PARTITION BY order_details.product_id
ORDER BY
	order_date ASC) AS RN,
	ROW_NUMBER() OVER(PARTITION BY order_details.product_id
ORDER BY
	order_date DESC) AS RN1
FROM
	order_details
INNER JOIN 
		orders ON
	order_details.order_id = orders.order_id
INNER JOIN 
		products ON
	order_details.product_id = products.product_id
ORDER BY
	product_name,
	order_date ASC
),
base_price AS (
SELECT
	product_id,
	unit_price
FROM
	dat
WHERE
	rn = 1
)
,
current_price AS (
SELECT
	product_id,
	unit_price
FROM
	dat
WHERE
	rn1 = 1
)
SELECT
	DISTINCT(dat.product_id),
	dat.product_name,
	CAST((
	SELECT
		unit_price
	FROM
		dat AS d2
	WHERE
		d2.product_id = dat.product_id
		AND d2.rn1 = 1
    ) AS NUMERIC(10,
	2)) AS current_price,
	CAST(base_price.unit_price AS NUMERIC(10,
	2)) AS base_price,
	100 * (
        CAST((
	SELECT
		unit_price
	FROM
		dat AS d3
	WHERE
		d3.product_id = dat.product_id
		AND d3.rn1 = 1
        ) AS NUMERIC(10,
	2)) - base_price.unit_price
    ) / base_price.unit_price AS percentage_increase
FROM
	dat
INNER JOIN 
    base_price
ON
	dat.product_id = base_price.product_id
WHERE
	(
        100 * (
            CAST((
	SELECT
		unit_price
	FROM
		dat AS d4
	WHERE
		d4.product_id = dat.product_id
		AND d4.rn1 = 1
            ) AS NUMERIC(10,
	2)) - base_price.unit_price
        ) / base_price.unit_price < 20
		OR 
        100 * (
            CAST((
		SELECT
			unit_price
		FROM
			dat AS d5
		WHERE
			d5.product_id = dat.product_id
			AND d5.rn1 = 1
            ) AS NUMERIC(10,
		2)) - base_price.unit_price
        ) / base_price.unit_price > 30
    )
	AND (
        CAST((
	SELECT
		unit_price
	FROM
		dat AS d6
	WHERE
		d6.product_id = dat.product_id
		AND d6.rn1 = 1
        ) AS NUMERIC(10,
	2)) - base_price.unit_price
    ) > 0
ORDER BY
	percentage_increase ASC;