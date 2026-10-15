CREATE OR REPLACE VIEW v_employee_full AS
SELECT 
   e.employee_id,
   e.first_name || ' ' || e.last_name AS full_name,
   e.job_id,
   j.job_title,
   e.salary,
   j.min_salary,
   j.max_salary,
   ROUND(e.salary / NULLIF((j.min_salary + j.max_salary) / 2, 0), 2) AS compa_ratio,
   e.department_id,
   NVL(d.department_name, 'Şöbəsiz') AS department_name,
   l.city,
   c.country_name,
   r.region_name,
   e.manager_id,
   e.hire_date,
   ROUND((SYSDATE - e.hire_date) / 365.25, 1) AS tenure_years
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN locations l ON d.location_id = l.location_id
LEFT JOIN countries c ON l.country_id = c.country_id
LEFT JOIN regions r ON c.region_id = r.region_id;
