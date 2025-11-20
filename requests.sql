
/* Запросы, подзапросы, JOIN, оконные функции */

/* 1)посмотрим на профессию и стомость услуги каждого из работников, выведя их по уменьшению стоимости предоставляемой работником услуги */

SELECT s.job, s.name, s.surname, se.service_cost 
FROM Staff s, Staff_Services ss, Services se
WHERE s.staff_id = ss.staff_id and ss.service_id = se.service_id
ORDER BY se.service_cost DESC;


/* 2)также используя подзапросы, можно вывести имена и профессии тех работников, у которых зп выше средней по отелю */

SELECT s.job, s.name, s.surname, se.service_cost 
FROM Staff s, Staff_Services ss, Services se
WHERE s.staff_id = ss.staff_id and ss.service_id = se.service_id and 
se.service_cost > (SELECT AVG(service_cost) FROM Services)


/* 3)выведем количество обращений к услугам каждой профессии в декабре, 
и сколько дополнительных денег отелю принесла каждая из них */

SELECT s.service_name AS Услуга,
       COUNT(sb.service_id) AS Количество_обращений,
       SUM(s.service_cost) AS Доход
FROM Service_Bookings sb
JOIN Services s ON sb.service_id = s.service_id
WHERE sb.date >= '2024.12.01' and sb.date <= '2024.12.31'
GROUP BY s.service_name
ORDER BY Доход DESC;
