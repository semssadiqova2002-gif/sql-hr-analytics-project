-- =====================================================================
-- BDA Data Analitika | SQL Final Layihə | Mərhələ 3: Views və DB Obyektləri
-- Fayl adı: sql/03_views_objects.sql
-- =====================================================================

-- ---------------------------------------------------------------------
-- 3.1: V_EMPLOYEE_FULL View-nun yaradılması (6 cədvəl JOIN)
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_employee_full AS
SELECT 
   e.employee_id,
   e.first_name || ' ' || e.last_name AS full_name,
   e.job_id,
   j.job_title,
   e.salary,
   j.min_salary,
   j.max_salary,
   -- compa_ratio = salary / ((min_salary + max_salary) / 2)
   ROUND(e.salary / NULLIF((j.min_salary + j.max_salary) / 2, 0), 2) AS compa_ratio,
   e.department_id,
   NVL(d.department_name, 'Şöbəsiz') AS department_name,
   l.city,
   c.country_name,
   r.region_name,
   e.manager_id,
   e.hire_date,
   -- tenure_years = (Cari tarix - hire_date) / 365.25
   ROUND((SYSDATE - e.hire_date) / 365.25, 1) AS tenure_years
FROM hr.employees e
JOIN hr.jobs j ON e.job_id = j.job_id
LEFT JOIN hr.departments d ON e.department_id = d.department_id
LEFT JOIN hr.locations l ON d.location_id = l.location_id
LEFT JOIN hr.countries c ON l.country_id = c.country_id
LEFT JOIN hr.regions r ON c.region_id = r.region_id;


-- ---------------------------------------------------------------------
-- 3.2: Sətir sayının yoxlanılması və INNER JOIN müqayisəsi
-- ---------------------------------------------------------------------
-- LEFT JOIN ilə sətir sayı:
SELECT COUNT(*) AS total_rows_left_join FROM v_employee_full;

-- INNER JOIN ilə yoxlama sorğusu:
SELECT COUNT(*) AS total_rows_inner_join
FROM hr.employees e
JOIN hr.jobs j ON e.job_id = j.job_id
JOIN hr.departments d ON e.department_id = d.department_id
JOIN hr.locations l ON d.location_id = l.location_id
JOIN hr.countries c ON l.country_id = c.country_id
JOIN hr.regions r ON c.region_id = r.region_id;

/*
  ŞƏRH (3.2):
  LEFT JOIN istifadə etdikdə şöbəsi olmayan (department_id IS NULL olan) işçilər 
  də nəticədə görünür və məlumat itmir. Əgər INNER JOIN istifadə etsəydik, şöbəsi 
  olmayan işçilər (məsələn, Kimberely Grant) nəticədən kənarda qalacaqdı və sətir sayı azalacaqdı.
*/


-- ---------------------------------------------------------------------
-- 3.3: V_PERF_2025 View-nun yaradılması
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_perf_2025 AS
SELECT 
   v.*,
   p.review_id,
   p.review_year,
   p.review_date,
   p.perf_score,
   p.rating_label,
   p.projects_completed,
   p.overtime_hours
FROM v_employee_full v
JOIN perf_reviews p ON v.employee_id = p.employee_id
WHERE p.review_year = 2025;


-- ---------------------------------------------------------------------
-- 3.4: V_DEPT_SUMMARY View-nun yaradılması
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dept_summary AS
SELECT 
   v.department_name,
   COUNT(DISTINCT v.employee_id) AS total_employees,
   ROUND(AVG(v.salary), 2) AS avg_salary,
   ROUND(AVG(v.compa_ratio), 2) AS avg_compa_ratio,
   ROUND(AVG(p.perf_score), 2) AS avg_perf_score,
   ROUND(AVG(p.overtime_hours), 2) AS avg_overtime
FROM v_employee_full v
LEFT JOIN perf_reviews p ON v.employee_id = p.employee_id AND p.review_year = 2025
GROUP BY v.department_name;


-- ---------------------------------------------------------------------
-- 3.5: SYNONYM yaradılması və istifadəsi
-- ---------------------------------------------------------------------
-- FreeSQL icazə verməzsə xəta verə bilər:
CREATE SYNONYM emp FOR hr.employees;

-- Sinonom üzərindən sorğu:
SELECT COUNT(*) FROM emp;

/*
  ŞƏRH (3.5):
  FreeSQL istifadəçi hüquqlarını məhdudlaşdırdığı üçün "ORA-01031: insufficient privileges"
  xətası verə bilər. Bu halda sistem inzibatçısı CREATE SYNONYM səlahiyyəti verməlidir.
*/


-- ---------------------------------------------------------------------
-- 3.6: DCL əmrləri (GRANT / REVOKE)
-- ---------------------------------------------------------------------
/* 
  GRANT SELECT ON v_dept_summary TO hr_analyst;
  REVOKE SELECT ON v_dept_summary FROM hr_analyst;

  ŞƏRH (3.6):
  Bu sorğular "hr_analyst" istifadəçisinə v_dept_summary görüntüsünü oxumaq icazəsi verir
  və daha sonra bu icazəni geri alır. FreeSQL-də icazə (privilege) çatışmazlığı xətası 
  verəcəyi üçün şərh blokunda saxlanılmışdır.
*/


-- ---------------------------------------------------------------------
-- 3.7: BONUS (+3): MATERIALIZED VIEW yaradılması
-- ---------------------------------------------------------------------
/*
  CREATE MATERIALIZED VIEW mv_dept_summary AS
  SELECT * FROM v_dept_summary;

  ŞƏRH (3.7):
  Adi VIEW sorğunu hər dəfə icra edərək datanı canlı gətirir. MATERIALIZED VIEW isə 
  sorğunun nəticəsini fiziki olaraq diskdə saxlayır. Bu, böyük datalarda oxuma sürətini 
  artırır, lakin məlumat yeniləndikdə REFRESH tələb edir.
*/
