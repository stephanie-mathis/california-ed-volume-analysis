# california-ed-volume-analysis
Healthcare data analysis project using California emergency department volume and capacity data to identify hospital growth, pressure, and county-level trends.

## Background & Overview

Los Angeles County has the highest volume of emergency department (ED) visits in California, consistently accounting for a significant share of the state’s total demand. As patient volume continues to fluctuate across facilities, hospital leadership faces increasing pressure to understand where demand is rising and which hospitals may be operating under strain.

This project analyzes emergency department data across Los Angeles County. The goal is to identify trends in ED volume, highlight high-growth hospitals, and evaluate operational strain using Visits Per Station as a key metric.
Insights and analysis are focused on the following key areas:

- County-Level Trends: Comparison of ED visit volume across California counties to understand how Los Angeles ranks within the state
- Year-Over-Year Growth: Identification of changes in ED visit volume over time, with a focus on recent growth patterns
- Hospital-Level Volume: Analysis of the busiest hospitals in Los Angeles County and their share of total visits
- Operational Strain: Evaluation of Visits Per Station to identify facilities experiencing the highest levels of demand relative to capacity
- High-Risk Facilities: Identification of hospitals in the top percentile of strain and those exceeding the county average
- Contributing Factors: Exploration of diagnosis categories (e.g., mental health, substance use) to better understand drivers of increased demand

This analysis is intended to support hospital leadership in making informed, proactive decisions around resource allocation, capacity planning, and operational strategy.

## Data Structure & Initial Checks

The dataset consists of two primary tables: hospitals and emergency_stats, joined by a shared hospital identifier (oshpd_id). Together, these tables provide both static hospital attributes and yearly emergency department performance metrics.

- The hospitals table contains descriptive information about each facility, including location, ownership, and classification.
- The emergency_stats table contains yearly emergency department data, including visit volume, capacity indicators, and operational metrics.

## Executive Summary
Los Angeles County accounts for the largest share of emergency department (ED) visits in California, handling approximately 23% of total statewide volume in 2023. While overall growth has stabilized year-over-year with only a 0.11% increase from 2022 to 2023, demand remains highly concentrated across a small number of hospitals, several of which are operating above average capacity based on Visits Per Station.

A subset of facilities falls within the top 5% of operational strain, indicating increased risk of overcrowding and resource pressure. Martin Luther King, Jr. Community Hospital stands out with both the high patient volume and the highest Visits Per Station in the county, indicating significant operational strain. The hospital has also seen increases in mental health and substance use visits, further contributing to this pressure.

## Insights Deep Dive

### LA Volume Trends Over Time

- Los Angeles County had the highest emergency department (ED) volume in California in 2023, reporting 2,576,439 visits, which represents approximately 23% of total statewide ED visits. This is more than 3x the volume of the second-highest county, San Diego, which accounted for 7% of total volume.

- Los Angeles County experienced a sharp increase in ED visits between 2021 and 2022, with volume rising by approximately 26% year-over-year. From 2022 to 2023, growth stabilized, with only a 0.11% increase, indicating that while demand remains high, the rate of increase has slowed considerably.

- Despite the slowdown in growth, total ED volume in 2023 remained elevated at over 2.57 million visits, suggesting that the system is operating at a sustained high-demand level rather than returning to pre-surge conditions. The combination of rapid prior growth and current stabilization suggests a shift from expansion to sustained pressure, where hospitals must manage consistently high volumes rather than prepare for continued rapid increases.

### Hospital-Level Demand Concentration

- ED demand within Los Angeles County is handled by a small number of high-volume hospitals, though operational strain is more accurately measured using Visits Per Station rather than volume alone. The top facilities each account for approximately 3–4% of total county volume, with the top five hospitals collectively representing a meaningful share of all ED visits.

- The busiest hospital, Martin Luther King, Jr. Community Hospital, reported 109,217 visits in 2023, accounting for approximately 4.24% of total LA County ED volume. This is an increase from 2022, where total visits were 99,493.

- Palmdale Regional Medical Center stands out among high-growth facilities, with ED visits increasing from 62,297 in 2022 to 80,002 in 2023, alongside elevated Visits Per Station (2,286) and overlapping primary care and mental health provider shortages — a combination that suggests rising demand may be outpacing both internal capacity and access to community-based care.

- Other high-volume facilities include Los Angeles General Medical Center (4.15%), Antelope Valley Medical Center (4.04%), Kaiser Foundation Hospital – Downey (3.64%), and Providence Holy Cross Medical Center (3.46%).

### Operational Strain & Contributing Factors

- The average Visits Per Station (VPS) across Los Angeles County hospitals in 2023 was approximately 1,595, compared to 1,542 in 2022, indicating consistently high operational demand. In comparison, San Diego's avg visit per station is 1,089 for 2023.

- Out of 56 hospitals, 3 facilities fall within the top 5% of Visits Per Station.
  - Martin Luther King, Jr. Community Hospital: 3,766 average visits per station
  - Monterey Park Hospital: 3,586 average visits per station	
  - Providence Holy Cross Medical Center: 2,786 average visits per station
    
These hospitals are most likely to experience overcrowding, longer wait times, and resource constraints due to demand exceeding available capacity.

- Martin Luther King, Jr. Community Hospital combines the highest volume with the highest Visits Per Station in the county, indicating elevated strain. The hospital also experienced a 126% increase in substance use visits, a 16% increase in homelessness visits, a 14% increase in mental health visits, and a 51% increase in sepsis diagnoses, contributing to ongoing demand. The facility is also located in an area with both a mental health and primary care provider shortage, further intensifying pressure on emergency services.

- Monterey Park Hospital ranks second in Visits Per Station, driven in part by a reduction in ED stations from 6 to 5 in 2023, while total ED visits continued to increase year-over-year. This combination of reduced capacity and rising demand directly contributes to elevated operational strain, despite no reported provider shortage in the area.

- Providence Holy Cross Medical Center has seen steady increases in ED volume, with a 26% rise from 2021 to 2022 and an 8% increase from 2022 to 2023. The hospital also experienced a 37% increase in substance use visits, the highest increase among its diagnosis categories. As demand continues to grow without a corresponding increase in capacity, this contributes to elevated Visits Per Station and overall strain.

## Recommendations

Based on the insights above, the following recommendations are proposed for hospital leadership in Los Angeles County:

- Prioritize high-strain facilities for targeted analysis and capacity planning. Hospitals in the top 5% of Visits Per Station — including Martin Luther King, Jr. Community Hospital, Monterey Park Hospital, and Providence Holy Cross Medical Center — should be prioritized for further evaluation. An analysis of wait times, staffing, patient throughput, and bed utilization will help to better understand performance constraints. Reviewing diagnosis-level trends (e.g., substance use, mental health, sepsis) can also help identify demand drivers and guide targeted interventions.

- Expand access to outpatient and community-based care in high-need areas. Facilities such as Martin Luther King, Jr. Community Hospital serve populations with mental health and primary care provider shortages, contributing to increased reliance on emergency services. Expanding mental health services, urgent care access, and primary care availability in surrounding communities could help reduce avoidable ED visits.

- Align capacity planning with sustained demand levels. Although ED growth has stabilized (+0.11% from 2022 to 2023), total volume remains elevated at over 2.57 million visits annually. Hospitals should shift from short-term surge response to long-term capacity planning, ensuring staffing, infrastructure, and resources are aligned with consistently high demand.

- Evaluate capacity constraints at rapidly growing facilities. Hospitals such as Monterey Park Hospital and Providence Holy Cross Medical Center are experiencing rising demand without corresponding increases in capacity. In Monterey’s case, a reduction in ED stations (from 6 to 5) has further intensified strain. Leadership should assess whether capacity expansion or operational redesign is needed to support continued growth.

