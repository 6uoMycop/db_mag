/*
 * Tests
 */


/* Test case 1.1 -- Decrease of Student's rating */

UPDATE "Students" SET "rating" = 19 WHERE "id" = 2;

--      Expected:
-- ERROR:  student_check(): Student's rating can't go lower then the threshold level
-- CONTEXT:  PL/pgSQL function student_check() line 7 at RAISE
-- SQL state: P0001


/* Test case 1.2 -- Previous Courses' price */

INSERT INTO "Courses_MM_Courses" ("id_courses_cur", "id_courses_prev") VALUES (1, 0);

--      Expected:
-- ERROR:  previous_price_check(): No course can be cheaper that any of it's previous course
-- CONTEXT:  PL/pgSQL function previous_price_check() line 10 at RAISE
-- SQL state: P0001



/* Test cases 2.1.X -- Student's policy - SELECT */

/* Test case 2.1.1 */

RESET ROLE;
SET ROLE _dementyeva;
SELECT "rating" FROM "Students";

--      Expected:
-- ERROR:  permission denied for table Students
-- SQL state: 42501

RESET ROLE;


/* Test case 2.1.2 */

RESET ROLE;
SET ROLE _dementyeva;
SELECT "username", "name", "majority" FROM "Students";

--      Expected:
-- "_dementyeva"	"Дементьева Наталия Игоревна"	true

RESET ROLE;


/* Test case 2.1.3 */

RESET ROLE;
SET ROLE _dementyeva;
SELECT "type", "number" FROM "Documents" WHERE "id_students" = (SELECT "id" FROM "Students");

--      Expected:
-- "Паспорт"	"4018 850788"

RESET ROLE;


/* Test case 2.1.4 */

RESET ROLE;
SET ROLE _dementyeva;
SELECT "name" FROM "Parents" WHERE "id_students" = (SELECT "id" FROM "Students");

--      Expected:
-- "Дементьев Игорь Матвеевич"
-- "Дементьева Ольга Владиславовна"

RESET ROLE;



/* Test cases 2.2.X -- Student's policy - UPDATE */

/* Test case 2.2.1 */

RESET ROLE;
SET ROLE _dementyeva;
UPDATE "Students" set "name" = 'Тест' WHERE "username" = '_dementyeva';

--      Expected:
-- UPDATE 1

SELECT "name" FROM "Students";

--      Expected:
-- "Тест"

RESET ROLE;


/* Test case 2.2.2 */

RESET ROLE;
SET ROLE _dementyeva;
UPDATE "Students" set "majority" = FALSE WHERE "username" = '_dementyeva';

--      Expected:
-- ERROR:  permission denied for table Students
-- SQL state: 42501

RESET ROLE;


/* Test case 2.3 -- Student's policy - INSERT */

RESET ROLE;
SET ROLE _newstudent;
INSERT INTO "Students"  ("id", "username",    "name")
VALUES                  (10,   '_newstudent', 'Тест Тест');

--      Expected:
-- INSERT 0 1

RESET ROLE;
SELECT * FROM "Students" WHERE "username" = '_newstudent';

--      Expected:
-- 10	"_newstudent"	"Тест Тест"	0	[null]


/* Test cases 2.4.X -- Administrator's policy */

/* Test case 2.4.1 */

RESET ROLE;
SET ROLE role_administrator;
SELECT * FROM get_price_avg_by_teacher(); 

--      Expected:
-- 79000	"Сысоева Лариса Вениаминовна"
-- 120000	"Иванков Илья Дмитриевич"
-- 120000	"Тарасов Роман Семенович"
-- 40000	"Мишин Даниил Романович"

RESET ROLE;


/* Test case 2.4.2 */

RESET ROLE;
SET ROLE role_student;
SELECT * FROM get_price_avg_by_teacher(); 

--      Expected:
-- ERROR:  permission denied for table Teachers_MM_Courses
-- CONTEXT:  SQL function "get_price_avg_by_teacher" statement 1
-- SQL state: 42501

RESET ROLE;




/* Test case 3.1 -- Student's policy (views) - SELECT */

RESET ROLE;
SET ROLE _dementyeva;
SELECT * FROM view_students, view_documents, view_parents;

--      Expected:
-- 0	"_dementyeva"	"Дементьева Наталия Игоревна"	true	29	"Паспорт"	"4018 850788"	0	"Дементьев Игорь Матвеевич"			0
-- 0	"_dementyeva"	"Дементьева Наталия Игоревна"	true	29	"Паспорт"	"4018 850788"	0	"Дементьева Ольга Владиславовна"	0

RESET ROLE;


/* Test cases 3.2.X -- Student's policy (views) - UPDATE */

/* Test case 3.2.1 */

RESET ROLE;
SET ROLE _dementyeva;
UPDATE "view_students" set "name" = 'Тест' WHERE "username" = '_dementyeva';

--      Expected:
-- UPDATE 1

SELECT "name" FROM "view_students";

--      Expected:
-- "Тест"

RESET ROLE;


/* Test case 3.2.2 */

RESET ROLE;
SET ROLE _dementyeva;
UPDATE "view_students" set "majority" = FALSE WHERE "username" = '_dementyeva';

--      Expected:
-- ERROR:  permission denied for view view_students
-- SQL state: 42501

RESET ROLE;


/* Test case 2.3 -- Student's policy (views) - INSERT */

RESET ROLE;
SET ROLE _newstudent;
INSERT INTO "view_students"  ("id", "username",    "name")
VALUES                       (10,   '_newstudent', 'Тест Тест');

--      Expected:
-- INSERT 0 1

RESET ROLE;
SELECT * FROM "Students" WHERE "username" = '_newstudent';

--      Expected:
-- 10	"_newstudent"	"Тест Тест"	0	[null]



/* Test cases 3.4.X -- Administrator's policy */

/* Test case 3.4.1 */

RESET ROLE;
SET ROLE role_administrator;
SELECT * FROM get_price_avg_by_teacher(); 

--      Expected:
-- 79000	"Сысоева Лариса Вениаминовна"
-- 120000	"Иванков Илья Дмитриевич"
-- 120000	"Тарасов Роман Семенович"
-- 40000	"Мишин Даниил Романович"

RESET ROLE;


/* Test case 3.4.2 */

RESET ROLE;
SET ROLE role_student;
SELECT * FROM get_price_avg_by_teacher(); 

--      Expected:
-- ERROR:  permission denied for view view_teachers_mm_courses
-- CONTEXT:  SQL function "get_price_avg_by_teacher" statement 1
-- SQL state: 42501

RESET ROLE;

