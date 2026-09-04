WITH department_revenue AS(
    SELECT * FROM {{ ('stg_hotel_bookings')}}
)
SELECT SUM(paid_amount) AS total_revenue,
employee_department
FROM department_revenue
WHERE booking_status = 'Checked Out'
GROUP BY employee_department
ORDER BY total_revenue DESC
