-- project IBM_attrition 


-- Create Database
--CREATE DATABASE HR_attrition;
--GO

-- Create Schema
--CREATE SCHEMA hr;
--GO



-- 2️⃣ Employee Table
CREATE TABLE HR_attrition.hr.Employee (
    emp_no INT PRIMARY KEY,
    age INT,
    distance_from_home INT,
    business_travel VARCHAR(50) 
        CHECK (business_travel IN ('Non-Travel','Travel_Rarely','Travel_Frequently')),
    attrition VARCHAR(3) 
        CHECK (attrition IN ('Yes','No')),
    ed_ID INT,
    sc_ID INT,
    comp_d_id INT,
    job_d_id INT,
    hist_id INT
);

-- 3️⃣ Education Table
CREATE TABLE HR_attrition.hr.Education (
    ed_id INT PRIMARY KEY IDENTITY(1,1),
    education INT CHECK (education IN (1,2,3,4,5)),
    education_field VARCHAR(50) CHECK (education_field IN 
        ('Life Sciences','Medical','Marketing','Technical Degree','Human Resources','Other'))
);

-- 4️⃣ Emp Social Status Table
CREATE TABLE HR_attrition.hr.Emp_social_status (
    sc_id INT PRIMARY KEY IDENTITY(1,1),
    gender VARCHAR(10) CHECK (gender IN ('Male','Female')),
    marital_status VARCHAR(20) CHECK (marital_status IN ('Single','Married','Divorced')),
    work_life_balance INT CHECK (work_life_balance BETWEEN 1 AND 4)
);

-- 5️⃣ Department Table
CREATE TABLE HR_attrition.hr.Department (
    dept_id INT PRIMARY KEY IDENTITY(1,1),
    department VARCHAR(50) CHECK (department IN ('Sales','Research & Development','Human Resources'))
);

-- 6️⃣ Job Role Table
CREATE TABLE HR_attrition.hr.Job_role (
    job_id INT PRIMARY KEY IDENTITY(1,1),
    job_role VARCHAR(50) CHECK (job_role IN 
        ('Sales Executive','Research Scientist','Laboratory Technician',
         'Manufacturing Director','Healthcare Representative','Manager',
         'Sales Representative','Research Director','Human Resources'))
);

-- 
CREATE TABLE HR_attrition.hr.Job_details (
    job_d_id INT PRIMARY KEY IDENTITY(1,1),
    job_involvement INT CHECK (job_involvement BETWEEN 1 AND 4),
    job_satisfaction INT CHECK (job_satisfaction BETWEEN 1 AND 4),
    performance_rating INT CHECK (performance_rating BETWEEN 1 AND 4),
    relation_satisfaction INT CHECK (relation_satisfaction BETWEEN 1 AND 4),
    dept_id INT NOT NULL FOREIGN KEY REFERENCES HR_attrition.hr.Department(dept_id),
    job_id INT NOT NULL FOREIGN KEY REFERENCES HR_attrition.hr.Job_role(job_id)
);

-- 
CREATE TABLE HR_attrition.hr.Compensation_details (
    comp_d_id INT PRIMARY KEY IDENTITY(1,1),
    daily_rate INT CHECK (daily_rate >= 0),
    hourly_rate INT CHECK (hourly_rate >= 0),
    monthly_rate INT CHECK (monthly_rate >= 0),
    monthly_income INT CHECK (monthly_income >= 0),
    percent_salary_hike INT CHECK (percent_salary_hike BETWEEN 0 AND 100),
    overtime VARCHAR(3) CHECK (overtime IN ('Yes','No')),
    stockoptionlevel INT CHECK (stockoptionlevel BETWEEN 0 AND 3)
);

-- 
CREATE TABLE HR_attrition.hr.Employee_History (
    hist_id INT PRIMARY KEY IDENTITY(1,1),
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    NumCompaniesWorked INT
);


ALTER TABLE HR_attrition.hr.Employee
ADD CONSTRAINT ed_ID_FK FOREIGN KEY(ed_ID) REFERENCES HR_attrition.hr.Education(ed_id);

ALTER TABLE HR_attrition.hr.Employee
ADD CONSTRAINT sc_ID_FK FOREIGN KEY(sc_ID) REFERENCES HR_attrition.hr.Emp_social_status(sc_id);

ALTER TABLE HR_attrition.hr.Employee
ADD CONSTRAINT comp_d_id_FK FOREIGN KEY(comp_d_id) REFERENCES HR_attrition.hr.Compensation_details(comp_d_id);

ALTER TABLE HR_attrition.hr.Employee
ADD CONSTRAINT job_d_id_FK FOREIGN KEY(job_d_id) REFERENCES HR_attrition.hr.Job_details(job_d_id);

ALTER TABLE HR_attrition.hr.Employee
ADD CONSTRAINT hist_id_FK FOREIGN KEY(hist_id) REFERENCES HR_attrition.hr.Employee_History(hist_id);

