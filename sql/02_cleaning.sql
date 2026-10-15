-- =====================================================================
-- BDA Data Analitika | SQL Final Layihə | Mərhələ 2: Data Cleaning
-- =====================================================================

-- 2.1 PERF_REVIEWS cədvəlinin yaradılması (Constraint-lərlə və xüsusi adlarla)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE perf_reviews PURGE';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE perf_reviews (
   review_id           NUMBER CONSTRAINT pk_perf_reviews PRIMARY KEY,
   employee_id         NUMBER NOT NULL,
   review_year         NUMBER NOT NULL,
   review_date         DATE,
   perf_score          NUMBER(2,1),
   rating_label        VARCHAR2(20),
   projects_completed  NUMBER,
   overtime_hours      NUMBER,
   -- Constraint adlandırmaları
   CONSTRAINT chk_score CHECK (perf_score BETWEEN 1 AND 5),
   CONSTRAINT chk_rating CHECK (rating_label IN ('Exceeds', 'Meets', 'Below')),
   CONSTRAINT chk_overtime CHECK (overtime_hours BETWEEN 0 AND 400),
   CONSTRAINT chk_projects CHECK (projects_completed >= 0),
   CONSTRAINT uq_emp_year UNIQUE (employee_id, review_year)
);

-- 2.2 Sequence yaradılması
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE perf_review_seq';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE SEQUENCE perf_review_seq START WITH 1 INCREMENT BY 1;


-- =====================================================================
-- 2.3 – 2.7: AYRI-AYRI SELECT YOXLAMALARI (İş qaydasına uyğun olaraq)
-- =====================================================================

-- 2.3: Dublikatların ROW_NUMBER() vasitəsilə yoxlanılması (rn > 1 olanlar)
SELECT * FROM (
   SELECT p.*,
      ROW_NUMBER() OVER (PARTITION BY employee_id, review_year ORDER BY review_id) AS rn
   FROM perf_reviews_raw p
)
WHERE rn > 1;

-- 2.4: Orphan sətirlərin NOT EXISTS ilə yoxlanılması
SELECT * 
FROM perf_reviews_raw p
WHERE NOT EXISTS (
   SELECT 1 FROM hr.employees e WHERE e.employee_id = p.employee_id
);

-- 2.5: Tarix formatlarının və il uyğunluğunun yoxlanılması
SELECT review_id, employee_id, review_year, review_date,
   CASE 
      WHEN review_date LIKE '____-__-__' AND EXTRACT(YEAR FROM TO_DATE(review_date, 'YYYY-MM-DD')) = review_year THEN TO_DATE(review_date, 'YYYY-MM-DD')
      WHEN review_date LIKE '__.__.____' AND EXTRACT(YEAR FROM TO_DATE(review_date, 'DD.MM.YYYY')) = review_year THEN TO_DATE(review_date, 'DD.MM.YYYY')
      ELSE NULL
   END AS checked_date
FROM perf_reviews_raw;

-- 2.6: Aralıqdan kənar dəyərlərin (score, overtime, projects) yoxlanılması
SELECT review_id, perf_score, overtime_hours, projects_completed,
   CASE WHEN perf_score BETWEEN 1 AND 5 THEN perf_score END AS chk_score,
   CASE WHEN overtime_hours BETWEEN 0 AND 400 THEN overtime_hours END AS chk_overtime,
   CASE WHEN projects_completed >= 0 THEN projects_completed END AS chk_projects
FROM perf_reviews_raw;

-- 2.7: rating_label yenidən hesablanması və uyğunsuzluqların yoxlanılması
SELECT review_id, rating_label AS raw_label,
   INITCAP(TRIM(rating_label)) AS cleaned_raw_label,
   CASE 
      WHEN perf_score BETWEEN 1 AND 5 THEN
         CASE 
            WHEN perf_score >= 4.0 THEN 'Exceeds'
            WHEN perf_score BETWEEN 3.0 AND 3.9 THEN 'Meets'
            ELSE 'Below'
         END
      ELSE NULL
   END AS calculated_label
FROM perf_reviews_raw;


-- =====================================================================
-- 2.8: INSERT INTO ... SELECT İLƏ BÜTÜN TƏMİZLƏMƏNİN BİR BÜTÖV İCRASI
-- =====================================================================

INSERT INTO perf_reviews (
   review_id,
   employee_id,
   review_year,
   review_date,
   perf_score,
   rating_label,
   projects_completed,
   overtime_hours
)
SELECT 
   perf_review_seq.NEXTVAL,
   employee_id,
   review_year,
   -- Tarix təmizliyi (format və il uyğunluğu)
   CASE 
      WHEN review_date LIKE '____-__-__' AND EXTRACT(YEAR FROM TO_DATE(review_date, 'YYYY-MM-DD')) = review_year THEN TO_DATE(review_date, 'YYYY-MM-DD')
      WHEN review_date LIKE '__.__.____' AND EXTRACT(YEAR FROM TO_DATE(review_date, 'DD.MM.YYYY')) = review_year THEN TO_DATE(review_date, 'DD.MM.YYYY')
      ELSE NULL
   END AS review_date,
   -- Score təmizliyi
   CASE WHEN perf_score BETWEEN 1 AND 5 THEN perf_score ELSE NULL END AS perf_score,
   -- Rating label hesabatı
   CASE 
      WHEN (CASE WHEN perf_score BETWEEN 1 AND 5 THEN perf_score ELSE NULL END) >= 4.0 THEN 'Exceeds'
      WHEN (CASE WHEN perf_score BETWEEN 1 AND 5 THEN perf_score ELSE NULL END) BETWEEN 3.0 AND 3.9 THEN 'Meets'
      WHEN (CASE WHEN perf_score BETWEEN 1 AND 5 THEN perf_score ELSE NULL END) < 3.0 THEN 'Below'
      ELSE NULL
   END AS rating_label,
   -- Projects təmizliyi
   CASE WHEN projects_completed >= 0 THEN projects_completed ELSE NULL END AS projects_completed,
   -- Overtime təmizliyi
   CASE WHEN overtime_hours BETWEEN 0 AND 400 THEN overtime_hours ELSE NULL END AS overtime_hours
FROM (
   SELECT 
      p.*,
      ROW_NUMBER() OVER (
         PARTITION BY employee_id, review_year 
         ORDER BY review_id
      ) AS rn
   FROM perf_reviews_raw p
   WHERE EXISTS (
      SELECT 1 FROM hr.employees e WHERE e.employee_id = p.employee_id
   )
)
WHERE rn = 1;

COMMIT;


-- =====================================================================
-- 2.9: BEFORE/AFTER HESABATI (UNION ALL İLƏ)
-- =====================================================================

SELECT '1. Raw Total Rows' AS metrik, COUNT(*) AS say FROM perf_reviews_raw
UNION ALL
SELECT '2. Deleted Duplicates', COUNT(*) FROM (
   SELECT employee_id, review_year FROM perf_reviews_raw
   GROUP BY employee_id, review_year HAVING COUNT(*) > 1
)
UNION ALL
SELECT '3. Deleted Orphans', COUNT(*) FROM perf_reviews_raw p
WHERE NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.employee_id = p.employee_id)
UNION ALL
SELECT '4. Invalid Scores Nullified', COUNT(*) FROM perf_reviews_raw WHERE perf_score NOT BETWEEN 1 AND 5 OR perf_score IS NULL
UNION ALL
SELECT '5. Invalid Dates Nullified', COUNT(*) FROM perf_reviews_raw 
WHERE (review_date NOT LIKE '____-__-__' AND review_date NOT LIKE '__.__.____')
   OR (review_date LIKE '____-__-__' AND EXTRACT(YEAR FROM TO_DATE(review_date, 'YYYY-MM-DD')) <> review_year)
   OR (review_date LIKE '__.__.____' AND EXTRACT(YEAR FROM TO_DATE(review_date, 'DD.MM.YYYY')) <> review_year)
UNION ALL
SELECT '6. Invalid Overtime Nullified', COUNT(*) FROM perf_reviews_raw WHERE overtime_hours NOT BETWEEN 0 AND 400 OR overtime_hours IS NULL
UNION ALL
SELECT '7. Cleaned Total Rows in PERF_REVIEWS', COUNT(*) FROM perf_reviews;
