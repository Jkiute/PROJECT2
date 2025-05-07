# PROJECT2
# SQL PROJECT:Student Course Management System
# Project Description
This SQL-based project simulates a Student Course Management System for an EdTech company. The goal is to design and implement a relational database system to manage students, instructors, courses, and enrollments. The project demonstrates database schema creation, data insertion, querying techniques, indexing, views, and triggers.

# How to Run the SQL Code
 After opening a new script on the Default DB on DBeaver :-
  -- Create the database
CREATE DATABASE course_management;
-Create Schema Edtech
-CREATE SCHEMA Edtech
-Run the SQL scripts
-Create the tables
-Insert Data in the Tables
-Run Part 3 and Part 4 queries

# Explanation of the Schema
Tables:
Students: Holds basic info like name, email, and DOB.
Instructors: Stores instructor information.
Courses: Each course has a description and is taught by an instructor.
Enrollments: A junction table linking students and courses stores the grade and enrollment date.

Relationships:
Students -- Enrollments: One-to-many
Courses -- Enrollments: One-to-many
Instructors -- Courses: One-to-many

# Descriptions of Key Queries
# PART 3 WRITING THE SQL QUERIES
# 3.1 Getting Students who enrolled in at least one course
SELECT DISTINCT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id;

# 3.2 Getting Students enrolled in more than two courses
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS course_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING course_count > 2;

# 3.3 Courses with total enrolled students
SELECT c.course_name, COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;

# 3.4 Average grade per course
SELECT c.course_name, 
       AVG(CASE 
           WHEN e.grade = 'A' THEN 4
           WHEN e.grade = 'B' THEN 3
           WHEN e.grade = 'C' THEN 2
           WHEN e.grade = 'D' THEN 1
           WHEN e.grade = 'F' THEN 0
       END) AS average_grade
FROM courses c JOIN enrollments e ON c.course_id = e.course_id GROUP BY c.course_id;

# 3.4 Students who haven’t enrolled in any course
SELECT s.first_name, s.last_name FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

# 3.5 Students with their average grade across all courses
SELECT s.first_name, s.last_name, 
       AVG(CASE 
           WHEN e.grade = 'A' THEN 4
           WHEN e.grade = 'B' THEN 3
           WHEN e.grade = 'C' THEN 2
           WHEN e.grade = 'D' THEN 1
           WHEN e.grade = 'F' THEN 0
       END) AS average_grade
FROM students s JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;

# 3.6 Instructors with the number of courses they teach
SELECT i.first_name, i.last_name, COUNT(c.course_id) AS total_courses FROM instructors i
LEFT JOIN courses c ON i.instructor_id = c.instructor_id
GROUP BY i.instructor_id;

# 3.7 Students enrolled in a course taught by “Mercy Smith”
SELECT s.first_name, s.last_name FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.first_name = 'Mercy' AND i.last_name = 'Smith';

# 3.8 Top 3 students by average grade
SELECT s.first_name, s.last_name, 
       AVG(CASE 
           WHEN e.grade = 'A' THEN 4
           WHEN e.grade = 'B' THEN 3
           WHEN e.grade = 'C' THEN 2
           WHEN e.grade = 'D' THEN 1
           WHEN e.grade = 'F' THEN 0
       END) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

# 3.9 Students failing (grade = ‘F’) in more than one course
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS failing_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade = 'F'
GROUP BY s.student_id
HAVING failing_courses > 1;

# Part 4: ADVANCED SQL
# 4.1 Create a VIEW named student_course_summary (student name, course, grade)
CREATE VIEW student_course_summary AS
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, c.course_name, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;
# 4.1.1 Displaying the student_course_summary view created above
SELECT * FROM student_course_summary;

-- Adding an INDEX on Enrollments.student_id
CREATE INDEX idx_student_id ON enrollments(student_id);

# 4.2 Creating a trigger or stored procedure that logs new enrollments
# 4.2.1 create a enrollment_logs table to store logs
CREATE TABLE enrollment_logs ( 
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    action VARCHAR(50),
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# 4.2.2 Create a trigger that inserts a log when a new enrollment is added
DELIMITER $$

CREATE TRIGGER log_new_enrollment
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
    INSERT INTO enrollment_logs (student_id, course_id, action)
    VALUES (NEW.student_id, NEW.course_id, 'ENROLLMENT CREATED');
END$$

DELIMITER ;
-- Select all from enrollment to verify logging works by inserting a new row into enrollments
SELECT * FROM enrollment_logs;
The Trigger Logs every new enrollment to an enrollment_logs table

# Challenges and Lessons Learned
1. Understanding relationships and foreign key constraints.
2. Importance of indexing for performance.
3. Learned to use UNION, JOIN, GROUP BY,DELIMITER and subqueries effectively.
4. Gained experience with triggers and views for real-world use cases.



