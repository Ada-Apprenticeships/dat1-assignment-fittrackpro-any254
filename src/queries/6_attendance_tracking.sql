.open fittrackpro.db
.mode column

-- 6.1 

INSERT INTO attendance (
    member_id,
    location_id,
    check_in_time
)
VALUES (
    7,
    1,
    '2025-02-14 16:30:00'
);

-- 6.2 

SELECT 
    date(check_in_time) AS visit_date,
    check_in_time,
    check_out_time
FROM attendance
WHERE member_id = 5
ORDER BY check_in_time;

-- 6.3
SELECT day_of_week, visit_count
FROM (
    SELECT
        CASE strftime('%w', check_in_time)
            WHEN '0' THEN 'Sunday'
            WHEN '1' THEN 'Monday'
            WHEN '2' THEN 'Tuesday'
            WHEN '3' THEN 'Wednesday'
            WHEN '4' THEN 'Thursday'
            WHEN '5' THEN 'Friday'
            WHEN '6' THEN 'Saturday'
        END AS day_of_week,
        COUNT(*) AS visit_count
    FROM attendance
    GROUP BY strftime('%w', check_in_time)
)
ORDER BY visit_count DESC
LIMIT 1;

-- 6.4 

WITH RECURSIVE dates(d) AS (
--earliest attendance date in the whole table 
  SELECT date(MIN(check_in_time))
  FROM attendance

  UNION ALL

  -- adding one day untill we teach the latest attendance date
  SELECT date(julianday(d) + 1)
  FROM dates
  WHERE d < (SELECT date(MAX(check_in_time)) FROM attendance)
),

-- counts visits per location per day ( only days that accually have visits)
daily_visits AS (
  SELECT
    location_id,
    date(check_in_time) AS d,
    COUNT(*) AS visit_count
  FROM attendance
  GROUP BY location_id, date(check_in_time)
),

-- combine locations and dates so nothing gets missed
grid AS (
  SELECT
    l.location_id,
    l.name AS location_name,
    dates.d,
    COALESCE(dv.visit_count, 0) AS visit_count
  FROM locations l
  CROSS JOIN dates
  LEFT JOIN daily_visits dv
    ON dv.location_id = l.location_id
   AND dv.d = dates.d
)

-- calculates the average per location across all days 
SELECT DISTINCT
  location_name,
  ROUND(AVG(visit_count) OVER (PARTITION BY location_id), 2) AS avg_daily_attendance
FROM grid
ORDER BY location_name;