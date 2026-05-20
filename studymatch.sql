-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 20, 2026 at 10:40 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `studymatch`
--

-- --------------------------------------------------------

--
-- Table structure for table `matches`
--

CREATE TABLE `matches` (
  `id` int(11) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `matched_id` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` varchar(36) NOT NULL,
  `sender_id` varchar(36) NOT NULL,
  `receiver_id` varchar(36) NOT NULL,
  `content` text NOT NULL,
  `message_type` varchar(10) NOT NULL DEFAULT 'text',
  `file_url` text DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_size` bigint(20) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `otp_tokens`
--

CREATE TABLE `otp_tokens` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `otp` varchar(255) NOT NULL,
  `expires_at` int(11) NOT NULL,
  `used` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `otp_tokens`
--

INSERT INTO `otp_tokens` (`id`, `email`, `otp`, `expires_at`, `used`, `created_at`) VALUES
(6, 'villarolly08@gmail.com', '$2y$10$ijAx2eIiyYuJTXR8iSzZauQBSkuVgslrSKphQc0QdiOUGVjIUtfCO', 1778555417, 1, '2026-05-12 03:00:17'),
(9, 'socsargens@gmail.com', '$2y$10$lNQAmxIdAcZwogCYoQ8XJ.Wp03CcWWjehhplmhMKrbEF3hG7n/Jda', 1779077381, 1, '2026-05-18 03:59:41');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` int(11) NOT NULL,
  `used` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `user_id` varchar(36) NOT NULL,
  `role` varchar(20) DEFAULT 'student',
  `school` varchar(100) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `topic` varchar(100) DEFAULT NULL,
  `year_level` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `subjects` longtext DEFAULT NULL CHECK (json_valid(`subjects`)),
  `learning_styles` longtext DEFAULT NULL CHECK (json_valid(`learning_styles`)),
  `study_styles` longtext DEFAULT NULL CHECK (json_valid(`study_styles`)),
  `availability` longtext DEFAULT NULL CHECK (json_valid(`availability`)),
  `strengths` longtext DEFAULT NULL CHECK (json_valid(`strengths`)),
  `weaknesses` longtext DEFAULT NULL CHECK (json_valid(`weaknesses`)),
  `profile_photo_url` text DEFAULT NULL,
  `onboarding_complete` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `rating` decimal(3,2) DEFAULT 0.00,
  `rating_count` int(11) DEFAULT 0,
  `bio` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`user_id`, `role`, `school`, `department`, `topic`, `year_level`, `date_of_birth`, `gender`, `subjects`, `learning_styles`, `study_styles`, `availability`, `strengths`, `weaknesses`, `profile_photo_url`, `onboarding_complete`, `created_at`, `updated_at`, `rating`, `rating_count`, `bio`) VALUES
('1778554816574', 'student', 'RMMC', 'CET', NULL, NULL, '2000-01-12', 'Male', '[\"Computer Science\",\"Mathematics\"]', '[\"Visual\",\"Kinesthetic\"]', '[\"Individual\"]', '{\"Monday\":[\"Morning (6am-12pm)\"]}', '[]', '[\"Computer Science\",\"Mathematics\"]', 'profile_1778554816574_1778810067.jpeg', 1, '2026-05-12 03:00:16', '2026-05-18 03:56:55', 3.00, 1, 'Student'),
('1779076780633', 'tutor', 'RMMC', 'BSCS', NULL, NULL, '2002-01-20', 'Male', '[\"Mathematics\",\"Computer Science\",\"Statistics\"]', '[\"Visual\",\"Reading\",\"Kinesthetic\",\"Auditory\"]', '[\"Group\"]', '{\"Monday\":[\"Morning (6am-12pm)\"]}', '[\"Mathematics\",\"Computer Science\",\"Statistics\"]', '[\"Physics\",\"Chemistry\"]', 'profile_1779076780633_1779077064.jpg', 1, '2026-05-18 03:59:40', '2026-05-18 04:06:52', 3.00, 1, 'Tutor');

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `rater_id` varchar(36) NOT NULL,
  `rated_id` varchar(36) NOT NULL,
  `score` tinyint(4) NOT NULL CHECK (`score` between 1 and 5),
  `review` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`id`, `rater_id`, `rated_id`, `score`, `review`, `created_at`) VALUES
(4, '1778554816574', '1779076780633', 3, NULL, '2026-05-18 04:06:52');

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `id` varchar(36) NOT NULL,
  `uploader_id` varchar(36) NOT NULL,
  `title` varchar(200) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `author_name` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `file_type` varchar(50) DEFAULT 'pdf',
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`id`, `uploader_id`, `title`, `subject`, `description`, `author_name`, `file_name`, `file_path`, `file_type`, `uploaded_at`) VALUES
('res_6a02a9cff1dae1.67299646', '1778554816574', 'Title', 'Mathematics', 'Title sample', 'Title', '1778554816574_1778559439.pdf', 'uploads/1778554816574_1778559439.pdf', 'pdf', '2026-05-12 04:17:19');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` varchar(36) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email_verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password`, `email_verified`, `created_at`) VALUES
('1778554816574', 'Rolly', 'villarolly08@gmail.com', '$2y$10$bH.URdJgqqwQMiBUkaK9vOgHg7SC3NVwMgV1r.WwMg1khgpH2eJmq', 1, '2026-05-12 03:00:16'),
('1779076780633', 'Villaruel', 'socsargens@gmail.com', '$2y$10$zdVNCg5iQo7DUk/j66ME5.EI4OJPVI1QGhU9sPznSzYJummHWhod2', 1, '2026-05-18 03:59:40');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `matches`
--
ALTER TABLE `matches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_match` (`user_id`,`matched_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_matched_id` (`matched_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sender` (`sender_id`),
  ADD KEY `idx_receiver` (`receiver_id`),
  ADD KEY `idx_convo` (`sender_id`,`receiver_id`);

--
-- Indexes for table `otp_tokens`
--
ALTER TABLE `otp_tokens`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_rating` (`rater_id`,`rated_id`),
  ADD KEY `ratings_ibfk_2` (`rated_id`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`id`),
  ADD KEY `resources_ibfk_1` (`uploader_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `matches`
--
ALTER TABLE `matches`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `otp_tokens`
--
ALTER TABLE `otp_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`rater_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`rated_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `resources`
--
ALTER TABLE `resources`
  ADD CONSTRAINT `resources_ibfk_1` FOREIGN KEY (`uploader_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
