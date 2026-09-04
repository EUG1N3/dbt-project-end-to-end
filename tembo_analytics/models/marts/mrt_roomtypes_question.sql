WITH occupancy AS(SELECT * FROM {{ ref('stg_hotel_bookings')}})
SELECT COUNT(booking_id) AS total_bookings,
AVG(nights_stayed) AS night_stayed_avg,
room_type
FROM occupancy
WHERE booking_status = 'Checked Out'
GROUP BY room_type
ORDER BY total_bookings DESC, night_stayed_avg DESC