-- ============================================================
-- TECH SALARY TRANSPARENCY PLATFORM
-- Complete Database Schema (MySQL)
-- Database Lead: Member 4
-- ============================================================
-- This script creates all three databases with proper schema
-- separation for the microservices architecture.
-- Run this script as root user in MySQL/XAMPP.
-- ============================================================

-- ============================================================
-- 1. IDENTITY DATABASE (Used by: Member 1 - Identity Service)
-- Stores user accounts and authentication data.
-- No salary data is stored here to protect privacy.
-- ============================================================
CREATE DATABASE IF NOT EXISTS identity_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE identity_db;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(100),
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_users_email (email),
    INDEX idx_users_email (email),
    INDEX idx_users_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 2. SALARY DATABASE (Used by: Member 2 - Submission Service,
--                               Member 4 - Search Service)
-- Stores salary submissions and technology tags.
-- NO personal identity info (email, user_id) stored here.
-- ============================================================
CREATE DATABASE IF NOT EXISTS salary_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE salary_db;

-- Technology lookup table for many-to-many relationship
CREATE TABLE IF NOT EXISTS technologies (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,

    UNIQUE KEY uk_technologies_name (name),
    INDEX idx_technologies_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Main salary submissions table
CREATE TABLE IF NOT EXISTS salary_submissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'Sri Lanka',
    city VARCHAR(100),
    experience_level ENUM('JUNIOR', 'MID', 'SENIOR', 'LEAD', 'PRINCIPAL') NOT NULL,
    years_of_experience INT NOT NULL,
    gross_monthly_salary DECIMAL(15, 2) NOT NULL,
    net_monthly_salary DECIMAL(15, 2),
    currency VARCHAR(10) NOT NULL DEFAULT 'LKR',
    employment_type ENUM('FULL_TIME', 'PART_TIME', 'CONTRACT', 'FREELANCE') NOT NULL DEFAULT 'FULL_TIME',
    remote_type ENUM('ONSITE', 'HYBRID', 'REMOTE') NOT NULL DEFAULT 'ONSITE',
    additional_notes TEXT,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    upvote_count INT NOT NULL DEFAULT 0,
    downvote_count INT NOT NULL DEFAULT 0,
    vote_count INT NOT NULL DEFAULT 0 COMMENT 'Net votes = upvotes - downvotes',
    submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes for Search Service query performance
    INDEX idx_submissions_status (status),
    INDEX idx_submissions_country (country),
    INDEX idx_submissions_company (company),
    INDEX idx_submissions_job_title (job_title),
    INDEX idx_submissions_experience_level (experience_level),
    INDEX idx_submissions_employment_type (employment_type),
    INDEX idx_submissions_remote_type (remote_type),
    INDEX idx_submissions_salary (gross_monthly_salary),
    INDEX idx_submissions_submitted_at (submitted_at),
    INDEX idx_submissions_vote_count (vote_count),
    -- Composite index for common search patterns
    INDEX idx_submissions_status_country (status, country),
    INDEX idx_submissions_status_company (status, company)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Junction table for many-to-many: submissions <-> technologies
CREATE TABLE IF NOT EXISTS submission_technologies (
    submission_id BIGINT NOT NULL,
    technology_id BIGINT NOT NULL,

    PRIMARY KEY (submission_id, technology_id),
    FOREIGN KEY (submission_id) REFERENCES salary_submissions(id) ON DELETE CASCADE,
    FOREIGN KEY (technology_id) REFERENCES technologies(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 3. COMMUNITY DATABASE (Used by: Member 3 - Vote Service)
-- Stores votes and reports from logged-in users.
-- References submission_id (from salary_db) and user_id
-- (from identity_db) by value only — no cross-DB foreign keys.
-- ============================================================
CREATE DATABASE IF NOT EXISTS community_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE community_db;

-- Votes table: one vote per user per submission
CREATE TABLE IF NOT EXISTS votes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    submission_id BIGINT NOT NULL COMMENT 'References salary_db.salary_submissions.id',
    user_id BIGINT NOT NULL COMMENT 'References identity_db.users.id',
    vote_type ENUM('UPVOTE', 'DOWNVOTE') NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uk_vote_user_submission (submission_id, user_id),
    INDEX idx_votes_submission (submission_id),
    INDEX idx_votes_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reports table: one report per user per submission
CREATE TABLE IF NOT EXISTS reports (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    submission_id BIGINT NOT NULL COMMENT 'References salary_db.salary_submissions.id',
    user_id BIGINT NOT NULL COMMENT 'References identity_db.users.id',
    reason TEXT NOT NULL,
    status ENUM('PENDING', 'REVIEWED', 'DISMISSED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uk_report_user_submission (submission_id, user_id),
    INDEX idx_reports_submission (submission_id),
    INDEX idx_reports_user (user_id),
    INDEX idx_reports_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
