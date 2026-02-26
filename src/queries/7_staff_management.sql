.open fittrackpro.db
.mode column

-- 7.1 

SELECT 
    staff_id,
    first_name,
    last_name,
    position AS role
FROM staff
ORDER BY position;

-- 7.2 
SELECT 
    s.staff_id AS trainer_id,
    s.first_name || ' ' || s.last_name AS trainer_name, 
    COUNT(pts.session_id) AS session_count
FROM staff s 
JOIN personal_training_sessions pts
    ON pts.staff_id = s.staff_id
WHERE s.position = 'Trainer'
    AND date(pts.session_date) >= date('2025-01-20')
    AND date(pts.session_date) < date('2025-01-20', '+30 days')
GROUP BY s.staff_id, s.first_name, s.last_name
HAVING COUNT(pts.session_id) >= 1
ORDER BY session_count DESC;
