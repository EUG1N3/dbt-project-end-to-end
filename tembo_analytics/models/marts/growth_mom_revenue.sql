WITH monthly_revenue AS(
    SELECT booking_month, room_type, SUM(paid_amount) AS total_revenue
FROM {{ref('stg_hotel_bookings')}}
GROUP BY booking_month, room_type),

prev_month AS (SELECT 
    booking_month, 
    room_type,
    total_revenue, 
    LAG(total_revenue) OVER(PARTITION BY room_type ORDER BY booking_month) AS prev_revenue 
FROM monthly_revenue)

SELECT booking_month, room_type, total_revenue, prev_revenue, 
ROUND(((prev_revenue - total_revenue)/total_revenue)*100, 2) AS percentage_growth FROM prev_month
