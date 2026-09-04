WITH staff_bookings AS(
    SELECT * FROM {{ ref('stg_hotel_bookings')}}
)
SELECT COUNT(booking_id) AS total_bookings, 
hotel_employee
FROM staff_bookings
GROUP BY hotel_employee
ORDER BY total_bookings DESC