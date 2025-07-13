-- CREATING A DATABASE FOR INVENTORY MANAGEMENT SYSTEM
create database Inventory
use Inventory

-- Creating the Products table
CREATE TABLE Products (
    product_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100)
);

-- Creating the Suppliers table
CREATE TABLE Suppliers (
    supplier_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    phone_number VARCHAR(15)
);

-- Creating the Inventory table
CREATE TABLE Inventory (
    inventory_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    quantity INT DEFAULT 0,
    supplier_id INT,
    last_updated DATE DEFAULT CAST(GETDATE() AS DATE),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Creating the Transactions table
CREATE TABLE Transactions (
    transaction_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    transaction_type VARCHAR(10) NOT NULL CHECK (transaction_type IN ('sale', 'purchase')),
    transaction_date DATE DEFAULT CAST(GETDATE() AS DATE),
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Inserting Data into Products Table:

INSERT INTO Products (product_name, price, category)
VALUES ('Laptop', 1200.00, 'Electronics'),
	   ('Desk Chair', 150.00, 'Furniture'),
	   ('Notebook', 2.50, 'Stationery');

-- Inserting Data into Suppliers Table:

INSERT INTO Suppliers (supplier_name, contact_email, phone_number) 
VALUES ('Tech Supplies Co.', 'contact@techsupplies.com', '1234567890'),
	   ('Office Furniture Inc.', 'support@officefurniture.com', '0987654321');

-- Inserting Data into Inventory Table:

INSERT INTO Inventory (product_id, quantity, supplier_id) 
VALUES (1, 10, 1), -- Laptop from Tech Supplies Co.
	   (2, 20, 2), -- Desk Chair from Office Furniture Inc.
	   (3, 100, 2); -- Notebook from Office Furniture Inc.

-- Inserting Data into Transactions Table:

INSERT INTO Transactions (product_id, transaction_type, quantity)
VALUES (1, 'purchase', 10), -- Purchased 10 laptops
	   (2, 'purchase', 20), -- Purchased 20 desk chairs
	   (3, 'purchase', 100); -- Purchased 100 notebooks

-- Sales transaction: selling 5 laptops
INSERT INTO Transactions (product_id, transaction_type, quantity)
VALUES (1, 'sale', 5);


