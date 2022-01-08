/*
 * Tests
 */


/* Test case 1 -- Decrease of Student's rating */
--      Initial:
-- INSERT INTO "Students"   ("id",  "name",                     "rating",   "majority")
-- VALUES                   (2,     'Шашков Семен Андреевич',   23,         TRUE);

UPDATE "Students" SET "rating" = 19 WHERE "id" = 2;

--      Expected:
-- ERROR:  student_check(): Student's rating can't go lower then the threshold level
-- CONTEXT:  PL/pgSQL function student_check() line 7 at RAISE
-- SQL state: P0001


/* Test case 2 -- Previous Courses' price */
--      Initial:
-- INSERT INTO "Courses"    ("id",  "name",                         "annotation",                               "duration", "price" )
-- VALUES                   (0,     'Информационная безопасность',  'Программа переподготовки специалистов',    512,        120000  );
-- INSERT INTO "Courses"    ("id",  "name",                         "annotation",                               "duration", "price" )
-- VALUES                   (1,     'Компьютерные сети',            'Введение в компьютерные сети',             103,        40000   );

INSERT INTO "Courses_MM_Courses" ("id_courses_cur", "id_courses_prev") VALUES (1, 0);

--      Expected:
-- ERROR:  previous_price_check(): No course can be cheaper that any of it's previous course
-- CONTEXT:  PL/pgSQL function previous_price_check() line 10 at RAISE
-- SQL state: P0001
