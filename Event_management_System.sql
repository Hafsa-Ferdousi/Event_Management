
DROP TABLE Payment CASCADE CONSTRAINTS;
DROP TABLE Invoice CASCADE CONSTRAINTS;
DROP TABLE Event_Guest CASCADE CONSTRAINTS;
DROP TABLE Decorator CASCADE CONSTRAINTS;
DROP TABLE Transport CASCADE CONSTRAINTS;
DROP TABLE Catering CASCADE CONSTRAINTS;
DROP TABLE Photographer CASCADE CONSTRAINTS;
DROP TABLE Service CASCADE CONSTRAINTS;
DROP TABLE Vendor CASCADE CONSTRAINTS;
DROP TABLE Booking CASCADE CONSTRAINTS;
DROP TABLE Package_Table CASCADE CONSTRAINTS;
DROP TABLE Event CASCADE CONSTRAINTS;
DROP TABLE Venue_Details CASCADE CONSTRAINTS;
DROP TABLE Venue CASCADE CONSTRAINTS;
DROP TABLE Staff CASCADE CONSTRAINTS;
DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE Person_Email CASCADE CONSTRAINTS;
DROP TABLE Person_Phone CASCADE CONSTRAINTS;
DROP TABLE Person CASCADE CONSTRAINTS;



-- 1. PERSON
CREATE TABLE Person (
    person_id      NUMBER(10)        NOT NULL,
    name           VARCHAR2(150)     NOT NULL,
    gender         VARCHAR2(10),
    birth_date     DATE,
    contact_number VARCHAR2(30),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);

-- 2. CLIENT
CREATE TABLE Client (
    client_id      NUMBER(10)        NOT NULL,
    client_type    VARCHAR2(50),
    contact        VARCHAR2(150),
    CONSTRAINT pk_client PRIMARY KEY (client_id),
    CONSTRAINT fk_client_person FOREIGN KEY (client_id) REFERENCES Person(person_id)
);

-- 3. STAFF
CREATE TABLE Staff (
    staff_id       NUMBER(10)        NOT NULL,
    staff_role     VARCHAR2(100),  -- fixed name
    hire_date      DATE,
    CONSTRAINT pk_staff PRIMARY KEY (staff_id),
    CONSTRAINT fk_staff_person FOREIGN KEY (staff_id) REFERENCES Person(person_id)
);

-- 4. VENUE
CREATE TABLE Venue (
    venue_id           NUMBER(10)    NOT NULL,
    staff_id           NUMBER(10)    NOT NULL,
    capacity           NUMBER(6),
    hourly_rate        NUMBER(12,2),
    city               VARCHAR2(100),
    postal_code        VARCHAR2(20),
    CONSTRAINT pk_venue PRIMARY KEY (venue_id),
    CONSTRAINT fk_venue_staff FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- 5. VENUE_DETAILS
CREATE TABLE Venue_Details (
    venue_id               NUMBER(10)   NOT NULL,
    parking_availability   VARCHAR2(50),
    accessibility_feature  VARCHAR2(200),
    CONSTRAINT pk_venue_details PRIMARY KEY (venue_id),
    CONSTRAINT fk_venue_details_venue FOREIGN KEY (venue_id) REFERENCES Venue(venue_id)
);

-- 6. EVENT
CREATE TABLE Event (
    event_id       NUMBER(10)        NOT NULL,
    duration       NUMBER(8,2),
    status         VARCHAR2(50),
    event_type     VARCHAR2(100),
    start_time     TIMESTAMP,
    CONSTRAINT pk_event PRIMARY KEY (event_id)
);

-- 7. PACKAGE
CREATE TABLE Package_Table (
    package_id     NUMBER(10)        NOT NULL,
    event_id       NUMBER(10)        NOT NULL,
    price          NUMBER(12,2),
    name           VARCHAR2(150),
    description    VARCHAR2(4000),
    CONSTRAINT pk_package PRIMARY KEY (package_id),
    CONSTRAINT fk_package_event FOREIGN KEY (event_id) REFERENCES Event(event_id)
);

-- 8. BOOKING
CREATE TABLE Booking (
    booking_id     NUMBER(10)        NOT NULL,
    client_id      NUMBER(10)        NOT NULL,
    event_id       NUMBER(10)        NOT NULL,
    package_id     NUMBER(10),
    booking_date   DATE DEFAULT SYSDATE,
    CONSTRAINT pk_booking PRIMARY KEY (booking_id),
    CONSTRAINT fk_booking_client FOREIGN KEY (client_id) REFERENCES Client(client_id),
    CONSTRAINT fk_booking_event FOREIGN KEY (event_id) REFERENCES Event(event_id),
    CONSTRAINT fk_booking_package FOREIGN KEY (package_id) REFERENCES Package_Table(package_id)
);

-- 9. VENDOR
CREATE TABLE Vendor (
    vendor_id      NUMBER(10)        NOT NULL,
    name           VARCHAR2(150)     NOT NULL,
    rating         NUMBER(5,2),
    unit_price     NUMBER(12,2),
    event_id       NUMBER(10),
    CONSTRAINT pk_vendor PRIMARY KEY (vendor_id),
    CONSTRAINT fk_vendor_event FOREIGN KEY (event_id) REFERENCES Event(event_id)
);

-- 10. SERVICE
CREATE TABLE Service (
    service_id     NUMBER(10)        NOT NULL,
    vendor_id      NUMBER(10)        NOT NULL,
    name           VARCHAR2(150),
    description    VARCHAR2(2000),
    unit_price     NUMBER(12,2),
    CONSTRAINT pk_service PRIMARY KEY (service_id),
    CONSTRAINT fk_service_vendor FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);

-- 11. PHOTOGRAPHER
CREATE TABLE Photographer (
    vendor_id          NUMBER(10)     NOT NULL,
    photography_style  VARCHAR2(200),
    portfolio          VARCHAR2(2000),
    CONSTRAINT pk_photographer PRIMARY KEY (vendor_id),
    CONSTRAINT fk_photographer_vendor FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);

-- 12. CATERING
CREATE TABLE Catering (
    vendor_id          NUMBER(10)     NOT NULL,
    menu               VARCHAR2(4000),
    cuisine_type       VARCHAR2(200),
    capacity           NUMBER(6),
    CONSTRAINT pk_catering PRIMARY KEY (vendor_id),
    CONSTRAINT fk_catering_vendor FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);

-- 13. TRANSPORT
CREATE TABLE Transport (
    vendor_id          NUMBER(10)     NOT NULL,
    vehicle_type       VARCHAR2(150),
    availability_time  VARCHAR2(200),
    capacity           NUMBER(6),
    CONSTRAINT pk_transport PRIMARY KEY (vendor_id),
    CONSTRAINT fk_transport_vendor FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);

-- 14. DECORATOR
CREATE TABLE Decorator (
    vendor_id         NUMBER(10)     NOT NULL,
    theme             VARCHAR2(200),
    portfolio         VARCHAR2(2000),
    specialities      VARCHAR2(1000),
    CONSTRAINT pk_decorator PRIMARY KEY (vendor_id),
    CONSTRAINT fk_decorator_vendor FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);

-- 15. EVENT_GUEST
CREATE TABLE Event_Guest (
    event_id       NUMBER(10)        NOT NULL,
    person_id      NUMBER(10)        NOT NULL,
    check_in_time  TIMESTAMP,
    CONSTRAINT pk_event_guest PRIMARY KEY (event_id, person_id),
    CONSTRAINT fk_event_guest_event FOREIGN KEY (event_id) REFERENCES Event(event_id),
    CONSTRAINT fk_event_guest_person FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

-- 16. INVOICE
CREATE TABLE Invoice (
    invoice_id     NUMBER(10)        NOT NULL,
    booking_id     NUMBER(10)        NOT NULL,
    vendor_id      NUMBER(10)        NOT NULL,
    invoice_date   DATE DEFAULT SYSDATE,
    unit_price     NUMBER(12,2),
    CONSTRAINT pk_invoice PRIMARY KEY (invoice_id),
    CONSTRAINT fk_invoice_booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    CONSTRAINT fk_invoice_vendor FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);

-- 17. PAYMENT
CREATE TABLE Payment (
    payment_id     NUMBER(10)        NOT NULL,
    invoice_id     NUMBER(10)        NOT NULL,
    amount         NUMBER(12,2)      NOT NULL,
    status         VARCHAR2(50),
    method         VARCHAR2(50),
    payment_date   DATE,
    CONSTRAINT pk_payment PRIMARY KEY (payment_id),
    CONSTRAINT fk_payment_invoice FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

-- 18. PERSON_EMAIL
CREATE TABLE Person_Email (
    person_id     NUMBER(10)         NOT NULL,
    email         VARCHAR2(250)      NOT NULL,
    CONSTRAINT pk_person_email PRIMARY KEY (person_id, email),
    CONSTRAINT fk_person_email_person FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

-- 19. PERSON_PHONE
CREATE TABLE Person_Phone (
    person_id     NUMBER(10)         NOT NULL,
    phone_number  VARCHAR2(50)       NOT NULL,
    phone_type    VARCHAR2(20),
    CONSTRAINT pk_person_phone PRIMARY KEY (person_id, phone_number),
    CONSTRAINT fk_person_phone_person FOREIGN KEY (person_id) REFERENCES Person(person_id)
);


CREATE INDEX idx_venue_staff ON Venue(staff_id);
CREATE INDEX idx_package_event ON Package_Table(event_id);
CREATE INDEX idx_booking_client ON Booking(client_id);
CREATE INDEX idx_booking_event ON Booking(event_id);
CREATE INDEX idx_vendor_event ON Vendor(event_id);
CREATE INDEX idx_service_vendor ON Service(vendor_id);
CREATE INDEX idx_invoice_booking ON Invoice(booking_id);
CREATE INDEX idx_invoice_vendor ON Invoice(vendor_id);
CREATE INDEX idx_payment_invoice ON Payment(invoice_id);
CREATE INDEX idx_person_email ON Person_Email(person_id);
CREATE INDEX idx_person_phone ON Person_Phone(person_id);

COMMIT;
-- ================================
-- 1. PERSON
-- ================================
INSERT INTO Person (person_id, name, gender, birth_date, contact_number)
VALUES (1, 'Rahim Uddin', 'Male', TO_DATE('1985-02-10','YYYY-MM-DD'), '01710000001');

INSERT INTO Person (person_id, name, gender, birth_date, contact_number)
VALUES (2, 'Fatema Akter', 'Female', TO_DATE('1990-06-25','YYYY-MM-DD'), '01710000002');

INSERT INTO Person (person_id, name, gender, birth_date, contact_number)
VALUES (3, 'Karim Hossain', 'Male', TO_DATE('1988-11-12','YYYY-MM-DD'), '01710000003');

INSERT INTO Person (person_id, name, gender, birth_date, contact_number)
VALUES (4, 'Salma Begum', 'Female', TO_DATE('1992-03-05','YYYY-MM-DD'), '01710000004');

INSERT INTO Person (person_id, name, gender, birth_date, contact_number)
VALUES (5, 'Jamal Uddin', 'Male', TO_DATE('1987-08-19','YYYY-MM-DD'), '01710000005');


INSERT INTO Client (client_id, client_type, contact)
VALUES (1, 'Corporate', 'Rahim Uddin');

INSERT INTO Client (client_id, client_type, contact)
VALUES (2, 'Individual', 'Fatema Akter');

INSERT INTO Client (client_id, client_type, contact)
VALUES (3, 'Corporate', 'Karim Hossain');

INSERT INTO Client (client_id, client_type, contact)
VALUES (4, 'Individual', 'Salma Begum');

INSERT INTO Client (client_id, client_type, contact)
VALUES (5, 'Corporate', 'Jamal Uddin');

INSERT INTO Staff (staff_id, staff_role, hire_date)
VALUES (1, 'Manager', TO_DATE('2015-05-10','YYYY-MM-DD'));

INSERT INTO Staff (staff_id, staff_role, hire_date)
VALUES (2, 'Event Coordinator', TO_DATE('2018-03-15','YYYY-MM-DD'));

INSERT INTO Staff (staff_id, staff_role, hire_date)
VALUES (3, 'Sales Executive', TO_DATE('2019-07-20','YYYY-MM-DD'));

INSERT INTO Staff (staff_id, staff_role, hire_date)
VALUES (4, 'Receptionist', TO_DATE('2020-01-12','YYYY-MM-DD'));

INSERT INTO Staff (staff_id, staff_role, hire_date)
VALUES (5, 'Technical Support', TO_DATE('2021-06-18','YYYY-MM-DD'));


INSERT INTO Venue (venue_id, staff_id, capacity, hourly_rate, city, postal_code)
VALUES (1, 1, 200, 5000, 'Dhaka', '1205');

INSERT INTO Venue (venue_id, staff_id, capacity, hourly_rate, city, postal_code)
VALUES (2, 2, 150, 4000, 'Chittagong', '4000');

INSERT INTO Venue (venue_id, staff_id, capacity, hourly_rate, city, postal_code)
VALUES (3, 3, 300, 6000, 'Sylhet', '3100');

INSERT INTO Venue (venue_id, staff_id, capacity, hourly_rate, city, postal_code)
VALUES (4, 4, 250, 5500, 'Khulna', '9000');

INSERT INTO Venue (venue_id, staff_id, capacity, hourly_rate, city, postal_code)
VALUES (5, 5, 180, 4500, 'Rajshahi', '6000');


INSERT INTO Venue_Details (venue_id, parking_availability, accessibility_feature)
VALUES (1, 'Available', 'Wheelchair Ramp');

INSERT INTO Venue_Details (venue_id, parking_availability, accessibility_feature)
VALUES (2, 'Limited', 'Elevator');

INSERT INTO Venue_Details (venue_id, parking_availability, accessibility_feature)
VALUES (3, 'Available', 'Ramps and lifts');

INSERT INTO Venue_Details (venue_id, parking_availability, accessibility_feature)
VALUES (4, 'None', 'No special features');

INSERT INTO Venue_Details (venue_id, parking_availability, accessibility_feature)
VALUES (5, 'Available', 'Wheelchair Accessible');



INSERT INTO Event (event_id, duration, status, event_type, start_time)
VALUES (1, 4, 'Scheduled', 'Wedding', TO_TIMESTAMP('2025-10-15 10:00:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Event (event_id, duration, status, event_type, start_time)
VALUES (2, 2, 'Scheduled', 'Birthday', TO_TIMESTAMP('2025-11-05 14:00:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Event (event_id, duration, status, event_type, start_time)
VALUES (3, 3, 'Completed', 'Corporate', TO_TIMESTAMP('2025-09-20 09:00:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Event (event_id, duration, status, event_type, start_time)
VALUES (4, 5, 'Scheduled', 'Engagement', TO_TIMESTAMP('2025-12-01 16:00:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Event (event_id, duration, status, event_type, start_time)
VALUES (5, 3.5, 'Cancelled', 'Workshop', TO_TIMESTAMP('2025-09-30 10:30:00','YYYY-MM-DD HH24:MI:SS'));



INSERT INTO Package_Table (package_id, event_id, price, name, description)
VALUES (1, 1, 50000, 'Gold Wedding Package', 'Includes full decoration and catering');

INSERT INTO Package_Table (package_id, event_id, price, name, description)
VALUES (2, 2, 15000, 'Birthday Basic Package', 'Cake and venue decoration');

INSERT INTO Package_Table (package_id, event_id, price, name, description)
VALUES (3, 3, 30000, 'Corporate Seminar Package', 'Lunch, snacks, and room setup');

INSERT INTO Package_Table (package_id, event_id, price, name, description)
VALUES (4, 4, 40000, 'Engagement Deluxe Package', 'Full event support and decoration');

INSERT INTO Package_Table (package_id, event_id, price, name, description)
VALUES (5, 5, 20000, 'Workshop Package', 'Materials and refreshments included');


INSERT INTO Booking (booking_id, client_id, event_id, package_id, booking_date)
VALUES (1, 1, 1, 1, TO_DATE('2025-08-01','YYYY-MM-DD'));

INSERT INTO Booking (booking_id, client_id, event_id, package_id, booking_date)
VALUES (2, 2, 2, 2, TO_DATE('2025-08-05','YYYY-MM-DD'));

INSERT INTO Booking (booking_id, client_id, event_id, package_id, booking_date)
VALUES (3, 3, 3, 3, TO_DATE('2025-08-10','YYYY-MM-DD'));

INSERT INTO Booking (booking_id, client_id, event_id, package_id, booking_date)
VALUES (4, 4, 4, 4, TO_DATE('2025-08-15','YYYY-MM-DD'));

INSERT INTO Booking (booking_id, client_id, event_id, package_id, booking_date)
VALUES (5, 5, 5, 5, TO_DATE('2025-08-20','YYYY-MM-DD'));


INSERT INTO Vendor (vendor_id, name, rating, unit_price, event_id)
VALUES (1, 'Bangla Catering', 4.5, 2000, 1);

INSERT INTO Vendor (vendor_id, name, rating, unit_price, event_id)
VALUES (2, 'Dhaka Decorators', 4.8, 1500, 2);

INSERT INTO Vendor (vendor_id, name, rating, unit_price, event_id)
VALUES (3, 'Sylhet Photography', 4.9, 2500, 3);

INSERT INTO Vendor (vendor_id, name, rating, unit_price, event_id)
VALUES (4, 'Chittagong Transport', 4.3, 1000, 4);

INSERT INTO Vendor (vendor_id, name, rating, unit_price, event_id)
VALUES (5, 'Rajshahi Event Services', 4.6, 1800, 5);


INSERT INTO Service (service_id, vendor_id, name, description, unit_price)
VALUES (1, 1, 'Lunch Catering', 'Full lunch for guests', 2000);

INSERT INTO Service (service_id, vendor_id, name, description, unit_price)
VALUES (2, 2, 'Venue Decoration', 'Full decoration setup', 1500);

INSERT INTO Service (service_id, vendor_id, name, description, unit_price)
VALUES (3, 3, 'Photography', 'Event coverage and album', 2500);

INSERT INTO Service (service_id, vendor_id, name, description, unit_price)
VALUES (4, 4, 'Transport', 'Bus for guests', 1000);

INSERT INTO Service (service_id, vendor_id, name, description, unit_price)
VALUES (5, 5, 'Event Management', 'Complete event handling', 1800);



INSERT INTO Catering (vendor_id, menu, cuisine_type, capacity)
VALUES (1, 'Rice, Chicken Curry, Salad', 'Bangladeshi', 200);

INSERT INTO Catering (vendor_id, menu, cuisine_type, capacity)
VALUES (5, 'Sandwiches, Juice, Snacks', 'Continental', 150);

INSERT INTO Catering (vendor_id, menu, cuisine_type, capacity)
VALUES (2, 'Rice, Fish Curry, Vegetables', 'Bangladeshi', 100);

INSERT INTO Catering (vendor_id, menu, cuisine_type, capacity)
VALUES (3, 'Mixed Cuisine', 'International', 180);

INSERT INTO Catering (vendor_id, menu, cuisine_type, capacity)
VALUES (4, 'Fast Food', 'Local', 120);

INSERT INTO Transport (vendor_id, vehicle_type, availability_time, capacity)
VALUES (4, 'Bus', '09:00-18:00', 50);

INSERT INTO Transport (vendor_id, vehicle_type, availability_time, capacity)
VALUES (5, 'Van', '10:00-16:00', 15);

INSERT INTO Transport (vendor_id, vehicle_type, availability_time, capacity)
VALUES (2, 'Car', '08:00-20:00', 5);

INSERT INTO Transport (vendor_id, vehicle_type, availability_time, capacity)
VALUES (3, 'Motorbike', '07:00-19:00', 2);

INSERT INTO Transport (vendor_id, vehicle_type, availability_time, capacity)
VALUES (1, 'Minibus', '09:00-17:00', 20);




INSERT INTO Event_Guest (event_id, person_id, check_in_time)
VALUES (1, 1, TO_TIMESTAMP('2025-10-15 10:05:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Event_Guest (event_id, person_id, check_in_time)
VALUES (1, 2, TO_TIMESTAMP('2025-10-15 10:10:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Event_Guest (event_id, person_id, check_in_time)
VALUES (2, 3, TO_TIMESTAMP('2025-11-05 14:05:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Event_Guest (event_id, person_id, check_in_time)
VALUES (3, 4, TO_TIMESTAMP('2025-09-20 09:10:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Event_Guest (event_id, person_id, check_in_time)
VALUES (4, 5, TO_TIMESTAMP('2025-12-01 16:15:00','YYYY-MM-DD HH24:MI:SS'));


INSERT INTO Invoice (invoice_id, booking_id, vendor_id, invoice_date, unit_price)
VALUES (1, 1, 1, TO_DATE('2025-08-02','YYYY-MM-DD'), 2000);

INSERT INTO Invoice (invoice_id, booking_id, vendor_id, invoice_date, unit_price)
VALUES (2, 2, 2, TO_DATE('2025-08-06','YYYY-MM-DD'), 1500);

INSERT INTO Invoice (invoice_id, booking_id, vendor_id, invoice_date, unit_price)
VALUES (3, 3, 3, TO_DATE('2025-08-11','YYYY-MM-DD'), 2500);

INSERT INTO Invoice (invoice_id, booking_id, vendor_id, invoice_date, unit_price)
VALUES (4, 4, 4, TO_DATE('2025-08-16','YYYY-MM-DD'), 1000);

INSERT INTO Invoice (invoice_id, booking_id, vendor_id, invoice_date, unit_price)
VALUES (5, 5, 5, TO_DATE('2025-08-21','YYYY-MM-DD'), 1800);



INSERT INTO Payment (payment_id, invoice_id, amount, status, method, payment_date)
VALUES (1, 1, 2000, 'Paid', 'Cash', TO_DATE('2025-08-03','YYYY-MM-DD'));

INSERT INTO Payment (payment_id, invoice_id, amount, status, method, payment_date)
VALUES (2, 2, 1500, 'Paid', 'Card', TO_DATE('2025-08-07','YYYY-MM-DD'));

INSERT INTO Payment (payment_id, invoice_id, amount, status, method, payment_date)
VALUES (3, 3, 2500, 'Pending', 'Bank Transfer', TO_DATE('2025-08-12','YYYY-MM-DD'));

INSERT INTO Payment (payment_id, invoice_id, amount, status, method, payment_date)
VALUES (4, 4, 1000, 'Paid', 'Cash', TO_DATE('2025-08-17','YYYY-MM-DD'));

INSERT INTO Payment (payment_id, invoice_id, amount, status, method, payment_date)
VALUES (5, 5, 1800, 'Pending', 'Card', TO_DATE('2025-08-22','YYYY-MM-DD'));


INSERT INTO Person_Email (person_id, email)
VALUES (1, 'rahim.uddin@gmail.com');

INSERT INTO Person_Email (person_id, email)
VALUES (2, 'fatema.akter@yahoo.com');

INSERT INTO Person_Email (person_id, email)
VALUES (3, 'karim.hossain@gmail.com');

INSERT INTO Person_Email (person_id, email)
VALUES (4, 'salma.begum@hotmail.com');

INSERT INTO Person_Email (person_id, email)
VALUES (5, 'jamal.uddin@gmail.com');



INSERT INTO Person_Phone (person_id, phone_number, phone_type)
VALUES (1, '01710000001', 'Mobile');

INSERT INTO Person_Phone (person_id, phone_number, phone_type)
VALUES (2, '01710000002', 'Mobile');

INSERT INTO Person_Phone (person_id, phone_number, phone_type)
VALUES (3, '01710000003', 'Mobile');

INSERT INTO Person_Phone (person_id, phone_number, phone_type)
VALUES (4, '01710000004', 'Mobile');

INSERT INTO Person_Phone (person_id, phone_number, phone_type)
VALUES (5, '01710000005', 'Mobile');

COMMIT;


