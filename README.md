# Parks and Recreation Employee Analysis (SQL)
## Project Overview

This project uses SQL to analyze employee data from a Parks and Recreation department, with the goal of answering real‑world workforce and compensation questions. The analysis mirrors practical HR and organizational reporting tasks such as headcount tracking, gender diversity assessment, age distribution analysis, salary benchmarking, and departmental cost evaluation.

The project progresses from data exploration to advanced querying techniques, producing insights that could support management decisions, workforce planning, and budget allocation.

---

## Business Questions Addressed

This analysis answers key operational and HR‑focused questions, including:

* How many employees are currently in the organization?
* How is the workforce distributed by gender?
* What does the age distribution of employees look like?
* Who are the highest‑paid employees?
* How do salaries vary across age groups and occupations?
* Which roles contribute most to total salary cost?
* How are employees distributed across departments?

---

## Dataset Description

The project uses three related tables:

* **employee_demographics**: employee ID, name, gender, age, and birth date
* **employee_salary**: employee ID, occupation, salary, and department ID
* **parks_departments**: department ID and department name

These tables were joined where necessary to create a complete employee profile combining demographics, job roles, compensation, and department information.

---

## Key SQL Techniques Used

* Data exploration using `SELECT`
* Filtering with `WHERE`, comparison operators, and `LIKE`
* Sorting with `ORDER BY`
* Aggregations using `COUNT`, `AVG`, `MIN`, `MAX`, and `SUM`
* Grouping data with `GROUP BY`
* Conditional logic using `CASE WHEN`
* Table joins (`INNER JOIN`, `LEFT JOIN`)
* Common Table Expressions (CTEs)

---

## Highlighted Queries & Analysis

### Total Workforce Size

Used to establish the overall size of the organization.

```sql
SELECT COUNT(*) AS Total_Employees
FROM parks_and_recreation.employee_demographics;
```

---

### Gender Distribution

Provides insight into workforce diversity and representation.

```sql
SELECT gender, COUNT(*) AS Count_Of_Employees
FROM parks_and_recreation.employee_demographics
GROUP BY gender;
```

---

### Top 5 Highest‑Paid Employees

Identifies compensation outliers and key earners within the organization.

```sql
SELECT d.first_name, d.last_name, d.gender, s.salary
FROM employee_demographics AS d
INNER JOIN employee_salary AS s
    ON d.employee_id = s.employee_id
ORDER BY s.salary DESC
LIMIT 5;
```

---

### Unified Employee Report

Creates a complete employee view including demographics, job role, salary, and department.

```sql
SELECT d.employee_id, d.first_name, d.last_name, d.gender, d.birth_date,
       dn.department_name, s.occupation, s.salary
FROM parks_and_recreation.employee_demographics d
LEFT JOIN parks_and_recreation.employee_salary s 
    ON d.employee_id = s.employee_id
LEFT JOIN parks_and_recreation.parks_departments dn
    ON s.dept_id = dn.department_id
ORDER BY d.last_name, d.first_name;
```

---

### Employee Age Group Classification

Segments employees into meaningful age groups for workforce planning.

```sql
SELECT employee_id, first_name, last_name, age,
CASE
    WHEN age < 30 THEN 'Young'
    WHEN age BETWEEN 30 AND 50 THEN 'Mid-Level'
    ELSE 'Senior'
END AS Age_Group
FROM parks_and_recreation.employee_demographics;
```

---

### Average Salary by Age Group

Examines how compensation varies across career stages.

```sql
SELECT 
    CASE
        WHEN (2023 - YEAR(birth_date)) < 30 THEN 'Young'
        WHEN (2023 - YEAR(birth_date)) BETWEEN 30 AND 50 THEN 'Mid-Level'
        ELSE 'Senior'
    END AS Age_Group,
AVG(s.salary) AS Average_Salary
FROM parks_and_recreation.employee_demographics d
LEFT JOIN parks_and_recreation.employee_salary s
    ON d.employee_id = s.employee_id
GROUP BY Age_Group
ORDER BY Average_Salary DESC;
```

---

### Total Salary Cost by Occupation

Identifies roles with the highest overall salary impact using a CTE.

```sql
WITH salary_cost AS (
    SELECT s.occupation, SUM(s.salary) AS total_salary_cost
    FROM parks_and_recreation.employee_salary s
    JOIN parks_and_recreation.employee_demographics d
        ON s.employee_id = d.employee_id
    GROUP BY s.occupation
)
SELECT *
FROM salary_cost
WHERE total_salary_cost > 100000;
```

---

## Insight Summary

* The organization has **11 employees**, with a predominantly male workforce.
* Most employees fall within the **mid‑level age group**, indicating a relatively experienced staff base.
* Female employee ages range from **29 to 46**, while male employee ages range from **34 to 61**.
* Salaries range between **20,000 and 90,000**, showing significant compensation variation.
* Only one occupation exceeds a **total salary cost of 100,000**, highlighting a key cost driver.
* Although there are **six departments**, salary expenditure is concentrated in a few roles.

Overall, the data reflects a **mid‑career‑focused workforce**, moderate gender imbalance, and uneven salary distribution across occupations.

---

## Recommendations

Based on the analysis, the following recommendations could support better workforce planning and cost management:

* **Improve gender balance**: With a predominantly male workforce, targeted hiring or inclusion initiatives could help improve gender representation.
* **Plan for workforce aging**: The concentration of employees in the mid-level age group suggests the need for succession planning to prepare for future senior-level exits.
* **Review high-cost roles**: Occupations with a total salary cost exceeding 100,000 should be reviewed to ensure compensation aligns with workload and impact.
* **Optimize departmental spending**: Since salary expenses are concentrated in a few roles or departments, management may explore redistribution of responsibilities or efficiency improvements.
* **Develop entry-level pipelines**: The low number of young employees suggests an opportunity to introduce internships or graduate roles to support long-term talent growth.

---

## Conclusion

This project demonstrates the practical use of SQL to solve real-world employee analytics problems. By combining filtering, aggregation, joins, conditional logic, and CTEs, the analysis transforms raw employee data into actionable organizational insights. The approach mirrors common HR and operational analytics tasks and showcases SQL skills relevant to real-world data analysis and organizational reporting.

---

## Author

Temitope Adeyemi | Data Analyst

