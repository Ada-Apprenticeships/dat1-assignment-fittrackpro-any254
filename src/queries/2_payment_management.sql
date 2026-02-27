.open fittrackpro.db
.mode column

-- 2.1 

INSERT INTO payments (
    member_id,
    amount,
    payment_date,
    payment_method,
    payment_type
)
VALUES (
    11,
    50.00,
    datetime('now'),
    'Credit Card',
    'Monthly membership fee'
);

-- 2.2 

SELECT 
    strftime('%Y-%m', payment_date) AS month,
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_type = 'Monthly membership fee'
    AND date(payment_date) >= date('2024-11-01')
    AND date(payment_date) <= date('2025-02-28')
GROUP BY month
ORDER BY month;



-- 2.3 

SELECT 
    payment_id,
    amount,
    payment_date,
    payment_method
FROM payments 
WHERE payment_type = 'Day pass';
