-- =====================================================================
-- BDA Data Analitika | SQL Final Layihə | Mərhələ 1: Data Profiling
-- =====================================================================

-- Task 1.1: Bütün 7 HR cədvəlinin və perf_reviews_raw-un sətir sayı
SELECT 'EMPLOYEES' AS table_name, COUNT(*) AS row_count FROM hr.employees
UNION ALL
SELECT 'DEPARTMENTS', COUNT(*) FROM hr.departments
UNION ALL
SELECT 'JOBS', COUNT(*) FROM hr.jobs
UNION ALL
SELECT 'JOB_HISTORY', COUNT(*) FROM hr.job_history
UNION ALL
SELECT 'LOCATIONS', COUNT(*) FROM hr.locations
UNION ALL
SELECT 'COUNTRIES', COUNT(*) FROM hr.countries
UNION ALL
SELECT 'REGIONS', COUNT(*) FROM hr.regions
UNION ALL
SELECT 'PERF_REVIEWS_RAW', COUNT(*) FROM perf_reviews_raw;

-- Task 1.2: hr.employees-də department_id, manager_id, commission_pct NULL sayı
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(department_id) AS dept_nulls,
    COUNT(*) - COUNT(manager_id) AS mgr_nulls,
    COUNT(*) - COUNT(commission_pct) AS comm_nulls
FROM hr.employees;

-- Task 1.3: NULL-ların oxunaqlı göstərilməsi (NVL, NVL2, COALESCE)
SELECT 
    employee_id,
    NVL(TO_CHAR(department_id), 'Şöbəsiz') AS dept_status,
    NVL2(commission_pct, 'Komissiyası var', '0') AS commission_status,
    COALESCE(TO_CHAR(manager_id), 'Top manager') AS manager_status
FROM hr.employees;

-- Task 1.4: perf_reviews_raw profili (rəqəmsal sütunlar üzrə MIN, MAX, AVG, NULL sayları)
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(perf_score) AS score_nulls,
    MIN(perf_score) AS min_score,
    MAX(perf_score) AS max_score,
    ROUND(AVG(perf_score), 2) AS avg_score,
    COUNT(*) - COUNT(overtime_hours) AS overtime_nulls,
    MIN(overtime_hours) AS min_overtime,
    MAX(overtime_hours) AS max_overtime,
    ROUND(AVG(overtime_hours), 2) AS avg_overtime
FROM perf_reviews_raw;

-- review_year üzrə sətir sayı
SELECT review_year, COUNT(*) AS row_count
FROM perf_reviews_raw
GROUP BY review_year;

-- Task 1.5: rating_label fərqli yazılışları və sayları
SELECT rating_label, COUNT(*) AS say 
FROM perf_reviews_raw 
GROUP BY rating_label;

-- Task 1.7: FULL OUTER JOIN ilə orphan və qiymətləndirilməmiş işçilərin tapılması
SELECT 
    NVL(p.employee_id, e.employee_id) AS employee_id,
    CASE 
        WHEN e.employee_id IS NULL THEN 'Orphan (HR-də yoxdur)'
        WHEN p.employee_id IS NULL THEN 'Qiymətləndirilməyib'
        ELSE 'Hər ikisində var'
    END AS status
FROM perf_reviews_raw p
FULL OUTER JOIN hr.employees e ON p.employee_id = e.employee_id
WHERE p.employee_id IS NULL OR e.employee_id IS NULL;
