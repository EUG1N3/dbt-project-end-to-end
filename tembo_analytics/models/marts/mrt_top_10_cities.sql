WITH guest_cities AS (
    SELECT * FROM {{ ref('stg_hotel_bookings')}}
)
SELECT COUNT(booking_id) AS total_guest_bookings,
guest_city
FROM guest_cities
WHERE booking_status = 'Checked Out'
AND guest_city IS NOT NULL
GROUP BY guest_city
ORDER BY total_guest_bookings DESC
LIMIT 10