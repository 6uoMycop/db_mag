/*
 * Users and Security Policy
 */



/*
 * Initial drop
 */

DROP ROLE IF EXISTS role_administrator;
DROP ROLE IF EXISTS role_student;

DROP USER IF EXISTS ivankov;
DROP USER IF EXISTS _dementyeva;
DROP USER IF EXISTS _newstudent;

DROP POLICY IF EXISTS policy_administrator  ON "Teachers";
DROP POLICY IF EXISTS policy_administrator  ON "Courses";
DROP POLICY IF EXISTS policy_administrator  ON "Teachers_MM_Courses";

DROP POLICY IF EXISTS policy_student        ON "Students";
DROP POLICY IF EXISTS policy_student        ON "Documents";
DROP POLICY IF EXISTS policy_student        ON "Parents";

DROP FUNCTION IF EXISTS get_price_avg_by_teacher();
DROP FUNCTION IF EXISTS get_price_min_by_teacher();
DROP FUNCTION IF EXISTS get_price_max_by_teacher();



/*
 * Creation of roles and users
 */

CREATE ROLE role_administrator;
CREATE ROLE role_student;

CREATE USER ivankov;
CREATE USER _dementyeva;
CREATE USER _newstudent;

GRANT role_administrator TO ivankov;
GRANT role_student TO _dementyeva;
GRANT role_student TO _newstudent;



/*
 * Policy
 */

ALTER TABLE "Teachers"              ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Courses"               ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Teachers_MM_Courses"   ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Students"              ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Documents"             ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Parents"               ENABLE ROW LEVEL SECURITY;

/*
 * role_administrator
 */

CREATE POLICY policy_administrator ON "Teachers"
    TO role_administrator
    USING (TRUE);
 
CREATE POLICY policy_administrator ON "Courses"
    TO role_administrator
    USING (TRUE);
	
CREATE POLICY policy_administrator ON "Teachers_MM_Courses"
    TO role_administrator
    USING (TRUE);


GRANT SELECT (
      "id"
    , "name"
) ON "Teachers"
TO role_administrator;

GRANT SELECT (
      "id"
    , "price"
) ON "Courses"
TO role_administrator;

GRANT SELECT (
      "id_teachers"
    , "id_courses"
) ON "Teachers_MM_Courses"
TO role_administrator;


/* Average price */
CREATE FUNCTION get_price_avg_by_teacher()
RETURNS TABLE(
      "price_avg"   FLOAT
    , "teacher"     varchar(128)
) AS $$
    SELECT
          AVG("Courses"."price") AS "price_avg"
        , "Teachers"."name"      AS "teacher"
    FROM
          "Teachers_MM_Courses"
        , "Courses"
        , "Teachers"
    WHERE (
            "Teachers_MM_Courses"."id_courses" = "Courses"."id"
    	AND "Teachers_MM_Courses"."id_teachers" = "Teachers"."id"
    ) GROUP BY "teacher"
$$
LANGUAGE SQL;


/* Minimal price */
CREATE FUNCTION get_price_min_by_teacher()
RETURNS TABLE(
      "price_min"   FLOAT
    , "teacher"     varchar(128)
) AS $$
    SELECT
          MIN("Courses"."price") AS "price_min"
        , "Teachers"."name"      AS "teacher"
    FROM
          "Teachers_MM_Courses"
        , "Courses"
        , "Teachers"
    WHERE (
            "Teachers_MM_Courses"."id_courses" = "Courses"."id"
    	AND "Teachers_MM_Courses"."id_teachers" = "Teachers"."id"
    ) GROUP BY "teacher"
$$
LANGUAGE SQL;


/* Maximal price */
CREATE FUNCTION get_price_max_by_teacher()
RETURNS TABLE(
      "price_max"   FLOAT
    , "teacher"     varchar(128)
) AS $$
    SELECT
          MAX("Courses"."price") AS "price_max"
        , "Teachers"."name"      AS "teacher"
    FROM
          "Teachers_MM_Courses"
        , "Courses"
        , "Teachers"
    WHERE (
            "Teachers_MM_Courses"."id_courses" = "Courses"."id"
    	AND "Teachers_MM_Courses"."id_teachers" = "Teachers"."id"
    ) GROUP BY "teacher"
$$
LANGUAGE SQL;



/*
 * role_student
 */

CREATE POLICY policy_student ON "Students"
    TO role_student
    USING (current_user = "Students"."username")
    WITH CHECK (current_user = "Students"."username");

CREATE POLICY policy_student ON "Documents"
    TO role_student
    USING (current_user = (SELECT "username" FROM "Students" WHERE "id" = "Documents"."id_students"))
    WITH CHECK (current_user = (SELECT "username" FROM "Students" WHERE "id" = "Documents"."id_students"));

CREATE POLICY policy_student ON "Parents"
    TO role_student
    USING (current_user = (SELECT "username" FROM "Students" WHERE "id" = "Parents"."id_students"));


GRANT
    INSERT (
          "id"
        , "username"
        , "name"
    ),
    SELECT (
          "id"
        , "username"
        , "name"
        , "majority"
    ),
    UPDATE (
          "name"
    )
ON "Students"
TO role_student;

GRANT
    INSERT (
          "id"
        , "type"
        , "number"
        , "id_students"
    ),
    SELECT (
          "id"
        , "type"
        , "number"
        , "id_students"
    ),
    UPDATE (
          "type"
        , "number"
    )
ON "Documents"
TO role_student;

GRANT
    SELECT (
          "name"
        , "id_students"
    )
ON "Parents"
TO role_student;









/*
 * Users and Security Policy -- views
 */

/*
 * Initial drop
 */

DROP ROLE IF EXISTS role_administrator;
DROP ROLE IF EXISTS role_student;

DROP USER IF EXISTS ivankov;
DROP USER IF EXISTS _dementyeva;
DROP USER IF EXISTS _newstudent;

DROP VIEW IF EXISTS view_student_info;
--DROP VIEW IF EXISTS view_student_info;



/*
 * Creation of roles and users
 */

CREATE ROLE role_administrator;
CREATE ROLE role_student;

CREATE USER ivankov;
CREATE USER _dementyeva;
CREATE USER _newstudent;

GRANT role_administrator TO ivankov;
GRANT role_student TO _dementyeva;
GRANT role_student TO _newstudent;




/*
 * Policy
 */

/*
 * role_administrator
 */

CREATE VIEW view_teachers AS
    SELECT
          "id"
        , "name"
    FROM "Teachers";

CREATE VIEW view_courses AS
    SELECT
          "id"
        , "price"
    FROM "Courses";

CREATE VIEW view_teachers_mm_courses AS
    SELECT
          "id_teachers"
        , "id_courses"
    FROM "Teachers_MM_Courses";


GRANT
    SELECT
ON view_teachers
TO role_administrator;

GRANT
    SELECT
ON view_courses
TO role_administrator;

GRANT
    SELECT
ON view_teachers_mm_courses
TO role_administrator;


/* Average price */
CREATE FUNCTION get_price_avg_by_teacher()
RETURNS TABLE(
      "price_avg"   FLOAT
    , "teacher"     varchar(128)
) AS $$
    SELECT
          AVG("view_courses"."price") AS "price_avg"
        , "view_teachers"."name"      AS "teacher"
    FROM
          "view_teachers_mm_courses"
        , "view_courses"
        , "view_teachers"
    WHERE (
            "view_teachers_mm_courses"."id_courses" = "view_courses"."id"
    	AND "view_teachers_mm_courses"."id_teachers" = "view_teachers"."id"
    ) GROUP BY "teacher"
$$
LANGUAGE SQL;


/* Minimal price */
CREATE FUNCTION get_price_min_by_teacher()
RETURNS TABLE(
      "price_min"   FLOAT
    , "teacher"     varchar(128)
) AS $$
    SELECT
          MIN("view_courses"."price") AS "price_avg"
        , "view_teachers"."name"      AS "teacher"
    FROM
          "view_teachers_mm_courses"
        , "view_courses"
        , "view_teachers"
    WHERE (
            "view_teachers_mm_courses"."id_courses" = "view_courses"."id"
    	AND "view_teachers_mm_courses"."id_teachers" = "view_teachers"."id"
    ) GROUP BY "teacher"
$$
LANGUAGE SQL;


/* Maximal price */
CREATE FUNCTION get_price_max_by_teacher()
RETURNS TABLE(
      "price_max"   FLOAT
    , "teacher"     varchar(128)
) AS $$
    SELECT
          MAX("view_courses"."price") AS "price_avg"
        , "view_teachers"."name"      AS "teacher"
    FROM
          "view_teachers_mm_courses"
        , "view_courses"
        , "view_teachers"
    WHERE (
            "view_teachers_mm_courses"."id_courses" = "view_courses"."id"
    	AND "view_teachers_mm_courses"."id_teachers" = "view_teachers"."id"
    ) GROUP BY "teacher"
$$
LANGUAGE SQL;









/*
 * role_student
 */

CREATE VIEW view_students AS
    SELECT
          "id"
        , "username"
        , "name"
        , "majority"
    FROM "Students"
    WHERE current_user = "username";

CREATE VIEW view_documents AS
    SELECT
          "id"
        , "type"
        , "number"
        , "id_students"
    FROM "Documents"
    WHERE current_user = (SELECT "username" FROM "Students" WHERE "id" = "Documents"."id_students");

CREATE VIEW view_parents AS
    SELECT
          "name"
        , "id_students"
    FROM "Parents"
    WHERE current_user = (SELECT "username" FROM "Students" WHERE "id" = "Parents"."id_students");

GRANT
    SELECT,
    INSERT (
          "id"
        , "username"
        , "name"
    ),
    UPDATE (
          "name"
    )
ON view_students
TO role_student;

GRANT
    SELECT,
    INSERT (
          "id"
        , "type"
        , "number"
        , "id_students"
    ),
    UPDATE (
          "type"
        , "number"
    )
ON view_documents
TO role_student;


GRANT
    SELECT
ON view_parents
TO role_student;


