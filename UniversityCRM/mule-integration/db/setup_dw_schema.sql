-- ============================================================
-- Dimension + fact schema for enrollment batch sync testing
-- Run this in Supabase Studio's SQL Editor, or via psql:
--   psql -h localhost -p 54322 -U postgres -d postgres -f setup_dw_schema.sql
-- ============================================================

DROP TABLE IF EXISTS fact_enrollment;
DROP TABLE IF EXISTS dim_student;
DROP TABLE IF EXISTS dim_course;

CREATE TABLE dim_student (
    student_key         SERIAL PRIMARY KEY,
    student_external_id TEXT UNIQUE NOT NULL,
    first_name          TEXT NOT NULL,
    last_name           TEXT NOT NULL,
    email               TEXT
);

CREATE TABLE dim_course (
    course_key          SERIAL PRIMARY KEY,
    course_external_id  TEXT UNIQUE NOT NULL,
    course_name         TEXT NOT NULL,
    max_capacity        INT DEFAULT 30
);

CREATE TABLE fact_enrollment (
    enrollment_key   SERIAL PRIMARY KEY,
    student_key      INT NOT NULL REFERENCES dim_student(student_key),
    course_key       INT NOT NULL REFERENCES dim_course(course_key),
    enrollment_date  DATE NOT NULL DEFAULT CURRENT_DATE,
    status           TEXT NOT NULL DEFAULT 'Active',
    sync_status      TEXT,           -- NULL / 'PENDING' = not yet synced, 'SUCCESS' / 'FAILED' after sync
    sync_timestamp   TIMESTAMP
);

-- ============================================================
-- Seed data: 15 students
-- NOTE: use these exact student_external_id values when you
-- create matching Student__c test records in Salesforce
-- (Student_External_Id__c field).
-- ============================================================
INSERT INTO dim_student (student_external_id, first_name, last_name, email) VALUES
('STU-001', 'Ava',     'Nguyen',    'ava.nguyen@example.edu'),
('STU-002', 'Liam',    'Patel',     'liam.patel@example.edu'),
('STU-003', 'Sophia',  'Garcia',    'sophia.garcia@example.edu'),
('STU-004', 'Noah',    'Kim',       'noah.kim@example.edu'),
('STU-005', 'Emma',    'Rossi',     'emma.rossi@example.edu'),
('STU-006', 'Oliver',  'Schmidt',   'oliver.schmidt@example.edu'),
('STU-007', 'Isabella','Dubois',    'isabella.dubois@example.edu'),
('STU-008', 'Elijah',  'Okafor',    'elijah.okafor@example.edu'),
('STU-009', 'Mia',     'Andersson', 'mia.andersson@example.edu'),
('STU-010', 'Lucas',   'Silva',     'lucas.silva@example.edu'),
('STU-011', 'Amelia',  'Ivanov',    'amelia.ivanov@example.edu'),
('STU-012', 'Mason',   'Tanaka',    'mason.tanaka@example.edu'),
('STU-013', 'Harper',  'Costa',     'harper.costa@example.edu'),
('STU-014', 'Ethan',   'Novak',     'ethan.novak@example.edu'),
('STU-015', 'Ella',    'Haddad',    'ella.haddad@example.edu');

-- ============================================================
-- Seed data: 5 courses
-- Same note: use these course_external_id values for
-- Course__c.Course_External_Id__c in Salesforce.
-- Max_capacity kept small so you can also test the waitlist
-- logic in your Apex trigger if you want.
-- ============================================================
INSERT INTO dim_course (course_external_id, course_name, max_capacity) VALUES
('CRS-001', 'Intro to Data Systems',   4),
('CRS-002', 'Calculus II',            4),
('CRS-003', 'Organic Chemistry',      4),
('CRS-004', 'World History Seminar',  4),
('CRS-005', 'Intro to Psychology',    4);

-- ============================================================
-- Seed data: 18 enrollments, spread across courses.
-- sync_status left NULL so the Mule flow's WHERE clause
-- (sync_status IS NULL OR sync_status = 'PENDING') picks them up.
-- ============================================================
INSERT INTO fact_enrollment (student_key, course_key, enrollment_date, status) VALUES
(1, 1, CURRENT_DATE, 'Active'),
(2, 1, CURRENT_DATE, 'Active'),
(3, 1, CURRENT_DATE, 'Active'),
(4, 1, CURRENT_DATE, 'Active'),
(5, 1, CURRENT_DATE, 'Active'),  -- 5th enrollment in a 4-capacity course: good waitlist test
(6, 2, CURRENT_DATE, 'Active'),
(7, 2, CURRENT_DATE, 'Active'),
(8, 2, CURRENT_DATE, 'Active'),
(9, 3, CURRENT_DATE, 'Active'),
(10, 3, CURRENT_DATE, 'Active'),
(11, 3, CURRENT_DATE, 'Active'),
(12, 4, CURRENT_DATE, 'Active'),
(13, 4, CURRENT_DATE, 'Active'),
(14, 5, CURRENT_DATE, 'Active'),
(15, 5, CURRENT_DATE, 'Active'),
(1,  2, CURRENT_DATE, 'Active'),
(2,  3, CURRENT_DATE, 'Active'),
(3,  4, CURRENT_DATE, 'Active');

-- Quick sanity check after running:
-- SELECT f.enrollment_key, ds.student_external_id, dc.course_external_id, f.status, f.sync_status
-- FROM fact_enrollment f
-- JOIN dim_student ds ON f.student_key = ds.student_key
-- JOIN dim_course dc ON f.course_key = dc.course_key;