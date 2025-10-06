CREATE DATABASE HR_PROJECT;
USE HR_PROJECT;

CREATE TABLE HR1 (
    Age TEXT,
    Attrition TEXT,
    BusinessTravel TEXT,
    DailyRate TEXT,
    Department TEXT,
    DistanceFromHome TEXT,
    Education TEXT,
    EducationField TEXT,
    EmployeeCount TEXT,
    EmployeeNumber TEXT,
    EnvironmentSatisfaction TEXT,
    Gender TEXT,
    HourlyRate TEXT,
    JobInvolvement TEXT,
    JobLevel TEXT,
    JobRole TEXT,
    JobSatisfaction TEXT,
    MaritalStatus TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_1.csv'
INTO TABLE HR1
FIELDS TERMINATED BY","
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT * FROM HR1;

ALTER TABLE HR1 MODIFY COLUMN age INT;
ALTER TABLE HR1 MODIFY COLUMN dailyrate INT;
ALTER TABLE HR1 MODIFY COLUMN distancefromhome INT;
ALTER TABLE HR1 MODIFY COLUMN education INT;
ALTER TABLE HR1 MODIFY COLUMN employeecount INT;
ALTER TABLE HR1 MODIFY COLUMN employeenumber INT;
ALTER TABLE HR1 MODIFY COLUMN environmentsatisfaction INT;
ALTER TABLE HR1 MODIFY COLUMN hourlyrate INT;
ALTER TABLE HR1 MODIFY COLUMN jobinvolvement INT;
ALTER TABLE HR1 MODIFY COLUMN joblevel INT;
ALTER TABLE HR1 MODIFY COLUMN jobsatisfaction INT;

CREATE TABLE HR2 (
    `Employee ID` TEXT,
    MonthlyIncome TEXT,
    MonthlyRate TEXT,
    NumCompaniesWorked TEXT,
    Over18 TEXT,
    OverTime TEXT,
    PercentSalaryHike TEXT,
    PerformanceRating TEXT,
    RelationshipSatisfaction TEXT,
    StandardHours TEXT,
    StockOptionLevel TEXT,
    TotalWorkingYears TEXT,
    TrainingTimesLastYear TEXT,
    WorkLifeBalance TEXT,
    YearsAtCompany TEXT,
    YearsInCurrentRole TEXT,
    YearsSinceLastPromotion TEXT,
    YearsWithCurrManager TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_2.csv'
INTO TABLE HR2
FIELDS TERMINATED BY","
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT * FROM HR2;

ALTER TABLE HR2 MODIFY COLUMN `Employee ID` INT;
ALTER TABLE HR2 MODIFY COLUMN MONTHLYINCOME INT;
ALTER TABLE HR2 MODIFY COLUMN MONTHLYRATE INT;
ALTER TABLE HR2 MODIFY COLUMN NumCompaniesWorked INT;
ALTER TABLE HR2 MODIFY COLUMN PercentSalaryHike INT;
ALTER TABLE HR2 MODIFY COLUMN PerformanceRating INT;
ALTER TABLE HR2 MODIFY COLUMN RelationshipSatisfaction INT;
ALTER TABLE HR2 MODIFY COLUMN StandardHours INT;
ALTER TABLE HR2 MODIFY COLUMN StockOptionLevel INT;
ALTER TABLE HR2 MODIFY COLUMN TotalWorkingYears INT;
ALTER TABLE HR2 MODIFY COLUMN TrainingTimesLastYear INT;
ALTER TABLE HR2 MODIFY COLUMN WorkLifeBalance INT;
ALTER TABLE HR2 MODIFY COLUMN YearsAtCompany INT;
ALTER TABLE HR2 MODIFY COLUMN YearsInCurrentRole INT;
ALTER TABLE HR2 MODIFY COLUMN YearsSinceLastPromotion INT;
ALTER TABLE HR2 MODIFY COLUMN YearsWithCurrManager INT;
SELECT * FROM HR1;

# Average Attrition rate for all Departments

SELECT DEPARTMENT,
FORMAT(COUNT(EMPLOYEENUMBER),"N0") AS NO_OF_EMP_LEFT,
CONCAT(ROUND(COUNT(EMPLOYEENUMBER)*100/(SELECT COUNT(*) FROM HR1),2)," %") AS PER_OF_TOTAL 
FROM HR1 
WHERE Attrition="YES" 
GROUP BY DEPARTMENT
ORDER BY 2 DESC;

# Average Hourly rate of Male Research Scientist

SELECT ROUND(AVG(HOURLYRATE),2) AS AVG_HOURLY_RATE_FOR_MALE_RESEARCH
FROM HR1 WHERE JOBROLE="Research Scientist" AND GENDER="MALE";

# Attrition rate Vs Monthly income stats

SELECT H.Attrition,
COUNT(H.employeenumber) AS NO_OF_EMPLOYEE,
AVG(R.MONTHLYINCOME) AS MONHTLY_INCOME 
FROM HR1 AS H JOIN HR2 AS R 
ON H.employeenumber=R.`Employee ID` 
GROUP BY H.Attrition;

# Average working years for each Department

SELECT DEPARTMENT,
CONCAT(ROUND(AVG(YearsAtCompany),2),' YRS') AS AVG_WORKING_YRS 
FROM HR1 AS H JOIN HR2 AS R 
ON H.employeenumber=R.`Employee ID` 
GROUP BY DEPARTMENT
ORDER BY AVG(YearsAtCompany) DESC; 

# Job Role Vs Work life balance

SELECT JOBROLE, 
ROUND(AVG(WorkLifeBalance),2) AS WORK_LIFE_BALANCE
FROM HR1 AS H JOIN HR2 AS R 
ON H.employeenumber=R.`Employee ID` 
GROUP BY JOBROLE
ORDER BY AVG(WorkLifeBalance) DESC;

# Attrition rate Vs Year since last promotion relation

SELECT YearsSinceLastPromotion,
FORMAT(COUNT(employeenumber),"N0") AS TOTAL_EMP,
FORMAT(SUM(CASE WHEN Attrition="YES" THEN 1 ELSE 0 END),"N0") AS EMP_LEFT,
CONCAT(ROUND(SUM(CASE WHEN Attrition="YES" THEN 1 ELSE 0 END)*100/COUNT(*),2)," %") AS PER_OF_TOTAL
FROM HR1 AS H JOIN HR2 AS R 
ON H.employeenumber=R.`Employee ID` 
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion ASC;
