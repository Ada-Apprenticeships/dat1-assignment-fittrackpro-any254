.open fittrackpro.db
.mode column

-- 8.1 

SELECT 
    pts.session_id, 
    TRIM(m.first_name || ' ' || m.last_name) AS memeber_name,
    strftime('%Y-%m-%d', pts.session_date) AS session_date,
    pts.start_time,
    pts.end_time
FROM personal_training_sessions AS pts
JOIN staff AS s
    ON s.staff_id = pts.staff_id
JOIN members AS m 
    ON m.member_id = pts.member_id
ORDER BY 
    pts.session_date,
    pts.start_time;
