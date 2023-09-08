SELECT*
FROM  [dbo].[Human Resource Assignment]

--TO CHECK FOR DUPLICATES

SELECT id,first_name, last_name, birthdate, gender race, department,jobtitle, location, hire_date,termdate,location_city,location_state, COUNT(*) as duplicatee_count
from [dbo].[Human Resource Assignment]
GROUP BY id, first_name, last_name, birthdate, gender, department, jobtitle, location, hire_date, termdate, location_city, location_state
HAVING COUNT(*) >1;


--CHECK FOR MISSING VALUES

SELECT
  COUNT(CASE WHEN id IS NULL THEN 1 END) AS id_missing_count,
  COUNT(CASE WHEN first_name IS NULL THEN 1 END) AS first_name_missing_count,
  COUNT(CASE WHEN last_name IS NULL THEN 1 END) AS last_name_missing_count,
  COUNT(CASE WHEN birthdate IS NULL THEN 1 END) AS birthday_missing_count,
  COUNT(CASE WHEN race IS NULL THEN 1 END) AS race_missing_count,
  COUNT(CASE WHEN department IS NULL THEN 1 END) AS department_missing_count,
  COUNT(CASE WHEN jobtitle IS NULL THEN 1 END) AS jobtitle_missing_count,
  COUNT(CASE WHEN location IS NULL THEN 1 END) AS location_missing_count,
  COUNT(CASE WHEN hire_date IS NULL THEN 1 END) AS hire_date_missing_count,
  COUNT(CASE WHEN termdate IS NULL THEN 1 END) AS termdate_missing_count,
  COUNT(CASE WHEN location_city IS NULL THEN 1 END) AS location_city_missing_count,
  COUNT(CASE WHEN location_state IS NULL THEN 1 END) AS location_state_missing_count
FROM
  [dbo].[Human Resource Assignment]

--UPDATING TABLE

UPDATE [dbo].[Human Resource Assignment]
  SET termdate=
  TRY_CONVERT(DATETIME, termdate,120)
  WHERE termdate IS NOT NULL AND termdate!=''


  --using data to answer questions

1--What is the gender breakdown of employees in the company?

SELECT gender, COUNT(*) AS gender_count
FROM [dbo].[Human Resource Assignment]
GROUP BY gender;

2--What is the race/ethnicity breakdown of employees in the company?

SELECT race, COUNT(*) AS race_count
FROM [dbo].[Human Resource Assignment]
GROUP BY race;

3--What is the age distribution of employees in the company?
SELECT 
    FLOOR(DATEDIFF(YEAR, birthdate, GETDATE()) / 10) * 10 AS age_range,
    COUNT(*) AS employee_count
FROM [dbo].[Human Resource Assignment]
GROUP BY FLOOR(DATEDIFF(YEAR, birthdate, GETDATE()) / 10) * 10
ORDER BY age_range;


4--How many employees work at headquarters versus remote locations?
SELECT
    CASE
        WHEN location = 'Headquarters' THEN 'Headquarters'
        ELSE 'Remote'
    END AS work_location,
    COUNT(*) AS num_employees
FROM [dbo].[Human Resource Assignment]
GROUP BY location;

--5.	What is the average length of employment for employees who have been terminated?

SELECT 
    AVG(DATEDIFF(MONTH, hire_date, termdate)) AS avg_employment_duration_months
FROM [dbo].[Human Resource Assignment]
WHERE termdate IS NOT NULL;


6--How does the gender distribution vary across departments and job title?

SELECT
    department,
    jobtitle,
    COUNT(CASE WHEN gender = 'Male' THEN 1 END) AS male_count,
    COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS female_count,
	COUNT(CASE WHEN gender = 'Non-Conforming' THEN 1 END) AS others_count
FROM [dbo].[Human Resource Assignment]
GROUP BY department, jobtitle;

7--What is the distribution of job titles across the company?

SELECT jobtitle, COUNT(*) AS job_title_count
FROM [dbo].[Human Resource Assignment]
GROUP BY jobtitle;

--8.	Which department has the highest turnover rate?
SELECT TOP 1
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminated_employees,
    100.0 * SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) AS turnover_rate
FROM [dbo].[Human Resource Assignment]
GROUP BY department
ORDER BY turnover_rate DESC;


9--What is the distribution of employees across locations by state?
SELECT location_state, COUNT(*) AS employee_count
FROM [dbo].[Human Resource Assignment]
GROUP BY location_state;


--10	How has the company's employee count changed over time based on hire and term dates?

SELECT hire_date AS date_event, COUNT(*) AS employee_count, 'Hired' AS event_type
FROM [dbo].[Human Resource Assignment]
GROUP BY hire_date
   UNION
      SELECT termdate AS date_event, -COUNT(*) AS employee_count, 'Terminated' AS event_type
      FROM [dbo].[Human Resource Assignment]
      WHERE termdate IS NOT NULL
      GROUP BY termdate
ORDER BY date_event;


--11.	What is the tenure distribution for each department?
SELECT 
    department,
    DATEDIFF(MONTH, hire_date, GETDATE()) AS tenure_months
FROM[dbo].[Human Resource Assignment] ;


SELECT 
    department,
    FLOOR(DATEDIFF(MONTH, hire_date, GETDATE()) / 12) AS tenure_years,
    COUNT(*) AS employee_count
FROM [dbo].[Human Resource Assignment]
GROUP BY department, FLOOR(DATEDIFF(MONTH, hire_date, GETDATE()) / 12)
ORDER BY department, tenure_years;


SELECT
    department,
    AVG(DATEDIFF(MONTH, hire_date, ISNULL(termdate, GETDATE()))) AS avg_tenure_months,
    MIN(DATEDIFF(MONTH, hire_date, ISNULL(termdate, GETDATE()))) AS min_tenure_months,
    MAX(DATEDIFF(MONTH, hire_date, ISNULL(termdate, GETDATE()))) AS max_tenure_months
FROM [dbo].[Human Resource Assignment]
GROUP BY department;




