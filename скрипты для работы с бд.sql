USE personal_data;

#Родствеников можно будет узнавать используя функцию
DELIMITER //
DROP PROCEDURE IF EXISTS find_relatives//
CREATE PROCEDURE find_relatives (IN id_persona BIGINT)
BEGIN
	IF((SELECT mother FROM relatives WHERE persona_id=id_persona)=999 
	AND (SELECT father  FROM relatives WHERE persona_id=id_persona)=999)
	THEN 
		SELECT "В базе данных отсутствуют родствиники для этого человека";
	ELSE
		SELECT b.persona_id AS brothers_and_sisters, a.mother, a.father FROM relatives AS a 
		RIGHT JOIN relatives AS b 
		ON a.mother=b.mother AND a.father=b.father 
	WHERE a.persona_id = id_persona AND b.persona_id!=id_persona;
	END IF;
END//
DELIMITER ;


#Процедура выдающие досье 
DELIMITER //
DROP PROCEDURE IF EXISTS dossier//
CREATE PROCEDURE dossier (IN id_persona BIGINT)
BEGIN
	SELECT * FROM persona 
	JOIN taste_in_movie timv 
	JOIN taste_in_music tims
	JOIN sports_values sv 
	JOIN hobbies h 
	JOIN relatives rs
	ON timv.persona_id=id AND tims.persona_id=id AND sv.persona_id=id AND h.persona_id=id AND rs.persona_id=id
	WHERE id=id_persona;
END//
DELIMITER ;

#Однако если создать следущие досье CALL dossier(7); то бдует таблица с пустыми полями
#Чтобы решить эту проблему необходимо создать тригеры

DROP TRIGGER IF EXISTS insert_movie_if_create_persona;
DELIMITER \\
CREATE TRIGGER insert_movie_if_create_persona AFTER INSERT ON persona
FOR EACH ROW
BEGIN 
	INSERT INTO taste_in_movie(persona_id) VALUES(NEW.id);
END\\
DELIMITER ;

DROP TRIGGER IF EXISTS insert_music_if_create_persona;
DELIMITER \\
CREATE TRIGGER insert_music_if_create_persona AFTER INSERT ON persona
FOR EACH ROW
BEGIN 
	INSERT INTO taste_in_music(persona_id) VALUES(NEW.id);
END\\
DELIMITER ;

DROP TRIGGER IF EXISTS insert_sports_if_create_persona;
DELIMITER \\
CREATE TRIGGER insert_sports_if_create_persona AFTER INSERT ON persona
FOR EACH ROW
BEGIN 
	INSERT INTO sports_values(persona_id) VALUES(NEW.id);
END\\
DELIMITER ;

DROP TRIGGER IF EXISTS insert_hobbies_if_create_persona;
DELIMITER \\
CREATE TRIGGER insert_hobbies_if_create_persona AFTER INSERT ON persona
FOR EACH ROW
BEGIN 
	INSERT INTO hobbies(persona_id) VALUES(NEW.id);
END\\
DELIMITER ;

DROP TRIGGER IF EXISTS insert_relatives_if_create_persona;
DELIMITER \\
CREATE TRIGGER insert_relatives_if_create_persona AFTER INSERT ON persona
FOR EACH ROW
BEGIN 
	INSERT INTO relatives(persona_id) VALUES(NEW.id);
END\\
DELIMITER ;

#теперь если создать акаунт у него автоматически создаются поля и запрос досье не будет пустым.

#Было бы неплохо узнавать последнее место посещения
DELIMITER \\
DROP PROCEDURE IF EXISTS where_persona\\
CREATE PROCEDURE where_persona (IN id_persona BIGINT)
BEGIN
	SELECT type_of_place, hostel_id AS place_id, time_of_settle AS visit_time FROM list_of_hotel_guests WHERE guests=id_persona
	UNION
	SELECT type_of_place, hostel_id AS place_id, time_of_left FROM list_of_hotel_guests WHERE guests=id_persona
	UNION
	SELECT type_of_place, bar_id AS place_id, time_of_buy FROM customers_of_bars WHERE guests=id_persona ORDER BY visit_time DESC LIMIT 1;
END\\
DELIMITER ;
