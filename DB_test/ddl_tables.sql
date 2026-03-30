CREATE TABLE IF NOT EXISTS student (
	student_id SERIAL PRIMARY KEY,
	name VARCHAR(16) NOT NULL,
	surname VARCHAR(16) NOT NULL,
	date_of_birth DATE NOT NULL,
	phone_number VARCHAR(10) NOT NULL,
	email VARCHAR(48) UNIQUE NOT NULL,
	registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'teacher_speсialization') THEN
		create type teacher_specialization as enum ('Програміст', 'Математик', 'Філолог', 'Фізик');
	END IF;
END$$;

CREATE TABLE IF NOT EXISTS teacher (
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(16) NOT NULL,
	surname VARCHAR(16) NOT NULL,
	date_of_birth DATE NOT NULL,
	phone_number VARCHAR(10) NOT NULL,
	email VARCHAR(48) UNIQUE NOT NULL,
	specialization teacher_specialization NOT NULL
);

DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'course_category') THEN
		create type course_category as enum ('IT', 'Точні науки', 'Гуманітарні науки');
	END IF;
END$$;

CREATE TABLE IF NOT EXISTS course (
	course_id SERIAL PRIMARY KEY,
	teacher_id INTEGER NOT NULL REFERENCES teacher(teacher_id) ON DELETE CASCADE,
	title VARCHAR(24) UNIQUE NOT NULL,
	description TEXT NOT NULL,
	price INTEGER NOT NULL,
	category course_category NOT NULL
);

DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'lesson_ordering') THEN
		create type lesson_ordering as enum ('Урок 1', 'Урок 2', 'Урок 3');
	END IF;
END$$;

CREATE TABLE IF NOT EXISTS lesson (
	lesson_id SERIAL PRIMARY KEY,
	course_id INTEGER NOT NULL REFERENCES course(course_id) ON DELETE CASCADE,
	title VARCHAR(24) UNIQUE NOT NULL,
	content TEXT NOT NULL,
	ordering lesson_ordering NOT NULL
);

DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enrolment_status') THEN
		create type enrolment_status as enum ('Завершено', 'Активно', 'Скасовано');
	END IF;
END$$;

CREATE TABLE IF NOT EXISTS enrolment (
	student_id INTEGER NOT NULL REFERENCES student(student_id),
	course_id INTEGER NOT NULL REFERENCES course(course_id),
	PRIMARY KEY(student_id, course_id),
	year_of_study DATE DEFAULT CURRENT_DATE,
	status enrolment_status NOT NULL
);

INSERT INTO student (name, surname, date_of_birth, phone_number, email, registration_date)
VALUES
	('Іван', 'Шевченко', '2006-05-10', '0671119876', 'ivan.shev@gmail.com', '2026-03-01 15:09:27'),
	('Олена', 'Бондаренко', '2007-09-22', '0952222233', 'olena.bond@gmail.com', '2026-03-05 16:11:35'),
	('Андрій', 'Ткаченко', '2005-12-15', '063333300', 'andriy.tk@gmail.com', '2026-03-10 12:00:09'),
	('Юлія', 'Кравченко', '2006-02-28', '0994444412', 'yulia.krav@gmail.com', '2026-03-12 23:59:01'),
	('Сергій', 'Олійник', '2007-07-07', '0675555444', 'serg.ol@gmail.com', '2026-03-15 18:56:13'),
	('Тетяна', 'Мороз', '2005-04-14', '0956666666', 'tanya.moroz@gmail.com', '2026-03-18 14:10:47'),
	('Максим', 'Поліщук', '2006-11-30', '0637777777', 'max.poly@gmail.com', '2026-03-20 09:19:19'),
	('Артем', 'Коваль', '2006-03-03', '0950000000', 'artem.koval@gmail.com', '2026-03-28 14:23:44');

INSERT INTO teacher (name, surname, date_of_birth, phone_number, email, specialization)
VALUES
	('Микола', 'Лисенко', '1975-03-14', '0671234567', 'm.lysenko@school.edu.ua', 'Математик'),
	('Олена', 'Коваль', '1982-11-20', '0959876543', 'o.koval@school.edu.ua', 'Фізик'),
	('Віктор', 'Рибачук', '1990-05-05', '0631112233', 'v.rybachuk@school.edu.ua', 'Програміст'),
	('Ганна', 'Мельник', '1988-08-12', '0995554433', 'h.melnyk@school.edu.ua', 'Філолог');

INSERT INTO course (title, teacher_id, description, price, category)
VALUES
	('Математика', 1, 'Базовий курс аналізу', 1300, 'Точні науки'),
	('Фізика', 2, 'Основи механіки', 1450, 'Точні науки'),
	('Робототехніка', 3, 'Збірка та програмування роботів', 1600, 'IT'),
	('Англійська мова', 4, 'Від рівня A2 до C1', 900, 'Гуманітарні науки');

INSERT INTO lesson (course_id, title, content, ordering)
VALUES
	(1, 'Натуральні числа', 'Поняття та операції', 'Урок 1'),
	(1, 'Цілі числа', 'Від’ємні та додатні числа', 'Урок 2'),
	(1, 'Раціональні числа', 'Дроби та відсотки', 'Урок 3'),

	(2, 'Кінематика', 'Рух тіл у просторі', 'Урок 1'),
	(2, 'Динаміка', 'Закони Ньютона', 'Урок 2'),
	(2, 'Інерція', 'Сила тертя та спокою', 'Урок 3'),

	(3, 'Основи програмування', 'Логіка та алгоритми', 'Урок 1'),
	(3, 'Електротехніка', 'Схеми та плати', 'Урок 2'),
	(3, 'Автоматизація', 'Написання коду для руху', 'Урок 3'),

	(4, 'Family and School', 'Vocabulary and grammar', 'Урок 1'),
	(4, 'Environment', 'Nature and pollution', 'Урок 2'),
	(4, 'University and job', 'Future career paths', 'Урок 3');

INSERT INTO enrolment (student_id, course_id, year_of_study, status)
VALUES
	(1, 1, '2026-03-25', 'Активно'),
	(1, 2, '2026-04-12', 'Активно'),
	(2, 4, '2026-03-13', 'Скасовано'),
	(3, 4, '2026-03-14', 'Активно'),
	(4, 1, '2026-03-15', 'Завершено'),
	(4, 2, '2026-03-16', 'Активно'),
	(4, 3, '2026-03-17', 'Активно'),
	(4, 4, '2026-03-18', 'Скасовано'),
	(5, 1, '2026-03-20', 'Активно'),
	(5, 3, '2026-03-21', 'Завершено'),
	(6, 2, '2026-03-22', 'Активно'),
	(7, 1, '2026-05-15', 'Завершено'),
	(7, 4, '2026-05-11', 'Активно'),
	(8, 3, '2026-04-28', 'Завершено');
	

	
	
	
	
	
