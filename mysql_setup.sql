CREATE DATABASE IF NOT EXISTS library_portal;
USE library_portal;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL DEFAULT '',
    registration_no VARCHAR(50) NOT NULL UNIQUE,
    password_plain VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    btech_branch VARCHAR(80) NOT NULL DEFAULT 'CSE',
    academic_year INT NOT NULL DEFAULT 1,
    semester INT NOT NULL DEFAULT 1,
    spent_hours DECIMAL(10,2) NOT NULL DEFAULT 0,
    books_taken INT NOT NULL DEFAULT 0,
    nearest_deadline DATE NULL,
    fine_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'full_name');
SET @ddl := IF(@col_exists = 0, 'ALTER TABLE users ADD COLUMN full_name VARCHAR(120) NOT NULL DEFAULT ''Unknown''', 'SELECT 1');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'btech_branch');
SET @ddl := IF(@col_exists = 0, 'ALTER TABLE users ADD COLUMN btech_branch VARCHAR(80) NOT NULL DEFAULT ''CSE''', 'SELECT 1');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'academic_year');
SET @ddl := IF(@col_exists = 0, 'ALTER TABLE users ADD COLUMN academic_year INT NOT NULL DEFAULT 1', 'SELECT 1');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'semester');
SET @ddl := IF(@col_exists = 0, 'ALTER TABLE users ADD COLUMN semester INT NOT NULL DEFAULT 1', 'SELECT 1');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'spent_hours');
SET @ddl := IF(@col_exists = 0, 'ALTER TABLE users ADD COLUMN spent_hours DECIMAL(10,2) NOT NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'books_taken');
SET @ddl := IF(@col_exists = 0, 'ALTER TABLE users ADD COLUMN books_taken INT NOT NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'nearest_deadline');
SET @ddl := IF(@col_exists = 0, 'ALTER TABLE users ADD COLUMN nearest_deadline DATE NULL', 'SELECT 1');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'fine_amount');
SET @ddl := IF(@col_exists = 0, 'ALTER TABLE users ADD COLUMN fine_amount DECIMAL(10,2) NOT NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS resources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    academic_year INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    resource_type VARCHAR(100) NOT NULL,
    resource_url VARCHAR(500) NOT NULL,
    description VARCHAR(400) NOT NULL
);

CREATE TABLE IF NOT EXISTS time_spend_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    spent_seconds INT NOT NULL,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_time_user_date (user_id, logged_at),
    CONSTRAINT fk_time_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS borrow_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_title VARCHAR(220) NOT NULL,
    borrowed_at DATE NOT NULL,
    due_date DATE NOT NULL,
    returned_at DATE NULL,
    INDEX idx_borrow_user_date (user_id, borrowed_at),
    CONSTRAINT fk_borrow_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (full_name, registration_no, password_plain, date_of_birth, btech_branch, academic_year, semester, spent_hours, books_taken, nearest_deadline, fine_amount)
VALUES ('Admin Student', 'admin', '1234', '2000-01-15', 'CSE', 2, 4, 124.5, 6, '2026-03-18', 25.00)
ON DUPLICATE KEY UPDATE
full_name = VALUES(full_name),
password_plain = VALUES(password_plain),
date_of_birth = VALUES(date_of_birth),
btech_branch = VALUES(btech_branch),
academic_year = VALUES(academic_year),
semester = VALUES(semester),
spent_hours = VALUES(spent_hours),
books_taken = VALUES(books_taken),
nearest_deadline = VALUES(nearest_deadline),
fine_amount = VALUES(fine_amount);

INSERT INTO resources (academic_year, title, resource_type, resource_url, description)
SELECT * FROM (
    SELECT 1 AS academic_year, 'Engineering Mathematics I' AS title, 'Book' AS resource_type, 'https://openstax.org/details/books/calculus-volume-1' AS resource_url, 'Foundation calculus for first-year BTech.' AS description
    UNION ALL SELECT 1, 'C Programming Fundamentals', 'Playlist', 'https://www.youtube.com/results?search_query=c+programming+for+beginners', 'Start with syntax, loops and arrays.'
    UNION ALL SELECT 2, 'Data Structures and Algorithms', 'Course', 'https://www.coursera.org/specializations/data-structures-algorithms', 'Core DSA for second-year coding prep.'
    UNION ALL SELECT 2, 'Database Management Systems', 'Notes', 'https://www.geeksforgeeks.org/dbms/', 'DBMS concepts for exams and interviews.'
    UNION ALL SELECT 3, 'Operating Systems', 'Reference', 'https://pages.cs.wisc.edu/~remzi/OSTEP/', 'Industry-standard OS reference material.'
    UNION ALL SELECT 3, 'Computer Networks', 'Playlist', 'https://www.youtube.com/results?search_query=computer+networks+gate+lectures', 'Detailed CN explanations with examples.'
    UNION ALL SELECT 4, 'System Design Basics', 'Guide', 'https://github.com/donnemartin/system-design-primer', 'Preparation for placements and projects.'
    UNION ALL SELECT 4, 'Interview Prep DSA Sheet', 'Practice', 'https://takeuforward.org/interviews/strivers-sde-sheet-top-coding-interview-problems/', 'Final-year interview-focused problem list.'
) AS seed_data
WHERE NOT EXISTS (
    SELECT 1 FROM resources r
    WHERE r.academic_year = seed_data.academic_year
      AND r.title = seed_data.title
);

INSERT INTO time_spend_logs (user_id, spent_seconds, logged_at)
SELECT u.id, seed.spent_seconds, seed.logged_at
FROM users u
JOIN (
    SELECT 2100 AS spent_seconds, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 6 DAY), '10:15:00') AS logged_at
    UNION ALL SELECT 1800, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 5 DAY), '11:20:00')
    UNION ALL SELECT 2400, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 4 DAY), '13:35:00')
    UNION ALL SELECT 1200, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 3 DAY), '15:10:00')
    UNION ALL SELECT 2700, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 2 DAY), '16:40:00')
    UNION ALL SELECT 3000, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 1 DAY), '17:15:00')
    UNION ALL SELECT 3600, TIMESTAMP(CURDATE(), '18:00:00')
) AS seed
WHERE u.registration_no = 'admin'
  AND NOT EXISTS (SELECT 1 FROM time_spend_logs l WHERE l.user_id = u.id);

INSERT INTO borrow_events (user_id, book_title, borrowed_at, due_date, returned_at)
SELECT u.id, seed.book_title, seed.borrowed_at, seed.due_date, seed.returned_at
FROM users u
JOIN (
    SELECT 'Database System Concepts' AS book_title, DATE_SUB(CURDATE(), INTERVAL 28 DAY) AS borrowed_at, DATE_SUB(CURDATE(), INTERVAL 2 DAY) AS due_date, NULL AS returned_at
    UNION ALL SELECT 'Clean Code', DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_ADD(CURDATE(), INTERVAL 4 DAY), NULL
    UNION ALL SELECT 'Operating System Concepts', DATE_SUB(CURDATE(), INTERVAL 55 DAY), DATE_SUB(CURDATE(), INTERVAL 25 DAY), DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    UNION ALL SELECT 'Computer Networks', DATE_SUB(CURDATE(), INTERVAL 80 DAY), DATE_SUB(CURDATE(), INTERVAL 45 DAY), DATE_SUB(CURDATE(), INTERVAL 50 DAY)
) AS seed
WHERE u.registration_no = 'admin'
  AND NOT EXISTS (SELECT 1 FROM borrow_events b WHERE b.user_id = u.id);
