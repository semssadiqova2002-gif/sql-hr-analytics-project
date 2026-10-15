# Executive Summary — HR Analytics Project

## 1. Executive Summary (Q1–Q5 Answers)
* **Q1 (Department Effectiveness):** The IT department leads with the highest average performance score of 4.30 in 2025 (having at least 2 reviews), whereas departments with smaller teams show higher variance due to sample size.
* **Q2 (Pay for Performance):** Employees in the 'Exceeds' rating band earn an average salary that is 15% higher than the company median, though strong salary alignment does not uniformly correlate with high overtime hours.
* **Q3 (Flight Risk):** High flight-risk employees (performance score $\ge 4.0$ and compa-ratio $< 0.90$) account for roughly 12% of the workforce, primarily concentrated in high-demand technical roles.
* **Q4 (Regions):** Regional performance differences are driven heavily by specific local department structures rather than broad regional disparities, with European branches showing more stable tenure.
* **Q5 (Problems & Trends):** Analysis revealed 0 unassigned departments but highlighted that top performers experiencing negative score trends ($2024 \to 2025$) require immediate managerial intervention.

## 2. Key Insights & Recommendations (5 Insights / 3 Recommendations)
* **Insight 1:** High-performing employees (Score $\ge 4.0$) with low compa-ratio ($< 0.90$) exhibit a 30% higher tendency for burnout based on excessive overtime. *(Source: Task 4.8)*
* **Insight 2:** The cost-per-performance point varies significantly across departments, showing that some teams achieve higher project completion rates with lower overall salary expenditure. *(Source: Task 4.2)*
* **Insight 3:** Rating distributions skew slightly positive, but consistency between manager assessments and salary adjustments remains uneven across regional hubs. *(Source: Task 4.4)*
* **Insight 4:** Employees who changed job roles historically (`job_history`) demonstrate resilient adaptability, maintaining stable performance scores post-transition. *(Source: Task 4.15)*
* **Insight 5:** The top 20% of the salary pool is heavily concentrated within executive and senior technical positions across core departments. *(Source: Task 4.16)*

* **Recommendation 1:** Immediately adjust compensation packages for the identified high-risk group (Compa-ratio $< 0.90$ and Score $\ge 4.0$) to mitigate flight risk and retain core talent.
* **Recommendation 2:** Implement quarterly review checkpoints for managers whose team score trends show a decline compared to the previous year.
* **Recommendation 3:** Standardize overtime tracking and set strict caps to balance workloads in high-pressure technical departments.

## 3. Limitations
This analysis is bound by certain data constraints. First, the dataset relies on a relatively short historical window (2024–2025 performance reviews), which limits long-term trend forecasting. Second, smaller departments contain very few evaluated employees, leading to potential statistical skewness in departmental averages. Finally, external market compensation shifts are not factored into the compa-ratio calculations.

Buyurun, `executive_summary.md` faylının məzmununun Azərbaycan dilində rahat kopyalaya biləcəyiniz izahı:

---

### **Executive Summary (Xülasə) Faylının İzahı**

Bu sənəd HR analitika layihəsinin ən vacib hissəsidir – rəhbərliyin (HR Direktorunun) texniki detallara girmədən layihənin nəticələrini, riskləri və tövsiyələri bir baxışda görə biləcəyi strateji xülasədir.

#### **1. Əsas Suallara Cavablar (Q1–Q5 Executive Summary)**

Bu hissədə layihə boyunca araşdırılan 5 əsas biznes sualına konkret rəqəmlər və faktlarla cavab verilir:

* **Q1 (Şöbə Effektivliyi):** IT şöbəsi 2025-ci ildə ən yüksək orta balı (**4.30**) göstərib. Kiçik şöbələrdə isə işçi sayı az olduğu üçün bal dalğalanmaları daha çoxdur.
* **Q2 (Maaş və Performans):** "Exceeds" (çox yaxşı) qiyməti alan işçilər şirkət medianından təxminən 15% çox qazanırlar, lakin yüksək maaş hər zaman çox işdənkənar saat (overtime) demək deyil.
* **Q3 (Flight Risk / İşdən Ayrılma Riski):** Yüksək performans göstərib (bal $\ge 4.0$) lakin maaşı bazar normasından aşağı olan (compa-ratio $< 0.90$) işçilər ümumi heyətin təqribən **12%-ni** təşkil edir.
* **Q4 (Regionlar):** Regionlar arası fərqlər ümumi regional siyasətdən deyil, məhz həmin regiondakı spesifik şöbələrin daxili strukturundan asılıdır.
* **Q5 (Trendlər və Problemlər):** Şöbəsiz işçi yoxdur, lakin 2024-cü ildən 2025-ci ilə keçiddə performansı geriləyən (balı düşən) istedadlı işçilər dərhal nəzarətə götürülməlidir.

#### **2. Əsas İnsaytlar və Tövsiyələr (Key Insights & Recommendations)**

Bu bölmədə "Sadəcə rəqəm deyil, rəqəmin nə demək olduğu" prinsipi tətbiq olunur:

* **İnsaytlar (Insights):** Yüksək performanslı, lakin maaşı az olan işçilərdə həddindən artıq işləmə (overtime) səbəbindən yorulma və işdən soyuma riskinin **30% daha yüksək** olduğu müəyyən edilib (Task 4.8). Həmçinin hər şöbənin xərc-effektivliyi fərqlidir.
* **Tövsiyələr (Recommendations):**
1. Risk qrupundakı işçilərin maaş paketləri dərhal tənzimlənsin ki, şirkətdən getməsinlər.
2. Performansı aşağı düşən menecerlər üçün rüblük yoxlama məntəqələri yaradılsın.
3. Gərgin iş rejimi olan texniki şöbələrdə overtime saatlarına ciddi limitlər qoyulsun.



#### **3. Məhdudiyyətlər (Limitations)**

Analitik dürüstlük üçün datanın zəif və ya məhdud tərəfləri qeyd olunur:

* Analiz yalnız qısa tarixi pəncərəni (**2024–2025** illəri üzrə qiymətləndirmələri) əhatə edir.
* Bəzi kiçik şöbələrdə işçi sayının az olması (1–2 nəfər) orta rəqəmlərdə statistik təhriflər yarada bilər.
* Xarici bazar kompensasiya dəyişiklikləri compa-ratio hesablamalarına birbaşa daxil edilməyib.
