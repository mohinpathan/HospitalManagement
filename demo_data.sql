-- ============================================================
--  DEMO DATA — Run this AFTER hospital_db.sql
--  Passwords are BCrypt hashes of the plain text shown below
--  admin123  → $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S
--  doctor123 → $2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi  (same as "password")
--  patient123→ same hash used below
-- ============================================================

USE hospital_db;

-- ── Departments (already seeded, safe to re-run) ──────────
INSERT IGNORE INTO departments (id, name, description) VALUES
(1, 'Cardiology',   'Heart and cardiovascular system'),
(2, 'Neurology',    'Brain and nervous system'),
(3, 'Pediatrics',   'Children health care'),
(4, 'Orthopedics',  'Bones, joints and muscles'),
(5, 'Dermatology',  'Skin, hair and nails'),
(6, 'General',      'General medicine');

-- ── Admins ────────────────────────────────────────────────
-- Password: admin123
INSERT IGNORE INTO admins (id, full_name, email, phone, password) VALUES
(1, 'Admin User',    'admin@hms.com',   '+91-9876543210',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S'),
(2, 'Super Admin',   'super@hms.com',   '+91-9876543211',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S');

-- ── Doctors ───────────────────────────────────────────────
-- Password: doctor123
INSERT IGNORE INTO doctors
  (id, full_name, email, phone, password, gender, qualification,
   specialization, department_id, experience_yrs, consultation_fee, address, status)
VALUES
(1, 'Dr. Sarah Johnson',  'sarah@hms.com',   '+91-9000000001',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Female', 'MD, FACC', 'Cardiologist',   1, 15, 800.00, 'Rajkot, Gujarat', 'active'),
(2, 'Dr. Michael Chen',   'michael@hms.com', '+91-9000000002',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Male',   'MD, PhD',  'Neurologist',    2, 12, 900.00, 'Rajkot, Gujarat', 'active'),
(3, 'Dr. Emily Davis',    'emily@hms.com',   '+91-9000000003',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Female', 'MD, FAAP', 'Pediatrician',   3, 10, 600.00, 'Rajkot, Gujarat', 'active'),
(4, 'Dr. Robert Brown',   'robert@hms.com',  '+91-9000000004',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Male',   'MS, FRCS', 'Orthopedic Surgeon', 4, 18, 1000.00, 'Rajkot, Gujarat', 'active'),
(5, 'Dr. Priya Sharma',   'priya@hms.com',   '+91-9000000005',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Female', 'MD, DVD',  'Dermatologist',  5,  8, 700.00, 'Rajkot, Gujarat', 'active'),
(6, 'Dr. James Wilson',   'james@hms.com',   '+91-9000000006',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Male',   'MBBS, MD', 'General Physician', 6, 6, 500.00, 'Rajkot, Gujarat', 'active');

-- ── Patients ──────────────────────────────────────────────
-- Password: patient123
INSERT IGNORE INTO patients
  (id, full_name, email, phone, password, gender, age, blood_group, address, status)
VALUES
(1, 'John Smith',    'john@hms.com',    '+91-8000000001',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Male',   45, 'O+',  '12 MG Road, Rajkot', 'active'),
(2, 'Emma Wilson',   'emma@hms.com',    '+91-8000000002',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Female', 32, 'A+',  '45 Station Road, Rajkot', 'active'),
(3, 'Raj Patel',     'raj@hms.com',     '+91-8000000003',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Male',   28, 'B+',  '78 University Road, Rajkot', 'active'),
(4, 'Priya Mehta',   'priya.p@hms.com', '+91-8000000004',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Female', 35, 'AB+', '23 Kalawad Road, Rajkot', 'active'),
(5, 'Arjun Singh',   'arjun@hms.com',   '+91-8000000005',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVyc5AlL2S',
   'Male',   52, 'O-',  '56 Gondal Road, Rajkot', 'active');

-- ── Doctor Schedules ──────────────────────────────────────
INSERT IGNORE INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time) VALUES
(1,'Monday','09:00:00','17:00:00'),
(1,'Wednesday','09:00:00','17:00:00'),
(1,'Friday','09:00:00','17:00:00'),
(2,'Tuesday','10:00:00','18:00:00'),
(2,'Thursday','10:00:00','18:00:00'),
(3,'Monday','08:00:00','16:00:00'),
(3,'Tuesday','08:00:00','16:00:00'),
(3,'Thursday','08:00:00','16:00:00'),
(4,'Wednesday','09:00:00','17:00:00'),
(4,'Friday','09:00:00','17:00:00'),
(5,'Monday','10:00:00','18:00:00'),
(5,'Thursday','10:00:00','18:00:00'),
(6,'Monday','08:00:00','20:00:00'),
(6,'Tuesday','08:00:00','20:00:00'),
(6,'Wednesday','08:00:00','20:00:00'),
(6,'Thursday','08:00:00','20:00:00'),
(6,'Friday','08:00:00','20:00:00');

-- ── Appointments ──────────────────────────────────────────
INSERT IGNORE INTO appointments
  (id, patient_id, doctor_id, department_id, appointment_date, appointment_time, reason, status)
VALUES
(1, 1, 1, 1, CURDATE(),                '10:00:00', 'Chest pain and shortness of breath', 'approved'),
(2, 2, 2, 2, DATE_ADD(CURDATE(),INTERVAL 1 DAY), '11:00:00', 'Frequent headaches and dizziness', 'pending'),
(3, 3, 3, 3, DATE_ADD(CURDATE(),INTERVAL 2 DAY), '09:00:00', 'Child vaccination schedule', 'approved'),
(4, 4, 4, 4, DATE_ADD(CURDATE(),INTERVAL 3 DAY), '14:00:00', 'Knee pain after sports injury', 'pending'),
(5, 5, 1, 1, DATE_ADD(CURDATE(),INTERVAL 4 DAY), '15:00:00', 'Routine cardiac checkup', 'approved'),
(6, 1, 6, 6, DATE_SUB(CURDATE(),INTERVAL 5 DAY), '10:30:00', 'Fever and cold', 'completed'),
(7, 2, 5, 5, DATE_SUB(CURDATE(),INTERVAL 3 DAY), '11:30:00', 'Skin rash treatment', 'completed');

-- ── Prescriptions ─────────────────────────────────────────
INSERT IGNORE INTO prescriptions
  (appointment_id, patient_id, doctor_id, diagnosis, medicines, instructions, follow_up_date)
VALUES
(6, 1, 6, 'Viral fever with upper respiratory infection',
   'Paracetamol 500mg twice daily, Cetirizine 10mg at night, Vitamin C 500mg daily',
   'Rest for 3 days, drink plenty of fluids, avoid cold food',
   DATE_ADD(CURDATE(), INTERVAL 7 DAY)),
(7, 2, 5, 'Allergic contact dermatitis',
   'Hydrocortisone cream 1% apply twice daily, Cetirizine 10mg at night',
   'Avoid allergen exposure, keep skin moisturized, do not scratch',
   DATE_ADD(CURDATE(), INTERVAL 14 DAY));

-- ── Bills ─────────────────────────────────────────────────
INSERT IGNORE INTO bills
  (id, appointment_id, patient_id, doctor_id,
   consultation_fee, medicine_charge, other_charge,
   payment_status, payment_method, receipt_sent)
VALUES
(1, 6, 1, 6, 500.00, 150.00, 50.00, 'confirmed', 'cash',   1),
(2, 7, 2, 5, 700.00, 200.00, 0.00,  'pending',   'online', 0);

-- ── Feedback ──────────────────────────────────────────────
INSERT IGNORE INTO feedback (name, email, subject, message) VALUES
('John Smith',  'john@hms.com',  'Great Service',
 'The doctors are very professional and the appointment system is very convenient.'),
('Emma Wilson', 'emma@hms.com',  'Excellent Experience',
 'Very smooth process from booking to consultation. Highly recommended!');

-- ============================================================
-- DEMO LOGIN CREDENTIALS
-- ============================================================
-- Admin:   admin@hms.com   / admin123
-- Doctor:  sarah@hms.com   / admin123  (all doctors use same hash)
-- Patient: john@hms.com    / admin123  (all patients use same hash)
-- ============================================================
