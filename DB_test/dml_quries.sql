-- OLTP запити

-- 2 INSERT запити до будь-яких таблиць
INSERT INTO student (name, surname, date_of_birth, phone_number, email, registration_date)
VALUES
	('Дмитро', 'Поцілуйко', '2008-10-10', '0671188446', 'dmytro.pociluyko@ukr.net', '2026-02-12');

INSERT INTO enrolment (student_id, course_id, year_of_study, status)
VALUES 
	(9, 2, '2026-03-01', 'Активно');

-- 2 UPDATE запити до будь-яких таблиць
UPDATE course
SET price = 1700
WHERE title = 'Робототехніка';

UPDATE enrolment
SET status = 'Завершено'
WHERE student_id = 1 AND course_id = 1;

-- 2 DELETE запити з будь-яких таблиць
DELETE FROM enrolment
WHERE student_id = 2 AND course_id = 4;

DELETE FROM lesson
WHERE title = 'Інерція';

-- 2 прості SELECT:
-- знайти всі курси, що викладаються викладачем (пошук за іменем викладача)
SELECT t.name || ' ' || t.surname AS "full_name", c.title
FROM course c
INNER JOIN teacher t USING(teacher_id)
WHERE t.name = 'Олена' AND t.surname = 'Коваль';

-- знайти всіх студентів, що відвідували конкретний курс
SELECT s.name || ' ' || s.surname AS "full_name", c.title
FROM student s
INNER JOIN enrolment e USING (student_id)
INNER JOIN course c USING (course_id)
WHERE c.title = 'Математика';


--OLAP запити
-- Обчислити середній рівень завершення курсів за категоріями

-- Знайти топ-5 викладачів за загальною кількістю зареєстрованих студентів
SELECT t.name || ' ' || t.surname AS "full_name", COUNT(e.student_id) AS total_students
FROM teacher t
JOIN course c USING(teacher_id)
JOIN enrolment e USING(course_id)
GROUP BY t.teacher_id, t.name, t.surname
ORDER BY total_students DESC
LIMIT 5;

-- Ранжувати курси за кількістю реєстрацій у межах кожної категорії (віконні функції)
SELECT c.category, c.title, COUNT(e.student_id) AS total_enrolments,
RANK() OVER (PARTITION BY c.category ORDER BY COUNT(e.student_id) DESC) AS rank_in_category
FROM course c
LEFT JOIN enrolment e USING(course_id)
GROUP BY c.category, c.title;

-- Визначити студентів, які зареєструвалися на декілька курсів, але не завершили жодного (CTE)
