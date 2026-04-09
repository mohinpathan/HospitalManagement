# 🏥 HealthCare Connect — Hospital Management System

A full-stack **Hospital Management System** built with **Spring MVC**, **JSP**, **MySQL (XAMPP)**, and **Bootstrap 5**. Supports three user roles — **Patient**, **Doctor**, and **Admin** — each with their own portal, dashboard, and feature set.

---

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Setup & Installation](#setup--installation)
- [Demo Credentials](#demo-credentials)
- [API / URL Reference](#api--url-reference)
- [Email Notifications](#email-notifications)
- [Screenshots](#screenshots)
- [Contributing](#contributing)

---

## ✨ Features

### 🧑 Patient Portal
| Feature | Description |
|---|---|
| Register / Login | Role-based registration with BCrypt password hashing |
| Dashboard | Stats: total, upcoming, completed appointments + prescriptions |
| Find Doctors | Search by name, filter by department, max fee, sort by fee/experience |
| Book Appointment | Select doctor, date, time, reason — pre-selects doctor from Find Doctors |
| My Appointments | View all appointments with status badges, cancel pending/approved |
| Medical Records | View prescriptions, diagnosis, medicines, bill breakdown |
| My Profile | Edit personal info (name, phone, age, blood group, address), change password |

### 👨‍⚕️ Doctor Portal
| Feature | Description |
|---|---|
| Dashboard | Stats: total, today, pending, completed appointments |
| Appointments | View all patient appointments, write prescription for approved ones |
| Write Prescription | Diagnosis, medicines, instructions, follow-up date + bill generation |
| My Profile | Edit contact info, change password, view professional details |

### 🛡️ Admin Portal
| Feature | Description |
|---|---|
| Dashboard | Live stats: doctors, patients, appointments, departments + pending approvals |
| Manage Doctors | Add, edit, delete doctors with full details |
| Manage Patients | View all patients, view details, soft delete |
| Manage Appointments | Approve, reject, delete appointments |
| Manage Departments | Add, delete departments with doctor count |
| Bills & Payments | Confirm bills, send receipt + prescription email to patient |
| Admin Profile | Edit profile, change password |

### 🔐 Authentication
- BCrypt password hashing
- Role-based session management
- Forgot password with 6-digit OTP (10-minute expiry)
- OTP countdown timer on verify page
- Password strength indicator on reset page

### 📧 Email Notifications
- Welcome email on registration
- Login alert on every login
- OTP email for password reset
- Password reset success confirmation
- Bill receipt + prescription email to patient

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Backend Framework | Spring MVC 6.1.6 |
| View Layer | JSP (JavaServer Pages) |
| Database | MySQL 9.0 via XAMPP |
| DB Access | Spring JdbcTemplate |
| Security | BCrypt (jbcrypt 0.4) |
| Email | JavaMail via Gmail SMTP |
| Frontend | Bootstrap 5.3.2 + Font Awesome 6.5 |
| Build Tool | Maven 3 |
| Server | Apache Tomcat 11 |
| Java Version | Java 17 |

---

## 📁 Project Structure

```
HospitalManagement/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── com/hospital/
│   │   │   │   ├── controller/
│   │   │   │   │   ├── AuthController.java       # Login, Register, OTP, Reset
│   │   │   │   │   ├── AdminController.java      # Admin CRUD operations
│   │   │   │   │   ├── PatientController.java    # Patient portal
│   │   │   │   │   ├── DoctorController.java     # Doctor portal
│   │   │   │   │   └── BillController.java       # Bill creation & confirmation
│   │   │   │   ├── model/
│   │   │   │   │   ├── Patient.java
│   │   │   │   │   ├── Doctor.java
│   │   │   │   │   ├── Admin.java
│   │   │   │   │   ├── Appointment.java
│   │   │   │   │   └── Bill.java
│   │   │   │   ├── service/
│   │   │   │   │   ├── UserService.java          # Patient/Doctor/Admin CRUD
│   │   │   │   │   ├── AppointmentService.java   # Appointment management
│   │   │   │   │   ├── BillService.java          # Bill & prescription
│   │   │   │   │   └── DepartmentService.java    # Department management
│   │   │   │   └── util/
│   │   │   │       ├── EmailService.java         # All email templates
│   │   │   │       ├── PasswordUtil.java         # BCrypt hash/verify
│   │   │   │       └── OtpUtil.java              # 6-digit OTP generator
│   │   ├── resources/
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml                       # DispatcherServlet config
│   │       │   └── spring-mvc.xml                # Spring beans, DataSource, Mail
│   │       ├── *.jsp                             # All JSP pages (40+)
│   │       └── META-INF/
├── hospital_db.sql                               # Database schema
├── demo_data.sql                                 # Sample data for testing
├── pom.xml                                       # Maven dependencies
└── README.md
```

---

## 🗄 Database Schema

9 tables in `hospital_db`:

```
admins          — Admin accounts with OTP support
departments     — Hospital departments (Cardiology, Neurology, etc.)
doctors         — Doctor profiles linked to departments
patients        — Patient profiles
doctor_schedules — Doctor availability by day/time
appointments    — Patient-Doctor appointments with status workflow
prescriptions   — Doctor prescriptions linked to appointments
bills           — Payment bills with auto-calculated total
feedback        — Contact/feedback messages
```

### Appointment Status Flow
```
pending → approved → completed
       → rejected
       → cancelled (by patient)
```

### Bill Status Flow
```
pending → confirmed (admin confirms + sends email to patient)
```

---

## ⚙️ Setup & Installation

### Prerequisites
- Java 17+
- Apache Tomcat 11
- XAMPP (MySQL + phpMyAdmin)
- Eclipse IDE (with Maven & Tomcat plugin)
- Git

### Step 1 — Clone the repository
```bash
git clone https://github.com/mohinpathan/HospitalManagement.git
cd HospitalManagement
```

### Step 2 — Start XAMPP MySQL
Open XAMPP Control Panel → Start **MySQL**

### Step 3 — Create the database
Open `http://localhost/phpmyadmin`

1. Click **New** → name it `hospital_db` → Create
2. Click **Import** → choose `hospital_db.sql` → Go
3. Click **Import** again → choose `demo_data.sql` → Go

### Step 4 — Configure email (Gmail SMTP)
Open `src/main/webapp/WEB-INF/spring-mvc.xml` and update:

```xml
<property name="username" value="YOUR_GMAIL@gmail.com" />
<property name="password" value="YOUR_APP_PASSWORD" />
```

> **Get App Password:** Google Account → Security → 2-Step Verification → App Passwords → Generate

### Step 5 — Import into Eclipse
1. File → Import → Maven → Existing Maven Projects
2. Browse to project folder → Finish
3. Right-click project → Maven → Update Project (Alt+F5) → Force Update → OK

### Step 6 — Run on Tomcat
1. Right-click project → Run As → Run on Server
2. Select Apache Tomcat v11.0 → Finish

### Step 7 — Open in browser
```
http://localhost:8080/HospitalManagement/home.jsp
```

---

## 🔑 Demo Credentials

| Role | Email | Password |
|---|---|---|
| 🛡️ Admin | admin@hms.com | admin123 |
| 👨‍⚕️ Doctor | sarah@hms.com | admin123 |
| 👨‍⚕️ Doctor | michael@hms.com | admin123 |
| 🧑 Patient | john@hms.com | admin123 |
| 🧑 Patient | emma@hms.com | admin123 |

---

## 🌐 API / URL Reference

### Public Routes
| Method | URL | Description |
|---|---|---|
| GET | `/home.jsp` | Landing page |
| GET | `/login.jsp` | Login page |
| POST | `/login` | Process login |
| GET | `/register.jsp` | Register page |
| POST | `/register` | Process registration |
| GET | `/logout` | Logout & clear session |
| POST | `/forgotPassword` | Send OTP to email |
| POST | `/verifyOtp` | Verify OTP |
| POST | `/resetPassword` | Reset password |

### Patient Routes (`/patient/*`)
| Method | URL | Description |
|---|---|---|
| GET | `/patient/dashboard` | Patient dashboard |
| GET | `/patient/findDoctors` | Find & filter doctors |
| GET | `/patient/bookAppointment` | Booking form |
| POST | `/patient/bookAppointment` | Submit booking |
| GET | `/patient/appointments` | My appointments |
| GET | `/patient/cancelAppointment?id=` | Cancel appointment |
| GET | `/patient/medicalRecords` | Prescriptions & bills |
| GET | `/patient/profile` | View profile |
| POST | `/patient/updateProfile` | Update profile |
| POST | `/patient/changePassword` | Change password |

### Doctor Routes (`/doctor/*`)
| Method | URL | Description |
|---|---|---|
| GET | `/doctor/dashboard` | Doctor dashboard |
| GET | `/doctor/appointments` | My appointments |
| GET | `/doctor/prescription/{id}` | Write prescription form |
| POST | `/createBill` | Save prescription + bill |
| GET | `/doctor/profile` | View profile |
| POST | `/doctor/updateProfile` | Update profile |
| POST | `/doctor/changePassword` | Change password |

### Admin Routes (`/admin/*`)
| Method | URL | Description |
|---|---|---|
| GET | `/admin/dashboard` | Admin dashboard |
| GET | `/admin/doctors` | List all doctors |
| GET | `/admin/doctors/add` | Add doctor form |
| POST | `/admin/doctors/add` | Save new doctor |
| GET | `/admin/doctors/edit?id=` | Edit doctor form |
| POST | `/admin/doctors/edit` | Update doctor |
| GET | `/admin/doctors/delete?id=` | Delete doctor |
| GET | `/admin/patients` | List all patients |
| GET | `/admin/patients/view?id=` | View patient details |
| GET | `/admin/patients/delete?id=` | Delete patient |
| GET | `/admin/appointments` | List all appointments |
| POST | `/admin/appointments/status` | Approve / Reject |
| GET | `/admin/appointments/delete?id=` | Delete appointment |
| GET | `/admin/departments` | List departments |
| POST | `/admin/departments/add` | Add department |
| GET | `/admin/departments/delete?id=` | Delete department |
| GET | `/admin/bills` | List all bills |
| POST | `/admin/confirmBill` | Confirm bill + email receipt |
| GET | `/admin/profile` | Admin profile |
| POST | `/admin/updateProfile` | Update admin profile |
| POST | `/admin/changePassword` | Change admin password |

---

## 📧 Email Notifications

All emails are sent via Gmail SMTP with beautiful HTML templates.

| Trigger | Email Sent |
|---|---|
| User registers | Welcome email with account details and login button |
| User logs in | Login alert with timestamp and security warning |
| Forgot password | OTP email with styled 6-digit code and instructions |
| Password reset | Success confirmation with timestamp |
| Admin confirms bill | Bill receipt + prescription details to patient |

---

## 🔒 Security Features

- **BCrypt** password hashing (cost factor 10)
- **Session-based** role authentication
- **OTP expiry** — 10 minutes, stored in DB
- **Soft delete** — doctors and patients are marked `inactive`, not removed
- **Input validation** — required fields, min length, email format
- **SQL injection prevention** — Spring JdbcTemplate parameterized queries

---

## 📦 Dependencies

```xml
Spring MVC          6.1.6
Spring JDBC         6.1.6
Spring Context      6.1.6
MySQL Connector     9.0.0
BCrypt (jbcrypt)    0.4
JavaMail            2.0.1
Bootstrap           5.3.2  (CDN)
Font Awesome        6.5.0  (CDN)
Jakarta Servlet     6.0.0
JSTL                3.0.1
```

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 👨‍💻 Author

**Mohin Pathan**
- GitHub: [@mohinpathan](https://github.com/mohinpathan)
- Email: mohinkhan1118@gmail.com

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

> Built with ❤️ using Spring MVC + JSP + MySQL
