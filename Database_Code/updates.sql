-- 1. Building
UPDATE building
SET address = '1001 E University Ave, Laramie, WY 82071'
WHERE building_id = 1;

-- 2. Location
UPDATE location
SET capacity = 40
WHERE location_id = 1;

-- 3. Catalog Section
UPDATE catalog_section
SET name = 'Audio/Visual Projectors'
WHERE section_id = 12;

-- 4. Catalog
UPDATE catalog
SET status = 'Inactive'
WHERE catalog_id = 3;

-- 5. Item
UPDATE item
SET status = 'In Repair'
WHERE item_id = 1;

-- 6. Staff
UPDATE staff
SET phone = '307-766-0000'
WHERE staff_id = 1;

-- 7. Role
UPDATE role
SET description = 'Full system administrator access across all modules'
WHERE role_id = 1;

-- 8. Permission
UPDATE permission
SET description = 'View all individual item records, including historical statuses'
WHERE permission_id = 1;

-- 9. Staff_Role
UPDATE staff_role
SET assigned_date = '2021-01-01'
WHERE staff_id = 1 AND role_id = 1;

-- 10. Role_Permission
-- Note: Both columns form the composite primary key, so an update modifies the key itself
UPDATE role_permission
SET permission_id = 5
WHERE role_id = 4 AND permission_id = 8;

-- 11. Staff_Location
UPDATE staff_location
SET assigned_date = '2021-01-15'
WHERE staff_id = 1 AND location_id = 1;
