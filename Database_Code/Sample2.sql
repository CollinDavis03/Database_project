-- ============================================================
-- SAMPLE DATA
-- ============================================================
 
-- Buildings
INSERT INTO building (code, full_name, address) VALUES
    ('WU', 'Wilbur Knight Building',       '1000 E University Ave, Laramie, WY 82071'),
    ('AG', 'Agriculture Building',          '1400 E University Ave, Laramie, WY 82071'),
    ('EN', 'Engineering Building',          '1000 E University Ave, Laramie, WY 82071'),
    ('BS', 'Business Building',             '1000 E University Ave, Laramie, WY 82071'),
    ('CR', 'Classroom Building',            '1000 E University Ave, Laramie, WY 82071');
 
-- Locations
INSERT INTO location (building_id, room_number, type, capacity, status, owner_category) VALUES
    (1, '0223', 'Classroom',      35,  'Active', 'Academic Affairs'),
    (1, '0115', 'Conference Room', 12, 'Active', 'Academic Affairs'),
    (2, '1040', 'Classroom',      60,  'Active', 'College of Agriculture'),
    (3, '2050', 'Lab',            24,  'Active', 'College of Engineering'),
    (4, '0101', 'Auditorium',     200, 'Active', 'Business School');
 
-- Catalog Sections (top-level)
INSERT INTO catalog_section (name, parent_id) VALUES
    ('All Equipment', NULL);
 
INSERT INTO catalog_section (name, parent_id) VALUES
    ('Audio',       1),
    ('Video',       1),
    ('Networking',  1),
    ('Control',     1),
    ('Computing',   1);
 
INSERT INTO catalog_section (name, parent_id) VALUES
    ('Speakers',     2),
    ('Amplifiers',   2),
    ('Microphones',  2),
    ('Projectors',   3),
    ('Displays',     3),
    ('Switches',     4),
    ('Touchpanels',  5),
    ('Computers',    6);
 
-- Catalog entries
INSERT INTO catalog (section_id, manufacturer, model, status, life_expectancy_years, description) VALUES
    (10, 'Epson',   'PowerLite 685W',       'Active',        7,  'Short-throw classroom projector'),
    (11, 'Samsung', 'QB75R 75in Display',   'Active',        8,  'Large format flat panel display'),
    (13, 'QSC',     'Q-SYS Core 110f',      'Active',        10, 'DSP core processor for audio routing'),
    (7,  'QSC',     'AD-S4T Ceiling Spkr',  'Active',        10, 'Pendant ceiling speaker'),
    (12, 'Netgear', 'GS748T 48-Port Switch','Active',        7,  '48-port managed gigabit switch'),
    (13, 'Crestron','TSW-770 Touchpanel',   'Active',        8,  '7-inch wall mount touchpanel'),
    (9,  'Shure',   'MXA910 Ceiling Array', 'Active',        10, 'Ceiling array microphone'),
    (14, 'Dell',    'OptiPlex 7090',        'Active',        5,  'Instructor desktop computer');
 
-- Items (individual physical units)
INSERT INTO item (catalog_id, location_id, item_code, serial_number, status, purchase_date, received_date, eol_date, mac_address) VALUES
    (1, 1, 'WU0223-PROJ-001', 'X7A2901234', 'Operational', '2021-06-15', '2021-08-01', '2028-06-15', NULL),
    (6, 1, 'WU0223-CTRL-001', 'CST77029384', 'Operational', '2021-06-15', '2021-08-01', '2029-06-15', NULL),
    (5, 1, 'WU0223-NET-001',  'NTG4892017', 'Operational', '2021-06-15', '2021-08-01', '2028-06-15', 'A4:B2:C3:D4:E5:F6'),
    (2, 3, 'AG1040-DSP-001',  'QSC9920471', 'Operational', '2020-01-10', '2020-02-01', '2030-01-10', NULL),
    (8, 4, 'EN2050-PC-001',   'DL77291834', 'Operational', '2022-09-01', '2022-09-15', '2027-09-01', '00:1A:2B:3C:4D:5E'),
    (2, 5, 'BS0101-DISP-001', 'SAM4410293', 'In Repair',   '2019-03-20', '2019-04-01', '2027-03-20', NULL),
    (7, 3, 'AG1040-MIC-001',  'SHR7720193', 'Operational', '2020-01-10', '2020-02-01', '2030-01-10', NULL),
    (4, 1, 'WU0223-SPK-001',  'QSC1193847', 'Operational', '2021-06-15', '2021-08-01', '2031-06-15', NULL);
 
-- Staff
INSERT INTO staff (first_name, last_name, email, phone, employment_type) VALUES
    ('Jane',   'Smith',   'jsmith@uwyo.edu',   '307-555-0101', 'Full-Time'),
    ('Collin', 'Davis',   'cdavis@uwyo.edu',   '307-555-0102', 'Student Employee'),
    ('Nolan',  'Berg',    'nberg@uwyo.edu',    '307-555-0103', 'Student Employee'),
    ('Mark',   'Johnson', 'mjohnson@uwyo.edu', '307-555-0104', 'Full-Time');
 
-- Roles
INSERT INTO role (role_name, description) VALUES
    ('Admin',               'Full read/write access to all data'),
    ('Inventory Specialist','Can view and edit item records'),
    ('Classroom Tech',      'Can view locations and items for assigned rooms'),
    ('Read-Only',           'View-only access to all inventory data');
 
-- Permissions
INSERT INTO permission (permission_name, description) VALUES
    ('view_item',     'View individual item records'),
    ('edit_item',     'Edit existing item records'),
    ('retire_item',   'Mark items as Retired'),
    ('view_catalog',  'View catalog and catalog section records'),
    ('edit_catalog',  'Add or edit catalog entries'),
    ('view_location', 'View location and building records'),
    ('edit_location', 'Add or edit location records'),
    ('view_staff',    'View staff records'),
    ('manage_staff',  'Add, edit, or deactivate staff records');
 
-- Staff → Roles
INSERT INTO staff_role (staff_id, role_id, assigned_date) VALUES
    (1, 1, '2022-01-15'),  -- Jane Smith: Admin
    (2, 2, '2023-08-20'),  -- Collin Davis: Inventory Specialist
    (2, 3, '2023-08-20'),  -- Collin Davis: Classroom Tech
    (3, 3, '2024-01-10'),  -- Nolan Berg: Classroom Tech
    (4, 1, '2021-06-01');  -- Mark Johnson: Admin
 
-- Role → Permissions
INSERT INTO role_permission (role_id, permission_id) VALUES
    -- Admin gets everything
    (1, 1),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7),(1, 8),(1, 9),
    -- Inventory Specialist
    (2, 1),(2, 2),(2, 3),(2, 4),(2, 6),
    -- Classroom Tech
    (3, 1),(3, 4),(3, 6),
    -- Read-Only
    (4, 1),(4, 4),(4, 6),(4, 8);
 
-- Staff → Locations
INSERT INTO staff_location (staff_id, location_id, assigned_date, role) VALUES
    (2, 1, '2023-08-20', 'Primary Technician'),  -- Collin: WU 0223
    (2, 2, '2023-08-20', 'Primary Technician'),  -- Collin: WU 0115
    (3, 3, '2024-01-10', 'Primary Technician'),  -- Nolan: AG 1040
    (3, 4, '2024-01-10', 'Backup'),              -- Nolan: EN 2050
    (1, 5, '2022-01-15', 'Primary Technician');  -- Jane: BS 0101
 
-- ============================================================
-- SAMPLE QUERIES
-- ============================================================
 
-- Q1: All equipment in a specific room (WU 0223)
-- SELECT i.item_code, c.manufacturer, c.model, i.serial_number, i.status, i.eol_date
-- FROM item i
--   JOIN catalog  c ON i.catalog_id  = c.catalog_id
--   JOIN location l ON i.location_id = l.location_id
--   JOIN building b ON l.building_id = b.building_id
-- WHERE b.code = 'WU' AND l.room_number = '0223'
-- ORDER BY c.manufacturer, c.model;
 
-- Q2: Items approaching end-of-life within the next 2 years
-- SELECT i.item_code, c.manufacturer, c.model, b.code, l.room_number, i.eol_date
-- FROM item i
--   JOIN catalog  c ON i.catalog_id  = c.catalog_id
--   JOIN location l ON i.location_id = l.location_id
--   JOIN building b ON l.building_id = b.building_id
-- WHERE i.eol_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 2 YEAR)
--   AND i.status != 'Retired'
-- ORDER BY i.eol_date;
 
-- Q3: All items not in Operational status
-- SELECT i.item_code, i.status, c.manufacturer, c.model, b.code, l.room_number
-- FROM item i
--   JOIN catalog  c ON i.catalog_id  = c.catalog_id
--   JOIN location l ON i.location_id = l.location_id
--   JOIN building b ON l.building_id = b.building_id
-- WHERE i.status != 'Operational'
-- ORDER BY i.status, b.code;
 
-- Q4: Equipment count by building
-- SELECT b.code, b.full_name, COUNT(i.item_id) AS total_items
-- FROM building b
--   LEFT JOIN location l ON b.building_id = l.building_id
--   LEFT JOIN item    i ON l.location_id  = i.location_id
-- GROUP BY b.building_id, b.code, b.full_name
-- ORDER BY total_items DESC;
 
-- Q5: Full catalog section path for a given item (using self-join)
-- SELECT child.name AS subcategory, parent.name AS category
-- FROM catalog_section child
--   LEFT JOIN catalog_section parent ON child.parent_id = parent.section_id
-- ORDER BY parent.name, child.name;
 
-- Q6: Staff and their assigned locations with role
-- SELECT s.first_name, s.last_name, s.employment_type,
--        b.code, l.room_number, sl.role AS technician_role, sl.assigned_date
-- FROM staff_location sl
--   JOIN staff    s ON sl.staff_id    = s.staff_id
--   JOIN location l ON sl.location_id = l.location_id
--   JOIN building b ON l.building_id  = b.building_id
-- ORDER BY s.last_name, b.code;
 
-- Q7: All permissions granted to a staff member (via roles)
-- SELECT DISTINCT s.first_name, s.last_name, p.permission_name
-- FROM staff s
--   JOIN staff_role      sr ON s.staff_id   = sr.staff_id
--   JOIN role_permission rp ON sr.role_id   = rp.role_id
--   JOIN permission      p  ON rp.permission_id = p.permission_id
-- WHERE s.staff_id = 2
-- ORDER BY p.permission_name;
