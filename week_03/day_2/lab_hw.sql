--  MVP

-- Question 1. 
-- a.

SELECT
    first_name,
    last_name,
    teams."name" 
FROM employees INNER JOIN teams 
    ON employees.team_id = teams.id; 
    
--b. 

SELECT
    first_name,
    last_name,
    teams."name" 
FROM employees INNER JOIN teams 
    ON employees.team_id = teams.id
WHERE pension_enrol IS TRUE; 


-- c.

SELECT
    first_name,
    last_name,
    teams.name,
    teams.charge_cost 
FROM employees INNER JOIN teams 
    ON employees.team_id = teams.id
WHERE CAST (teams.charge_cost AS INT) > 80;

-- Question 2
-- a.

SELECT *
FROM employees LEFT JOIN pay_details  
    ON employees.pay_detail_id = pay_details.id
WHERE pay_details.local_account_no IS NOT NULL
AND pay_details.local_sort_code IS NOT NULL; 

-- b.

SELECT 
    employees.*,
    pay_details.*,
    teams."name" 
FROM (employees LEFT JOIN pay_details  
    ON employees.pay_detail_id = pay_details.id)
    LEFT JOIN teams
    ON employees.team_id = teams.id
WHERE pay_details.local_account_no IS NOT NULL
AND pay_details.local_sort_code IS NOT NULL;

-- Question 3
-- a.

SELECT
    employees.id,
    teams.name 
FROM employees LEFT JOIN teams 
    ON employees.team_id = teams.id
ORDER BY employees.id ASC;

-- b.

SELECT
    count(employees.id) AS no_in_team,
    teams."name" 
    AS no_emp_per_team
FROM employees LEFT JOIN teams 
    ON employees.team_id = teams.id
GROUP BY teams.name;

-- c.

SELECT
    count(employees.id) AS no_in_team,
    teams."name" 
    AS no_emp_per_team
FROM employees LEFT JOIN teams 
    ON employees.team_id = teams.id
GROUP BY teams.name
ORDER BY no_in_team;

-- Question 4.
-- a.

SELECT
    teams.id AS team_id,
    teams.name,
    count(employees.id) AS no_in_team
FROM teams LEFT JOIN employees 
    ON employees.team_id = teams.id
GROUP BY teams.id
ORDER BY no_in_team DESC;

-- b.

SELECT
    teams.id AS team_id,
    teams.name,
    count(employees.id) AS no_in_team,
    CAST(teams.charge_cost AS INT) * count(employees.id)
    AS total_day_charge
FROM teams LEFT JOIN employees 
    ON employees.team_id = teams.id
GROUP BY teams.id
ORDER BY no_in_team DESC;

-- c.

SELECT
    teams.id AS team_id,
    teams.name,
    count(employees.id) AS no_in_team,
    CAST(teams.charge_cost AS INT) * count(employees.id)
    AS total_day_charge
FROM teams LEFT JOIN employees 
    ON employees.team_id = teams.id
GROUP BY teams.id
HAVING (CAST(teams.charge_cost AS INT) * count(employees.id)) > 5000;


--  Extension
-- Question 5.

SELECT
    count(DISTINCT (employee_id))
FROM employees_committees;

-- Question 6.

SELECT
    count(employees.id)
FROM employees FULL JOIN employees_committees AS ec 
    ON employees.id = ec.employee_id
WHERE ec.committee_id IS NULL;




