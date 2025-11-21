# NYC-Resteraunts-Heath-Inspection-Analysis-Project

## Project Overview  
This project provides a comprehensive analysis of NYC Restaurant Health Inspection results to support the Department of Health in enhancing public safety and operational efficiency. Leveraging a large dataset containing restaurant information, cuisine types, inspection scores, and violation codes, the analysis focuses on transforming raw, complex data into clear, actionable intelligence for city leadership.
The primary goal is to identify systemic issues in food safety, pinpoint high-risk areas and cuisine types, and provide data-driven recommendations for targeted policy, education, and inspection scheduling.

## Project Objectives  
The project aims to support the NYC Department of Health Commissioner and city leadership by delivering actionable insights into food safety performance, ensuring that resource allocation (inspections and education) is optimized to reduce public health risks across the five boroughs.

## Exploration Questions  
- Which violations are most common city-wide, and which boroughs or neighborhoods experience them most frequently?
- Which cuisines and neighborhoods consistently show the lowest food safety performance?
- How have restaurant grades and violations changed across boroughs and over time?
- Based on performance trends, where should the city deploy targeted inspections, policy changes, or food safety education efforts?

## Tools and Technologies  
- **Excel** – Initial data structuring and review using the Data Dictionary
- **PostgreSQL** – Data preparation, cleaning, modeling, and analysis
- **Tableau**  – Visualization and dashboard development

## Approach  
1. The raw inspection dataset, along with a supplementary Data Dictionary, was first obtained in Excel and reviewed for structure and completeness.
2. The dataset was then uploaded to PostgreSQL for data preparation and analysis.
3. A third table, Cuisine Classification, was added to standardize cuisine categories by joining it with the main dataset. A comprehensive SQL analysis was conducted to identify patterns in violations, grades, and cuisine types across New York City.
4. The cleaned dataset was then uploaded to Power BI for visualizations and reporting.

## Dashboards Description 
- **KPIs**: Number of Restaurants, Total Inspections, Total Critical Violations, Average Inspection Score
- **Stacked Horizontal Bar Chart**: Violations by Cuisine Classification
- **Stacked Column Chart**: Grade Distribution across Boroughs
- **Horizontal Bar Chart**: Top 5 Inspection Types
- **Line Chart**: Critical Violations Over Time
- **Heatmap Table**: Top 10 Violations and Their Frequency

## Key Insights
- **Out of 285,168 inspections, Manhattan (36.8%) recorded the highest number** , followed by Brooklyn (25.9%), Queens (24.52%), Bronx (9.19%), and Staten Island (3.48%).
- **Critical violations increased steadily from 2021, peaking in 2024 (~30%)**. In 2025, they dropped by ~7%, landing around 23%.
- **Over 51% of NYC restaurants have either not been graded or not yet inspected**. About 33% have received an A grade.
- The most common inspection types include:
Cycle Inspection – Initial
Cycle Inspection – Re-inspection
Pre-Permit (Operational) Initial Inspection
- **Manhattan (~19.8%) recorded the highest proportion of critical violations**, followed by Brooklyn, Queens, Bronx, and Staten Island.
Common critical violations included:
Improper cleaning and sanitizing
Food not properly protected
Presence of flies or flying insects
Evidence of mice
Lack of Food Protection Certificate (FPC)
- **East Asian & Pacific (~10%) and North & South American (~14.4%) cuisines had the highest proportions of critical violations**, indicating poor food safety performance in these categories.

## Recommendations
- Prioritize high-risk restaurants and repeat critical offenders—especially in Manhattan—for targeted inspections and rapid re-checks.
- Mandate advanced FPC training with emphasis on preventing critical issues such as pest control, food handling, and temperature management.
- Require daily self-inspection logs maintained by restaurant managers to improve internal accountability and ensure continuous quality assurance.

## Files Included  
- [README.md](README.md) → Provides a description of the project    
- [store sales database create queries.sql](store%20sales%20database%20create%20queries.sql) → SQL queries for data preparation.
- [store sales eda.sql](store%20sales%20eda.sql) → SQL queries for data anlaysis   
- [sales dashboard.png](sales%20dashboard.png) → Dashboard with all visualizations  

