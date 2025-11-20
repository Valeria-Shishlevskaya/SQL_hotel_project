--Триггеры

/* Напишем триггерную функцию, которая будет автоматически добавлять текущую дату в таблицу Review (отзывы), если гость оставляет новый отзыв, но не указывает дату вручную. */


CREATE OR REPLACE FUNCTION set_review_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.review_date IS NULL THEN
        NEW.review_date := CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Теперь свяжем триггер с конкретной таблицей Rewiev */

CREATE TRIGGER trigger_set_review_date
BEFORE INSERT ON Review
FOR EACH ROW
EXECUTE PROCEDURE set_review_date();

Для проверки:
INSERT INTO Review (review_id, grade, guest_id, room_id)
VALUES (8, 5, 10, 3);

/* При выведении таблицы Review, у строчки 8 будет стоять текущая дата */



/* Давайте предположим, что в отель нельяз будет заселяться с детьми младше 1 года. Напишем триггер, который не позволит добавлять в таблицу Гости, грудничков */


CREATE OR REPLACE FUNCTION small_children()
RETURNS TRIGGER AS $$
BEGIN
    IF AGE(NEW.birth_date) < INTERVAL '1 years' THEN
        RAISE EXCEPTION 'Гости младше 1 года не могут быть заселены в отель;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_small_children 
BEFORE INSERT ON Guests
FOR EACH ROW
EXECUTE PROCEDURE small_children();


/* Пример для проверки: */

INSERT INTO Guests (guest_name, guest_surname, birth_date)
VALUES ('Анна', 'Иванова', '2024-12-01');
 
