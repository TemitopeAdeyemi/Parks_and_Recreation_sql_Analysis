-- Parks and Recreation Employee Analysis
-- Preview all employee demographic records
SELECT *
FROM employee_demographics;

-- Preview all employee salary records
SELECT *
FROM employee_salary;

-- Preview  all departments records
SELECT *
FROM parks_departments;

-- Total Number Of Employees
SELECT COUNT(*) AS Total_Employees
FROM parks_and_recreation.employee_demographics;

-- How is the workforce distributed by gender?
SELECT gender, COUNT(*) AS Count_Of_Employees
FROM parks_and_recreation.employee_demographics
GROUP BY gender;

-- Retrieve basic employee information (name and age)
SELECT first_name, last_name, age
FROM parks_and_recreation.employee_demographics;

-- Which employees are over 40 years old?
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE age > 40;

-- Find employee record by first name
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name = 'April';

-- Retrieve employees whose first names begin with A, B or C
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'A%'
OR first_name LIKE 'B%'
OR first_name LIKE 'C%';

-- Identify employees born before January 1,1985
SELECT first_name, last_name, birth_date
FROM parks_and_recreation.employee_demographics
WHERE birth_date < '1985-01-01';

-- Identify employees excluding male employees (gender diversity check)
SELECT first_name, last_name, gender
FROM parks_and_recreation.employee_demographics
WHERE gender != 'Male';

-- Sort employees by age in ascending order
SELECT first_name, last_name, age
FROM parks_and_recreation.employee_demographics
ORDER BY age;

-- Clean and standardize salary table column names
SELECT employee_id as ID, occupation as Job_Title, salary as Annual_Salary
FROM parks_and_recreation.employee_salary;

-- What is the age range for each gender?
SELECT gender, min(age) as Min_Age, max(age) as Max_Age
FROM parks_and_recreation.employee_demographics
GROUP BY gender;

-- Who are the top 5 highest-paid employees?
SELECT d.first_name, d.last_name, d.gender, s.salary
FROM employee_demographics AS d
INNER JOIN employee_salary AS s
    ON d.employee_id = s.employee_id
    ORDER BY s.salary DESC
    LIMIT 5;
    
-- Combine demographic and salary data for all employees
SELECT d.*, s.*
FROM parks_and_recreation.employee_demographics AS d
LEFT JOIN parks_and_recreation.employee_salary AS s
	ON d.employee_id = s.employee_id;
    
-- List all job roles within the organization
SELECT DISTINCT occupation
FROM parks_and_recreation.employee_salary
ORDER BY occupation;

-- Employee age distribution
SELECT (YEAR('2025-01-01') - YEAR(birth_date)) AS Age,
COUNT(*) AS Number_of_Employees
FROM parks_and_recreation.employee_demographics
GROUP BY YEAR('2025-01-01') - YEAR(birth_date)
ORDER BY Age;

-- Identify the youngest and oldest employees by gender
SELECT gender, MIN(age) AS Min_Age, MAX(age) AS Max_Age
FROM parks_and_recreation.employee_demographics
GROUP BY gender;

-- Unified employee report that includes demographic information, job title, salary and department 
SELECT 
d.employee_id, d.first_name, d.last_name, d.gender, d.birth_date, dn.department_name, s.occupation, s.salary
FROM parks_and_recreation.employee_demographics d
LEFT JOIN parks_and_recreation.employee_salary s 
    ON d.employee_id = s.employee_id
LEFT JOIN parks_and_recreation.parks_departments dn
    ON s.dept_id = dn.department_id 
ORDER BY d.last_name, d.first_name;

-- Classify employees into age groups (Young, Mid-Level or Senior)
SELECT employee_id, first_name, last_name, age,
 CASE
    WHEN age < 30 THEN 'Young'
    WHEN age BETWEEN 30 AND 50 THEN 'Mid-Level'
    ELSE 'Senior'
END AS Age_Group
FROM parks_and_recreation.employee_demographics;

-- How many employees into each age group?
SELECT 
    CASE
        WHEN (2023 - YEAR(birth_date)) < 30 THEN 'Young'
        WHEN (2023 - YEAR(birth_date)) BETWEEN 30 AND 50 THEN 'Mid-Level'
        ELSE 'Senior'
    END AS Age_Group,
    COUNT(*) AS Number_of_Employees
FROM parks_and_recreation.employee_demographics
GROUP BY Age_group
ORDER BY Number_of_Employees DESC;

-- What is the average salary per age group?
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

-- Which occupation have a total salary cost above 100,000?
WITH salary_cost AS (
SELECT s.occupation, SUM(s.salary) AS total_salary_cost
FROM parks_and_recreation.employsee_salary s
JOIN parks_and_recreation.employee_demographics d
	ON s.employee_id = d.employee_id
GROUP BY s.occupation
)
SELECT *
FROM salary_cost
WHERE total_salary_cost > 100000;


/* INSIGHT SUMMARY
The organization has 11 Employees, with a workforce that is predominantly male (7 males and 4 females).
Most Employees fall within the mid-level age range, with only one Young and one Senior employee and 4 Staff are above 40.
Female ages range from 29 to 46 while male ages extend from 34 to 61. Salaries span from 20 000 to 90 000 and only one 
occupation exceeds a total salary cost of 100 000. The Company consists of six departments, though only a few accounts for 
most salary expenses. Overall, the data reflects a mid-level focused workforce with moderate gender imbalance and broad variation
in age and compensation.
*/