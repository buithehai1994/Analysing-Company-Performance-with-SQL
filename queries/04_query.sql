SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS year_month,
    COUNT(order_id) AS total_orders,
    CAST(TRUNC(SUM(freight)) AS INTEGER) AS total_freight
FROM 
    orders
WHERE 
    EXTRACT(year FROM order_date) BETWEEN 1997 AND 1998
GROUP BY 
    TO_CHAR(order_date, 'YYYY-MM')
HAVING 
    COUNT(order_id) > 35
ORDER BY 
    total_freight DESC;
