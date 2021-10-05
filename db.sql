CREATE TABLE "public.Students" (
/* Attributes */
	"id"			serial,
	"name"			varchar(128),
	"rating"		integer			NOT NULL,
	"majority"		BOOLEAN			NOT NULL,
/* Attributes constraints */

/* Foreign keys */
	"id_documents"	integer			NOT NULL,
	"id_parents"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT	"Students_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Teachers" (
/* Attributes */
	"id"			serial,
	"name"			varchar(128),
	"speciality"	varchar(64)		NOT NULL,
	"degree"		varchar(32)		NOT NULL,
	"rating"		integer			NOT NULL,
	"salary"		FLOAT			NOT NULL,
/* Attributes constraints */


/* Foreign keys */
	"id_documents"	integer			NOT NULL,
	"id_jobs"		integer			NOT NULL,
/* Primary key */
	CONSTRAINT	"Teachers_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Courses" (
/* Attributes */
	"id"			serial,
	"name"			varchar(128),
	"annotation"	TEXT(1024)		NOT NULL,
	"duration"		integer			NOT NULL,
	"price"			integer			NOT NULL,
/* Attributes constraints */


/* Foreign keys */
	"id_courses"	integer			NOT NULL,
	"id_teachers"	integer			NOT NULL,
	"id_students"	integer			NOT NULL,
	"id_equipment"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT	"Courses_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Gragebook" (
/* Attributes */
	"id"			serial			NOT NULL,
	"type"			varchar(32)		NOT NULL,
	"score"			integer			NOT NULL,
/* Attributes constraints */


/* Foreign keys */
	"id_teachers"	BINARY			NOT NULL,
	"id_students"	BINARY			NOT NULL,
	"id_courses"	BINARY			NOT NULL,
/* Primary key */
	CONSTRAINT	"Gragebook_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Rooms" (
/* Attributes */
	"id"			serial			NOT NULL,
	"type"			varchar(32)		NOT NULL,
	"number"		integer(32)		NOT NULL,
/* Attributes constraints */


/* Foreign keys */
	"id_equipment"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT	"Rooms_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Timetable" (
/* Attributes */
	"id"			serial			NOT NULL,
	"start"			DATETIME		NOT NULL,
	"end"			DATETIME		NOT NULL,
/* Attributes constraints */


/* Foreign keys */
	"id_teachers"	integer			NOT NULL,
	"id_students"	integer			NOT NULL,
	"id_rooms"		integer			NOT NULL,
	"id_courses"	integer			NOT NULL,
/* Primary key */
	CONSTRAINT	"Timetable_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Documents" (
/* Attributes */
	"id"			serial			NOT NULL,
	"type"			varchar(64)		NOT NULL,
	"number"		DECIMAL			NOT NULL,
/* Attributes constraints */


/* Foreign keys */
/* Primary key */
	CONSTRAINT	"Documents_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Jobs" (
/* Attributes */
	"id"			serial			NOT NULL,
	"name"			varchar(128)	NOT NULL,
/* Attributes constraints */


/* Foreign keys */
/* Primary key */
	CONSTRAINT	"Jobs_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Parents" (
/* Attributes */
	"id"			serial			NOT NULL,
	"name"			serial(128)		NOT NULL,
/* Attributes constraints */


/* Foreign keys */
/* Primary key */
	CONSTRAINT	"Parents_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Equipment" (
/* Attributes */
	"id"			serial			NOT NULL,
	"name"			serial(128)		NOT NULL,
/* Attributes constraints */


/* Foreign keys */
/* Primary key */
	CONSTRAINT	"Equipment_pk"	PRIMARY KEY ("id")
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
