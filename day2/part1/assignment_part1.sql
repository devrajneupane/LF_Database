-- sqlfluff:indentation:tab_space_size:2
--
-- Create queries:
-- Grades table
CREATE TABLE Grades (grade_id INT PRIMARY KEY, grade_name VARCHAR(10));

-- Students table
CREATE TABLE Students (
  student_id INT PRIMARY KEY,
  student_name VARCHAR(50),
  student_age INT,
  student_grade_id INT,
  FOREIGN KEY (student_grade_id) REFERENCES Grades (grade_id)
);

-- Courses table
CREATE TABLE Courses (
  course_id INT PRIMARY KEY,
  course_name VARCHAR(50)
);

-- Enrollments table
CREATE TABLE Enrollments (
  enrollment_id INT PRIMARY KEY,
  student_id INT,
  course_id INT,
  enrollment_date DATE,
  FOREIGN KEY (student_id) REFERENCES Students (student_id),
  FOREIGN KEY (course_id) REFERENCES Courses (course_id)
);

-- Insert queries:
-- Insert into Grades table
INSERT INTO
  Grades (grade_id, grade_name)
VALUES
  (1, 'A'),
  (2, 'B'),
  (3, 'C');

SELECT
  *
FROM
  enrollments;

-- Insert into Courses table
INSERT INTO
  Courses (course_id, course_name)
VALUES
  (101, 'Math'),
  (102, 'Science'),
  (103, 'History');

-- Insert into Students table
INSERT INTO
  Students (
    student_id,
    student_name,
    student_age,
    student_grade_id
  )
VALUES
  (1, 'Alice', 17, 1),
  (2, 'Bob', 16, 2),
  (3, 'Charlie', 18, 1),
  (4, 'David', 16, 2),
  (5, 'Eve', 17, 1),
  (6, 'Frank', 18, 3),
  (7, 'Grace', 17, 2),
  (8, 'Henry', 16, 1),
  (9, 'Ivy', 18, 2),
  (10, 'Jack', 17, 3);

-- Insert into Enrollments table
INSERT INTO
  Enrollments (
    enrollment_id,
    student_id,
    course_id,
    enrollment_date
  )
VALUES
  (1, 1, 101, '2023-09-01'),
  (2, 1, 102, '2023-09-01'),
  (3, 2, 102, '2023-09-01'),
  (4, 3, 101, '2023-09-01'),
  (5, 3, 103, '2023-09-01'),
  (6, 4, 101, '2023-09-01'),
  (7, 4, 102, '2023-09-01'),
  (8, 5, 102, '2023-09-01'),
  (9, 6, 101, '2023-09-01'),
  (10, 7, 103, '2023-09-01');

-- Questions:
--
-- Find all students enrolled in the Math course.
SELECT
  s.*
FROM
  students s
  JOIN enrollments e ON s.student_id = e.student_id
  JOIN courses c ON e.course_id = c.course_id
WHERE
  c.course_name = 'Math'
GROUP BY
  s.student_id;

-- List all courses taken by students named Bob.
SELECT
  c.*
FROM
  courses c
  JOIN enrollments e ON c.course_id = e.course_id
  JOIN students s ON e.student_id = s.student_id
WHERE
  s.student_name = 'Bob';

-- Find the names of students who are enrolled in more than one course.
SELECT
  s.student_name
FROM
  students s
  JOIN enrollments e ON s.student_id = e.student_id
  JOIN courses c ON e.course_id = c.course_id
GROUP BY
  s.student_id
HAVING
  COUNT(e.course_id) > 1;

-- List all students who are in Grade A (grade_id = 1).
SELECT
  s.*
FROM
  students s
  JOIN grades g ON s.student_grade_id = g.grade_id
WHERE
  g.grade_id = 1;

-- Find the number of students enrolled in each course.
SELECT
  e.course_id,
  COUNT(e.student_id) AS students_enrolled
FROM
  enrollments e
GROUP BY
  e.course_id
ORDER BY
  e.course_id;

-- Retrieve the course with the highest number of enrollments.
SELECT
  course_name,
  COUNT(s.student_id) AS student_count
FROM
  students s
  JOIN enrollments e ON e.student_id = s.student_id
  JOIN courses c ON c.course_id = e.course_id
GROUP BY
  course_name
HAVING
  COUNT(e.student_id) = (
    SELECT
      COUNT(student_id)
    FROM
      Enrollments
    GROUP BY
      course_id
    ORDER BY
      COUNT(student_id) DESC
    LIMIT
      1
  );

-- List students who are enrolled in all available courses.
SELECT
  student_name
FROM
  students s
  JOIN enrollments e ON e.student_id = s.student_id
  JOIN courses c ON c.course_id = e.course_id
GROUP BY
  student_name
HAVING
  COUNT(e.course_id) = (
    SELECT
      COUNT(course_id)
    FROM
      courses
  );

-- Find students who are not enrolled in any courses.
SELECT
  s.*
FROM
  students s
  LEFT JOIN enrollments e ON e.student_id = s.student_id
WHERE
  e.course_id IS NULL;

-- Retrieve the average age of students enrolled in the Science course.
SELECT
  AVG(s.student_age) AS average_age
FROM
  students s
  JOIN enrollments e ON e.student_id = s.student_id
  JOIN courses c ON c.course_id = e.course_id
WHERE
  c.course_name = 'Science';

-- Find the grade of students enrolled in the History course.
SELECT
  s.student_name,
  c.course_name,
  g.grade_name
FROM
  students s
  JOIN enrollments e ON e.student_id = s.student_id
  JOIN courses c ON c.course_id = e.course_id
  JOIN grades g ON g.grade_id = s.student_grade_id
WHERE
  c.course_name = 'History';
