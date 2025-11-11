-- Student Management System (SQL Project)
-- Author: Bodramoni Eshika
-- Date: November 2025

DROP SCHEMA IF EXISTS student_management CASCADE;
CREATE SCHEMA IF NOT EXISTS student_management;

DROP TABLE IF EXISTS student_management.user_login;
CREATE TABLE IF NOT EXISTS student_management.user_login (
	user_id TEXT PRIMARY KEY,
    user_password TEXT,
    first_name TEXT,
	last_name TEXT,
	sign_up_on DATE,
	email_id TEXT
);

DROP TABLE IF EXISTS student_management.parent_details;
CREATE TABLE IF NOT EXISTS student_management.parent_details (
	parent_id TEXT PRIMARY KEY,
    father_first_name TEXT,
	father_last_name TEXT,
	father_email_id TEXT,
	father_mobile TEXT,
	father_occupation TEXT,
	mother_first_name TEXT,
	mother_last_name TEXT,
	mother_email_id TEXT,
	mother_mobile TEXT,
	mother_occupation TEXT
);

DROP TABLE IF EXISTS student_management.teachers;
CREATE TABLE IF NOT EXISTS student_management.teachers (
	teacher_id TEXT PRIMARY KEY,
    first_name TEXT,
	last_name TEXT,
	date_of_birth DATE,
	email_id TEXT,
	contact TEXT,
	registration_date DATE,
	registration_id TEXT UNIQUE
);

DROP TABLE IF EXISTS student_management.class_details;
CREATE TABLE IF NOT EXISTS student_management.class_details (
	class_id TEXT PRIMARY KEY,
    class_teacher TEXT REFERENCES student_management.teachers (teacher_id),
	class_year TEXT
);

DROP TABLE IF EXISTS student_management.student_details;
CREATE TABLE IF NOT EXISTS student_management.student_details (
	student_id TEXT PRIMARY KEY,
    first_name TEXT,
	last_name TEXT,
	date_of_birth DATE,
	class_id TEXT REFERENCES student_management.class_details (class_id),
	roll_no TEXT,
	email_id TEXT,
	parent_id TEXT REFERENCES student_management.parent_details (parent_id),
	registration_date DATE,
	registration_id TEXT UNIQUE
);

DROP TABLE IF EXISTS student_management.subject;
CREATE TABLE IF NOT EXISTS student_management.subject (
	subject_id TEXT PRIMARY KEY,
    subject_name TEXT,
	class_year TEXT,
	subject_head TEXT REFERENCES student_management.teachers (teacher_id)
);

DROP TABLE IF EXISTS student_management.subject_tutors;
CREATE TABLE IF NOT EXISTS student_management.subject_tutors (
	row_id SERIAL PRIMARY KEY,
    subject_id TEXT REFERENCES student_management.subject (subject_id),
	teacher_id TEXT REFERENCES student_management.teachers (teacher_id),
	class_id TEXT REFERENCES student_management.class_details (class_id)
);

INSERT INTO student_management.user_login(user_id, user_password, first_name, last_name, sign_up_on, email_id)
VALUES
('u001','pass123','Eshika','Mudhiraj','2024-08-01','eshika@example.com'),
('u002','pass456','Anita','Kumar','2024-09-10','anita@example.com');

INSERT INTO student_management.parent_details(parent_id, father_first_name, father_last_name, father_email_id, father_mobile, father_occupation,
                                              mother_first_name, mother_last_name, mother_email_id, mother_mobile, mother_occupation)
VALUES
('p001','Ramesh','Mudhiraj','ramesh@example.com','9876500001','Engineer','Sangeeta','Mudhiraj','sangeeta@example.com','9876500002','Teacher'),
('p002','Vikram','Kumar','vikram@example.com','9876500003','Business','Meena','Kumar','meena@example.com','9876500004','Doctor');

INSERT INTO student_management.teachers(teacher_id, first_name, last_name, date_of_birth, email_id, contact, registration_date, registration_id)
VALUES
('t001','Suresh','Patel','1980-05-12','suresh.patel@example.com','9000000001','2020-07-01','REG-T-001'),
('t002','Meera','Shah','1985-02-20','meera.shah@example.com','9000000002','2021-01-15','REG-T-002');

INSERT INTO student_management.class_details(class_id, class_teacher, class_year)
VALUES
('c1','t001','2024'),
('c2','t002','2024');

INSERT INTO student_management.student_details(student_id, first_name, last_name, date_of_birth, class_id, roll_no, email_id, parent_id, registration_date, registration_id)
VALUES
('s001','Riya','Patel','2008-03-05','c1','01','riya.patel@example.com','p001','2022-06-10','REG-S-001'),
('s002','Aman','Khan','2007-11-12','c1','02','aman.khan@example.com','p002','2022-06-12','REG-S-002'),
('s003','Kavya','Rao','2008-01-20','c2','01','kavya.rao@example.com','p001','2022-06-20','REG-S-003');

INSERT INTO student_management.subject(subject_id, subject_name, class_year, subject_head)
VALUES
('sub1','Mathematics','2024','t001'),
('sub2','Science','2024','t002');

INSERT INTO student_management.subject_tutors(subject_id, teacher_id, class_id)
VALUES
('sub1','t001','c1'),
('sub2','t002','c2');

SELECT * FROM student_management.student_details;

SELECT first_name, last_name FROM student_management.student_details WHERE class_id = 'c1';

SELECT s.first_name || ' ' || s.last_name AS student_name,
       c.class_id,
       t.first_name || ' ' || t.last_name AS class_teacher
FROM student_management.student_details s
JOIN student_management.class_details c ON s.class_id = c.class_id
JOIN student_management.teachers t ON c.class_teacher = t.teacher_id
ORDER BY s.student_id;

SELECT class_id, COUNT(*) AS total_students
FROM student_management.student_details
GROUP BY class_id;

WITH parent_counts AS (
  SELECT parent_id, COUNT(*) AS children_count
  FROM student_management.student_details
  GROUP BY parent_id
)
SELECT s.student_id, s.first_name, s.last_name, p.father_mobile, pc.children_count
FROM student_management.student_details s
LEFT JOIN student_management.parent_details p ON s.parent_id = p.parent_id
JOIN parent_counts pc ON s.parent_id = pc.parent_id
ORDER BY pc.children_count DESC;

SELECT class_id, total_students,
       RANK() OVER (ORDER BY total_students DESC) AS class_rank
FROM (
  SELECT class_id, COUNT(*) AS total_students
  FROM student_management.student_details
  GROUP BY class_id
) t;

UPDATE student_management.user_login SET first_name = 'Eshika' WHERE user_id = 'u001';
