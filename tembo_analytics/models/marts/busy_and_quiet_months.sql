WITH booking_counts AS(
    SELECT * FROM {{ ref('stg_hotel_bookings')}}
)
SELECT COUNT(booking_id) AS total_bookings, booking_month
FROM booking_counts
WHERE booking_month IS NOT null
GROUP BY booking_month
ORDER BY total_bookings DESC