CREATE TABLE "public.Students" (
	"id"			serial,
	"name"			varchar(128),
	"rating"		integer			NOT NULL,
	"majority"		BOOLEAN			NOT NULL,
	"id_documents"	integer			NOT NULL,
	"id_parents"	integer			NOT NULL,
	CONSTRAINT 	"Students_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Teachers" (
	"id"			serial,
	"name"			varchar(128),
	"speciality"	varchar(64)		NOT NULL,
	"degree"		varchar(32)		NOT NULL,
	"rating"		integer			NOT NULL,
	"salary"		FLOAT			NOT NULL,
	"id_documents"	integer			NOT NULL,
	"id_jobs"		integer			NOT NULL,
	CONSTRAINT 	"Teachers_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Courses" (
	"id"			serial,
	"name"			varchar(128),
	"annotation"	TEXT(1024)		NOT NULL,
	"duration"		integer			NOT NULL,
	"price"			integer			NOT NULL,
	"id_courses"	integer			NOT NULL,
	"id_teachers"	integer			NOT NULL,
	"id_students"	integer			NOT NULL,
	"id_equipment"	integer			NOT NULL,
	CONSTRAINT 	"Courses_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Gragebook" (
	"id"			serial			NOT NULL,
	"type"			varchar(32)		NOT NULL,
	"score"			integer			NOT NULL,
	"id_teachers"	BINARY			NOT NULL,
	"id_students"	BINARY			NOT NULL,
	"id_courses"	BINARY			NOT NULL,
	CONSTRAINT 	"Gragebook_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Rooms" (
	"id"			serial			NOT NULL,
	"type"			varchar(32)		NOT NULL,
	"number"		integer(32)		NOT NULL,
	"id_equipment"	integer			NOT NULL,
	CONSTRAINT 	"Rooms_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Timetable" (
	"id"			serial			NOT NULL,
	"start"			DATETIME		NOT NULL,
	"end"			DATETIME		NOT NULL,
	"id_teachers"	integer			NOT NULL,
	"id_students"	integer			NOT NULL,
	"id_rooms"		integer			NOT NULL,
	"id_courses"	integer			NOT NULL,
	CONSTRAINT 	"Timetable_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Documents" (
	"id"			serial			NOT NULL,
	"type"			varchar(64)		NOT NULL,
	"number"		DECIMAL			NOT NULL,
	CONSTRAINT 	"Documents_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Jobs" (
	"id"			serial			NOT NULL,
	"name"			varchar(128)	NOT NULL,
	CONSTRAINT 	"Jobs_pk"		PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Parents" (
	"id"			serial			NOT NULL,
	"name"			serial(128)		NOT NULL,
	CONSTRAINT 	"Parents_pk"	PRIMARY KEY ("id")
) WITH (
	OIDS=FALSE
);



CREATE TABLE "public.Equipment" (
	"id"			serial			NOT NULL,
	"name"			serial(128)		NOT NULL,
	CONSTRAINT 	"Equipment_pk"	PRIMARY KEY ("id")
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
