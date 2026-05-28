DROP DATABASE IF EXISTS lms_db;
CREATE DATABASE lms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lms_db;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Student','Instructor','Admin') NOT NULL DEFAULT 'Student',
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- Courses table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    enrollment_key VARCHAR(50) NOT NULL,
    status ENUM('Draft','Published') NOT NULL DEFAULT 'Draft',
    FOREIGN KEY (instructor_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Modules table
CREATE TABLE modules (
    module_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    display_order INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Lessons table
CREATE TABLE lessons (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    content_type ENUM('Text','PDF','Video') NOT NULL DEFAULT 'Text',
    FOREIGN KEY (module_id) REFERENCES modules(module_id) ON DELETE CASCADE
);

-- Enrollments table
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Assignments table
CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    instructions TEXT,
    due_date DATE,
    max_points INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Assignment Submissions table
CREATE TABLE assignment_submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    grade DECIMAL(5,2),
    feedback TEXT,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Mock data
INSERT INTO users (name, email, password_hash, role, is_active) VALUES
('Admin User', 'admin@example.com', '$2a$10$7aV9YlXwJxB6zJz7Zp4aPuE5V1Zz8WvY8dEJfZVhK5J6FQKc3e5aW', 'Admin', TRUE),
('Instructor One', 'instructor1@example.com', '$2a$10$7aV9YlXwJxB6zJz7Zp4aPuE5V1Zz8WvY8dEJfZVhK5J6FQKc3e5aW', 'Instructor', TRUE),
('Student One', 'student1@example.com', '$2a$10$7aV9YlXwJxB6zJz7Zp4aPuE5V1Zz8WvY8dEJfZVhK5J6FQKc3e5aW', 'Student', TRUE);

INSERT INTO courses (instructor_id, title, description, enrollment_key, status) VALUES
(2, 'Intro to Java', 'Basic Java programming concepts', 'JAVA101', 'Published');

INSERT INTO modules (course_id, title, display_order) VALUES
(1, 'Getting Started', 1),
(1, 'OOP Basics', 2);

INSERT INTO lessons (module_id, title, content, content_type) VALUES
(1, 'Hello World', 'Welcome to the course! This lesson covers ...', 'Text'),
(2, 'Classes and Objects', 'PDF link here', 'PDF');

INSERT INTO assignments (course_id, title, instructions, due_date, max_points) VALUES
(1, 'Assignment 1', 'Write a Hello World program', '2026-06-30', 100);
