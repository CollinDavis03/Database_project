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

-- 3. Catalog_Section
-- 4. Catalog
-- 5. Item

-- PERMISSIONS & ACCESS CONTROL LAYER (RBAC)
-- 6. Staff
-- 7. Role
-- 8. Permission
-- 9. Staff_Role (junction)
-- 10. Role_Permission (junction)
-- 11. Staff_Location (junction)
