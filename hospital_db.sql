-- ============================================================
--  Hospital Management System - MySQL Database
--  Run this in phpMyAdmin (XAMPP) or MySQL CLI
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE hospital_db;

-- ============================================================
-- 1. ADMINS
-- ============================================================
CREATE TABLE admins (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    phone       VARCHAR(20),
    password    VARCHAR(255) NOT NULL,          -- BCrypt hashed
    otp         VARCHAR(10)  DEFAULT NULL,       -- for forgot-password
    otp_expiry  DATETIME     DEFAULT NULL,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Default admin (password = admin123  →  BCrypt hash below)
INSERT INTO admins (full_name, email, phone, password)
VALUES ('Admin User', 'admin@hms.com', '+1-555-0001',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S');

-- ============================================================
-- 2. DEPARTMENTS
-- ============================================================
CREATE TABLE departments (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO departments (name, description) VALUES
('Cardiology',   'Heart and cardiovascular system'),
('Neurology',    'Brain and nervous system'),
('Pediatrics',   'Children health care'),
('Orthopedics',  'Bones, joints and muscles'),
('Dermatology',  'Skin, hair and nails'),
('General',      'General medicine');

-- ============================================================
-- 3. DOCTORS
-- ============================================================
CREATE TABLE doctors (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    password        VARCHAR(255) NOT NULL,          -- BCrypt hashed
    gender          ENUM('Male','Female','Other'),
    qualification   VARCHAR(100),                   -- e.g. MD, FACC
    specialization  VARCHAR(100),
    department_id   INT,
    experience_yrs  INT DEFAULT 0,
    consultation_fee DECIMAL(10,2) DEFAULT 0.00,
    address         TEXT,
    bio             TEXT,
    otp             VARCHAR(10)  DEFAULT NULL,
    otp_expiry      DATETIME     DEFAULT NULL,
    status          ENUM('active','inactive') DEFAULT 'active',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- ============================================================
-- 4. PATIENTS
-- ============================================================
CREATE TABLE patients (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    password        VARCHAR(255) NOT NULL,          -- BCrypt hashed
    gender          ENUM('Male','Female','Other'),
    age             INT,
    blood_group     VARCHAR(5),                     -- O+, A-, etc.
    address         TEXT,
    otp             VARCHAR(10)  DEFAULT NULL,
    otp_expiry      DATETIME     DEFAULT NULL,
    status          ENUM('active','inactive') DEFAULT 'active',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 5. DOCTOR SCHEDULES
-- ============================================================
CREATE TABLE doctor_schedules (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id   INT NOT NULL,
    day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
    start_time  TIME NOT NULL,
    end_time    TIME NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- ============================================================
-- 6. APPOINTMENTS
-- ============================================================
CREATE TABLE appointments (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    patient_id      INT NOT NULL,
    doctor_id       INT NOT NULL,
    department_id   INT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason          TEXT,
    status          ENUM('pending','approved','completed','cancelled','rejected')
                    DEFAULT 'pending',
    notes           TEXT,                           -- doctor notes after visit
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id)    REFERENCES patients(id)    ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)     REFERENCES doctors(id)     ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- ============================================================
-- 7. PRESCRIPTIONS
-- ============================================================
CREATE TABLE prescriptions (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id  INT NOT NULL UNIQUE,            -- one prescription per appointment
    patient_id      INT NOT NULL,
    doctor_id       INT NOT NULL,
    diagnosis       TEXT,
    medicines       TEXT,                           -- comma-separated or JSON string
    instructions    TEXT,
    follow_up_date  DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id)     REFERENCES patients(id)     ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)      REFERENCES doctors(id)      ON DELETE CASCADE
);

-- ============================================================
-- 8. BILLS / PAYMENTS
-- ============================================================
CREATE TABLE bills (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id      INT NOT NULL,
    patient_id          INT NOT NULL,
    doctor_id           INT NOT NULL,
    consultation_fee    DECIMAL(10,2) DEFAULT 0.00,
    medicine_charge     DECIMAL(10,2) DEFAULT 0.00,
    other_charge        DECIMAL(10,2) DEFAULT 0.00,
    total_amount        DECIMAL(10,2) GENERATED ALWAYS AS
                            (consultation_fee + medicine_charge + other_charge) STORED,
    payment_status      ENUM('pending','confirmed','paid','cancelled') DEFAULT 'pending',
    payment_method      ENUM('cash','card','online','insurance') DEFAULT 'cash',
    confirmed_by_admin  INT DEFAULT NULL,           -- admin id who confirmed
    confirmed_at        DATETIME DEFAULT NULL,
    receipt_sent        TINYINT(1) DEFAULT 0,       -- 1 = email sent to patient
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id)     REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id)         REFERENCES patients(id)     ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)          REFERENCES doctors(id)      ON DELETE CASCADE,
    FOREIGN KEY (confirmed_by_admin) REFERENCES admins(id)       ON DELETE SET NULL
);

-- ============================================================
-- 9. FEEDBACK / CONTACT MESSAGES
-- ============================================================
CREATE TABLE feedback (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100),
    email       VARCHAR(150),
    subject     VARCHAR(200),
    message     TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- END
-- ============================================================
