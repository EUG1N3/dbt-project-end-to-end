-- Average rating per room type 
WITH room_rating AS(
    SELECT * FROM {{ ref('stg_hotel_bookings')}}
)
SELECT room_type, 
AVG(guest_rating) AS average_room_type_rating
FROM room_rating
WHERE booking_status = 'Checked Out'
GROUP BY room_type
ORDER BY average_room_type_rating DESC