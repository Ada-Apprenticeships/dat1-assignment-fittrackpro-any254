.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON; -- Since we are using or relying on foreign keys

DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS locations;

-- locations
CREATE TABLE locations (
    location_id INTEGER,
    name VARCHAR(30),
    address VARCHAR(100),
    phone_number TEXT NOT NULL
        CHECK (length(phone_number) BETWEEN 5 AND 20),
    email VARCHAR(50) NOT NULL
        CHECK (email LIKE '%@%.%'),
    opening_hours TEXT NOT NULL
        CHECK (opening_hours LIKE '__:__-__:__'),
    PRIMARY KEY (location_id)
);


-- members 
CREATE TABLE members (
    member_id INTEGER,
    first_name VARCHAR(20),
    last_name VARCHAR(30),
    email VARCHAR(50) NOT NULL
        CHECK (email LIKE '%@%.%'),
    phone_number TEXT NOT NULL
        CHECK (length(phone_number) BETWEEN 5 AND 20),
    date_of_birth TEXT NOT NULL
        CHECK (date(date_of_birth) IS NOT NULL),
    join_date TEXT NOT NULL
        CHECK (
            date(join_date) IS NOT NULL
            AND date(join_date) >= date(date_of_birth)
        ),
    emergency_contact_name VARCHAR(20),
    emergency_contact_phone TEXT NOT NULL
        CHECK (length(emergency_contact_phone) BETWEEN 5 AND 20),
    PRIMARY KEY (member_id)
);


--staff
CREATE TABLE staff (
    staff_id INTEGER,
    first_name VARCHAR(20),
    last_name VARCHAR(30),
    email VARCHAR(50) NOT NULL
        CHECK (email LIKE '%@%.%'),
    phone_number TEXT NOT NULL
        CHECK (length(phone_number) BETWEEN 5 AND 20),
    position TEXT NOT NULL
        CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    location_id INTEGER,
    hire_date TEXT NOT NULL
        CHECK (date(hire_date) IS NOT NULL),
    PRIMARY KEY (staff_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

--equipment 
CREATE TABLE equipment (
    equipment_id INTEGER,
    name VARCHAR(20),
    type VARCHAR(30),
    purchase_date TEXT NOT NULL
        CHECK (date(purchase_date) IS NOT NULL),
    last_maintenance_date TEXT NOT NULL
        CHECK (date(last_maintenance_date) IS NOT NULL),
    next_maintenance_date TEXT NOT NULL
        CHECK (date(next_maintenance_date) IS NOT NULL),
    location_id INTEGER,
    PRIMARY KEY (equipment_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- classes
CREATE TABLE classes (
    class_id INTEGER,
    name VARCHAR(30),
    description VARCHAR(100),
    capacity INTEGER,
    duration INTEGER,
    location_id INTEGER,
    PRIMARY KEY (class_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- class_schedule
CREATE TABLE class_schedule (
    schedule_id INTEGER,
    class_id INTEGER,
    staff_id INTEGER,
    start_time TEXT NOT NULL
        CHECK (datetime(start_time) IS NOT NULL),
    end_time TEXT NOT NULL
        CHECK (datetime(end_time) IS NOT NULL),
    PRIMARY KEY (schedule_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- memberships
CREATE TABLE memberships (
    membership_id INTEGER,
    member_id INTEGER,
    type VARCHAR(30),
    start_date TEXT NOT NULL
        CHECK (date(start_date) IS NOT NULL),
    end_date TEXT NOT NULL
        CHECK (date(end_date) IS NOT NULL),
    status TEXT NOT NULL
    CHECK (status IN ('Active', 'Inactive')),
    PRIMARY KEY (membership_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- attendance
CREATE TABLE attendance (
    attendance_id INTEGER,
    member_id INTEGER,
    location_id INTEGER,
    check_in_time TEXT NOT NULL
        CHECK (datetime(check_in_time) IS NOT NULL),
    check_out_time TEXT
        CHECK (
            check_out_time IS NULL
            OR datetime(check_out_time) IS NOT NULL
        ),
    PRIMARY KEY (attendance_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- class_attendance
CREATE TABLE class_attendance (
    class_attendance_id INTEGER,
    schedule_id INTEGER,
    member_id INTEGER,
    attendance_status TEXT NOT NULL
        CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    PRIMARY KEY (class_attendance_id),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- payments
CREATE TABLE payments (
    payment_id INTEGER,
    member_id INTEGER,
    amount REAL,
    payment_date TEXT NOT NULL
        CHECK (datetime(payment_date) IS NOT NULL),
    payment_method TEXT NOT NULL
        CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type TEXT NOT NULL
        CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    PRIMARY KEY (payment_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- personal_training_sessions
CREATE TABLE personal_training_sessions (
    session_id INTEGER,
    member_id INTEGER,
    staff_id INTEGER,
    session_date TEXT NOT NULL
        CHECK (date(session_date) IS NOT NULL),
    start_time TEXT NOT NULL
        CHECK (time(start_time) IS NOT NULL),
    end_time TEXT NOT NULL
        CHECK (time(end_time) IS NOT NULL),
    notes VARCHAR(100),
    PRIMARY KEY (session_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- member_health_metrics
CREATE TABLE member_health_metrics (
    metric_id INTEGER,
    member_id INTEGER,
    measurement_date TEXT NOT NULL
        CHECK (date(measurement_date) IS NOT NULL),
    weight REAL,
    body_fat_percentage REAL,
    muscle_mass REAL,
    bmi REAL,
    PRIMARY KEY (metric_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- equipment_maintenance_log
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER,
    equipment_id INTEGER,
    maintenance_date TEXT NOT NULL
        CHECK (date(maintenance_date) IS NOT NULL),
    description VARCHAR(100),
    staff_id INTEGER,
    PRIMARY KEY (log_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);