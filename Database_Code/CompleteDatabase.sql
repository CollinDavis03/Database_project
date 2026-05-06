DROP DATABASE IF EXISTS UWITInven;

CREATE DATABASE UWITInven;
USE UWITInven;

-- Drop tables in reverse dependency order (children before parents)
DROP TABLE IF EXISTS staff_location;
DROP TABLE IF EXISTS role_permission;
DROP TABLE IF EXISTS staff_role;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS catalog;
DROP TABLE IF EXISTS catalog_section;
DROP TABLE IF EXISTS location;
DROP TABLE IF EXISTS building;
DROP TABLE IF EXISTS permission;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS staff;

-- 1. Building
CREATE TABLE building (
    building_id  INT           NOT NULL AUTO_INCREMENT,
    code         VARCHAR(10)   NOT NULL,
    full_name    VARCHAR(100)  NOT NULL,
    address      VARCHAR(255)  NOT NULL,
    PRIMARY KEY (building_id),
    UNIQUE (code)
);

-- 2. Location
CREATE TABLE location (
    location_id    INT           NOT NULL AUTO_INCREMENT,
    building_id    INT           NOT NULL,
    room_number    VARCHAR(20)   NOT NULL,
    type           VARCHAR(50)   NOT NULL,
    capacity       INT           NOT NULL,
    status         VARCHAR(20)   NOT NULL DEFAULT 'Active',
    owner_category VARCHAR(100),
    PRIMARY KEY (location_id),
    CONSTRAINT fk_location_building FOREIGN KEY (building_id)
        REFERENCES building (building_id),
    CONSTRAINT chk_location_type CHECK (
        type IN ('Classroom', 'Lab', 'Conference Room', 'Auditorium')
    ),
CONSTRAINT chk_location_status CHECK (
    status IN ('Active', 'Inactive')
)
);

-- 3. Catalog Section
CREATE TABLE catalog_section (
    section_id     INT           NOT NULL AUTO_INCREMENT, 
	name           VARCHAR(100)  NOT NULL, 
    parent_id      INT,
    PRIMARY KEY (section_id),
    CONSTRAINT fk_catalog_section_self FOREIGN KEY (parent_id) 
        REFERENCES catalog_section(section_id)
);

-- 4. Catalog
CREATE TABLE catalog (
	catalog_id     INT           NOT NULL AUTO_INCREMENT, 
    section_id     INT           NOT NULL,
    manufacturer   VARCHAR(100)  NOT NULL, 
    model          VARCHAR(100)  NOT NULL, 
    status         VARCHAR(100)  NOT NULL, 
    life_expectancy_years INT    NOT NULL, 
    description    TEXT,
    PRIMARY  KEY (catalog_id),
    CONSTRAINT fk_ctg_ctg_section FOREIGN KEY (section_id)
        REFERENCES catalog_section(section_id),
	CONSTRAINT chk_catalog_status CHECK (
        status IN ('Active', 'Inactive', 'Discontinued')
	)
);

-- 5. Item
CREATE TABLE item (
	item_id        INT           NOT NULL AUTO_INCREMENT, 
    catalog_id     INT           NOT NULL, 
    location_id    INT           NOT NULL, 
    item_code      VARCHAR(50)   NOT NULL UNIQUE, 
    serial_number  VARCHAR(100)  NOT NULL, 
    status         VARCHAR(20)   NOT NULL, 
    purchase_date  DATE          NOT NULL, 
    received_date  DATE          NOT NULL, 
    eol_date       DATE          NOT  NULL, 
    mac_address    VARCHAR(17),
    PRIMARY KEY (item_id), 
    CONSTRAINT fk_item_catalog FOREIGN KEY (catalog_id)
        REFERENCES catalog(catalog_id),
	CONSTRAINT fk_item_location FOREIGN KEY (location_id)
        REFERENCES location(location_id), 
	CONSTRAINT chk_item_status CHECK (
        status in ('Operational','In Repair','Retired')
	)
);


-- 6. Staff
CREATE TABLE staff (
	staff_id       INT           NOT NULL AUTO_INCREMENT, 
    first_name     VARCHAR(50)   NOT NULL, 
    last_name      VARCHAR(50)   NOT NULL, 
    email          VARCHAR(100)  NOT NULL UNIQUE, 
    phone          VARCHAR(20), 
    employment_type VARCHAR(20)  NOT NULL, 
    PRIMARY KEY (staff_id), 
    CONSTRAINT chk_staff_employment_type CHECK (
	   employment_type in ('Full-Time','Student Employee')
	)
);


-- 7. Role
CREATE TABLE role (
	role_id         INT           NOT NULL AUTO_INCREMENT, 
    role_name       VARCHAR(50)   NOT NULL, 
    description     TEXT          NOT NULL, 
    PRIMARY  KEY (role_id)
);


-- 8. Permission
CREATE TABLE permission (
	permission_id   INT            NOT NULL AUTO_INCREMENT, 
    permission_name VARCHAR(50)    NOT NULL, 
    description     TEXT           NOT NULL, 
    PRIMARY KEY (permission_id)
);


-- 9. Staff_Role
CREATE TABLE staff_role (
	staff_id        INT            NOT NULL, 
    role_id         INT            NOT NULL, 
    assigned_date   DATE           NOT NULL, 
    PRIMARY KEY (staff_id, role_id), 
    CONSTRAINT fk_staff_r FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id),
	CONSTRAINT fk_role_s FOREIGN KEY (role_id)
        REFERENCES role(role_id)
);


-- 10. Role_Permission
CREATE TABLE role_permission (
	role_id        INT            NOT NULL, 
    permission_id  INT            NOT NULL, 
    PRIMARY KEY (role_id, permission_id), 
    CONSTRAINT fk_role_p FOREIGN KEY (role_id)
        REFERENCES role(role_id),
	CONSTRAINT fk_permission_r FOREIGN KEY (permission_id)
        REFERENCES permission(permission_id)
);


-- 11. Staff_Location
CREATE TABLE staff_location (
	staff_id        INT            NOT NULL, 
    location_id     INT            NOT NULL, 
    assigned_date   DATE, 
    role          VARCHAR(50),
    PRIMARY KEY (staff_id, location_id), 
    CONSTRAINT fk_staff_l FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id),
	CONSTRAINT fk_location_s FOREIGN KEY (location_id)
        REFERENCES location(location_id)
);

-- Clear existing data in reverse dependency order
-- DELETE FROM staff_location;
-- DELETE FROM role_permission;
-- DELETE FROM staff_role;
-- DELETE FROM item;
-- DELETE FROM catalog;
-- DELETE FROM catalog_section;
-- DELETE FROM location;
-- DELETE FROM building;
-- DELETE FROM permission;
-- DELETE FROM role;
-- DELETE FROM staff;

SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE building        AUTO_INCREMENT = 1;
ALTER TABLE location        AUTO_INCREMENT = 1;
ALTER TABLE catalog_section AUTO_INCREMENT = 1;
ALTER TABLE catalog         AUTO_INCREMENT = 1;
ALTER TABLE item            AUTO_INCREMENT = 1;
ALTER TABLE staff           AUTO_INCREMENT = 1;
ALTER TABLE role            AUTO_INCREMENT = 1;
ALTER TABLE permission      AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- BUILDINGS (10 rows)
-- ============================================================
INSERT INTO building (code, full_name, address) VALUES
    ('WU', 'Wilbur Knight Building',        '1000 E University Ave, Laramie, WY 82071'),
    ('AG', 'Agriculture Building',           '1400 E University Ave, Laramie, WY 82071'),
    ('EN', 'Engineering Building',           '1100 E University Ave, Laramie, WY 82071'),
    ('BS', 'Business Building',              '1200 E University Ave, Laramie, WY 82071'),
    ('CR', 'College of Arts & Sciences',     '1600 E University Ave, Laramie, WY 82071'),
    ('ED', 'Education Building',             '1300 E University Ave, Laramie, WY 82071'),
    ('LB', 'Coe Library',                    '1000 E University Ave, Laramie, WY 82071'),
    ('HR', 'Half Acre Recreation Center',    '1700 E University Ave, Laramie, WY 82071'),
    ('OL', 'Old Main',                       '1000 E University Ave, Laramie, WY 82071'),
    ('PH', 'Physical Sciences Building',     '1000 E University Ave, Laramie, WY 82071');

-- ============================================================
-- LOCATIONS (20 rows)
-- ============================================================
INSERT INTO location (building_id, room_number, type, capacity, status, owner_category) VALUES
    (1, '0223', 'Classroom',       35,  'Active',   'Academic Affairs'),
    (1, '0115', 'Conference Room', 12,  'Active',   'Academic Affairs'),
    (1, '0340', 'Classroom',       60,  'Active',   'Academic Affairs'),
    (1, '0450', 'Lab',             24,  'Active',   'College of Engineering'),
    (2, '1040', 'Classroom',       80,  'Active',   'College of Agriculture'),
    (2, '2010', 'Conference Room', 20,  'Active',   'College of Agriculture'),
    (3, '2050', 'Lab',             30,  'Active',   'College of Engineering'),
    (3, '3100', 'Classroom',       45,  'Active',   'College of Engineering'),
    (4, '0101', 'Auditorium',      200, 'Active',   'Business School'),
    (4, '0205', 'Classroom',       40,  'Active',   'Business School'),
    (5, '1010', 'Classroom',       50,  'Active',   'College of Arts & Sciences'),
    (5, '1020', 'Lab',             20,  'Inactive', 'College of Arts & Sciences'),
    (6, '0110', 'Classroom',       35,  'Active',   'College of Education'),
    (6, '0220', 'Conference Room', 15,  'Active',   'College of Education'),
    (7, 'LL10', 'Lab',             40,  'Active',   'Library & Information'),
    (7, '2030', 'Conference Room', 10,  'Active',   'Library & Information'),
    (9, '0100', 'Auditorium',      150, 'Active',   'University Administration'),
    (9, '0200', 'Conference Room', 25,  'Active',   'University Administration'),
    (10,'1050', 'Classroom',       55,  'Active',   'College of Arts & Sciences'),
    (10,'2020', 'Lab',             22,  'Active',   'College of Arts & Sciences');

-- ============================================================
-- CATALOG SECTIONS
-- ============================================================
INSERT INTO catalog_section (name, parent_id) VALUES ('All Equipment', NULL);
INSERT INTO catalog_section (name, parent_id) VALUES
    ('Audio', 1),('Video', 1),('Networking', 1),('Control', 1),('Computing', 1),('Power', 1);
INSERT INTO catalog_section (name, parent_id) VALUES
    ('Speakers', 2),('Amplifiers', 2),('Microphones', 2),('DSP Processors', 2),
    ('Projectors', 3),('Flat Panels', 3),('Cameras', 3),('Document Cameras', 3),
    ('Switches', 4),('Wireless APs', 4),('Touchpanels', 5),('Control Processors', 5),
    ('Computers', 6),('UPS', 7);

-- ============================================================
-- CATALOG (25 rows)
-- ============================================================
INSERT INTO catalog (section_id, manufacturer, model, status, life_expectancy_years, description) VALUES
    (12, 'Epson',    'PowerLite 685W',          'Active',       7,  'Short-throw WXGA classroom projector, 3500 lumens'),
    (12, 'Epson',    'PowerLite 990U',          'Active',       7,  'Long-throw WUXGA projector, 5000 lumens'),
    (12, 'Sony',     'VPL-PHZ10',               'Active',       8,  'Laser projector, 5000 lumens, no lamp replacement'),
    (13, 'Samsung',  'QB75R 75in Display',      'Active',       8,  'Commercial 75" 4K display for large classrooms'),
    (13, 'Samsung',  'QB55R 55in Display',      'Active',       8,  'Commercial 55" 4K display'),
    (13, 'LG',       'UL3G 65in Display',       'Discontinued', 7,  '65" Ultra Stretch display - discontinued'),
    (15, 'HoverCam', 'Solo 8Plus',              'Active',       6,  '8MP USB document camera'),
    (15, 'Epson',    'ELPDC21',                 'Active',       6,  'Document camera with HDMI output'),
    (8,  'QSC',      'AD-S4T Ceiling Speaker',  'Active',       10, 'Pendant ceiling speaker, 4" driver'),
    (8,  'QSC',      'AD-S82T Wall Speaker',    'Active',       10, 'Surface-mount speaker, 8" driver'),
    (11, 'QSC',      'Q-SYS Core 110f',         'Active',       10, 'DSP core processor, 12x8 I/O'),
    (9,  'Crown',    'CDi 2|600',               'Active',       10, '2-channel DriveCore amplifier, 600W'),
    (10, 'Shure',    'MXA910 Ceiling Array',    'Active',       10, 'Ceiling array microphone, 8 lobes'),
    (10, 'Shure',    'ULXD4 Wireless Receiver', 'Active',       8,  'Wireless microphone receiver, single channel'),
    (10, 'Shure',    'ULXD2 Handheld Tx',       'Active',       8,  'Wireless handheld transmitter'),
    (16, 'Netgear',  'GS748T 48-Port Switch',   'Active',       7,  '48-port managed gigabit switch'),
    (16, 'Netgear',  'GS724T 24-Port Switch',   'Active',       7,  '24-port managed gigabit switch'),
    (17, 'Cisco',    'Aironet 2800',            'Discontinued', 7,  'Dual-band 802.11ac Wave 2 AP'),
    (18, 'Crestron', 'TSW-770 Touchpanel',      'Active',       8,  '7" wall-mount touchpanel with NFC'),
    (19, 'Crestron', 'CP4N Control Processor',  'Active',       10, '4-Series control processor, PoE'),
    (20, 'Dell',     'OptiPlex 7090',           'Active',       5,  'Instructor desktop, i7-11700, 16GB RAM'),
    (20, 'Dell',     'OptiPlex 5090',           'Active',       5,  'Instructor desktop, i5-11500, 8GB RAM'),
    (20, 'Apple',    'Mac Mini M2',             'Active',       6,  'Mac Mini M2, 16GB RAM, 512GB SSD'),
    (14, 'Huddly',   'IQ Conference Camera',    'Active',       5,  'AI-powered 150 degree FOV conference camera'),
    (21, 'APC',      'Smart-UPS 1500VA',        'Active',       5,  'Rack-mount UPS, 1500VA, 980W');

-- ============================================================
-- ITEMS (43 rows)
-- Note: eol_date is NOT NULL in your schema so all rows include it
-- ============================================================
INSERT INTO item (catalog_id, location_id, item_code, serial_number, status, purchase_date, received_date, eol_date, mac_address) VALUES
    -- WU 0223 (location_id = 1)
    (1,  1, 'WU0223-PROJ-001', 'EPS7A291034',  'Operational', '2021-06-15', '2021-08-01', '2028-06-15', NULL),
    (19, 1, 'WU0223-CTRL-001', 'CST4N029384',  'Operational', '2021-06-15', '2021-08-01', '2031-06-15', NULL),
    (19, 1, 'WU0223-TP-001',   'CST77029001',  'Operational', '2021-06-15', '2021-08-01', '2029-06-15', NULL),
    (16, 1, 'WU0223-NET-001',  'NTG4892017',   'Operational', '2021-06-15', '2021-08-01', '2028-06-15', 'A4:B2:C3:D4:E5:F6'),
    (9,  1, 'WU0223-SPK-001',  'QSC1193847',   'Operational', '2021-06-15', '2021-08-01', '2031-06-15', NULL),
    (9,  1, 'WU0223-SPK-002',  'QSC1193848',   'Operational', '2021-06-15', '2021-08-01', '2031-06-15', NULL),
    (13, 1, 'WU0223-MIC-001',  'SHR9102847',   'Operational', '2021-06-15', '2021-08-01', '2029-06-15', NULL),
    (21, 1, 'WU0223-PC-001',   'DL7029183',    'Operational', '2021-06-15', '2021-08-01', '2026-06-15', '00:1A:2B:3C:4D:5E'),
    -- WU 0115 (location_id = 2)
    (5,  2, 'WU0115-DISP-001', 'SAM5503920',   'Operational', '2022-03-10', '2022-04-01', '2030-03-10', NULL),
    (24, 2, 'WU0115-CAM-001',  'HUD1029384',   'Operational', '2022-03-10', '2022-04-01', '2027-03-10', NULL),
    (11, 2, 'WU0115-DSP-001',  'QSC9920471',   'Operational', '2022-03-10', '2022-04-01', '2032-03-10', NULL),
    -- WU 0340 (location_id = 3)
    (2,  3, 'WU0340-PROJ-001', 'EPS9U102938',  'Operational', '2020-05-20', '2020-08-01', '2027-05-20', NULL),
    (19, 3, 'WU0340-CTRL-001', 'CST4N029002',  'Operational', '2020-05-20', '2020-08-01', '2030-05-20', NULL),
    (9,  3, 'WU0340-SPK-001',  'QSC1194001',   'Operational', '2020-05-20', '2020-08-01', '2030-05-20', NULL),
    (9,  3, 'WU0340-SPK-002',  'QSC1194002',   'Operational', '2020-05-20', '2020-08-01', '2030-05-20', NULL),
    -- AG 1040 (location_id = 5)
    (4,  5, 'AG1040-DISP-001', 'SAM7503921',   'Operational', '2020-01-10', '2020-02-01', '2028-01-10', NULL),
    (11, 5, 'AG1040-DSP-001',  'QSC9920472',   'Operational', '2020-01-10', '2020-02-01', '2030-01-10', NULL),
    (13, 5, 'AG1040-MIC-001',  'SHR9102001',   'Operational', '2020-01-10', '2020-02-01', '2030-01-10', NULL),
    (14, 5, 'AG1040-WRLS-001', 'SHR8801001',   'In Repair',   '2020-01-10', '2020-02-01', '2028-01-10', NULL),
    (15, 5, 'AG1040-WRLS-TX1', 'SHR8802001',   'In Repair',   '2020-01-10', '2020-02-01', '2028-01-10', NULL),
    -- EN 2050 (location_id = 7)
    (23, 7, 'EN2050-PC-001',   'APL2M2019283', 'Operational', '2022-09-01', '2022-09-15', '2028-09-01', '00:1A:2B:3C:4D:5F'),
    (23, 7, 'EN2050-PC-002',   'APL2M2019284', 'Operational', '2022-09-01', '2022-09-15', '2028-09-01', '00:1A:2B:3C:4D:60'),
    (17, 7, 'EN2050-NET-001',  'NTG2401920',   'Operational', '2022-09-01', '2022-09-15', '2029-09-01', 'B1:C2:D3:E4:F5:A6'),
    -- BS 0101 (location_id = 9)
    (3,  9, 'BS0101-PROJ-001', 'SNY1Z019283',  'Operational', '2019-06-01', '2019-08-01', '2027-06-01', NULL),
    (4,  9, 'BS0101-DISP-001', 'SAM7503001',   'In Repair',   '2019-03-20', '2019-04-01', '2027-03-20', NULL),
    (12, 9, 'BS0101-AMP-001',  'CRN2C600001',  'Operational', '2019-06-01', '2019-08-01', '2029-06-01', NULL),
    (11, 9, 'BS0101-DSP-001',  'QSC9920001',   'Operational', '2019-06-01', '2019-08-01', '2029-06-01', NULL),
    (16, 9, 'BS0101-NET-001',  'NTG4892100',   'Operational', '2019-06-01', '2019-08-01', '2026-06-01', 'C3:D4:E5:F6:A7:B8'),
    (25, 9, 'BS0101-UPS-001',  'APC1500V001',  'Operational', '2019-06-01', '2019-08-01', '2024-06-01', NULL),
    -- ED 0110 (location_id = 13)
    (1,  13,'ED0110-PROJ-001', 'EPS7A291100',  'Operational', '2023-01-15', '2023-02-01', '2030-01-15', NULL),
    (19, 13,'ED0110-CTRL-001', 'CST4N029500',  'Operational', '2023-01-15', '2023-02-01', '2033-01-15', NULL),
    (7,  13,'ED0110-DCAM-001', 'HVC8P001920',  'Operational', '2023-01-15', '2023-02-01', '2029-01-15', NULL),
    -- LB LL10 (location_id = 15)
    (22, 15,'LB-LL10-PC-001',  'DL5029100',    'Operational', '2021-08-01', '2021-08-15', '2026-08-01', '11:22:33:44:55:66'),
    (22, 15,'LB-LL10-PC-002',  'DL5029101',    'Operational', '2021-08-01', '2021-08-15', '2026-08-01', '11:22:33:44:55:67'),
    (5,  15,'LB-LL10-DISP-001','SAM5503001',   'Operational', '2021-08-01', '2021-08-15', '2029-08-01', NULL),
    -- OL 0100 (location_id = 17)
    (3,  17,'OL0100-PROJ-001', 'SNY1Z019001',  'Retired',     '2016-05-01', '2016-08-01', '2024-05-01', NULL),
    (4,  17,'OL0100-DISP-001', 'SAM7503100',   'Operational', '2023-05-15', '2023-08-01', '2031-05-15', NULL),
    (11, 17,'OL0100-DSP-001',  'QSC9920100',   'Operational', '2023-05-15', '2023-08-01', '2033-05-15', NULL),
    -- PH 1050 (location_id = 19)
    (1,  19,'PH1050-PROJ-001', 'EPS7A291200',  'Operational', '2022-07-01', '2022-08-01', '2029-07-01', NULL),
    (9,  19,'PH1050-SPK-001',  'QSC1194100',   'Operational', '2022-07-01', '2022-08-01', '2032-07-01', NULL),
    (8,  19,'PH1050-DCAM-001', 'ELP21001920',  'Operational', '2022-07-01', '2022-08-01', '2028-07-01', NULL),
    -- Discontinued items (needed for subquery 6.8)
    (6,  11,'CR1010-DISP-001', 'LG65UL001920', 'Operational', '2020-03-01', '2020-04-01', '2027-03-01', NULL),
    (18, 7, 'EN2050-AP-001',   'CSC2800019283','Operational', '2020-03-01', '2020-04-01', '2027-03-01', 'AA:BB:CC:DD:EE:FF');

-- ============================================================
-- STAFF (10 rows)
-- ============================================================
INSERT INTO staff (first_name, last_name, email, phone, employment_type) VALUES
    ('Janet',   'Morrison',  'jmorrison@uwyo.edu',  '307-766-0101', 'Full-Time'),
    ('Mark',    'Johnson',   'mjohnson@uwyo.edu',   '307-766-0102', 'Full-Time'),
    ('Sarah',   'Kimura',    'skimura@uwyo.edu',    '307-766-0103', 'Full-Time'),
    ('Collin',  'Davis',     'cdavis@uwyo.edu',     '307-555-0201', 'Student Employee'),
    ('Nolan',   'Berg',      'nberg@uwyo.edu',      '307-555-0202', 'Student Employee'),
    ('Abdalla', 'Elokely',   'aelokely@uwyo.edu',   '307-555-0203', 'Student Employee'),
    ('Thomas',  'Hinckley',  'thinckley@uwyo.edu',  '307-555-0204', 'Student Employee'),
    ('Nolan',   'Nachbar',   'nnachbar@uwyo.edu',   '307-555-0205', 'Student Employee'),
    ('Rachel',  'Torres',    'rtorres@uwyo.edu',    '307-766-0104', 'Full-Time'),
    ('Derek',   'Paulsen',   'dpaulsen@uwyo.edu',   '307-766-0105', 'Full-Time');

-- ============================================================
-- ROLES (4 rows)
-- ============================================================
INSERT INTO role (role_name, description) VALUES
    ('Admin',                'Full read/write access to all tables including staff and RBAC management'),
    ('Inventory Specialist', 'Can view and edit item records, retire equipment, and browse catalog'),
    ('Classroom Tech',       'Can view locations and items for assigned rooms; read-only catalog access'),
    ('Read-Only',            'View-only access to all inventory data; cannot modify any records');

-- ============================================================
-- PERMISSIONS (9 rows)
-- ============================================================
INSERT INTO permission (permission_name, description) VALUES
    ('view_item',     'View individual item records including serial numbers and dates'),
    ('edit_item',     'Edit existing item records (status, location, dates)'),
    ('retire_item',   'Change an item status to Retired'),
    ('view_catalog',  'View catalog entries and catalog section hierarchy'),
    ('edit_catalog',  'Add or modify catalog entries and sections'),
    ('view_location', 'View location and building records'),
    ('edit_location', 'Add or modify location and building records'),
    ('view_staff',    'View staff records and role assignments'),
    ('manage_staff',  'Add, edit, or deactivate staff; assign and revoke roles');

-- ============================================================
-- STAFF_ROLE (11 rows)
-- ============================================================
INSERT INTO staff_role (staff_id, role_id, assigned_date) VALUES
    (1,  1, '2020-08-15'),
    (2,  1, '2019-06-01'),
    (3,  2, '2021-01-10'),
    (4,  2, '2023-08-20'),
    (4,  3, '2023-08-20'),
    (5,  3, '2024-01-10'),
    (6,  3, '2023-08-20'),
    (7,  4, '2023-08-20'),
    (8,  4, '2023-08-20'),
    (9,  2, '2022-03-01'),
    (10, 3, '2022-03-01');

-- ============================================================
-- ROLE_PERMISSION
-- ============================================================
INSERT INTO role_permission (role_id, permission_id) VALUES
    (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),
    (2,1),(2,2),(2,3),(2,4),(2,6),
    (3,1),(3,4),(3,6),
    (4,1),(4,4),(4,6),(4,8);

-- ============================================================
-- STAFF_LOCATION (15 rows)
-- ============================================================
INSERT INTO staff_location (staff_id, location_id, assigned_date, role) VALUES
    (1,  1,  '2020-08-15', 'Primary Technician'),
    (1,  9,  '2020-08-15', 'Primary Technician'),
    (1,  17, '2020-08-15', 'Primary Technician'),
    (2,  5,  '2019-06-01', 'Primary Technician'),
    (2,  7,  '2019-06-01', 'Primary Technician'),
    (9,  13, '2022-03-01', 'Primary Technician'),
    (9,  15, '2022-03-01', 'Primary Technician'),
    (10, 19, '2022-03-01', 'Primary Technician'),
    (4,  1,  '2023-08-20', 'Primary Technician'),
    (4,  2,  '2023-08-20', 'Primary Technician'),
    (4,  3,  '2023-08-20', 'Backup'),
    (5,  3,  '2024-01-10', 'Primary Technician'),
    (5,  7,  '2024-01-10', 'Backup'),
    (6,  5,  '2023-08-20', 'Backup'),
    (10, 8,  '2022-03-01', 'Primary Technician');

-- ============================================================
-- VERIFY all tables loaded correctly
-- ============================================================
SELECT * FROM building        ORDER BY building_id;
SELECT * FROM location        ORDER BY location_id;
SELECT * FROM catalog_section ORDER BY section_id;
SELECT * FROM catalog         ORDER BY catalog_id;
SELECT * FROM item            ORDER BY item_id;
SELECT * FROM staff           ORDER BY staff_id;
SELECT * FROM role            ORDER BY role_id;
SELECT * FROM permission      ORDER BY permission_id;
SELECT * FROM staff_role      ORDER BY staff_id;
SELECT * FROM role_permission ORDER BY role_id;
SELECT * FROM staff_location  ORDER BY staff_id;

 -- ============================================================
-- 6.2 INSERT — Before/After
-- ============================================================

-- BEFORE screenshot
SELECT * FROM item WHERE item_code = 'TEST-ITEM-001';

-- Insert test item
INSERT INTO item (catalog_id, location_id, item_code, serial_number, status, purchase_date, received_date, eol_date, mac_address)
VALUES (1, 1, 'TEST-ITEM-001', 'SN-TEST-12345', 'Operational', '2026-01-15', '2026-02-01', '2031-01-15', NULL);

-- AFTER screenshot
SELECT * FROM item WHERE item_code = 'TEST-ITEM-001';


-- ============================================================
-- 6.3 SELECT — Basic Queries
-- ============================================================

SELECT * FROM building        ORDER BY building_id;
SELECT * FROM location        ORDER BY location_id;
SELECT * FROM catalog_section ORDER BY section_id;
SELECT * FROM catalog         ORDER BY catalog_id;
SELECT * FROM item            ORDER BY item_id;
SELECT * FROM staff           ORDER BY staff_id;
SELECT * FROM role            ORDER BY role_id;
SELECT * FROM permission      ORDER BY permission_id;
SELECT * FROM staff_role      ORDER BY staff_id;
SELECT * FROM role_permission ORDER BY role_id;
SELECT * FROM staff_location  ORDER BY staff_id;


-- ============================================================
-- 6.4 UPDATE — Before/After
-- ============================================================

-- BEFORE screenshot
SELECT item_id, item_code, status FROM item WHERE item_code = 'TEST-ITEM-001';

SET SQL_SAFE_UPDATES = 0;
UPDATE item SET status = 'In Repair' WHERE item_code = 'TEST-ITEM-001';
SET SQL_SAFE_UPDATES = 1;

-- AFTER screenshot
SELECT item_id, item_code, status FROM item WHERE item_code = 'TEST-ITEM-001';


-- ============================================================
-- 6.5 DELETE — Before/After
-- ============================================================

-- BEFORE screenshot
SELECT * FROM staff_location;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM staff_location;
SET SQL_SAFE_UPDATES = 1;

-- AFTER screenshot
SELECT * FROM staff_location;

-- Re-insert staff_location so JOIN queries below still work
INSERT INTO staff_location (staff_id, location_id, assigned_date, role) VALUES
    (1,  1,  '2020-08-15', 'Primary Technician'),
    (1,  9,  '2020-08-15', 'Primary Technician'),
    (1,  17, '2020-08-15', 'Primary Technician'),
    (2,  5,  '2019-06-01', 'Primary Technician'),
    (2,  7,  '2019-06-01', 'Primary Technician'),
    (9,  13, '2022-03-01', 'Primary Technician'),
    (9,  15, '2022-03-01', 'Primary Technician'),
    (10, 19, '2022-03-01', 'Primary Technician'),
    (4,  1,  '2023-08-20', 'Primary Technician'),
    (4,  2,  '2023-08-20', 'Primary Technician'),
    (4,  3,  '2023-08-20', 'Backup'),
    (5,  3,  '2024-01-10', 'Primary Technician'),
    (5,  7,  '2024-01-10', 'Backup'),
    (6,  5,  '2023-08-20', 'Backup'),
    (10, 8,  '2022-03-01', 'Primary Technician');


-- ============================================================
-- 6.6 JOIN Queries
-- ============================================================

-- Items approaching end-of-life within next 2 years
SELECT i.item_code, c.manufacturer, c.model, b.code, l.room_number, i.eol_date
FROM item i
  JOIN catalog  c ON i.catalog_id  = c.catalog_id
  JOIN location l ON i.location_id = l.location_id
  JOIN building b ON l.building_id = b.building_id
WHERE i.eol_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 2 YEAR)
  AND i.status != 'Retired'
ORDER BY i.eol_date;

-- All equipment in room WU-0223
SELECT i.item_code, c.manufacturer, c.model, i.serial_number, i.status, i.eol_date
FROM item i
  JOIN catalog  c ON i.catalog_id  = c.catalog_id
  JOIN location l ON i.location_id = l.location_id
  JOIN building b ON l.building_id = b.building_id
WHERE b.code = 'WU' AND l.room_number = '0223'
ORDER BY c.manufacturer, c.model;

-- Non-operational items across campus
SELECT i.item_code, i.status, c.manufacturer, c.model, b.code, l.room_number
FROM item i
  JOIN catalog  c ON i.catalog_id  = c.catalog_id
  JOIN location l ON i.location_id = l.location_id
  JOIN building b ON l.building_id = b.building_id
WHERE i.status != 'Operational'
ORDER BY i.status, b.code;

-- Staff permissions lookup (Collin Davis = staff_id 4)
SELECT DISTINCT s.first_name, s.last_name, p.permission_name
FROM staff s
  JOIN staff_role      sr ON s.staff_id       = sr.staff_id
  JOIN role_permission rp ON sr.role_id       = rp.role_id
  JOIN permission      p  ON rp.permission_id = p.permission_id
WHERE s.staff_id = 4
ORDER BY p.permission_name;


-- ============================================================
-- 6.7 Aggregate Functions
-- ============================================================

-- Item count by status
SELECT status, COUNT(*) AS item_count
FROM item
GROUP BY status
ORDER BY item_count DESC;

-- Item count per building
SELECT b.code AS building_code, b.full_name, COUNT(i.item_id) AS total_items
FROM building b
  JOIN location l ON b.building_id = l.building_id
  JOIN item     i ON l.location_id = i.location_id
GROUP BY b.building_id, b.code, b.full_name
ORDER BY total_items DESC;

-- Average life expectancy by catalog section
SELECT cs.name AS section_name,
       COUNT(c.catalog_id) AS model_count,
       AVG(c.life_expectancy_years) AS avg_life_expectancy_years
FROM catalog_section cs
  JOIN catalog c ON cs.section_id = c.section_id
GROUP BY cs.section_id, cs.name
ORDER BY avg_life_expectancy_years DESC;


-- ============================================================
-- 6.8 Subqueries
-- ============================================================

-- Items with discontinued catalog models
SELECT i.item_code, i.serial_number, i.status, i.eol_date
FROM item i
WHERE i.catalog_id IN (
    SELECT catalog_id FROM catalog WHERE status = 'Discontinued'
);

-- Items in above-average capacity rooms
SELECT i.item_code, c.manufacturer, c.model, l.room_number, l.capacity
FROM item i
  JOIN catalog  c ON i.catalog_id  = c.catalog_id
  JOIN location l ON i.location_id = l.location_id
WHERE l.location_id IN (
    SELECT location_id FROM location
    WHERE capacity > (SELECT AVG(capacity) FROM location)
)
ORDER BY l.capacity DESC;


-- ============================================================
-- 6.9 Views
-- ============================================================

CREATE VIEW Building_View AS
SELECT building_id, code, full_name, address FROM building;
DESC Building_View;
SELECT * FROM Building_View;

CREATE VIEW Location_View AS
SELECT location_id, building_id, room_number, type, capacity, status, owner_category FROM location;
DESC Location_View;
SELECT * FROM Location_View;

CREATE VIEW Catalog_Section_View AS
SELECT section_id, name, parent_id FROM catalog_section;
DESC Catalog_Section_View;
SELECT * FROM Catalog_Section_View;

CREATE VIEW Catalog_View AS
SELECT catalog_id, section_id, manufacturer, model, status, life_expectancy_years, description FROM catalog;
DESC Catalog_View;
SELECT * FROM Catalog_View;

CREATE VIEW Item_View AS
SELECT item_id, catalog_id, location_id, item_code, serial_number, status,
       purchase_date, received_date, eol_date, mac_address FROM item;
DESC Item_View;
SELECT * FROM Item_View;

CREATE VIEW Staff_View AS
SELECT staff_id, first_name, last_name, email, phone, employment_type FROM staff;
DESC Staff_View;
SELECT * FROM Staff_View;

CREATE VIEW Role_View AS
SELECT role_id, role_name, description FROM role;
DESC Role_View;
SELECT * FROM Role_View;

CREATE VIEW Permission_View AS
SELECT permission_id, permission_name, description FROM permission;
DESC Permission_View;
SELECT * FROM Permission_View;

CREATE VIEW Staff_Role_View AS
SELECT staff_id, role_id, assigned_date FROM staff_role;
DESC Staff_Role_View;
SELECT * FROM Staff_Role_View;

CREATE VIEW Role_Permission_View AS
SELECT role_id, permission_id FROM role_permission;
DESC Role_Permission_View;
SELECT * FROM Role_Permission_View;

CREATE VIEW Staff_Location_View AS
SELECT staff_id, location_id, assigned_date, role FROM staff_location;
DESC Staff_Location_View;
SELECT * FROM Staff_Location_View;


-- ============================================================
-- 6.10 Stored Procedure & Trigger
-- ============================================================

DELIMITER //
CREATE PROCEDURE GetRoomInventory(IN p_building_code VARCHAR(10), IN p_room VARCHAR(20))
BEGIN
    SELECT i.item_code, c.manufacturer, c.model, i.serial_number, i.status, i.eol_date
    FROM item i
      JOIN catalog  c ON i.catalog_id  = c.catalog_id
      JOIN location l ON i.location_id = l.location_id
      JOIN building b ON l.building_id = b.building_id
    WHERE b.code = p_building_code AND l.room_number = p_room
    ORDER BY c.manufacturer;
END //
DELIMITER ;

CALL GetRoomInventory('WU', '0223');

DELIMITER //
CREATE TRIGGER trg_set_eol_date
BEFORE INSERT ON item
FOR EACH ROW
BEGIN
    IF NEW.eol_date IS NULL THEN
        SET NEW.eol_date = DATE_ADD(NEW.purchase_date, INTERVAL (
            SELECT life_expectancy_years FROM catalog WHERE catalog_id = NEW.catalog_id
        ) YEAR);
    END IF;
END //
DELIMITER ;

-- Test the trigger
INSERT INTO item (catalog_id, location_id, item_code, serial_number, status, purchase_date, received_date, eol_date, mac_address)
VALUES (1, 1, 'TRIGGER-TEST-001', 'SN-TRIG-00001', 'Operational', '2026-01-01', '2026-01-15', NULL, NULL);

SELECT item_code, purchase_date, eol_date FROM item WHERE item_code = 'TRIGGER-TEST-001';

SET SQL_SAFE_UPDATES = 0;
DELETE FROM item WHERE item_code IN ('TEST-ITEM-001', 'TRIGGER-TEST-001');
SET SQL_SAFE_UPDATES = 1;


-- ============================================================
-- 6.11 Transactions
-- ============================================================

-- TRANSACTION 1: Retire an item and update technician assignment
SELECT item_code, status FROM item WHERE item_code = 'OL0100-PROJ-001';

START TRANSACTION;
UPDATE item SET status = 'Retired' WHERE item_code = 'OL0100-PROJ-001';
UPDATE staff_location SET assigned_date = CURDATE() WHERE staff_id = 1 AND location_id = 17;
COMMIT;

SELECT item_code, status FROM item WHERE item_code = 'OL0100-PROJ-001';


-- TRANSACTION 2: Assign a staff member a role and location
SELECT * FROM staff_role     WHERE staff_id = 10;
SELECT * FROM staff_location WHERE staff_id = 10;

START TRANSACTION;
INSERT INTO staff_role (staff_id, role_id, assigned_date) VALUES (10, 2, '2026-05-01');
INSERT INTO staff_location (staff_id, location_id, assigned_date, role) VALUES (10, 3, '2026-05-01', 'Primary Technician');
COMMIT;

SELECT * FROM staff_role     WHERE staff_id = 10;
SELECT * FROM staff_location WHERE staff_id = 10;

DELETE FROM staff_role WHERE staff_id = 10 AND role_id = 2;
DELETE FROM staff_location WHERE staff_id = 10 AND location_id = 3;


-- TRANSACTION 3: Move an item to a new location
SELECT item_code, location_id FROM item WHERE item_code = 'WU0223-PROJ-001';

START TRANSACTION;
UPDATE item SET location_id = 3 WHERE item_code = 'WU0223-PROJ-001';
COMMIT;

SELECT item_code, location_id FROM item WHERE item_code = 'WU0223-PROJ-001';

SET SQL_SAFE_UPDATES = 0;
UPDATE item SET location_id = 1 WHERE item_code = 'WU0223-PROJ-001';
SET SQL_SAFE_UPDATES = 1;


-- TRANSACTION 4: ROLLBACK example
SELECT item_code, status FROM item WHERE location_id = 1;

START TRANSACTION;
UPDATE item SET status = 'Retired' WHERE location_id = 1;
ROLLBACK;

SELECT item_code, status FROM item WHERE location_id = 1;


-- TRANSACTION 5: Add catalog entry and deploy item atomically
SELECT COUNT(*) AS catalog_count FROM catalog;
SELECT COUNT(*) AS item_count    FROM item;

START TRANSACTION;
INSERT INTO catalog (section_id, manufacturer, model, status, life_expectancy_years, description)
VALUES (12, 'Epson', 'PowerLite L265F', 'Active', 8, 'Laser projector, 4600 lumens');
INSERT INTO item (catalog_id, location_id, item_code, serial_number, status, purchase_date, received_date, eol_date, mac_address)
VALUES (LAST_INSERT_ID(), 1, 'WU0223-PROJ-002', 'EPS4600L001', 'Operational', '2026-05-01', '2026-05-04', '2034-05-01', NULL);
COMMIT;

SELECT * FROM catalog WHERE model = 'PowerLite L265F';
SELECT * FROM item    WHERE item_code = 'WU0223-PROJ-002';

DELETE FROM item WHERE item_code = 'WU0223-PROJ-002';

-- ============================================================
-- FULL CRUD — ALL 11 TABLES
-- ============================================================


-- ============================================================
-- BUILDING
-- ============================================================

-- SELECT all
SELECT * FROM building ORDER BY building_id;

-- SELECT specific
SELECT * FROM building WHERE code = 'WU';
SELECT building_id, code, full_name FROM building ORDER BY code;
SELECT COUNT(*) AS total_buildings FROM building;

-- INSERT
INSERT INTO building (code, full_name, address)
VALUES ('ME', 'Mechanical Engineering Building', '1500 E University Ave, Laramie, WY 82071');

-- SELECT to confirm insert
SELECT * FROM building WHERE code = 'ME';

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE building SET address = '1501 E University Ave, Laramie, WY 82071' WHERE code = 'ME';
SET SQL_SAFE_UPDATES = 1;

-- SELECT to confirm update
SELECT * FROM building WHERE code = 'ME';

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM building WHERE code = 'ME';
SET SQL_SAFE_UPDATES = 1;

-- SELECT to confirm delete
SELECT * FROM building WHERE code = 'ME';


-- ============================================================
-- LOCATION
-- ============================================================

-- SELECT all
SELECT * FROM location ORDER BY location_id;

-- SELECT specific
SELECT * FROM location WHERE building_id = 1;
SELECT * FROM location WHERE type = 'Auditorium';
SELECT * FROM location WHERE status = 'Inactive';
SELECT * FROM location WHERE capacity > 100 ORDER BY capacity DESC;
SELECT l.room_number, l.type, l.capacity, b.code AS building
FROM location l JOIN building b ON l.building_id = b.building_id
ORDER BY b.code, l.room_number;

-- INSERT
INSERT INTO location (building_id, room_number, type, capacity, status, owner_category)
VALUES (1, '0999', 'Classroom', 30, 'Active', 'Academic Affairs');

SELECT * FROM location WHERE room_number = '0999';

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE location SET capacity = 45 WHERE room_number = '0999';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM location WHERE room_number = '0999';

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM location WHERE room_number = '0999';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM location WHERE room_number = '0999';


-- ============================================================
-- CATALOG_SECTION
-- ============================================================

-- SELECT all
SELECT * FROM catalog_section ORDER BY section_id;

-- SELECT specific
SELECT * FROM catalog_section WHERE parent_id IS NULL;
SELECT * FROM catalog_section WHERE parent_id = 1;
SELECT * FROM catalog_section WHERE parent_id = 2;
SELECT child.name AS subcategory, parent.name AS category
FROM catalog_section child
LEFT JOIN catalog_section parent ON child.parent_id = parent.section_id
ORDER BY parent.name, child.name;

-- INSERT
INSERT INTO catalog_section (name, parent_id) VALUES ('Laser Projectors', 3);

SELECT * FROM catalog_section WHERE name = 'Laser Projectors';

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE catalog_section SET name = 'Laser Display Units' WHERE name = 'Laser Projectors';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM catalog_section WHERE name = 'Laser Display Units';

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM catalog_section WHERE name = 'Laser Display Units';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM catalog_section WHERE name = 'Laser Display Units';


-- ============================================================
-- CATALOG
-- ============================================================

-- SELECT all
SELECT * FROM catalog ORDER BY catalog_id;

-- SELECT specific
SELECT * FROM catalog WHERE manufacturer = 'Epson';
SELECT * FROM catalog WHERE status = 'Discontinued';
SELECT * FROM catalog WHERE life_expectancy_years >= 10;
SELECT * FROM catalog WHERE section_id = 12;
SELECT c.manufacturer, c.model, cs.name AS section
FROM catalog c JOIN catalog_section cs ON c.section_id = cs.section_id
ORDER BY cs.name, c.manufacturer;
SELECT manufacturer, COUNT(*) AS model_count
FROM catalog GROUP BY manufacturer ORDER BY model_count DESC;

-- INSERT
INSERT INTO catalog (section_id, manufacturer, model, status, life_expectancy_years, description)
VALUES (12, 'Epson', 'PowerLite L265F', 'Active', 8, 'Laser projector, 4600 lumens');

SELECT * FROM catalog WHERE model = 'PowerLite L265F';

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE catalog SET life_expectancy_years = 9 WHERE model = 'PowerLite L265F';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM catalog WHERE model = 'PowerLite L265F';

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM catalog WHERE model = 'PowerLite L265F';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM catalog WHERE model = 'PowerLite L265F';


-- ============================================================
-- ITEM
-- ============================================================

-- SELECT all
SELECT * FROM item ORDER BY item_id;

-- SELECT specific
SELECT * FROM item WHERE status = 'Operational';
SELECT * FROM item WHERE status = 'In Repair';
SELECT * FROM item WHERE status = 'Retired';
SELECT * FROM item WHERE location_id = 1;
SELECT * FROM item WHERE mac_address IS NOT NULL;
SELECT * FROM item WHERE eol_date < CURDATE() AND status != 'Retired';
SELECT * FROM item WHERE eol_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 1 YEAR);
SELECT i.item_code, i.status, c.manufacturer, c.model, b.code, l.room_number
FROM item i
  JOIN catalog  c ON i.catalog_id  = c.catalog_id
  JOIN location l ON i.location_id = l.location_id
  JOIN building b ON l.building_id = b.building_id
ORDER BY b.code, l.room_number;

-- INSERT
INSERT INTO item (catalog_id, location_id, item_code, serial_number, status, purchase_date, received_date, eol_date, mac_address)
VALUES (1, 1, 'CRUD-ITEM-001', 'SN-CRUD-12345', 'Operational', '2026-01-15', '2026-02-01', '2031-01-15', NULL);

SELECT * FROM item WHERE item_code = 'CRUD-ITEM-001';

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE item SET status = 'In Repair' WHERE item_code = 'CRUD-ITEM-001';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM item WHERE item_code = 'CRUD-ITEM-001';

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM item WHERE item_code = 'CRUD-ITEM-001';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM item WHERE item_code = 'CRUD-ITEM-001';


-- ============================================================
-- STAFF
-- ============================================================

-- SELECT all
SELECT * FROM staff ORDER BY staff_id;

-- SELECT specific
SELECT * FROM staff WHERE employment_type = 'Full-Time';
SELECT * FROM staff WHERE employment_type = 'Student Employee';
SELECT * FROM staff WHERE last_name = 'Davis';
SELECT s.first_name, s.last_name, s.employment_type, r.role_name
FROM staff s
  JOIN staff_role sr ON s.staff_id = sr.staff_id
  JOIN role r ON sr.role_id = r.role_id
ORDER BY s.last_name;
SELECT employment_type, COUNT(*) AS count FROM staff GROUP BY employment_type;

-- INSERT
INSERT INTO staff (first_name, last_name, email, phone, employment_type)
VALUES ('Alex', 'Turner', 'aturner@uwyo.edu', '307-555-0301', 'Student Employee');

SELECT * FROM staff WHERE email = 'aturner@uwyo.edu';

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE staff SET phone = '307-555-0399' WHERE email = 'aturner@uwyo.edu';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM staff WHERE email = 'aturner@uwyo.edu';

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM staff WHERE email = 'aturner@uwyo.edu';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM staff WHERE email = 'aturner@uwyo.edu';


-- ============================================================
-- ROLE
-- ============================================================

-- SELECT all
SELECT * FROM role ORDER BY role_id;

-- SELECT specific
SELECT * FROM role WHERE role_name = 'Admin';
SELECT r.role_name, COUNT(sr.staff_id) AS staff_count
FROM role r
LEFT JOIN staff_role sr ON r.role_id = sr.role_id
GROUP BY r.role_id, r.role_name
ORDER BY staff_count DESC;

-- INSERT
INSERT INTO role (role_name, description)
VALUES ('Field Technician', 'On-site technician for equipment installation and repair');

SELECT * FROM role WHERE role_name = 'Field Technician';

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE role SET description = 'On-site technician responsible for AV installation, repair, and maintenance'
WHERE role_name = 'Field Technician';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM role WHERE role_name = 'Field Technician';

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM role WHERE role_name = 'Field Technician';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM role WHERE role_name = 'Field Technician';


-- ============================================================
-- PERMISSION
-- ============================================================

-- SELECT all
SELECT * FROM permission ORDER BY permission_id;

-- SELECT specific
SELECT * FROM permission WHERE permission_name LIKE 'view%';
SELECT * FROM permission WHERE permission_name LIKE 'edit%';
SELECT p.permission_name, COUNT(rp.role_id) AS assigned_to_roles
FROM permission p
LEFT JOIN role_permission rp ON p.permission_id = rp.permission_id
GROUP BY p.permission_id, p.permission_name
ORDER BY assigned_to_roles DESC;

-- INSERT
INSERT INTO permission (permission_name, description)
VALUES ('export_report', 'Export inventory reports to CSV or PDF');

SELECT * FROM permission WHERE permission_name = 'export_report';

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE permission SET description = 'Export full inventory reports in CSV, PDF, or Excel format'
WHERE permission_name = 'export_report';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM permission WHERE permission_name = 'export_report';

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM permission WHERE permission_name = 'export_report';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM permission WHERE permission_name = 'export_report';


-- ============================================================
-- STAFF_ROLE
-- ============================================================

-- SELECT all
SELECT * FROM staff_role ORDER BY staff_id;

-- SELECT specific
SELECT * FROM staff_role WHERE role_id = 1;
SELECT s.first_name, s.last_name, r.role_name, sr.assigned_date
FROM staff_role sr
  JOIN staff s ON sr.staff_id = s.staff_id
  JOIN role  r ON sr.role_id  = r.role_id
ORDER BY r.role_name, s.last_name;
SELECT staff_id, COUNT(*) AS role_count FROM staff_role GROUP BY staff_id ORDER BY role_count DESC;

-- INSERT
INSERT INTO staff_role (staff_id, role_id, assigned_date) VALUES (10, 2, '2026-05-01');

SELECT * FROM staff_role WHERE staff_id = 10 AND role_id = 2;

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE staff_role SET assigned_date = '2026-05-04' WHERE staff_id = 10 AND role_id = 2;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM staff_role WHERE staff_id = 10 AND role_id = 2;

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM staff_role WHERE staff_id = 10 AND role_id = 2;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM staff_role WHERE staff_id = 10 AND role_id = 2;


-- ============================================================
-- ROLE_PERMISSION
-- ============================================================

-- SELECT all
SELECT * FROM role_permission ORDER BY role_id;

-- SELECT specific
SELECT * FROM role_permission WHERE role_id = 1;
SELECT r.role_name, p.permission_name
FROM role_permission rp
  JOIN role       r ON rp.role_id       = r.role_id
  JOIN permission p ON rp.permission_id = p.permission_id
ORDER BY r.role_name, p.permission_name;
SELECT role_id, COUNT(*) AS permission_count FROM role_permission GROUP BY role_id ORDER BY permission_count DESC;

-- INSERT
INSERT INTO role_permission (role_id, permission_id) VALUES (4, 2);

SELECT * FROM role_permission WHERE role_id = 4 AND permission_id = 2;

-- UPDATE (composite PK — replace the row)
SET SQL_SAFE_UPDATES = 0;
DELETE FROM role_permission WHERE role_id = 4 AND permission_id = 2;
INSERT INTO role_permission (role_id, permission_id) VALUES (4, 3);
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM role_permission WHERE role_id = 4 AND permission_id = 3;

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM role_permission WHERE role_id = 4 AND permission_id = 3;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM role_permission WHERE role_id = 4 AND permission_id = 3;


-- ============================================================
-- STAFF_LOCATION
-- ============================================================

-- SELECT all
SELECT * FROM staff_location ORDER BY staff_id;

-- SELECT specific
SELECT * FROM staff_location WHERE staff_id = 4;
SELECT * FROM staff_location WHERE location_id = 1;
SELECT * FROM staff_location WHERE role = 'Primary Technician';
SELECT s.first_name, s.last_name, b.code, l.room_number, sl.role, sl.assigned_date
FROM staff_location sl
  JOIN staff    s ON sl.staff_id    = s.staff_id
  JOIN location l ON sl.location_id = l.location_id
  JOIN building b ON l.building_id  = b.building_id
ORDER BY s.last_name, b.code;
SELECT staff_id, COUNT(*) AS location_count FROM staff_location GROUP BY staff_id ORDER BY location_count DESC;

-- INSERT
INSERT INTO staff_location (staff_id, location_id, assigned_date, role)
VALUES (10, 4, '2026-05-01', 'Backup');

SELECT * FROM staff_location WHERE staff_id = 10 AND location_id = 4;

-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE staff_location SET role = 'Primary Technician' WHERE staff_id = 10 AND location_id = 4;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM staff_location WHERE staff_id = 10 AND location_id = 4;

-- DELETE
SET SQL_SAFE_UPDATES = 0;
DELETE FROM staff_location WHERE staff_id = 10 AND location_id = 4;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM staff_location WHERE staff_id = 10 AND location_id = 4;
