DROP TABLE IF EXISTS StudentEnrollments;

CREATE TABLE StudentEnrollments (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100),
    course_id VARCHAR(10),
    enrollment_date DATE
);

INSERT INTO StudentEnrollments (student_name, course_id, enrollment_date)
VALUES
('Ashish', 'CSE101', '2024-06-01'),
('Smaran', 'CSE102', '2024-06-01'),
('Vaibhav', 'CSE103', '2024-06-01');

START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-01' WHERE student_id = 1;

START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-05' WHERE student_id = 2;

UPDATE StudentEnrollments SET enrollment_date = '2024-07-15' WHERE student_id = 2;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-20' WHERE student_id = 1;


TRUNCATE TABLE StudentEnrollments;
INSERT INTO StudentEnrollments (student_name, course_id, enrollment_date)
VALUES ('Ashish', 'CSE101', '2024-06-01');

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1;

START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-10' WHERE student_id = 1;
COMMIT;

SELECT * FROM StudentEnrollments WHERE student_id = 1;
COMMIT;


TRUNCATE TABLE StudentEnrollments;
INSERT INTO StudentEnrollments (student_name, course_id, enrollment_date)
VALUES ('Ashish', 'CSE101', '2024-06-01');

START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1 FOR UPDATE;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1;

UPDATE StudentEnrollments SET enrollment_date = '2024-07-10' WHERE student_id = 1;
COMMIT;

SELECT * FROM StudentEnrollments WHERE student_id = 1;
