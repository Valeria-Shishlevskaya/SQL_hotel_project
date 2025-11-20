--Функции 

/* 1) Функция, которая считает предоставляемый процент скидки, в зависимости от дня проживания: */

CREATE OR REPLACE FUNCTION calculate_discount(num_days INT)
RETURNS INT AS $$
DECLARE
    discount_percent INT;

BEGIN
    SELECT COALESCE(MAX(d.discount), 0)
    INTO discount_percent
    FROM Discounts d
    WHERE num_days >= d.count_days;

    RETURN discount_percent;
END;
$$ LANGUAGE plpgsql;


/* 2) Функция, которая считает итоговую стоимость приобретенных каждым гостем услуг: */

CREATE OR REPLACE FUNCTION calculate_total_services_cost(guest_id_param INT)
RETURNS NUMERIC AS $$
DECLARE
    total_cost NUMERIC;
BEGIN
    SELECT SUM(s.service_cost)
    INTO total_cost
    FROM Service_Bookings sb
    JOIN Services s ON sb.service_id = s.service_id
    WHERE sb.guest_id = guest_id_param; 

    IF total_cost IS NULL THEN
        total_cost := 0;
    END IF;

    RETURN total_cost;
END;
$$ LANGUAGE plpgsql;


/* 3) функция, которая определяет стоимость, которую должен заплатить гость за номер, учитывая класс и кроличетсво дней, без учета скидки */

CREATE OR REPLACE FUNCTION calculate_room_cost(guest_id_param INT)
RETURNS NUMERIC AS $$
DECLARE
    total_cost NUMERIC;
    days_stayed INT;
    cost_per_night NUMERIC;
BEGIN
    SELECT (rb.check_out_date - rb.check_in_date) AS days_stayed,
            rc.cost_per_night AS cost_per_night
    INTO days_stayed, cost_per_night
    FROM Room_Bookings rb
    JOIN Rooms r ON rb.room_id = r.room_id
    JOIN Room_Class rc ON r.room_class_id = rc.room_class_id
    WHERE rb.guest_id = guest_id_param;

    total_cost := days_stayed * cost_per_night;
    RETURN total_cost;
END;
$$ LANGUAGE plpgsql;


/* Итоговый запрос, с учетом этих трех функций: */


SELECT g.guest_name AS Имя,
       g.guest_surname AS Фамилия,
       calculate_room_cost(g.guest_id) AS Стоимость_без_скидки,
    calculate_discount(rb.check_out_date - rb.check_in_date) AS Процент_скидки,
    ROUND(calculate_room_cost(g.guest_id) * (1 -          calculate_discount(rb.check_out_date - rb.check_in_date) / 100.0), 2) AS    Стоимость_со_скидкой,
    calculate_total_services_cost(g.guest_id) AS Стоимость_за_услуги,
    ROUND( calculate_room_cost(g.guest_id) * 
        (1 - calculate_discount(rb.check_out_date - rb.check_in_date) / 100.0) +
        calculate_total_services_cost(g.guest_id), 2) AS Итоговая_стоимость
FROM Guests g
JOIN Room_Bookings rb ON g.guest_id = rb.guest_id;

