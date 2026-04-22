CREATE DATABASE UWITSchema;
USE UWITSchema; 
DROP DATABASE UWITSchema;

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
SELECT * FROM building;

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
SELECT * FROM location;

-- 3. Catalog Section
CREATE TABLE catalog_section (
    section_id     INT           NOT NULL AUTO_INCREMENT, 
	name           VARCHAR(100)  NOT NULL, 
    parent_id      INT,
    PRIMARY KEY (section_id),
    CONSTRAINT fk_catalog_section_self FOREIGN KEY (parent_id) 
        REFERENCES catalog_section(section_id)
);
SELECT * FROM catalog_section;

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
        status IN ('Active', 'Inactive')
	)
);
SELECT * FROM catalog;

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
SELECT * FROM item;

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
SELECT * FROM staff;

-- 7. Role
CREATE TABLE role (
	role_id         INT           NOT NULL AUTO_INCREMENT, 
    role_name       VARCHAR(50)   NOT NULL, 
    description     TEXT          NOT NULL, 
    PRIMARY  KEY (role_id)
);
SELECT * FROM role;

-- 8. Permission
CREATE TABLE permission (
	permission_id   INT            NOT NULL AUTO_INCREMENT, 
    permission_name VARCHAR(50)    NOT NULL, 
    description     TEXT           NOT NULL, 
    PRIMARY KEY (permission_id)
);
SELECT * FROM permission;

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
SELECT * FROM staff_role;

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
SELECT * FROM role_permission;

-- 11. Staff_Location
CREATE TABLE staff_location (
	staff_id        INT            NOT NULL, 
    location_id     INT            NOT NULL, 
    assigned_date   DATE, 
    PRIMARY KEY (staff_id, location_id), 
    CONSTRAINT fk_staff_l FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id),
	CONSTRAINT fk_location_s FOREIGN KEY (location_id)
        REFERENCES location(location_id)
);
SELECT * FROM staff_location;
