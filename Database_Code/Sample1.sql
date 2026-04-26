-- Clear existing data in reverse dependency order
DELETE FROM staff_location;
DELETE FROM role_permission;
DELETE FROM staff_role;
DELETE FROM item;
DELETE FROM catalog;
DELETE FROM catalog_section;
DELETE FROM location;
DELETE FROM building;
DELETE FROM permission;
DELETE FROM role;
DELETE FROM staff;
 
-- Reset auto-increment counters
ALTER TABLE building        AUTO_INCREMENT = 1;
ALTER TABLE location        AUTO_INCREMENT = 1;
ALTER TABLE catalog_section AUTO_INCREMENT = 1;
ALTER TABLE catalog         AUTO_INCREMENT = 1;
ALTER TABLE item            AUTO_INCREMENT = 1;
ALTER TABLE staff           AUTO_INCREMENT = 1;
ALTER TABLE role            AUTO_INCREMENT = 1;
ALTER TABLE permission      AUTO_INCREMENT = 1;
 
-- ============================================================
-- BUILDINGS (10 rows)
-- Owner: Abdalla Elokely
-- ============================================================
INSERT INTO building (code, full_name, address) VALUES
    ('WU', 'Wilbur Knight Building',           '1000 E University Ave, Laramie, WY 82071'),
    ('AG', 'Agriculture Building',              '1400 E University Ave, Laramie, WY 82071'),
    ('EN', 'Engineering Building',              '1100 E University Ave, Laramie, WY 82071'),
    ('BS', 'Business Building',                 '1200 E University Ave, Laramie, WY 82071'),
    ('CR', 'College of Arts & Sciences',        '1600 E University Ave, Laramie, WY 82071'),
    ('ED', 'Education Building',                '1300 E University Ave, Laramie, WY 82071'),
    ('LB', 'Coe Library',                       '1000 E University Ave, Laramie, WY 82071'),
    ('HR', 'Half Acre Recreation Center',       '1700 E University Ave, Laramie, WY 82071'),
    ('OL', 'Old Main',                          '1000 E University Ave, Laramie, WY 82071'),
    ('PH', 'Physical Sciences Building',        '1000 E University Ave, Laramie, WY 82071');
 
-- ============================================================
-- LOCATIONS (20 rows)
-- Owner: Nolan Berg
-- ============================================================
INSERT INTO location (building_id, room_number, type, capacity, status, owner_category) VALUES
    -- Wilbur Knight (building_id = 1)
    (1, '0223', 'Classroom',       35,  'Active',   'Academic Affairs'),
    (1, '0115', 'Conference Room', 12,  'Active',   'Academic Affairs'),
    (1, '0340', 'Classroom',       60,  'Active',   'Academic Affairs'),
    (1, '0450', 'Lab',             24,  'Active',   'College of Engineering'),
    -- Agriculture (building_id = 2)
    (2, '1040', 'Classroom',       80,  'Active',   'College of Agriculture'),
    (2, '2010', 'Conference Room', 20,  'Active',   'College of Agriculture'),
    -- Engineering (building_id = 3)
    (3, '2050', 'Lab',             30,  'Active',   'College of Engineering'),
    (3, '3100', 'Classroom',       45,  'Active',   'College of Engineering'),
    -- Business (building_id = 4)
    (4, '0101', 'Auditorium',      200, 'Active',   'Business School'),
    (4, '0205', 'Classroom',       40,  'Active',   'Business School'),
    -- Arts & Sciences (building_id = 5)
    (5, '1010', 'Classroom',       50,  'Active',   'College of Arts & Sciences'),
    (5, '1020', 'Lab',             20,  'Inactive', 'College of Arts & Sciences'),
    -- Education (building_id = 6)
    (6, '0110', 'Classroom',       35,  'Active',   'College of Education'),
    (6, '0220', 'Conference Room', 15,  'Active',   'College of Education'),
    -- Library (building_id = 7)
    (7, 'LL10', 'Lab',             40,  'Active',   'Library & Information'),
    (7, '2030', 'Conference Room', 10,  'Active',   'Library & Information'),
    -- Old Main (building_id = 9)
    (9, '0100', 'Auditorium',      150, 'Active',   'University Administration'),
    (9, '0200', 'Conference Room', 25,  'Active',   'University Administration'),
    -- Physical Sciences (building_id = 10)
    (10,'1050', 'Classroom',       55,  'Active',   'College of Arts & Sciences'),
    (10,'2020', 'Lab',             22,  'Active',   'College of Arts & Sciences');
 
-- ============================================================
-- CATALOG SECTIONS (self-referencing hierarchy)
-- Owner: Nolan Nachbar
-- ============================================================
 
-- Level 0: Root
INSERT INTO catalog_section (name, parent_id) VALUES
    ('All Equipment', NULL);                            -- section_id = 1
 
-- Level 1: Main categories (parent = 1)
INSERT INTO catalog_section (name, parent_id) VALUES
    ('Audio',       1),                                 -- 2
    ('Video',       1),                                 -- 3
    ('Networking',  1),                                 -- 4
    ('Control',     1),                                 -- 5
    ('Computing',   1),                                 -- 6
    ('Power',       1);                                 -- 7
 
-- Level 2: Subcategories
INSERT INTO catalog_section (name, parent_id) VALUES
    ('Speakers',        2),                             -- 8
    ('Amplifiers',      2),                             -- 9
    ('Microphones',     2),                             -- 10
    ('DSP Processors',  2),                             -- 11
    ('Projectors',      3),                             -- 12
    ('Flat Panels',     3),                             -- 13
    ('Cameras',         3),                             -- 14
    ('Document Cameras',3),                             -- 15
    ('Switches',        4),                             -- 16
    ('Wireless APs',    4),                             -- 17
    ('Touchpanels',     5),                             -- 18
    ('Control Processors',5),                           -- 19
    ('Computers',       6),                             -- 20
    ('UPS',             7);                             -- 21
 
-- ============================================================
-- CATALOG (equipment models — 25 rows)
-- Owner: Thomas Hinckley
-- ============================================================
INSERT INTO catalog (section_id, manufacturer, model, status, life_expectancy_years, description) VALUES
    -- Projectors (12)
    (12, 'Epson',    'PowerLite 685W',          'Active',       7,  'Short-throw WXGA classroom projector, 3500 lumens'),
    (12, 'Epson',    'PowerLite 990U',          'Active',       7,  'Long-throw WUXGA projector, 5000 lumens'),
    (12, 'Sony',     'VPL-PHZ10',               'Active',       8,  'Laser projector, 5000 lumens, no lamp replacement'),
    -- Flat Panels (13)
    (13, 'Samsung',  'QB75R 75in Display',      'Active',       8,  'Commercial 75" 4K display for large classrooms'),
    (13, 'Samsung',  'QB55R 55in Display',      'Active',       8,  'Commercial 55" 4K display'),
    (13, 'LG',       'UL3G 65in Display',       'Discontinued', 7,  '65" Ultra Stretch display — discontinued'),
    -- Document Cameras (15)
    (15, 'HoverCam', 'Solo 8Plus',              'Active',       6,  '8MP USB document camera'),
    (15, 'Epson',    'ELPDC21',                 'Active',       6,  'Document camera with HDMI output'),
    -- Speakers (8)
    (8,  'QSC',      'AD-S4T Ceiling Speaker',  'Active',       10, 'Pendant ceiling speaker, 4" driver'),
    (8,  'QSC',      'AD-S82T Wall Speaker',    'Active',       10, 'Surface-mount speaker, 8" driver'),
    -- Amplifiers / DSP (9, 11)
    (11, 'QSC',      'Q-SYS Core 110f',         'Active',       10, 'DSP core processor, 12x8 I/O'),
    (9,  'Crown',    'CDi 2|600',               'Active',       10, '2-channel DriveCore amplifier, 600W'),
    -- Microphones (10)
    (10, 'Shure',    'MXA910 Ceiling Array',    'Active',       10, 'Ceiling array microphone, 8 lobes'),
    (10, 'Shure',    'ULXD4 Wireless Receiver', 'Active',       8,  'Wireless microphone receiver, single channel'),
    (10, 'Shure',    'ULXD2 Handheld Tx',       'Active',       8,  'Wireless handheld transmitter'),
    -- Networking (16, 17)
    (16, 'Netgear',  'GS748T 48-Port Switch',   'Active',       7,  '48-port managed gigabit switch'),
    (16, 'Netgear',  'GS724T 24-Port Switch',   'Active',       7,  '24-port managed gigabit switch'),
    (17, 'Cisco',    'Aironet 2800',            'Discontinued', 7,  'Dual-band 802.11ac Wave 2 AP'),
    -- Control (18, 19)
    (18, 'Crestron', 'TSW-770 Touchpanel',      'Active',       8,  '7" wall-mount touchpanel with NFC'),
    (19, 'Crestron', 'CP4N Control Processor',  'Active',       10, '4-Series control processor, PoE'),
    -- Computers (20)
    (20, 'Dell',     'OptiPlex 7090',           'Active',       5,  'Instructor desktop, i7-11700, 16GB RAM'),
    (20, 'Dell',     'OptiPlex 5090',           'Active',       5,  'Instructor desktop, i5-11500, 8GB RAM'),
    (20, 'Apple',    'Mac Mini M2',             'Active',       6,  'Mac Mini M2, 16GB RAM, 512GB SSD'),
    -- Cameras (14)
    (14, 'Huddly',   'IQ Conference Camera',    'Active',       5,  'AI-powered 150° FOV conference camera'),
    -- UPS (21)
    (21, 'APC',      'Smart-UPS 1500VA',        'Active',       5,  'Rack-mount UPS, 1500VA, 980W');
 
-- ============================================================
-- ITEMS (individual physical assets — 40 rows)
-- Owner: Collin Davis
-- ============================================================
INSERT INTO item (catalog_id, location_id, item_code, serial_number, status, purchase_date, received_date, eol_date, mac_address) VALUES
    -- WU 0223 (location_id = 1) — Standard classroom kit
    (1,  1, 'WU0223-PROJ-001', 'EPS7A291034',  'Operational', '2021-06-15', '2021-08-01', '2028-06-15', NULL),
    (19, 1, 'WU0223-CTRL-001', 'CST4N029384',  'Operational', '2021-06-15', '2021-08-01', '2031-06-15', NULL),
    (19, 1, 'WU0223-TP-001',   'CST77029001',  'Operational', '2021-06-15', '2021-08-01', '2029-06-15', NULL),
    (16, 1, 'WU0223-NET-001',  'NTG4892017',   'Operational', '2021-06-15', '2021-08-01', '2028-06-15', 'A4:B2:C3:D4:E5:F6'),
    (9,  1, 'WU0223-SPK-001',  'QSC1193847',   'Operational', '2021-06-15', '2021-08-01', '2031-06-15', NULL),
    (9,  1, 'WU0223-SPK-002',  'QSC1193848',   'Operational', '2021-06-15', '2021-08-01', '2031-06-15', NULL),
    (13, 1, 'WU0223-MIC-001',  'SHR9102847',   'Operational', '2021-06-15', '2021-08-01', '2029-06-15', NULL),
    (21, 1, 'WU0223-PC-001',   'DL7029183',    'Operational', '2021-06-15', '2021-08-01', '2026-06-15', '00:1A:2B:3C:4D:5E'),
 
    -- WU 0115 Conference Room (location_id = 2)
    (5,  2, 'WU0115-DISP-001', 'SAM5503920',   'Operational', '2022-03-10', '2022-04-01', '2030-03-10', NULL),
    (24, 2, 'WU0115-CAM-001',  'HUD1029384',   'Operational', '2022-03-10', '2022-04-01', '2027-03-10', NULL),
    (11, 2, 'WU0115-DSP-001',  'QSC9920471',   'Operational', '2022-03-10', '2022-04-01', '2032-03-10', NULL),
 
    -- WU 0340 (location_id = 3) — Larger classroom
    (2,  3, 'WU0340-PROJ-001', 'EPS9U102938',  'Operational', '2020-05-20', '2020-08-01', '2027-05-20', NULL),
    (19, 3, 'WU0340-CTRL-001', 'CST4N029002',  'Operational', '2020-05-20', '2020-08-01', '2030-05-20', NULL),
    (9,  3, 'WU0340-SPK-001',  'QSC1194001',   'Operational', '2020-05-20', '2020-08-01', '2030-05-20', NULL),
    (9,  3, 'WU0340-SPK-002',  'QSC1194002',   'Operational', '2020-05-20', '2020-08-01', '2030-05-20', NULL),
 
    -- AG 1040 (location_id = 5) — Large classroom
    (4,  5, 'AG1040-DISP-001', 'SAM7503921',   'Operational', '2020-01-10', '2020-02-01', '2028-01-10', NULL),
    (11, 5, 'AG1040-DSP-001',  'QSC9920472',   'Operational', '2020-01-10', '2020-02-01', '2030-01-10', NULL),
    (13, 5, 'AG1040-MIC-001',  'SHR9102001',   'Operational', '2020-01-10', '2020-02-01', '2030-01-10', NULL),
    (14, 5, 'AG1040-WRLS-001', 'SHR8801001',   'In Repair',   '2020-01-10', '2020-02-01', '2028-01-10', NULL),
    (15, 5, 'AG1040-WRLS-TX1', 'SHR8802001',   'In Repair',   '2020-01-10', '2020-02-01', '2028-01-10', NULL),
 
    -- EN 2050 Lab (location_id = 7)
    (23, 7, 'EN2050-PC-001',   'APL2M2019283', 'Operational', '2022-09-01', '2022-09-15', '2028-09-01', '00:1A:2B:3C:4D:5F'),
    (23, 7, 'EN2050-PC-002',   'APL2M2019284', 'Operational', '2022-09-01', '2022-09-15', '2028-09-01', '00:1A:2B:3C:4D:60'),
    (17, 7, 'EN2050-NET-001',  'NTG2401920',   'Operational', '2022-09-01', '2022-09-15', '2029-09-01', 'B1:C2:D3:E4:F5:A6'),
 
    -- BS 0101 Auditorium (location_id = 9)
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
 
    -- LB LL10 (location_id = 15) — Library lab
    (22, 15,'LB-LL10-PC-001',  'DL5029100',    'Operational', '2021-08-01', '2021-08-15', '2026-08-01', '11:22:33:44:55:66'),
    (22, 15,'LB-LL10-PC-002',  'DL5029101',    'Operational', '2021-08-01', '2021-08-15', '2026-08-01', '11:22:33:44:55:67'),
    (5,  15,'LB-LL10-DISP-001','SAM5503001',   'Operational', '2021-08-01', '2021-08-15', '2029-08-01', NULL),
 
    -- OL 0100 Auditorium (location_id = 17)
    (3,  17,'OL0100-PROJ-001', 'SNY1Z019001',  'Retired',     '2016-05-01', '2016-08-01', '2024-05-01', NULL),
    (4,  17,'OL0100-DISP-001', 'SAM7503100',   'Operational', '2023-05-15', '2023-08-01', '2031-05-15', NULL),
    (11, 17,'OL0100-DSP-001',  'QSC9920100',   'Operational', '2023-05-15', '2023-08-01', '2033-05-15', NULL),
 
    -- PH 1050 (location_id = 19)
    (1,  19,'PH1050-PROJ-001', 'EPS7A291200',  'Operational', '2022-07-01', '2022-08-01', '2029-07-01', NULL),
    (9,  19,'PH1050-SPK-001',  'QSC1194100',   'Operational', '2022-07-01', '2022-08-01', '2032-07-01', NULL),
    (8,  19,'PH1050-DCAM-001', 'ELP21001920',  'Operational', '2022-07-01', '2022-08-01', '2028-07-01', NULL);
 
-- ============================================================
-- STAFF (10 rows)
-- Owner: Nolan Nachbar
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
-- Owner: Abdalla Elokely
-- ============================================================
INSERT INTO role (role_name, description) VALUES
    ('Admin',                'Full read/write access to all tables including staff and RBAC management'),
    ('Inventory Specialist', 'Can view and edit item records, retire equipment, and browse catalog'),
    ('Classroom Tech',       'Can view locations and items for assigned rooms; read-only catalog access'),
    ('Read-Only',            'View-only access to all inventory data; cannot modify any records');
 
-- ============================================================
-- PERMISSIONS (9 rows)
-- Owner: Thomas Hinckley
-- ============================================================
INSERT INTO permission (permission_name, description) VALUES
    ('view_item',      'View individual item records including serial numbers and dates'),
    ('edit_item',      'Edit existing item records (status, location, dates)'),
    ('retire_item',    'Change an item status to Retired'),
    ('view_catalog',   'View catalog entries and catalog section hierarchy'),
    ('edit_catalog',   'Add or modify catalog entries and sections'),
    ('view_location',  'View location and building records'),
    ('edit_location',  'Add or modify location and building records'),
    ('view_staff',     'View staff records and role assignments'),
    ('manage_staff',   'Add, edit, or deactivate staff; assign and revoke roles');
 
-- ============================================================
-- STAFF_ROLE junction (10 rows)
-- Owner: Collin Davis
-- ============================================================
INSERT INTO staff_role (staff_id, role_id, assigned_date) VALUES
    (1,  1, '2020-08-15'),   -- Janet Morrison: Admin
    (2,  1, '2019-06-01'),   -- Mark Johnson: Admin
    (3,  2, '2021-01-10'),   -- Sarah Kimura: Inventory Specialist
    (4,  2, '2023-08-20'),   -- Collin Davis: Inventory Specialist
    (4,  3, '2023-08-20'),   -- Collin Davis: Classroom Tech
    (5,  3, '2024-01-10'),   -- Nolan Berg: Classroom Tech
    (6,  3, '2023-08-20'),   -- Abdalla Elokely: Classroom Tech
    (7,  4, '2023-08-20'),   -- Thomas Hinckley: Read-Only
    (8,  4, '2023-08-20'),   -- Nolan Nachbar: Read-Only
    (9,  2, '2022-03-01'),   -- Rachel Torres: Inventory Specialist
    (10, 3, '2022-03-01');   -- Derek Paulsen: Classroom Tech
 
-- ============================================================
-- ROLE_PERMISSION junction
-- Owner: Abdalla Elokely
-- ============================================================
INSERT INTO role_permission (role_id, permission_id) VALUES
    -- Admin (role 1): all permissions
    (1, 1),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7),(1, 8),(1, 9),
    -- Inventory Specialist (role 2)
    (2, 1),(2, 2),(2, 3),(2, 4),(2, 6),
    -- Classroom Tech (role 3)
    (3, 1),(3, 4),(3, 6),
    -- Read-Only (role 4)
    (4, 1),(4, 4),(4, 6),(4, 8);
 
-- ============================================================
-- STAFF_LOCATION junction (15 rows)
-- Owner: Whole Team
-- ============================================================
INSERT INTO staff_location (staff_id, location_id, assigned_date, role) VALUES
    -- Full-time staff cover whole buildings
    (1,  1,  '2020-08-15', 'Primary Technician'),
    (1,  9,  '2020-08-15', 'Primary Technician'),
    (1,  17, '2020-08-15', 'Primary Technician'),
    (2,  5,  '2019-06-01', 'Primary Technician'),
    (2,  7,  '2019-06-01', 'Primary Technician'),
    (9,  13, '2022-03-01', 'Primary Technician'),
    (9,  15, '2022-03-01', 'Primary Technician'),
    (10, 19, '2022-03-01', 'Primary Technician'),
    -- Student employees with scoped room assignments
    (4,  1,  '2023-08-20', 'Primary Technician'),   -- Collin: WU 0223
    (4,  2,  '2023-08-20', 'Primary Technician'),   -- Collin: WU 0115
    (4,  3,  '2023-08-20', 'Backup'),               -- Collin: WU 0340 (backup)
    (5,  3,  '2024-01-10', 'Primary Technician'),   -- Nolan B: WU 0340
    (5,  7,  '2024-01-10', 'Backup'),               -- Nolan B: EN 2050 (backup)
    (6,  5,  '2023-08-20', 'Backup'),               -- Abdalla: AG 1040 (backup)
    (10, 8,  '2022-03-01', 'Primary Technician');   -- Derek: EN 3100
