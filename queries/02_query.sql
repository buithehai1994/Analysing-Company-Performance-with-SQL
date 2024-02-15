SELECT 
    ship_country,
    ROUND(AVG((shipped_date - order_date)::numeric), 2) AS average_days_between_order_and_shipping,
    COUNT(DISTINCT order_id) AS total_unique_orders
FROM
    orders
WHERE
    EXTRACT(YEAR FROM order_date) = 1998
GROUP BY
    ship_country
HAVING
    AVG((shipped_date - order_date)::numeric) >= 5
    AND COUNT(DISTINCT order_id) > 10
ORDER BY
    ship_country;