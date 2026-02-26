.open fittrackpro.db
.mode column

-- 3.1 
SELECT 
    equipment_id,
    name,
    next_maintenance_date
FROM equipment
WHERE date(next_maintenance_date)
BETWEEN date('2025-01-01')
    AND date('2025-01-01', '+30 days');

-- 3.2 
SELECT 
    type as equipent_type,
    count(type) as count
FROM equipment
GROUP BY type;


-- 3.3 
SELECT  
    type AS equipment_type,
    ROUND(AVG(julianday('now') - julianday(purchase_date))) AS avg_age_days
FROM equipment
GROUP BY type;