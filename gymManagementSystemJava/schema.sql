-- Drop existing database if exists
DROP DATABASE IF EXISTS gym_db;
CREATE DATABASE gym_db;
USE gym_db;

CREATE TABLE User (
    userID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Member') NOT NULL DEFAULT 'Member',
    contactNo VARCHAR(20)
);

CREATE TABLE MembershipPlan (
    planID INT AUTO_INCREMENT PRIMARY KEY,
    planName VARCHAR(100) NOT NULL,
    durationMonths INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

CREATE TABLE Subscription (
    subID INT AUTO_INCREMENT PRIMARY KEY,
    userID INT NOT NULL,
    planID INT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    status ENUM('Active', 'Expired', 'Pending') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE,
    FOREIGN KEY (planID) REFERENCES MembershipPlan(planID) ON DELETE CASCADE
);

CREATE TABLE Payment (
    paymentID INT AUTO_INCREMENT PRIMARY KEY,
    subID INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paymentDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paymentMethod VARCHAR(50) NOT NULL,
    FOREIGN KEY (subID) REFERENCES Subscription(subID) ON DELETE CASCADE
);

-- Insert Mock Data
INSERT INTO User (name, email, password, role, contactNo) VALUES 
('Admin User', 'admin@gym.com', 'admin123', 'Admin', '1234567890'),
('John Doe', 'john@member.com', 'john123', 'Member', '0987654321'),
('Jane Smith', 'jane@member.com', 'jane123', 'Member', '5551234567');

INSERT INTO MembershipPlan (planName, durationMonths, price, description) VALUES
('Basic Plan', 1, 30.00, 'Access to basic gym equipment.'),
('Standard Plan', 3, 80.00, 'Access to equipment and locker room.'),
('Premium Plan', 12, 300.00, 'All access plus personal trainer sessions.');

INSERT INTO Subscription (userID, planID, startDate, endDate, status) VALUES
(2, 2, '2023-01-01', '2023-04-01', 'Expired'),
(3, 3, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 12 MONTH), 'Active');

INSERT INTO Payment (subID, amount, paymentMethod) VALUES
(1, 80.00, 'Credit Card'),
(2, 300.00, 'Cash');

-- Feature Expansion Tables
CREATE TABLE Attendance (
    attendanceID INT AUTO_INCREMENT PRIMARY KEY,
    userID INT NOT NULL,
    checkInTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE
);

CREATE TABLE GymClass (
    classID INT AUTO_INCREMENT PRIMARY KEY,
    className VARCHAR(100) NOT NULL,
    trainerName VARCHAR(100) NOT NULL,
    scheduleTime DATETIME NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE ClassBooking (
    bookingID INT AUTO_INCREMENT PRIMARY KEY,
    userID INT NOT NULL,
    classID INT NOT NULL,
    bookingTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE,
    FOREIGN KEY (classID) REFERENCES GymClass(classID) ON DELETE CASCADE
);

-- Mock Data for Classes
INSERT INTO GymClass (className, trainerName, scheduleTime, capacity) VALUES 
('Morning Yoga', 'Sarah Connor', DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), 20),
('HIIT Bootcamp', 'John Smith', DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), 15);
