
CREATE DATABASE UniversityDB;

USE UniversityDB;

CREATE TABLE Schools (
    school_id VARCHAR(100) PRIMARY KEY ,
    school_name VARCHAR(100) NOT NULL,
    dean_id VARCHAR(100),
    
);

drop table Schools;


CREATE TABLE Departments (
    department_id VARCHAR(100) PRIMARY KEY ,
    department_name VARCHAR(100) NOT NULL,
    school_id VARCHAR(100) NOT NULL,
    head_of_department_id VARCHAR(100),
    FOREIGN KEY (school_id) REFERENCES Schools(school_id)
);

CREATE TABLE Courses (
    course_id VARCHAR(100) PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    department_id VARCHAR(100)  NOT NULL,
	category VARCHAR(100) NOT NULL,
    duration_years INT,
    total_credits INT,
    tuition_fee DECIMAL(15,2),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);



CREATE TABLE Units (
    unit_id VARCHAR(100) PRIMARY KEY ,
    unit_code VARCHAR(20) UNIQUE NOT NULL,
    unit_name VARCHAR(100) NOT NULL,
    description TEXT,
    credit_hours INT NOT NULL,
     
    prerequisites VARCHAR(255),
  
);
CREATE TABLE Users (
    user_id VARCHAR(100)  PRIMARY KEY ,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Student','Lecturer','NonStaff','Admin')),
    last_login DATETIME,
    is_active BIT DEFAULT 1
   
);


CREATE TABLE Students (
    student_id VARCHAR(100) PRIMARY KEY,
    national_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M','F','O')),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    enrollment_date DATE NOT NULL,
    graduation_date DATE,
    course_id VARCHAR(100) NOT NULL,
	county VARCHAR(50) NOT NULL,
    user_id VARCHAR(100) UNIQUE NOT NULL,

     FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
   
);

CREATE TABLE Branches (
    branch_id VARCHAR(100) PRIMARY KEY ,
    branch_name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
	address TEXT
);

CREATE TABLE Lecturers (
    lecturer_id VARCHAR(100) PRIMARY KEY,
    staff_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    office_number VARCHAR(20),
    department_id VARCHAR(100) NOT NULL,
    user_id VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
	branch_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),

    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


CREATE TABLE LecturerUnits (
    assignment_id INT PRIMARY KEY IDENTITY(1,1),
    lecturer_id VARCHAR(100) NOT NULL,
    unit_id VARCHAR(100) NOT NULL,
    academic_year VARCHAR(100) NOT NULL,
    semester INT NOT NULL,
	course_id VARCHAR(100) NOT NULL,
    teaching_hours INT,
   FOREIGN KEY (course_id) REFERENCES Courses(course_id),

    FOREIGN KEY (lecturer_id) REFERENCES Lecturers(lecturer_id),
    FOREIGN KEY (unit_id) REFERENCES Units(unit_id),
    UNIQUE(lecturer_id, unit_id, academic_year, semester)
);

CREATE TABLE UnitRegistrations (
    registration_id INT PRIMARY KEY IDENTITY(1,1),
    student_id VARCHAR(100) NOT NULL,
    UnitsAwarded NVARCHAR(MAX) NOT NULL,
    academic_year VARCHAR(100) NOT NULL,
	year_of_study int NOT NULL,
    semester INT NOT NULL,
	unit_studied  NVARCHAR(MAX) NOT NULL,
    registration_date DATE DEFAULT GETDATE(),
    promoted BIT DEFAULT 0,
	mode_of_study VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'Enrolled' CHECK (status IN ('Enrolled','Completed','Withdrawn')),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
     
    UNIQUE(student_id,academic_year, semester)
);


 CREATE TABLE Intakes(
  intake_id int PRIMARY KEY IDENTITY(1,1),
 
  course_id VARCHAR(100) NOT NULL,
  year_of_intake int NOT NULL,
  
  units  NVARCHAR(MAX) NOT NULL,
  total_fee DECIMAL(15,2) NOT NULL,
 );
 drop table Intakes
 
 CREATE TABLE UnitsToRegister(
  registration_id INT PRIMARY KEY IDENTITY(1,1),
  intake_id int NOT NULL,
  course_id VARCHAR(100) NOT NULL,
  academic_year VARCHAR(100) NOT NULL,
  year_of_study int NOT NULL,
  semester INT NOT NULL,
  fee DECIMAL(15,2) NOT NULL,
  unit_to_register  NVARCHAR(MAX) NOT NULL,
      FOREIGN KEY (course_id) REFERENCES Courses(course_id),

	  FOREIGN KEY (intake_id) REFERENCES Intakes(intake_id),


 );
 
 CREATE TABLE Fees (
    fee_id varchar(100) PRIMARY KEY ,
    student_id varchar(100) NOT NULL,
   
	paid DECIMAL(15,2) NOT NULL,
    fee_type VARCHAR(50) NOT NULL CHECK (fee_type IN ('Tuition','Hostel','Library','Other')),
    due_date DATE NOT NULL,
    paid_date DATE,
    payment_method VARCHAR(50),
    reference_number VARCHAR(50),
	balance DECIMAL(15,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending','Partial','Paid','Overdue')),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE TABLE NonStaff (
    non_staff_id varchar(100) PRIMARY KEY ,
    employee_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    national_id VARCHAR(20) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M','F','O')),
    
    -- Employment Details
    employment_type VARCHAR(20) NOT NULL 
        CHECK (employment_type IN ('Full-Time', 'Part-Time', 'Contractor')),
    job_title VARCHAR(100) NOT NULL,
    department_id  VARCHAR(100) ,
    manager_id  VARCHAR(100),
    hire_date DATE NOT NULL,
    termination_date DATE,
    
    -- Contact Information
    official_email VARCHAR(100) UNIQUE NOT NULL,
    personal_email VARCHAR(100),
    phone VARCHAR(20),
    emergency_contact VARCHAR(20),
    
    -- Address Information
    physical_address TEXT,
    postal_address TEXT,
    
    -- System Access
    user_id  VARCHAR(100) UNIQUE,
    
    -- Financial Information
     
  
    
    -- Constraints
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES NonStaff(non_staff_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    
    -- Temporal Constraints
    CHECK (termination_date IS NULL OR termination_date > hire_date),
    CHECK (DATEDIFF(YEAR, date_of_birth, hire_date) >= 18)
);

-- Indexes for Common Searches
CREATE INDEX idx_nonstaff_department ON NonStaff(department_id);
CREATE INDEX idx_nonstaff_jobtitle ON NonStaff(job_title);
CREATE INDEX idx_nonstaff_emptype ON NonStaff(employment_type);


CREATE TABLE SalaryPayments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    staff_type VARCHAR(20) NOT NULL CHECK (staff_type IN ('Lecturer','NonStaff')),
    staff_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    payment_date DATE NOT NULL,
    pay_period VARCHAR(50),
    tax_deductions DECIMAL(15,2),
    net_amount DECIMAL(15,2) NOT NULL,
	bank_account_number VARCHAR(30),
    bank_name VARCHAR(50),
    payment_method VARCHAR(50),
    reference_number VARCHAR(50)
);
CREATE TABLE Hostels (
    registration_id INT PRIMARY KEY IDENTITY(1,1),
    hostel_name VARCHAR(100) NOT NULL,
	student_id VARCHAR(100) NOT NULL,
    branch_id  VARCHAR(100)  NOT NULL,
    room_number VARCHAR(100) NOT NULL,
    amenities TEXT,
    rent DECIMAL(15,2),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),
	    FOREIGN KEY (student_id) REFERENCES Students(student_id)

);

CREATE TABLE LibraryBooks (
    book_id INT PRIMARY KEY IDENTITY(1,1),
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publication_year INT,
    genre VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available','Borrowed','Lost')),
    branch_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE BookLoans (
    loan_id INT PRIMARY KEY IDENTITY(1,1),
    book_id INT NOT NULL,
    borrower_id INT NOT NULL,
    borrower_type VARCHAR(20) CHECK (borrower_type IN ('Student','Lecturer','NoStaff')),
    loan_date DATE DEFAULT GETDATE(),
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(15,2) DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES LibraryBooks(book_id)
);


CREATE TABLE StoreInventory (
    item_id INT PRIMARY KEY IDENTITY(1,1),
    item_code VARCHAR(20) UNIQUE NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    quantity INT DEFAULT 0,
    unit_price DECIMAL(15,2) NOT NULL,
    branch_id VARCHAR(100) NOT NULL,
    last_restock DATE,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);


CREATE TABLE AcademicCalendar (
    event_id INT PRIMARY KEY IDENTITY(1,1),
    event_name VARCHAR(100) NOT NULL,
    event_type VARCHAR(50) CHECK (event_type IN ('Holiday','Exam','Registration','Lecture')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    branch_id VARCHAR(100) NOT NULL,
    description TEXT,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE SystemLogs (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    log_timestamp DATETIME DEFAULT GETDATE(),
    user_id  VARCHAR(100),
    action_type VARCHAR(50) NOT NULL,
    description TEXT,
    ip_address VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE LMSMaterials (
    material_id INT PRIMARY KEY IDENTITY(1,1),
    unit_id VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    material_type VARCHAR(50) CHECK (material_type IN ('LectureNote','Video','Assignment','Reading')),
    upload_date DATETIME DEFAULT GETDATE(),
    upload_by  VARCHAR(100) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    download_count INT DEFAULT 0,
    FOREIGN KEY (unit_id) REFERENCES Units(unit_id),
    FOREIGN KEY (upload_by) REFERENCES Users(user_id)
);

-- Example: NonStaff Leave Records
CREATE TABLE NonStaffLeave (
    leave_id INT PRIMARY KEY IDENTITY(1,1),
    non_staff_id VARCHAR(100) NOT NULL,
    leave_type VARCHAR(30) CHECK (leave_type IN ('Annual', 'Sick', 'Maternity', 'Study')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    FOREIGN KEY (non_staff_id) REFERENCES NonStaff(non_staff_id)
);

CREATE TABLE NonStaffLeaveBalance (
    balance_id INT PRIMARY KEY IDENTITY(1,1),
    non_staff_id VARCHAR(100) NOT NULL,
    year INT NOT NULL CHECK (year BETWEEN 2000 AND 2100),
    leave_type VARCHAR(30) NOT NULL CHECK (leave_type IN (
        'Annual', 'Sick', 'Casual', 'Maternity', 
        'Paternity', 'Study', 'Compensatory', 'Other'
    )),
    
    -- Entitlement Details
    entitled_days DECIMAL(5,2) NOT NULL CHECK (entitled_days >= 0),
    carried_forward_days DECIMAL(5,2) DEFAULT 0,
    additional_days DECIMAL(5,2) DEFAULT 0,
    
    -- Usage Tracking
    used_days DECIMAL(5,2) DEFAULT 0,
    pending_days DECIMAL(5,2) DEFAULT 0,
    
    -- Computed Columns
    total_entitlement AS (entitled_days + carried_forward_days + additional_days),
    remaining_days AS (entitled_days + carried_forward_days + additional_days - used_days - pending_days),
    
    -- Constraints
    FOREIGN KEY (non_staff_id) REFERENCES NonStaff(non_staff_id),
    UNIQUE (non_staff_id, year, leave_type),
    
    -- Validation
    CHECK (used_days >= 0 AND pending_days >= 0)
);
-- Example: NonStaff Roles
CREATE TABLE NonStaffRoles (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name VARCHAR(50) NOT NULL CHECK (role_name IN (
        'Administrative', 'Technical', 'Maintenance', 
        'Security', 'Catering', 'Transport'
    )),
    non_staff_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (non_staff_id) REFERENCES NonStaff(non_staff_id)
);

CREATE TABLE LMSCourses (
    course_id varchar(100),
 
    academic_year INT NOT NULL,
    semester INT NOT NULL,
 
    
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
     UNIQUE ( academic_year, semester)
);


CREATE TABLE LecturerLeave (
    leave_id INT PRIMARY KEY IDENTITY(1,1),
    lecturer_id  VARCHAR(100) NOT NULL,
    leave_type VARCHAR(20) NOT NULL 
        CHECK (leave_type IN ('Annual', 'Sick', 'Maternity', 'Study', 'Conference', 'Other')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days AS DATEDIFF(DAY, start_date, end_date) + 1,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'Pending' 
        CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Cancelled')),
    approved_by VARCHAR(100),
    approval_date DATE,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    
    -- Foreign Keys
    FOREIGN KEY (lecturer_id) REFERENCES Lecturers(lecturer_id),
    FOREIGN KEY (approved_by) REFERENCES Users(user_id),
    
    -- Date Validation
    CHECK (end_date >= start_date),
    CHECK (approval_date >= created_at OR approval_date IS NULL)
);

-- Supporting Table for Leave Balance
CREATE TABLE LecturerLeaveBalance (
    balance_id INT PRIMARY KEY IDENTITY(1,1),
    lecturer_id VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    leave_type VARCHAR(20) NOT NULL,
    entitled_days INT NOT NULL,
    used_days INT DEFAULT 0,
    remaining_days AS entitled_days - used_days,
    
    FOREIGN KEY (lecturer_id) REFERENCES Lecturers(lecturer_id),
    UNIQUE (lecturer_id, year, leave_type)
);

-- Indexes
CREATE INDEX idx_leave_lecturer ON LecturerLeave(lecturer_id);
CREATE INDEX idx_leave_dates ON LecturerLeave(start_date, end_date);
CREATE INDEX idx_leave_status ON LecturerLeave(status);

CREATE TABLE Results (
    result_id INT PRIMARY KEY IDENTITY(1,1),
    intake_id int NOT NULL,
    course_id VARCHAR(100) NOT NULL,
    academic_year VARCHAR(100) NOT NULL,
    year_of_study INT NOT NULL CHECK (year_of_study BETWEEN 1 AND 6),
    semester INT NOT NULL CHECK (semester BETWEEN 1 AND 3),
    file_url VARCHAR(500) NOT NULL, -- Cloud storage URL instead of file path
    uploaded_at DATETIME DEFAULT GETDATE(),
    uploaded_by VARCHAR(100) NOT NULL,
    file_hash VARCHAR(64) UNIQUE, -- SHA-256 hash for duplicate detection
    processed_at DATETIME,
    validator_id VARCHAR(100),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (intake_id) REFERENCES Intakes(intake_id),
    FOREIGN KEY (uploaded_by) REFERENCES Users(user_id),
    FOREIGN KEY (validator_id) REFERENCES Users(user_id)
);

-- Table for school expenses
CREATE TABLE SchoolExpenses (
    expense_id INT PRIMARY KEY IDENTITY(1,1),
    expense_type VARCHAR(100) NOT NULL CHECK (expense_type IN ('Tuition', 'Staff Salaries', 'Infrastructure', 'Maintenance', 'Library', 'Other')),
    amount DECIMAL(15,2) NOT NULL,
    description TEXT,
    date_incurred DATE NOT NULL,
    branch_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- Table for school incomes
CREATE TABLE SchoolIncomes (
    income_id INT PRIMARY KEY IDENTITY(1,1),
    income_type VARCHAR(100) NOT NULL CHECK (income_type IN ('Tuition Fees', 'Government Grant', 'Donations', 'Fundraising', 'Other')),
    amount DECIMAL(15,2) NOT NULL,
    description TEXT,
    date_received DATE NOT NULL,
    branch_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE SchoolSupplies (
    supply_id INT PRIMARY KEY IDENTITY(1,1),
    supply_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2),
    total_cost DECIMAL(15,2),
    branch_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);
CREATE TABLE FinancialReports (
    report_id INT PRIMARY KEY IDENTITY(1,1),
    report_type VARCHAR(100) NOT NULL, -- e.g., Monthly, Quarterly, Annual
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_income DECIMAL(15,2) NOT NULL,
    total_expense DECIMAL(15,2) NOT NULL,
    net_balance DECIMAL(15,2) NOT NULL,
    report_date DATE NOT NULL
);
CREATE TABLE Donors (
    donor_id INT PRIMARY KEY IDENTITY(1,1),
    donor_name VARCHAR(255) NOT NULL,
    donation_amount DECIMAL(15,2) NOT NULL,
    donation_date DATE NOT NULL,
    branch_id VARCHAR(100),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE Admissions (
    application_id INT PRIMARY KEY IDENTITY(1,1),
    applicant_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    applied_course VARCHAR(100) NOT NULL,
    application_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('Pending', 'Accepted', 'Rejected')),
    remarks TEXT,
    branch_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE Alumni (
    alumni_id INT PRIMARY KEY IDENTITY(1,1),
    student_id VARCHAR(100) UNIQUE, -- if linked to a student record
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    graduation_year INT NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    current_employer VARCHAR(255),
    current_position VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE TABLE CourseSchedules (
    schedule_id INT PRIMARY KEY IDENTITY(1,1),
    course_id VARCHAR(100) NOT NULL,
    unit_id VARCHAR(100),
    lecturer_id VARCHAR(100),
    day_of_week VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    classroom VARCHAR(50),
    academic_year VARCHAR(50) NOT NULL,
    semester INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (lecturer_id) REFERENCES Lecturers(lecturer_id)
);


CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY IDENTITY(1,1),
    student_id VARCHAR(100) NOT NULL,
    schedule_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Present', 'Absent', 'Excused')),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (schedule_id) REFERENCES CourseSchedules(schedule_id)
);

CREATE TABLE Clubs (
    club_id INT PRIMARY KEY IDENTITY(1,1),
    club_name VARCHAR(100) NOT NULL,
    description TEXT,
    advisor_id VARCHAR(100),  -- Could reference a staff or lecturer
    branch_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE ClubMemberships (
    membership_id INT PRIMARY KEY IDENTITY(1,1),
    club_id INT NOT NULL,
    student_id VARCHAR(100) NOT NULL,
    join_date DATE NOT NULL,
    role VARCHAR(50),  -- e.g., Member, President, Treasurer
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    UNIQUE (club_id, student_id)
);
CREATE TABLE BusRoutes (
    route_id INT PRIMARY KEY IDENTITY(1,1),
    route_name VARCHAR(100) NOT NULL,
    start_point VARCHAR(255) NOT NULL,
    end_point VARCHAR(255) NOT NULL,
    branch_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE StudentBusAssignments (
    assignment_id INT PRIMARY KEY IDENTITY(1,1),
    student_id VARCHAR(100) NOT NULL,
    route_id INT NOT NULL,
    assigned_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (route_id) REFERENCES BusRoutes(route_id),
    UNIQUE (student_id, route_id)
);

CREATE TABLE MaintenanceRequests (
    request_id INT PRIMARY KEY IDENTITY(1,1),
    description TEXT NOT NULL,
    request_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Cancelled')),
    branch_id VARCHAR(100) NOT NULL,
    reported_by VARCHAR(100),  -- Could be a staff or student ID
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);
CREATE TABLE AssetInventory (
    asset_id INT PRIMARY KEY IDENTITY(1,1),
    asset_tag VARCHAR(100) UNIQUE NOT NULL,
    asset_name VARCHAR(100) NOT NULL,
    description TEXT,
    purchase_date DATE,
    purchase_cost DECIMAL(15,2),
    current_value DECIMAL(15,2),
    branch_id VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('Active', 'Under Maintenance', 'Retired')),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE LectureEvaluations (
    evaluation_id INT PRIMARY KEY IDENTITY(1,1),
    
    lecturer_id VARCHAR(100) NOT NULL,
    course_id   VARCHAR(100) NOT NULL,
    unit_id     VARCHAR(100) NULL,  -- Optional: if you want to tie the evaluation to a specific unit
    student_id  VARCHAR(100) NOT NULL,
    
    academic_year VARCHAR(20) NOT NULL,
    semester      INT NOT NULL CHECK (semester BETWEEN 1 AND 3),
    
    -- Rating scale (for example, 1 to 5, where 5 is the best)
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    
    comments TEXT,  -- Optional: for detailed feedback
    evaluation_date DATETIME DEFAULT GETDATE(),
    
    -- Foreign key constraints to ensure data integrity
    FOREIGN KEY (lecturer_id) REFERENCES Lecturers(lecturer_id),
    FOREIGN KEY (course_id)   REFERENCES Courses(course_id),
    FOREIGN KEY (student_id)  REFERENCES Students(student_id)
    
    -- Optionally, you might want to add a foreign key for unit_id if it references another table.
    -- FOREIGN KEY (unit_id) REFERENCES Units(unit_id)
);

CREATE TABLE Scholarships (
    scholarship_id INT PRIMARY KEY IDENTITY(1,1),
    scholarship_name VARCHAR(255) NOT NULL,
    description TEXT,
    amount DECIMAL(15,2) NOT NULL,
    eligibility_criteria TEXT,
    application_deadline DATE,
    awarded_date DATE
);

CREATE TABLE StudentScholarships (
    student_id VARCHAR(100) NOT NULL,
    scholarship_id INT NOT NULL,
    awarded_date DATE NOT NULL,
    PRIMARY KEY (student_id, scholarship_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (scholarship_id) REFERENCES Scholarships(scholarship_id)
);

CREATE TABLE DisciplinaryRecords (
    record_id INT PRIMARY KEY IDENTITY(1,1),
    student_id VARCHAR(100) NOT NULL,
    infraction VARCHAR(255) NOT NULL,
    description TEXT,
    action_taken VARCHAR(255),
    record_date DATE NOT NULL,
    status VARCHAR(50) CHECK (status IN ('Pending', 'Resolved', 'Appealed')),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE TABLE CounselingSessions (
    session_id INT PRIMARY KEY IDENTITY(1,1),
    participant_id VARCHAR(100) NOT NULL,  -- could be a student or staff member
    counselor_id VARCHAR(100) NOT NULL,
    session_date DATETIME NOT NULL,
    session_type VARCHAR(50) CHECK (session_type IN ('Academic', 'Personal', 'Career')),
    notes TEXT,
    outcome TEXT,
    FOREIGN KEY (counselor_id) REFERENCES Users(user_id)  -- assuming counselors are in the Users table
);

CREATE TABLE GraduationRecords (
    graduation_id INT PRIMARY KEY IDENTITY(1,1),
    student_id VARCHAR(100) NOT NULL,
    graduation_date DATE NOT NULL,
    degree_awarded VARCHAR(100) NOT NULL,
    honors VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);


CREATE TABLE ResourceBookings (
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    resource_name VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50) CHECK (resource_type IN ('Classroom', 'Laboratory', 'Auditorium', 'Other')),
    booked_by VARCHAR(100) NOT NULL,
    booking_date DATETIME NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(50) CHECK (status IN ('Pending', 'Confirmed', 'Cancelled')),
    FOREIGN KEY (booked_by) REFERENCES Users(user_id)
);

CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    sender_id VARCHAR(100) NOT NULL,
    target_role VARCHAR(50),  -- e.g., 'Student', 'Lecturer', 'All'
    FOREIGN KEY (sender_id) REFERENCES Users(user_id)
);

CREATE TABLE ResearchProjects (
    project_id INT PRIMARY KEY IDENTITY(1,1),
    project_title VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    funding_amount DECIMAL(15,2),
    principal_investigator VARCHAR(100) NOT NULL,
    FOREIGN KEY (principal_investigator) REFERENCES Lecturers(lecturer_id)
);

CREATE TABLE ResearchParticipants (
    project_id INT NOT NULL,
    participant_id VARCHAR(100) NOT NULL,  -- could be a lecturer or staff
    role VARCHAR(100),
    PRIMARY KEY (project_id, participant_id),
    FOREIGN KEY (project_id) REFERENCES ResearchProjects(project_id),
    FOREIGN KEY (participant_id) REFERENCES Users(user_id)
);

CREATE TABLE Workshops (
    workshop_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    location VARCHAR(255),
    organizer VARCHAR(100),
    FOREIGN KEY (organizer) REFERENCES Users(user_id)
);

CREATE TABLE WorkshopRegistrations (
    registration_id INT PRIMARY KEY IDENTITY(1,1),
    workshop_id INT NOT NULL,
    participant_id VARCHAR(100) NOT NULL,
    registration_date DATE DEFAULT GETDATE(),
    status VARCHAR(50) CHECK (status IN ('Registered', 'Attended', 'Cancelled')),
    FOREIGN KEY (workshop_id) REFERENCES Workshops(workshop_id),
    FOREIGN KEY (participant_id) REFERENCES Users(user_id)
);

CREATE TABLE Tenders (
    tender_id INT PRIMARY KEY IDENTITY(1,1),
    tender_title VARCHAR(255) NOT NULL,
    tender_description TEXT NOT NULL,
    issue_date DATE NOT NULL,
    closing_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('Open', 'Closed', 'Awarded', 'Cancelled')),
    branch_id VARCHAR(100) NOT NULL,  -- The branch issuing the tender, if applicable
    contact_person VARCHAR(100),
    contact_details VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE TenderApplications (
    application_id INT PRIMARY KEY IDENTITY(1,1),
    tender_id INT NOT NULL,
    supplier_name VARCHAR(255) NOT NULL,
    application_date DATE NOT NULL DEFAULT GETDATE(),
    proposal_details TEXT NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('Submitted', 'Reviewed', 'Accepted', 'Rejected')),
    evaluated_by VARCHAR(100),  -- Optionally, the user who reviewed the application
    evaluation_comments TEXT,
    FOREIGN KEY (tender_id) REFERENCES Tenders(tender_id)
);

CREATE TABLE TenderDocuments (
    document_id INT PRIMARY KEY IDENTITY(1,1),
    tender_id INT NOT NULL,
    document_name VARCHAR(255) NOT NULL,
    document_url VARCHAR(500) NOT NULL, -- URL or file path to the document (if using cloud storage, for example)
    uploaded_at DATETIME DEFAULT GETDATE(),
    uploaded_by VARCHAR(100),
    FOREIGN KEY (tender_id) REFERENCES Tenders(tender_id)
);

CREATE TABLE TenderAwards (
    award_id INT PRIMARY KEY IDENTITY(1,1),
    tender_id INT NOT NULL,
    supplier_name VARCHAR(255) NOT NULL,
    award_date DATE NOT NULL,
    contract_value DECIMAL(15,2) NOT NULL,
    award_notes TEXT,
    awarded_by VARCHAR(100), -- The evaluator or committee who awarded the tender
    FOREIGN KEY (tender_id) REFERENCES Tenders(tender_id)
);
CREATE TABLE TenderEvaluationCriteria (
    criteria_id INT PRIMARY KEY IDENTITY(1,1),
    tender_id INT NOT NULL,
    criteria_description VARCHAR(255) NOT NULL,
    weight DECIMAL(5,2) NOT NULL,  -- Represents the importance of this criteria (e.g., percentage weight)
    FOREIGN KEY (tender_id) REFERENCES Tenders(tender_id)
);
CREATE TABLE TenderEvaluationScores (
    score_id INT PRIMARY KEY IDENTITY(1,1),
    application_id INT NOT NULL,
    criteria_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,  -- The score awarded for this criterion
    comments TEXT,
    FOREIGN KEY (application_id) REFERENCES TenderApplications(application_id),
    FOREIGN KEY (criteria_id) REFERENCES TenderEvaluationCriteria(criteria_id)
);
CREATE TABLE TenderClarifications (
    clarification_id INT PRIMARY KEY IDENTITY(1,1),
    tender_id INT NOT NULL,
    question TEXT NOT NULL,
    answer TEXT,
    asked_by VARCHAR(255) NOT NULL,  -- Supplier or applicant name
    asked_at DATETIME DEFAULT GETDATE(),
    answered_at DATETIME,
    FOREIGN KEY (tender_id) REFERENCES Tenders(tender_id)
);

CREATE TABLE ITSupportTickets (
    ticket_id INT PRIMARY KEY IDENTITY(1,1),
    user_id VARCHAR(100) NOT NULL,  -- Who reported the issue
    issue_description TEXT NOT NULL,
    issue_category VARCHAR(50) NOT NULL 
        CHECK (issue_category IN ('Hardware', 'Software', 'Network', 'Other')),
    status VARCHAR(50) NOT NULL 
        CHECK (status IN ('Open', 'In Progress', 'Resolved', 'Closed')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    resolved_at DATETIME,
    assigned_to VARCHAR(100),  -- IT staff assigned to resolve the issue
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (assigned_to) REFERENCES Users(user_id)
);

CREATE TABLE CampusSecurityIncidents (
    incident_id INT PRIMARY KEY IDENTITY(1,1),
    incident_type VARCHAR(50) NOT NULL 
        CHECK (incident_type IN ('Theft', 'Accident', 'Vandalism', 'Other')),
    description TEXT NOT NULL,
    incident_date DATE NOT NULL,
    reported_by VARCHAR(100) NOT NULL,  -- The user who reported the incident
    status VARCHAR(50) NOT NULL 
        CHECK (status IN ('Reported', 'Investigating', 'Resolved')),
    resolution TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (reported_by) REFERENCES Users(user_id)
);

CREATE TABLE FacultyPublications (
    publication_id INT PRIMARY KEY IDENTITY(1,1),
    lecturer_id VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    journal VARCHAR(255),
    publication_date DATE,
    abstract TEXT,
    document_url VARCHAR(500),  -- Link to the publication or full text (if stored in the cloud)
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (lecturer_id) REFERENCES Lecturers(lecturer_id)
);
CREATE TABLE StudentInternships (
    internship_id INT PRIMARY KEY IDENTITY(1,1),
    student_id VARCHAR(100) NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    position VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    supervisor VARCHAR(255),
    feedback TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);
