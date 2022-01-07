/*
 * Initial drop all tables
 */

DROP TABLE IF EXISTS "Students"     CASCADE;
DROP TABLE IF EXISTS "Teachers"     CASCADE;
DROP TABLE IF EXISTS "Courses"      CASCADE;
DROP TABLE IF EXISTS "Gradebook"    CASCADE;
DROP TABLE IF EXISTS "Rooms"        CASCADE;
DROP TABLE IF EXISTS "Timetable"    CASCADE;
DROP TABLE IF EXISTS "Documents"    CASCADE;
DROP TABLE IF EXISTS "Jobs"         CASCADE;
DROP TABLE IF EXISTS "Parents"      CASCADE;
DROP TABLE IF EXISTS "Equipment"    CASCADE;

DROP TABLE IF EXISTS "Courses_MM_Equipment"     CASCADE;
DROP TABLE IF EXISTS "Courses_MM_Courses"       CASCADE;



/*
 * Tables creation
 */


/* Main tables */


CREATE TABLE "Students" (
/* Attributes */
    "id"            integer,
    "name"          varchar(128)    NOT NULL,
    "rating"        integer         NOT NULL,
    "majority"      BOOLEAN         NOT NULL,
/* Attributes constraints */
    CONSTRAINT "name_check"         CHECK (     -- Russian alphabet, space and '-'. Length >= 3
        "name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
    CONSTRAINT "rating_interval"    CHECK (     -- Rating in range [0, 100]
        0 <= "rating" AND rating <= 100),

/* Foreign keys */
/* Primary key */
    CONSTRAINT "Students_pk"        PRIMARY KEY ("id")
);



CREATE TABLE "Teachers" (
/* Attributes */
    "id"            integer,
    "name"          varchar(128)    NOT NULL,
    "speciality"    varchar(64)     NOT NULL,
    "degree"        varchar(64)     NOT NULL,
    "rating"        integer         NOT NULL,
    "salary"        FLOAT           NOT NULL,
/* Attributes constraints */
    CONSTRAINT "name_check"         CHECK (     -- Russian alphabet, space and '-'. Length >= 3
        "name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
    CONSTRAINT "speciality_check"   CHECK (     -- Russian alphabet, space, ',' and '-'. Length >= 3
        "speciality" ~ '^([а-я]|[А-Я]|[ ,-]){3,}$'),
    CONSTRAINT "degree_check"       CHECK (     -- Допустимые значения
        "degree" IN (
          'Бакалавр'
        , 'Специалист'
        , 'Магистр'
        , 'Кандидат наук'
        , 'Доктор наук'
    )),
    CONSTRAINT "rating_interval"    CHECK (     -- Rating in range [0, 100]
        0 <= "rating" AND rating <= 100),
    CONSTRAINT "salary_interval"    CHECK (     -- Salary in range (0, inf)
        0 < "salary"),

/* Foreign keys */
/* Primary key */
    CONSTRAINT "Teachers_pk"        PRIMARY KEY ("id")
);



CREATE TABLE "Courses" (
/* Attributes */
    "id"            integer,
    "name"          varchar(128)    NOT NULL,
    "annotation"    varchar(1024)   NOT NULL,
    "duration"      integer         NOT NULL,
    "price"         FLOAT           NOT NULL,
/* Attributes constraints */
    CONSTRAINT "name_check"         CHECK (     -- Russian alphabet, space and '-'. Length >= 3
        "name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
    CONSTRAINT "annotation_check"   CHECK (     -- Russian and English alphabet, special symbols. Length >= 15
        "annotation" ~ '^([а-я]|[А-Я]|[a-z]|[A-Z]|[0-9]|[ .,;:@№%()/-]){15,}$'),
    CONSTRAINT "duration_interval"  CHECK (     -- Duration in range (0, inf)
        0 < "duration"),
    CONSTRAINT "price_interval"     CHECK (     -- Price in range (0, inf)
        0 < "price"),

/* Foreign keys */
/* Primary key */
    CONSTRAINT "Courses_pk"         PRIMARY KEY ("id")
);



CREATE TABLE "Gradebook" (
/* Attributes */
    "id"            integer         NOT NULL,
    "type"          varchar(32)     NOT NULL,
    "score"         integer         NOT NULL,
/* Attributes constraints */
    CONSTRAINT "type_check"         CHECK (     -- Допустимые значения
        "type" IN (
          'Занятие'
        , 'Лаба'
        , 'Тест'
        , 'Итог'
    )),
    CONSTRAINT "score_interval"     CHECK (     -- Score in range [2, 5]
        2 <= "score" AND score <= 5),

/* Foreign keys */
    "id_courses"    integer         NOT NULL,
    "id_students"   integer         NOT NULL,
    "id_teachers"   integer         NOT NULL,
/* Primary key */
    CONSTRAINT "Gradebook_pk"       PRIMARY KEY ("id")
);



CREATE TABLE "Rooms" (
/* Attributes */
    "id"            integer         NOT NULL,
    "type"          varchar(32)     NOT NULL,
    "number"        integer         NOT NULL,
/* Attributes constraints */
    CONSTRAINT "type_check"         CHECK (     -- Допустимые значения
        "type" IN (
              'Учебная аудитория'
            , 'Преподавательская'
    )),
    CONSTRAINT "number_interval"    CHECK (     -- Number in range [170, 175]
        170 <= "number" AND "number" <= 175),

/* Foreign keys */
/* Primary key */
    CONSTRAINT "Rooms_pk"           PRIMARY KEY ("id")
);



CREATE TABLE "Timetable" (
/* Attributes */
    "id"            integer         NOT NULL,
    "start"         time            NOT NULL,
    "end"           time            NOT NULL,
    "dow"           integer         NOT NULL,
/* Attributes constraints */
    CONSTRAINT "time_check"         CHECK (     -- Start must be erlier than end
        "start" < "end"),
    CONSTRAINT "dow_check"          CHECK (     -- Day of week in [1-6] -- Monday to Saturday
        1 <= "dow" AND "dow" <= 6),

/* Foreign keys */
    "id_courses"    integer         NOT NULL,
    "id_rooms"      integer         NOT NULL,
    "id_teachers"   integer         NOT NULL,
/* Primary key */
    CONSTRAINT "Timetable_pk"       PRIMARY KEY ("id")
);



CREATE TABLE "Documents" (
/* Attributes */
    "id"            integer         NOT NULL,
    "type"          varchar(64)     NOT NULL,
    "number"        varchar(64)     NOT NULL,
/* Attributes constraints */
    CONSTRAINT "type_check"         CHECK (     -- Допустимые значения
        "type" IN (
              'Паспорт'
            , 'Свидетельство о рождении'
            , 'Диплом'
    )),
    CONSTRAINT "number_check"       CHECK (     -- Russian alphabet, latin alphabet, numbers, space and '-'. Length >= 3
        "number" ~ '^([а-я]|[А-Я]|[a-z]|[A-Z]|[0-9]|[ -]){3,}$'),

/* Foreign keys */
    "id_students"   integer         DEFAULT NULL,
    "id_teachers"   integer         DEFAULT NULL,
/* Foreign keys constraints */
    CONSTRAINT "only_one_id_check"  CHECK (     -- Check if only one is set
        "id_students" IS NULL  OR "id_teachers" IS NULL),
/* Primary key */
    CONSTRAINT "Documents_pk"       PRIMARY KEY ("id")
);



CREATE TABLE "Jobs" (
/* Attributes */
    "id"            integer         NOT NULL,
    "name"          varchar(128)    NOT NULL,
/* Attributes constraints */
    CONSTRAINT "name_check"         CHECK (     -- Russian alphabet, space and '-'. Length >= 3
        "name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),

/* Foreign keys */
    "id_teachers"   integer         NOT NULL,
/* Primary key */
    CONSTRAINT "Jobs_pk"            PRIMARY KEY ("id")
);



CREATE TABLE "Parents" (
/* Attributes */
    "id"            integer         NOT NULL,
    "name"          varchar(128)    NOT NULL,
/* Attributes constraints */
    CONSTRAINT "name_check"         CHECK (     -- Russian alphabet, space and '-'. Length >= 3
        "name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),

/* Foreign keys */
    "id_students"   integer         NOT NULL,
/* Primary key */
    CONSTRAINT "Parents_pk"         PRIMARY KEY ("id")
);



CREATE TABLE "Equipment" (
/* Attributes */
    "id"            integer         NOT NULL,
    "name"          varchar(128)    NOT NULL,
    "number_inv"    integer         NOT NULL,
/* Attributes constraints */
    CONSTRAINT "name_check"         CHECK (     -- Russian alphabet, space and '-'. Length >= 2
        "name" ~ '^([а-я]|[А-Я]|[ -]){2,}$'),
    CONSTRAINT "number_inv_interval"    CHECK ( -- Inventory number in range [0, inf)
        0 <= "number_inv"),

/* Foreign keys */
/* Primary key */
    CONSTRAINT "Equipment_pk"       PRIMARY KEY ("id")
);



/* Intermediate tables */

CREATE TABLE "Courses_MM_Equipment" (
/* Foreign keys */
    "id_courses"    integer         NOT NULL,
    "id_equipment"  integer         NOT NULL,
    CONSTRAINT "C_mm_E_fk0"         FOREIGN KEY ("id_courses")      REFERENCES "Courses"("id"),
    CONSTRAINT "C_mm_E_fk1"         FOREIGN KEY ("id_equipment")    REFERENCES "Equipment"("id")
);



CREATE TABLE "Courses_MM_Courses" (  -- Предшествующие курсы
/* Foreign keys */
    "id_courses_cur"    integer     NOT NULL,
    "id_courses_prev"   integer     NOT NULL,
    CONSTRAINT "C_mm_С_fk0"         FOREIGN KEY ("id_courses_cur")  REFERENCES "Courses"("id"),
    CONSTRAINT "C_mm_С_fk1"         FOREIGN KEY ("id_courses_prev") REFERENCES "Courses"("id")
);



/* Foreign keys */

/* Main tables */

ALTER TABLE "Gradebook" ADD CONSTRAINT "Gradebook_fk0"  FOREIGN KEY ("id_courses")      REFERENCES "Courses"("id");
ALTER TABLE "Gradebook" ADD CONSTRAINT "Gradebook_fk1"  FOREIGN KEY ("id_students")     REFERENCES "Students"("id");
ALTER TABLE "Gradebook" ADD CONSTRAINT "Gradebook_fk2"  FOREIGN KEY ("id_teachers")     REFERENCES "Teachers"("id");

ALTER TABLE "Timetable" ADD CONSTRAINT "Timetable_fk0"  FOREIGN KEY ("id_courses")      REFERENCES "Courses"("id");
ALTER TABLE "Timetable" ADD CONSTRAINT "Timetable_fk1"  FOREIGN KEY ("id_rooms")        REFERENCES "Rooms"("id");
ALTER TABLE "Timetable" ADD CONSTRAINT "Timetable_fk2"  FOREIGN KEY ("id_teachers")     REFERENCES "Teachers"("id");

ALTER TABLE "Documents" ADD CONSTRAINT "Documents_fk0"  FOREIGN KEY ("id_students")     REFERENCES "Students"("id");
ALTER TABLE "Documents" ADD CONSTRAINT "Documents_fk1"  FOREIGN KEY ("id_teachers")     REFERENCES "Teachers"("id");

ALTER TABLE "Jobs"      ADD CONSTRAINT "Jobs_fk0"       FOREIGN KEY ("id_teachers")     REFERENCES "Teachers"("id");

ALTER TABLE "Parents"   ADD CONSTRAINT "Parents_fk0"    FOREIGN KEY ("id_students")     REFERENCES "Students"("id");



/*
 * Data filling
 */

/* Teachers */

INSERT INTO "Teachers"  ("id",  "name",                         "speciality",                                       "degree",           "rating",   "salary")
VALUES                  (1,     'Иванков Илья Дмитриевич',      'Информационная безопасность',                      'Кандидат наук',    79,         112000  );
INSERT INTO "Teachers"  ("id",  "name",                         "speciality",                                       "degree",           "rating",   "salary")
VALUES                  (2,     'Мишин Даниил Романович',       'Информатика и вычислительная техника',             'Магистр',          46,         60000   );
INSERT INTO "Teachers"  ("id",  "name",                         "speciality",                                       "degree",           "rating",   "salary")
VALUES                  (3,     'Сысоева Лариса Вениаминовна',  'Управление в технических системах',                'Кандидат наук',    72,         109000  );
INSERT INTO "Teachers"  ("id",  "name",                         "speciality",                                       "degree",           "rating",   "salary")
VALUES                  (5,     'Тарасов Роман Семенович',      'Математическая логика, алгебра и теория чисел',    'Доктор наук',      99,         200000  );

/* Courses */

INSERT INTO "Courses"   ("id",  "name",                         "annotation",                               "duration", "price" )
VALUES                  (0,     'Информационная безопасность',  'Программа переподготовки специалистов',    512,        120000  );
INSERT INTO "Courses"   ("id",  "name",                         "annotation",                               "duration", "price" )
VALUES                  (1,     'Компьютерные сети',            'Введение в компьютерные сети',             103,        40000   );
INSERT INTO "Courses"   ("id",  "name",                         "annotation",                               "duration", "price" )
VALUES                  (2,     'Системное программирование',   'Разработка системного ПО для ОС Windows',  300,        79000   );

/* Courses_MM_Courses - предшествующие курсы */

INSERT INTO "Courses_MM_Courses"    ("id_courses_cur",  "id_courses_prev" )
VALUES                              (0,                 1                 );
INSERT INTO "Courses_MM_Courses"    ("id_courses_cur",  "id_courses_prev" )
VALUES                              (0,                 2                 );

/* Rooms */

INSERT INTO "Rooms"     ("id",  "type",                 "number")
VALUES                  (0,     'Учебная аудитория',    170);
INSERT INTO "Rooms"     ("id",  "type",                 "number")
VALUES                  (1,     'Преподавательская',    171);
INSERT INTO "Rooms"     ("id",  "type",                 "number")
VALUES                  (3,     'Преподавательская',    173);
INSERT INTO "Rooms"     ("id",  "type",                 "number")
VALUES                  (4,     'Учебная аудитория',    174);
INSERT INTO "Rooms"     ("id",  "type",                 "number")
VALUES                  (5,     'Учебная аудитория',    175);

/* Students */

INSERT INTO "Students"  ("id",  "name",                         "rating",   "majority")
VALUES                  (0,     'Дементьева Наталия Игоревна',  63,         TRUE);
INSERT INTO "Students"  ("id",  "name",                         "rating",   "majority")
VALUES                  (1,     'Михайлов Александр Павлович',  44,         FALSE);
INSERT INTO "Students"  ("id",  "name",                         "rating",   "majority")
VALUES                  (2,     'Шашков Семен Андреевич',       23,         TRUE);
INSERT INTO "Students"  ("id",  "name",                         "rating",   "majority")
VALUES                  (3,     'Авдеева Олеся Святославовна',  79,         FALSE);
INSERT INTO "Students"  ("id",  "name",                         "rating",   "majority")
VALUES                  (4,     'Семенов Марк Родионович',      45,         FALSE);
INSERT INTO "Students"  ("id",  "name",                         "rating",   "majority")
VALUES                  (5,     'Максимова Ангелина Петровна',  78,         TRUE);
INSERT INTO "Students"  ("id",  "name",                         "rating",   "majority")
VALUES                  (6,     'Логинов Эрик Робертович',      30,         FALSE);
INSERT INTO "Students"  ("id",  "name",                         "rating",   "majority")
VALUES                  (7,     'Крылов Алексей Васильевич',    81,         TRUE);

/* Timetable */

INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (0,   '10:00:00', '12:30:00', 1, 0, 0, 1);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (1,   '13:00:00', '13:30:00', 1, 0, 4, 1);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (2,   '13:00:00', '13:30:00', 1, 0, 5, 5);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (3,   '10:00:00', '12:30:00', 3, 0, 0, 1);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (4,   '13:00:00', '13:30:00', 3, 0, 4, 5);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (5,   '10:00:00', '12:30:00', 4, 0, 0, 5);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (6,   '10:00:00', '12:30:00', 4, 0, 4, 1);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (7,   '13:00:00', '13:30:00', 4, 0, 5, 5);

INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (8,   '10:00:00', '12:30:00', 1, 1, 4, 2);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (9,   '13:00:00', '13:30:00', 1, 1, 5, 2);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (10,  '13:00:00', '13:30:00', 1, 1, 0, 2);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (11,  '10:00:00', '12:30:00', 3, 1, 5, 2);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (12,  '13:00:00', '13:30:00', 3, 1, 5, 2);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (13,  '10:00:00', '12:30:00', 4, 1, 4, 2);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (14,  '10:00:00', '12:30:00', 4, 1, 5, 2);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (15,  '13:00:00', '13:30:00', 4, 1, 0, 2);

INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (16,  '10:00:00', '12:30:00', 1, 2, 4, 3);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (17,  '13:00:00', '13:30:00', 1, 2, 0, 3);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (18,  '13:00:00', '13:30:00', 1, 2, 5, 3);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (19,  '10:00:00', '12:30:00', 3, 2, 4, 3);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (20,  '13:00:00', '13:30:00', 3, 2, 0, 3);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (21,  '10:00:00', '12:30:00', 4, 2, 5, 3);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (22,  '10:00:00', '12:30:00', 4, 2, 0, 3);
INSERT INTO "Timetable" ("id", "start", "end", "dow", "id_courses", "id_rooms", "id_teachers") VALUES (23,  '13:00:00', '13:30:00', 4, 2, 4, 3);

/* Documents */

INSERT INTO "Documents" ("id", "type", "number", "id_teachers") VALUES (0,  'Паспорт',                  '4004 078567',      1);
INSERT INTO "Documents" ("id", "type", "number", "id_teachers") VALUES (2,  'Паспорт',                  '4015 427247',      2);
INSERT INTO "Documents" ("id", "type", "number", "id_teachers") VALUES (4,  'Паспорт',                  '4000 934575',      3);
INSERT INTO "Documents" ("id", "type", "number", "id_teachers") VALUES (6,  'Паспорт',                  '4003 524157',      5);
INSERT INTO "Documents" ("id", "type", "number", "id_teachers") VALUES (1,  'Диплом',                   '473892 7462947',   1);
INSERT INTO "Documents" ("id", "type", "number", "id_teachers") VALUES (3,  'Диплом',                   '471548 2874782',   2);
INSERT INTO "Documents" ("id", "type", "number", "id_teachers") VALUES (5,  'Диплом',                   '215678 3205704',   3);
INSERT INTO "Documents" ("id", "type", "number", "id_teachers") VALUES (7,  'Диплом',                   '393024 7882445',   5);
INSERT INTO "Documents" ("id", "type", "number", "id_students") VALUES (23, 'Свидетельство о рождении', 'IV-ЖА 837462',     1);
INSERT INTO "Documents" ("id", "type", "number", "id_students") VALUES (24, 'Свидетельство о рождении', 'XI-ВЫ 643254',     3);
INSERT INTO "Documents" ("id", "type", "number", "id_students") VALUES (25, 'Свидетельство о рождении', 'XV-МК 867014',     4);
INSERT INTO "Documents" ("id", "type", "number", "id_students") VALUES (26, 'Свидетельство о рождении', 'II-ЛУ 953135',     6);
INSERT INTO "Documents" ("id", "type", "number", "id_students") VALUES (29, 'Паспорт',                  '4018 850788',      0);
INSERT INTO "Documents" ("id", "type", "number", "id_students") VALUES (32, 'Паспорт',                  '4017 634234',      2);
INSERT INTO "Documents" ("id", "type", "number", "id_students") VALUES (33, 'Паспорт',                  '4019 853456',      5);
INSERT INTO "Documents" ("id", "type", "number", "id_students") VALUES (34, 'Паспорт',                  '4020 352465',      7);

/* Jobs */

INSERT INTO "Jobs"      ("id", "name", "id_teachers") VALUES (0,   'ФГАОУ ВО СПбПУ',    3);
INSERT INTO "Jobs"      ("id", "name", "id_teachers") VALUES (1,   'ФГАОУ ВО СПбПУ',    5);
INSERT INTO "Jobs"      ("id", "name", "id_teachers") VALUES (2,   'ООО НеоБИТ',        1);
INSERT INTO "Jobs"      ("id", "name", "id_teachers") VALUES (3,   'АО МЦСТ',           2);

/* Parents */

INSERT INTO "Parents"   ("id", "name", "id_students") VALUES (30,  'Михайлов Павел Антонович',      0);
INSERT INTO "Parents"   ("id", "name", "id_students") VALUES (31,  'Михайлова Зоя Васильевна',      1);
INSERT INTO "Parents"   ("id", "name", "id_students") VALUES (32,  'Авдеев Святослав Богданович',   2);
INSERT INTO "Parents"   ("id", "name", "id_students") VALUES (33,  'Авдеева Елена Юрьевна',         3);
INSERT INTO "Parents"   ("id", "name", "id_students") VALUES (34,  'Семенов Родион Витальевич',     4);
INSERT INTO "Parents"   ("id", "name", "id_students") VALUES (35,  'Семенова Валерия Мартыновна',   5);
INSERT INTO "Parents"   ("id", "name", "id_students") VALUES (36,  'Логинов Роберт Геннадьевич',    6);
INSERT INTO "Parents"   ("id", "name", "id_students") VALUES (37,  'Логинова Кристина Матвеевна',   7);


/* Equipment */

INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (0,     'ПК',                       92394);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (1,     'ПК',                       40446);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (2,     'ПК',                       49939);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (3,     'ПК',                       14949);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (4,     'ПК',                       31254);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (5,     'ПК',                       75727);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (6,     'ПК',                       80152);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (7,     'ПК',                       43809);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (8,     'ПК',                       50706);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (9,     'ПК',                       78087);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (10,    'ПК',                       78207);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (11,    'ПК',                       98324);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (12,    'Проектор',                 28870);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (13,    'Учебный коммутатор',       46193);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (14,    'Учебный коммутатор',       59193);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (15,    'Учебный маршрутизатор',    37154);
INSERT INTO "Equipment" ("id", "name", "number_inv") VALUES (16,    'Учебный маршрутизатор',    38304);


/* Gradebook */

INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (123,    'Занятие',  4, 1, 0, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (124,    'Занятие',  4, 1, 1, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (125,    'Занятие',  3, 1, 2, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (126,    'Занятие',  4, 1, 3, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (127,    'Занятие',  5, 1, 4, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (128,    'Занятие',  4, 1, 5, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (129,    'Занятие',  5, 1, 6, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (130,    'Занятие',  5, 1, 7, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (131,    'Тест',     5, 1, 0, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (132,    'Тест',     3, 1, 1, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (133,    'Тест',     5, 1, 2, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (134,    'Тест',     3, 1, 3, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (135,    'Тест',     5, 1, 4, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (136,    'Тест',     3, 1, 5, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (137,    'Тест',     4, 1, 6, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (138,    'Тест',     3, 1, 7, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (139,    'Лаба',     4, 1, 0, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (140,    'Лаба',     3, 1, 1, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (141,    'Лаба',     5, 1, 2, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (142,    'Лаба',     4, 1, 3, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (143,    'Лаба',     3, 1, 4, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (144,    'Лаба',     4, 1, 5, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (145,    'Лаба',     3, 1, 6, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (146,    'Лаба',     3, 1, 7, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (147,    'Занятие',  4, 1, 0, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (148,    'Занятие',  5, 1, 1, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (149,    'Занятие',  5, 1, 2, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (150,    'Занятие',  5, 1, 3, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (151,    'Занятие',  3, 1, 4, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (152,    'Занятие',  3, 1, 5, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (153,    'Занятие',  5, 1, 6, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (154,    'Занятие',  5, 1, 7, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (155,    'Занятие',  3, 1, 0, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (156,    'Занятие',  3, 1, 1, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (157,    'Занятие',  4, 1, 2, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (158,    'Занятие',  3, 1, 3, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (159,    'Занятие',  5, 1, 4, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (160,    'Занятие',  3, 1, 5, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (161,    'Тест',     4, 1, 0, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (162,    'Тест',     5, 1, 1, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (163,    'Тест',     4, 1, 2, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (164,    'Тест',     4, 1, 3, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (165,    'Тест',     5, 1, 4, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (166,    'Тест',     5, 1, 5, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (167,    'Тест',     3, 1, 6, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (168,    'Тест',     5, 1, 7, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (169,    'Лаба',     4, 1, 0, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (170,    'Лаба',     3, 1, 1, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (171,    'Лаба',     3, 1, 2, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (172,    'Лаба',     5, 1, 3, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (173,    'Лаба',     3, 1, 4, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (174,    'Лаба',     5, 1, 5, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (175,    'Лаба',     5, 1, 6, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (176,    'Лаба',     5, 1, 7, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (177,    'Занятие',  5, 1, 0, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (178,    'Занятие',  4, 1, 1, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (179,    'Занятие',  3, 1, 2, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (180,    'Занятие',  4, 1, 3, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (181,    'Занятие',  5, 1, 4, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (182,    'Итог',     3, 1, 0, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (183,    'Итог',     4, 1, 1, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (184,    'Итог',     5, 1, 2, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (185,    'Итог',     5, 1, 3, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (186,    'Итог',     4, 1, 4, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (187,    'Итог',     3, 1, 5, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (188,    'Итог',     4, 1, 6, 2);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (189,    'Итог',     5, 1, 7, 2);

INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (190,    'Занятие',  4, 2, 4, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (191,    'Занятие',  4, 2, 3, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (192,    'Занятие',  3, 2, 1, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (193,    'Занятие',  4, 2, 6, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (194,    'Занятие',  5, 2, 2, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (195,    'Занятие',  4, 2, 7, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (196,    'Занятие',  5, 2, 0, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (197,    'Занятие',  5, 2, 5, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (198,    'Тест',     5, 2, 4, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (199,    'Тест',     3, 2, 3, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (200,    'Тест',     5, 2, 1, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (201,    'Тест',     3, 2, 6, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (202,    'Тест',     5, 2, 2, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (203,    'Тест',     3, 2, 7, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (204,    'Тест',     4, 2, 0, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (205,    'Тест',     3, 2, 5, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (206,    'Лаба',     4, 2, 4, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (207,    'Лаба',     3, 2, 3, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (208,    'Лаба',     5, 2, 1, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (209,    'Лаба',     4, 2, 6, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (210,    'Лаба',     3, 2, 2, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (211,    'Лаба',     4, 2, 7, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (212,    'Лаба',     3, 2, 0, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (213,    'Лаба',     3, 2, 5, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (214,    'Занятие',  4, 2, 4, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (215,    'Занятие',  5, 2, 3, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (216,    'Занятие',  5, 2, 1, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (217,    'Занятие',  5, 2, 6, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (218,    'Занятие',  3, 2, 2, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (219,    'Занятие',  3, 2, 7, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (220,    'Занятие',  5, 2, 0, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (221,    'Занятие',  5, 2, 5, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (222,    'Занятие',  3, 2, 4, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (223,    'Занятие',  3, 2, 3, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (224,    'Занятие',  4, 2, 1, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (225,    'Занятие',  3, 2, 6, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (226,    'Занятие',  5, 2, 2, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (227,    'Занятие',  3, 2, 7, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (228,    'Тест',     4, 2, 4, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (229,    'Тест',     5, 2, 3, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (230,    'Тест',     4, 2, 1, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (231,    'Тест',     4, 2, 6, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (232,    'Тест',     5, 2, 2, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (233,    'Тест',     5, 2, 7, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (234,    'Тест',     3, 2, 0, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (235,    'Тест',     5, 2, 5, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (236,    'Лаба',     4, 2, 4, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (237,    'Лаба',     3, 2, 3, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (238,    'Лаба',     3, 2, 1, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (239,    'Лаба',     5, 2, 6, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (240,    'Лаба',     3, 2, 2, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (241,    'Лаба',     5, 2, 7, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (242,    'Лаба',     5, 2, 0, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (243,    'Лаба',     5, 2, 5, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (244,    'Занятие',  5, 2, 4, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (245,    'Занятие',  4, 2, 3, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (246,    'Занятие',  3, 2, 1, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (247,    'Занятие',  4, 2, 6, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (248,    'Занятие',  5, 2, 2, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (249,    'Итог',     3, 2, 4, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (250,    'Итог',     4, 2, 3, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (251,    'Итог',     5, 2, 1, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (252,    'Итог',     5, 2, 6, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (253,    'Итог',     4, 2, 2, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (254,    'Итог',     3, 2, 7, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (255,    'Итог',     4, 2, 0, 3);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (256,    'Итог',     5, 2, 5, 3);

INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (257,    'Занятие',  4, 1, 7, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (258,    'Занятие',  4, 1, 0, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (259,    'Занятие',  3, 1, 2, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (260,    'Занятие',  4, 1, 1, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (261,    'Занятие',  5, 1, 3, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (262,    'Занятие',  4, 1, 4, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (263,    'Занятие',  5, 1, 5, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (264,    'Занятие',  5, 1, 6, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (265,    'Тест',     5, 1, 7, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (266,    'Тест',     3, 1, 0, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (267,    'Тест',     5, 1, 2, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (268,    'Тест',     3, 1, 1, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (269,    'Тест',     5, 1, 3, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (270,    'Тест',     3, 1, 4, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (271,    'Тест',     4, 1, 5, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (272,    'Тест',     3, 1, 6, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (273,    'Лаба',     4, 1, 7, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (274,    'Лаба',     3, 1, 0, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (275,    'Лаба',     5, 1, 2, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (276,    'Лаба',     4, 1, 1, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (277,    'Лаба',     3, 1, 3, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (278,    'Лаба',     4, 1, 4, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (279,    'Лаба',     3, 1, 5, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (280,    'Лаба',     3, 1, 6, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (281,    'Занятие',  4, 1, 7, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (282,    'Занятие',  5, 1, 0, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (283,    'Занятие',  5, 1, 2, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (284,    'Занятие',  5, 1, 1, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (285,    'Занятие',  3, 1, 3, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (286,    'Занятие',  3, 1, 4, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (287,    'Занятие',  5, 1, 5, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (288,    'Занятие',  5, 1, 6, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (289,    'Занятие',  3, 1, 7, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (290,    'Занятие',  3, 1, 0, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (291,    'Занятие',  4, 1, 2, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (292,    'Занятие',  3, 1, 1, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (293,    'Занятие',  5, 1, 3, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (294,    'Занятие',  3, 1, 4, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (295,    'Тест',     4, 1, 7, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (296,    'Тест',     5, 1, 0, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (297,    'Тест',     4, 1, 2, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (298,    'Тест',     4, 1, 1, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (299,    'Тест',     5, 1, 3, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (300,    'Тест',     5, 1, 4, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (301,    'Тест',     3, 1, 5, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (302,    'Тест',     5, 1, 6, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (303,    'Лаба',     4, 1, 7, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (304,    'Лаба',     3, 1, 0, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (305,    'Лаба',     3, 1, 2, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (306,    'Лаба',     5, 1, 1, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (307,    'Лаба',     3, 1, 3, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (308,    'Лаба',     5, 1, 4, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (309,    'Лаба',     5, 1, 5, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (310,    'Лаба',     5, 1, 6, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (311,    'Занятие',  5, 1, 7, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (312,    'Занятие',  4, 1, 0, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (313,    'Занятие',  3, 1, 2, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (314,    'Занятие',  4, 1, 1, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (315,    'Занятие',  5, 1, 3, 5);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (316,    'Итог',     3, 1, 7, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (317,    'Итог',     4, 1, 0, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (318,    'Итог',     5, 1, 2, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (319,    'Итог',     5, 1, 1, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (320,    'Итог',     4, 1, 3, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (321,    'Итог',     3, 1, 4, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (322,    'Итог',     4, 1, 5, 1);
INSERT INTO "Gradebook" ("id", "type", "score", "id_courses", "id_students", "id_teachers") VALUES (323,    'Итог',     5, 1, 6, 1);

