-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: merrimate-db.cfuzllgvnind.ap-south-1.rds.amazonaws.com:3306
-- Generation Time: Oct 11, 2022 at 08:51 AM
-- Server version: 8.0.28
-- PHP Version: 8.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `merrimate`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1, 'merrimate', 'admin@merrimate.com', '$2y$10$hYoSB5ckIOl7GlwKguGxaeY7lNCQlNR6sFCrtvSkyo4i7K4MfU5Iu', '2022-06-07 03:56:27', '2022-09-10 19:40:45');

-- --------------------------------------------------------

--
-- Table structure for table `block_users`
--

CREATE TABLE `block_users` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `blocked` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `block_users`
--

INSERT INTO `block_users` (`id`, `user_id`, `blocked`, `created_at`, `updated_at`) VALUES
(32, 88, '89', '2022-09-21 07:38:22', '2022-09-21 07:38:22');

-- --------------------------------------------------------

--
-- Table structure for table `boosters`
--

CREATE TABLE `boosters` (
  `id` bigint UNSIGNED NOT NULL,
  `icon` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `boosters`
--

INSERT INTO `boosters` (`id`, `icon`, `name`, `price`, `weight`, `created_at`, `updated_at`) VALUES
(1, 'https://merrimate.com/storage/icons/ic_boost_silver.png', 'Silver', '20.00', '1', '2022-08-11 13:07:53', '2022-08-11 13:07:53'),
(2, 'https://merrimate.com/storage/icons/ic_boost_gold.png', 'Gold', '40.00', '2', '2022-08-11 13:08:59', '2022-08-11 13:08:59'),
(3, 'https://merrimate.com/storage/icons/ic_boost_platinum.png', 'Platinum', '60.00', '3', '2022-08-11 13:09:59', '2022-08-11 13:09:59'),
(4, 'https://merrimate.com/storage/icons/ic_boost_diamond.png', 'Diamond', '80.00', '4', '2022-08-11 13:10:47', '2022-08-11 13:10:47');

-- --------------------------------------------------------

--
-- Table structure for table `chat_details`
--

CREATE TABLE `chat_details` (
  `id` bigint UNSIGNED NOT NULL,
  `chat_history_id` bigint UNSIGNED NOT NULL,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_seen` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `chat_details`
--

INSERT INTO `chat_details` (`id`, `chat_history_id`, `content`, `type`, `is_seen`, `created_at`, `updated_at`) VALUES
(214, 216, 'hi', 'text', '1', '2022-09-15 15:30:01', '2022-09-26 13:04:47'),
(215, 217, 'hello', 'text', '1', '2022-09-15 15:30:17', '2022-09-26 13:45:17'),
(216, 218, 'https://merrimate.com/storage/chat/1663255982039.mp3', 'voice', '1', '2022-09-15 15:30:29', '2022-09-26 13:04:47'),
(217, 219, 'https://merrimate.com/storage/chat/IMG-20220915-WA0000.jpg', 'image', '1', '2022-09-15 15:30:56', '2022-09-26 13:04:47'),
(218, 220, 'https://merrimate.com/storage/chat/IMG-20220913-WA0039.jpg', 'image', '1', '2022-09-15 15:31:03', '2022-09-26 13:45:17'),
(219, 221, '12', 'quiz', '1', '2022-09-16 13:40:05', '2022-09-26 13:04:47'),
(220, 222, 'hii', 'text', '1', '2022-09-19 19:31:59', '2022-09-23 10:41:43'),
(221, 223, 'hello', 'text', '1', '2022-09-19 19:32:09', '2022-09-19 20:11:23'),
(222, 224, 'https://merrimate.com/storage/chat/Screenshot_2022-09-15-16-13-20-281_com.instagram.android.jpg', 'image', '1', '2022-09-19 19:32:18', '2022-09-23 10:41:43'),
(223, 225, 'https://merrimate.com/storage/chat/1663615945323.mp3', 'voice', '1', '2022-09-19 19:32:29', '2022-09-23 10:41:43'),
(224, 226, 'hello', 'text', '1', '2022-09-19 19:33:53', '2022-09-19 20:11:23'),
(225, 227, '14', 'quiz', '1', '2022-09-19 19:41:04', '2022-09-23 10:41:43'),
(226, 228, 'hello', 'text', '1', '2022-09-19 19:50:54', '2022-09-19 20:11:23'),
(227, 229, 'hello', 'text', '1', '2022-09-19 20:02:15', '2022-09-23 10:41:43'),
(228, 230, 'hii', 'text', '1', '2022-09-20 15:48:07', '2022-09-26 13:45:17'),
(229, 231, 'testing', 'text', '1', '2022-09-20 15:48:19', '2022-09-26 13:45:17'),
(230, 232, 'hello', 'text', '1', '2022-09-21 07:22:40', '2022-09-21 07:38:43'),
(231, 233, 'fjxr', 'text', '1', '2022-09-21 07:22:57', '2022-09-21 07:38:43'),
(232, 234, 'HDD', 'text', '1', '2022-09-21 07:23:07', '2022-09-21 07:38:43'),
(233, 235, 'HDD', 'text', '1', '2022-09-21 07:23:11', '2022-09-21 07:38:43'),
(234, 236, 'hello', 'text', '1', '2022-09-21 07:29:26', '2022-09-21 07:38:43'),
(235, 237, 'https://merrimate.com/storage/chat/2022-09-03.16.12.055.jpg', 'image', '1', '2022-09-21 07:30:46', '2022-09-21 07:38:43'),
(236, 238, 'hello', 'text', '1', '2022-09-23 10:41:52', '2022-09-23 10:42:01'),
(237, 239, 'hello', 'text', '1', '2022-09-23 10:42:00', '2022-09-23 10:42:32'),
(238, 240, 'hello', 'text', '1', '2022-09-26 12:40:40', '2022-09-26 13:45:17');

-- --------------------------------------------------------

--
-- Table structure for table `chat_histories`
--

CREATE TABLE `chat_histories` (
  `id` bigint UNSIGNED NOT NULL,
  `sender_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `chat_histories`
--

INSERT INTO `chat_histories` (`id`, `sender_id`, `user_id`, `created_at`, `updated_at`) VALUES
(216, '83', 84, '2022-09-15 15:30:01', '2022-09-15 15:30:01'),
(217, '84', 83, '2022-09-15 15:30:17', '2022-09-15 15:30:17'),
(218, '83', 84, '2022-09-15 15:30:29', '2022-09-15 15:30:29'),
(219, '83', 84, '2022-09-15 15:30:56', '2022-09-15 15:30:56'),
(220, '84', 83, '2022-09-15 15:31:03', '2022-09-15 15:31:03'),
(221, '83', 84, '2022-09-16 13:40:05', '2022-09-16 13:40:05'),
(222, '86', 85, '2022-09-19 19:31:59', '2022-09-19 19:31:59'),
(223, '85', 86, '2022-09-19 19:32:09', '2022-09-19 19:32:09'),
(224, '86', 85, '2022-09-19 19:32:18', '2022-09-19 19:32:18'),
(225, '86', 85, '2022-09-19 19:32:29', '2022-09-19 19:32:29'),
(226, '85', 86, '2022-09-19 19:33:53', '2022-09-19 19:33:53'),
(227, '86', 85, '2022-09-19 19:41:04', '2022-09-19 19:41:04'),
(228, '85', 86, '2022-09-19 19:50:54', '2022-09-19 19:50:54'),
(229, '86', 85, '2022-09-19 20:02:15', '2022-09-19 20:02:15'),
(230, '84', 83, '2022-09-20 15:48:07', '2022-09-20 15:48:07'),
(231, '84', 83, '2022-09-20 15:48:19', '2022-09-20 15:48:19'),
(232, '88', 89, '2022-09-21 07:22:40', '2022-09-21 07:22:40'),
(233, '88', 89, '2022-09-21 07:22:57', '2022-09-21 07:22:57'),
(234, '88', 89, '2022-09-21 07:23:07', '2022-09-21 07:23:07'),
(235, '88', 89, '2022-09-21 07:23:11', '2022-09-21 07:23:11'),
(236, '88', 89, '2022-09-21 07:29:26', '2022-09-21 07:29:26'),
(237, '88', 89, '2022-09-21 07:30:46', '2022-09-21 07:30:46'),
(238, '90', 85, '2022-09-23 10:41:52', '2022-09-23 10:41:52'),
(239, '85', 90, '2022-09-23 10:42:00', '2022-09-23 10:42:00'),
(240, '84', 83, '2022-09-26 12:40:40', '2022-09-26 12:40:40');

-- --------------------------------------------------------

--
-- Table structure for table `coin_histories`
--

CREATE TABLE `coin_histories` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `send_to` bigint UNSIGNED NOT NULL,
  `coins_send` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coin_histories`
--

INSERT INTO `coin_histories` (`id`, `user_id`, `send_to`, `coins_send`, `created_at`, `updated_at`) VALUES
(24, 80, 79, '12', '2022-09-14 08:38:13', '2022-09-14 08:38:13'),
(25, 85, 86, '50', '2022-09-19 19:48:52', '2022-09-19 19:48:52'),
(26, 83, 84, '1000', '2022-09-20 12:55:14', '2022-09-20 12:55:14'),
(27, 83, 84, '500', '2022-09-20 12:55:39', '2022-09-20 12:55:39');

-- --------------------------------------------------------

--
-- Table structure for table `coin_packages`
--

CREATE TABLE `coin_packages` (
  `id` bigint UNSIGNED NOT NULL,
  `coins` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coin_packages`
--

INSERT INTO `coin_packages` (`id`, `coins`, `price`, `created_at`, `updated_at`) VALUES
(2, '1000', '50.00', '2022-06-18 07:34:40', '2022-06-18 07:34:40'),
(3, '3000', '80.00', '2022-06-18 07:35:17', '2022-06-18 07:35:17'),
(5, '5000', '100.00', '2022-08-02 13:45:44', '2022-08-02 13:45:44'),
(6, '8000', '120.00', '2022-08-02 13:47:33', '2022-08-02 13:47:33'),
(7, '10000', '150.00', '2022-08-02 13:47:53', '2022-08-02 13:47:53');

-- --------------------------------------------------------

--
-- Table structure for table `coin_wallets`
--

CREATE TABLE `coin_wallets` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `total_coins` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coin_wallets`
--

INSERT INTO `coin_wallets` (`id`, `user_id`, `total_coins`, `created_at`, `updated_at`) VALUES
(24, 76, '150', '2022-09-08 09:53:19', '2022-09-10 20:08:46'),
(26, 78, '0', '2022-09-09 11:20:16', '2022-09-09 11:20:16'),
(27, 79, '12', '2022-09-09 11:23:43', '2022-09-14 08:38:13'),
(28, 80, '38', '2022-09-09 11:35:02', '2022-09-14 08:38:13'),
(31, 83, '5600', '2022-09-15 14:55:36', '2022-09-20 13:14:03'),
(32, 84, '1550', '2022-09-15 14:57:47', '2022-09-20 15:49:34'),
(33, 85, '50', '2022-09-19 19:25:21', '2022-10-03 20:24:39'),
(34, 86, '100', '2022-09-19 19:31:13', '2022-09-19 19:49:28'),
(35, 87, '0', '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(36, 88, '0', '2022-09-21 07:14:46', '2022-09-21 07:14:46'),
(37, 89, '0', '2022-09-21 07:18:58', '2022-09-21 07:18:58'),
(38, 90, '0', '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(39, 91, '50', '2022-09-23 18:39:26', '2022-10-03 20:27:14'),
(40, 92, '0', '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(41, 93, '0', '2022-10-04 08:21:38', '2022-10-04 08:21:38');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gifts`
--

CREATE TABLE `gifts` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `main_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `gifts`
--

INSERT INTO `gifts` (`id`, `name`, `description`, `price`, `main_img`, `quantity`, `created_at`, `updated_at`) VALUES
(25, 'theta 432', 'test', '28', 'https://merrimate.com/storage/gift/1662460167_Amal Law Associates.png', '12', '2022-09-06 10:29:27', '2022-09-06 10:29:27'),
(31, 'test', 'test', '150', 'https://merrimate.com/storage/gift/1663616562_WhatsApp Image 2022-09-06 at 7.07.06 PM.jpeg', '9', '2022-09-19 19:42:42', '2022-09-19 19:42:42');

-- --------------------------------------------------------

--
-- Table structure for table `gift_images`
--

CREATE TABLE `gift_images` (
  `id` bigint UNSIGNED NOT NULL,
  `gift_id` bigint UNSIGNED NOT NULL,
  `images` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `gift_images`
--

INSERT INTO `gift_images` (`id`, `gift_id`, `images`, `created_at`, `updated_at`) VALUES
(46, 25, 'https://merrimate.com/storage/gift/1662460167_WhatsApp Image 2022-08-26 at 1.39.43 PM.jpeg', '2022-09-06 10:29:27', '2022-09-06 10:29:27'),
(47, 25, 'https://merrimate.com/storage/gift/1662460167_p1fpculh981n9ch141ik813mo9qg3.png', '2022-09-06 10:29:27', '2022-09-06 10:29:27'),
(48, 25, 'https://merrimate.com/storage/gift/1662460167_Logo-02.jpg', '2022-09-06 10:29:27', '2022-09-06 10:29:27'),
(59, 31, 'https://merrimate.com/storage/gift/1663616562_elf-bar-lost-mary-bm600-disposable-vape-pod-box-of-10-wolfvapescouk-triple-mango-585864_650x.webp', '2022-09-19 19:42:42', '2022-09-19 19:42:42'),
(60, 31, 'https://merrimate.com/storage/gift/1663616562_elf-bar-lost-mary-bm600-disposable-vape-pod-box-of-10-wolfvapescouk-blue-razz-ice-253624_1800x1800.webp', '2022-09-19 19:42:42', '2022-09-19 19:42:42');

-- --------------------------------------------------------

--
-- Table structure for table `gift_variants`
--

CREATE TABLE `gift_variants` (
  `id` bigint UNSIGNED NOT NULL,
  `gift_id` bigint UNSIGNED NOT NULL,
  `variants` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `gift_variants`
--

INSERT INTO `gift_variants` (`id`, `gift_id`, `variants`, `created_at`, `updated_at`) VALUES
(88, 25, 'XS', '2022-09-06 10:29:27', '2022-09-06 10:29:27'),
(89, 25, 'S', '2022-09-06 10:29:27', '2022-09-06 10:29:27'),
(100, 31, 'XS', '2022-09-19 19:42:42', '2022-09-19 19:42:42'),
(101, 31, 'S', '2022-09-19 19:42:42', '2022-09-19 19:42:42');

-- --------------------------------------------------------

--
-- Table structure for table `hobbies`
--

CREATE TABLE `hobbies` (
  `id` bigint UNSIGNED NOT NULL,
  `hobbies` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hobbies_icon` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hobbies`
--

INSERT INTO `hobbies` (`id`, `hobbies`, `hobbies_icon`, `created_at`, `updated_at`) VALUES
(1, 'Photography', 'https://merrimate.com/storage/icons/ic_camera.png', '2022-05-06 06:00:33', '2022-05-06 06:00:33'),
(2, 'Games', 'https://merrimate.com/storage/icons/ic_game.png', '2022-05-06 06:00:41', '2022-05-06 06:00:41'),
(3, 'Shopping', 'https://merrimate.com/storage/icons/ic_shopping.png', '2022-05-06 06:00:46', '2022-05-06 06:00:46'),
(4, 'Arts & Crafts', 'https://merrimate.com/storage/icons/ic-art.png', '2022-05-06 06:00:54', '2022-05-06 06:00:54'),
(5, 'Swimming', 'https://merrimate.com/storage/icons/ic_swimming.png', '2022-05-06 06:01:01', '2022-05-06 06:01:01'),
(6, 'Karaoke', 'https://merrimate.com/storage/icons/ic_karaoke.png', '2022-05-06 06:01:07', '2022-05-06 06:01:07'),
(7, 'Cooking', 'https://merrimate.com/storage/icons/ic_cooking.png', '2022-05-06 06:01:11', '2022-05-06 06:01:11'),
(8, 'Music', 'https://merrimate.com/storage/icons/ic_music.png', '2022-05-06 06:01:17', '2022-05-06 06:01:17'),
(9, 'Travelling', 'https://merrimate.com/storage/icons/ic_traveling.png', '2022-05-06 06:01:28', '2022-05-06 06:01:28'),
(10, 'Drinking', 'https://merrimate.com/storage/icons/ic_drinking.png', '2022-05-06 06:01:34', '2022-05-06 06:01:34'),
(11, 'Fitness', 'https://merrimate.com/storage/icons/ic_fitness.png', '2022-05-06 06:01:40', '2022-05-06 06:01:40'),
(12, 'Movie', 'https://merrimate.com/storage/icons/ic_movie.png', '2022-05-06 06:01:49', '2022-05-06 06:01:49');

-- --------------------------------------------------------

--
-- Table structure for table `like_counts`
--

CREATE TABLE `like_counts` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `total_likes` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `like_counts`
--

INSERT INTO `like_counts` (`id`, `user_id`, `total_likes`, `created_at`, `updated_at`) VALUES
(26, 78, '0', '2022-09-09 11:20:16', '2022-09-09 11:36:24'),
(27, 79, '0', '2022-09-09 11:23:43', '2022-09-15 09:52:24'),
(35, 86, '1', '2022-09-19 19:31:13', '2022-09-19 19:31:52'),
(36, 87, '0', '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(37, 88, '1', '2022-09-21 07:14:46', '2022-09-21 07:22:25'),
(38, 89, '1', '2022-09-21 07:18:58', '2022-09-21 07:20:31'),
(39, 90, '2', '2022-09-23 10:40:47', '2022-09-23 10:41:30'),
(42, 92, '2', '2022-09-25 08:18:39', '2022-09-25 08:19:35'),
(43, 83, '2', '2022-09-26 08:56:19', '2022-09-26 13:38:20'),
(44, 91, '0', '2022-10-03 20:11:29', '2022-10-03 20:11:29'),
(45, 85, '0', '2022-10-03 20:14:01', '2022-10-03 20:14:01'),
(46, 93, '2', '2022-10-04 08:21:38', '2022-10-04 08:22:09'),
(47, 84, '0', '2022-10-08 16:24:10', '2022-10-08 16:24:10');

-- --------------------------------------------------------

--
-- Table structure for table `matched_users`
--

CREATE TABLE `matched_users` (
  `id` bigint UNSIGNED NOT NULL,
  `matched_person1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `matched_person2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `matched_users`
--

INSERT INTO `matched_users` (`id`, `matched_person1`, `matched_person2`, `created_at`, `updated_at`) VALUES
(87, '85', '86', '2022-09-19 19:31:52', '2022-09-19 19:31:52'),
(88, '89', '88', '2022-09-21 07:22:25', '2022-09-21 07:22:25'),
(89, '85', '90', '2022-09-23 10:41:30', '2022-09-23 10:41:30'),
(90, '84', '83', '2022-09-26 13:38:20', '2022-09-26 13:38:20');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2022_05_06_100645_create_hobbies_table', 1),
(6, '2022_05_06_100656_create_sexuals_table', 1),
(7, '2022_05_06_103230_add_sexual_id_to_table_users', 2),
(8, '2022_05_06_115544_create_user_hobbies_table', 3),
(9, '2022_05_17_090018_create_social_logins_table', 4),
(10, '2022_05_20_090455_create_user_images_table', 5),
(11, '2022_05_20_090502_create_user_videos_table', 5),
(12, '2022_05_20_144226_create_user_likes_table', 6),
(13, '2022_05_21_124610_create_dummydatas_table', 7),
(14, '2022_05_23_091516_create_matched_users_table', 8);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint UNSIGNED NOT NULL,
  `notification_from` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notification_to` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `notification_from`, `notification_to`, `content`, `title`, `is_read`, `created_at`, `updated_at`) VALUES
(25, '84', '83', 'You got matched with Abdul rehman', 'New Match', '0', '2022-09-15 15:25:08', '2022-09-15 15:25:08'),
(26, '86', '85', 'You got matched with no name', 'New Match', '0', '2022-09-19 19:31:53', '2022-09-19 19:31:53'),
(27, '88', '89', 'You got matched with Prashant Kumar', 'New Match', '0', '2022-09-21 07:22:25', '2022-09-21 07:22:25'),
(28, '90', '85', 'You got matched with shashikant sai', 'New Match', '0', '2022-09-23 10:41:31', '2022-09-23 10:41:31'),
(29, '83', '84', 'You got matched with Zeeshan Haider', 'New Match', '0', '2022-09-26 13:38:20', '2022-09-26 13:38:20');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `zip_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_amount` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `first_name`, `last_name`, `country`, `city`, `address`, `zip_code`, `phone`, `email`, `note`, `total_amount`, `created_at`, `updated_at`) VALUES
(10, 65, 'grdg', 'htfhj', 'India', 'gfvn', 'grfh', '6552', '658555585', 'gdfgff', 'gdfhf', '28', '2022-09-07 10:38:39', '2022-09-07 10:38:39');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `gift_id` bigint UNSIGNED NOT NULL,
  `variant` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `gift_id`, `variant`, `quantity`, `price`, `created_at`, `updated_at`) VALUES
(8, 10, 25, 'XS', '1', '28', '2022-09-07 10:38:39', '2022-09-07 10:38:39');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 5, 'profile', 'b77cf27bef689613cab75fbbdfd0484c28291f567ec806f58023c9214480aed5', '[\"*\"]', NULL, '2022-05-06 10:36:31', '2022-05-06 10:36:31'),
(2, 'App\\Models\\User', 6, 'profile', '6d60b0d2fdcc004afee2c003a99cbfafb5928883391589eecbffee3dfdeee6d6', '[\"*\"]', NULL, '2022-05-06 10:37:46', '2022-05-06 10:37:46'),
(3, 'App\\Models\\User', 7, 'profile', 'df1cc5096804f2a918d4336c33cddf7229c20bfc3e3be6ecb25a53c1cb78d67f', '[\"*\"]', NULL, '2022-05-06 10:47:45', '2022-05-06 10:47:45'),
(4, 'App\\Models\\User', 8, 'profile', '9ba427cc70c55b77670d22537db94fae097f6b60f5d4b03a080e0b6c6a05a10c', '[\"*\"]', NULL, '2022-05-06 10:49:48', '2022-05-06 10:49:48'),
(5, 'App\\Models\\User', 9, 'profile', '14559390491ee669ac3653759960776533d1a3a647d5411b7a37c95fdfb61d97', '[\"*\"]', NULL, '2022-05-17 07:50:41', '2022-05-17 07:50:41'),
(6, 'App\\Models\\User', 10, 'profile', '5e8d7abbf7ebd190dfb4d7403e18b624862f1d7179f98f32b16f14b827082166', '[\"*\"]', NULL, '2022-05-21 03:18:37', '2022-05-21 03:18:37'),
(7, 'App\\Models\\User', 11, 'profile', '013097a7055d2bc7d9b389cb38a4ef305ba9cbf225e112671de88b74a1334103', '[\"*\"]', NULL, '2022-05-23 09:15:57', '2022-05-23 09:15:57'),
(8, 'App\\Models\\User', 12, 'profile', '91a5a3f91e3c0de5b7c4b8c01bb5c80d5183bf6a1900ae8c99de2fb2f4709cae', '[\"*\"]', NULL, '2022-05-27 07:06:04', '2022-05-27 07:06:04'),
(9, 'App\\Models\\User', 13, 'profile', '50c60b3e9e05e623d593d79e33ebac154ae97b99f4a8e1ae0d1ed6af59ccd67e', '[\"*\"]', NULL, '2022-05-27 07:08:51', '2022-05-27 07:08:51'),
(10, 'App\\Models\\User', 14, 'profile', 'df53b3bccc2843783d7f41904f8e38748ed4f75a421432884b0a08400a5e348d', '[\"*\"]', NULL, '2022-05-27 07:15:14', '2022-05-27 07:15:14'),
(11, 'App\\Models\\User', 15, 'profile', 'b24112190e38e4466f4ccbdad8724954e3abea2dd7ff400841621923dbe18580', '[\"*\"]', NULL, '2022-05-27 07:21:44', '2022-05-27 07:21:44'),
(12, 'App\\Models\\User', 18, 'profile', '39888714a61b68baeb4d6fd1b947143e5d97d70d1fa4640a4e09e8835f79b137', '[\"*\"]', NULL, '2022-05-27 07:55:07', '2022-05-27 07:55:07'),
(13, 'App\\Models\\User', 19, 'profile', '018db4b07dae3d2fb0dd89f6e355d0338a1017b723ab5a0df8495913cb6007c9', '[\"*\"]', NULL, '2022-05-27 08:06:24', '2022-05-27 08:06:24'),
(14, 'App\\Models\\User', 20, 'profile', 'bdee7f6cd27e4bba9e12b149de7d5ef42c0f6005176cfb0b970189472e3b58e1', '[\"*\"]', NULL, '2022-05-27 08:14:19', '2022-05-27 08:14:19'),
(15, 'App\\Models\\User', 21, 'profile', '7a980a6b9fcbfc4419bb5df2d383f1086fded5a39d1e0e462001c05fa4b16475', '[\"*\"]', NULL, '2022-05-27 08:14:54', '2022-05-27 08:14:54'),
(16, 'App\\Models\\User', 33, 'profile', 'c6e8a6287bfe1f1de894adeb2272671a4a0d90169ff7b05b0ce37781e9eeb46e', '[\"*\"]', NULL, '2022-05-27 08:43:11', '2022-05-27 08:43:11'),
(17, 'App\\Models\\User', 34, 'profile', '6a435a5fc995b0a091263fc5c087da47a14345d39b3e9fff816750e6aa7546f2', '[\"*\"]', NULL, '2022-05-27 08:44:36', '2022-05-27 08:44:36'),
(18, 'App\\Models\\User', 35, 'profile', 'b21453a3d4f8c7fde5fa2c5b11445eb569d28d2fc850f89185405f54ec1e698f', '[\"*\"]', NULL, '2022-05-27 09:03:23', '2022-05-27 09:03:23'),
(19, 'App\\Models\\User', 36, 'profile', 'b88481ef2a0e20b7cfd2916c808b4ece9ae88bde3bca4fb81ad4117a3e285fd6', '[\"*\"]', NULL, '2022-05-28 06:02:21', '2022-05-28 06:02:21'),
(20, 'App\\Models\\User', 37, 'profile', 'aee27099eaa62329894517387ee8dd25705d2d2ecdd491ecda1be80a921ffdc0', '[\"*\"]', NULL, '2022-05-28 06:26:08', '2022-05-28 06:26:08'),
(21, 'App\\Models\\User', 38, 'profile', 'afda7303b248ff51d0ad1d854bf303e178f54c779675467134b2f7e535d5c5d4', '[\"*\"]', NULL, '2022-05-28 10:37:05', '2022-05-28 10:37:05'),
(22, 'App\\Models\\User', 39, 'profile', '426e44cd66e38be5a0241adf600e884a96e9fbd01b4018625eadb380186127d3', '[\"*\"]', NULL, '2022-05-28 10:47:12', '2022-05-28 10:47:12'),
(23, 'App\\Models\\User', 40, 'profile', '9b962642c02b23d8967cf348f6621e1c7202628a531a419f0036b2fcd7d5007d', '[\"*\"]', NULL, '2022-05-28 11:31:42', '2022-05-28 11:31:42'),
(24, 'App\\Models\\User', 41, 'profile', 'a4d28c618c01fbbdac7e71306094a5da48018e47336f2128e41f2f2dc4075191', '[\"*\"]', NULL, '2022-05-28 12:37:48', '2022-05-28 12:37:48'),
(25, 'App\\Models\\User', 42, 'profile', '1975ac60f12895b82f40bae67e83e113b2c293cc34c249dfb512746debf97428', '[\"*\"]', NULL, '2022-05-28 15:07:28', '2022-05-28 15:07:28'),
(26, 'App\\Models\\User', 43, 'profile', '62d9cadfd29ed3bcd464610bd9da9ed80933a8da3b986f157493eea15b5c0c8f', '[\"*\"]', NULL, '2022-05-30 07:20:19', '2022-05-30 07:20:19'),
(27, 'App\\Models\\User', 44, 'profile', '184f2e7b4cc4dfad963e1a62d2b4bede2b59d4143c4f3f537318e382568bceab', '[\"*\"]', NULL, '2022-05-30 07:42:32', '2022-05-30 07:42:32'),
(28, 'App\\Models\\User', 45, 'profile', '712e62eef17b76750811389a394fd75d3da80db7370d55f7c9681cd0277e59ac', '[\"*\"]', NULL, '2022-05-30 07:54:10', '2022-05-30 07:54:10'),
(29, 'App\\Models\\User', 46, 'profile', '7b30519d2060144be39738dedb35baa1e110b433037e6189008143095b6b894a', '[\"*\"]', NULL, '2022-05-30 07:57:29', '2022-05-30 07:57:29'),
(30, 'App\\Models\\User', 47, 'profile', '84af9d15fa392158db01a933627bc811e4370b2884a429b03ea4372a24edd6d6', '[\"*\"]', NULL, '2022-05-30 07:59:15', '2022-05-30 07:59:15'),
(31, 'App\\Models\\User', 48, 'profile', '88b4bc2cdc212429983d76d1aada638631cdf792916d325e20fb3ef06d7b4cd8', '[\"*\"]', NULL, '2022-05-30 08:20:55', '2022-05-30 08:20:55'),
(32, 'App\\Models\\User', 49, 'profile', '73f5b08731f693ad80251d76263e6e346d2e3b629df6c903ebdd27094b2f9d2c', '[\"*\"]', NULL, '2022-05-30 09:04:44', '2022-05-30 09:04:44'),
(33, 'App\\Models\\User', 50, 'profile', 'a2d4a83bb95ff0c1ad16d681347ef30362d441df0342edc9e42132255c1f4ada', '[\"*\"]', NULL, '2022-05-30 11:01:55', '2022-05-30 11:01:55'),
(34, 'App\\Models\\User', 51, 'profile', '743d17ba1e64fc9639bd9bc04e1022d637627ac9fe2124f14acf8d78c38eb521', '[\"*\"]', NULL, '2022-05-30 11:07:05', '2022-05-30 11:07:05'),
(35, 'App\\Models\\User', 52, 'profile', '41cb2864b820ded49ee260063d6ef6a093cf174f71b58fd68da0fcdb61de637e', '[\"*\"]', NULL, '2022-05-30 11:09:56', '2022-05-30 11:09:56'),
(36, 'App\\Models\\User', 53, 'profile', 'e374be9448eec19cb13f13f91f0af8a0852533b9fc61ed572ca84fd133c1bdfe', '[\"*\"]', NULL, '2022-05-30 11:11:03', '2022-05-30 11:11:03'),
(37, 'App\\Models\\User', 54, 'profile', '883a3e1e6191b55696a1d0d663a94336faada4c3129ac9724ecaa36ae68c7af5', '[\"*\"]', NULL, '2022-05-30 11:12:50', '2022-05-30 11:12:50'),
(38, 'App\\Models\\User', 55, 'profile', 'faa983ab1dbfb201b8de296c5662e136e059e71dd34c3ef8ccb7ab8e96ada5ae', '[\"*\"]', NULL, '2022-06-01 12:16:27', '2022-06-01 12:16:27'),
(39, 'App\\Models\\User', 56, 'profile', '8290926314ffd12623334dbcb3def712dc597ed504450c8c81b620af305f6e01', '[\"*\"]', NULL, '2022-06-02 12:49:06', '2022-06-02 12:49:06'),
(40, 'App\\Models\\User', 57, 'profile', 'b0838fc51c78e5cd3d312cb9abead9b2d13f12711b46a6b8a3b20b5b173235e8', '[\"*\"]', NULL, '2022-06-07 08:49:56', '2022-06-07 08:49:56'),
(41, 'App\\Models\\User', 58, 'profile', '41036cac4c6b5fca54926f9bcf0ea88b320090b5770e2a94fdc1e782e477b392', '[\"*\"]', NULL, '2022-07-01 08:02:41', '2022-07-01 08:02:41'),
(42, 'App\\Models\\User', 59, 'profile', '85bc0263701249c29f7b0a501d664638171074e5e4c782465b850071de55a849', '[\"*\"]', NULL, '2022-07-01 08:13:48', '2022-07-01 08:13:48'),
(43, 'App\\Models\\User', 60, 'profile', '0c32c680eb808a64100347303e35f26fad6a7af7e658d1762c5209fd0e884b4a', '[\"*\"]', NULL, '2022-07-01 09:03:16', '2022-07-01 09:03:16'),
(44, 'App\\Models\\User', 61, 'profile', '0171908293fcdcf9b8ec65afb5f8f841606d3e8a2cc2f06649b65be7a0473575', '[\"*\"]', NULL, '2022-07-01 09:05:41', '2022-07-01 09:05:41'),
(45, 'App\\Models\\User', 62, 'profile', 'f969e9c8daec59e63da7bc44f21f2f1b60d56da54f25cc0559e58a11cf7cdd05', '[\"*\"]', NULL, '2022-07-05 09:14:10', '2022-07-05 09:14:10'),
(46, 'App\\Models\\User', 63, 'profile', '14e8934967483d3194c5a0062ddb053fcdda5e88773fbfcd471d4e9e544f4782', '[\"*\"]', NULL, '2022-07-06 08:03:13', '2022-07-06 08:03:13'),
(47, 'App\\Models\\User', 64, 'profile', 'c07277d71f08f9edee97cd1dff2c0d59130ecbe934bc767778a2be9895dbf0f5', '[\"*\"]', NULL, '2022-07-06 08:23:57', '2022-07-06 08:23:57'),
(48, 'App\\Models\\User', 65, 'profile', '046b34bbc8774d9feacf9c807a27a7505628b581c167ea3d12d924a3ba0bfc16', '[\"*\"]', NULL, '2022-07-06 10:34:57', '2022-07-06 10:34:57'),
(49, 'App\\Models\\User', 66, 'profile', '30deaa9628d31daf4892886701860107392febdf3da6677e3db9ed2ca6a85b8f', '[\"*\"]', NULL, '2022-07-06 10:35:28', '2022-07-06 10:35:28'),
(50, 'App\\Models\\User', 67, 'profile', '8b24d8f9cc2e64cd00546aa8d5796e2edb31e37b8435c631d9ad0e0a036f704f', '[\"*\"]', NULL, '2022-07-11 09:12:48', '2022-07-11 09:12:48'),
(51, 'App\\Models\\User', 68, 'profile', 'c10910f3d89082ac8713f4a780663939a28a112638b8f07ef851189842b30476', '[\"*\"]', NULL, '2022-07-11 09:20:26', '2022-07-11 09:20:26'),
(52, 'App\\Models\\User', 69, 'profile', 'ce6192530d4a9af4385756f84a624e9adb33c26b6dcef6cfb1dd00080bf0160e', '[\"*\"]', NULL, '2022-07-15 11:15:22', '2022-07-15 11:15:22'),
(53, 'App\\Models\\User', 70, 'profile', 'd2443fa53957ab556b27b260bc13c3e6af8531ab82bfe9a093b3ee417af3c1b3', '[\"*\"]', NULL, '2022-07-15 11:31:30', '2022-07-15 11:31:30'),
(54, 'App\\Models\\User', 71, 'profile', '4bbc8b1dd79202d1d4b3eaf3c184697f76214d6c3dc3e9b2fb229a15bc5f98ae', '[\"*\"]', NULL, '2022-07-27 12:57:42', '2022-07-27 12:57:42'),
(55, 'App\\Models\\User', 72, 'profile', 'aa63e7fca29962783bed40b7d7e8f5fb69d56b1346441232a0c7694cac64de75', '[\"*\"]', NULL, '2022-07-28 11:16:03', '2022-07-28 11:16:03'),
(56, 'App\\Models\\User', 73, 'profile', '2429a11644bb0a5082a7396eb25a668c42fe1a7d86a0d5f304ab7e8dcfad7b13', '[\"*\"]', NULL, '2022-08-25 16:17:26', '2022-08-25 16:17:26'),
(57, 'App\\Models\\User', 74, 'profile', '796267885e727fe9c0f0ef4252fc01bf202549b12107a3a655146639fa9aa3c6', '[\"*\"]', NULL, '2022-08-31 04:13:11', '2022-08-31 04:13:11'),
(58, 'App\\Models\\User', 75, 'profile', 'bfbc183e36744efe1e38fa66aa8bbded39aaee410f9a0062f92adbc4825a130f', '[\"*\"]', NULL, '2022-09-08 09:27:55', '2022-09-08 09:27:55'),
(59, 'App\\Models\\User', 76, 'profile', '06cf018a988a4f85469b15366835173a8c0c87b4626c111965e5392ca0ea28c3', '[\"*\"]', NULL, '2022-09-08 09:53:19', '2022-09-08 09:53:19'),
(60, 'App\\Models\\User', 77, 'profile', '809767db0afcebf5a0cf78282362369a1979dd83d48a86893af0dd92441c415c', '[\"*\"]', NULL, '2022-09-08 10:00:17', '2022-09-08 10:00:17'),
(61, 'App\\Models\\User', 78, 'profile', '0774b253fd1f90bb7dc901b2438ff4d05bc5680b7084d8df8ca0aef63c72d89c', '[\"*\"]', NULL, '2022-09-09 11:20:16', '2022-09-09 11:20:16'),
(62, 'App\\Models\\User', 79, 'profile', '0e5a6d941062466619d101d585599eda489b9800a3cb37a8724cfbb62bd2d2ab', '[\"*\"]', NULL, '2022-09-09 11:23:43', '2022-09-09 11:23:43'),
(63, 'App\\Models\\User', 80, 'profile', 'e85aed17715de95863a81660c12356d59ab9733862b9ee304421b336952fb42e', '[\"*\"]', NULL, '2022-09-09 11:35:02', '2022-09-09 11:35:02'),
(64, 'App\\Models\\User', 81, 'profile', '01aabf004e5030fac7a3d1b7bfce9eed631bcfc29f178c502336698af49aa336', '[\"*\"]', NULL, '2022-09-11 06:50:12', '2022-09-11 06:50:12'),
(65, 'App\\Models\\User', 82, 'profile', '9e7c125ea1db49add36c71126365fb5d930162d2ef07b2865afe85ab9f405f69', '[\"*\"]', NULL, '2022-09-14 05:44:17', '2022-09-14 05:44:17'),
(66, 'App\\Models\\User', 83, 'profile', 'f2977a2a71df0d58a3ec3c5bad78e5ec2ebd31ac04886e5131499db49672ac69', '[\"*\"]', NULL, '2022-09-15 14:55:36', '2022-09-15 14:55:36'),
(67, 'App\\Models\\User', 84, 'profile', 'd2a1c984b77b8fcb0d8a9745291d2cf6e7eba8327fb90ac6e7f8f2780d341fa6', '[\"*\"]', NULL, '2022-09-15 14:57:47', '2022-09-15 14:57:47'),
(68, 'App\\Models\\User', 85, 'profile', '1d8bba15d6220a1839be3e95889c25efb43f45525d49a46d6dfb18d903934988', '[\"*\"]', NULL, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(69, 'App\\Models\\User', 86, 'profile', '1fffec73eb46dedb8af9127ca20da22a0d73ac9bd43b1745bbced4a8c345d7a5', '[\"*\"]', NULL, '2022-09-19 19:31:13', '2022-09-19 19:31:13'),
(70, 'App\\Models\\User', 87, 'profile', 'aa58d35ed9d423876ac12e9ab71a2ac1334a30c69296cb661f6b3a476417c2ad', '[\"*\"]', NULL, '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(71, 'App\\Models\\User', 88, 'profile', '283478a2ddff007dbbaf40fb0cdd746ef940c0f1d6b363f7c0f6740656163ad6', '[\"*\"]', NULL, '2022-09-21 07:14:46', '2022-09-21 07:14:46'),
(72, 'App\\Models\\User', 89, 'profile', '4db2d7fe401bdb9aeed39f3d7bab0bcf46fe4b9a655f41f72ca2422f278e81e7', '[\"*\"]', NULL, '2022-09-21 07:18:58', '2022-09-21 07:18:58'),
(73, 'App\\Models\\User', 90, 'profile', 'a771eed20d6f397f84b4be27499fddecb4b355347d5c5020e488ea46dfa16fb9', '[\"*\"]', NULL, '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(74, 'App\\Models\\User', 91, 'profile', '8947b3b8f852d5d6807a5c029234fb8f6853499e83a3afab88fe8ea48ac9ca1c', '[\"*\"]', NULL, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(75, 'App\\Models\\User', 92, 'profile', '83759759f93498b774d14ca887d4d290b631b78aa85c8e6ed05001e6740ad33f', '[\"*\"]', NULL, '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(76, 'App\\Models\\User', 93, 'profile', '23b04987038e48aa4d8fc78d753ccb810ef809340bccdba4a8d0c9799b503e67', '[\"*\"]', NULL, '2022-10-04 08:21:38', '2022-10-04 08:21:38');

-- --------------------------------------------------------

--
-- Table structure for table `plan_transactions`
--

CREATE TABLE `plan_transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `transaction_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `plan_transactions`
--

INSERT INTO `plan_transactions` (`id`, `user_id`, `transaction_id`, `type`, `created_at`, `updated_at`) VALUES
(23, 83, 'coins', '', '2022-09-20 12:44:39', '2022-09-20 12:44:39'),
(24, 83, 'coins', '', '2022-09-20 12:53:03', '2022-09-20 12:53:03'),
(25, 83, 'coins', '', '2022-09-20 13:14:03', '2022-09-20 13:14:03');

-- --------------------------------------------------------

--
-- Table structure for table `privacy_lists`
--

CREATE TABLE `privacy_lists` (
  `id` bigint UNSIGNED NOT NULL,
  `list_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `privacy_lists`
--

INSERT INTO `privacy_lists` (`id`, `list_name`, `created_at`, `updated_at`) VALUES
(1, 'Only Friends', '2022-07-28 08:18:50', '2022-07-28 08:18:50'),
(2, 'Friends of Friends', '2022-07-28 08:18:50', '2022-07-28 08:18:50'),
(3, 'Only me', '2022-07-28 08:20:55', '2022-07-28 08:20:55'),
(4, 'Everyone', '2022-07-28 08:20:55', '2022-07-28 08:20:55');

-- --------------------------------------------------------

--
-- Table structure for table `quizzes`
--

CREATE TABLE `quizzes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `quiz_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quiz_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quizzes`
--

INSERT INTO `quizzes` (`id`, `user_id`, `quiz_name`, `quiz_description`, `created_at`, `updated_at`) VALUES
(11, 76, 'Test QuiZ 2', 'testing description', '2022-09-14 13:13:20', '2022-09-14 13:13:20'),
(12, 83, 'Test quiz', 'testing description', '2022-09-16 13:30:53', '2022-09-16 13:30:53'),
(13, 83, 'Test 2', 'ehhehehe', '2022-09-16 14:45:06', '2022-09-16 14:45:06'),
(14, 86, 'test', 'test', '2022-09-19 19:41:01', '2022-09-19 19:41:01');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_questions`
--

CREATE TABLE `quiz_questions` (
  `id` bigint UNSIGNED NOT NULL,
  `quiz_id` bigint UNSIGNED NOT NULL,
  `question` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `option1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `option2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `option3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `option4` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `right_answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quiz_questions`
--

INSERT INTO `quiz_questions` (`id`, `quiz_id`, `question`, `option1`, `option2`, `option3`, `option4`, `right_answer`, `created_at`, `updated_at`) VALUES
(26, 11, 'answer is a?', '1', '2', '3', '4', '1', '2022-09-14 13:13:20', '2022-09-14 13:13:20'),
(27, 11, 'answer is b?', '1', '2', '3', '4', '2', '2022-09-14 13:13:20', '2022-09-14 13:13:20'),
(28, 11, 'answer is c?', '1', '2', '3', '4', '3', '2022-09-14 13:13:20', '2022-09-14 13:13:20'),
(29, 11, 'answer is d?', '1', '2', '3', '4', '4', '2022-09-14 13:13:20', '2022-09-14 13:13:20'),
(30, 11, 'answer is a?', '1', '2', '3', '4', '1', '2022-09-14 13:13:20', '2022-09-14 13:13:20'),
(31, 12, 'abc', '1', '2', '3', '4', '1', '2022-09-16 13:30:53', '2022-09-16 13:30:53'),
(32, 12, 'hddhdh', '1', '2', '3', '4', '1', '2022-09-16 13:30:53', '2022-09-16 13:30:53'),
(33, 12, 'hdhdhshsvd', '1', '2', '3', '4', '2', '2022-09-16 13:30:53', '2022-09-16 13:30:53'),
(34, 12, 'hdhdhsusbsbshd', '1', '2', '3', '4', '4', '2022-09-16 13:30:53', '2022-09-16 13:30:53'),
(35, 12, 'hdhshsbegdhdhsgs', '1', '2', '3', '4', '2', '2022-09-16 13:30:53', '2022-09-16 13:30:53'),
(36, 13, 'dhshsh', '1', '2', '3', '4', '1', '2022-09-16 14:45:06', '2022-09-16 14:45:06'),
(37, 13, 'hehshsgs', '1', '2', '3', '4', '3', '2022-09-16 14:45:06', '2022-09-16 14:45:06'),
(38, 13, 'hehssgv', '1', '2', '3', '4', '1', '2022-09-16 14:45:06', '2022-09-16 14:45:06'),
(39, 13, 'hshshsgs', '1', '2', '3', '4', '4', '2022-09-16 14:45:06', '2022-09-16 14:45:06'),
(40, 13, 'hshsgzhzhsvs', '1', '2', '3', '4', '2', '2022-09-16 14:45:06', '2022-09-16 14:45:06'),
(41, 14, '1234', '1', '2', '3', '4', '4', '2022-09-19 19:41:01', '2022-09-19 19:41:01'),
(42, 14, '5678', '5', '6', '7', '8', '8', '2022-09-19 19:41:01', '2022-09-19 19:41:01'),
(43, 14, '9101', '9', '1', '0', '1', '0', '2022-09-19 19:41:01', '2022-09-19 19:41:01'),
(44, 14, 'abcd', 'a', 'b', 'c', 'd', 'd', '2022-09-19 19:41:01', '2022-09-19 19:41:01'),
(45, 14, 'efgh', 'e', 'f', 'g', 'h', 'h', '2022-09-19 19:41:01', '2022-09-19 19:41:01');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_results`
--

CREATE TABLE `quiz_results` (
  `id` bigint UNSIGNED NOT NULL,
  `quiz_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `performed_by` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quiz_results`
--

INSERT INTO `quiz_results` (`id`, `quiz_id`, `user_id`, `performed_by`, `score`, `created_at`, `updated_at`) VALUES
(18, 14, 86, '85', '60', '2022-09-19 19:41:27', '2022-09-19 19:41:27'),
(19, 12, 83, '84', '40', '2022-09-20 15:48:45', '2022-09-20 15:48:45');

-- --------------------------------------------------------

--
-- Table structure for table `sexuals`
--

CREATE TABLE `sexuals` (
  `id` bigint UNSIGNED NOT NULL,
  `sexual_orientations` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sexuals`
--

INSERT INTO `sexuals` (`id`, `sexual_orientations`, `created_at`, `updated_at`) VALUES
(1, 'Straight', '2022-05-06 06:52:53', '2022-05-06 06:52:53'),
(2, 'Gay', '2022-05-06 06:53:03', '2022-05-06 06:53:03'),
(3, 'Lesbian', '2022-05-06 06:53:09', '2022-05-06 06:53:09'),
(4, 'Bisexual', '2022-05-06 06:53:15', '2022-05-06 06:53:15'),
(5, 'Asexual', '2022-05-06 06:53:21', '2022-05-06 06:53:21'),
(6, 'Demisexual', '2022-05-06 06:53:30', '2022-05-06 06:53:30'),
(7, 'Pansexual', '2022-05-06 06:53:37', '2022-05-06 06:53:37'),
(8, 'Queer', '2022-05-06 06:53:43', '2022-05-06 06:53:43');

-- --------------------------------------------------------

--
-- Table structure for table `story_scenes`
--

CREATE TABLE `story_scenes` (
  `id` bigint NOT NULL,
  `user_stories_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `story_scenes`
--

INSERT INTO `story_scenes` (`id`, `user_stories_id`, `user_id`, `created_at`, `updated_at`) VALUES
(23, 17, 85, '2022-09-19 20:03:54', '2022-09-19 20:03:54'),
(24, 25, 84, '2022-09-20 15:47:33', '2022-09-20 15:47:33'),
(25, 26, 83, '2022-09-26 09:11:32', '2022-09-26 09:11:32');

-- --------------------------------------------------------

--
-- Table structure for table `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `id` bigint UNSIGNED NOT NULL,
  `plan_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `plan_icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `plan_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `plan_price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscription_plans`
--

INSERT INTO `subscription_plans` (`id`, `plan_name`, `plan_icon`, `plan_description`, `plan_price`, `created_at`, `updated_at`) VALUES
(1, 'normal ', '', 'he can only chat with match connect for 7 days and he or she can only get 5 matches in week for free after than we have to purchase premium membership', '0.00', '2022-07-26 19:00:00', '2022-07-27 14:02:13'),
(2, 'stater x', 'https://merrimate.com/storage/icons/ic_star.png', 'in this plan user will get full access of application for 3 month and he will 300 matches only', '20.00', '2022-07-27 14:07:36', '2022-07-27 14:07:36'),
(3, 'stater pro', 'https://merrimate.com/storage/icons/ic_diamond.png', 'in this plan user will get full access of application for 12 month and he will get 1000 Matches', '50.00', '2022-07-27 14:08:18', '2022-07-27 14:08:18'),
(4, 'Stater x pro', 'https://merrimate.com/storage/icons/ic_crown.png', 'in this plan user will get full access of application for life time for unlimited access', '100.00', '2022-07-27 14:08:52', '2022-07-27 14:08:52');

-- --------------------------------------------------------

--
-- Table structure for table `super_likes`
--

CREATE TABLE `super_likes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `user_like` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `sexual_id` bigint UNSIGNED DEFAULT NULL,
  `provider` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider_id` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider_token` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_birth` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_img` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `access_token` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `short_bio` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_holiday` smallint NOT NULL DEFAULT '0',
  `latitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `longitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fcm_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` smallint DEFAULT '1',
  `show_orientation` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `sexual_id`, `provider`, `provider_id`, `provider_token`, `name`, `username`, `phone`, `date_of_birth`, `gender`, `password`, `profile_img`, `email`, `access_token`, `short_bio`, `is_holiday`, `latitude`, `longitude`, `fcm_token`, `is_active`, `show_orientation`, `email_verified_at`, `remember_token`, `created_at`, `updated_at`) VALUES
(78, 1, NULL, NULL, NULL, 'shabran ali', 'shabran456', '+923423855428', '1997-09-10', 'Woman', '$2y$10$jgIAGK2WbYdR/.wcbGE/Y.hZygJ3QL/aSN/lYnnvRGVh4ejux2abi', 'https://merrimate.com/storage/profile/1662722415_image_cropper_1662722386922.jpg', NULL, '61|Bsc8lMJC0w7jwemr2xHEil9CFhmWSdcyECJZXDed', '', 0, '24.879172', '67.171543', 'dqvxD3B6TdeZSImBlbKk6v:APA91bEHxuRhUvD06hU2bD3v4h9ldD3ebJoMv6wuLK4qjIyfuFb6wg8yBbOgTEhzXPXgs9fJ3imnTpVVJvhmdxK8OUXI8SgvfMFawUACKjvxR6TX9fXVScULcetBr6m02DEGHQ6qranh', 1, '1', NULL, NULL, '2022-09-09 11:20:15', '2022-09-14 10:50:51'),
(79, 1, NULL, NULL, NULL, 'Ayaz', 'Qureshi', '+923417164469', '1995-11-16', 'Other', '$2y$10$Pc0iOptkySfIwTY9yt8FMOWL6y7sZGXvI7U/4dDtjrbFHzhirTIP6', 'https://merrimate.com/storage/profile/1662722623_image_cropper_1662722583512.jpg', NULL, '62|BZ0DR5T5nSdoKJOe3Lxgq0pVzeJtqOYgHpkDvj8T', NULL, 0, '24.913270', '67.131159', 'fUYp2Bb1RX-MMCuzSkKn2I:APA91bGvQy-3ZyFSzCKJKqBoiBOHYg-lMpzTuqlZZPnXHkQhZ2BQfZL16IUdqEflD8PFcaSBEvXwx6bQk_mE7yyWBzaGF82eYVFczjdtAA4vpDmYuwoWTqsbEZRm_kxvi1wE8mGPx9rA', 1, '0', NULL, NULL, '2022-09-09 11:23:43', '2022-09-09 11:23:43'),
(83, 1, NULL, NULL, NULL, 'Zeeshan Haider', 'shenron07', '+923456186504', '1995-08-25', 'Man', '$2y$10$ofb1BBgsOPpoT6iZm/lz8OelQEwfQPuPY1mqJnyTwSNnqw.sC.SXO', 'https://merrimate.com/storage/profile/1663253736_image_cropper_1663253857418.jpg', NULL, '66|00X015FVEQ3xbQDQaRvGyn2dA7h41eIHqhumRusl', NULL, 0, '24.9196571', '67.0950548', 'dcplwFDERxqb4DH2rpGXz1:APA91bFPe8ZWHK6ufKRa3TwcHLjEwPMxmd5u5EgpsMBUKq3Hr9gnaSec5k2zUYEaNkQEKboTm86KZG0KIUfnb9-aPu0fC9A62mmfwQPLLSkXdragHK0JHu3sMFerS7l4ZugC38Tc8-lQ', 1, '1', NULL, NULL, '2022-09-15 14:55:36', '2022-09-20 13:47:56'),
(84, 1, NULL, NULL, NULL, 'Abdul rehman', 'maan20', '+923051627269', '2002-08-18', 'Man', '$2y$10$4j5CSIwm8HFZwLKyStVDSOkHBusOWy58d0U6zYDZywgqxsTmvBTrm', 'https://merrimate.com/storage/profile/1663253867_image_cropper_1663253772739.jpg', 'rehman30912@gmail.com', '67|skrgR0Aw8CnOcqkFFfovRAwxBxmHnhWzc5Metb2t', 'Dev account', 0, '24.9196415', '67.095067', 'fvIGnGcHQLSDfzj7j8ClKL:APA91bFZU6RfrSXy7zl5sewZl1z16JEHKn-8Q92sRlAiFW75hP7Ct1_vK7XGdYgNQhxCJ6WL3HhqFlPMoMHxo2VR4CmMthT6ra3qnRrxwhddmVpdUTjv3uW_Yp65j2NFovHHosZCuEwd', 1, '1', NULL, NULL, '2022-09-15 14:57:47', '2022-09-20 15:50:08'),
(85, 1, NULL, NULL, NULL, 'Hemant singh', 'hemant', '+918114471036', '1998-09-13', 'Man', '$2y$10$fxqlniOuVX1b71SDK9DQa.9IXevowznYFawCfyZOTv6ABS8/h05Qy', 'https://merrimate.com/storage/profile/1663615521_image_cropper_1663615499723.jpg', NULL, '68|MhDXvbdh7j6m7q6fmT7vXaT0ACd6pUViNkJ3AzCO', NULL, 0, '25.1986532', '75.8987555', 'dZH9j2W4SOKBibmYIvtNz8:APA91bGui9TWc4_3kYsv0z_Q91bmDSsjA8C53qMpDx_k6A6IpmCXdJVTkl4icT-Ezn13eFAj0QNJ0gVtMAF8Oxbt1NATlgT6iTVJ3YjO433_U_VJdO6IOuEtanHQgrIODtCuMihO_iuK', 1, '1', NULL, NULL, '2022-09-19 19:25:21', '2022-10-03 20:32:28'),
(86, 1, NULL, NULL, NULL, 'no name', 'noname', '+916350443523', '2022-09-20', 'Woman', '$2y$10$gpZo9sEGxcOUUAhJuHhZ0uZq4Khaenhlh4wxwa9ntpXWAJ4B3t29O', 'https://merrimate.com/storage/profile/1663615873_image_cropper_1663615825552.jpg', 'noname@gmail.com', '69|RtIRv89DMK8byNnT079riVx6qfNzDDLg6kFwuwPi', 'hello', 0, '25.19847005586083', '75.89919990639173', 'eAhAd0TZSzWYkpgU6ftceP:APA91bHmCc0Lkn09SxX10JI3zAqJwLv0_McL87mjU9fkM8bxk3uJ8SZ0gR0XH2m0WKOPym2-3wENiIVdIvRmc3DhoUqsO6Br1K2pZyZMqsFwrAsnTO1ScnMQg6QZOq5gfUEvenSNASWa', 1, '1', NULL, NULL, '2022-09-19 19:31:13', '2022-09-19 20:09:50'),
(87, 1, 'google', '115287518085222716515', NULL, 'Bhanwar Kanwar', 'bhanwar', '+919672953188', '2022-09-01', 'Woman', '$2y$10$WZW2to528Rxz0BWNZD239eYylgxtuSEQRg7ddr3TbjHqAjlgEW.FG', 'https://merrimate.com/storage/profile/1663618632_socialImage.png', 'bhanwark108@gmail.com', '70|9tHmIoHbzEwJ9niuVNxy0oexvcrnCfzCcSG3KAWc', NULL, 0, '25.19847005586083', '75.89919990639173', 'eAhAd0TZSzWYkpgU6ftceP:APA91bHmCc0Lkn09SxX10JI3zAqJwLv0_McL87mjU9fkM8bxk3uJ8SZ0gR0XH2m0WKOPym2-3wENiIVdIvRmc3DhoUqsO6Br1K2pZyZMqsFwrAsnTO1ScnMQg6QZOq5gfUEvenSNASWa', 1, '1', NULL, NULL, '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(88, 1, 'google', '116818779589531809867', NULL, 'Prashant Kumar', 'assks', '+919540100020', '2022-09-21', 'Man', '$2y$10$QmSlcL7qbNG5nRXPJAZrIOqCBYl1NfzdlJRMZLc2fduafzZ0EHVbC', 'https://merrimate.com/storage/profile/1663744486_socialImage.png', 'prashant@shivalikjournal.com', '71|AX2UkdMfNs9aPLGrfUQvoCX5irgIhBIBT0bruTvq', NULL, 0, '28.4957225', '77.4019316', 'dH9eoyd-TWaI8xIHBuwNEx:APA91bHULT89l2YcOemkDfw6YOJBq1V-qpRExohNZq4KqAhYkw5A4TEGD1SitKlG1osFZtsRHe8mqu9f4hI16cZgpfMX-8AUwVgWHpU0gM76T4zyn73mzwpkm0a_l9JONVTPMAUN75e2', 1, '1', NULL, NULL, '2022-09-21 07:14:46', '2022-09-21 07:31:47'),
(89, 1, 'google', '102710469519238994849', NULL, 'Hello', 'dateme02', '+917464813388', '2000-09-14', 'Man', '$2y$10$lsF8UicD4vwV1hKbJgKoBuJn7Bdk.RZbpe82WKrgAlDJTBo2Mkmxq', 'https://merrimate.com/storage/profile/1663744738_image_cropper_1663744620781.jpg', 'piyushkanwal18@gmail.com', '72|tbM87q7zChE3azPQWhhOL9DworJ45Y1uemQbRRcB', NULL, 0, '28.495727', '77.4019329', 'dr_qceR5TeKm_A7Y0vUpOL:APA91bHjEDuT4isUZt7oUlFYbwyDJxoxAl88DBTS7cjM2vO9poeE462RrGY4MnN_ITSfNlV1HKEdzu3Fm8hBbwIXRh5gFgQGQMD9dJk96T7QB967n2bBJu60DMFRaD1-GfhPzcmo8N2Y', 1, '1', NULL, NULL, '2022-09-21 07:18:58', '2022-09-21 07:19:49'),
(90, 1, 'google', '116092270216359007142', NULL, 'shashikant sai', 'shashi', '+919602162524', '2022-09-23', 'Man', '$2y$10$LNEei.yR3Hhbzn1BsHLAR.EFir/K6CVs4vCgr/FU3DYrcSiCo/Moq', 'https://merrimate.com/storage/profile/1663929647_socialImage.png', 'sadapet125@gmail.com', '73|1ti8aLnjNfyEzkBtMUjpK5MumJBBaPj5kXZmhB4P', NULL, 0, '25.1518093', '75.856494', 'fjxwP00qT8eKEbVw5M5tsl:APA91bELGjP2DIXR3t8kYe48pb8e80zWQtl8fKGSwFcSjpNSh3mWRos1CstwX9JM_jm57Z7QOp-I1tDrGfXMCD1kp2udCznbGamGJ8hWosGMassz7N9NRZUl3xSXsVXfgZKjjHcCzLR0', 1, '0', NULL, NULL, '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(91, 1, NULL, NULL, NULL, 'Deep', 'Deep77', '+460736393831', '1993-02-09', 'Man', '$2y$10$sUDa78wuqVtPXYub1NmruuwFuXkoC/8GGuxoaGU1BZB45.quzs0jm', 'https://merrimate.com/storage/profile/1663958366_image_cropper_1663958343195.jpg', NULL, '74|lj6tXfvzbwxqb0b5GS62m1RYXKkEIBa6ZmB7ICe3', NULL, 1, '57.7607561', '14.1440678', 'fFG8SLNyRLGDdobExJEwVi:APA91bFq_lAyfDbhs2k6jeNkXsDLbC9e2kks47FujoqqkBPtyOcLlXbP1nnOMUmgbUqIsLbs9SICTi_DGUdrUaPm9aXHil5xYo82a-VO-lyZTSFR9LLOREsj986L7iGoyXmDxNoljxZ2', 1, '0', NULL, NULL, '2022-09-23 18:39:26', '2022-10-03 20:25:46'),
(92, 1, 'google', '102959168421399101809', NULL, 'Divya Rathore', 'Divya Rathore', '+916350466038', '2002-03-09', 'Woman', '$2y$10$dE6eoBJhp7UohfM8UU3F6u./eVpqAmIlM5FT8xHus9wLh9lati4JC', 'https://merrimate.com/storage/profile/1664093919_socialImage.png', 'divyarathore9032002@gmail.com', '75|bHUYFaqMPl9MIRd37UffNIzx3ftWI6N3m7EVVk54', NULL, 0, '25.1989859', '75.8985637', 'fttyEPcNSD-d4SZa39h0WG:APA91bFvhkB-S-NUZLH0RElQVa5feZiUp4vnA2_B0mgrNRKB87nF0H0fZjUae6Fx6-fd-kC_LAbtOCUKuUZNBDF3X2lCnBPhUMJM3Ket_C7QntDTasJ1XMk1WmoOoG7F6bWre_a4FYNq', 1, '0', NULL, NULL, '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(93, 1, 'google', '109202027291129136749', NULL, 'Shashikant Dwivedi', 'theskd', '+919116337787', '1999-07-26', 'Man', '$2y$10$obWwqk9OnqPTvy5JMEUN4uTeX/l4EBjfHLyHQmOAqPlb7mbJmOfBC', 'https://merrimate.com/storage/profile/1664871698_socialImage.png', 'shashikant.dwivedi.1999@gmail.com', '76|XtTWedbg42DWIKOBymidD5eVDB9JlopaA3vVMACw', NULL, 0, '25.1509041', '75.8786301', 'dRX827chS52h0Ds0UAwBhV:APA91bF-a8GMxBQKcAXwut6thzvyp33KHlv2CZY6XC-YPpB2O9_IBdNeVut_vWn6TKJiXkzAAVF74uIwgXaMFko_udZgsqnHj0SjTuBAHq4xoaRb8C7LTYd0bm5VPcTkq2cxGKnaK6QU', 1, '0', NULL, NULL, '2022-10-04 08:21:38', '2022-10-04 08:21:38');

-- --------------------------------------------------------

--
-- Table structure for table `user_boosters`
--

CREATE TABLE `user_boosters` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `booster_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_boosters`
--

INSERT INTO `user_boosters` (`id`, `user_id`, `booster_id`, `created_at`, `updated_at`) VALUES
(13, 78, NULL, '2022-09-09 11:20:16', '2022-09-09 11:20:16'),
(14, 79, NULL, '2022-09-09 11:23:43', '2022-09-09 11:23:43'),
(18, 83, NULL, '2022-09-15 14:55:36', '2022-09-15 14:55:36'),
(19, 84, NULL, '2022-09-15 14:57:47', '2022-09-15 14:57:47'),
(20, 85, NULL, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(21, 86, NULL, '2022-09-19 19:31:13', '2022-09-19 19:31:13'),
(22, 87, NULL, '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(23, 88, NULL, '2022-09-21 07:14:46', '2022-09-21 07:14:46'),
(24, 89, NULL, '2022-09-21 07:18:58', '2022-09-21 07:18:58'),
(25, 90, NULL, '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(26, 91, NULL, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(27, 92, NULL, '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(28, 93, NULL, '2022-10-04 08:21:38', '2022-10-04 08:21:38');

-- --------------------------------------------------------

--
-- Table structure for table `user_channels`
--

CREATE TABLE `user_channels` (
  `id` int NOT NULL,
  `sender_id` int NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `channel_name` varchar(250) NOT NULL,
  `type` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL,
  `token` varchar(1000) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_channels`
--

INSERT INTO `user_channels` (`id`, `sender_id`, `user_id`, `channel_name`, `type`, `status`, `token`, `created_at`, `updated_at`) VALUES
(75, 83, 84, '1663256035960', 'voice', 'deactive', '123', '2022-09-15 15:31:18', '2022-09-15 15:31:28'),
(76, 83, 84, '1663256049105', 'voice', 'deactive', '123', '2022-09-15 15:31:31', '2022-09-15 15:31:57'),
(77, 84, 83, '1663255926771', 'voice', 'deactive', '123', '2022-09-15 15:32:06', '2022-09-15 15:32:13'),
(78, 84, 83, '1663255937789', 'voice', 'deactive', '123', '2022-09-15 15:32:17', '2022-09-15 15:32:33'),
(79, 83, 84, '1663320865027', 'voice', 'deactive', '123', '2022-09-16 09:31:47', '2022-09-16 09:32:03'),
(80, 83, 84, '1663338875605', 'voice', 'deactive', '123', '2022-09-16 14:31:58', '2022-09-16 14:32:05'),
(81, 86, 85, '1663615962753', 'video', 'deactive', '123', '2022-09-19 19:32:43', '2022-09-19 19:33:31'),
(82, 86, 85, '1663616012539', 'voice', 'deactive', '123', '2022-09-19 19:33:32', '2022-09-19 19:33:42'),
(83, 88, 89, '1663745000185', 'voice', 'deactive', '123', '2022-09-21 07:23:20', '2022-09-21 07:23:28'),
(84, 88, 89, '1663745014857', 'voice', 'deactive', '123', '2022-09-21 07:23:35', '2022-09-21 07:23:48'),
(85, 88, 89, '1663745029065', 'video', 'deactive', '123', '2022-09-21 07:23:49', '2022-09-21 07:29:47'),
(86, 88, 89, '1663745332431', 'video', 'deactive', '123', '2022-09-21 07:28:52', '2022-09-21 07:29:10'),
(87, 88, 89, '1663745350845', 'voice', 'deactive', '123', '2022-09-21 07:29:10', '2022-09-21 07:29:22'),
(88, 88, 89, '1663745529139', 'video', 'deactive', '123', '2022-09-21 07:32:09', '2022-09-21 07:32:29'),
(89, 88, 89, '1663745565849', 'voice', 'deactive', '123', '2022-09-21 07:32:45', '2022-09-21 07:32:58'),
(90, 90, 85, '1663929694514', 'video', 'deactive', '123', '2022-09-23 10:41:35', '2022-09-23 10:41:47'),
(91, 90, 85, '1663929722567', 'video', 'deactive', '123', '2022-09-23 10:42:03', '2022-09-23 10:42:14'),
(92, 85, 90, '1663929733005', 'voice', 'deactive', '123', '2022-09-23 10:42:16', '2022-09-23 10:42:16'),
(93, 85, 90, '1663929734863', 'voice', 'deactive', '123', '2022-09-23 10:42:18', '2022-09-23 10:42:44'),
(94, 85, 90, '1663929763281', 'voice', 'deactive', '123', '2022-09-23 10:42:46', '2022-09-23 10:42:52'),
(95, 85, 90, '1663929772285', 'voice', 'deactive', '123', '2022-09-23 10:42:55', '2022-09-23 10:43:11'),
(96, 84, 83, '1664196019361', 'voice', 'deactive', '123', '2022-09-26 12:40:19', '2022-09-26 12:40:30'),
(97, 84, 83, '1664196050431', 'voice', 'deactive', '123', '2022-09-26 12:40:50', '2022-09-26 12:41:02'),
(98, 84, 83, '1664196892282', 'voice', 'deactive', '123', '2022-09-26 12:54:52', '2022-09-26 12:54:59'),
(99, 84, 83, '1664196907852', 'voice', 'deactive', '123', '2022-09-26 12:55:08', '2022-09-26 12:55:28'),
(100, 84, 83, '1664197067038', 'voice', 'deactive', '123', '2022-09-26 12:57:47', '2022-09-26 12:58:24'),
(101, 84, 83, '1664197108377', 'voice', 'deactive', '123', '2022-09-26 12:58:28', '2022-09-26 12:58:35'),
(102, 84, 83, '1664197467104', 'voice', 'deactive', '123', '2022-09-26 13:04:27', '2022-09-26 13:04:40'),
(103, 84, 83, '1664197488956', 'voice', 'deactive', '123', '2022-09-26 13:04:49', '2022-09-26 13:05:16'),
(104, 84, 83, '1664197687632', 'voice', 'deactive', '123', '2022-09-26 13:08:07', '2022-09-26 13:08:21'),
(105, 84, 83, '1664197918062', 'voice', 'deactive', '123', '2022-09-26 13:11:58', '2022-09-26 13:12:04'),
(106, 84, 83, '1664197933429', 'voice', 'deactive', '123', '2022-09-26 13:12:13', '2022-09-26 13:12:31'),
(107, 84, 83, '1664197957000', 'voice', 'deactive', '123', '2022-09-26 13:12:37', '2022-09-26 13:12:44'),
(108, 84, 83, '1664197986660', 'voice', 'deactive', '123', '2022-09-26 13:13:06', '2022-09-26 13:13:28'),
(109, 84, 83, '1664198236318', 'voice', 'deactive', '123', '2022-09-26 13:17:16', '2022-09-26 13:17:36'),
(110, 84, 83, '1664198258304', 'voice', 'deactive', '123', '2022-09-26 13:17:38', '2022-09-26 13:17:47'),
(111, 84, 83, '1664198287490', 'voice', 'deactive', '123', '2022-09-26 13:18:07', '2022-09-26 13:18:20'),
(112, 84, 83, '1664198315861', 'voice', 'deactive', '123', '2022-09-26 13:18:36', '2022-09-26 13:18:43'),
(113, 84, 83, '1664198469547', 'voice', 'deactive', '123', '2022-09-26 13:21:09', '2022-09-26 13:21:21'),
(114, 84, 83, '1664198528554', 'voice', 'deactive', '123', '2022-09-26 13:22:08', '2022-09-26 13:22:27'),
(115, 84, 83, '1664198577860', 'voice', 'deactive', '123', '2022-09-26 13:22:58', '2022-09-26 13:23:02'),
(116, 84, 83, '1664198590812', 'voice', 'deactive', '123', '2022-09-26 13:23:11', '2022-09-26 13:23:21'),
(117, 84, 83, '1664198604447', 'voice', 'deactive', '123', '2022-09-26 13:23:24', '2022-09-26 13:23:37');

-- --------------------------------------------------------

--
-- Table structure for table `user_dislikes`
--

CREATE TABLE `user_dislikes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `user_like` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_hobbies`
--

CREATE TABLE `user_hobbies` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `hobbies_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_hobbies`
--

INSERT INTO `user_hobbies` (`id`, `user_id`, `hobbies_id`, `created_at`, `updated_at`) VALUES
(391, 78, 12, '2022-09-09 11:20:15', '2022-09-09 11:20:15'),
(392, 79, 1, '2022-09-09 11:23:43', '2022-09-09 11:23:43'),
(393, 79, 2, '2022-09-09 11:23:43', '2022-09-09 11:23:43'),
(394, 79, 11, '2022-09-09 11:23:43', '2022-09-09 11:23:43'),
(395, 79, 12, '2022-09-09 11:23:43', '2022-09-09 11:23:43'),
(399, 78, 1, '2022-09-10 08:10:05', '2022-09-10 08:10:05'),
(400, 78, 2, '2022-09-10 08:10:05', '2022-09-10 08:10:05'),
(401, 78, 11, '2022-09-10 08:10:05', '2022-09-10 08:10:05'),
(440, 83, 1, '2022-09-15 14:55:36', '2022-09-15 14:55:36'),
(441, 83, 2, '2022-09-15 14:55:36', '2022-09-15 14:55:36'),
(442, 83, 3, '2022-09-15 14:55:36', '2022-09-15 14:55:36'),
(443, 83, 4, '2022-09-15 14:55:36', '2022-09-15 14:55:36'),
(454, 84, 10, '2022-09-15 15:29:28', '2022-09-15 15:29:28'),
(455, 85, 1, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(456, 85, 2, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(457, 85, 3, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(458, 85, 4, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(459, 85, 5, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(460, 85, 6, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(461, 85, 7, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(462, 85, 8, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(463, 85, 9, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(464, 85, 10, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(465, 85, 11, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(466, 85, 12, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(489, 86, 11, '2022-09-19 19:36:42', '2022-09-19 19:36:42'),
(490, 86, 12, '2022-09-19 19:38:05', '2022-09-19 19:38:05'),
(491, 86, 1, '2022-09-19 19:38:05', '2022-09-19 19:38:05'),
(492, 86, 2, '2022-09-19 19:38:05', '2022-09-19 19:38:05'),
(493, 86, 3, '2022-09-19 19:38:05', '2022-09-19 19:38:05'),
(494, 86, 4, '2022-09-19 19:38:06', '2022-09-19 19:38:06'),
(495, 86, 5, '2022-09-19 19:38:06', '2022-09-19 19:38:06'),
(496, 86, 6, '2022-09-19 19:38:06', '2022-09-19 19:38:06'),
(497, 86, 7, '2022-09-19 19:38:06', '2022-09-19 19:38:06'),
(498, 86, 8, '2022-09-19 19:38:07', '2022-09-19 19:38:07'),
(499, 86, 9, '2022-09-19 19:38:07', '2022-09-19 19:38:07'),
(500, 86, 10, '2022-09-19 19:38:07', '2022-09-19 19:38:07'),
(501, 87, 2, '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(502, 87, 4, '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(503, 87, 6, '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(504, 87, 8, '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(505, 84, 12, '2022-09-20 15:50:08', '2022-09-20 15:50:08'),
(506, 84, 2, '2022-09-20 15:50:08', '2022-09-20 15:50:08'),
(507, 84, 6, '2022-09-20 15:50:08', '2022-09-20 15:50:08'),
(508, 84, 8, '2022-09-20 15:50:08', '2022-09-20 15:50:08'),
(509, 84, 9, '2022-09-20 15:50:08', '2022-09-20 15:50:08'),
(510, 88, 1, '2022-09-21 07:14:46', '2022-09-21 07:14:46'),
(511, 88, 3, '2022-09-21 07:14:46', '2022-09-21 07:14:46'),
(512, 89, 1, '2022-09-21 07:18:58', '2022-09-21 07:18:58'),
(513, 90, 1, '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(514, 90, 2, '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(515, 90, 3, '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(516, 90, 4, '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(517, 91, 1, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(518, 91, 2, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(519, 91, 3, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(520, 91, 4, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(521, 91, 5, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(522, 91, 6, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(523, 91, 7, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(524, 91, 8, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(525, 91, 9, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(526, 91, 10, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(527, 91, 11, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(528, 91, 12, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(529, 92, 3, '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(530, 92, 4, '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(531, 92, 6, '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(532, 92, 8, '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(533, 92, 12, '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(534, 93, 2, '2022-10-04 08:21:38', '2022-10-04 08:21:38');

-- --------------------------------------------------------

--
-- Table structure for table `user_images`
--

CREATE TABLE `user_images` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `u_images` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_images`
--

INSERT INTO `user_images` (`id`, `user_id`, `u_images`, `created_at`, `updated_at`) VALUES
(25, 83, 'https://merrimate.com/storage/profile/image_cropper_1663255748619.jpg', '2022-09-15 15:26:38', '2022-09-15 15:26:38'),
(26, 84, 'https://merrimate.com/storage/profile/image_cropper_1663255594280.jpg', '2022-09-15 15:26:50', '2022-09-15 15:26:50'),
(27, 86, 'https://merrimate.com/storage/profile/image_cropper_1663616193872.jpg', '2022-09-19 19:36:38', '2022-09-19 19:36:38');

-- --------------------------------------------------------

--
-- Table structure for table `user_likes`
--

CREATE TABLE `user_likes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `user_like` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_likes`
--

INSERT INTO `user_likes` (`id`, `user_id`, `user_like`, `created_at`, `updated_at`) VALUES
(228, 84, '78', '2022-09-15 15:24:51', '2022-09-15 15:24:51'),
(229, 84, '79', '2022-09-15 15:24:54', '2022-09-15 15:24:54'),
(230, 84, '81', '2022-09-15 15:25:00', '2022-09-15 15:25:00'),
(231, 84, '82', '2022-09-15 15:25:06', '2022-09-15 15:25:06'),
(232, 84, '83', '2022-09-15 15:25:08', '2022-09-15 15:25:08'),
(233, 85, '86', '2022-09-19 19:31:51', '2022-09-19 19:31:51'),
(234, 86, '85', '2022-09-19 19:31:52', '2022-09-19 19:31:52'),
(235, 89, '88', '2022-09-21 07:20:31', '2022-09-21 07:20:31'),
(236, 88, '89', '2022-09-21 07:22:25', '2022-09-21 07:22:25'),
(237, 85, '90', '2022-09-23 10:41:11', '2022-09-23 10:41:11'),
(238, 90, '86', '2022-09-23 10:41:17', '2022-09-23 10:41:17'),
(239, 90, '85', '2022-09-23 10:41:30', '2022-09-23 10:41:30'),
(240, 92, '86', '2022-09-25 08:19:33', '2022-09-25 08:19:33'),
(241, 92, '87', '2022-09-25 08:19:35', '2022-09-25 08:19:35'),
(242, 85, '92', '2022-09-25 08:20:04', '2022-09-25 08:20:04'),
(243, 83, '79', '2022-09-26 12:16:32', '2022-09-26 12:16:32'),
(244, 83, '84', '2022-09-26 13:38:20', '2022-09-26 13:38:20'),
(245, 93, '85', '2022-10-04 08:22:05', '2022-10-04 08:22:05'),
(246, 93, '90', '2022-10-04 08:22:09', '2022-10-04 08:22:09');

-- --------------------------------------------------------

--
-- Table structure for table `user_plans`
--

CREATE TABLE `user_plans` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `subscription_plan_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_plans`
--

INSERT INTO `user_plans` (`id`, `user_id`, `subscription_plan_id`, `created_at`, `updated_at`) VALUES
(13, 78, 1, '2022-09-09 11:20:16', '2022-09-09 11:20:16'),
(14, 79, 1, '2022-09-09 11:23:43', '2022-09-09 11:23:43'),
(18, 83, 1, '2022-09-15 14:55:36', '2022-09-15 14:55:36'),
(19, 84, 1, '2022-09-15 14:57:47', '2022-09-15 14:57:47'),
(20, 85, 1, '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(21, 86, 1, '2022-09-19 19:31:13', '2022-09-19 19:31:13'),
(22, 87, 1, '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(23, 88, 1, '2022-09-21 07:14:46', '2022-09-21 07:14:46'),
(24, 89, 1, '2022-09-21 07:18:58', '2022-09-21 07:18:58'),
(25, 90, 1, '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(26, 91, 1, '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(27, 92, 1, '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(28, 93, 1, '2022-10-04 08:21:38', '2022-10-04 08:21:38');

-- --------------------------------------------------------

--
-- Table structure for table `user_privacies`
--

CREATE TABLE `user_privacies` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `privacy_list_id` bigint UNSIGNED NOT NULL DEFAULT '4',
  `email` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `dob` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `phone` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `location` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `bio` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `gender` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `age_range` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '18 - 25',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_privacies`
--

INSERT INTO `user_privacies` (`id`, `user_id`, `privacy_list_id`, `email`, `dob`, `phone`, `location`, `bio`, `gender`, `age_range`, `created_at`, `updated_at`) VALUES
(12, 78, 4, '1', '1', '1', '1', '1', 'All', 'All', '2022-09-09 11:20:16', '2022-09-09 11:20:16'),
(13, 79, 4, '1', '1', '1', '1', '1', 'All', 'All', '2022-09-09 11:23:43', '2022-09-09 11:23:43'),
(17, 83, 4, '1', '1', '1', '1', '1', 'All', 'All', '2022-09-15 14:55:36', '2022-09-15 15:17:39'),
(18, 84, 4, '1', '1', '1', '1', '1', 'All', 'All', '2022-09-15 14:57:47', '2022-09-15 15:19:09'),
(19, 85, 4, '1', '1', '1', '1', '1', 'Man', '18 - 25', '2022-09-19 19:25:21', '2022-09-19 19:25:21'),
(20, 86, 4, '1', '1', '1', '1', '1', 'Woman', '18 - 25', '2022-09-19 19:31:13', '2022-09-19 19:31:13'),
(21, 87, 4, '1', '1', '1', '1', '1', 'Woman', '18 - 25', '2022-09-19 20:17:12', '2022-09-19 20:17:12'),
(22, 88, 4, '1', '1', '1', '1', '1', 'Man', '18 - 25', '2022-09-21 07:14:46', '2022-09-21 07:14:46'),
(23, 89, 4, '1', '1', '1', '1', '1', 'Man', '18 - 25', '2022-09-21 07:18:58', '2022-09-21 07:18:58'),
(24, 90, 4, '1', '1', '1', '1', '1', 'Man', '18 - 25', '2022-09-23 10:40:47', '2022-09-23 10:40:47'),
(25, 91, 4, '1', '1', '1', '1', '1', 'Man', '18 - 25', '2022-09-23 18:39:26', '2022-09-23 18:39:26'),
(26, 92, 4, '1', '1', '1', '1', '1', 'Woman', '18 - 25', '2022-09-25 08:18:39', '2022-09-25 08:18:39'),
(27, 93, 4, '1', '1', '1', '1', '1', 'Man', '18 - 25', '2022-10-04 08:21:38', '2022-10-04 08:21:38');

-- --------------------------------------------------------

--
-- Table structure for table `user_stories`
--

CREATE TABLE `user_stories` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `image` varchar(500) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_videos`
--

CREATE TABLE `user_videos` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `u_videos` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_videos`
--

INSERT INTO `user_videos` (`id`, `user_id`, `u_videos`, `created_at`, `updated_at`) VALUES
(43, 84, 'https://merrimate.com/storage/profile/VID-20220725-WA0002_trimmed:Sep15,2022-20:28:40.mp4', '2022-09-15 15:30:09', '2022-09-15 15:30:09'),
(44, 84, 'https://merrimate.com/storage/profile/VID-20220725-WA0002_trimmed:Sep15,2022-20:27:14.mp4', '2022-09-15 15:30:20', '2022-09-15 15:30:20'),
(46, 83, 'https://merrimate.com/storage/profile/VID-20220707-WA0000_trimmed:20Sep2022-18:03:01.mp4', '2022-09-20 13:00:26', '2022-09-20 13:00:26'),
(47, 83, 'https://merrimate.com/storage/profile/VID-20220705-WA0001_trimmed:20Sep2022-18:17:00.mp4', '2022-09-20 13:14:23', '2022-09-20 13:14:23');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `block_users`
--
ALTER TABLE `block_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `block_users_user_id_foreign` (`user_id`);

--
-- Indexes for table `boosters`
--
ALTER TABLE `boosters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `chat_details`
--
ALTER TABLE `chat_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_details_chat_history_id_foreign` (`chat_history_id`);

--
-- Indexes for table `chat_histories`
--
ALTER TABLE `chat_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_histories_user_id_foreign` (`user_id`);

--
-- Indexes for table `coin_histories`
--
ALTER TABLE `coin_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coin_histories_user_id_foreign` (`user_id`);

--
-- Indexes for table `coin_packages`
--
ALTER TABLE `coin_packages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coin_wallets`
--
ALTER TABLE `coin_wallets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_id` (`user_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `gifts`
--
ALTER TABLE `gifts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gift_images`
--
ALTER TABLE `gift_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `gift_images_gift_id_foreign` (`gift_id`);

--
-- Indexes for table `gift_variants`
--
ALTER TABLE `gift_variants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `gift_variants_gift_id_foreign` (`gift_id`);

--
-- Indexes for table `hobbies`
--
ALTER TABLE `hobbies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `like_counts`
--
ALTER TABLE `like_counts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `like_counts_user_id_foreign` (`user_id`);

--
-- Indexes for table `matched_users`
--
ALTER TABLE `matched_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_foreign` (`order_id`),
  ADD KEY `order_items_gift_id_foreign` (`gift_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `plan_transactions`
--
ALTER TABLE `plan_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_transactions_user_id_foreign` (`user_id`);

--
-- Indexes for table `privacy_lists`
--
ALTER TABLE `privacy_lists`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quizzes_user_id_foreign` (`user_id`);

--
-- Indexes for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quiz_questions_quiz_id_foreign` (`quiz_id`);

--
-- Indexes for table `quiz_results`
--
ALTER TABLE `quiz_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quiz_results_quiz_id_foreign` (`quiz_id`),
  ADD KEY `quiz_results_user_id_foreign` (`user_id`);

--
-- Indexes for table `sexuals`
--
ALTER TABLE `sexuals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `story_scenes`
--
ALTER TABLE `story_scenes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_id` (`user_id`);

--
-- Indexes for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `super_likes`
--
ALTER TABLE `super_likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `super_likes_user_id_foreign` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_sexual_id_foreign` (`sexual_id`);

--
-- Indexes for table `user_boosters`
--
ALTER TABLE `user_boosters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_boosters_user_id_foreign` (`user_id`),
  ADD KEY `user_boosters_booster_id_foreign` (`booster_id`);

--
-- Indexes for table `user_channels`
--
ALTER TABLE `user_channels`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_dislikes`
--
ALTER TABLE `user_dislikes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_dislikes_user_id_foreign` (`user_id`);

--
-- Indexes for table `user_hobbies`
--
ALTER TABLE `user_hobbies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_hobbies_user_id_foreign` (`user_id`),
  ADD KEY `user_hobbies_hobbies_id_foreign` (`hobbies_id`);

--
-- Indexes for table `user_images`
--
ALTER TABLE `user_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_images_user_id_foreign` (`user_id`);

--
-- Indexes for table `user_likes`
--
ALTER TABLE `user_likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_likes_user_id_foreign` (`user_id`);

--
-- Indexes for table `user_plans`
--
ALTER TABLE `user_plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_plans_user_id_foreign` (`user_id`),
  ADD KEY `user_plans_subscription_plan_id_foreign` (`subscription_plan_id`);

--
-- Indexes for table `user_privacies`
--
ALTER TABLE `user_privacies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_privacies_user_id_foreign` (`user_id`),
  ADD KEY `user_privacies_privacy_list_id_foreign` (`privacy_list_id`);

--
-- Indexes for table `user_stories`
--
ALTER TABLE `user_stories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_videos`
--
ALTER TABLE `user_videos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_videos_user_id_foreign` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `block_users`
--
ALTER TABLE `block_users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `boosters`
--
ALTER TABLE `boosters`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `chat_details`
--
ALTER TABLE `chat_details`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=239;

--
-- AUTO_INCREMENT for table `chat_histories`
--
ALTER TABLE `chat_histories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=241;

--
-- AUTO_INCREMENT for table `coin_histories`
--
ALTER TABLE `coin_histories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `coin_packages`
--
ALTER TABLE `coin_packages`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `coin_wallets`
--
ALTER TABLE `coin_wallets`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gifts`
--
ALTER TABLE `gifts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `gift_images`
--
ALTER TABLE `gift_images`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `gift_variants`
--
ALTER TABLE `gift_variants`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `hobbies`
--
ALTER TABLE `hobbies`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `like_counts`
--
ALTER TABLE `like_counts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `matched_users`
--
ALTER TABLE `matched_users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `plan_transactions`
--
ALTER TABLE `plan_transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `privacy_lists`
--
ALTER TABLE `privacy_lists`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `quizzes`
--
ALTER TABLE `quizzes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `quiz_results`
--
ALTER TABLE `quiz_results`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `sexuals`
--
ALTER TABLE `sexuals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `story_scenes`
--
ALTER TABLE `story_scenes`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `super_likes`
--
ALTER TABLE `super_likes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT for table `user_boosters`
--
ALTER TABLE `user_boosters`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `user_channels`
--
ALTER TABLE `user_channels`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- AUTO_INCREMENT for table `user_dislikes`
--
ALTER TABLE `user_dislikes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `user_hobbies`
--
ALTER TABLE `user_hobbies`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=535;

--
-- AUTO_INCREMENT for table `user_images`
--
ALTER TABLE `user_images`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `user_likes`
--
ALTER TABLE `user_likes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=247;

--
-- AUTO_INCREMENT for table `user_plans`
--
ALTER TABLE `user_plans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `user_privacies`
--
ALTER TABLE `user_privacies`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `user_stories`
--
ALTER TABLE `user_stories`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `user_videos`
--
ALTER TABLE `user_videos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `block_users`
--
ALTER TABLE `block_users`
  ADD CONSTRAINT `block_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `chat_details`
--
ALTER TABLE `chat_details`
  ADD CONSTRAINT `chat_details_chat_history_id_foreign` FOREIGN KEY (`chat_history_id`) REFERENCES `chat_histories` (`id`);

--
-- Constraints for table `chat_histories`
--
ALTER TABLE `chat_histories`
  ADD CONSTRAINT `chat_histories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `gift_images`
--
ALTER TABLE `gift_images`
  ADD CONSTRAINT `gift_images_gift_id_foreign` FOREIGN KEY (`gift_id`) REFERENCES `gifts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `gift_variants`
--
ALTER TABLE `gift_variants`
  ADD CONSTRAINT `gift_variants_gift_id_foreign` FOREIGN KEY (`gift_id`) REFERENCES `gifts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `like_counts`
--
ALTER TABLE `like_counts`
  ADD CONSTRAINT `like_counts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `plan_transactions`
--
ALTER TABLE `plan_transactions`
  ADD CONSTRAINT `plan_transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD CONSTRAINT `quiz_questions_quiz_id_foreign` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`);

--
-- Constraints for table `story_scenes`
--
ALTER TABLE `story_scenes`
  ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `super_likes`
--
ALTER TABLE `super_likes`
  ADD CONSTRAINT `super_likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_sexual_id_foreign` FOREIGN KEY (`sexual_id`) REFERENCES `sexuals` (`id`);

--
-- Constraints for table `user_boosters`
--
ALTER TABLE `user_boosters`
  ADD CONSTRAINT `user_boosters_booster_id_foreign` FOREIGN KEY (`booster_id`) REFERENCES `boosters` (`id`),
  ADD CONSTRAINT `user_boosters_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_dislikes`
--
ALTER TABLE `user_dislikes`
  ADD CONSTRAINT `user_dislikes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_hobbies`
--
ALTER TABLE `user_hobbies`
  ADD CONSTRAINT `user_hobbies_hobbies_id_foreign` FOREIGN KEY (`hobbies_id`) REFERENCES `hobbies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_hobbies_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_images`
--
ALTER TABLE `user_images`
  ADD CONSTRAINT `user_images_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_likes`
--
ALTER TABLE `user_likes`
  ADD CONSTRAINT `user_likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_plans`
--
ALTER TABLE `user_plans`
  ADD CONSTRAINT `user_plans_subscription_plan_id_foreign` FOREIGN KEY (`subscription_plan_id`) REFERENCES `subscription_plans` (`id`),
  ADD CONSTRAINT `user_plans_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_privacies`
--
ALTER TABLE `user_privacies`
  ADD CONSTRAINT `user_privacies_privacy_list_id_foreign` FOREIGN KEY (`privacy_list_id`) REFERENCES `privacy_lists` (`id`),
  ADD CONSTRAINT `user_privacies_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_videos`
--
ALTER TABLE `user_videos`
  ADD CONSTRAINT `user_videos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
