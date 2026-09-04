WITH source AS(
    SELECT *
    FROM {{ ref('cleaned_tembo') }}
)
SELECT booking_id,
    guest_name,
    guest_city,
    guest_nationality,
    room_no AS room_number,
    room_type,
    room_rate_per_night,
    DATE_TRUNC('month', check_in_date) AS booking_month,
    DATE_TRUNC('month', check_out_date) AS check_out_month,
    nights_stayed,
    staff_name AS hotel_employee,
    staff_department AS employee_department,
    staff_salary AS employee_salary,
    payment_method,
    INITCAP(booking_status) AS booking_status,
    NULLIF(REGEXP_REPLACE(total_amount, '[^0-9.]', ''), '')::NUMERIC AS paid_amount,
    service_used AS service_type,
    service_price,
    guest_rating
FROM source
QUALIFY ROW_NUMBER () OVER (PARTITION BY booking_id ORDER BY booking_month) = 1 

ORDER BY booking_month ASC,
    check_out_month ASC



