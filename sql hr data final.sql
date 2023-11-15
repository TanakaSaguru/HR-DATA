Select * from dbo.general_data

-- Retrieve the total number of employees in the dataset.
Select COUNT(Distinct EmployeeID) AS TOTAL_NUMBER_OFEMPLOYEES
from dbo.general_data;

--. List all unique job roles in the dataset.
Select Distinct (JobRole) from dbo.general_data

--Find the average age of employees.
Select  AVG( Age ) as Average_Age
from dbo.general_data



--. Retrieve the names and ages of employees who have worked at the company for more 
--than 5 years.

SELECT Age, 
    CASE 
        WHEN ISNUMERIC(TotalWorkingYears) = 1 THEN CAST(TotalWorkingYears AS INT)
        ELSE 0 
    END AS TotalWorkingYears
FROM dbo.general_data
WHERE ISNUMERIC(TotalWorkingYears) = 1 
    AND CAST(TotalWorkingYears AS INT) > 5;

-- Get a count of employees grouped by their department
Select COUNT(EmployeeID ) AS TotalEmployeesper_Department ,Department 
from dbo.general_data
Group by Department

Select Distinct Department from dbo.general_data


-- List employees who have 'High' Job Satisfaction.
SELECT COUNT(G.EmployeeID) AS EmployeesID_with_HighSatisfaction
FROM dbo.general_data G
JOIN dbo.employee_survey_data$ E 
ON G.EmployeeID = E.EmployeeID
WHERE E.JobSatisfaction = 4;

Select * from dbo.employee_survey_data$

--. Find the highest Monthly Income in the dataset
SELECT MAX(MonthlyIncome) AS Highest_Monthly_Salary
from dbo.general_data


-- List employees who have 'Travel_Rarely' as their BusinessTravel type
SELECT COUNT( EmployeeID) AS EMPLOYESS_WHO_TRAVEL_RARELY
from dbo.general_data
where BusinessTravel= 'Travel_Rarely'


--9. Retrieve the distinct MaritalStatus categories in the dataset.

Select Distinct(MaritalStatus) from dbo.general_data


--Get a list of employees with more than 2 years of work experience but less than 4 years in 
--their current role.

SELECT COUNT(EmployeeID) AS EMPLOYEESWITH_MORETHAN2_YEARS_BUTLESSTHAN_4YEARSWORKEXP
FROM dbo.general_data
WHERE ISNUMERIC(TotalWorkingYears) = 1
  AND CONVERT(int, TotalWorkingYears) > 2
  AND CONVERT(int, TotalWorkingYears) < 4;


-- List employees who have changed their job roles within the company (JobLevel and 
--JobRole differ from their previous job).


--Find the average distance from home for employees in each department
  Select AVG(DistanceFromHome) AS AVG_DISTANCE_FROMHOME,Department 
  from dbo.general_data
  group by Department


--Retrieve the top 5 employees with the highest MonthlyIncome
  Select top 5  EmployeeID ,MonthlyIncome from dbo.general_data
  ORDER BY MonthlyIncome Desc ;


--Calculate the percentage of employees who have had a promotion in the last year


WITH OneYearPromotions AS
(
      SELECT COUNT(EmployeeID) AS EmployeePromotedLastYear
      FROM dbo.general_data
      WHERE YearsSinceLastPromotion = 1
)
SELECT 
    (EmployeePromotedLastYear * 100.0) / (SELECT COUNT(EmployeeID) FROM dbo.general_data) AS Promotion_Percentage_For_LastYear
FROM OneYearPromotions;

-- List the employees with the highest and lowest EnvironmentSatisfaction
Select MAX(EnvironmentSatisfaction) AS MAXIMUM_ENVIRONMENT_SATISFACTION,Min(EnvironmentSatisfaction) AS MINIMUM_ENVIRONMENT_SATISFACTION
FROM dbo.employee_survey_data$ 


Select EnvironmentSatisfaction ,(EmployeeID)
FROM dbo.employee_survey_data$
Where EnvironmentSatisfaction =4 or EnvironmentSatisfaction =1;
 
--OR
SELECT EmployeeID, EnvironmentSatisfaction
FROM dbo.employee_survey_data$
WHERE EnvironmentSatisfaction = (SELECT MAX(EnvironmentSatisfaction) FROM dbo.employee_survey_data$)
UNION ALL
SELECT EmployeeID, EnvironmentSatisfaction
FROM dbo.employee_survey_data$
WHERE EnvironmentSatisfaction = (SELECT MIN(EnvironmentSatisfaction) FROM dbo.employee_survey_data$);


--Find the employees who have the same JobRole and MaritalStatus.
SELECT A.EmployeeID AS Employee1, B.EmployeeID AS Employee2, A.JobRole, A.MaritalStatus
FROM dbo.general_data A
JOIN dbo.general_data B ON A.JobRole = B.JobRole
                       AND A.MaritalStatus = B.MaritalStatus
                       AND A.EmployeeID <> B.EmployeeID;


--. List the employees with the highest TotalWorkingYears who also have a 
--PerformanceRating of 4

 SELECT COUNT( G.EmployeeID) AS EMPLOYEES_WITHBOTHHIGHWORKINGYEARSANDPERFOMANCERATING 
FROM dbo.general_data G
JOIN dbo.manager_survey_data$ M ON G.EmployeeID = M.EmployeeID
WHERE M.PerformanceRating = 4
 AND G.TotalWorkingYears = (SELECT MAX(TotalWorkingYears) FROM dbo.general_data WHERE TotalWorkingYears IS NOT NULL AND TotalWorkingYears <> 'NA');

 Select * from dbo.manager_survey_data$

-- Calculate the average Age and JobSatisfaction for each BusinessTravel type.
 Select G.BusinessTravel AS BUSINESS_Travel_TYPE,avg( E.JobSatisfaction) AS AVG_JOBSATISFACTION, AVG (G.Age) AS AVG_AGE
 from dbo.general_data G
 JOIN dbo.employee_survey_data$ E
 on 
 G.EmployeeID =E.EmployeeID
Group by G.BusinessTravel

--Retrieve the most common EducationField among employee
Select Count(EmployeeID) AS Number_of_Employees ,EducationField
from dbo.general_data
Group by EducationField

-- List the employees who have worked for the company the longest but haven't had a 
--promotion



SELECT EmployeeID
FROM dbo.general_data
WHERE YearsSinceLastPromotion = 0 AND YearsAtCompany = (SELECT MAX(YearsAtCompany) FROM dbo.general_data);