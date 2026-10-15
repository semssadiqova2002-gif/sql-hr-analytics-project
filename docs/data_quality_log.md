# Data Quality Log - HR Performance Reviews

| # | Issue | Column | Rows affected | Detection query | Fix strategy |
|---|---|---|---|---|---|
| 1 | Duplicate reviews | employee_id, review_year | ~2+ | Task 1.6 / ROW_NUMBER | Keep latest/first using ROW_NUMBER() |
| 2 | Orphan records | employee_id | Varies | Task 1.6 / NOT EXISTS | Filter out IDs not in hr.employees |
| 3 | Invalid date format | review_date | Varies | Task 1.6 / LIKE | Standardize using CASE and TO_DATE |
| 4 | Out-of-range score | perf_score | Varies | Task 1.6 / BETWEEN | Set invalid scores (<1 or >5) to NULL |
| 5 | Out-of-range overtime | overtime_hours | Varies | Task 1.6 / BETWEEN | Set invalid overtime (<0 or >400) to NULL |
| 6 | Inconsistent rating labels | rating_label | Varies | Task 1.5 / DISTINCT | Recalculate rating_label from perf_score |
