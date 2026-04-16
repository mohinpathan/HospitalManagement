# 🏥 HealthCare Connect — Hospital Management System

<div align="center">

![Java](https://img.shields.io/badge/Java-17-orange?style=flat-square&logo=java)
![Spring MVC](https://img.shields.io/badge/Spring%20MVC-6.1.6-green?style=flat-square&logo=spring)
![MySQL](https://img.shields.io/badge/MySQL-9.0-blue?style=flat-square&logo=mysql)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3.2-purple?style=flat-square&logo=bootstrap)
![Tomcat](https://img.shields.io/badge/Tomcat-11-yellow?style=flat-square&logo=apachetomcat)
![Maven](https://img.shields.io/badge/Maven-3-red?style=flat-square&logo=apachemaven)

A full-stack **Hospital Management System** built with **Spring MVC 6**, **JSP**, **MySQL (XAMPP)**, and **Bootstrap 5**.  
Supports three user roles — **Patient**, **Doctor**, and **Admin** — each with a dedicated portal, dashboard, and complete feature set.

</div>

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Setup & Installation](#-setup--installation)
- [Demo Credentials](#-demo-credentials)
- [URL Reference](#-url-reference)
- [Email Notifications](#-email-notifications)
- [Security](#-security)
- [Dependencies](#-dependencies)
- [Contributing](#-contributing)

---

## ✨ Features

### 🧑 Patient Portal

| Feature | Description |
|---|---|
| Register / Login | Role-based registration with BCrypt hashing + Remember Me (30 days) |
| Dashboard | Welcome banner with health chips, next appointment highlight, stats, quick actions |
| Find Doctors | Search by name, filter by department, max fee, sort by fee/experience — card grid |
| Book Appointment | Select doctor (pre-selects from Find Doctors), date, time, reason |
| My Appointments | Full list with status badges, cancel pending/approved appointments |
| Medical Records | Prescription cards with diagnosis, medicines, bill breakdown |
| My Profile | Edit personal info, change password, profile photo upload |
| Notifications | In-app bell icon with unread count, notification history page |

### 👨‍⚕️ Doctor Portal

| Feature | Description |
|---|---|
| Dashboard | Welcome banner with rating, earnings, unique patients, today's appointments panel |
| Appointments | Full list with "Write Prescription" button for approved appointments |
| Write Prescription | Diagnosis, medicines, instructions, follow-up date + bill generation |
| My Schedule | Set available days/times; patients see only available slots |
| My Profile | Edit contact info, change password, profile photo upload |
| Notifications | Alerts for new bookings, reviews received |

### 🛡️ Admin Portal

| Feature | Description |
|---|---|
| Dashboard | Revenue stats, today's count, pending approvals, recent registrations, top doctors |
| Manage Doctors | Add, edit, delete doctors with full details |
| Manage Patients | View all patients, view details, soft delete |
| Manage Appointments | Approve, reject, delete with status workflow |
| Manage Departments | Add, delete departments with doctor count cards |
| Bills & Payments | Confirm bills, send receipt + prescription PDF email to patient |
| Reports & Analytics | Monthly revenue chart, appointment trend, dept breakdown (Chart.js), top rated doctors |
| Feedback | View and delete all contact/feedback messages with unread badge |
| Admin Profile | Edit profile, change password |

### 🔐 Authentication & Security

| Feature | Description |
|---|---|
| BCrypt Hashing | All passwords hashed with cost factor 10 |
| Session Management | 8-hour session timeout, role-based access control |
| Remember Me | 30-day HttpOnly cookie, auto-fills login form |
| Forgot Password | 6-digit OTP via email (10-minute expiry, countdown timer) |
| Password Reset | Strength indicator, confirm match checker, session-based flow |
| Auto-redirect | Already logged-in users skip login page |

### 📧 Email Notifications

| Trigger | Email |
|---|---|
| Registration | Welcome email with account details and login button |
| Forgot Password | Styled OTP email with 6-digit code |
| Password Reset | Success confirmation with timestamp |
| Bill Confirmed | Receipt + prescription details to patient |
| Appointment Reminder | Sent daily at 8 AM for next-day appointments (scheduled task) |

### 🆕 Advanced Features

| Feature | Description |
|---|---|
| PDF Bill Download | iText-generated PDF receipt downloadable by patient and admin |
| Doctor Reviews | Patients rate doctors (1–5 stars) after completed appointments |
| Profile Photo Upload | Image upload stored on server, shown in profile |
| Notification System | In-app notifications stored in DB, bell icon with live count polling |
| Doctor Schedule | Doctors set available days/times; AJAX slot checker for booking |
| Admin Reports | Chart.js charts: revenue bar, appointment trend line, dept doughnut |
| Feedback System | Public contact form + patient feedback, admin inbox view |
| Appointment Reminders | Spring `@Scheduled` task sends email reminders 24h before |

---

## 🛠 Tech Stack

| Layer | Technology | Version |
|---|---|---|
| Backend Framework | Spring MVC | 6.1.6 |
| View Layer | JSP (JavaServer Pages) | — |
| Database | MySQL via XAMPP | 9.0 |
| DB Access | Spring JdbcTemplate | 6.1.6 |
| Security | BCrypt (jbcrypt) | 0.4 |
| Email | JavaMail via Gmail SMTP | 2.0.1 |
| PDF Generation | iText PDF | 5.5.13.3 |
| Charts | Chart.js | 4.4.0 (CDN) |
| File Upload | Commons FileUpload | 1.5 |
| Frontend | Bootstrap 5.3.2 + Font Awesome 6.5 | CDN |
| Build Tool | Maven | 3 |
| Server | Apache Tomcat | 11 |
| Java Version | Java | 17 |

---

## 📁 Project Structure

```
HospitalManagement/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── com/hospital/
│   │   │   │   ├── controller/              # 11 Spring MVC Controllers
│   │   │   │   │   ├── AuthController.java       # Login, Register, OTP, Reset
│   │   │   │   │   ├── AdminController.java      # Admin CRUD + Reports
│   │   │   │   │   ├── PatientController.java    # Patient portal
│   │   │   │   │   ├── DoctorController.java     # Doctor portal
│   │   │   │   │   ├── BillController.java       # Bill creation & confirmation
│   │   │   │   │   ├── FeedbackController.java   # Contact form + admin inbox
│   │   │   │   │   ├── NotificationController.java # Bell icon + AJAX count
│   │   │   │   │   ├── PdfController.java        # PDF bill download
│   │   │   │   │   ├── ReviewController.java     # Doctor star ratings
│   │   │   │   │   ├── ScheduleController.java   # Doctor availability + AJAX slots
│   │   │   │   │   └── UploadController.java     # Profile photo upload
│   │   │   │   ├── model/                   # 5 Model classes
│   │   │   │   │   ├── Patient.java
│   │   │   │   │   ├── Doctor.java
│   │   │   │   │   ├── Admin.java
│   │   │   │   │   ├── Appointment.java
│   │   │   │   │   └── Bill.java
│   │   │   │   ├── service/                 # 9 Service classes
│   │   │   │   │   ├── UserService.java          # Patient/Doctor/Admin CRUD
│   │   │   │   │   ├── AppointmentService.java   # Appointment management
│   │   │   │   │   ├── BillService.java          # Bill, prescription, revenue
│   │   │   │   │   ├── DepartmentService.java    # Department management
│   │   │   │   │   ├── NotificationService.java  # In-app notifications
│   │   │   │   │   ├── ReviewService.java        # Doctor ratings & reviews
│   │   │   │   │   ├── ScheduleService.java      # Doctor schedule management
│   │   │   │   │   ├── PdfService.java           # iText PDF generation
│   │   │   │   │   └── ReminderScheduler.java    # @Scheduled email reminders
│   │   │   │   └── util/                    # 4 Utility classes
│   │   │   │       ├── EmailService.java         # All HTML email templates
│   │   │   │       ├── PasswordUtil.java         # BCrypt hash/verify
│   │   │   │       └── OtpUtil.java              # 6-digit OTP generator
│   │   ├── resources/
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml                  # DispatcherServlet config
│   │       │   └── spring-mvc.xml           # Beans, DataSource, Mail, Scheduler
│   │       ├── Public Pages (7)
│   │       │   ├── home.jsp, about.jsp, contact.jsp
│   │       │   ├── login.jsp, register.jsp
│   │       │   ├── forgetpass.jsp, verifyOtp.jsp, resetPassword.jsp
│   │       ├── Patient Pages (10)
│   │       │   ├── patientDashboard.jsp, patientAppointments.jsp
│   │       │   ├── bookAppointment.jsp, findDoctors.jsp
│   │       │   ├── medicalRecords.jsp, patientProfile.jsp
│   │       │   ├── patientheader.jsp, patientsidebar.jsp
│   │       │   ├── patientabout.jsp, patientcontact.jsp
│   │       ├── Doctor Pages (9)
│   │       │   ├── doctorDashboard.jsp, doctorAppointments.jsp
│   │       │   ├── doctorProfile.jsp, writePrescription.jsp
│   │       │   ├── docmyschedule.jsp, docschedule.jsp
│   │       │   ├── doctorheader.jsp, doctorsidebar.jsp
│   │       │   ├── doctorabout.jsp, doctorcontact.jsp
│   │       ├── Admin Pages (14)
│   │       │   ├── adminDashboard.jsp, adminreports.jsp
│   │       │   ├── managedoctor.jsp, adddoctor.jsp, editdoctor.jsp
│   │       │   ├── managepatients.jsp, viewpatient.jsp
│   │       │   ├── manageappointment.jsp, managedepartment.jsp
│   │       │   ├── managebills.jsp, adminfeedback.jsp
│   │       │   ├── adminprofile.jsp, adminheader.jsp, adminsidebar.jsp
│   │       └── Shared (3)
│   │           ├── notifications.jsp, header.jsp, footer.jsp
├── hospital_db.sql                          # Core database schema
├── demo_data.sql                            # Sample data for testing
├── features_db.sql                          # New feature tables (notifications, reviews)
├── pom.xml                                  # Maven dependencies
└── README.md
```

---

## 🗄 Database Schema

### Core Tables (`hospital_db.sql`)

| Table | Description |
|---|---|
| `admins` | Admin accounts with OTP support |
| `departments` | Hospital departments (Cardiology, Neurology, etc.) |
| `doctors` | Doctor profiles linked to departments |
| `patients` | Patient profiles |
| `doctor_schedules` | Doctor availability by day/time |
| `appointments` | Patient-Doctor appointments with status workflow |
| `prescriptions` | Doctor prescriptions linked to appointments |
| `bills` | Payment bills with auto-calculated total |
| `feedback` | Contact/feedback messages |

### Feature Tables (`features_db.sql`)

| Table | Description |
|---|---|
| `notifications` | In-app notifications per user/role |
| `reviews` | Patient star ratings for doctors |
| `photo` column | Added to patients, doctors, admins |
| `lang` column | Language preference (en/hi) |

### Appointment Status Flow
```
pending ──► approved ──► completed
        └──► rejected
patient ──► cancelled
```

### Bill Status Flow
```
pending ──► confirmed (admin confirms + emails receipt PDF to patient)
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

```
1. Click New → name it hospital_db → Create
2. Import tab → choose hospital_db.sql → Go
3. Import tab → choose demo_data.sql → Go
4. Import tab → choose features_db.sql → Go
```

### Step 4 — Configure Gmail SMTP
Open `src/main/webapp/WEB-INF/spring-mvc.xml` and update:

```xml
<property name="username" value="YOUR_GMAIL@gmail.com" />
<property name="password" value="YOUR_APP_PASSWORD" />
```

> **Get App Password:** Google Account → Security → 2-Step Verification → App Passwords → Generate

### Step 5 — Import into Eclipse
```
1. File → Import → Maven → Existing Maven Projects
2. Browse to project folder → Finish
3. Right-click project → Maven → Update Project (Alt+F5)
4. Check "Force Update of Snapshots/Releases" → OK
```

### Step 6 — Run on Tomcat
```
1. Right-click project → Run As → Run on Server
2. Select Apache Tomcat v11.0 → Finish
```

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
| 👨‍⚕️ Doctor | emily@hms.com | admin123 |
| 🧑 Patient | john@hms.com | admin123 |
| 🧑 Patient | emma@hms.com | admin123 |
| 🧑 Patient | raj@hms.com | admin123 |

---

## 🌐 URL Reference

### Public Routes
| Method | URL | Description |
|---|---|---|
| GET | `/home.jsp` | Landing page |
| GET | `/login.jsp` | Login page |
| POST | `/login` | Process login (+ Remember Me cookie) |
| GET | `/register.jsp` | Register page |
| POST | `/register` | Process registration (sends welcome email) |
| GET | `/logout` | Logout + clear cookies |
| GET | `/autoLogin` | Auto-login from Remember Me cookie |
| POST | `/forgotPassword` | Send OTP to email |
| POST | `/verifyOtp` | Verify OTP (session-based) |
| POST | `/resetPassword` | Reset password (sends success email) |

### Patient Routes (`/patient/*`)
| Method | URL | Description |
|---|---|---|
| GET | `/patient/dashboard` | Dashboard with stats, next appt, quick actions |
| GET | `/patient/findDoctors` | Search/filter doctors by name, dept, fee, sort |
| GET | `/patient/bookAppointment` | Booking form (pre-selects doctor) |
| POST | `/patient/bookAppointment` | Submit booking |
| GET | `/patient/appointments` | My appointments list |
| GET | `/patient/cancelAppointment?id=` | Cancel appointment |
| GET | `/patient/medicalRecords` | Prescriptions & bills |
| GET | `/patient/bill/pdf/{billId}` | Download bill as PDF |
| GET | `/patient/profile` | View profile |
| POST | `/patient/updateProfile` | Update profile |
| POST | `/patient/changePassword` | Change password |
| POST | `/patient/review/submit` | Submit doctor review |
| POST | `/patient/feedback/submit` | Submit feedback |

### Doctor Routes (`/doctor/*`)
| Method | URL | Description |
|---|---|---|
| GET | `/doctor/dashboard` | Dashboard with today's panel, earnings, rating |
| GET | `/doctor/appointments` | My appointments |
| GET | `/doctor/prescription/{id}` | Write prescription form |
| POST | `/createBill` | Save prescription + generate bill |
| GET | `/doctor/schedule` | View/manage schedule |
| POST | `/doctor/schedule/save` | Add availability slot |
| GET | `/doctor/schedule/delete/{id}` | Remove slot |
| GET | `/doctor/schedule/slots` | AJAX: get available slots for a date |
| GET | `/doctor/profile` | View profile |
| POST | `/doctor/updateProfile` | Update profile |
| POST | `/doctor/changePassword` | Change password |

### Admin Routes (`/admin/*`)
| Method | URL | Description |
|---|---|---|
| GET | `/admin/dashboard` | Dashboard with revenue, recent registrations, top doctors |
| GET | `/admin/doctors` | List all doctors |
| GET | `/admin/doctors/add` | Add doctor form |
| POST | `/admin/doctors/add` | Save new doctor |
| GET | `/admin/doctors/edit?id=` | Edit doctor form |
| POST | `/admin/doctors/edit` | Update doctor |
| GET | `/admin/doctors/delete?id=` | Soft delete doctor |
| GET | `/admin/patients` | List all patients |
| GET | `/admin/patients/view?id=` | View patient details + history |
| GET | `/admin/patients/delete?id=` | Soft delete patient |
| GET | `/admin/appointments` | List all appointments |
| POST | `/admin/appointments/status` | Approve / Reject |
| GET | `/admin/appointments/delete?id=` | Delete appointment |
| GET | `/admin/departments` | List departments |
| POST | `/admin/departments/add` | Add department |
| GET | `/admin/departments/delete?id=` | Delete department |
| GET | `/admin/bills` | List all bills |
| POST | `/admin/confirmBill` | Confirm bill + email PDF receipt |
| GET | `/admin/bill/pdf/{billId}` | Download bill PDF |
| GET | `/admin/reports` | Charts: revenue, trends, dept stats, top doctors |
| GET | `/admin/feedback` | View all feedback messages |
| GET | `/admin/feedback/delete/{id}` | Delete feedback |
| GET | `/admin/profile` | Admin profile |
| POST | `/admin/updateProfile` | Update admin profile |
| POST | `/admin/changePassword` | Change admin password |

### Shared Routes
| Method | URL | Description |
|---|---|---|
| GET | `/notifications` | View all notifications (marks as read) |
| GET | `/notifications/count` | AJAX: get unread count |
| GET | `/notifications/markRead/{id}` | Mark single notification read |
| POST | `/upload/photo` | Upload profile photo |
| POST | `/feedback/submit` | Public contact form submit |

---

## 📧 Email Notifications

All emails use beautiful HTML templates with role-specific color themes.

| Trigger | Subject | Color |
|---|---|---|
| Registration | Welcome to HealthCare Connect 🎉 | Role-specific |
| Forgot Password | Password Reset OTP 🔑 | Purple |
| Password Reset | Password Reset Successful ✅ | Green |
| Bill Confirmed | Payment Receipt & Prescription 🧾 | Blue |
| Appointment Reminder | Appointment Reminder for Tomorrow 📅 | Blue |

> Login email notification was intentionally removed to avoid inbox spam.

---

## 🔒 Security

| Feature | Implementation |
|---|---|
| Password Hashing | BCrypt with cost factor 10 |
| Session Auth | Role-based session attributes, 8-hour timeout |
| Remember Me | HttpOnly cookie, 30-day expiry, auto-fill on login |
| OTP Flow | 6-digit OTP stored in DB with 10-minute expiry, session-based verification |
| Soft Delete | Doctors and patients marked `inactive`, not removed from DB |
| SQL Injection | Spring JdbcTemplate parameterized queries throughout |
| File Upload | Content-type validation, 5 MB size limit, UUID filename |
| Access Control | Every controller method checks session role before processing |

---

## 📦 Dependencies

```xml
Spring MVC              6.1.6
Spring JDBC             6.1.6
Spring Context Support  6.1.6   (JavaMailSenderImpl)
MySQL Connector/J       9.0.0
BCrypt (jbcrypt)        0.4
JavaMail                2.0.1
iText PDF               5.5.13.3
Commons FileUpload      1.5
Commons IO              2.15.1
Bootstrap               5.3.2   (CDN)
Font Awesome            6.5.0   (CDN)
Chart.js                4.4.0   (CDN)
Jakarta Servlet API     6.0.0   (provided)
JSTL                    3.0.1
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
- Project: [github.com/mohinpathan/HospitalManagement](https://github.com/mohinpathan/HospitalManagement)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

Built with ❤️ using **Spring MVC + JSP + MySQL**

⭐ Star this repo if you found it helpful!

</div>
