-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: host.docker.internal:3306
-- Generation Time: May 19, 2025 at 07:21 AM
-- Server version: 9.3.0
-- PHP Version: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cracker-prisma`
--

-- --------------------------------------------------------

--
-- Table structure for table `wp_cracker_feature_flag`
--

CREATE TABLE `wp_cracker_feature_flag` (
  `id` int NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `required_role` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wp_cracker_feature_flag`
--

INSERT INTO `wp_cracker_feature_flag` (`id`, `name`, `description`, `is_enabled`, `required_role`) VALUES
(1, 'premiumDashboardSwitch', 'a switch that changes state from basic to premium dashboard. brings up upgrade popup for basic members', 0, NULL),
(2, 'adminDashboardMenuItem', 'option in user menu that navigates to admin dashboard', 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `wp_cracker_role_lookup`
--

CREATE TABLE `wp_cracker_role_lookup` (
  `id` int NOT NULL,
  `name` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wp_cracker_role_lookup`
--

INSERT INTO `wp_cracker_role_lookup` (`id`, `name`, `description`) VALUES
(1, 'member', 'default role. basic member. access to free features'),
(2, 'premium', 'paid member. access to premium features'),
(3, 'admin', 'administrator. access to admin only features');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `wp_cracker_feature_flag`
--
ALTER TABLE `wp_cracker_feature_flag`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `wp_cracker_feature_flag_name_key` (`name`),
  ADD KEY `wp_cracker_feature_flag_required_role_fkey` (`required_role`);

--
-- Indexes for table `wp_cracker_role_lookup`
--
ALTER TABLE `wp_cracker_role_lookup`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `wp_cracker_role_lookup_name_key` (`name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `wp_cracker_feature_flag`
--
ALTER TABLE `wp_cracker_feature_flag`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `wp_cracker_role_lookup`
--
ALTER TABLE `wp_cracker_role_lookup`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `wp_cracker_feature_flag`
--
ALTER TABLE `wp_cracker_feature_flag`
  ADD CONSTRAINT `wp_cracker_feature_flag_required_role_fkey` FOREIGN KEY (`required_role`) REFERENCES `wp_cracker_role_lookup` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
