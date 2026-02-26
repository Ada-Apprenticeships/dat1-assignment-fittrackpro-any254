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
    name VARCHAR(50),
    address VARCHAR(100),
    phone_number TEXT NOT NULL
        CHECK (length(phone_number) BETWEEN 5 AND 20),
    email VARCHAR(50) NOT NULL
        CHECK (email LIKE '%@%.%'),
    oopening_hours VARCHAR(30) NOT NULL
        CHECK (opening_hours GLOB '[0-2][0-9]:[0-5][0-9]-[0-2][0-9]:[0-5][0-9]'),
    PRIMARY KEY (location_id)
);


-- members 
CREATE TABLE members (
    member_id INTEGER,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone_number VARCHAR(20),
    date_of_birth VARCHAR(20), -- Date not null Check ( date(date of birth ))
    join_date VARCHAR(20),
    emergency_contact_name VARCHAR(50),
    emergency_contact_phone VARCHAR(20),
    PRIMARY KEY (member_id)
);


--staff
CREATE TABLE staff (
    staff_id INTEGER,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone_number VARCHAR(20),
    position VARCHAR(20),
    location_id INTEGER,
    hire_date VARCHAR(20),
    PRIMARY KEY (staff_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

--equipment 
CREATE TABLE equipment (
    equipment_id INTEGER,
    name VARCHAR(50),
    type VARCHAR(30),
    purchase_date VARCHAR(20),
    last_maintenance_date VARCHAR(20),
    next_maintenance_date VARCHAR(20),
    location_id INTEGER,
    PRIMARY KEY (equipment_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- classes
CREATE TABLE classes (
    class_id INTEGER,
    name VARCHAR(50),
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
    start_time VARCHAR(25),
    end_time VARCHAR(25),
    PRIMARY KEY (schedule_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- memberships
CREATE TABLE memberships (
    membership_id INTEGER,
    member_id INTEGER,
    type VARCHAR(30),
    start_date VARCHAR(20),
    end_date VARCHAR(20),
    status VARCHAR(20),
    PRIMARY KEY (membership_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- attendance
CREATE TABLE attendance (
    attendance_id INTEGER,
    member_id INTEGER,
    location_id INTEGER,
    check_in_time VARCHAR(25),
    check_out_time VARCHAR(25),
    PRIMARY KEY (attendance_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- class_attendance
CREATE TABLE class_attendance (
    class_attendance_id INTEGER,
    schedule_id INTEGER,
    member_id INTEGER,
    attendance_status VARCHAR(20),
    PRIMARY KEY (class_attendance_id),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- payments
CREATE TABLE payments (
    payment_id INTEGER,
    member_id INTEGER,
    amount REAL,
    payment_date VARCHAR(20),
    payment_method VARCHAR(20),
    payment_type VARCHAR(40),
    PRIMARY KEY (payment_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- personal_training_sessions
CREATE TABLE personal_training_sessions (
    session_id INTEGER,
    member_id INTEGER,
    staff_id INTEGER,
    session_date INTEGER,
    start_time VARCHAR(25),
    end_time VARCHAR(25),
    notes VARCHAR(100),
    PRIMARY KEY (session_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- member_health_metrics
CREATE TABLE member_health_metrics (
    metric_id INTEGER,
    member_id INTEGER,
    measurement_date VARCHAR(20),
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
    maintenance_date VARCHAR(20),
    description VARCHAR(100),
    staff_id INTEGER,
    PRIMARY KEY (log_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);