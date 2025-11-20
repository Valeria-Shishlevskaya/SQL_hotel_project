--WITH

/* 4) Хочу получить информацию о том в каких классах номеров проживали мужчины, и в каких классах проживали женщины. */

WITH GuestClasses AS (
    SELECT 
        g.guest_id,
        g.gender AS Пол,
        rc.class_name AS Класс_номера
    FROM Guests g
    JOIN Room_Bookings rb ON g.guest_id = rb.guest_id
    JOIN Rooms r ON rb.room_id = r.room_id
    JOIN Room_Class rc ON r.room_class_id = rc.room_class_id
)
SELECT Пол,
       Класс_номера,
       COUNT(*) AS Количество_гостей
FROM GuestClasses
GROUP BY Пол, Класс_номера
ORDER BY Пол, Класс_номера;
