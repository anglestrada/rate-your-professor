-- Table Schema for DB project, rate your professor
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    class_year INT NOT NULL,
    user_role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
    user_status ENUM('active', 'inactive', 'suspended') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME NULL,
    suspended_until DATETIME NULL,

    CONSTRAINT chk_suspended CHECK suspended_until IS NULL OR user_status = 'suspended',
    CONSTRAINT chk_over_suspended CHECK suspended_until <= NOW() OR user_status != 'suspended',
    CONSTRAINT chk_active_status CHECK last_login IS >= NOW() - INTERVAL 5 DAYS AND last_login IS <= NOW() OR user_status != 'active'
);

--Not done with this yet
CREATE TABLE IF NOT EXISTS professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    title VARCHAR(75) NOT NULL,
    department VARCHAR(100) NOT NULL,
);