-- ==========================================================
-- BANKING MANAGEMENT SYSTEM DATABASE
-- Compatible with MySQL 8.0.46
-- ==========================================================

DROP DATABASE IF EXISTS banking_management_system;

CREATE DATABASE banking_management_system;

USE banking_management_system;

-- ==========================================================
-- BRANCH TABLE
-- ==========================================================

CREATE TABLE branch (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_code VARCHAR(20) UNIQUE NOT NULL,
    ifsc_code VARCHAR(20) UNIQUE NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10)
);

-- ==========================================================
-- ADMIN TABLE
-- ==========================================================

CREATE TABLE admin (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    mobile VARCHAR(15),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================
-- CUSTOMER TABLE
-- ==========================================================

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,

    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),

    gender ENUM('Male','Female','Other'),

    dob DATE,

    mobile VARCHAR(15) UNIQUE,

    email VARCHAR(100) UNIQUE,

    aadhaar VARCHAR(20) UNIQUE,

    pan VARCHAR(20) UNIQUE,

    address VARCHAR(255),

    city VARCHAR(50),

    state VARCHAR(50),

    pincode VARCHAR(10),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================
-- ACCOUNT TABLE
-- ==========================================================

CREATE TABLE account (

    account_number BIGINT PRIMARY KEY,

    customer_id INT NOT NULL,

    branch_id INT NOT NULL,

    account_type ENUM('Savings','Current') NOT NULL,

    balance DECIMAL(15,2) DEFAULT 0,

    opening_date DATE,

    status ENUM('Active','Frozen','Closed') DEFAULT 'Active',

    atm_pin CHAR(4),

    login_password VARCHAR(255),

    FOREIGN KEY(customer_id)
    REFERENCES customer(customer_id)
    ON DELETE CASCADE,

    FOREIGN KEY(branch_id)
    REFERENCES branch(branch_id)
);

-- ==========================================================
-- BENEFICIARY TABLE
-- ==========================================================

CREATE TABLE beneficiary (

    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,

    account_number BIGINT,

    beneficiary_account BIGINT,

    beneficiary_name VARCHAR(100),

    added_date DATE,

    FOREIGN KEY(account_number)
    REFERENCES account(account_number)
    ON DELETE CASCADE
);

-- ==========================================================
-- TRANSACTION TABLE
-- ==========================================================

CREATE TABLE transactions (

    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    account_number BIGINT,

    transaction_type ENUM(
        'Deposit',
        'Withdraw',
        'Transfer',
        'Loan',
        'FD',
        'RD'
    ),

    amount DECIMAL(15,2),

    balance_after DECIMAL(15,2),

    description VARCHAR(255),

    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(account_number)
    REFERENCES account(account_number)
);

-- ==========================================================
-- LOAN TABLE
-- ==========================================================

CREATE TABLE loan (

    loan_id INT AUTO_INCREMENT PRIMARY KEY,

    account_number BIGINT,

    loan_type ENUM(
        'Home',
        'Vehicle',
        'Education',
        'Personal'
    ),

    amount DECIMAL(15,2),

    interest_rate DECIMAL(5,2),

    tenure_months INT,

    status ENUM(
        'Pending',
        'Approved',
        'Rejected'
    ) DEFAULT 'Pending',

    applied_date DATE,

    FOREIGN KEY(account_number)
    REFERENCES account(account_number)
);

-- ==========================================================
-- FIXED DEPOSIT TABLE
-- ==========================================================

CREATE TABLE fixed_deposit (

    fd_id INT AUTO_INCREMENT PRIMARY KEY,

    account_number BIGINT,

    amount DECIMAL(15,2),

    interest_rate DECIMAL(5,2),

    tenure_months INT,

    start_date DATE,

    maturity_date DATE,

    maturity_amount DECIMAL(15,2),

    FOREIGN KEY(account_number)
    REFERENCES account(account_number)
);

-- ==========================================================
-- RECURRING DEPOSIT TABLE
-- ==========================================================

CREATE TABLE recurring_deposit (

    rd_id INT AUTO_INCREMENT PRIMARY KEY,

    account_number BIGINT,

    monthly_amount DECIMAL(15,2),

    interest_rate DECIMAL(5,2),

    tenure_months INT,

    start_date DATE,

    maturity_date DATE,

    maturity_amount DECIMAL(15,2),

    FOREIGN KEY(account_number)
    REFERENCES account(account_number)
);

-- ==========================================================
-- LOGIN HISTORY
-- ==========================================================

CREATE TABLE login_history (

    login_id INT AUTO_INCREMENT PRIMARY KEY,

    account_number BIGINT,

    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    logout_time TIMESTAMP NULL,

    ip_address VARCHAR(50),

    FOREIGN KEY(account_number)
    REFERENCES account(account_number)
);

-- ==========================================================
-- AUDIT LOG
-- ==========================================================

CREATE TABLE audit_log (

    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    admin_id INT,

    action VARCHAR(255),

    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(admin_id)
    REFERENCES admin(admin_id)
);

-- ==========================================================
-- INSERT BRANCHES
-- ==========================================================

INSERT INTO branch
(branch_name,branch_code,ifsc_code,address,city,state,pincode)

VALUES

('Main Branch','B001','BMS0001001',
'MG Road','Delhi','Delhi','110001'),

('North Branch','B002','BMS0001002',
'Civil Lines','Delhi','Delhi','110054'),

('South Branch','B003','BMS0001003',
'Saket','Delhi','Delhi','110017');

-- ==========================================================
-- INSERT DEFAULT ADMIN
-- ==========================================================

INSERT INTO admin
(username,password,full_name,mobile,email)

VALUES

(
'admin',
'admin123',
'System Administrator',
'9999999999',
'admin@bank.com'
);

-- ==========================================================
-- SAMPLE CUSTOMER
-- ==========================================================

INSERT INTO customer
(
first_name,
last_name,
gender,
dob,
mobile,
email,
aadhaar,
pan,
address,
city,
state,
pincode
)

VALUES

(
'Rahul',
'Sharma',
'Male',
'2000-02-15',
'9876543210',
'rahul@gmail.com',
'123412341234',
'ABCDE1234F',
'MG Road',
'Delhi',
'Delhi',
'110001'
);

-- ==========================================================
-- SAMPLE ACCOUNT
-- ==========================================================

INSERT INTO account
(
account_number,
customer_id,
branch_id,
account_type,
balance,
opening_date,
status,
atm_pin,
login_password
)

VALUES

(
100000000001,
1,
1,
'Savings',
50000,
CURDATE(),
'Active',
'1234',
'rahul123'
);

-- ==========================================================
-- SAMPLE TRANSACTION
-- ==========================================================

INSERT INTO transactions
(
account_number,
transaction_type,
amount,
balance_after,
description
)

VALUES

(
100000000001,
'Deposit',
50000,
50000,
'Initial Deposit'
);