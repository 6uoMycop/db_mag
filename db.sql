/*
 * Initial drop all tables
 */
 
DROP TABLE IF EXISTS "Students"		CASCADE;
DROP TABLE IF EXISTS "Teachers"		CASCADE;
DROP TABLE IF EXISTS "Courses"		CASCADE;
DROP TABLE IF EXISTS "Gragebook"	CASCADE;
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
	"id_documents"	integer			NOT NULL,
	"id_parents"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Students_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
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
	"id_documents"	integer			NOT NULL,
	"id_jobs"		integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Teachers_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
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
	"id_teachers"	integer			NOT NULL,
	"id_students"	integer			NOT NULL,
	"id_equipment"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Courses_pk"			PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "Gragebook" (
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
	"id_teachers"	integer			NOT NULL,
	"id_students"	integer			NOT NULL,
	"id_courses"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Gragebook_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "Rooms" (
/* Attributes */
	"id"			integer			NOT NULL,
	"type"			varchar(32)		NOT NULL,
	"number"		integer			NOT NULL,
/* Attributes constraints */
	CONSTRAINT "type_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"type" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "number_interval"	CHECK (		-- Number in range [101, 123]U[201, 217] -- First and second floor rooms
		(101 <= "number" AND "number" <= 123) OR (201 <= "number" AND "number" <= 217)),

/* Foreign keys */
	"id_equipment"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Rooms_pk"			PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "Timetable" (
/* Attributes */
	"id"			integer			NOT NULL,
	"start"			timestamp		NOT NULL,
	"end"			timestamp		NOT NULL,
/* Attributes constraints */
	CONSTRAINT "time_check"			CHECK (		-- Start must be erlier than end
		"start" < "end"),

/* Foreign keys */
	"id_teachers"	integer			NOT NULL,
	"id_students"	integer			NOT NULL,
	"id_rooms"		integer			NOT NULL,
	"id_courses"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT "Timetable_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "Documents" (
/* Attributes */
	"id"			integer			NOT NULL,
	"type"			varchar(64)		NOT NULL,
	"number"		DECIMAL			NOT NULL,
/* Attributes constraints */
	CONSTRAINT "type_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"type" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),
	CONSTRAINT "number_interval"	CHECK (		-- Number in range (0, inf)
		0 < "number"),

/* Foreign keys */
/* Primary key */
	CONSTRAINT "Documents_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "Jobs" (
/* Attributes */
	"id"			integer			NOT NULL,
	"name"			varchar(128)	NOT NULL,
/* Attributes constraints */
	CONSTRAINT "name_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),

/* Foreign keys */
/* Primary key */
	CONSTRAINT "Jobs_pk"			PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "Parents" (
/* Attributes */
	"id"			integer			NOT NULL,
	"name"			varchar(128)	NOT NULL,
/* Attributes constraints */
	CONSTRAINT "name_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),

/* Foreign keys */
/* Primary key */
	CONSTRAINT "Parents_pk"			PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "Equipment" (
/* Attributes */
	"id"			integer			NOT NULL,
	"name"			varchar(128)	NOT NULL,
/* Attributes constraints */
	CONSTRAINT "name_check"			CHECK (		-- Russian alphabet, space and '-'. Length >= 3
		"name" ~ '^([а-я]|[А-Я]|[ -]){3,}$'),

/* Foreign keys */
/* Primary key */
	CONSTRAINT "Equipment_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



ALTER TABLE "Students"	ADD CONSTRAINT "Students_fk0"	FOREIGN KEY ("id_documents")	REFERENCES "Documents"	("id");
ALTER TABLE "Students"	ADD CONSTRAINT "Students_fk1"	FOREIGN KEY ("id_parents")		REFERENCES "Parents"	("id");

ALTER TABLE "Teachers"	ADD CONSTRAINT "Teachers_fk0"	FOREIGN KEY ("id_documents")	REFERENCES "Documents"	("id");
ALTER TABLE "Teachers"	ADD CONSTRAINT "Teachers_fk1"	FOREIGN KEY ("id_jobs")			REFERENCES "Jobs"		("id");

ALTER TABLE "Courses"	ADD CONSTRAINT "Courses_fk0"	FOREIGN KEY ("id_courses")		REFERENCES "Courses"	("id");
ALTER TABLE "Courses"	ADD CONSTRAINT "Courses_fk1"	FOREIGN KEY ("id_teachers")		REFERENCES "Teachers"	("id");
ALTER TABLE "Courses"	ADD CONSTRAINT "Courses_fk2"	FOREIGN KEY ("id_students")		REFERENCES "Students"	("id");
ALTER TABLE "Courses"	ADD CONSTRAINT "Courses_fk3"	FOREIGN KEY ("id_equipment")	REFERENCES "Equipment"	("id");

ALTER TABLE "Gragebook"	ADD CONSTRAINT "Gragebook_fk0"	FOREIGN KEY ("id_teachers")		REFERENCES "Teachers"	("id");
ALTER TABLE "Gragebook"	ADD CONSTRAINT "Gragebook_fk1"	FOREIGN KEY ("id_students")		REFERENCES "Students"	("id");
ALTER TABLE "Gragebook"	ADD CONSTRAINT "Gragebook_fk2"	FOREIGN KEY ("id_courses")		REFERENCES "Courses"	("id");

ALTER TABLE "Rooms"		ADD CONSTRAINT "Rooms_fk0"		FOREIGN KEY ("id_equipment")	REFERENCES "Equipment"	("id");

ALTER TABLE "Timetable"	ADD CONSTRAINT "Timetable_fk0"	FOREIGN KEY ("id_teachers")		REFERENCES "Teachers"	("id");
ALTER TABLE "Timetable"	ADD CONSTRAINT "Timetable_fk1"	FOREIGN KEY ("id_students")		REFERENCES "Students"	("id");
ALTER TABLE "Timetable"	ADD CONSTRAINT "Timetable_fk2"	FOREIGN KEY ("id_rooms")		REFERENCES "Rooms"		("id");
ALTER TABLE "Timetable"	ADD CONSTRAINT "Timetable_fk3"	FOREIGN KEY ("id_courses")		REFERENCES "Courses"	("id");
