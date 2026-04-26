-- ============================================================
-- UWIT Inventory Management System
-- Missing Query Screenshots
-- COSC 4820 — Database Systems | Spring 2026
-- ============================================================
 
 
-- ============================================================
-- INSERT (Before/After)
-- ============================================================
 
-- Run SELECT first to capture BEFORE screenshot
SELECT * FROM item WHERE item_code = 'TEST-ITEM-001';
 
-- Insert a new item
INSERT INTO item (catalog_id, location_id, item_code, serial_number, status, purchase_date, received_date, eol_date, mac_address)
VALUES (1, 1, 'TEST-ITEM-001', 'SN-TEST-12345', 'Operational', '2026-01-15', '2026-02-01', '2031-01-15', NULL);
 
-- Run SELECT again to capture AFTER screenshot
SELECT * FROM item WHERE item_code = 'TEST-ITEM-001';
 
 
-- ============================================================
-- UPDATE (Before/After)
-- ============================================================
 
-- Run SELECT first to capture BEFORE screenshot
SELECT item_id, item_code, status FROM item WHERE item_code = 'TEST-ITEM-001';
 
-- Update the status of the item we just inserted
SET SQL_SAFE_UPDATES = 0;
UPDATE item
SET status = 'In Repair'
WHERE item_code = 'TEST-ITEM-001';
 
-- Run SELECT again to capture AFTER screenshot
SELECT item_id, item_code, status FROM item WHERE item_code = 'TEST-ITEM-001';
 
 
-- ============================================================
-- AGGREGATE FUNCTIONS
-- ============================================================
 
-- Count of items grouped by status
SELECT status, COUNT(*) AS item_count
FROM item
GROUP BY status
ORDER BY item_count DESC;
 
-- Count of items per building
SELECT b.code AS building_code, b.full_name, COUNT(i.item_id) AS total_items
FROM building b
JOIN location l ON b.building_id = l.building_id
JOIN item i ON l.location_id = i.location_id
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
-- SUBQUERIES
-- ============================================================
 
-- Find all items whose catalog model is discontinued
SELECT i.item_code, i.serial_number, i.status, i.eol_date
FROM item i
WHERE i.catalog_id IN (
    SELECT catalog_id FROM catalog WHERE status = 'Discontinued'
);
 
-- Find all items located in rooms with capacity greater than the average
SELECT i.item_code, c.manufacturer, c.model, l.room_number, l.capacity
FROM item i
JOIN catalog c ON i.catalog_id = c.catalog_id
JOIN location l ON i.location_id = l.location_id
WHERE l.location_id IN (
    SELECT location_id FROM location
    WHERE capacity > (SELECT AVG(capacity) FROM location)
)
ORDER BY l.capacity DESC;
 
 
-- ============================================================
-- CLEANUP (run after screenshots are taken)
-- ============================================================
 
-- Remove the test item inserted above
-- DELETE FROM item WHERE item_code = 'TEST-ITEM-001';
