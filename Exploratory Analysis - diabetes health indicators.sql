-- Project: Exploritory Analysis of a Diabetes Health Indicators Dataset
-- Author: Alex Marvin
-- Source: Kaggle, The Behavioral Risk Factor Surveillance System (BRFSS)
-- More information about this dataset located in the [ diabetes_variable_info_README.md ] and [ codebook_diabetes.pdf ] files

-- - - - - - - - Table of Contents - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- NUMBERS BY DIAGNOSIS
-- CTE FOR CATEGORY SUMMARY, WINDOW FUNCTION FOR PROPORTION 
-- DIAGNOSIS BY SEX - long
-- DIAGNOSIS BY SEX - wide
-- DIAGNOSIS BY AGE - long
-- DIAGNOSIS BY AGE - wide
-- DIAGNOSIS BY EDUCATION - long
-- DIAGNOSIS BY EDUCATION - wide
-- DIAGNOSIS BY INCOME - long
-- DIAGNOSIS BY INCOME - wide
-- ANALYZING BY ALL SUBCATEGORIES - long (produces the table used to make the pie/radar charts)
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- NUMBERS BY DIAGNOSIS
-- Looking at averages of 9 health indicators along with the number of respondents in the dataset by diabetes status of the respondent.
select
case
        when Diabetes_012 = 0 then 'No Diabetes'
        when Diabetes_012 = 1 then 'Pre-Diabetic'
        when Diabetes_012 = 2 then 'Diabetic'
    end as Diabeties_Cat,
    count(*) as Num_Respondents,
    avg(cast(HighBP as decimal(10,2)))*100 as Pct_High_Blood_Pressure,
    avg(HighChol)*100 as Pct_High_Cholesterol,
    avg(BMI) as BMI_Avg,
    avg(Smoker)*100 as Pct_Smoke,
    avg(Stroke)*100 as Pct_Stroke,
    avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
	(avg(PhysActivity))*100 as Pct_PhysActive,
	(1-avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
	(1-avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
from diabetes_012
group by Diabetes_012;


-- CTE FOR CATEGORY SUMMARY, WINDOW FUNCTION FOR PROPORTION 
-- Used a calculated table expression to make a temporary table. Necessary to make the [Proportion_of_Sample] calculated field. 
with DiabetesSummary as (
    select
        case
            when Diabetes_012 = 0 then 'No Diabetes'
            when Diabetes_012 = 1 then 'Pre-Diabetic'
            when Diabetes_012 = 2 then 'Diabetic'
        end as Diabetes_Cat,
        count(*) as Num_Respondents,
        avg(cast(HighBP as decimal(10,2)))*100 as Pct_High_Blood_Pressure,
        avg(HighChol)*100 as Pct_High_Cholesterol,
        avg(BMI) as BMI_Avg,
        avg(Smoker)*100 as Pct_Smoke,
        avg(Stroke)*100 as Pct_Stroke,
        avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
        avg(PhysActivity)*100 as Pct_PhysActive,
        (1 - avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
        (1 - avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
    from diabetes_012
    group by Diabetes_012
)
select
    Diabetes_Cat,
    Num_Respondents,
	Num_Respondents * 100.0 / sum(Num_Respondents) over () as Proportion_of_Sample,
    Pct_High_Blood_Pressure,
    Pct_High_Cholesterol,
    BMI_Avg,
    Pct_Smoke,
    Pct_Stroke,
    Pct_Heart_Disease,
    Pct_PhysActive,
    Pct_MissingFruit,
    Pct_MissingVeggies
from DiabetesSummary;


-- Looking at the data across 2 dimensions [Diagnosis] & [Sex]
-- DIAGNOSIS BY SEX - long
with DiabetesSummary as (
    select
        case
            when Diabetes_012 = 0 then 'No Diabetes'
            when Diabetes_012 = 1 then 'Pre-Diabetic'
            when Diabetes_012 = 2 then 'Diabetic'
        end as Diabetes_Cat,
        case
            when Sex = 1 then 'Male'
            when Sex = 0 then 'Female'
        end as Gender,
        count(*) as Num_Respondents,
        avg(cast(HighBP as decimal(10,2)))*100 as Pct_High_Blood_Pressure,
        avg(HighChol)*100 as Pct_High_Cholesterol,
        avg(BMI) as BMI_Avg,
        avg(Smoker)*100 as Pct_Smoke,
        avg(Stroke)*100 as Pct_Stroke,
        avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
        avg(PhysActivity)*100 as Pct_PhysActive,
        (1 - avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
        (1 - avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
    from diabetes_012
    group by Diabetes_012, Sex
)
select
    Diabetes_Cat,
    Gender,
    Num_Respondents,
    Num_Respondents * 100.0 / sum(Num_Respondents) over () as Proportion_of_Sample,
    Pct_High_Blood_Pressure,
    Pct_High_Cholesterol,
    BMI_Avg,
    Pct_PhysActive,
    Pct_Smoke,
    Pct_Stroke,
    Pct_Heart_Disease,
    Pct_MissingFruit,
    Pct_MissingVeggies
from DiabetesSummary
order by Diabetes_Cat, Gender;


-- DIAGNOSIS BY SEX - wide
with DiabetesSummary as (
    select
        case
            when Diabetes_012 = 0 then 'No Diabetes'
            when Diabetes_012 = 1 then 'Pre-Diabetic'
            when Diabetes_012 = 2 then 'Diabetic'
        end as Diabetes_Cat,
        case 
            when Sex = 0 then 'Female'
            when Sex = 1 then 'Male'
        end as Gender,
        count(*) as Num_Respondents,
        avg(cast(HighBP as decimal(10,2)))*100 as Pct_High_Blood_Pressure,
        avg(HighChol)*100 as Pct_High_Cholesterol,
        avg(BMI) as BMI_Avg,
        avg(Smoker)*100 as Pct_Smoke,
        avg(Stroke)*100 as Pct_Stroke,
        avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
        avg(PhysActivity)*100 as Pct_PhysActive,
        (1 - avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
        (1 - avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
    from diabetes_012
    group by Diabetes_012, Sex
)
select
    Diabetes_Cat,
    max(case when Gender = 'Female' then Num_Respondents end) as Num_Respondents_Female,
    max(case when Gender = 'Male' then Num_Respondents end) as Num_Respondents_Male,
    max(case when Gender = 'Female' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_Female,
    max(case when Gender = 'Male' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_Male,
    max(case when Gender = 'Female' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_Female,
    max(case when Gender = 'Male' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_Male,
    max(case when Gender = 'Female' then BMI_Avg end) as BMI_Avg_Female,
    max(case when Gender = 'Male' then BMI_Avg end) as BMI_Avg_Male,
    max(case when Gender = 'Female' then Pct_Smoke end) as Pct_Smoke_Female,
    max(case when Gender = 'Male' then Pct_Smoke end) as Pct_Smoke_Male,
    max(case when Gender = 'Female' then Pct_Stroke end) as Pct_Stroke_Female,
    max(case when Gender = 'Male' then Pct_Stroke end) as Pct_Stroke_Male,
    max(case when Gender = 'Female' then Pct_Heart_Disease end) as Pct_Heart_Disease_Female,
    max(case when Gender = 'Male' then Pct_Heart_Disease end) as Pct_Heart_Disease_Male,
    max(case when Gender = 'Female' then Pct_PhysActive end) as Pct_PhysActive_Female,
    max(case when Gender = 'Male' then Pct_PhysActive end) as Pct_PhysActive_Male,
    max(case when Gender = 'Female' then Pct_MissingFruit end) as Pct_MissingFruit_Female,
    max(case when Gender = 'Male' then Pct_MissingFruit end) as Pct_MissingFruit_Male,
    max(case when Gender = 'Female' then Pct_MissingVeggies end) as Pct_MissingVeggies_Female,
    max(case when Gender = 'Male' then Pct_MissingVeggies end) as Pct_MissingVeggies_Male
from DiabetesSummary
group by Diabetes_Cat
order by Diabetes_Cat;


-- Looking at the data across 2 dimensions [Diagnosis] & [Age]
-- DIAGNOSIS BY AGE - long
with diabetessummary as (
    select
        case
            when diabetes_012 = 0 then 'No Diabetes'
            when diabetes_012 = 1 then 'Pre-Diabetic'
            when diabetes_012 = 2 then 'Diabetic'
        end as diabetes_cat,
        case 
            when age <= 3 then 'Under 35'
            when age between 4 and 7 then '35-54'
            when age >= 8 then '55+'
        end as age_group,
        count(*) as num_respondents,
        avg(cast(highbp as decimal(10,2)))*100 as pct_high_blood_pressure,
        avg(highchol)*100 as pct_high_cholesterol,
        avg(bmi) as bmi_avg,
        avg(smoker)*100 as pct_smoke,
        avg(stroke)*100 as pct_stroke,
        avg(heartdiseaseorattack)*100 as pct_heart_disease,
        avg(physactivity) * 100 as pct_physactive,
        (1-avg(cast(fruits as decimal(10,2))))*100 as pct_missingfruit, 
        (1-avg(cast(veggies as decimal(10,2))))*100 as pct_missingveggies
    from diabetes_012
    group by diabetes_012, age
)
select
    diabetes_cat,
    age_group,
    sum(num_respondents) as num_respondents,
    sum(num_respondents)*100.0 / sum(sum(num_respondents)) over () as proportion_of_sample,
    avg(pct_high_blood_pressure) as pct_high_blood_pressure,
    avg(pct_high_cholesterol) as pct_high_cholesterol,
    avg(bmi_avg) as bmi_avg,
    avg(pct_physactive) as pct_physactive,
    avg(pct_smoke) as pct_smoke,
    avg(pct_stroke) as pct_stroke,
    avg(pct_heart_disease) as pct_heart_disease,
    avg(pct_missingfruit) as pct_missingfruit,
    avg(pct_missingveggies) as pct_missingveggies
from diabetessummary
group by diabetes_cat, age_group
order by diabetes_cat, age_group;


-- DIAGNOSIS BY AGE - wide
with DiabetesSummary as (
    select
        case
            when Diabetes_012 = 0 then 'No Diabetes'
            when Diabetes_012 = 1 then 'Pre-Diabetic'
            when Diabetes_012 = 2 then 'Diabetic'
        end as Diabetes_Cat,
        case 
            when Age <= 3 then 'Under 35'
            when Age between 4 and 7 then '35-54'
            when Age >= 8 then '55+'
        end as Age_Group,
        count(*) as Num_Respondents,
        avg(cast(HighBP as decimal(10,2)))*100 as Pct_High_Blood_Pressure,
        avg(HighChol)*100 as Pct_High_Cholesterol,
        avg(BMI) as BMI_Avg,
        avg(Smoker)*100 as Pct_Smoke,
        avg(Stroke)*100 as Pct_Stroke,
        avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
        avg(PhysActivity)*100 as Pct_PhysActive,
        (1 - avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
        (1 - avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
    from diabetes_012
    group by Diabetes_012, Age
)
select
    Diabetes_Cat,
    max(case when Age_Group = 'Under 35' then Num_Respondents end) as Num_Respondents_Under35,
    max(case when Age_Group = '35-54' then Num_Respondents end) as Num_Respondents_35to54,
    max(case when Age_Group = '55+' then Num_Respondents end) as Num_Respondents_55Plus,
    max(case when Age_Group = 'Under 35' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_Under35,
    max(case when Age_Group = '35-54' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_35to54,
    max(case when Age_Group = '55+' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_55Plus,
    max(case when Age_Group = 'Under 35' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_Under35,
    max(case when Age_Group = '35-54' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_35to54,
    max(case when Age_Group = '55+' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_55Plus,
    max(case when Age_Group = 'Under 35' then BMI_Avg end) as BMI_Avg_Under35,
    max(case when Age_Group = '35-54' then BMI_Avg end) as BMI_Avg_35to54,
    max(case when Age_Group = '55+' then BMI_Avg end) as BMI_Avg_55Plus,
    max(case when Age_Group = 'Under 35' then Pct_Smoke end) as Pct_Smoke_Under35,
    max(case when Age_Group = '35-54' then Pct_Smoke end) as Pct_Smoke_35to54,
    max(case when Age_Group = '55+' then Pct_Smoke end) as Pct_Smoke_55Plus,
    max(case when Age_Group = 'Under 35' then Pct_Stroke end) as Pct_Stroke_Under35,
    max(case when Age_Group = '35-54' then Pct_Stroke end) as Pct_Stroke_35to54,
    max(case when Age_Group = '55+' then Pct_Stroke end) as Pct_Stroke_55Plus,
    max(case when Age_Group = 'Under 35' then Pct_Heart_Disease end) as Pct_Heart_Disease_Under35,
    max(case when Age_Group = '35-54' then Pct_Heart_Disease end) as Pct_Heart_Disease_35to54,
    max(case when Age_Group = '55+' then Pct_Heart_Disease end) as Pct_Heart_Disease_55Plus,
    max(case when Age_Group = 'Under 35' then Pct_PhysActive end) as Pct_PhysActive_Under35,
    max(case when Age_Group = '35-54' then Pct_PhysActive end) as Pct_PhysActive_35to54,
    max(case when Age_Group = '55+' then Pct_PhysActive end) as Pct_PhysActive_55Plus,
    max(case when Age_Group = 'Under 35' then Pct_MissingFruit end) as Pct_MissingFruit_Under35,
    max(case when Age_Group = '35-54' then Pct_MissingFruit end) as Pct_MissingFruit_35to54,
	max(case when Age_Group = '55+' then Pct_MissingFruit end) as Pct_MissingFruit_55Plus,
    max(case when Age_Group = 'Under 35' then Pct_MissingVeggies end) as Pct_MissingVeggies_Under35,
    max(case when Age_Group = '35-54' then Pct_MissingVeggies end) as Pct_MissingVeggies_35to54,
    max(case when Age_Group = '55+' then Pct_MissingVeggies end) as Pct_MissingVeggies_55Plus
from DiabetesSummary
group by Diabetes_Cat
order by Diabetes_Cat;


-- Looking at the data across 2 dimensions [Diagnosis] & [Education]
-- DIAGNOSIS BY EDUCATION - long
with DiabetesSummary AS (
    select
        case
            when Diabetes_012 = 0 then 'No Diabetes'
            when Diabetes_012 = 1 then 'Pre-Diabetic'
            when Diabetes_012 = 2 then 'Diabetic'
        end as Diabetes_Cat,
        case 
            when Education <= 3 then 'No HS Deg.'
            when Education between 4 and 5 then 'HS Graduate'
            when Education >= 6 then 'Graduate'
        end as Educ_Group,
        count(*) as Num_Respondents,
        avg(CAST(HighBP as decimal(10,2)))*100 AS Pct_High_Blood_Pressure,
        avg(HighChol)*100 as Pct_High_Cholesterol,
        avg(BMI) as BMI_Avg,
        avg(Smoker)*100 as Pct_Smoke,
        avg(Stroke)*100 as Pct_Stroke,
        avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
        avg(PhysActivity)*100 as Pct_PhysActive,
        (1 - avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
        (1 - avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
    from diabetes_012
    group by Diabetes_012, Education
)
select
    Diabetes_Cat,
    Educ_Group,
    sum(Num_Respondents) as Num_Respondents,
    sum(Num_Respondents)*100.0 / sum(sum(Num_Respondents)) over () as Proportion_of_Sample,
    avg(Pct_High_Blood_Pressure) as Pct_High_Blood_Pressure,
    avg(Pct_High_Cholesterol) as Pct_High_Cholesterol,
    avg(BMI_Avg) as BMI_Avg,
    avg(Pct_PhysActive) as Pct_PhysActive,
    avg(Pct_Smoke) as Pct_Smoke,
    avg(Pct_Stroke) as Pct_Stroke,
    avg(Pct_Heart_Disease) as Pct_Heart_Disease,
    avg(Pct_MissingFruit) as Pct_MissingFruit,
    avg(Pct_MissingVeggies) as Pct_MissingVeggies
from DiabetesSummary
group by Diabetes_Cat, Educ_Group
order by Diabetes_Cat, Educ_Group desc;


-- DIAGNOSIS BY EDUCATION - wide
with DiabetesSummary as (
    select
        case
            when Diabetes_012 = 0 then 'No Diabetes'
            when Diabetes_012 = 1 then 'Pre-Diabetic'
            when Diabetes_012 = 2 then 'Diabetic'
        end as Diabetes_Cat,
        case 
            when Education <= 3 then 'No HS Deg.'
            when Education between 4 and 5 then 'HS Graduate'
            when Education >= 6 then 'Graduate'
        end as Educ_Group,
        count(*) as Num_Respondents,
        avg(cast(HighBP as decimal(10,2)))*100 as Pct_High_Blood_Pressure,
        avg(HighChol)*100 as Pct_High_Cholesterol,
        avg(BMI) as BMI_Avg,
        avg(Smoker)*100 as Pct_Smoke,
        avg(Stroke)*100 as Pct_Stroke,
        avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
        avg(PhysActivity)*100 as Pct_PhysActive,
        (1 - avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
        (1 - avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
    from diabetes_012
    group by Diabetes_012, Education
)
select
	Diabetes_Cat,
    max(case when Educ_Group = 'No HS Deg.' then Num_Respondents end) as Num_Respondents_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then Num_Respondents end) as Num_Respondents_HSGrad,
    max(case when Educ_Group = 'Graduate' then Num_Respondents end) as Num_Respondents_Grad,
    max(case when Educ_Group = 'No HS Deg.' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_HSGrad,
    max(case when Educ_Group = 'Graduate' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_Grad,
    max(case when Educ_Group = 'No HS Deg.' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_HSGrad,
    max(case when Educ_Group = 'Graduate' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_Grad,
    max(case when Educ_Group = 'No HS Deg.' then BMI_Avg end) as BMI_Avg_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then BMI_Avg end) as BMI_Avg_HSGrad,
    max(case when Educ_Group = 'Graduate' then BMI_Avg end) as BMI_Avg_Grad,
    max(case when Educ_Group = 'No HS Deg.' then Pct_Smoke end) as Pct_Smoke_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then Pct_Smoke end) as Pct_Smoke_HSGrad,
    max(case when Educ_Group = 'Graduate' then Pct_Smoke end) as Pct_Smoke_Grad,
    max(case when Educ_Group = 'No HS Deg.' then Pct_Stroke end) as Pct_Stroke_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then Pct_Stroke end) as Pct_Stroke_HSGrad,
    max(case when Educ_Group = 'Graduate' then Pct_Stroke end) as Pct_Stroke_Grad,
    max(case when Educ_Group = 'No HS Deg.' then Pct_Heart_Disease end) as Pct_Heart_Disease_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then Pct_Heart_Disease end) as Pct_Heart_Disease_HSGrad,
    max(case when Educ_Group = 'Graduate' then Pct_Heart_Disease end) as Pct_Heart_Disease_Grad,
    max(case when Educ_Group = 'No HS Deg.' then Pct_PhysActive end) as Pct_PhysActive_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then Pct_PhysActive end) as Pct_PhysActive_HSGrad,
    max(case when Educ_Group = 'Graduate' then Pct_PhysActive end) as Pct_PhysActive_Grad,
    max(case when Educ_Group = 'No HS Deg.' then Pct_MissingFruit end) as Pct_MissingFruit_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then Pct_MissingFruit end) as Pct_MissingFruit_HSGrad,
    max(case when Educ_Group = 'Graduate' then Pct_MissingFruit end) as Pct_MissingFruit_Grad,
    max(case when Educ_Group = 'No HS Deg.' then Pct_MissingVeggies end) as Pct_MissingVeggies_LessThanHS,
    max(case when Educ_Group = 'HS Graduate' then Pct_MissingVeggies end) as Pct_MissingVeggies_HSGrad,
    max(case when Educ_Group = 'Graduate' then Pct_MissingVeggies end) as Pct_MissingVeggies_Grad
from DiabetesSummary
group by Diabetes_Cat
order by Diabetes_Cat;


-- Looking at the data across 2 dimensions [Diagnosis] & [Income]
-- DIAGNOSIS BY INCOME - long
with DiabetesSummary AS (
    select
        case
            when Diabetes_012 = 0 then 'No Diabetes'
            when Diabetes_012 = 1 then 'Pre-Diabetic'
            when Diabetes_012 = 2 then 'Diabetic'
        end as Diabetes_Cat,
        case 
            when Income <= 5 then '< 35K'
            when Income between 6 and 8 then '35K - 100K'
            when Income >= 6 then '> 100K'
        end as Inc_Group,
        count(*) as Num_Respondents,
        avg(CAST(HighBP as decimal(10,2)))*100 as Pct_High_Blood_Pressure,
        avg(HighChol)*100 as Pct_High_Cholesterol,
        avg(BMI) as BMI_Avg,
        avg(Smoker)*100 as Pct_Smoke,
        avg(Stroke)*100 as Pct_Stroke,
        avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
        avg(PhysActivity)*100 as Pct_PhysActive,
        (1 - avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
        (1 - avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
    from diabetes_012
    group by Diabetes_012, Income
)
select
    Diabetes_Cat,
    Inc_Group,
    sum(Num_Respondents) as Num_Respondents,
    sum(Num_Respondents)*100.0 / sum(sum(Num_Respondents)) over () as Proportion_of_Sample,
    avg(Pct_High_Blood_Pressure) as Pct_High_Blood_Pressure,
    avg(Pct_High_Cholesterol) as Pct_High_Cholesterol,
    avg(BMI_Avg) as BMI_Avg,
    avg(Pct_PhysActive) as Pct_PhysActive,
    avg(Pct_Smoke) as Pct_Smoke,
    avg(Pct_Stroke) as Pct_Stroke,
    avg(Pct_Heart_Disease) as Pct_Heart_Disease,
    avg(Pct_MissingFruit) as Pct_MissingFruit,
    avg(Pct_MissingVeggies) as Pct_MissingVeggies
from DiabetesSummary
group by Diabetes_Cat, Inc_Group
order by Diabetes_Cat, Inc_Group desc;


-- DIAGNOSIS BY INCOME - wide
with DiabetesSummary as (
    select
        case
            when Diabetes_012 = 0 then 'No Diabetes'
            when Diabetes_012 = 1 then 'Pre-Diabetic'
            when Diabetes_012 = 2 then 'Diabetic'
        end as Diabetes_Cat,
        case 
            when Income <= 5 then '< 35K'
            when Income between 6 and 8 then '35K - 100K'
            when Income >= 9 then '> 100K'
        end as Inc_Group,
        count(*) as Num_Respondents,
        avg(cast(HighBP as decimal(10,2)))*100 as Pct_High_Blood_Pressure,
        avg(HighChol)*100 as Pct_High_Cholesterol,
        avg(BMI) as BMI_Avg,
        avg(Smoker)*100 as Pct_Smoke,
        avg(Stroke)*100 as Pct_Stroke,
        avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
        avg(PhysActivity)*100 as Pct_PhysActive,
        (1 - avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
        (1 - avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
    from diabetes_012
    group by Diabetes_012, Income
)
select
    Diabetes_Cat,
    max(case when Inc_Group = '< 35K' then Num_Respondents end) as Num_Respondents_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then Num_Respondents end) as Num_Respondents_Between35K100K,
    max(case when Inc_Group = '> 100K' then Num_Respondents end) as Num_Respondents_Above100K,
    max(case when Inc_Group = '< 35K' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_Between35K100K,
    max(case when Inc_Group = '> 100K' then Pct_High_Blood_Pressure end) as Pct_High_Blood_Pressure_Above100K,
    max(case when Inc_Group = '< 35K' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_Between35K100K,
    max(case when Inc_Group = '> 100K' then Pct_High_Cholesterol end) as Pct_High_Cholesterol_Above100K,
    max(case when Inc_Group = '< 35K' then BMI_Avg end) as BMI_Avg_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then BMI_Avg end) as BMI_Avg_Between35K100K,
    max(case when Inc_Group = '> 100K' then BMI_Avg end) as BMI_Avg_Above100K,
    max(case when Inc_Group = '< 35K' then Pct_Smoke end) as Pct_Smoke_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then Pct_Smoke end) as Pct_Smoke_Between35K100K,
    max(case when Inc_Group = '> 100K' then Pct_Smoke end) as Pct_Smoke_Above100K,
    max(case when Inc_Group = '< 35K' then Pct_Stroke end) as Pct_Stroke_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then Pct_Stroke end) as Pct_Stroke_Between35K100K,
    max(case when Inc_Group = '> 100K' then Pct_Stroke end) as Pct_Stroke_Above100K,
    max(case when Inc_Group = '< 35K' then Pct_Heart_Disease end) as Pct_Heart_Disease_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then Pct_Heart_Disease end) as Pct_Heart_Disease_Between35K100K,
    max(case when Inc_Group = '> 100K' then Pct_Heart_Disease end) as Pct_Heart_Disease_Above100K,
    max(case when Inc_Group = '< 35K' then Pct_PhysActive end) as Pct_PhysActive_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then Pct_PhysActive end) as Pct_PhysActive_Between35K100K,
    max(case when Inc_Group = '> 100K' then Pct_PhysActive end) as Pct_PhysActive_Above100K,
    max(case when Inc_Group = '< 35K' then Pct_MissingFruit end) as Pct_MissingFruit_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then Pct_MissingFruit end) as Pct_MissingFruit_Between35K100K,
    max(case when Inc_Group = '> 100K' then Pct_MissingFruit end) as Pct_MissingFruit_Above100K,
    max(case when Inc_Group = '< 35K' then Pct_MissingVeggies end) as Pct_MissingVeggies_LessThan35K,
    max(case when Inc_Group = '35K - 100K' then Pct_MissingVeggies end) as Pct_MissingVeggies_Between35K100K,
    max(case when Inc_Group = '> 100K' then Pct_MissingVeggies end) as Pct_MissingVeggies_Above100K
from DiabetesSummary
group by Diabetes_Cat
order by Diabetes_Cat;


-- ANALYZING BY ALL SUBCATEGORIES - long
-- Used resulting table to make the used to make the pie/radar charts that can dynamically change with any filter selection.
with DiabetesSummary as (
    select
        case
            when Diabetes_012 = 0 then 'No Diabetes'
            when Diabetes_012 = 1 then 'Pre-Diabetic'
            when Diabetes_012 = 2 then 'Diabetic'
        end as Diabetes_Cat,case
            when Sex = 1 then 'Male'
            when Sex = 0 then 'Female'
        end as Gender,
		case 
            when age <= 3 then 'Under 35'
            when age between 4 and 7 then '35-54'
            when age >= 8 then '55+'
        end as age_group,
		case 
            when Education <= 3 then 'No HS Deg.'
            when Education between 4 and 5 then 'HS Graduate'
            when Education >= 6 then 'Graduate'
        end as Educ_Group,
		case 
            when Income <= 5 then '< 35K'
            when Income between 6 and 8 then '35K - 100K'
            when Income >= 6 then '> 100K'
        end as Inc_Group,
        count(*) as Num_Respondents,
        avg(cast(HighBP as decimal(10,2)))*100 as Pct_High_Blood_Pressure,
        avg(HighChol)*100 as Pct_High_Cholesterol,
        avg(BMI) as BMI_Avg,
        avg(Smoker)*100 as Pct_Smoke,
        avg(Stroke)*100 as Pct_Stroke,
        avg(HeartDiseaseorAttack)*100 as Pct_Heart_Disease,
        avg(PhysActivity)*100 as Pct_PhysActive,
        (1 - avg(cast(Fruits as decimal(10,2))))*100 as Pct_MissingFruit, 
        (1 - avg(cast(Veggies as decimal(10,2))))*100 as Pct_MissingVeggies
    from diabetes_012
    group by Diabetes_012, Sex, age, Education, Income
)
select
    Diabetes_Cat,
	Gender,
	age_group,
	Educ_Group,
	Inc_Group,
    Num_Respondents,
	Num_Respondents * 100.0 / sum(Num_Respondents) over () as Proportion_of_Sample,
    Pct_High_Blood_Pressure,
    Pct_High_Cholesterol,
    BMI_Avg,
	Pct_PhysActive,
    Pct_Smoke,
    Pct_Stroke,
    Pct_Heart_Disease,
    Pct_MissingFruit,
    Pct_MissingVeggies
from DiabetesSummary
order by Diabetes_Cat, Gender, age_group, Educ_Group desc, Inc_Group desc;


-- A wide version of the last table containing all categories will result in a table with 126 columns of information unique to each combination of category. 
-- This doesn't fundamentally change the interpretation of the data and actually makes for an easier visual comparison between specific combinations of categories.
-- But because filtering typically relies on a single variable to adjust the displayed content dynamically, having the data in wide form makes it hard or impossible to produce anything other than static and one-dimensional visuals.
