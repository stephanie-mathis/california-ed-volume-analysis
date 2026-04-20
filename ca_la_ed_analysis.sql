
-- LA Volume Trends Over Time

-- What are the  counties’ total and percentage for 2023? Where does LA stand?

SELECT
    h.county_name,
    SUM(s.total_ed_visits) AS county_total,
    ROUND(
        SUM(s.total_ed_visits) * 100.0 /
        (SELECT SUM(total_ed_visits)
          FROM emergency_stats
          WHERE category = 'All ED Visits'
              AND report_year = 2023 )
  		 )AS percent_of_state
FROM hospitals h
JOIN emergency_stats s
    ON h.oshpd_id = s.oshpd_id
WHERE s.category = 'All ED Visits'
  AND s.report_year = 2023
GROUP BY h.county_name
ORDER BY county_total DESC;

-- What is LA’s yoy growth total as well as the percent difference?

SELECT
    s.report_year,
    SUM(s.total_ed_visits) AS total_visits_per_year,
    ROUND(
        (
            SUM(s.total_ed_visits) -
            LAG(SUM(s.total_ed_visits)) OVER (ORDER BY s.report_year)
        ) * 100.0
        / LAG(SUM(s.total_ed_visits)) OVER (ORDER BY s.report_year),
        2) AS percent_change
FROM emergency_stats s
JOIN hospitals h
  ON h.oshpd_id = s.oshpd_id
WHERE h.county_name = 'Los Angeles'
  AND s.category = 'All ED Visits'
GROUP BY s.report_year
ORDER BY s.report_year;




-- High Level Demand Concentration

-- Which are the busiest hospitals in LA by ED visits? 

SELECT
    h.facility_name,
    s.total_ed_visits,
    SUM(s.total_ed_visits) OVER () AS la_county_total,
    ROUND(
        s.total_ed_visits * 100.0 / SUM(s.total_ed_visits) OVER (),
        2
       ) AS pct_of_county
FROM hospitals h
JOIN emergency_stats s
   ON h.oshpd_id = s.oshpd_id
WHERE s.category = 'All ED Visits'
  AND s.report_year = 2023
  AND h.county_name = 'Los Angeles'
ORDER BY s.total_ed_visits DESC;

-- What was MLK's growth from 2022 to 2023?

SELECT s.report_year, SUM(s.total_ed_visits) AS total_visit_count
FROM hospitals h
JOIN emergency_stats s ON h.oshpd_id = s.oshpd_id
WHERE category = 'All ED Visits' 
AND facility_name = 'Martin Luther King, Jr. Community Hospital'
GROUP BY report_year;

-- Identify hospitals with the largest year-over-year volume growth.

SELECT
    h.facility_name,
    SUM(CASE WHEN s.report_year = 2022 THEN s.total_ed_visits ELSE 0 END) AS visits_2022,
    SUM(CASE WHEN s.report_year = 2023 THEN s.total_ed_visits ELSE 0 END) AS visits_2023,
    ROUND(
        (
            SUM(CASE WHEN s.report_year = 2023 THEN s.total_ed_visits ELSE 0 END) -
            SUM(CASE WHEN s.report_year = 2022 THEN s.total_ed_visits ELSE 0 END)
        ) * 100.0 /
        NULLIF(SUM(CASE WHEN s.report_year = 2022 THEN s.total_ed_visits ELSE 0 END), 0)
    ) AS yoy_growth_pct
FROM hospitals h
JOIN emergency_stats s
    ON h.oshpd_id = s.oshpd_id
WHERE h.county_name = 'Los Angeles'
  AND s.category = 'All ED Visits'
  AND s.report_year IN (2022, 2023)
GROUP BY h.facility_name
ORDER BY yoy_growth_pct DESC NULLS LAST;


-- How are the  hospitals with the highest YOY growth perfoming?

SELECT s.report_year, h.facility_name,s.total_ed_visits, 
ROUND(s.visits_per_station) AS visits_per_station, 
s.primary_care_shortage_area, s.mental_health_shortage_area, s.ed_stations
FROM hospitals h
    JOIN emergency_stats s ON h.oshpd_id = s.oshpd_id
WHERE facility_name IN ('Palmdale Regional Medical Center', 'Providence Saint Joseph Medical Center', 
'Garfield Medical Center', 'Los Angeles County Olive View – UCLA Medical Center') 
AND category = 'All ED Visits'
ORDER BY facility_name, report_year;



-- What are the average visits per station for LA County for 2022 and 2023?

SELECT 
		(SELECT ROUND(AVG(s.visits_per_station))
		FROM hospitals h
		JOIN emergency_stats s ON h.oshpd_id = s.oshpd_id
		WHERE h.county_name = 'Los Angeles'
			AND s.report_year = 2022
			AND s.category = 'All ED Visits'
		) 
		AS avg_visits_per_station_2022,
	ROUND(AVG(s.visits_per_station)) AS avg_visits_per_station_2023
FROM hospitals h
JOIN emergency_stats s
    ON h.oshpd_id = s.oshpd_id
WHERE h.county_name = 'Los Angeles'
  AND s.report_year = 2023
  AND s.category = 'All ED Visits';

-- How does LA county’s average visit per station compare to San Diego for 2023?

SELECT
    h.county_name,
    ROUND(AVG(s.visits_per_station)) AS avg_visits_per_station,
    ROUND(MAX(s.visits_per_station)) AS max_visits_per_station,
    ROUND(MIN(s.visits_per_station)) AS min_visits_per_station
FROM hospitals h
JOIN emergency_stats s
    ON h.oshpd_id = s.oshpd_id
WHERE h.county_name IN ('Los Angeles', 'San Diego')
  AND s.report_year = 2023
  AND s.category = 'All ED Visits'
GROUP BY h.county_name
ORDER BY avg_visits_per_station DESC;

-- Which LA hospitals are above the county average for visits per station?

WITH la_vps AS (
    SELECT
        h.facility_name,
        s.total_ed_visits,
        s.ed_stations,
        ROUND(s.visits_per_station) AS visits_per_station,
        ROUND(AVG(s.visits_per_station) OVER ()) AS avg_la_county_vps_2023
    FROM hospitals h
    JOIN emergency_stats s
        ON h.oshpd_id = s.oshpd_id
    WHERE h.county_name = 'Los Angeles'
      AND s.report_year = 2023
      AND s.category = 'All ED Visits'
)
SELECT *
FROM la_vps
WHERE visits_per_station > avg_la_county_vps_2023
ORDER BY visits_per_station DESC;

-- Which Los Angeles hospitals fall within the top 5% for visits per station?

WITH la_stats AS (
    SELECT 
	    PERCENT_RANK() OVER (ORDER BY s.visits_per_station) AS la_percentile,
        h.facility_name,
		ROUND(s.visits_per_station) AS visits_per_station,
        s.total_ed_visits,
        s.ed_stations
    FROM hospitals h
    JOIN emergency_stats s
        ON h.oshpd_id = s.oshpd_id
    WHERE h.county_name = 'Los Angeles'
      AND s.report_year = 2023
      AND s.category = 'All ED Visits'
	ORDER BY la_percentile DESC
)
SELECT 
    facility_name,
    total_ed_visits,
    visits_per_station,
	ed_stations
FROM la_stats
WHERE la_percentile >= 0.95
ORDER BY visits_per_station DESC;

/* What are the diagnosis trends at Martin Luther King, Jr. Community Hospital, 
and are ED visits related to homelessness, substance use, and mental health increasing? */

WITH cte_mlk AS (
    SELECT 
        s.report_year,
        s.category,
        SUM(s.ed_dx_count) AS mlk_dx_total_count
    FROM hospitals h
    JOIN emergency_stats s
        ON h.oshpd_id = s.oshpd_id
    WHERE h.facility_name = 'Martin Luther King, Jr. Community Hospital'
      AND s.category <> 'All ED Visits' 
    GROUP BY s.report_year, s.category
)
SELECT 
    category,
    SUM(CASE WHEN report_year = 2022 THEN mlk_dx_total_count END) AS dx_count_2022,
    SUM(CASE WHEN report_year = 2023 THEN mlk_dx_total_count END) AS dx_count_2023,
    ROUND(
        (
            SUM(CASE WHEN report_year = 2023 THEN mlk_dx_total_count END) -
            SUM(CASE WHEN report_year = 2022 THEN mlk_dx_total_count END)
        )::numeric
        / SUM(CASE WHEN report_year = 2022 THEN mlk_dx_total_count END) * 100
    ) AS pct_diff
FROM cte_mlk
GROUP BY category
ORDER BY pct_diff DESC;

/* What is the current operational status of Monterey Park Hospital in terms of capacity and visits per station? */

SELECT s.report_year, s.ed_stations, s.total_ed_visits,
ROUND(s.visits_per_station) AS avg_visits_per_station
 FROM 
    hospitals h
    JOIN  emergency_stats s ON h.oshpd_id = s.oshpd_id
WHERE h.facility_name = 'Monterey Park Hospital'
AND s.category = 'All ED Visits'
ORDER BY s.report_year;

-- What growth has Providence Holy Cross Medical Center experienced from 2021 to 2023?

WITH cte_providence AS (
    SELECT
        s.report_year,
        SUM(s.total_ed_visits) AS total_visits
    FROM hospitals h
    JOIN emergency_stats s
        ON h.oshpd_id = s.oshpd_id
    WHERE h.facility_name = 'Providence Holy Cross Medical Center'
      AND s.report_year IN (2021, 2022, 2023)
      AND s.category = 'All ED Visits'
    GROUP BY s.report_year
)
SELECT
    SUM(CASE WHEN report_year = 2021 THEN total_visits ELSE 0 END) AS total_visits_2021,
    SUM(CASE WHEN report_year = 2022 THEN total_visits ELSE 0 END) AS total_visits_2022,
    ROUND(
        (
            SUM(CASE WHEN report_year = 2022 THEN total_visits ELSE 0 END) -
            SUM(CASE WHEN report_year = 2021 THEN total_visits ELSE 0 END)
        ) * 100.0 /
        NULLIF(SUM(CASE WHEN report_year = 2021 THEN total_visits ELSE 0 END), 0)
    ) AS pct_growth_2021_2022,
    SUM(CASE WHEN report_year = 2023 THEN total_visits ELSE 0 END) AS total_visits_2023,
    ROUND(
        (
            SUM(CASE WHEN report_year = 2023 THEN total_visits ELSE 0 END) -
            SUM(CASE WHEN report_year = 2022 THEN total_visits ELSE 0 END)
        ) * 100.0 /
        NULLIF(SUM(CASE WHEN report_year = 2022 THEN total_visits ELSE 0 END), 0)
    ) AS pct_growth_2022_2023
FROM cte_providence;


/* What is the operational status of Providence Holy Cross Medical Center
in terms of capacity and visits per station? */

SELECT
    s.report_year,
    s.licensed_bed_size,
    s.total_ed_visits,
    s.ed_stations,
    ROUND(s.visits_per_station, 2) AS visits_per_station
FROM hospitals h
JOIN emergency_stats s
    ON h.oshpd_id = s.oshpd_id
WHERE h.facility_name = 'Providence Holy Cross Medical Center'
  AND s.report_year IN (2021, 2022, 2023)
  AND s.category = 'All ED Visits'
ORDER BY s.report_year;

-- What are the diagnosis trends at Providence Holy Cross Medical Center?

WITH cte_phcmc AS (
    SELECT 
        s.report_year,
        s.category,
        SUM(s.ed_dx_count) AS phcmc_dx_total_count
    FROM hospitals h
    JOIN emergency_stats s
        ON h.oshpd_id = s.oshpd_id
    WHERE h.facility_name = 'Providence Holy Cross Medical Center'
      AND s.category <> 'All ED Visits' 
    GROUP BY s.report_year, s.category
)
SELECT 
    category,
    SUM(CASE WHEN report_year = 2022 THEN phcmc_dx_total_count END) AS dx_count_2022,
    SUM(CASE WHEN report_year = 2023 THEN phcmc_dx_total_count END) AS dx_count_2023,
    ROUND(
        (
            SUM(CASE WHEN report_year = 2023 THEN phcmc_dx_total_count END) -
            SUM(CASE WHEN report_year = 2022 THEN phcmc_dx_total_count END)
        )::numeric
        / SUM(CASE WHEN report_year = 2022 THEN phcmc_dx_total_count END) * 100
    ) AS pct_diff
FROM cte_phcmc
GROUP BY category
ORDER BY pct_diff DESC;













