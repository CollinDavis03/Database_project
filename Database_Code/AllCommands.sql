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
