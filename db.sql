/*
 * Initial drop all tables
 */

DROP TABLE IF EXISTS "Students"		CASCADE;
DROP TABLE IF EXISTS "Teachers"		CASCADE;
DROP TABLE IF EXISTS "Courses"		CASCADE;
DROP TABLE IF EXISTS "Gradebook"	CASCADE;
DROP TABLE IF EXISTS "Rooms"		CASCADE;
DROP TABLE IF EXISTS "Timetable"	CASCADE;
DROP TABLE IF EXISTS "Documents"	CASCADE;
DROP TABLE IF EXISTS "Jobs"			CASCADE;
DROP TABLE IF EXISTS "Parents"		CASCADE;
DROP TABLE IF EXISTS "Equipment"	CASCADE;



/*
 * Tables creation
 */


CREATE TABLE "Students" (
/* Attributes */
	"id"			integer,
	"name"			varchar(128)	NOT NULL,
	"rating"		integer			NOT NULL,
	"majority"		BOOLEAN			NOT NULL,
/* Attributes constraints */
	CONSTRAINT "name_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "rating_interval"	CHECK (		-- Rating in range [0, 100]
		0 <= "rating" AND rating <= 100),

/* Foreign keys */
	"id_courses"	integer			NOT NULL,
	"id_gradebook"	integer			NOT NULL,
	"id_timetable"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Students_pk"		PRIMARY KEY ("id")
);



CREATE TABLE "Teachers" (
/* Attributes */
	"id"			integer,
	"name"			varchar(128)	NOT NULL,
	"speciality"	varchar(64)		NOT NULL,
	"degree"		varchar(32)		NOT NULL,
	"rating"		integer			NOT NULL,
	"salary"		FLOAT			NOT NULL,
/* Attributes constraints */
	CONSTRAINT "name_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "speciality_check"	CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"speciality" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "degree_check"		CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"degree" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "rating_interval"	CHECK (		-- Rating in range [0, 100]
		0 <= "rating" AND rating <= 100),
	CONSTRAINT "salary_interval"	CHECK (		-- Salary in range (0, inf)
		0 < "salary"),

/* Foreign keys */
	"id_courses"	integer			NOT NULL,
	"id_gradebook"	integer			NOT NULL,
	"id_timetable"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Teachers_pk"		PRIMARY KEY ("id")
);



CREATE TABLE "Courses" (
/* Attributes */
	"id"			integer,
	"name"			varchar(128)	NOT NULL,
	"annotation"	varchar(1024)	NOT NULL,
	"duration"		integer			NOT NULL,
	"price"			FLOAT			NOT NULL,
/* Attributes constraints */
	CONSTRAINT "name_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "annotation_check"	CHECK (		-- Russian alphabet, special symbols. Length >= 15
		"annotation" ~ '^([а-я]|[А-Я]|[0-9]|[ .,;:@№%()/-]){15,}$'),
	CONSTRAINT "duration_interval"	CHECK (		-- Duration in range (0, inf)
		0 < "duration"),
	CONSTRAINT "price_interval"		CHECK (		-- Price in range (0, inf)
		0 < "price"),

/* Foreign keys */
	"id_courses"	integer			NOT NULL,
	"id_gradebook"	integer			NOT NULL,
	"id_timetable"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Courses_pk"			PRIMARY KEY ("id")
);



CREATE TABLE "Gradebook" (
/* Attributes */
	"id"			integer			NOT NULL,
	"type"			varchar(32)		NOT NULL,
	"score"			integer			NOT NULL,
/* Attributes constraints */
	CONSTRAINT "type_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"type" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "score_interval"		CHECK (		-- Score in range [2, 5]
		2 <= "score" AND score <= 5),

/* Foreign keys */
/* Primary key */
	CONSTRAINT "Gradebook_pk"		PRIMARY KEY ("id")
);



CREATE TABLE "Rooms" (
/* Attributes */
	"id"			integer			NOT NULL,
	"type"			varchar(32)		NOT NULL,
	"number"		integer			NOT NULL,
/* Attributes constraints */
	CONSTRAINT "type_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"type" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "number_interval"	CHECK (		-- Number in range [170, 175]
		170 <= "number" AND "number" <= 175),

/* Foreign keys */
	"id_timetable"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Rooms_pk"			PRIMARY KEY ("id")
);



CREATE TABLE "Timetable" (
/* Attributes */
	"id"			integer			NOT NULL,
	"start"			timestamp		NOT NULL,
	"end"			timestamp		NOT NULL,
	"dow"			integer			NOT NULL,
/* Attributes constraints */
	CONSTRAINT "time_check"			CHECK (		-- Start must be erlier than end
		"start" < "end"),
	CONSTRAINT "dow_check"			CHECK (		-- Day of week in [1-6] -- Monday to Saturday
		1 <= "dow" AND "dow" <= 6),

/* Foreign keys */
/* Primary key */
	CONSTRAINT "Timetable_pk"		PRIMARY KEY ("id")
);



CREATE TABLE "Documents" (
/* Attributes */
	"id"			integer			NOT NULL,
	"type"			varchar(64)		NOT NULL,
	"number"		varchar(64)		NOT NULL,
/* Attributes constraints */
	CONSTRAINT "type_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"type" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "number_check"		CHECK (		-- Russian alphabet, latin alphabet, numbers, space and '-'. Length >= 3
		"number" ~ '^([а-я]|[А-Я]|[a-z]|[A-Z]|[0-9]|[ -]){3,}$'),

/* Foreign keys */
	"id_students"	integer,
	"id_teachers"	integer,
/* Primary key */
	CONSTRAINT "Documents_pk"		PRIMARY KEY ("id")
);



CREATE TABLE "Jobs" (
/* Attributes */
	"id"			integer			NOT NULL,
	"name"			varchar(128)	NOT NULL,
/* Attributes constraints */
	CONSTRAINT "name_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),

/* Foreign keys */
	"id_teachers"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Jobs_pk"			PRIMARY KEY ("id")
);



CREATE TABLE "Parents" (
/* Attributes */
	"id"			integer			NOT NULL,
	"name"			varchar(128)	NOT NULL,
/* Attributes constraints */
	CONSTRAINT "name_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),

/* Foreign keys */
	"id_students"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Parents_pk"			PRIMARY KEY ("id")
);



CREATE TABLE "Equipment" (
/* Attributes */
	"id"			integer			NOT NULL,
	"name"			varchar(128)	NOT NULL,
	"number_inv"	integer			NOT NULL,
/* Attributes constraints */
	CONSTRAINT "name_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "number_inv_interval"	CHECK (	-- Inventory number in range [0, inf)
		0 <= "number_inv"),

/* Foreign keys */
	"id_courses"	integer			NOT NULL,
	"id_rooms"		integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Equipment_pk"		PRIMARY KEY ("id")
);



ALTER TABLE "Teachers"	ADD CONSTRAINT "Teachers_fk0"	FOREIGN KEY ("id_courses")		REFERENCES "Courses"("id");
ALTER TABLE "Teachers"	ADD CONSTRAINT "Teachers_fk1"	FOREIGN KEY ("id_gradebook")	REFERENCES "Gradebook"("id");
ALTER TABLE "Teachers"	ADD CONSTRAINT "Teachers_fk2"	FOREIGN KEY ("id_timetable")	REFERENCES "Timetable"("id");
ALTER TABLE "Courses"	ADD CONSTRAINT "Courses_fk0"	FOREIGN KEY ("id_courses")		REFERENCES "Courses"("id");
ALTER TABLE "Courses"	ADD CONSTRAINT "Courses_fk1"	FOREIGN KEY ("id_gradebook")	REFERENCES "Gradebook"("id");
ALTER TABLE "Courses"	ADD CONSTRAINT "Courses_fk2"	FOREIGN KEY ("id_timetable")	REFERENCES "Timetable"("id");
ALTER TABLE "Rooms"		ADD CONSTRAINT "Rooms_fk0"		FOREIGN KEY ("id_timetable")	REFERENCES "Timetable"("id");
ALTER TABLE "Students"	ADD CONSTRAINT "Students_fk0"	FOREIGN KEY ("id_courses")		REFERENCES "Courses"("id");
ALTER TABLE "Students"	ADD CONSTRAINT "Students_fk1"	FOREIGN KEY ("id_gradebook")	REFERENCES "Gradebook"("id");
ALTER TABLE "Students"	ADD CONSTRAINT "Students_fk2"	FOREIGN KEY ("id_timetable")	REFERENCES "Timetable"("id");
ALTER TABLE "Documents"	ADD CONSTRAINT "Documents_fk0"	FOREIGN KEY ("id_students")		REFERENCES "Students"("id");
ALTER TABLE "Documents"	ADD CONSTRAINT "Documents_fk1"	FOREIGN KEY ("id_teachers")		REFERENCES "Teachers"("id");
ALTER TABLE "Jobs"		ADD CONSTRAINT "Jobs_fk0"		FOREIGN KEY ("id_teachers")		REFERENCES "Teachers"("id");
ALTER TABLE "Parents"	ADD CONSTRAINT "Parents_fk0"	FOREIGN KEY ("id_students")		REFERENCES "Students"("id");
ALTER TABLE "Equipment"	ADD CONSTRAINT "Equipment_fk0"	FOREIGN KEY ("id_courses")		REFERENCES "Courses"("id");
ALTER TABLE "Equipment"	ADD CONSTRAINT "Equipment_fk1"	FOREIGN KEY ("id_rooms")		REFERENCES "Rooms"("id");



/*
 * Data filling
 */

/* Teachers */

INSERT INTO "Teachers"	("id",	"name",							"speciality",										"degree",								"rating",	"salary")
VALUES					(1,		"Иванков Илья Дмитриевич",		"Информационная безопасность",						"Кандидат технических наук",			79,			112000	);
INSERT INTO "Teachers"	("id",	"name",							"speciality",										"degree",								"rating",	"salary")
VALUES					(2,		"Мишин Даниил Романович",		"Информатика и вычислительная техника",				"Магистр",								46,			60000	);
INSERT INTO "Teachers"	("id",	"name",							"speciality",										"degree",								"rating",	"salary")
VALUES					(3,		"Сысоева Лариса Вениаминовна",	"Управление в технических системах",				"Кандидат технических наук",			72,			109000	);
INSERT INTO "Teachers"	("id",	"name",							"speciality",										"degree",								"rating",	"salary")
VALUES					(5,		"Тарасов Роман Семенович",		"Математическая логика, алгебра и теория чисел",	"Доктор физико-математических наук",	99,			200000	);

/* Courses */

INSERT INTO "Courses"	("id",	"name",							"annotation",								"duration",	"price"	)
VALUES					(0,		"Информационная безопасность",	"Программа переподготовки специалистов",	512,		120000	);
INSERT INTO "Courses"	("id",	"name",							"annotation",								"duration",	"price"	)
VALUES					(0,		"Компьютерные сети",			"Введение в компьютерные сети",				103,		40000	);
INSERT INTO "Courses"	("id",	"name",							"annotation",								"duration",	"price"	)
VALUES					(0,		"Системное программирование",	"Разработка системного ПО для ОС Windows",	300,		79000	);

/* Rooms */

INSERT INTO "Rooms"		("id",	"type",					"number")
VALUES					(0,		"Учебная аудитория",	170);
INSERT INTO "Rooms"		("id",	"type",					"number")
VALUES					(1,		"Преподавательская",	171);
INSERT INTO "Rooms"		("id",	"type",					"number")
VALUES					(3,		"Преподавательская",	173);
INSERT INTO "Rooms"		("id",	"type",					"number")
VALUES					(4,		"Учебная аудитория",	174);
INSERT INTO "Rooms"		("id",	"type",					"number")
VALUES					(5,		"Учебная аудитория",	175);

/* Students */

INSERT INTO "Students"	("id",	"name",							"rating",	"majority")
VALUES					(34,	"Дементьева Наталия Игоревна",	63,			TRUE);
INSERT INTO "Students"	("id",	"name",							"rating",	"majority")
VALUES					(35,	"Михайлов Александр Павлович",	44,			FALSE);
INSERT INTO "Students"	("id",	"name",							"rating",	"majority")
VALUES					(36,	"Шашков Семен Андреевич",		23,			TRUE);
INSERT INTO "Students"	("id",	"name",							"rating",	"majority")
VALUES					(37,	"Авдеева Олеся Святославовна",	79,			FALSE);
INSERT INTO "Students"	("id",	"name",							"rating",	"majority")
VALUES					(42,	"Семёнов Марк Родионович",		45,			FALSE);
INSERT INTO "Students"	("id",	"name",							"rating",	"majority")
VALUES					(43,	"Максимова Ангелина Петровна",	78,			TRUE);
INSERT INTO "Students"	("id",	"name",							"rating",	"majority")
VALUES					(45,	"Логинов Эрик Робертович",		30,			FALSE);
INSERT INTO "Students"	("id",	"name",							"rating",	"majority")
VALUES					(46,	"Крылов Алексей Васильевич",	81,			TRUE);

/* Gradebook */

INSERT INTO "Gradebook"	("id", "type", "score") VALUES (130,	"Занятие",	4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (131,	"Занятие",	4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (132,	"Занятие",	4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (133,	"Занятие",	3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (134,	"Занятие",	4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (135,	"Занятие",	5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (136,	"Занятие",	4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (137,	"Занятие",	5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (138,	"Занятие",	5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (139,	"Тест",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (140,	"Тест",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (141,	"Тест",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (142,	"Тест",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (143,	"Тест",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (144,	"Тест",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (145,	"Тест",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (146,	"Тест",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (147,	"Лаба",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (148,	"Лаба",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (149,	"Лаба",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (150,	"Лаба",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (151,	"Лаба",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (152,	"Лаба",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (153,	"Лаба",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (154,	"Лаба",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (155,	"Занятие",	4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (156,	"Занятие",	5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (157,	"Занятие",	5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (158,	"Занятие",	3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (159,	"Занятие",	4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (160,	"Занятие",	3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (161,	"Занятие",	5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (162,	"Занятие",	5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (163,	"Занятие",	3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (164,	"Занятие",	3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (165,	"Занятие",	4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (166,	"Занятие",	3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (167,	"Занятие",	5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (168,	"Занятие",	3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (169,	"Тест",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (170,	"Тест",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (171,	"Тест",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (172,	"Тест",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (173,	"Тест",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (174,	"Тест",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (175,	"Тест",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (176,	"Тест",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (177,	"Лаба",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (178,	"Лаба",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (179,	"Лаба",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (180,	"Лаба",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (181,	"Лаба",		3);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (182,	"Лаба",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (183,	"Лаба",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (184,	"Лаба",		5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (185,	"Занятие",	2);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (186,	"Занятие",	5);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (187,	"Итог",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (188,	"Итог",		4);
INSERT INTO "Gradebook"	("id", "type", "score") VALUES (189,	"Итог",		3);

/* Timetable */

INSERT INTO "Timetable"	("id", "start", "end", "dow") VALUES (20,	"10:00:00",	"12:30:00",	1);
INSERT INTO "Timetable"	("id", "start", "end", "dow") VALUES (21,	"13:00:00",	"13:30:00",	1);
INSERT INTO "Timetable"	("id", "start", "end", "dow") VALUES (22,	"13:00:00",	"13:30:00",	1);
INSERT INTO "Timetable"	("id", "start", "end", "dow") VALUES (23,	"10:00:00",	"12:30:00",	3);
INSERT INTO "Timetable"	("id", "start", "end", "dow") VALUES (34,	"13:00:00",	"13:30:00"	3);
INSERT INTO "Timetable"	("id", "start", "end", "dow") VALUES (35,	"10:00:00",	"12:30:00"	4);
INSERT INTO "Timetable"	("id", "start", "end", "dow") VALUES (36,	"10:00:00",	"12:30:00"	4);
INSERT INTO "Timetable"	("id", "start", "end", "dow") VALUES (37,	"13:00:00",	"13:30:00"	4);

/* Documents */

INSERT INTO "Documents"	("id", "type", "number", "id_teachers") VALUES (0,	"Паспорт",					"4004 078567",		1);
INSERT INTO "Documents"	("id", "type", "number", "id_teachers") VALUES (2,	"Паспорт",					"4015 427247",		2);
INSERT INTO "Documents"	("id", "type", "number", "id_teachers") VALUES (4,	"Паспорт",					"4000 934575",		3);
INSERT INTO "Documents"	("id", "type", "number", "id_teachers") VALUES (6,	"Паспорт",					"4003 524157",		5);
INSERT INTO "Documents"	("id", "type", "number", "id_teachers") VALUES (1,	"Диплом",					"473892 7462947",	1);
INSERT INTO "Documents"	("id", "type", "number", "id_teachers") VALUES (3,	"Диплом",					"471548 2874782",	2);
INSERT INTO "Documents"	("id", "type", "number", "id_teachers") VALUES (5,	"Диплом",					"215678 3205704",	3);
INSERT INTO "Documents"	("id", "type", "number", "id_teachers") VALUES (7,	"Диплом",					"393024 7882445",	5);
INSERT INTO "Documents"	("id", "type", "number", "id_students") VALUES (23,	"Свидетельство о рождении",	"IV-ЖА 837462",		35);
INSERT INTO "Documents"	("id", "type", "number", "id_students") VALUES (24,	"Свидетельство о рождении",	"XI-ВЫ 643254",		37);
INSERT INTO "Documents"	("id", "type", "number", "id_students") VALUES (25,	"Свидетельство о рождении",	"XV-МК 867014",		42);
INSERT INTO "Documents"	("id", "type", "number", "id_students") VALUES (26,	"Свидетельство о рождении",	"II-ЛУ 953135",		45);
INSERT INTO "Documents"	("id", "type", "number", "id_students") VALUES (29,	"Паспорт",					"4018 850788",		34);
INSERT INTO "Documents"	("id", "type", "number", "id_students") VALUES (32,	"Паспорт",					"4017 634234",		36);
INSERT INTO "Documents"	("id", "type", "number", "id_students") VALUES (33,	"Паспорт",					"4019 853456",		43);
INSERT INTO "Documents"	("id", "type", "number", "id_students") VALUES (34,	"Паспорт",					"4020 352465",		46);

/* Jobs */

INSERT INTO "Jobs"		("id", "name") VALUES (1,	"ФГАОУ ВО СПбПУ");
INSERT INTO "Jobs"		("id", "name") VALUES (2,	"ООО НеоБИТ");
INSERT INTO "Jobs"		("id", "name") VALUES (3,	"АО МЦСТ");

/* Parents */

INSERT INTO "Parents"	("id", "name") VALUES (30,	"Михайлов Павел Антонович");
INSERT INTO "Parents"	("id", "name") VALUES (31,	"Михайлова Зоя Васильевна");
INSERT INTO "Parents"	("id", "name") VALUES (32,	"Авдеев Святослав Богданович");
INSERT INTO "Parents"	("id", "name") VALUES (33,	"Авдеева Елена Юрьевна");
INSERT INTO "Parents"	("id", "name") VALUES (33,	"Семёнов Родион Витальевич");
INSERT INTO "Parents"	("id", "name") VALUES (34,	"Семёнова Валерия Мартыновна");
INSERT INTO "Parents"	("id", "name") VALUES (35,	"Логинов Роберт Геннадьевич");
INSERT INTO "Parents"	("id", "name") VALUES (36,	"Логинова Кристина Матвеевна");


/* Equipment */

INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						92394);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						40446);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						49939);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						14949);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						31254);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						75727);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						80152);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						43809);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						50706);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						78087);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						78207);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"ПК",						98324);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"Проектор",					28870);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"Учебный коммутатор",		46193);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"Учебный коммутатор",		59193);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"Учебный маршрутизатор",	37154);
INSERT INTO "Equipment"	("id", "name", "number_inv") VALUES (0,	"Учебный маршрутизатор",	38304);





