-- user table
CREATE TABLE "user" (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_no VARCHAR(15),
    land_id INTEGER REFERENCES "address"(land_id)
);




-- Address table
CREATE TABLE "address" (
    land_id SERIAL PRIMARY KEY,
    land_no VARCHAR(255),
    street_name VARCHAR(255),
    grama_division_no VARCHAR(255)
)

-- status table
CREATE TABLE "status" (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES "user"(id),
    account_owner VARCHAR(255) REFERENCES "user"(id),
    id_check_status INTEGER CHECK (id_check_status IN (0, 1, 2, 3)) NOT NULL,
    address_check_status INTEGER CHECK (address_check_status IN (0, 1, 2, 3)) NOT NULL,
    police_check_status INTEGER CHECK (police_check_status IN (0, 1, 2, 3)) NOT NULL
);


-- Data for user table
INSERT INTO "user" (id, address, name, phone_no, gramadevision) VALUES 
('123456789V', '123, Sample Street', 'Alice', '1234567890', 'Bambalapitiya'), 
('987654321V', '456, Example Avenue', 'Bob', '9876543210', 'Bambalapitiya'), 
('456789012V', '789, Test Road', 'Charlie', '7890123456', 'Wellawatta'), 
('789012345V', '101, Dummy Lane', 'David', '1011121314', 'Wellawatta'), 
('345678901V', '202, Mock Street', 'Eva', '2021222324', 'Bambalapitiya'), 
('210987654V', '303, Fiction Road', 'Frank', '3031323334', 'Milagiriya'), 
('543210987V', '404, Imaginary Avenue', 'Grace', '4041424344', 'Wellawatta'), 
('678901234V', '505, Random Lane', 'Henry', '5051525354', 'Wellawatta'), 
('789456123V', '606, Null Street', 'Ivy', '6061626364', 'Milagiriya'), 
('321654987V', '707, Void Avenue', 'Jack', '7071727374', 'Bambalapitiya');