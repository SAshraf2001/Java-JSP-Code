-- Online Learning Management System (LMS) Database Schema
-- Target Database: MySQL/MariaDB compatible

CREATE DATABASE IF NOT EXISTS lms_db;
USE lms_db;

-- 1. User Table
-- Stores details for both Students and Instructors
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'STUDENT', -- 'STUDENT' or 'INSTRUCTOR'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Course Table
-- Stores metadata of courses created by Instructors
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    instructor_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Enrollment Table
-- Maps students to courses they are enrolled in
CREATE TABLE IF NOT EXISTS enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_student_course (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Module Table
-- Courses are divided into multiple learning modules
CREATE TABLE IF NOT EXISTS modules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    order_index INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Lesson Table
-- Modules contain lessons (readings, videos, etc.)
CREATE TABLE IF NOT EXISTS lessons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    video_url VARCHAR(500),
    order_index INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Assignment Table
-- Lessons can have assignments associated with them
CREATE TABLE IF NOT EXISTS assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lesson_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    max_points INT NOT NULL DEFAULT 100,
    due_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. AssignmentSubmission Table
-- Tracks student submissions and grades
CREATE TABLE IF NOT EXISTS assignment_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    submission_text TEXT,
    file_path VARCHAR(500),
    grade VARCHAR(10) DEFAULT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================================
-- Sample User Seeds
-- =========================================================================

-- Seed Instructors
INSERT INTO users (name, email, password, role) VALUES 
('Dr. Jane Doe', 'instructor@lms.com', 'password123', 'INSTRUCTOR'),
('Prof. Alan Turing', 'alan@lms.com', 'password123', 'INSTRUCTOR');

-- Seed Students
INSERT INTO users (name, email, password, role) VALUES 
('John Smith', 'student@lms.com', 'password123', 'STUDENT'),
('Alice Cooper', 'alice@lms.com', 'password123', 'STUDENT');

-- Seed Sample Courses
INSERT INTO courses (title, description, instructor_id) VALUES 
('Introduction to Java MVC', 'Learn the basics of building web applications using Servlets, JDBC, and JSP.', 1),
('Database Design with MySQL', 'Master the art of creating normalized database schemas, joins, and indexing.', 1),
('Algorithms & Data Structures', 'Deep dive into computer science fundamentals with Alan Turing.', 2);

-- Seed Sample Enrollments
-- Enroll John Smith (ID: 3) in Java MVC (ID: 1) and Database Design (ID: 2)
INSERT INTO enrollments (student_id, course_id) VALUES 
(3, 1),
(3, 2);

-- Enroll Alice Cooper (ID: 4) in Java MVC (ID: 1) and Algorithms (ID: 3)
INSERT INTO enrollments (student_id, course_id) VALUES 
(4, 1),
(4, 3);

-- Seed Sample Modules for Course 1 (Java MVC)
INSERT INTO modules (course_id, title, description, order_index) VALUES 
(1, 'Module 1: Servlet Architecture', 'Understanding HTTP lifecycle, request/response objects, and web.xml routing.', 1),
(1, 'Module 2: JDBC Integration', 'Connecting Java applications to relational databases safely with SQL.', 2);

-- Seed Sample Lessons for Module 1
INSERT INTO lessons (module_id, title, content, video_url, order_index) VALUES 
(1, 'Lesson 1.1: Web Container Fundamentals', 'An introduction to Servlets and how Tomcat manages concurrent requests.', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 1),
(1, 'Lesson 1.2: Session Management', 'How to use HttpSession for keeping user credentials across requests.', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 2);
