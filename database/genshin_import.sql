-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 28, 2026 at 05:12 AM
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
-- Database: `genshin_import`
--

-- --------------------------------------------------------

--
-- Table structure for table `artifacts`
--

DROP TABLE IF EXISTS `artifacts`;
CREATE TABLE IF NOT EXISTS `artifacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `set_name` varchar(255) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT 0.00,
  `image_url` varchar(255) DEFAULT NULL,
  `rarity` int(11) DEFAULT 4,
  `stock` int(11) NOT NULL DEFAULT 10,
  `description` text DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `artifacts`
--

INSERT INTO `artifacts` (`id`, `name`, `set_name`, `type`, `price`, `image_url`, `rarity`, `stock`, `description`) VALUES
(1, 'Crimson Witch of Flames', 'Crimson Witch', 'Flower', 500.00, 'https://paimon.moe/images/artifacts/crimson_witch_of_flames.png', 4, 10, 'Some powerfull artifact i guess'),
(2, 'Heart of Depth', 'Heart of Depth', 'Flower', 500.00, 'https://paimon.moe/images/artifacts/heart_of_depth.png', 4, 10, 'To infinity and beyond');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
CREATE TABLE IF NOT EXISTS `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `weapon_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `role` varchar(20) DEFAULT 'user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `token`, `role`) VALUES
(17, 'xiao', 'xiao@liyue.com', 'xiaomima', '24dad96fc384eaefcbb8300fad1fd221', 'user'),
(18, 'test', 'test@test.com', 'testingthis', 'e4d647352c437a1e0c73d43e79790e74', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `weapons`
--

DROP TABLE IF EXISTS `weapons`;
CREATE TABLE IF NOT EXISTS `weapons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `element` varchar(100) DEFAULT 'none',
  `rarity` int(11) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `stock` int(11) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `attack` int(11) DEFAULT 0,
  `crit_rate` decimal(5,2) DEFAULT 0.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weapons`
--

INSERT INTO `weapons` (`id`, `name`, `type`, `element`, `rarity`, `price`, `stock`, `description`, `image_url`, `attack`, `crit_rate`) VALUES
(1, 'Staff of Homa', 'Polearm', 'none', 5, 2000.00, 8, 'A staff of vermilion red that seems to have a faint, ominous glow.', 'https://paimon.moe/images/weapons/staff_of_homa.png', 608, 66.20),
(2, 'Primordial Jade Winged-Spear', 'polearm', 'none', 4, 1800.00, 10, 'A polearm of the ancient jade dragons, capable of piercing through anything.', '', 674, 0.00),
(3, 'Elegy for the End', 'Bow', 'none', 5, 1500.00, 8, 'A longbow that sighs in the wind, mourning the fallen.', 'https://paimon.moe/images/weapons/elegy_for_the_end.png', 608, 0.00),
(4, 'Skyward Blade', 'Sword', 'none', 5, 1200.00, 13, 'The sword of a knight who once served the Anemo Archon.', 'https://paimon.moe/images/weapons/skyward_blade.png', 608, 4.00),
(5, 'Wolfs Gravestone', 'claymore', 'none', 4, 1900.00, 10, 'A legendary claymore used to fell the wolf king.', '', 608, 0.00),
(8, 'sword small', 'sword', 'none', 4, 9999.00, 1, 'a sword, but small', '', 9999, 0.00);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
