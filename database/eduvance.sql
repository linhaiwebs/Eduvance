-- ============================================
-- Eduvance LMS - Database Schema & Seed Data
-- MySQL 5.7+ / Compatible with Supabase (PostgreSQL adapter available)
-- Generated from Laravel Migrations
-- ============================================

-- Create Database
CREATE DATABASE IF NOT EXISTS `eduvance` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `eduvance`;

-- ============================================
-- Table: migrations (Laravel internal)
-- ============================================
CREATE TABLE IF NOT EXISTS `migrations` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `migration` varchar(255) NOT NULL,
    `batch` int NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: students
-- ============================================
DROP TABLE IF EXISTS `students`;
CREATE TABLE `students` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `username` varchar(255) NOT NULL,
    `email` varchar(255) NOT NULL,
    `password` varchar(255) NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: teachers
-- ============================================
DROP TABLE IF EXISTS `teachers`;
CREATE TABLE `teachers` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `username` varchar(255) NOT NULL,
    `email` varchar(255) NOT NULL,
    `password` varchar(255) NOT NULL,
    `role` varchar(255) NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: classes
-- ============================================
DROP TABLE IF EXISTS `classes`;
CREATE TABLE `classes` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `teacher_id` int NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: subjects
-- ============================================
DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `teacher_id` int NOT NULL,
    `class_id` int NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: lessons
-- ============================================
DROP TABLE IF EXISTS `lessons`;
CREATE TABLE `lessons` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `subject_name` varchar(255) NOT NULL,
    `subject_id` varchar(255) NOT NULL,
    `lesson_name` varchar(255) NOT NULL,
    `lesson_thumbnail` varchar(255) NOT NULL,
    `lesson_vedio_link` varchar(255) NOT NULL,
    `platform_link` varchar(255) DEFAULT 'N',
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: comments
-- ============================================
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `student_id` varchar(255) NOT NULL,
    `display_name` varchar(255) NOT NULL,
    `email_address` varchar(255) NOT NULL,
    `message` varchar(255) NOT NULL,
    `lesson_id` varchar(255) NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: contact_details
-- ============================================
DROP TABLE IF EXISTS `contact_details`;
CREATE TABLE `contact_details` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `school_name` varchar(255) NOT NULL,
    `school_address` varchar(255) NOT NULL,
    `admin_name` varchar(255) NOT NULL,
    `admin_tel` varchar(255) NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: feedback
-- ============================================
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `full_name` varchar(255) NOT NULL,
    `email_address` varchar(255) NOT NULL,
    `tel_no` varchar(255) NOT NULL,
    `message` varchar(255) NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: documents
-- ============================================
DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `document_title` varchar(255) NOT NULL,
    `class_id` varchar(255) NOT NULL,
    `lesson_id` varchar(255) NOT NULL,
    `document_name` varchar(255) NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: video_models
-- ============================================
DROP TABLE IF EXISTS `video_models`;
CREATE TABLE `video_models` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `userId` varchar(255) NOT NULL,
    `lessonId` varchar(255) NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: users (Laravel default auth)
-- ============================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `email` varchar(255) NOT NULL,
    `email_verified_at` timestamp NULL DEFAULT NULL,
    `password` varchar(255) NOT NULL,
    `remember_token` varchar(100) DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: password_resets (Laravel default auth)
-- ============================================
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets` (
    `email` varchar(255) NOT NULL,
    `token` varchar(255) NOT NULL,
    `created_at` timestamp NULL DEFAULT NULL,
    KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- SEED DATA
-- ============================================

-- Admin Teacher Account
-- Email: kamalperera@gmail.com  Password: 123
INSERT INTO `teachers` (`username`, `email`, `password`, `role`, `created_at`, `updated_at`) VALUES
('Kamal Perera', 'kamalperera@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', NOW(), NOW());

-- Student Account
-- Email: sheraanmario777@gmail.com  Password: 123
INSERT INTO `students` (`username`, `email`, `password`, `created_at`, `updated_at`) VALUES
('Chamud Sachintha', 'sheraanmario777@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NOW(), NOW());

-- Classes (Grades)
INSERT INTO `classes` (`name`, `teacher_id`, `created_at`, `updated_at`) VALUES
('Grade 6', 4, NOW(), NOW()),
('Grade 7', 4, NOW(), NOW()),
('Grade 8', 3, NOW(), NOW()),
('Grade 9', 2, NOW(), NOW()),
('Grade 10', 2, NOW(), NOW()),
('Grade 11', 1, NOW(), NOW());

-- Subjects
INSERT INTO `subjects` (`name`, `teacher_id`, `class_id`, `created_at`, `updated_at`) VALUES
('Subject 01', 1, 1, NOW(), NOW()),
('Subject 02', 1, 2, NOW(), NOW()),
('Subject 03', 2, 4, NOW(), NOW()),
('Subject 04', 3, 6, NOW(), NOW()),
('Subject 05', 4, 7, NOW(), NOW()),
('Subject 06', 4, 6, NOW(), NOW());

-- Sample Comment
INSERT INTO `comments` (`student_id`, `display_name`, `email_address`, `message`, `lesson_id`, `created_at`, `updated_at`) VALUES
('1', 'User 01', 'abv123@gmail.com', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it', '1', NOW(), NOW());

-- Sample Contact Details
INSERT INTO `contact_details` (`school_name`, `school_address`, `admin_name`, `admin_tel`, `created_at`, `updated_at`) VALUES
('Eduvance Academy', '123 Education Street, Colombo', 'Admin User', '+94-77-1234567', NOW(), NOW());

-- Record migrations
INSERT INTO `migrations` (`migration`, `batch`) VALUES
('2022_05_10_025018_create_students_table', 1),
('2022_05_10_070511_create_teachers_table', 1),
('2022_05_10_104220_create_classes_table', 1),
('2022_05_10_105452_create_lessons_table', 1),
('2022_05_10_110936_create_subjects_table', 1),
('2022_08_19_111346_create_comments_table', 1),
('2022_10_05_143212_create_contact_details_table', 1),
('2022_10_07_164556_create_feedback_table', 1),
('2022_10_18_012317_create_documents_table', 1),
('2022_10_28_162948_create_video_models_table', 1),
('2022_11_01_000000_add_platform_link_to_lessons_table', 1);
