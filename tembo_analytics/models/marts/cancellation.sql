WITH cancelled_bookings_table AS(
    SELECT COUNT(booking_id) AS cancelled_bookings, room_type
    FROM {{('stg_hotel_bookings')}}
    WHERE booking_status = 'Cancelled'
    GROUP BY room_type), 
total_bookings AS(
    SELECT COUNT(booking_id) AS total_bookings, room_type
    FROM {{('stg_hotel_bookings')}}
    GROUP BY room_type), 
joined_table AS(
    SELECT c.cancelled_bookings, t.total_bookings, t.room_type
    FROM cancelled_bookings_table AS c
    LEFT JOIN total_bookings AS t 
    ON t.room_type = c.room_type)
SELECT room_type, ROUND(((cancelled_bookings / total_bookings) * 100), 2) cancelled_bookings_percentage
    FROM joined_table
    ORDER BY cancelled_bookings_percentage DESC

