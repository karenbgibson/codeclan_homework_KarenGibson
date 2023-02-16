-- Question 1.

SELECT count(*)
FROM employees
WHERE grade IS NULL 
    AND salary IS NULL;
    
-- Question 2.
    
SELECT 
    department,
    concat(first_name, ' ', last_name) AS full_name
FROM employees 
ORDER BY department, last_name;

-- Question 3.

SELECT *
FROM employees 
WHERE 
    last_name ILIKE 'A%'
ORDER BY salary DESC NULLS LAST 
    LIMIT 10;
    
    
-- Question 4.
    
SELECT
    department,
    count(*) AS no_in_dept
FROM employees 
WHERE start_date BETWEEN '01-01-2013' AND '12-31-2013'
GROUP BY department;


-- Question 5.

SELECT 
    department,
    fte_hours,
    count(fte_hours) AS no_on_fte_pattern
FROM employees
GROUP BY department, fte_hours 
ORDER BY department, fte_hours;


-- Question 6.

SELECT 
    count(pension_enrol),
    pension_enrol 
FROM employees 
GROUP BY pension_enrol;

-- Question 7.

SELECT *
FROM employees 
WHERE department = 'Accounting'
    AND pension_enrol IS FALSE
ORDER BY salary DESC NULLS LAST
LIMIT 1;

-- Question 8.

SELECT 
    country, 
    count(country) AS no_of_employees,
    ROUND(avg(salary),2) AS avg_salary 
FROM employees 
GROUP BY country
HAVING 
    count(country) > 30
ORDER BY avg_salary DESC;


-- Question 9.

SELECT 
    first_name,
    last_name,
    fte_hours,
    salary,
    (fte_hours * salary) AS effective_yearly_salary
FROM employees
WHERE (fte_hours * salary) > 30000;

-- Question 10.

SELECT 
    e.*,
    t.name
FROM employees AS e INNER JOIN
    teams AS t
    ON e.team_id = t.id
WHERE t.name IN ('Data Team 1', 'Data Team 2');

-- Question 11.

SELECT 
    first_name,
    last_name 
FROM employees AS e LEFT JOIN
    pay_details AS pd 
    ON e.pay_detail_id = pd.id
WHERE pd.local_tax_code IS NULL

-- Question 12.

SELECT
    e. first_name,
    e. last_name,
    e.salary,
    t.charge_cost,
    t."name" AS team_name,
    (48 * 35 * CAST (t.charge_cost AS NUMERIC)- e.salary) * fte_hours AS expected_profit
FROM employees AS e LEFT JOIN 
    teams AS t 
    ON e.team_id = t.id 
ORDER BY expected_profit DESC NULLS LAST


-- Question 13.

SELECT 
    fte_hours 
FROM employees
GROUP BY fte_hours
ORDER BY count(*)
LIMIT 1;

SELECT 
    first_name,
    last_name,
    salary,
    fte_hours
FROM employees
WHERE country = 'Japan'
    AND fte_hours = (SELECT 
    fte_hours 
FROM employees
GROUP BY fte_hours
ORDER BY count(*) ASC NULLS LAST
LIMIT 1)
ORDER BY salary ASC NULLS LAST
LIMIT 1;


-- Question 14.

SELECT
    count(department) AS employees_with_no_first_name,
    department
FROM employees
WHERE first_name IS NULL
GROUP BY department
HAVING count(department) >= 2
ORDER BY employees_with_no_first_name DESC,
    department ASC; 


-- Question 15

SELECT 
    first_name,
    count (first_name) AS no_employees_with_name
FROM employees 
WHERE first_name IS NOT NULL
GROUP BY first_name 
HAVING count (first_name) > 1
ORDER BY no_employees_with_name DESC,
first_name ASC;


-- Question 16

--attempting to round answer to percentage

SELECT
    department,
    sum(CAST((grade = 1) AS INT)) AS grade_1_total,
    sum(CAST((grade != 1) AS INT)) AS grade_not_1,
    CONCAT((ROUND(CAST(sum(CAST((grade = 1) AS INT)) AS REAL) /
    CAST((sum(CAST((grade != 1) AS INT))) +
    sum(CAST((grade = 1) AS INT)) AS REAL)
    * 100),2), '%') AS proportion_grade_1
FROM employees 
GROUP BY department;

-- attempting without rounding

SELECT
    department,
    sum(CAST((grade = 1) AS INT)) AS grade_1_total,
    sum(CAST((grade != 1) AS INT)) AS grade_not_1,
    CONCAT(CAST(sum(CAST((grade = 1) AS INT)) AS REAL) /
    CAST((sum(CAST((grade != 1) AS INT))) +
    sum(CAST((grade = 1) AS INT)) AS REAL)
    * 100, '%') AS proportion_grade_1
FROM employees 
GROUP BY department;


--^^ I really wanted to round the above grade_proportion as a percentage
-- with 2 decimal places but couldn't get the ROUND function to work properly.



    












    







