Variables used in the pie & radar charts are listed below along with their codebook names for reference.

(Categories)
Diabetes_012 - Adult was told they had diabetes or were pre-diabetic
Sex - Sex at birth
Age - Reported age in 5-year groupings
Education - Education Level
Income - Income Level

(Indicators)
HighBP - Adults who were told they have high blood pressure by a medical professional
HighChol - Adults who were told they have high cholesterol by a medical professional
BMI - body mass index (1-9999)
Smoker - Adults who are current smokers
Stroke - Ever Diagnosed with a Stroke
HeartDiseaseorAttack - Adults who were told they had angina or coronary heart disease
PhysActivity - Adults who reported doing physical activity or exercise during the past 30 days other than their regular job
Fruits - Adults who make fruit a regular/daily part of their diet
Veggies - Adults who make vegetables a regular/daily part of their diet

SAS Variable Name: DIABETE4
SAS Variable Name: BIRTHSEX
SAS Variable Name: _AGEG5YR
SAS Variable Name: EDUCA
SAS Variable Name: INCOME3

( search for these in the codebook_diabetes.pdf file )

SAS Variable Name: _RFHYPE6
SAS Variable Name: _RFCHOL3
SAS Variable Name: _BMI5
SAS Variable Name: _RFSMOK3
SAS Variable Name: CVDSTRK3
SAS Variable Name: CVDCRHD4
SAS Variable Name: _TOTINDA

About Dataset
- The survey was established in 1984. Data are collected monthly in all 50 states, Puerto Rico, the U.S. Virgin islands, and Guam.
- The original dataset contains responses from 438,693 individuals and has 303 features.
- The dataset used here [diabetes_012_health_indicators_BRFSS2021.csv] is a clean subset of 236,378 survey responses to the CDC's BRFSS2021.
- These features are either questions directly asked of participants, or calculated variables based on individual participant responses.
- For this dataset, a csv of the 2021 BRFSS dataset available on Kaggle was used.
- Link to data download: [ https://www.kaggle.com/datasets/julnazz/diabetes-health-indicators-dataset ]

Content
- The Behavioral Risk Factor Surveillance System (BRFSS) is an ongoing, state-based telephone survey that collects data about health-related risk behaviors, chronic health conditions, and the use of preventive services among adults aged 18 years and older residing in the United States. Conducted annually by the Centers for Disease Control and Prevention (CDC), the BRFSS has been providing valuable insights into the health status and behaviors of U.S. adults since its inception in 1984.
- For this dataset, a csv of the 2021 BRFSS dataset available on Kaggle was used. The original dataset contains responses from 438,693 individuals and has 303 features. These features are either questions directly asked of participants, or calculated variables based on individual participant responses.
- The target variable Diabetes_012 has 3 classes. 0 is for no diabetes or only during pregnancy, 1 is for prediabetes, and 2 is for diabetes. There is class imbalance in this dataset. This dataset has 21 feature variables.

Context
- Diabetes is a chronic health condition that affects how your body turns food into energy. There are three main types of diabetes: type 1, type 2, and gestational diabetes.
-- Type 1 diabetes is an autoimmune disease that causes your body to attack the cells in your pancreas that produce insulin. Insulin is a hormone that helps your body use glucose for energy.
-- Type 2 diabetes is the most common type of diabetes. It occurs when your body doesn't respond normally to insulin, or when your body doesn't produce enough insulin.
-- Gestational diabetes is a type of diabetes that develops during pregnancy. It usually goes away after the baby is born.

Prevalence of Diabetes
- According to the CDC BRFSS 2021, 34.1 million adults in the United States have diabetes, or 10.5% of the adult population. This number has been increasing over time. In 2010, 29.1 million adults in the United States had diabetes, or 9.3% of the adult population.
