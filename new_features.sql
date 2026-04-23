-- ============================================================
--  New Features — run after hospital_db.sql + features_db.sql
-- ============================================================
USE hospital_db;

-- Patient Reports / X-Ray uploads by doctor
CREATE TABLE IF NOT EXISTS patient_reports (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    patient_id      INT NOT NULL,
    doctor_id       INT NOT NULL,
    appointment_id  INT,
    report_type     ENUM('xray','lab','prescription','other') DEFAULT 'other',
    file_name       VARCHAR(255) NOT NULL,
    file_path       VARCHAR(500) NOT NULL,
    description     TEXT,
    send_email      TINYINT(1) DEFAULT 0,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)  REFERENCES doctors(id)  ON DELETE CASCADE
);

-- Online Payments
CREATE TABLE IF NOT EXISTS payments (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    bill_id         INT NOT NULL,
    patient_id      INT NOT NULL,
    amount          DECIMAL(10,2) NOT NULL,
    payment_method  ENUM('card','upi','netbanking','wallet') DEFAULT 'card',
    transaction_id  VARCHAR(100),
    status          ENUM('pending','success','failed') DEFAULT 'pending',
    paid_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bill_id)    REFERENCES bills(id)    ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- Doctor Notes per patient
CREATE TABLE IF NOT EXISTS doctor_notes (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id   INT NOT NULL,
    patient_id  INT NOT NULL,
    note        TEXT NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id)  REFERENCES doctors(id)  ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- Ensure photo columns exist
ALTER TABLE patients ADD COLUMN IF NOT EXISTS photo VARCHAR(255) DEFAULT NULL;
ALTER TABLE doctors  ADD COLUMN IF NOT EXISTS photo VARCHAR(255) DEFAULT NULL;
ALTER TABLE admins   ADD COLUMN IF NOT EXISTS photo VARCHAR(255) DEFAULT NULL;

-- Expand bills payment_method ENUM to support online payment methods
ALTER TABLE bills
MODIFY COLUMN payment_method
ENUM('cash','card','online','insurance','upi','netbanking','wallet') DEFAULT 'cash';

-- ============================================================
-- END
-- ============================================================
