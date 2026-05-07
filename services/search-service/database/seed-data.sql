-- ============================================================
-- SEED DATA for Testing
-- Run this AFTER init-schema.sql
-- Inserts sample technologies, approved salary submissions,
-- and links between them.
-- ============================================================

USE salary_db;

-- ============================================================
-- Insert Technologies
-- ============================================================
INSERT INTO technologies (name) VALUES
    ('Java'),
    ('Spring Boot'),
    ('React'),
    ('Angular'),
    ('Node.js'),
    ('Python'),
    ('AWS'),
    ('Docker'),
    ('Kubernetes'),
    ('TypeScript'),
    ('MySQL'),
    ('PostgreSQL'),
    ('MongoDB'),
    ('.NET'),
    ('PHP'),
    ('Laravel'),
    ('Vue.js'),
    ('Flutter'),
    ('Go'),
    ('Terraform'),
    ('JavaScript'),
    ('C#'),
    ('Redis'),
    ('GraphQL'),
    ('Microservices');

-- ============================================================
-- Insert Salary Submissions (APPROVED status for search testing)
-- ============================================================
INSERT INTO salary_submissions
    (job_title, company, country, city, experience_level, years_of_experience,
     gross_monthly_salary, net_monthly_salary, currency, employment_type,
     remote_type, additional_notes, status, upvote_count, downvote_count, vote_count, submitted_at)
VALUES
    -- 1. WSO2 - Senior Software Engineer
    ('Senior Software Engineer', 'WSO2', 'Sri Lanka', 'Colombo', 'SENIOR', 6,
     650000.00, 520000.00, 'LKR', 'FULL_TIME', 'HYBRID',
     'Good work-life balance. Annual bonus included.', 'APPROVED', 12, 2, 10,
     '2025-01-15 10:30:00'),

    -- 2. Virtusa - Software Engineer
    ('Software Engineer', 'Virtusa', 'Sri Lanka', 'Colombo', 'MID', 3,
     280000.00, 230000.00, 'LKR', 'FULL_TIME', 'ONSITE',
     'Standard benefits package. Transport allowance.', 'APPROVED', 8, 1, 7,
     '2025-02-01 09:15:00'),

    -- 3. IFS - Tech Lead
    ('Tech Lead', 'IFS', 'Sri Lanka', 'Colombo', 'LEAD', 8,
     950000.00, 760000.00, 'LKR', 'FULL_TIME', 'HYBRID',
     'Stock options available. Great engineering culture.', 'APPROVED', 15, 3, 12,
     '2025-01-20 14:00:00'),

    -- 4. Sysco LABS - Junior Software Engineer
    ('Junior Software Engineer', 'Sysco LABS', 'Sri Lanka', 'Colombo', 'JUNIOR', 1,
     150000.00, 130000.00, 'LKR', 'FULL_TIME', 'ONSITE',
     'Good learning environment for freshers.', 'APPROVED', 6, 0, 6,
     '2025-02-10 11:45:00'),

    -- 5. 99x - Full Stack Developer
    ('Full Stack Developer', '99x', 'Sri Lanka', 'Colombo', 'MID', 4,
     350000.00, 285000.00, 'LKR', 'FULL_TIME', 'REMOTE',
     'Fully remote with flexible hours.', 'APPROVED', 10, 1, 9,
     '2025-03-05 16:20:00'),

    -- 6. Calcey Technologies - DevOps Engineer
    ('DevOps Engineer', 'Calcey Technologies', 'Sri Lanka', 'Colombo', 'SENIOR', 5,
     550000.00, 440000.00, 'LKR', 'FULL_TIME', 'HYBRID',
     'Good cloud infrastructure team.', 'APPROVED', 7, 1, 6,
     '2025-02-20 08:30:00'),

    -- 7. Zone24x7 - QA Engineer
    ('QA Engineer', 'Zone24x7', 'Sri Lanka', 'Colombo', 'MID', 3,
     220000.00, 185000.00, 'LKR', 'FULL_TIME', 'ONSITE',
     'Automation-focused QA team.', 'APPROVED', 5, 0, 5,
     '2025-03-15 13:10:00'),

    -- 8. Pearson Lanka - Data Engineer
    ('Data Engineer', 'Pearson Lanka', 'Sri Lanka', 'Colombo', 'SENIOR', 7,
     700000.00, 560000.00, 'LKR', 'FULL_TIME', 'HYBRID',
     'Big data processing with cloud-native tools.', 'APPROVED', 9, 2, 7,
     '2025-01-25 10:00:00'),

    -- 9. Cambio Software - Frontend Developer
    ('Frontend Developer', 'Cambio Software', 'Sri Lanka', 'Colombo', 'MID', 2,
     250000.00, 210000.00, 'LKR', 'FULL_TIME', 'ONSITE',
     'React-based projects. Good mentoring.', 'APPROVED', 6, 1, 5,
     '2025-02-28 15:30:00'),

    -- 10. Arimac - Principal Engineer
    ('Principal Engineer', 'Arimac', 'Sri Lanka', 'Colombo', 'PRINCIPAL', 12,
     1500000.00, 1100000.00, 'LKR', 'FULL_TIME', 'HYBRID',
     'Leadership role with architecture decisions.', 'APPROVED', 18, 4, 14,
     '2025-01-10 09:00:00'),

    -- 11. WSO2 - Junior Software Engineer
    ('Junior Software Engineer', 'WSO2', 'Sri Lanka', 'Colombo', 'JUNIOR', 0,
     120000.00, 105000.00, 'LKR', 'FULL_TIME', 'ONSITE',
     'Internship converted to full-time.', 'APPROVED', 7, 1, 6,
     '2025-03-01 10:15:00'),

    -- 12. Virtusa - Senior QA Engineer
    ('Senior QA Engineer', 'Virtusa', 'Sri Lanka', 'Colombo', 'SENIOR', 6,
     480000.00, 390000.00, 'LKR', 'FULL_TIME', 'HYBRID',
     'Test automation lead role.', 'APPROVED', 8, 0, 8,
     '2025-02-14 11:00:00'),

    -- 13. IFS - Software Engineer (Contract)
    ('Software Engineer', 'IFS', 'Sri Lanka', 'Colombo', 'MID', 4,
     400000.00, 400000.00, 'LKR', 'CONTRACT', 'REMOTE',
     'Contract role, no deductions. 6-month contract.', 'APPROVED', 11, 2, 9,
     '2025-03-10 14:45:00'),

    -- 14. Sysco LABS - Backend Developer
    ('Backend Developer', 'Sysco LABS', 'Sri Lanka', 'Colombo', 'SENIOR', 5,
     580000.00, 465000.00, 'LKR', 'FULL_TIME', 'HYBRID',
     'Microservices architecture. Java/Spring stack.', 'APPROVED', 9, 1, 8,
     '2025-01-30 12:00:00'),

    -- 15. 99x - UI/UX Engineer
    ('UI/UX Engineer', '99x', 'Sri Lanka', 'Colombo', 'MID', 3,
     300000.00, 250000.00, 'LKR', 'FULL_TIME', 'REMOTE',
     'Design-focused role with frontend work.', 'APPROVED', 5, 0, 5,
     '2025-03-20 09:30:00'),

    -- 16. Calcey Technologies - Mobile Developer
    ('Mobile Developer', 'Calcey Technologies', 'Sri Lanka', 'Colombo', 'MID', 3,
     320000.00, 265000.00, 'LKR', 'FULL_TIME', 'ONSITE',
     'Flutter cross-platform development.', 'APPROVED', 6, 0, 6,
     '2025-02-05 16:00:00'),

    -- 17. Zone24x7 - Machine Learning Engineer
    ('Machine Learning Engineer', 'Zone24x7', 'Sri Lanka', 'Colombo', 'SENIOR', 5,
     620000.00, 500000.00, 'LKR', 'FULL_TIME', 'HYBRID',
     'Computer vision and NLP projects.', 'APPROVED', 13, 2, 11,
     '2025-01-18 10:30:00'),

    -- 18. Pearson Lanka - Software Engineer (Freelance)
    ('Software Engineer', 'Pearson Lanka', 'Sri Lanka', 'Kandy', 'MID', 3,
     350000.00, 350000.00, 'LKR', 'FREELANCE', 'REMOTE',
     'Freelance contract. Working from Kandy.', 'APPROVED', 7, 1, 6,
     '2025-03-12 08:45:00'),

    -- 19. Arimac - Junior Developer
    ('Junior Developer', 'Arimac', 'Sri Lanka', 'Colombo', 'JUNIOR', 1,
     130000.00, 115000.00, 'LKR', 'FULL_TIME', 'ONSITE',
     'Good startup culture. Learning opportunities.', 'APPROVED', 5, 0, 5,
     '2025-02-22 14:15:00'),

    -- 20. WSO2 - Lead Architect
    ('Lead Architect', 'WSO2', 'Sri Lanka', 'Colombo', 'LEAD', 10,
     1100000.00, 850000.00, 'LKR', 'FULL_TIME', 'HYBRID',
     'Architecture and team leadership. Great benefits.', 'APPROVED', 20, 3, 17,
     '2025-01-05 09:00:00'),

    -- 21. PENDING submission (should NOT appear in search results)
    ('Software Engineer', 'TestCompany', 'Sri Lanka', 'Colombo', 'MID', 2,
     200000.00, 170000.00, 'LKR', 'FULL_TIME', 'ONSITE',
     'This is a pending submission for testing.', 'PENDING', 2, 0, 2,
     '2025-03-25 10:00:00'),

    -- 22. REJECTED submission (should NOT appear in search results)
    ('Developer', 'FakeCompany', 'Sri Lanka', 'Colombo', 'SENIOR', 20,
     5000000.00, 4000000.00, 'LKR', 'FULL_TIME', 'REMOTE',
     'Suspicious salary data - rejected.', 'REJECTED', 1, 15, -14,
     '2025-03-22 12:00:00');


-- ============================================================
-- Link Submissions to Technologies
-- ============================================================
-- Submission 1: WSO2 Senior SE - Java, Spring Boot, Microservices, Docker
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (1, (SELECT id FROM technologies WHERE name = 'Java')),
    (1, (SELECT id FROM technologies WHERE name = 'Spring Boot')),
    (1, (SELECT id FROM technologies WHERE name = 'Microservices')),
    (1, (SELECT id FROM technologies WHERE name = 'Docker'));

-- Submission 2: Virtusa SE - Java, Angular, MySQL
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (2, (SELECT id FROM technologies WHERE name = 'Java')),
    (2, (SELECT id FROM technologies WHERE name = 'Angular')),
    (2, (SELECT id FROM technologies WHERE name = 'MySQL'));

-- Submission 3: IFS Tech Lead - .NET, C#, AWS
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (3, (SELECT id FROM technologies WHERE name = '.NET')),
    (3, (SELECT id FROM technologies WHERE name = 'C#')),
    (3, (SELECT id FROM technologies WHERE name = 'AWS'));

-- Submission 4: Sysco LABS Junior - Java, Spring Boot, React
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (4, (SELECT id FROM technologies WHERE name = 'Java')),
    (4, (SELECT id FROM technologies WHERE name = 'Spring Boot')),
    (4, (SELECT id FROM technologies WHERE name = 'React'));

-- Submission 5: 99x Full Stack - React, Node.js, TypeScript, MongoDB
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (5, (SELECT id FROM technologies WHERE name = 'React')),
    (5, (SELECT id FROM technologies WHERE name = 'Node.js')),
    (5, (SELECT id FROM technologies WHERE name = 'TypeScript')),
    (5, (SELECT id FROM technologies WHERE name = 'MongoDB'));

-- Submission 6: Calcey DevOps - AWS, Docker, Kubernetes, Terraform
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (6, (SELECT id FROM technologies WHERE name = 'AWS')),
    (6, (SELECT id FROM technologies WHERE name = 'Docker')),
    (6, (SELECT id FROM technologies WHERE name = 'Kubernetes')),
    (6, (SELECT id FROM technologies WHERE name = 'Terraform'));

-- Submission 7: Zone24x7 QA - Java, Python
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (7, (SELECT id FROM technologies WHERE name = 'Java')),
    (7, (SELECT id FROM technologies WHERE name = 'Python'));

-- Submission 8: Pearson Data Engineer - Python, AWS, PostgreSQL
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (8, (SELECT id FROM technologies WHERE name = 'Python')),
    (8, (SELECT id FROM technologies WHERE name = 'AWS')),
    (8, (SELECT id FROM technologies WHERE name = 'PostgreSQL'));

-- Submission 9: Cambio Frontend - React, TypeScript, JavaScript
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (9, (SELECT id FROM technologies WHERE name = 'React')),
    (9, (SELECT id FROM technologies WHERE name = 'TypeScript')),
    (9, (SELECT id FROM technologies WHERE name = 'JavaScript'));

-- Submission 10: Arimac Principal - Java, Spring Boot, AWS, Kubernetes, Microservices
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (10, (SELECT id FROM technologies WHERE name = 'Java')),
    (10, (SELECT id FROM technologies WHERE name = 'Spring Boot')),
    (10, (SELECT id FROM technologies WHERE name = 'AWS')),
    (10, (SELECT id FROM technologies WHERE name = 'Kubernetes')),
    (10, (SELECT id FROM technologies WHERE name = 'Microservices'));

-- Submission 11: WSO2 Junior - Java, Spring Boot
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (11, (SELECT id FROM technologies WHERE name = 'Java')),
    (11, (SELECT id FROM technologies WHERE name = 'Spring Boot'));

-- Submission 12: Virtusa Senior QA - Java, Python, Docker
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (12, (SELECT id FROM technologies WHERE name = 'Java')),
    (12, (SELECT id FROM technologies WHERE name = 'Python')),
    (12, (SELECT id FROM technologies WHERE name = 'Docker'));

-- Submission 13: IFS Contract SE - Java, Spring Boot, AWS, Docker
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (13, (SELECT id FROM technologies WHERE name = 'Java')),
    (13, (SELECT id FROM technologies WHERE name = 'Spring Boot')),
    (13, (SELECT id FROM technologies WHERE name = 'AWS')),
    (13, (SELECT id FROM technologies WHERE name = 'Docker'));

-- Submission 14: Sysco LABS Backend - Java, Spring Boot, Microservices, Redis
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (14, (SELECT id FROM technologies WHERE name = 'Java')),
    (14, (SELECT id FROM technologies WHERE name = 'Spring Boot')),
    (14, (SELECT id FROM technologies WHERE name = 'Microservices')),
    (14, (SELECT id FROM technologies WHERE name = 'Redis'));

-- Submission 15: 99x UI/UX - React, TypeScript, Vue.js
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (15, (SELECT id FROM technologies WHERE name = 'React')),
    (15, (SELECT id FROM technologies WHERE name = 'TypeScript')),
    (15, (SELECT id FROM technologies WHERE name = 'Vue.js'));

-- Submission 16: Calcey Mobile - Flutter, TypeScript
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (16, (SELECT id FROM technologies WHERE name = 'Flutter')),
    (16, (SELECT id FROM technologies WHERE name = 'TypeScript'));

-- Submission 17: Zone24x7 ML Engineer - Python, AWS, Docker
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (17, (SELECT id FROM technologies WHERE name = 'Python')),
    (17, (SELECT id FROM technologies WHERE name = 'AWS')),
    (17, (SELECT id FROM technologies WHERE name = 'Docker'));

-- Submission 18: Pearson Freelance SE - PHP, Laravel, MySQL
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (18, (SELECT id FROM technologies WHERE name = 'PHP')),
    (18, (SELECT id FROM technologies WHERE name = 'Laravel')),
    (18, (SELECT id FROM technologies WHERE name = 'MySQL'));

-- Submission 19: Arimac Junior - React, JavaScript
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (19, (SELECT id FROM technologies WHERE name = 'React')),
    (19, (SELECT id FROM technologies WHERE name = 'JavaScript'));

-- Submission 20: WSO2 Lead Architect - Java, Spring Boot, AWS, Kubernetes, Microservices, Go
INSERT INTO submission_technologies (submission_id, technology_id) VALUES
    (20, (SELECT id FROM technologies WHERE name = 'Java')),
    (20, (SELECT id FROM technologies WHERE name = 'Spring Boot')),
    (20, (SELECT id FROM technologies WHERE name = 'AWS')),
    (20, (SELECT id FROM technologies WHERE name = 'Kubernetes')),
    (20, (SELECT id FROM technologies WHERE name = 'Microservices')),
    (20, (SELECT id FROM technologies WHERE name = 'Go'));


-- ============================================================
-- Insert sample users into identity_db (for Member 1 testing)
-- ============================================================
USE identity_db;

INSERT INTO users (email, password_hash, display_name, role) VALUES
    ('admin@techsalary.lk', '$2a$10$dummyHashForTestingPurposesOnly1234567890', 'Admin User', 'ADMIN'),
    ('user1@example.com', '$2a$10$dummyHashForTestingPurposesOnly1234567891', 'Test User 1', 'USER'),
    ('user2@example.com', '$2a$10$dummyHashForTestingPurposesOnly1234567892', 'Test User 2', 'USER'),
    ('user3@example.com', '$2a$10$dummyHashForTestingPurposesOnly1234567893', 'Test User 3', 'USER'),
    ('user4@example.com', '$2a$10$dummyHashForTestingPurposesOnly1234567894', 'Test User 4', 'USER');


-- ============================================================
-- Insert sample votes into community_db (for Member 3 testing)
-- ============================================================
USE community_db;

INSERT INTO votes (submission_id, user_id, vote_type) VALUES
    (1, 2, 'UPVOTE'),
    (1, 3, 'UPVOTE'),
    (2, 2, 'UPVOTE'),
    (2, 4, 'UPVOTE'),
    (3, 2, 'UPVOTE'),
    (3, 3, 'UPVOTE'),
    (3, 4, 'UPVOTE'),
    (5, 3, 'UPVOTE'),
    (5, 4, 'DOWNVOTE');
