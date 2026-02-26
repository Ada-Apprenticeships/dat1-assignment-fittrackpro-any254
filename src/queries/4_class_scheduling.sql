.open fittrackpro.db
.mode column

-- 4.1 
SELECT 
    cl.class_id, 
    cl.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name
FROM class_schedule cs 
JOIN classes cl
    ON cs.class_id = cl.class_id
JOIN staff s
    ON cs.staff_id = s.staff_id
ORDER BY cl.class_id;

-- 4.2 

SELECT 
    c.class_id,
    c.name,
    cs.start_time,
    cs.end_time, 
    (c.capacity - COUNT(ca.class_attendance_id)) AS available_spots
FROM class_schedule cs
JOIN classes c
    ON c.class_id = cs.class_id
LEFT JOIN class_attendance ca
    ON ca.schedule_id =cs.schedule_id
    AND ca.attendance_status = 'Registered'
WHERE date(cs.start_time) = '2025-02-01'
GROUP BY cs.schedule_id, c.class_id, c.name, cs.start_time, cs.end_time, c.capacity
HAVING available_spots > 0
ORDER BY cs.start_time;

-- 4.3 
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
SELECT cs.schedule_id, 11, 'Registered'
FROM class_schedule cs
WHERE cs.class_id = 1
    AND date(cs.start_time) = '2025-02-01'
ORDER BY cs.start_time
LIMIT 1;

-- 4.4 
DELETE FROM class_attendance
WHERE schedule_id = 7
    AND member_id = 3
    AND attendance_status = 'Registered';

-- 4.5 
SELECT 
    c.class_id,
    c.name AS class_name,
    COUNT(*) AS registration_count
FROM class_attendance ca
JOIN class_schedule cs
    ON ca.schedule_id = cs.schedule_id
JOIN classes c
    ON cs.class_id = c.class_id
WHERE ca.attendance_status = 'Registered'
GROUP BY c.class_id, c.name
ORDER BY registration_count DESC 
LIMIT 1;




-- 4.6 

SELECT ROUND(AVG(class_count), 2) AS avg_classes_per_member
FROM (
    SELECT 
        m.member_id,
        COUNT(ca.class_attendance_id) AS class_count
    FROM members m
    LEFT JOIN class_attendance ca
        ON ca.member_id =m.member_id
        AND ca.attendance_status IN ('Registered', 'Attended')
    GROUP BY m.member_id
);


