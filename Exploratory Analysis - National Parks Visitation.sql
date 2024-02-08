-- Exploratory Analysis of U.S. National Park Dataset
-- Author: Alex
-- Date: 1/27/2024
------------------------------------------------------------------------------------------------------------------
-- Data Sources
---	Kaggle:				The United States National Parks (2021) 
--- Travel Lemming:		63 Ranked National Parks in the USA (2022)
------------------------------------------------------------------------------------------------------------------

-- Pretext

-- Using datasets with information about National Park establishment dates, names, states, area, visitation, parks per state, & rankings, I am joining park counts by state and ranking data with visitation data.
-- Rankings are based on the collection methods used in the curation of the dataset downloaded from the Travel Lemming website.

-- Visitation is for 2021 and increases by several percentage points per year.
--- example: Great Smoky Mountains visitation grew by 4.6% per year on average from 1940-2021 
--- example calculation can be found in the excel doc. entitled: "state national parks - state, size, annual visitors" in my GitHub (4th sheet)
--- Longitudinal visitation data used in example found at "www.nationalparked.com/great-smoky-mountains/visitation-statistics"

------------------------------------------------------------------------------------------------------------------

-- Joining [a] datasets: [state national parks a - state, size, annual visitors] & [state national parks a - parks per state]

------------------------------------------------------------------------------------------------------------------
select 
	np.[index],
	np.Date_Sequence as 'Date Sequence',
	np.Date_Established as 'Date Established',
	np.Park_Name as 'Park Name',
	np.State,
	npc.Total_parks as 'Parks/State',
	np.NumVisitors_2021 as 'Num Visitors',
	round(np.Acres, 2) as Acres,
	round(np.Km2, 2) as 'Km 2',
	round((np.NumVisitors_2021/np.Acres), 2) as 'Visits/Acre',
	round((np.NumVisitors_2021/np.Km2), 2) as 'Visits/Km2'
from dbo.[state national parks a - state, size, annual visitors] as np
inner join dbo.[state national parks a - parks per state] as npc 
on np.State = npc.State
order by np.State desc, np.Date_Sequence;

-- Joined dataset containing count of parks per state with the dataset containing park names, states, park size, visitation, & date established.
-- Saved resulting table in CSV file: "state national parks b - state, size, annual visitors, parks per state".

------------------------------------------------------------------------------------------------------------------

-- Checking for discrepancies in the data (A)

select Park_Name, State, Num_Visitors, Acres, Km_2, Visits_Acre from dbo.[state national parks b - state, size, annual visitors, parks per state];
select Park_Name, State, Visits_Acre from dbo.[state national parks b - ranks];

-- Visits/Acre/Km2 don't match between datasets because visitation in both datasets are from different years.
-- Calculated these measures in the first table and exclude them from the ranks dataset when joining tables for consistency.
-- Therefore visitation are 2021 numbers.

------------------------------------------------------------------------------------------------------------------

-- Checking for discrepancies in the data (B)

select * from dbo.[state national parks b - ranks] 
where [Biodiversity_Rank] = (select max([Biodiversity_Rank]) 
from dbo.[state national parks b - ranks]);

-- Checked for an outlier noticed in the biodiversity column and found that the land area of Missouri's Gateway Arch is so small and has so much human foot traffic moving through that the biodiversity cannot be accurately assessed.
-- A low number of plant & animal secies is deduced in light of this information. 
-- This National Park was assigned the maximum [Biodiversity_Rank] and minimum [Num_of_Species] for ordinal placement within the dataset.

------------------------------------------------------------------------------------------------------------------

-- Joining [b] datasets: [state national parks b - state, size, annual visitors, parks per state] & [state national parks b - ranks]
-- Added dense ranks and bins to categorize ranks for analysis

------------------------------------------------------------------------------------------------------------------
select
	np.[index],
	np.Date_Sequence as 'Date Sequence',
	np.Date_established as 'Date Established',
    np.Park_Name as 'Park Name',
	np.State,
	np.Parks_State as 'Parks/State',
    np.Num_Visitors as 'Annual Visitors',
    round(np.Acres, 2) as Acres,
	round(np.Km_2, 2) as 'Km 2',
	round(np.Visits_Acre, 2) as 'Visits/Acre',
	round(np.Visits_Km2, 2) as 'Visits/Km2',
    npr.Crowding_Rank as 'Crowding Rank',
    dense_rank() over (order by npr.Crowding_Rank) as 'Dense Crowding Rank',
    case
        when npr.Crowding_Rank between 1 and 16 then 'Least Crowded'
        when npr.Crowding_Rank between 17 and 32 then 'Somewhat Crowded'
        when npr.Crowding_Rank between 33 and 48 then 'Crowded'
		when npr.Crowding_Rank between 49 and 64 then 'Very Crowded'
        else 'Other'
    end as 'Crowding Rank Bin',
	npr.Review_Rank as 'Review Rank',
    dense_rank() over (order by npr.Review_Rank) as 'Dense Review Rank',
    case
        when npr.Review_Rank between 1 and 17 then 'Excellent'
        when npr.Review_Rank between 19 and 33 then 'Good'
        when npr.Review_Rank between 34 and 57 then 'Fair'
		when npr.Review_Rank between 58 and 62 then 'Average'
        else 'Other'
    end as 'Review Rank Bin',
	round(npr._1_5_Review, 2) as '1-5 Review',
	npr.Weather_Rank as 'Weather Rank',
    dense_rank() over (order by npr.Weather_Rank) as 'Dense Weather Rank',
	npr.Desireable_Weather_mo as 'Good Weather (mo.)',
	npr.Affordability_Rank as 'Affordability Rank',
    dense_rank() over (order by npr.Affordability_Rank) as 'Dense Affordability Rank',
    case
        when npr.Affordability_Rank between 1 and 16 then 'Very Affordable'
        when npr.Affordability_Rank between 17 and 32 then 'Affordable'
        when npr.Affordability_Rank between 33 and 48 then 'Less Affordable'
		when npr.Affordability_Rank between 49 and 64 then 'Expensive'
        else 'Other'
    end as 'Affordability Rank Bin',
	npr.Nightly_Avg_Lodging as 'Nightly Avg. Lodging',
	npr.Biodiversity_Rank as 'Biodiversity Rank',
    dense_rank() over (order by npr.Biodiversity_Rank) as 'Dense Biodiversity Rank',
    case
        when npr.Biodiversity_Rank between 1 and 17 then 'Very High Biodiversity'
        when npr.Biodiversity_Rank between 18 and 37 then 'High Biodiversity'
        when npr.Biodiversity_Rank between 38 and 50 then 'Moderate Biodiversity'
		when npr.Biodiversity_Rank between 51 and 63 then 'Low Biodiversity'
        else 'Unmeasurable'
    end as 'Biodiversity Rank Bin',
	npr.Num_of_Species as 'Num. of Species',
	npr.Accessibility_Rank as 'Accessibility Rank',
    dense_rank() over (order by npr.Accessibility_Rank) as 'Dense Accessibility Rank',
    case
        when npr.Accessibility_Rank between 1 and 15 then 'Very Accessible'
        when npr.Accessibility_Rank between 16 and 31 then 'Somewhat Accessible'
        when npr.Accessibility_Rank between 32 and 47 then 'Limited Access'
		when npr.Accessibility_Rank between 48 and 61 then 'Challenging Accessibility'
        else 'Other'
    end as 'Accessibility Rank Bin',
	round(npr.Dist_To_Airport_mi, 2) as 'Dist to Airport (mi.)',
	round(npr.Dist_To_City_mi, 2) as 'Dist to City (mi.)',
	round(npr.Dist_To_Airport_km, 2) as 'Dist to Airport (km.)',
	round(npr.Dist_To_City_km, 2) as 'Dist to City (km.)'
from 
    dbo.[state national parks b - state, size, annual visitors, parks per state] as np
inner join 
    dbo.[state national parks b - ranks] as npr 
	on np.Park_Name = npr.Park_Name and np.State = npr.State
	order by npr.Park_Name; 

-- Joined dataset containing rankings per park with the dataset containing a count of parks per state park names, states, park size, visitation, & date established.
-- Saved resulting table in CSV file: "state notional parks c - state, size, annual visitors, parks per state, ranks". 

-- Order by different ranks to see how National Parks compare.
-- [ Crowding_Rank / Review_Rank / Weather_Rank / Affordability_Rank / Accessibility_Rank / Biodiversity_Rank ]

------------------------------------------------------------------------------------------------------------------

-- A few interesting findings relating to biodiversity and crowding in National Parks

-- With over 6 times the number of plant and animal species than Parks with the next highest numbers of plant and animal species, when ordered from most to least biodiverse, Great Smoky Mountains is displayed at the top of the list –revealing this National Park as the most bidiverse.

-- When odered from most to least crowded, Gatway Arch is placed at the top of the list –revealing this National Park as the smallest, least biodiverse, and among the most crowded National Parks among all National Parks in the United States. However, Gatway Arch still receives a 4.57/5 average review. It can be inferred that National Parks are popular and well received by visitors.

-- When comparing crowding ranks between parks that received an average review versus parks that received an excellent review, a third of the parks (2/6) that received an average review were also ranked as being very crowded or crowded while little over half of the parks (10/19) that received an excellent review were were also ranked as being very crowded or crowded. Parks with an excellent review are aproximately 58% more likely to be considered very crowded or crowded compared to parks with an average review. 

-- |(1 - (10/19)/(2/6))*100| = |(1 - (.5263/.3333))*100| = |(1 - 1.579)*100| = 57.9% rounds up to 58%

------------------------------------------------------------------------------------------------------------------
