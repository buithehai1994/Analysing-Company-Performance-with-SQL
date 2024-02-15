SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_full_name,
    e.title AS employee_job_title,
    DATE_PART('year', AGE(e.hire_date, e.birth_date)) AS age_at_hire,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_full_name,
    m.title AS manager_job_title
FROM 
    employees e
LEFT JOIN 
    employees m ON e.reports_to = m.employee_id
ORDER BY 
    age_at_hire ASC, employee_full_name ASC;