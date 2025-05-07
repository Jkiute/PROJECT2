CREATE DATABASE course_management;
 
  Create SCHEMA Edtech
  
  USE course_management;
  
--Create table students
  
create table students (
  student_id INT PRIMARY KEY,
  first_nanme VARCHAR(50),
  last_mname VARCHAR(50),
  email VARCHAR(100),
  date_of_birth DATE
 );

--Create Instructors table
CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

--Create Courses table
   CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_description TEXT,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

--Create Enrollments table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(1),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

--Inserting Data into Students table
INSERT INTO course_management.students (student_id, first_name, last_name, email, date_of_birth) VALUES
(1, 'Jared', 'Kiute', 'jared.kiute@gmail.com', '1997-05-15'),
(2, 'Kay', 'Kelvin', 'kay.kelvin@gmail.com', '1999-08-12'),
(3, 'Jett', 'chi', 'jett.chi@gmail.com', '2000-11-01'),
(4, 'David', 'Mwaura', 'david.mwaura@gmail.com', '1995-05-19'),
(5, 'Eva', 'Chao', 'eva.chao@gmail.com', '1996-01-10'),
(6, 'Frank', 'Madondo', 'frank.madondo@gmail.com', '1999-10-04'),
(7, 'Grace', 'Atieno', 'grace.atieno@gmail.com', '1999-02-14'),
(8, 'Henry', 'Thiery', 'henry.thiery@gmail.com', '1998-09-20'),
(9, 'Chris', 'Black', 'chris.black@gmail.com', '2003-02-02'),
(10, 'Jack', 'Daniels', 'jack.daniels@gmail.com', '1992-10-07');

--Display all the data inserted into students table
SELECT * FROM course_management.students s;

--Inserting Data into Instructors table
INSERT INTO course_management.instructors (instructor_id, first_name, last_name, email) VALUES
(1, 'Faith', 'Samantha', 'faith.samantha@gmail.com'),
(2, 'Linda', 'Musangi', 'linda.musangi@gmail.com'),
(3, 'Robert', 'Dinero', 'robert.dinero@gmail.com');

--Display all the data inserted into instructors table
SELECT * FROM course_management.instructors i ;

--Inserting Data into table Courses
INSERT INTO course_management.courses (course_id, course_name, course_description, instructor_id) VALUES
(1, 'SQL Basics', 'Intro to SQL Fundamentals', 1),
(2, 'Advanced SQL', 'Complex SQL Concepts', 1),
(3, 'Python for Data Science', 'Intro to Python', 2),
(4, 'Data Structures', 'Learn about Data Structures', 3),
(5, 'Machine Learning', 'Basics of ML', 3);

--Display all the data inserted into courses table
SELECT * FROM course_management.courses c ;

--Inserting Data into table Enrollments
INSERT INTO course_management.enrollments (enrollment_id, student_id, course_id, enrollment_date, grade) VALUES
(1, 1, 1, '2025-04-15', 'A'),
(2, 1, 2, '2025-04-16', 'B'),
(3, 2, 1, '2025-04-17', 'C'),
(4, 3, 3, '2025-04-18', 'B'),
(5, 4, 4, '2025-04-19', 'A'),
(6, 5, 5, '2025-04-20', 'D'),
(7, 6, 1, '2025-04-21', 'A'),
(8, 7, 2, '2025-04-22', 'B'),
(9, 8, 5, '2025-04-23', 'A'),
(10, 9, 3, '2025-04-24', 'C'),
(11, 10, 4, '2025-04-25', 'F'),
(12, 5, 1, '2025-04-26', 'B'),
(13, 6, 2, '2025-04-27', 'A'),
(14, 7, 3, '2025-04-28', 'B'),
(15, 8, 4, '2025-04-29', 'C');

--Display all the data inserted into Enrollments table
SELECT * FROM course_management.enrollments e ;

-- PART 3 WRITING THE SQL QUERIES

-- Students who enrolled in at least one course

SELECT DISTINCT s.student_id, s.first_name, s.last_name, s.email, s.date_of_birth
FROM course_management.students s
JOIN course_management.enrollments e ON s.student_id = e.student_id;

--Students enrolled in more than two courses
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS course_count
FROM course_management.students s
JOIN course_management.enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) > 2;

--Courses with total enrolled students
SELECT c.course_id, c.course_name, COUNT(e.student_id) AS total_students
FROM course_management.courses c
LEFT JOIN course_management.enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

--Average grade per course
SELECT c.course_name, 
       AVG(CASE 
           WHEN e.grade = 'A' THEN 4
           WHEN e.grade = 'B' THEN 3
           WHEN e.grade = 'C' THEN 2
           WHEN e.grade = 'D' THEN 1
           WHEN e.grade = 'F' THEN 0
       END) AS average_grade
FROM courses c JOIN enrollments e ON c.course_id = e.course_id GROUP BY c.course_id;

--Students who haven’t enrolled in any course
SELECT s.first_name, s.last_name FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

--Students with their average grade across all courses

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

-- Instructors with the number of courses they teach
SELECT i.first_name, i.last_name, COUNT(c.course_id) AS total_courses FROM instructors i
LEFT JOIN courses c ON i.instructor_id = c.instructor_id
GROUP BY i.instructor_id;

-- Students enrolled in a course taught by “Mercy Smith”
SELECT s.first_name, s.last_name FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.first_name = 'Mercy' AND i.last_name = 'Smith';

-- Top 3 students by average grade
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

-- Students failing (grade = ‘F’) in more than one course
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS failing_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade = 'F'
GROUP BY s.student_id
HAVING failing_courses > 1;


-- Part 4: ADVANCED SQL

-- Create a VIEW named student_course_summary (student name, course, grade)
CREATE VIEW student_course_summary AS
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, c.course_name, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Displaying the student_course_summary view created above
SELECT * FROM student_course_summary;

-- Adding an INDEX on enrollments.student_id
CREATE INDEX idx_student_id ON enrollments(student_id);

-- Create a trigger or stored procedure that logs new enrollments
-- create a enrollment_logs table to store logs
CREATE TABLE enrollment_logs ( 
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    action VARCHAR(50),
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- create a trigger that inserts a log when a new enrollment is added
DELIMITER $$

CREATE TRIGGER log_new_enrollment
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
    INSERT INTO enrollment_logs (student_id, course_id, action)
    VALUES (NEW.student_id, NEW.course_id, 'ENROLLMENT CREATED');
END$$

DELIMITER ;

--  Select all from enrollment to verify logging works by inserting a new row into enrollments
SELECT * FROM enrollment_logs;
