-- 1.	Revenue analysis: Total revenue by month, by room type, by payment method
-- 2.	Occupancy: Which room types are booked most? Average nights stayed per room type
-- 3.	Guest insights: Top 10 cities guests come from. Average rating per room type
-- 4.	Staff performance: Which staff handled the most bookings? Which department generates most revenue?
-- 5.	Trends: Revenue growth month over month (window function). Busiest vs quietest months
-- 6.	Cancellations: Cancellation rate per room type. Revenue lost from cancellations and no-shows
-- 
-- 1. Revenue analysis: Total revenue by month, by room type, by payment method
WITH total_monthly_revenue AS(
    SELECT * FROM {{ ref('stg_hotel_bookings')}}
)
SELECT 
booking_month,
room_type,
payment_method,
SUM(paid_amount) AS total_revenue
FROM total_monthly_revenue
WHERE booking_status = 'Checked Out'
GROUP BY booking_month, room_type, payment_method
ORDER BY booking_month

-- Occupancy: Which room types are booked most? Average nights stayed per room type