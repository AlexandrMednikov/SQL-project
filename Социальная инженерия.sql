#Проэкт социальная инженерия создан по задумке использовать базы данных с небольшой информации о людях
#и выстраивать осталньую информацию имея то что есть. На самом деле для этого проэкта не хватит одного человека
#и чтобы его реализовать требуются огромные вложения. Я же покажу поверхностно, как это могло бы работаь.
DROP DATABASE IF EXISTS personal_data;
CREATE DATABASE personal_data;
USE personal_data;

DROP TABLE IF EXISTS persona;
CREATE TABLE persona
	(id SERIAL,	
	first_name char(20) NOT NULL,
	last_name char(20) NOT NULL,
	city char(40) DEFAULT NULL, #город где человек чаще всего находится
	date_of_birth DATE DEFAULT NULL,
	type_of_employment char(40) DEFAULT NULL,
	date_of_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);

INSERT INTO persona(first_name, last_name, city, date_of_birth, type_of_employment) VALUES
	("Майк", "Вазовски", "Лондон", "2000-01-01", "Ученный"),
	("Даниил", "Варожин", "Минск", "1987-01-10", NULL),
	("Альберт", "Вольфранг", "Стокгольм", "1991-12-21", "Инженер"),
	("Ян", "Гощлик", "Варшава", "1991-10-13", "Кассир"),
	("Екатирина", "Айвазовская", "Тверь", "1987-07-01", "Фотограф"),
    ("Андрей", "Айвазовский", "Тверь", "1985-03-17", "Экскурсовод"),	
    ("Филип", "Айвазовский", "Тверь", "2002-09-21", "Студент"),
    ("Анна", "Айвазовская", "Псков", "2001-01-11", NULL),
    ("Николай", "Виригин", "Псков", "1993-12-23", "Инвестор"),
    ("Фрэнк", "Фишер", NULL, NULL, NULL),
    ("Дарвин", "Уоринг", "Лондон", "1992-12-22", "Ученый"),
    ("Сэм", "Уоринг", "Лондон", "2020-04-19", NULL),
    ("Адик", "Нусхалиев", "Дзержинск", "1999-10-09", "Разнорабочий"),
    ("Сулик", "Нусхалиев", "Восход", "1997-0-01", "Тюремный заключеный"),
    ("Анастасия", "Кремлёва", "Владивосток", "1999-01-03", "Cтудент"),
    ("Виктор", "Кремлёв", NULL, "2004-07-29", NULL),
    ("Альбина", "Кремлёва", NULL, NULL, NULL),
    ("Ли", "Цзин-Пи", "Пекин", "1981-02-09", "Учитель руского и китайского языка"),
    ("Шах", "Нусхалиев", NULL, NULL, NULL);

DROP TABLE IF EXISTS intersection_points_of_people;
CREATE TABLE intersection_points_of_people(
     persona_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	`Пекин` ENUM("+", "-") NULL,
	`Москва` ENUM("+", "-") NULL,
	`Лондон` ENUM("+", "-") NULL,
	`Минск`  ENUM("+", "-") NULL,
	`Варшава` ENUM("+", "-") NULL,
	
	FOREIGN KEY (persona_id) REFERENCES persona(id) 
	);

#Точки пересечения людей могли бы влиять на вероятность знакомства этих людей
#В полной мери такая таблица могла бы быть слишком громозкой и скорее всего она бы создавалась
#для отдельных случаев поиска совпадений
INSERT INTO intersection_points_of_people VALUES
	(1, "+", "+", "+", "-" , "-"),
	(2, "+", "+", "-", "+" , "-"),
	(3, "-", "+", "+", "-" , "-"),
	(4, "-", "+", "+", "-" , "+"),
	(5, "+", "+", "-", "-" , "-"),
	(6, "-", "+", "-", "-" , "-"),
	(7, "-", "+", "-", "+" , "-"),
	(8, "-", "+", "-", "-" , "-"),
	(9, "-", "+", "-", "-" , "-"),
	(10, "+", "+", "+", "+" , "+"),
	(11, "-", "+", "-", "-" , "+"),
	(12, "-", "+", "-", "+" , "-"),
	(13, "-", "+", "-", "-" , "-"),
	(14, "-", "+", "-", "+" , "-"),
	(15, "-", "+", "-", "-" , "-"),
	(16, "+", "+", "-", "-" , "-"),
	(17, "-", "+", "-", "-" , "+"),
	(18, "+", "+", "-", "-" , "+"),
	(19, "-", "-", "-", "-" , "-");

CREATE VIEW intersection_points_of_pekin 
AS SELECT first_name, last_name FROM persona JOIN intersection_points_of_people i  ON persona_id=id
WHERE `Пекин`="+" ;

CREATE VIEW intersection_points_of_moscow 
AS SELECT first_name, last_name FROM persona JOIN intersection_points_of_people i  ON persona_id=id
WHERE `Москва`="+" ;

CREATE VIEW intersection_points_of_london
AS SELECT first_name, last_name FROM persona JOIN intersection_points_of_people i  ON persona_id=id
WHERE `Лондон`="+" ;

CREATE VIEW intersection_points_of_minsk 
AS SELECT first_name, last_name FROM persona JOIN intersection_points_of_people i  ON persona_id=id
WHERE `Минск`="+" ;

CREATE VIEW intersection_points_of_warsaw 
AS SELECT first_name, last_name FROM persona JOIN intersection_points_of_people i  ON persona_id=id
WHERE `Варшава`="+" ;

#Увы фамилии не английские поэтому надежнее делать вручную. 
#Если фамилии не склоняются от пола то все намного проще и можно сделать представления
#Указаны только мать и отец т.к этого достаточно для формирования остального. Позже покажу как
DROP TABLE IF EXISTS relatives;
CREATE TABLE relatives( 
	persona_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    mother BIGINT UNSIGNED NOT NULL DEFAULT 999,
    father BIGINT UNSIGNED NOT NULL DEFAULT 999,
	
	FOREIGN KEY (father) REFERENCES persona(id) ,
	FOREIGN KEY (mother) REFERENCES persona(id) ,
	FOREIGN KEY (persona_id) REFERENCES persona(id) 
);

#По скольку значение NULL не допустимо а оно тут необходимо я создам id обозначающий null
INSERT INTO persona VALUES (999, "NULL", "NULL", "NULL", "3000-00-00", "NULL", DEFAULT);

INSERT INTO relatives VALUES
(1, 999, 999),
(2, 999, 999),
(3, 999, 999),
(4, 999, 999),
(5, 999, 999),
(6, 999, 999),
(7, 5, 6),
(8, 5, 6),
(9, 999, 999),
(10, 999, 999),
(11, 999, 999),
(12, 999, 19),
(13, 999, 19),
(14, 999, 19),
(15, 17, 999),
(16, 17, 999),
(17, 999, 999),
(18, 999, 999),
(19, 999, 999)
;

#Список id в которых я вносил бы братьев и сестер я не мог создать под тип свойствейный id. Чтобы получилось
#сформировать данные на которые можно сылаться, а именно одну цифру я придумал такой способ. Иначе была бы следущая каша
#brothers VRCHAR .. insrt ino relatives(brothers) vaules ("1, 2, 3") . Вместо этого родствеников можно будет узнавать
#используя функцию  find_relatives


#Данные о музыкальных плейлистах наших пользователей. Это конечно должно быть не малое кол-во
#бд с разных музыкальных площадках. Столько у меня не будет, поэтому я перечислю музыкальные вкусы и фаворитов которых
#мы могли бы узнать на основе тех данных что были бы у нас.
DROP TABLE IF EXISTS taste_in_music;
CREATE TABLE taste_in_music
	(persona_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	taste CHAR(40),
	musical_favorite CHAR(40),
	
	FOREIGN KEY (persona_id) REFERENCES persona(id)
	);

INSERT INTO taste_in_music VALUES
(1, "Rock", "Marlin Manson"),
(2, "Hip-Hop", "50 Cent"),
(3, "Hip-Hop", "2-Pac" ),
(4, "Rock", "Kiss"),
(5, "Classic", "Моцарт"),
(6, "Jazz", "Frank Sinatara"),
(7, "Pop", "michael jackson"),
(8, "Classic", "Бетховен"),
(9, "Rock", "Цой"),
(10, "Electronic", "Crystal Castles"),
(11, "Rock", "Marlin Manson"),
(12, "Rap", "2-pac"),
(13, "Rap", "Eminem"),
(14, "Rap", "Витя АК-47"),
(15, "Classic", "Чайковский"),
(16, "Techno", "Паша техник"),
(17, "Rock", "Цой"),
(18, "Electronic", "Crystal Castles"),
(19, "Classic", "Тимур Муцураев")
;

#Далее я буду заносить данные о людях, которые мы также могли получить с разных бд с разных источников.
DROP TABLE IF EXISTS sports_values;
CREATE TABLE sports_values
	(persona_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	sports_past CHAR(40) , #чем человек занимался до совершенолетия
	career CHAR(40) ,
	duration_of_sports_past INT(20) ,
	sportive_activity_at_the_moment CHAR(40) ,
	
	FOREIGN KEY (persona_id) REFERENCES persona(id) 
	);

INSERT INTO sports_values VALUES
(1, "Шахматы", "КМС", 7, "Спортивный зал"),
(2, "Ушу", NULL, NULL, NULL),
(3, "Бальные танцы", "КМС", 10, NULL),
(4, NULL, NULL, NULL, NULL),
(5, "Акробатика", NULL, NULL, NULL),
(6, "Ушу", "КМС", 4, "Спортивный зал"),
(7, NULL, NULL, NULL, NULL),
(8, "Акробатика", NULL, 6, NULL),
(9, "Ушу", NULL, 5, "Спортивный зал"),
(10, "Бег", NULL, 2, "Спортивный зал"),
(11, "Ушу", "МС", 24, "Спортивный зал"),
(12, NULL, NULL, NULL, NULL),
(13, "Бег", NULL, 6, "Бег"),
(14, NULL, NULL, NULL, NULL),
(15, "Бег", NULL, 7, "Бег"),
(16, "Акробатика", "КМС", 7, NULL),
(17, "Прыжки в длину", "МС", 11, "Прыжки в длину"),
(18, NULL, NULL, NULL, NULL),
(19, NULL, NULL, NULL, NULL)
;

DROP TABLE IF EXISTS taste_in_movie;
CREATE TABLE taste_in_movie
	(persona_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	favorite_movie_genre CHAR(40) DEFAULT NULL,
	favorite_actor CHAR(40) DEFAULT NULL,
	favorite_movie CHAR(40) DEFAULT NULL,
	
	FOREIGN KEY (persona_id) REFERENCES persona(id)
	);

INSERT INTO taste_in_movie VALUES
(1, "Horor", DEFAULT, "Поворот не туда"),
(2, "Comedy", "Джим Керри", "Всегда говори ДА"),
(3, "Comedy", DEFAULT, "Мальчишник в Лас-Вегасе"),
(4, "Horor", "", "Texas chainsaw massacre"),
(5, "Black and white", "Чарли Чаплин", DEFAULT),
(6, "Documentary", "Игорь Прокопенко", DEFAULT),
(7, "Comedy", "Джони Депп", "Алиса в стране чудес"),
(8, "Drama", DEFAULT, DEFAULT),
(9, "Horor", DEFAULT, "Техаская резня бензопилой"),
(11, "Horor", DEFAULT, "Поворот не туда"),
(13, "Action", DEFAULT, "Крепкий орешек"),
(14, "Comedy", "Джони Депп", "Эйс Вентура"),
(15, "Comedy", DEFAULT, DEFAULT),
(19, "Action", DEFAULT, DEFAULT)
;

DROP TABLE IF EXISTS hobbies;
CREATE TABLE hobbies
	(persona_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	hobby_top1 CHAR(40),
	hobby_top2 CHAR(40),
	hobby_top3 CHAR(40),
		
	FOREIGN KEY (persona_id) REFERENCES persona(id)
	);

INSERT INTO hobbies VALUES
	(1, "Настольные игры", "Выпечка", NULL ),
	(2, "Выпечка", NULL, NULL),
	(3, "Частые прогулки", NULL, NULL),
	(4, "Чтение", "Частые прогулки", NULL),
	(5, "Правильное питание", "Частые прогулки", "Чтение"),
	(6, "Игры в компьютер", "Изучение новостей", NULL),
	(8, "Рисование", "Пение", NULL),
	(9, "Политика", "Благотворительность", "Изучение новостей"),
	(11, "Настольные игры", "Частые прогулки", NULL),
	(13, "Посещение церкви", NULL, NULL),
	(14, "Лепка фигурок из хлеба", NULL, NULL),
	(15, "Чтение", "Правильное питание", NULL),
	(16, "Посещение церкви", NULL, NULL),
	(17, "Туризм", "Скалолазанье", NULL),
	(18, "Искуство", "Наука", "Чтение")
	;

#Было бы полезно иметь инструкцию по определению принадлежности лиц к тем или иным соц категориям.
#Разделение людей на классы, группы и психотипы довольно обширны. Я решил не выбирать что-то одно.
#В создании бд для применении в соц инженерии можно зайдействовать и не одно известное деление,
#но я для данного экспириенса сделаю свои безыменые категори на точках смежности разных вкусовых
# предпочтений человека.

DROP TABLE IF EXISTS hobbiestype_of_persone;
DROP TABLE IF EXISTS sporttype_of_persone;
DROP TABLE IF EXISTS moviestype_of_persone;
DROP TABLE IF EXISTS musictype_of_persone;
DROP TABLE IF EXISTS type_of_persone;
CREATE TABLE type_of_persone
	(id SERIAL,
	 name CHAR(40)
	);

INSERT INTO type_of_persone(name) VALUES ("первый тип"),("второй тип"),("третий тип"), ("NULL");

CREATE TABLE moviestype_of_persone(
	id SERIAL,
	movies CHAR(40),
	type_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (type_id) REFERENCES type_of_persone(id)
	);

INSERT INTO moviestype_of_persone(movies, type_id) VALUES
	("Horor", 1),
	("Action", 1),
	("Comedy", 2),
	("Black and white", 3),
	("Documentary", 3),
	("Drama", 3),
	(NULL, 4)
	;

CREATE TABLE musictype_of_persone(
	id SERIAL,
	music CHAR(40),
	type_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (type_id) REFERENCES type_of_persone(id)
	);

INSERT INTO musictype_of_persone(music, type_id) VALUES
	("Rock", 1),
	("Techno", 1),
	("Hip-Hop", 2),
	("Pop", 2),
	("Rap", 2),
	("Classic", 3),
	("Jazz", 3),
	("Electronic", 3),
	(NULL, 4)
	;

CREATE TABLE sporttype_of_persone(
	id SERIAL,
	sport CHAR(40),
	type_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (type_id) REFERENCES type_of_persone(id)
	);

INSERT INTO sporttype_of_persone(sport, type_id) VALUES
	(NULL, 1),
	("Бег", 2),
	("Спортивный зал", 2),
	("Ушу", 2),
	("Шахматы", 3),
	("Бальные танцы", 3),
	("Акробатика", 3),
	("Прыжки в длину", 3)
	;

CREATE TABLE hobbiestype_of_persone(
	id SERIAL,
	hobbies CHAR(40),
	type_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (type_id) REFERENCES type_of_persone(id)
	);

INSERT INTO hobbiestype_of_persone(hobbies, type_id) VALUES
	("Игры в компьютер", 1),
	("Тату", 1),
	("Выпечка", 2),
	("Частые прогулки", 2),
	("Посещение церкви", 2),
	("Лепка фигурок из хлеба", 2),
	("Скалолазанье", 2),
	("Настольные игры", 3),
	("Чтение", 3),
	("Правильное питание", 3),
	("Изучение новостей", 3),
	("Рисование", 3),
	("Искуство", 3),
	("Наука", 3),
	(NULL, 4)
	;

#Можно было сооздавать внешние ключи таким оброзамо чтобы sports_values соединялась с sporttype_of_persone и.т.п
#Я не хочу так делать, мне комфортнее видеть эту взаимосвзяь в join соеденениях

#Предположим у нас данные о заведениях и их посетитилях
DROP TABLE IF EXISTS types_of_establishments;
CREATE TABLE types_of_establishments(
	id SERIAL,
	type_of CHAR(40)
	);
	
INSERT INTO types_of_establishments(type_of) VALUES("bars"), ("hostels");

DROP TABLE IF EXISTS hotels;
CREATE TABLE hostels
	(id SERIAL,
	name CHAR(40),
	country CHAR(40),
	city CHAR(40),
	stars ENUM("1", "2", "3", "4", "5"),
	average_room_price BIGINT,
	type_of_place BIGINT UNSIGNED NOT NULL DEFAULT 2,
	
	FOREIGN KEY (type_of_place) REFERENCES types_of_establishments(id)
	);

INSERT INTO hostels(name, country, city, stars, average_room_price) VALUES
	("Шатры", "Россия", "Москва", 3, 39),
	("Чинпин","Китай","Пекин", 4, 78),
	("Граф","Англия","Лондон", 5, 232),
	("Батько","Беларусия","Минск", 3, 48),
	("Кильма","Польша","Варшава", 4, 89),
	("Граф Гусь","Россия","Тверь", 4, 55)
	;

DROP TABLE IF EXISTS list_of_hotel_guests;
CREATE TABLE list_of_hotel_guests
	(id SERIAL,
	hostel_id BIGINT UNSIGNED NOT NULL,
	guests BIGINT UNSIGNED NOT NULL,
	time_of_settle DATETIME ,
	time_of_left DATETIME,
	room_number BIGINT UNSIGNED NOT NULL,
	type_of_place BIGINT UNSIGNED NOT NULL DEFAULT 2,
	
	FOREIGN KEY (hostel_id) REFERENCES hoStels(id),
	FOREIGN KEY (guests) REFERENCES persona(id),
	FOREIGN KEY (type_of_place) REFERENCES types_of_establishments(id)
	);

INSERT INTO list_of_hotel_guests(hostel_id, guests, time_of_settle, time_of_left, room_number) VALUES
	(4, 7, "2022-02-15 10:44:02", "2022-02-22 08:11:38", 89 ),
	(5, 17, "2022-03-24 22:17:02", "2022-04-11 09:31:31", 76),
	(6, 16, "2022-06-15 15:17:02", "2022-08-01 18:11:38", 305 ),
	(1, 1, "2022-08-23 10:36:42", NULL, 178),
	(1, 11, "2022-08-23 10:37:22", NULL, 192),
	(1, 12, "2022-08-23 10:37:48", NULL, 192),
	(1, 3, "2022-08-24 09:41:59", NULL, 174),
	(2, 10, "2022-09-25 17:12:00", NULL, 203),
	(3, 17, "2022-09-25 17:12:00", NULL, 1067)
	;

DROP TABLE IF EXISTS bars;
CREATE TABLE bars
	(id SERIAL,
	name CHAR(40),
	country CHAR(40),
	city CHAR(40),
	average_price INT(100),
	type_of_place BIGINT UNSIGNED NOT NULL DEFAULT 2,
	
	FOREIGN KEY (type_of_place) REFERENCES types_of_establishments(id)
	);

INSERT INTO bars(name, country, city, average_price) VALUES
	("FLEX", "Россия", "Москва", 10),
	("Groom","Россия","Москва", 12),
	("Grey Joe","Англия","Лондон", 67),
	("Зона№0","Россия","Москва", 7),
	("MOST IN","Польша","Варшава", 13),
	("Lider","Китай","Пекин", 22),
	("Последний ласты","Россия","Тверь", 5),
	("Zone","Польша","Варшава", 17)
	;

DROP TABLE IF EXISTS customers_of_bars;
CREATE TABLE customers_of_bars
	(id SERIAL,
	bar_id BIGINT UNSIGNED NOT NULL,
	guests BIGINT UNSIGNED NOT NULL,
	time_of_buy DATETIME , #момент расплаты кредиткой
	type_of_place BIGINT UNSIGNED NOT NULL DEFAULT 2,
	
	FOREIGN KEY (bar_id) REFERENCES bars(id),
	FOREIGN KEY (guests) REFERENCES persona(id),
	FOREIGN KEY (type_of_place) REFERENCES types_of_establishments(id)
	);

INSERT INTO customers_of_bars(bar_id, guests, time_of_buy) VALUES 
	(5, 4, "2022-09-07 19:16:10"),
	(2, 11, "2022-09-09 20:07:09"),
	(2, 1, "2022-09-09 20:07:31"),
	(2, 3, "2022-09-09 20:07:54"),
	(4, 17, "2022-09-11 18:45:01"),
	(4, 8, "2022-09-11 19:07:12"),
	(3, 4, "2022-09-23 19:31:37"),
	(8, 4, "2022-09-24 19:00:56"),
	(6, 18, "2022-09-25 21:13:42")
	;


