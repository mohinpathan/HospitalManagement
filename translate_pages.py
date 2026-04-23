import os

path = 'src/main/webapp'

# Simple text replacements — English → bilingual L() calls
# Format: (old_exact_text, new_text)
replacements = [
    # Common labels
    ('Total Doctors', '<%=L(hi,"कुल डॉक्टर","Total Doctors")%>'),
    ('Total Patients', '<%=L(hi,"कुल मरीज़","Total Patients")%>'),
    ('Total Appointments', '<%=L(hi,"कुल अपॉइंटमेंट","Total Appointments")%>'),
    ('Total Revenue', '<%=L(hi,"कुल राजस्व","Total Revenue")%>'),
    ('Departments', '<%=L(hi,"विभाग","Departments")%>'),
    ('Appointments', '<%=L(hi,"अपॉइंटमेंट","Appointments")%>'),
    ('Dashboard', '<%=L(hi,"डैशबोर्ड","Dashboard")%>'),
    ('My Profile', '<%=L(hi,"मेरी प्रोफ़ाइल","My Profile")%>'),
    ('Change Password', '<%=L(hi,"पासवर्ड बदलें","Change Password")%>'),
    ('Save Changes', '<%=L(hi,"बदलाव सहेजें","Save Changes")%>'),
    ('Update Password', '<%=L(hi,"पासवर्ड अपडेट करें","Update Password")%>'),
    ('Current Password', '<%=L(hi,"वर्तमान पासवर्ड","Current Password")%>'),
    ('New Password', '<%=L(hi,"नया पासवर्ड","New Password")%>'),
    ('Confirm New Password', '<%=L(hi,"नए पासवर्ड की पुष्टि करें","Confirm New Password")%>'),
    ('Full Name', '<%=L(hi,"पूरा नाम","Full Name")%>'),
    ('Email Address', '<%=L(hi,"ईमेल पता","Email Address")%>'),
    ('Phone', '<%=L(hi,"फ़ोन","Phone")%>'),
    ('Address', '<%=L(hi,"पता","Address")%>'),
    ('Blood Group', '<%=L(hi,"रक्त समूह","Blood Group")%>'),
    ('Gender', '<%=L(hi,"लिंग","Gender")%>'),
    ('Age', '<%=L(hi,"आयु","Age")%>'),
    ('Status', '<%=L(hi,"स्थिति","Status")%>'),
    ('Actions', '<%=L(hi,"कार्रवाई","Actions")%>'),
    ('No appointments found', '<%=L(hi,"कोई अपॉइंटमेंट नहीं मिला","No appointments found")%>'),
    ('No doctors found', '<%=L(hi,"कोई डॉक्टर नहीं मिला","No doctors found")%>'),
    ('No patients found', '<%=L(hi,"कोई मरीज़ नहीं मिला","No patients found")%>'),
    ('No bills found', '<%=L(hi,"कोई बिल नहीं मिला","No bills found")%>'),
    ('View All', '<%=L(hi,"सभी देखें","View All")%>'),
    ('Back to', '<%=L(hi,"वापस","Back to")%>'),
    ('Add Doctor', '<%=L(hi,"डॉक्टर जोड़ें","Add Doctor")%>'),
    ('Manage Doctors', '<%=L(hi,"डॉक्टर प्रबंधन","Manage Doctors")%>'),
    ('Manage Patients', '<%=L(hi,"मरीज़ प्रबंधन","Manage Patients")%>'),
    ('Manage Appointments', '<%=L(hi,"अपॉइंटमेंट प्रबंधन","Manage Appointments")%>'),
    ('Bills & Payments', '<%=L(hi,"बिल और भुगतान","Bills & Payments")%>'),
    ('Reports & Analytics', '<%=L(hi,"रिपोर्ट और विश्लेषण","Reports & Analytics")%>'),
    ('Feedback & Messages', '<%=L(hi,"फ़ीडबैक और संदेश","Feedback & Messages")%>'),
    ('Write Prescription', '<%=L(hi,"पर्चा लिखें","Write Prescription")%>'),
    ('My Appointments', '<%=L(hi,"मेरे अपॉइंटमेंट","My Appointments")%>'),
    ('My Patients', '<%=L(hi,"मेरे मरीज़","My Patients")%>'),
    ('My Schedule', '<%=L(hi,"मेरा शेड्यूल","My Schedule")%>'),
    ('Find a Doctor', '<%=L(hi,"डॉक्टर खोजें","Find a Doctor")%>'),
    ('Book Appointment', '<%=L(hi,"अपॉइंटमेंट बुक करें","Book Appointment")%>'),
    ('Medical Records', '<%=L(hi,"चिकित्सा रिकॉर्ड","Medical Records")%>'),
    ('Pay Online', '<%=L(hi,"ऑनलाइन भुगतान करें","Pay Online")%>'),
    ('Download PDF', '<%=L(hi,"PDF डाउनलोड करें","Download PDF")%>'),
    ('Payment Complete', '<%=L(hi,"भुगतान पूर्ण","Payment Complete")%>'),
    ('Confirm & Email', '<%=L(hi,"पुष्टि करें और ईमेल करें","Confirm & Email")%>'),
    ('Profile Information', '<%=L(hi,"प्रोफ़ाइल जानकारी","Profile Information")%>'),
    ('Personal Information', '<%=L(hi,"व्यक्तिगत जानकारी","Personal Information")%>'),
    ('Professional Information', '<%=L(hi,"पेशेवर जानकारी","Professional Information")%>'),
    ('Account Info', '<%=L(hi,"खाता जानकारी","Account Info")%>'),
    ('Professional Details', '<%=L(hi,"पेशेवर विवरण","Professional Details")%>'),
    ('Uploaded Reports', '<%=L(hi,"अपलोड की गई रिपोर्ट","Uploaded Reports")%>'),
    ('Appointment History', '<%=L(hi,"अपॉइंटमेंट इतिहास","Appointment History")%>'),
    ('Billing History', '<%=L(hi,"बिलिंग इतिहास","Billing History")%>'),
    ('My Notes', '<%=L(hi,"मेरे नोट्स","My Notes")%>'),
    ('Add Private Note', '<%=L(hi,"निजी नोट जोड़ें","Add Private Note")%>'),
    ('Upload Report / X-Ray', '<%=L(hi,"रिपोर्ट / X-Ray अपलोड करें","Upload Report / X-Ray")%>'),
    ('Recent Appointments', '<%=L(hi,"हाल के अपॉइंटमेंट","Recent Appointments")%>'),
    ('Recent Prescriptions', '<%=L(hi,"हाल के पर्चे","Recent Prescriptions")%>'),
    ('Recent Patients', '<%=L(hi,"हाल के मरीज़","Recent Patients")%>'),
    ('Recent Doctors', '<%=L(hi,"हाल के डॉक्टर","Recent Doctors")%>'),
    ('Top Rated Doctors', '<%=L(hi,"शीर्ष रेटेड डॉक्टर","Top Rated Doctors")%>'),
    ('Pending Appointments', '<%=L(hi,"लंबित अपॉइंटमेंट","Pending Appointments")%>'),
    ('Departments Overview', '<%=L(hi,"विभाग अवलोकन","Departments Overview")%>'),
    ('Today\'s Appointments', '<%=L(hi,"आज के अपॉइंटमेंट","Today\'s Appointments")%>'),
    ('Monthly Revenue', '<%=L(hi,"मासिक राजस्व","Monthly Revenue")%>'),
    ('Appointment Trend', '<%=L(hi,"अपॉइंटमेंट ट्रेंड","Appointment Trend")%>'),
    ('Appointments by Dept', '<%=L(hi,"विभाग अनुसार अपॉइंटमेंट","Appointments by Dept")%>'),
    ('Approve', '<%=L(hi,"स्वीकृत करें","Approve")%>'),
    ('Reject', '<%=L(hi,"अस्वीकार करें","Reject")%>'),
    ('Delete', '<%=L(hi,"हटाएं","Delete")%>'),
    ('Edit', '<%=L(hi,"संपादित करें","Edit")%>'),
    ('View', '<%=L(hi,"देखें","View")%>'),
    ('Cancel', '<%=L(hi,"रद्द करें","Cancel")%>'),
    ('Save', '<%=L(hi,"सहेजें","Save")%>'),
    ('Submit', '<%=L(hi,"जमा करें","Submit")%>'),
    ('Search', '<%=L(hi,"खोजें","Search")%>'),
    ('Filter', '<%=L(hi,"फ़िल्टर","Filter")%>'),
    ('Sort By', '<%=L(hi,"क्रमबद्ध करें","Sort By")%>'),
    ('Department', '<%=L(hi,"विभाग","Department")%>'),
    ('Doctor', '<%=L(hi,"डॉक्टर","Doctor")%>'),
    ('Patient', '<%=L(hi,"मरीज़","Patient")%>'),
    ('Diagnosis', '<%=L(hi,"निदान","Diagnosis")%>'),
    ('Medicines', '<%=L(hi,"दवाइयां","Medicines")%>'),
    ('Instructions', '<%=L(hi,"निर्देश","Instructions")%>'),
    ('Follow-up Date', '<%=L(hi,"फॉलो-अप तारीख","Follow-up Date")%>'),
    ('Consultation Fee', '<%=L(hi,"परामर्श शुल्क","Consultation Fee")%>'),
    ('Medicine Charge', '<%=L(hi,"दवा शुल्क","Medicine Charge")%>'),
    ('Other Charges', '<%=L(hi,"अन्य शुल्क","Other Charges")%>'),
    ('Total Amount', '<%=L(hi,"कुल राशि","Total Amount")%>'),
    ('Payment Method', '<%=L(hi,"भुगतान विधि","Payment Method")%>'),
    ('Receipt Sent', '<%=L(hi,"रसीद भेजी गई","Receipt Sent")%>'),
    ('years experience', '<%=L(hi,"वर्ष अनुभव","years experience")%>'),
    ('/ consultation', '<%=L(hi,"/ परामर्श","/ consultation")%>'),
    ('No records yet', '<%=L(hi,"अभी तक कोई रिकॉर्ड नहीं","No records yet")%>'),
    ('No schedule set yet', '<%=L(hi,"अभी तक कोई शेड्यूल नहीं","No schedule set yet")%>'),
    ('Add Availability', '<%=L(hi,"उपलब्धता जोड़ें","Add Availability")%>'),
    ('Day of Week', '<%=L(hi,"सप्ताह का दिन","Day of Week")%>'),
    ('Start Time', '<%=L(hi,"शुरुआत का समय","Start Time")%>'),
    ('End Time', '<%=L(hi,"समाप्ति का समय","End Time")%>'),
    ('Current Schedule', '<%=L(hi,"वर्तमान शेड्यूल","Current Schedule")%>'),
    ('Notifications', '<%=L(hi,"सूचनाएं","Notifications")%>'),
    ('No notifications', '<%=L(hi,"कोई सूचना नहीं","No notifications")%>'),
    ('You\'re all caught up!', '<%=L(hi,"सब कुछ अपडेट है!","You\'re all caught up!")%>'),
    ('Select Payment Method', '<%=L(hi,"भुगतान विधि चुनें","Select Payment Method")%>'),
    ('Pay Securely', '<%=L(hi,"सुरक्षित भुगतान करें","Pay Securely")%>'),
    ('256-bit SSL encrypted', '<%=L(hi,"256-बिट SSL एन्क्रिप्टेड","256-bit SSL encrypted")%>'),
    ('Cardholder Name', '<%=L(hi,"कार्डधारक का नाम","Cardholder Name")%>'),
    ('Card Number', '<%=L(hi,"कार्ड नंबर","Card Number")%>'),
    ('Expiry', '<%=L(hi,"समाप्ति","Expiry")%>'),
    ('UPI ID', '<%=L(hi,"UPI ID","UPI ID")%>'),
    ('Net Banking', '<%=L(hi,"नेट बैंकिंग","Net Banking")%>'),
    ('Wallet', '<%=L(hi,"वॉलेट","Wallet")%>'),
    ('Credit/Debit Card', '<%=L(hi,"क्रेडिट/डेबिट कार्ड","Credit/Debit Card")%>'),
]

# Files to skip (already fully translated or component files)
skip = ['langswitcher.jsp', 'footer.jsp', 'header.jsp', 'adminheader.jsp',
        'patientheader.jsp', 'doctorheader.jsp', 'adminsidebar.jsp',
        'patientsidebar.jsp', 'doctorsidebar.jsp', 'login.jsp', 'home.jsp',
        'register.jsp', 'forgetpass.jsp', 'verifyOtp.jsp', 'resetPassword.jsp',
        'bookAppointment.jsp', 'patientAppointments.jsp']

total_changes = 0
for f in os.listdir(path):
    if not f.endswith('.jsp') or f in skip:
        continue
    fp = os.path.join(path, f)
    with open(fp, 'r', encoding='utf-8') as fh:
        c = fh.read()
    orig = c
    for old, new in replacements:
        # Only replace if not already wrapped in L()
        if old in c and 'L(hi' not in c[max(0,c.find(old)-10):c.find(old)+len(old)+10]:
            c = c.replace(old, new)
    if c != orig:
        with open(fp, 'w', encoding='utf-8') as fh:
            fh.write(c)
        total_changes += 1
        print(f'Translated: {f}')

print(f'\nTotal files updated: {total_changes}')
