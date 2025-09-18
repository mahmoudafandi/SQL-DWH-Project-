-- loading data into tables 
-- 

--IF OBJECT_ID('dbo.Staging_AllData', 'U') IS NOT NULL
--    DROP TABLE dbo.Staging_AllData;
--CREATE TABLE dbo.Staging_AllData (
--    Age INT,
--    Attrition NVARCHAR(50),
--    BusinessTravel NVARCHAR(50),
--    DailyRate INT,
--    Department NVARCHAR(50),
--    DistanceFromHome INT,
--    Education INT,
--    EducationField NVARCHAR(50),
--    EmployeeCount INT,
--    EmployeeNumber INT,
--    EnvironmentSatisfaction INT,
--    Gender NVARCHAR(10),
--    HourlyRate INT,
--    JobInvolvement INT,
--    JobLevel INT,
--    JobRole NVARCHAR(100),
--    JobSatisfaction INT,
--    MaritalStatus NVARCHAR(50),
--    MonthlyIncome INT,
--    MonthlyRate INT,
--    NumCompaniesWorked INT,
--    Over18 NVARCHAR(5),
--    OverTime NVARCHAR(5),
--    PercentSalaryHike INT,
--    PerformanceRating INT,
--    RelationshipSatisfaction INT,
--    StandardHours INT,
--    StockOptionLevel INT,
--    TotalWorkingYears INT,
--    TrainingTimesLastYear INT,
--    WorkLifeBalance INT,
--    YearsAtCompany INT,
--    YearsInCurrentRole INT,
--    YearsSinceLastPromotion INT,
--    YearsWithCurrManager INT
--);

--GO
--BULK INSERT dbo.Staging_AllData
--FROM 'C:\Users\96650\Desktop\L4T1\project_IBM\dataset\data.txt'
--WITH (
--    FIRSTROW = 2,              
--    FIELDTERMINATOR = ',',     
--    ROWTERMINATOR = '\n',       
--    TABLOCK,
--    CODEPAGE = '65001'          
--);

-- Loading into employee

-----------------------------



BEGIN TRY
    BEGIN TRANSACTION;

-- 1️⃣ Education Table
INSERT INTO HR_attrition.hr.Education (education, education_field)
SELECT DISTINCT
    Education,
    EducationField
FROM dbo.Staging_AllData S
WHERE NOT EXISTS (
    SELECT 1 
    FROM HR_attrition.hr.Education E
    WHERE E.education = S.Education
      AND E.education_field = S.EducationField
);

-- 2Emp_social_status Table
INSERT INTO HR_attrition.hr.Emp_social_status (gender, marital_status, work_life_balance)
SELECT DISTINCT
    Gender,
    MaritalStatus,
    WorkLifeBalance
FROM dbo.Staging_AllData S
WHERE NOT EXISTS (
    SELECT 1 
    FROM HR_attrition.hr.Emp_social_status SS
    WHERE SS.gender = S.Gender
      AND SS.marital_status = S.MaritalStatus
      AND SS.work_life_balance = S.WorkLifeBalance
);

-- 3️⃣ Job_role Table
INSERT INTO HR_attrition.hr.Job_role (job_role)
SELECT DISTINCT
    JobRole
FROM dbo.Staging_AllData S
WHERE NOT EXISTS (
    SELECT 1 FROM HR_attrition.hr.Job_role JR 
    WHERE JR.job_role = S.JobRole
);

-- 4Department Table
INSERT INTO HR_attrition.hr.Department (department)
SELECT DISTINCT
    Department
FROM dbo.Staging_AllData S
WHERE NOT EXISTS (
    SELECT 1 FROM HR_attrition.hr.Department D 
    WHERE D.department = S.Department
);

-- Job_details Table
INSERT INTO HR_attrition.hr.Job_details (job_id, dept_id, job_involvement, job_satisfaction, performance_rating, relation_satisfaction)
SELECT DISTINCT
    JR.job_id,
    D.dept_id,
    S.JobInvolvement,
    S.JobSatisfaction,
    S.PerformanceRating,
    S.RelationshipSatisfaction
FROM dbo.Staging_AllData S
JOIN HR_attrition.hr.Job_role JR ON S.JobRole = JR.job_role
JOIN HR_attrition.hr.Department D ON S.Department = D.department
WHERE NOT EXISTS (
    SELECT 1 FROM HR_attrition.hr.Job_details JD
    WHERE JD.job_id = JR.job_id
      AND JD.dept_id = D.dept_id
      AND JD.job_involvement = S.JobInvolvement
      AND JD.job_satisfaction = S.JobSatisfaction
      AND JD.performance_rating = S.PerformanceRating
      AND JD.relation_satisfaction = S.RelationshipSatisfaction
);

--  Employee_History Table
INSERT INTO HR_attrition.hr.Employee_History (YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager, TotalWorkingYears, TrainingTimesLastYear, NumCompaniesWorked)
SELECT DISTINCT
    YearsAtCompany,
    YearsInCurrentRole,
    YearsSinceLastPromotion,
    YearsWithCurrManager,
    TotalWorkingYears,
    TrainingTimesLastYear,
    NumCompaniesWorked
FROM dbo.Staging_AllData S
WHERE NOT EXISTS (
    SELECT 1 FROM HR_attrition.hr.Employee_History EH
    WHERE EH.YearsAtCompany = S.YearsAtCompany
      AND EH.YearsInCurrentRole = S.YearsInCurrentRole
      AND EH.YearsSinceLastPromotion = S.YearsSinceLastPromotion
      AND EH.YearsWithCurrManager = S.YearsWithCurrManager
      AND EH.TotalWorkingYears = S.TotalWorkingYears
      AND EH.TrainingTimesLastYear = S.TrainingTimesLastYear
      AND EH.NumCompaniesWorked = S.NumCompaniesWorked
);

--  Compensation_details Table
INSERT INTO HR_attrition.hr.Compensation_details (daily_rate, hourly_rate, monthly_rate, monthly_income, percent_salary_hike, overtime, stockoptionlevel)
SELECT DISTINCT
    DailyRate,
    HourlyRate,
    MonthlyRate,
    MonthlyIncome,
    PercentSalaryHike,
    OverTime,
    StockOptionLevel
FROM dbo.Staging_AllData S
WHERE NOT EXISTS (
    SELECT 1 FROM HR_attrition.hr.Compensation_details CD
    WHERE CD.daily_rate = S.DailyRate
      AND CD.hourly_rate = S.HourlyRate
      AND CD.monthly_rate = S.MonthlyRate
      AND CD.monthly_income = S.MonthlyIncome
      AND CD.percent_salary_hike = S.PercentSalaryHike
      AND CD.overtime = S.OverTime
      AND CD.stockoptionlevel = S.StockOptionLevel
);

-- Employee Table
INSERT INTO HR_attrition.hr.Employee (emp_no, age, distance_from_home, business_travel, attrition, ed_ID, sc_ID, job_d_id, hist_id, comp_d_id)
SELECT DISTINCT
    S.EmployeeNumber,
    S.Age,
    S.DistanceFromHome,
    S.BusinessTravel,
    S.Attrition,
    E.ed_id,
    SS.sc_id,
    JD.job_d_id,
    EH.hist_id,
    CD.comp_d_id
FROM dbo.Staging_AllData S
JOIN HR_attrition.hr.Education E 
    ON S.Education = E.education AND S.EducationField = E.education_field
JOIN HR_attrition.hr.Emp_social_status SS 
    ON S.Gender = SS.gender AND S.MaritalStatus = SS.marital_status AND S.WorkLifeBalance = SS.work_life_balance
JOIN HR_attrition.hr.Job_details JD 
    ON S.JobRole = (SELECT JR.job_role FROM HR_attrition.hr.Job_role JR WHERE JR.job_id = JD.job_id)
    AND S.JobInvolvement = JD.job_involvement
    AND S.JobSatisfaction = JD.job_satisfaction
    AND S.PerformanceRating = JD.performance_rating
    AND S.Department = (SELECT D.department FROM HR_attrition.hr.Department D WHERE D.dept_id = JD.dept_id)
    AND S.RelationshipSatisfaction = JD.relation_satisfaction
JOIN HR_attrition.hr.Employee_History EH 
    ON S.YearsAtCompany = EH.YearsAtCompany
    AND S.YearsInCurrentRole = EH.YearsInCurrentRole
    AND S.YearsSinceLastPromotion = EH.YearsSinceLastPromotion
    AND S.YearsWithCurrManager = EH.YearsWithCurrManager
    AND S.TotalWorkingYears = EH.TotalWorkingYears
    AND S.TrainingTimesLastYear = EH.TrainingTimesLastYear
    AND S.NumCompaniesWorked = EH.NumCompaniesWorked
JOIN HR_attrition.hr.Compensation_details CD
    ON S.DailyRate = CD.daily_rate
    AND S.HourlyRate = CD.hourly_rate
    AND S.MonthlyRate = CD.monthly_rate
    AND S.MonthlyIncome = CD.monthly_income
    AND S.PercentSalaryHike = CD.percent_salary_hike
    AND S.OverTime = CD.overtime
    AND S.StockOptionLevel = CD.stockoptionlevel
WHERE NOT EXISTS (
    SELECT 1 FROM HR_attrition.hr.Employee EMP
    WHERE EMP.emp_no = S.EmployeeNumber
);

COMMIT TRANSACTION;
PRINT 'Data loaded successfully!';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred while loading data.';
    PRINT ERROR_MESSAGE();
END CATCH;

