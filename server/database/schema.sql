SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS case_documents;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS cases;
DROP TABLE IF EXISTS consultation_requests;
DROP TABLE IF EXISTS lawyer_profiles;
DROP TABLE IF EXISTS users;

-- =====================================================
-- USERS
-- =====================================================

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(320) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,

    role ENUM('LAWYER', 'CLIENT') NOT NULL,
    status ENUM('ACTIVE', 'SUSPENDED') DEFAULT 'ACTIVE',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_users_email (email),
    INDEX idx_users_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- LAWYER PROFILES
-- =====================================================

CREATE TABLE lawyer_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL UNIQUE,

    bio TEXT,
    qualifications TEXT,
    experience_years INT,
    specialization VARCHAR(255),
    profile_image VARCHAR(500),
    office_address TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_lawyer_profile_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- CONSULTATION REQUESTS
-- =====================================================

CREATE TABLE consultation_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(100) NOT NULL,
    email VARCHAR(320) NOT NULL,
    phone VARCHAR(20),

    subject VARCHAR(255),
    message TEXT NOT NULL,

    status ENUM(
        'NEW',
        'REVIEWED',
        'ACCEPTED',
        'REJECTED'
    ) DEFAULT 'NEW',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_consultation_status (status),
    INDEX idx_consultation_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- CASES
-- =====================================================

CREATE TABLE cases (
    case_id INT AUTO_INCREMENT PRIMARY KEY,

    client_id INT NOT NULL,

    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,

    case_type VARCHAR(100),

    status ENUM(
        'PENDING',
        'ACTIVE',
        'ON_HOLD',
        'CLOSED'
    ) DEFAULT 'PENDING',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_case_client
        FOREIGN KEY (client_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    INDEX idx_cases_client_id (client_id),
    INDEX idx_cases_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- CASE DOCUMENTS
-- =====================================================

CREATE TABLE case_documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,

    case_id INT NOT NULL,
    uploaded_by INT NOT NULL,

    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(1000) NOT NULL,
    file_size BIGINT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_document_case
        FOREIGN KEY (case_id)
        REFERENCES cases(case_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_document_user
        FOREIGN KEY (uploaded_by)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    INDEX idx_documents_case_id (case_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- APPOINTMENTS
-- =====================================================

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,

    client_id INT NOT NULL,
    lawyer_id INT NOT NULL,

    requested_date DATETIME NOT NULL,

    status ENUM(
        'PENDING',
        'CONFIRMED',
        'RESCHEDULED',
        'CANCELLED',
        'COMPLETED'
    ) DEFAULT 'PENDING',

    notes TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_appointment_client
        FOREIGN KEY (client_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_appointment_lawyer
        FOREIGN KEY (lawyer_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    INDEX idx_appointments_client (client_id),
    INDEX idx_appointments_lawyer (lawyer_id),
    INDEX idx_appointments_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;