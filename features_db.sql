-- ============================================================
--  New Feature Tables — run after hospital_db.sql
-- ============================================================
USE hospital_db;

-- Notifications
CREATE TABLE IF NOT EXISTS notifications (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    user_role   ENUM('patient','doctor','admin') NOT NULL,
    title       VARCHAR(200) NOT NULL,
    message     TEXT NOT NULL,
    type        VARCHAR(50) DEFAULT 'info',   -- info, success, warning
    is_read     TINYINT(1) DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctor Reviews
CREATE TABLE IF NOT EXISTS reviews (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    patient_id      INT NOT NULL,
    doctor_id       INT NOT NULL,
    appointment_id  INT NOT NULL UNIQUE,
    rating          INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id)     REFERENCES patients(id)     ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)      REFERENCES doctors(id)      ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE
);

-- Profile Photos
ALTER TABLE patients ADD COLUMN IF NOT EXISTS photo VARCHAR(255) DEFAULT NULL;
ALTER TABLE doctors  ADD COLUMN IF NOT EXISTS photo VARCHAR(255) DEFAULT NULL;
ALTER TABLE admins   ADD COLUMN IF NOT EXISTS photo VARCHAR(255) DEFAULT NULL;

-- Language preference
ALTER TABLE patients ADD COLUMN IF NOT EXISTS lang VARCHAR(5) DEFAULT 'en';
ALTER TABLE doctors  ADD COLUMN IF NOT EXISTS lang VARCHAR(5) DEFAULT 'en';
ALTER TABLE admins   ADD COLUMN IF NOT EXISTS lang VARCHAR(5) DEFAULT 'en';

-- ============================================================
-- END
-- ============================================================
