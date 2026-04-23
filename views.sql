-- Create Building_View
CREATE VIEW Building_View AS
SELECT building_id, code, full_name, address
FROM building;
DESC Building_View;
SELECT * FROM Building_View;

-- Create Location_View
CREATE VIEW Location_View AS
SELECT location_id, building_id, room_number, type, capacity, status, owner_category
FROM location;
DESC Location_View;
SELECT * FROM Location_View;

-- Create Catalog_Section_View
CREATE VIEW Catalog_Section_View AS
SELECT section_id, name, parent_id
FROM catalog_section;
DESC Catalog_Section_View;
SELECT * FROM Catalog_Section_View;

-- Create Catalog_View
CREATE VIEW Catalog_View AS
SELECT catalog_id, section_id, manufacturer, model, status, life_expectancy_years, description
FROM catalog;
DESC Catalog_View;
SELECT * FROM Catalog_View;

-- Create Item_View
CREATE VIEW Item_View AS
SELECT item_id, catalog_id, location_id, item_code, serial_number, status, purchase_date, received_date, eol_date, mac_address
FROM item;
DESC Item_View;
SELECT * FROM Item_View;

-- Create Staff_View
CREATE VIEW Staff_View AS
SELECT staff_id, first_name, last_name, email, phone, employment_type
FROM staff;
DESC Staff_View;
SELECT * FROM Staff_View;

-- Create Role_View
CREATE VIEW Role_View AS
SELECT role_id, role_name, description
FROM role;
DESC Role_View;
SELECT * FROM Role_View;

-- Create Permission_View
CREATE VIEW Permission_View AS
SELECT permission_id, permission_name, description
FROM permission;
DESC Permission_View;
SELECT * FROM Permission_View;

-- Create Staff_Role_View
CREATE VIEW Staff_Role_View AS
SELECT staff_id, role_id, assigned_date
FROM staff_role;
DESC Staff_Role_View;
SELECT * FROM Staff_Role_View;

-- Create Role_Permission_View
CREATE VIEW Role_Permission_View AS
SELECT role_id, permission_id
FROM role_permission;
DESC Role_Permission_View;
SELECT * FROM Role_Permission_View;

-- Create Staff_Location_View
CREATE VIEW Staff_Location_View AS
SELECT staff_id, location_id, assigned_date, role
FROM staff_location;
DESC Staff_Location_View;
SELECT * FROM Staff_Location_View;
