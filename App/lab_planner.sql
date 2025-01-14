-- phpMyAdmin SQL Dump
-- version 5.2.1deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Gegenereerd op: 03 dec 2024 om 13:30
-- Serverversie: 10.11.6-MariaDB-0+deb12u1
-- PHP-versie: 8.2.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lab_planner`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `alembic_version`
--

CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `alembic_version`
--

INSERT INTO `alembic_version` (`version_num`) VALUES
('fe314fbf7184');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `animals`
--

CREATE TABLE `animals` (
  `animalId` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `animalTypeId` int(11) DEFAULT NULL,
  `birthDate` date DEFAULT NULL,
  `sicknesses` text DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `animals`
--

INSERT INTO `animals` (`animalId`, `name`, `animalTypeId`, `birthDate`, `sicknesses`, `description`) VALUES
(36, 'Stefan', 14, '2024-12-24', 'none', 'none');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `animaltypes`
--

CREATE TABLE `animaltypes` (
  `animalTypeId` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `animaltypes`
--

INSERT INTO `animaltypes` (`animalTypeId`, `name`) VALUES
(12, 'Geese'),
(13, 'Chicken'),
(14, 'Cow'),
(15, 'Horse'),
(16, 'Sheep'),
(17, 'Bird'),
(18, 'Pig');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `dailytasks`
--

CREATE TABLE `dailytasks` (
  `dailyTaskId` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `priority` smallint(6) DEFAULT NULL,
  `taskType` int(11) DEFAULT NULL,
  `finished` smallint(6) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL,
  `doneDate` datetime DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `stockId` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `foodtypes`
--

CREATE TABLE `foodtypes` (
  `foodTypeId` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `foodtypes`
--

INSERT INTO `foodtypes` (`foodTypeId`, `name`) VALUES
(11, 'Hay'),
(12, 'Straw'),
(13, 'Cow food'),
(14, 'Pig food'),
(15, 'Geese food'),
(16, 'Pigeon food'),
(17, 'finches food'),
(18, 'quail food'),
(19, 'Chicken food'),
(20, 'Sheep food'),
(21, 'Straw');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `foodtypes_animals`
--

CREATE TABLE `foodtypes_animals` (
  `foodTypesAnimalsId` int(11) NOT NULL,
  `foodTypeId` int(11) DEFAULT NULL,
  `animalTypeId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `foodtypes_animals`
--

INSERT INTO `foodtypes_animals` (`foodTypesAnimalsId`, `foodTypeId`, `animalTypeId`) VALUES
(47, 21, 15),
(48, 21, 14);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `messages`
--

CREATE TABLE `messages` (
  `messageId` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `messages`
--

INSERT INTO `messages` (`messageId`, `title`, `description`) VALUES
(3, 'Test', 'Lorem\r\n'),
(4, 'Test message 2', 'Lorem ipsum dolor');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `rapports`
--

CREATE TABLE `rapports` (
  `rapportId` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `photos` text DEFAULT NULL,
  `exceptionalities` text DEFAULT NULL,
  `date` date DEFAULT NULL,
  `userId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `rapports`
--

INSERT INTO `rapports` (`rapportId`, `title`, `description`, `photos`, `exceptionalities`, `date`, `userId`) VALUES
(27, 'jakubski : 2024-11-21 10:01:45.954595', NULL, NULL, 'None', '2024-11-21', 43),
(28, 'jakubski : 2024-11-25', NULL, NULL, 'None', '2024-11-25', 43),
(30, 'jakubski : 2024-11-26', NULL, NULL, 'found 5 eggs.', '2024-11-26', 43),
(33, 'jakubski : 2024-11-27', NULL, NULL, 'None', '2024-11-27', 43),
(35, 'jakubski : 2024-11-28', NULL, NULL, 'None', '2024-11-28', 43);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `rapport_tasks`
--

CREATE TABLE `rapport_tasks` (
  `rapportTasksId` int(11) NOT NULL,
  `rapportId` int(11) NOT NULL,
  `taskId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `stocks`
--

CREATE TABLE `stocks` (
  `stockId` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `foodTypeId` int(11) DEFAULT NULL,
  `minimumQuantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `stocks`
--

INSERT INTO `stocks` (`stockId`, `quantity`, `foodTypeId`, `minimumQuantity`) VALUES
(36, 186, 19, 200),
(37, 150, 13, 200),
(38, 900, 17, 200),
(39, 995, 15, 200),
(40, 995, 11, 200),
(41, 900, 16, 200),
(42, 1000, 14, 200),
(43, 985, 18, 200),
(44, 1000, 20, 200),
(46, 1000, 21, 150);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `tasks`
--

CREATE TABLE `tasks` (
  `taskId` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `priority` smallint(6) DEFAULT NULL,
  `taskType` int(11) DEFAULT NULL,
  `finished` smallint(6) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL,
  `doneDate` datetime DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `stockId` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `daily` tinyint(4) DEFAULT NULL,
  `rapportId` int(11) DEFAULT NULL,
  `animalTypeId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `tasks`
--

INSERT INTO `tasks` (`taskId`, `title`, `description`, `priority`, `taskType`, `finished`, `createdDate`, `doneDate`, `deadline`, `stockId`, `quantity`, `daily`, `rapportId`, `animalTypeId`) VALUES
(227, 'gfgadfdsaf', 'fdsfadsfdsafasfds', 2, 15, 1, '2024-11-25 10:41:57', NULL, NULL, NULL, 0, 0, 28, 14),
(229, 'fdasfsfsfdsaf', 'fdsfadsfsfafdsfdsfs', 2, 15, 0, '2024-11-25 10:42:18', NULL, NULL, NULL, 0, 0, 28, 18),
(231, 'fsdfsffsfs', 'fdsfsfdsf', 2, 15, 0, '2024-11-25 12:24:29', NULL, NULL, NULL, 0, 0, 28, NULL),
(232, 'hshshs', 'hshdhs', 2, 15, 0, '2024-11-25 12:48:40', NULL, NULL, NULL, 0, 0, 28, 14),
(233, 'ddudyddydy', 'yeyeey', 1, 15, 0, '2024-11-25 12:53:49', NULL, NULL, NULL, 0, 0, 28, 14),
(240, 'Clean and refill food/water bowls for finches.', 'Use the finch food. Add vitamins to the water for all birds.', 2, 14, 1, '2024-11-26 11:39:38', NULL, NULL, 38, 5, 1, 30, 17),
(241, 'Clean and refill food/water bowls for chinese Dwarf Quails', 'Use the quail food. Add vitamins to water for all birds.', 1, 14, 1, '2024-11-26 11:40:37', NULL, NULL, 43, 5, 1, 30, 17),
(242, 'Clean and refill the food bowls for pigeons', 'Use pigeon food and the specified grit. Add vitamins to water for all birds.', 1, 14, 1, '2024-11-26 11:41:29', NULL, NULL, 41, 5, 1, 30, 17),
(243, 'Clean the aviary cage.', 'Clean the finch house only if no finches are living in them.', 2, 15, 1, '2024-11-26 11:43:08', NULL, NULL, NULL, 0, 1, 30, 17),
(244, 'Add nest material as needed to houses.', 'Do not forget the houses of the Dwarf Quails!', 2, 15, 1, '2024-11-26 11:44:38', NULL, NULL, NULL, 0, 1, 30, 17),
(245, 'Put fallen perches back on their place.', '.', 2, 15, 1, '2024-11-26 11:45:12', NULL, NULL, NULL, 0, 1, 30, 17),
(246, 'Record any deaths', 'Record any deaths in the exceptionalities field in your rapport.', 2, 16, 0, '2024-11-26 11:45:48', NULL, NULL, NULL, 0, 1, 30, 17),
(247, 'Record any new births.', '.', 2, 16, 0, '2024-11-26 11:46:25', NULL, NULL, NULL, 0, 1, 30, 17),
(248, 'Egg collection', 'Remove pigeon eggs daily from under the pigeons.', 2, 16, 1, '2024-11-26 11:46:59', NULL, NULL, NULL, 0, 1, 30, 17),
(249, 'Check for ratholes and close them with stones and sand.', '.', 2, 16, 1, '2024-11-26 11:47:35', NULL, NULL, NULL, 0, 1, 30, 17),
(250, 'Feed and give water to the the pigs.', 'Use the pig pellets.', 2, 14, 0, '2024-11-26 12:17:56', NULL, NULL, 42, 5, 1, NULL, 18),
(251, 'Add straw if needed.', '.', 2, 14, 0, '2024-11-26 12:20:23', NULL, NULL, NULL, 0, 1, NULL, 18),
(252, 'Note any special observations.', 'Note them in the exceptionality field in the rapport.', 2, 16, 0, '2024-11-26 12:21:39', NULL, NULL, NULL, 0, 1, 30, 18),
(254, 'Clean the feed machines from outside to inside.', '.', 2, 15, 0, '2024-11-26 12:22:51', NULL, NULL, NULL, 0, 1, 30, 13),
(255, 'Collect the eggs.', 'Collect the eggs and take the directly to building M. Date the eggs with a pencil and place them in a cardboard egg carton. Store the cartons in the cabinet and log the number of eggs collected.', 2, 16, 0, '2024-11-26 12:23:53', NULL, NULL, NULL, 0, 1, 30, 13),
(256, 'Clean and refill grit bowls.', '.', 2, 15, 0, '2024-11-26 12:24:23', NULL, NULL, NULL, 0, 1, 30, 13),
(257, 'Put fallen perches back on their place.', '.', 1, 15, 0, '2024-11-26 12:24:48', NULL, NULL, NULL, 0, 1, 30, 13),
(258, 'Check for ratholes and close them with stones and sand. Report in the exceptionality in the rapport.', '.', 1, 16, 0, '2024-11-26 12:25:36', NULL, NULL, NULL, 0, 1, 30, 13),
(259, 'Check if the electric fence is on.', '.', 1, 16, 0, '2024-11-26 12:25:57', NULL, NULL, NULL, 0, 1, 30, 13),
(261, 'Feed the goose.', '.', 2, 14, 0, '2024-11-26 12:27:11', NULL, NULL, 39, 5, 1, 30, 12),
(262, 'Clean and refill the pond.', '.', 2, 15, 0, '2024-11-26 12:27:35', NULL, NULL, NULL, 0, 1, 30, 12),
(263, 'Clean the geese houses.', '.', 2, 15, 0, '2024-11-26 12:27:56', NULL, NULL, NULL, 0, 1, 30, 12),
(264, 'Remove anny eggs.', 'Put the removed eggs in building M with the other eggs.', 2, 16, 0, '2024-11-26 12:28:28', NULL, NULL, NULL, 0, 1, 30, 12),
(265, 'Feed the horses.', 'Use hay, and chec', 1, 14, 0, '2024-11-26 12:29:22', NULL, NULL, 40, 5, 1, 30, 15),
(266, 'Clean and refill the water and provide pellets.', '.', 2, 14, 0, '2024-11-26 12:29:51', NULL, NULL, NULL, 0, 1, 30, 15),
(267, 'Remove manure from the floors on the ground.', '.', 2, 15, 0, '2024-11-26 12:30:16', NULL, NULL, NULL, 0, 1, 30, 15),
(270, 'Clean the floor and add straw if needed.', '.', 2, 15, 0, '2024-11-26 12:32:26', NULL, NULL, NULL, 0, 1, 30, 16),
(272, 'Clean and refill the food and water bowls.', 'Fill the feed bowls with pellets and hay.', 2, 14, 0, '2024-11-26 14:07:31', NULL, NULL, 37, 5, 1, 30, 14),
(274, 'Check if the salt lick is still hanging and in good condition.', '.', 2, 14, 0, '2024-11-26 14:08:51', NULL, NULL, NULL, 0, 1, 30, 14),
(277, 'Brush the cows.', '.', 1, 17, 0, '2024-11-26 14:10:18', NULL, NULL, NULL, 0, 0, 30, NULL),
(278, 'Organize and clean the hay tent.', '.', 1, 17, 0, '2024-11-26 14:10:38', NULL, NULL, NULL, 0, 1, 30, NULL),
(279, 'Clean tools and put them back neatly.', '.', 1, 17, 0, '2024-11-26 14:10:54', NULL, NULL, NULL, 0, 1, 30, NULL),
(280, 'Monitor the inventory of animal supplies.', '.', 1, 17, 0, '2024-11-26 14:11:19', NULL, NULL, NULL, 0, 1, 30, NULL),
(549, 'Clean and refill food/water/grit bowls for finches.', 'Use the finch food, and the specified grit. Add vitamins to the water for all birds.', 2, 14, 1, '2024-11-27 10:55:43', NULL, NULL, 38, 5, 0, 33, 17),
(552, 'Clean the aviary cage.', 'Clean the finch house only if no finches are living in them.', 2, 15, 1, '2024-11-27 10:55:43', NULL, NULL, NULL, 0, 0, 33, 17),
(553, 'Add nest material as needed to houses.', 'Do not forget the houses of the Dwarf Quails!', 2, 15, 1, '2024-11-27 10:55:43', NULL, NULL, NULL, 0, 0, 33, 17),
(554, 'Put fallen perches back on their place.', '.', 2, 15, 1, '2024-11-27 10:55:43', NULL, NULL, NULL, 0, 0, NULL, 17),
(555, 'Record any deaths', 'Record any deaths in the exceptionalities field in your rapport.', 2, 16, 1, '2024-11-27 10:55:43', NULL, NULL, NULL, 0, 0, 33, 17),
(556, 'Record any new births.', '.', 2, 16, 1, '2024-11-27 10:55:43', NULL, NULL, NULL, 0, 0, 33, 17),
(557, 'Egg collection', 'Remove pigeon eggs daily from under the pigeons.', 2, 16, 1, '2024-11-27 10:55:43', NULL, NULL, NULL, 0, 0, 33, 17),
(558, 'Check for ratholes and close them with stones and sand.', '.', 2, 16, 1, '2024-11-27 10:55:43', NULL, NULL, NULL, 0, 0, 33, 17),
(559, 'Feed and give water to the the pigs.', 'Use the pig pellets.', 2, 14, 0, '2024-11-27 10:55:44', NULL, NULL, 42, 5, 0, NULL, 18),
(561, 'Note any special observations.', 'Note them in the exceptionality field in the rapport.', 2, 16, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, 18),
(562, 'Clean the feed machines from outside to inside.', '.', 2, 15, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, NULL, 13),
(570, 'Clean and refill the pond.', '.', 2, 15, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, 12),
(572, 'Remove any eggs.', 'Put the removed eggs in building M with the other eggs.', 2, 16, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, NULL, 12),
(573, 'Feed the horses.', 'Use hay, and chec', 1, 14, 0, '2024-11-27 10:55:44', NULL, NULL, 40, 5, 0, 33, 15),
(574, 'Clean and refill the water and provide pellets.', '.', 2, 14, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, 15),
(575, 'Remove manure from the floors on the ground.', '.', 2, 15, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, 15),
(576, 'Clean and refill water bowls, with vitamin C, check the salt lick.', '.', 2, 15, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, 16),
(577, 'Clean the floor and add straw if needed.', '.', 2, 15, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, 16),
(578, 'Feed the sheep.', '.', 2, 14, 0, '2024-11-27 10:55:44', NULL, NULL, 44, 8, 0, 33, 16),
(581, 'Check if the salt lick is still hanging and in good condition.', '.', 2, 14, 1, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, 14),
(583, 'Brush the horses.', '.', 1, 17, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, NULL),
(584, 'Organize and clean the hay tent. ye', '.', 1, 17, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, NULL, NULL),
(585, 'Clean tools and put them back neatly.', '.', 1, 17, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, NULL),
(586, 'Monitor the inventory of animal supplies.', '.', 1, 17, 0, '2024-11-27 10:55:44', NULL, NULL, NULL, 0, 0, 33, NULL),
(627, 'Clean and refill food/water/grit bowls for chinese Dwarf Quailsss', 'Use the quail food and the specified grit. Add vitamins to water for all birds.', 1, 14, 0, '2024-11-28 14:43:53', NULL, NULL, 43, 5, 0, NULL, 17),
(628, 'Clean and refill the food bowls for pigeons', 'Use pigeon food and the specified grit. Add vitamins to water for all birds.', 1, 14, 0, '2024-11-28 14:43:53', NULL, NULL, 41, 5, 0, NULL, 17),
(630, 'Add nest material as needed to houses.', 'Do not forget the houses of the Dwarf Quails!', 2, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 17),
(631, 'Put fallen perches back on their placee.', '.', 2, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 17),
(632, 'Record any deaths', 'Record any deaths in the exceptionalities field in your rapport.', 2, 16, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 17),
(633, 'Record any new births.', '.', 2, 16, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 17),
(634, 'Egg collection', 'Remove pigeon eggs daily from under the pigeons.', 2, 16, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 17),
(635, 'Check for ratholes and close them with stones and sand.', '.', 2, 16, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 17),
(636, 'Feed and give water to the the pigs.', 'Use the pig pellets.', 2, 14, 0, '2024-11-28 14:43:53', NULL, NULL, 42, 5, 0, NULL, 18),
(637, 'Add straw if needed.', '.', 2, 14, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 18),
(638, 'Note any special observations.', 'Note them in the exceptionality field in the rapport.', 2, 16, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 18),
(639, 'Clean the feed machines from outside to inside.', '.', 2, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 13),
(640, 'Collect the eggs.', 'Collect the eggs and take the directly to building M. Date the eggs with a pencil and place them in a cardboard egg carton. Store the cartons in the cabinet and log the number of eggs collected.', 2, 16, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 13),
(641, 'Clean and refill grit bowls.', '.', 2, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 13),
(642, 'Put fallen perches back on their place.', '.', 1, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 13),
(643, 'Check for ratholes and close them with stones and sand. Report in the exceptionality in the rapport.', '.', 1, 16, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 13),
(644, 'Check if the electric fence is on.', '.', 1, 16, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 13),
(645, 'Feed the goose.', '.', 2, 14, 0, '2024-11-28 14:43:53', NULL, NULL, 39, 5, 0, NULL, 12),
(646, 'Clean and refill the pond.', '.', 2, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 12),
(647, 'Clean the geese houses.', '.', 2, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 12),
(648, 'Remove anny eggs.', 'Put the removed eggs in building M with the other eggs.', 2, 16, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 12),
(649, 'Feed the horses.', 'Use hay, and chec', 1, 14, 0, '2024-11-28 14:43:53', NULL, NULL, 40, 5, 0, NULL, 15),
(650, 'Clean and refill the water and provide pellets.', '.', 2, 14, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 15),
(651, 'Remove manure from the floors on the ground.', '.', 2, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 15),
(652, 'Clean and refill water bowls, with vitamin C, check the salt lick.', '.', 2, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 16),
(653, 'Clean the floor and add straw if needed.', '.', 2, 15, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 16),
(654, 'Feed the sheep.', '.', 2, 14, 0, '2024-11-28 14:43:53', NULL, NULL, 44, 8, 0, NULL, 16),
(655, 'Clean and refill the food and water bowls.', 'Fill the feed bowls with pellets and hay.', 2, 14, 0, '2024-11-28 14:43:53', NULL, NULL, 37, 5, 0, NULL, 14),
(656, 'Check if the salt lick is still hanging and in good condition.', '.', 2, 14, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, 14),
(657, 'Organize and clean the hay tent.', '.', 1, 17, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, NULL),
(658, 'Clean tools and put them back neatly.', '.', 1, 17, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, NULL),
(659, 'Monitor the inventory of animal supplies.', '.', 1, 17, 0, '2024-11-28 14:43:53', NULL, NULL, NULL, 0, 0, NULL, NULL),
(662, 'nieuwe taak test pig', 'dsa', 1, 15, NULL, '2024-11-29 14:27:57', NULL, NULL, NULL, 0, 0, NULL, 18),
(663, 'Add new test cow', 'gdgd', 2, 17, NULL, '2024-11-29 14:30:08', NULL, NULL, NULL, 0, 0, NULL, 14),
(664, 'bdhdhs', 'bdbdbdj', 2, 16, NULL, '2024-11-29 14:30:55', NULL, NULL, NULL, 0, 0, NULL, 13),
(666, 'Clean and refill food/water/grit bowls for finches.', 'Use the finch food, and the specified grit. Add vitamins to the water for all birds.', 2, 14, 0, '2024-11-29 14:43:54', NULL, NULL, 38, 5, 0, NULL, 17),
(667, 'Clean and refill food/water/grit bowls for chinese Dwarf Quails', 'Use the quail food and the specified grit. Add vitamins to water for all birds.', 1, 14, 0, '2024-11-29 14:43:54', NULL, NULL, 43, 5, 0, NULL, 17),
(668, 'Clean and refill the food bowls for pigeons', 'Use pigeon food and the specified grit. Add vitamins to water for all birds.', 1, 14, 0, '2024-11-29 14:43:54', NULL, NULL, 41, 5, 0, NULL, 17),
(669, 'Clean the aviary cage.', 'Clean the finch house only if no finches are living in them.', 2, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 17),
(670, 'Add nest material as needed to houses.', 'Do not forget the houses of the Dwarf Quails!', 2, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 17),
(671, 'Put fallen perches back on their place.', '.', 2, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 17),
(672, 'Record any deaths', 'Record any deaths in the exceptionalities field in your rapport.', 2, 16, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 17),
(673, 'Record any new births.', '.', 2, 16, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 17),
(674, 'Egg collection', 'Remove pigeon eggs daily from under the pigeons.', 2, 16, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 17),
(675, 'Check for ratholes and close them with stones and sand.', '.', 2, 16, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 17),
(676, 'Feed and give water to the the pigs.', 'Use the pig pellets.', 2, 14, 0, '2024-11-29 14:43:54', NULL, NULL, 42, 5, 0, NULL, 18),
(677, 'Add straw if needed.', '.', 2, 14, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 18),
(678, 'Note any special observations.', 'Note them in the exceptionality field in the rapport.', 2, 16, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 18),
(679, 'Clean the feed machines from outside to inside.', '.', 2, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 13),
(680, 'Collect the eggs.', 'Collect the eggs and take the directly to building M. Date the eggs with a pencil and place them in a cardboard egg carton. Store the cartons in the cabinet and log the number of eggs collected.', 2, 16, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 13),
(681, 'Clean and refill grit bowls.', '.', 2, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 13),
(682, 'Put fallen perches back on their place.', '.', 1, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 13),
(683, 'Check for ratholes and close them with stones and sand. Report in the exceptionality in the rapport.', '.', 1, 16, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 13),
(684, 'Check if the electric fence is on.', '.', 1, 16, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 13),
(685, 'Feed the goose.', '.', 2, 14, 0, '2024-11-29 14:43:54', NULL, NULL, 39, 5, 0, NULL, 12),
(686, 'Clean and refill the pond.', '.', 2, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 12),
(687, 'Clean the geese houses.', '.', 2, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 12),
(688, 'Remove anny eggs.', 'Put the removed eggs in building M with the other eggs.', 2, 16, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 12),
(689, 'Feed the horses.', 'Use hay, and chec', 1, 14, 0, '2024-11-29 14:43:54', NULL, NULL, 40, 5, 0, NULL, 15),
(690, 'Clean and refill the water and provide pellets.', '.', 2, 14, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 15),
(691, 'Remove manure from the floors on the ground.', '.', 2, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 15),
(692, 'Clean the floor and add straw if needed.', '.', 2, 15, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 16),
(693, 'Clean and refill the food and water bowls.', 'Fill the feed bowls with pellets and hay.', 2, 14, 0, '2024-11-29 14:43:54', NULL, NULL, 37, 5, 0, NULL, 14),
(694, 'Check if the salt lick is still hanging and in good condition.', '.', 2, 14, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, 14),
(695, 'Organize and clean the hay tent.', '.', 1, 17, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, NULL),
(696, 'Clean tools and put them back neatly.', '.', 1, 17, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, NULL),
(697, 'Monitor the inventory of animal supplies.', '.', 1, 17, 0, '2024-11-29 14:43:54', NULL, NULL, NULL, 0, 0, NULL, NULL),
(699, 'fdsafsdfd', 'fdsfdsfdfs', 1, 14, NULL, '2024-11-29 14:50:32', NULL, NULL, NULL, 0, 0, NULL, NULL),
(700, 'nieuwe taak test', 'fdsfsdfsd', 1, 16, NULL, '2024-11-29 15:04:32', NULL, NULL, NULL, 0, 0, NULL, 14),
(701, 'Nieuwe taak test nog eens cow.', 'fdsf', 1, 15, NULL, '2024-11-29 15:04:56', NULL, NULL, NULL, 0, 0, NULL, 14),
(702, 'nieuwe taak testitto pig', 'fdsfsdf', 1, 14, NULL, '2024-11-29 15:05:43', NULL, NULL, NULL, 0, 0, NULL, 18),
(703, 'nieuwe takkitoagjfkfds', 'fdsfsfsdfds', 2, 14, NULL, '2024-11-29 15:06:11', NULL, NULL, NULL, 0, 0, NULL, NULL),
(705, 'Bird taak test', 'fdsfafds', 1, 15, NULL, '2024-11-29 15:09:58', NULL, NULL, NULL, 0, 0, NULL, 17),
(706, 'fdsafasfdsf', 'sfdsfsfsdf', 1, 15, NULL, '2024-11-29 15:10:37', NULL, NULL, NULL, 0, 0, NULL, NULL),
(718, 'Feed and give water to the the pigs.', 'Use the pig pellets.', 2, 14, 0, '2024-12-02 08:16:50', NULL, NULL, 42, 5, 0, NULL, 18),
(719, 'Add straw if needed.', '.', 2, 14, 0, '2024-12-02 08:16:50', NULL, NULL, NULL, 0, 0, NULL, 18),
(721, 'Clean the feed machines from outside to inside.', '.', 2, 15, 0, '2024-12-02 08:16:50', NULL, NULL, NULL, 0, 0, NULL, 13),
(734, 'Clean the floor and add straw if needed.', '.', 2, 15, 0, '2024-12-02 08:16:50', NULL, NULL, NULL, 0, 0, NULL, 16),
(735, 'Clean and refill the food and water bowls.', 'Fill the feed bowls with pellets and hay.', 2, 14, 0, '2024-12-02 08:16:50', NULL, NULL, 37, 5, 0, NULL, 14),
(740, 'Daily task cow test', 'fdsfsdfdsf', 1, 15, 0, '2024-12-02 08:16:50', NULL, NULL, NULL, 0, 0, NULL, 14),
(741, 'Daily Cow', 'fdsfsdf', 1, 15, 0, '2024-12-02 08:16:50', NULL, NULL, NULL, 0, 0, NULL, 14),
(744, 'Daily cow test', 'hdhdjd', 2, 16, NULL, '2024-12-02 08:36:39', NULL, NULL, NULL, 0, 0, NULL, 14),
(756, 'Feed and give water to the the pigs.', 'Use the pig pellets.', 2, 14, 0, '2024-12-02 09:53:07', NULL, NULL, 42, 5, 0, NULL, 18),
(757, 'Add straw if needed.', '.', 2, 14, 0, '2024-12-02 09:53:07', NULL, NULL, NULL, 0, 0, NULL, 18),
(759, 'Clean the feed machines from outside to inside.', '.', 2, 15, 0, '2024-12-02 09:53:07', NULL, NULL, NULL, 0, 0, NULL, 13),
(772, 'Clean the floor and add straw if needed.', '.', 2, 15, 0, '2024-12-02 09:53:07', NULL, NULL, NULL, 0, 0, NULL, 16),
(773, 'Clean and refill the food and water bowls.', 'Fill the feed bowls with pellets and hay.', 2, 14, 0, '2024-12-02 09:53:07', NULL, NULL, 37, 5, 0, NULL, 14),
(778, 'Daily Cow', 'fdsfsdf', 1, 15, 0, '2024-12-02 09:53:07', NULL, NULL, NULL, 0, 0, NULL, 14),
(779, 'Clean and refill food/water/grit bowls for finches.', 'Use the finch food, and the specified grit. Add vitamins to the water for all birds.', 2, 14, 1, '2024-12-02 10:01:47', NULL, NULL, 38, 5, 0, NULL, 17),
(780, 'Clean and refill food/water/grit bowls for chinese Dwarf Quails', 'Use the quail food and the specified grit. Add vitamins to water for all birds.', 1, 14, 1, '2024-12-02 10:01:47', NULL, NULL, 43, 5, 0, NULL, 17),
(781, 'Clean and refill the food bowls for pigeons', 'Use pigeon food and the specified grit. Add vitamins to water for all birds.', 1, 14, 1, '2024-12-02 10:01:47', NULL, NULL, 41, 5, 0, NULL, 17),
(782, 'Clean the aviary cage.', 'Clean the finch house only if no finches are living in them.', 2, 15, 1, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 17),
(783, 'Add nest material as needed to houses.', 'Do not forget the houses of the Dwarf Quails!', 2, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 17),
(784, 'Put fallen perches back on their place.', '.', 2, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 17),
(785, 'Record any deaths', 'Record any deaths in the exceptionalities field in your rapport.', 2, 16, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 17),
(786, 'Record any new births.', '.', 2, 16, 1, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 17),
(787, 'Egg collection', 'Remove pigeon eggs daily from under the pigeons.', 2, 16, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 17),
(788, 'Check for ratholes and close them with stones and sand.', '.', 2, 16, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 17),
(789, 'Feed and give water to the the pigs.', 'Use the pig pellets.', 2, 14, 0, '2024-12-02 10:01:47', NULL, NULL, 42, 5, 0, NULL, 18),
(790, 'Add straw if needed.', '.', 2, 14, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 18),
(791, 'Note any special observations.', 'Note them in the exceptionality field in the rapport.', 2, 16, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 18),
(792, 'Clean the feed machines from outside to inside.', '.', 2, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 13),
(793, 'Collect the eggs.', 'Collect the eggs and take the directly to building M. Date the eggs with a pencil and place them in a cardboard egg carton. Store the cartons in the cabinet and log the number of eggs collected.', 2, 16, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 13),
(794, 'Clean and refill grit bowls.', '.', 2, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 13),
(795, 'Put fallen perches back on their place.', '.', 1, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 13),
(796, 'Check for ratholes and close them with stones and sand. Report in the exceptionality in the rapport.', '.', 1, 16, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 13),
(797, 'Check if the electric fence is on.', '.', 1, 16, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 13),
(798, 'Feed the goose.', '.', 2, 14, 0, '2024-12-02 10:01:47', NULL, NULL, 39, 5, 0, NULL, 12),
(799, 'Clean and refill the pond.', '.', 2, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 12),
(800, 'Clean the geese houses.', '.', 2, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 12),
(801, 'Remove anny eggs.', 'Put the removed eggs in building M with the other eggs.', 2, 16, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 12),
(802, 'Feed the horses.', 'Use hay, and chec', 1, 14, 0, '2024-12-02 10:01:47', NULL, NULL, 40, 5, 0, NULL, 15),
(803, 'Clean and refill the water and provide pellets.', '.', 2, 14, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 15),
(804, 'Remove manure from the floors on the ground.', '.', 2, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 15),
(805, 'Clean the floor and add straw if needed.', '.', 2, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 16),
(806, 'Clean and refill the food and water bowls.', 'Fill the feed bowls with pellets and hay.', 2, 14, 0, '2024-12-02 10:01:47', NULL, NULL, 37, 5, 0, NULL, 14),
(807, 'Check if the salt lick is still hanging and in good condition.', '.', 2, 14, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 14),
(808, 'Organize and clean the hay tent.', '.', 1, 17, 1, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, NULL),
(809, 'Clean tools and put them back neatly.', '.', 1, 17, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, NULL),
(810, 'Monitor the inventory of animal supplies.', '.', 1, 17, 1, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, NULL),
(811, 'Daily Cow', 'fdsfsdf', 1, 15, 0, '2024-12-02 10:01:47', NULL, NULL, NULL, 0, 0, NULL, 14),
(817, 'Clean and refill the grit bowls for all the birds.', 'Use the specified grit.', 2, 15, NULL, '2024-12-02 15:20:35', NULL, NULL, NULL, 0, 1, NULL, 17),
(822, 'Clean and refill food/water bowls for finches.', 'Use the finch food. Add vitamins to the water for all birds.', 2, 14, 0, '2024-12-03 08:30:55', NULL, NULL, 38, 5, 0, NULL, 17),
(823, 'Clean and refill food/water bowls for chinese Dwarf Quails', 'Use the quail food. Add vitamins to water for all birds.', 1, 14, 0, '2024-12-03 08:30:55', NULL, NULL, 43, 5, 0, NULL, 17),
(824, 'Clean and refill the food bowls for pigeons', 'Use pigeon food and the specified grit. Add vitamins to water for all birds.', 1, 14, 1, '2024-12-03 08:30:55', NULL, NULL, 41, 5, 0, NULL, 17),
(825, 'Clean the aviary cage.', 'Clean the finch house only if no finches are living in them.', 2, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 17),
(826, 'Add nest material as needed to houses.', 'Do not forget the houses of the Dwarf Quails!', 2, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 17),
(827, 'Put fallen perches back on their place.', '.', 2, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 17),
(828, 'Record any deaths', 'Record any deaths in the exceptionalities field in your rapport.', 2, 16, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 17),
(829, 'Record any new births.', '.', 2, 16, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 17),
(830, 'Egg collection', 'Remove pigeon eggs daily from under the pigeons.', 2, 16, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 17),
(831, 'Check for ratholes and close them with stones and sand.', '.', 2, 16, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 17),
(832, 'Feed and give water to the the pigs.', 'Use the pig pellets.', 2, 14, 0, '2024-12-03 08:30:55', NULL, NULL, 42, 5, 0, NULL, 18),
(833, 'Add straw if needed.', '.', 2, 14, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 18),
(834, 'Note any special observations.', 'Note them in the exceptionality field in the rapport.', 2, 16, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 18),
(835, 'Clean the feed machines from outside to inside.', '.', 2, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 13),
(836, 'Collect the eggs.', 'Collect the eggs and take the directly to building M. Date the eggs with a pencil and place them in a cardboard egg carton. Store the cartons in the cabinet and log the number of eggs collected.', 2, 16, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 13),
(837, 'Clean and refill grit bowls.', '.', 2, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 13),
(838, 'Put fallen perches back on their place.', '.', 1, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 13),
(839, 'Check for ratholes and close them with stones and sand. Report in the exceptionality in the rapport.', '.', 1, 16, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 13),
(840, 'Check if the electric fence is on.', '.', 1, 16, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 13),
(841, 'Feed the goose.', '.', 2, 14, 0, '2024-12-03 08:30:55', NULL, NULL, 39, 5, 0, NULL, 12),
(842, 'Clean and refill the pond.', '.', 2, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 12),
(843, 'Clean the geese houses.', '.', 2, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 12),
(844, 'Remove anny eggs.', 'Put the removed eggs in building M with the other eggs.', 2, 16, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 12),
(845, 'Feed the horses.', 'Use hay, and chec', 1, 14, 0, '2024-12-03 08:30:55', NULL, NULL, 40, 5, 0, NULL, 15),
(846, 'Clean and refill the water and provide pellets.', '.', 2, 14, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 15),
(847, 'Remove manure from the floors on the ground.', '.', 2, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 15),
(848, 'Clean the floor and add straw if needed.', '.', 2, 15, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 16),
(849, 'Clean and refill the food and water bowls.', 'Fill the feed bowls with pellets and hay.', 2, 14, 0, '2024-12-03 08:30:55', NULL, NULL, 37, 5, 0, NULL, 14),
(850, 'Check if the salt lick is still hanging and in good condition.', '.', 2, 14, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, 14),
(851, 'Organize and clean the hay tent.', '.', 1, 17, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, NULL),
(852, 'Clean tools and put them back neatly.', '.', 1, 17, 0, '2024-12-03 08:30:55', NULL, NULL, NULL, 0, 0, NULL, NULL),
(853, 'Monitor the inventory of animal supplies.', '.', 1, 17, 0, '2024-12-03 08:30:56', NULL, NULL, NULL, 0, 0, NULL, NULL),
(854, 'Clean and refill the grit bowls for all the birds.', 'Use the specified grit.', 2, 15, 0, '2024-12-03 08:30:56', NULL, NULL, NULL, 0, 0, NULL, 17);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `tasktypes`
--

CREATE TABLE `tasktypes` (
  `taskTypeId` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `tasktypes`
--

INSERT INTO `tasktypes` (`taskTypeId`, `name`) VALUES
(14, 'Feeding'),
(15, 'Cleaning'),
(16, 'Observation'),
(17, 'General');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `users`
--

CREATE TABLE `users` (
  `userId` int(11) NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  `function` smallint(6) DEFAULT NULL,
  `username` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `users`
--

INSERT INTO `users` (`userId`, `password`, `function`, `username`) VALUES
(37, '$2b$12$J5fJRkNhoaqjwQL0hmpweOBNVytzd4HxT8lPa.CoiBZ4ksS8q1PkW', 1, 'test'),
(43, '$2b$12$OSquvFtre0pZLuDf2TPYae3BFh30U4TMwPtZUo.eezCdkelccsa76', 0, 'jakubski'),
(44, '$2b$12$qAxARSLCdmOOOoYeg3VbC.iHuw1LlD9odj/zzZ.F/lfXZPBDla4wC', 0, 'Jules'),
(46, '$2b$12$XA4XHuAUiww4TCYsUQOX.OrjO1wDGVIgj/kzNTw3MTJiVRItqs882', 0, 'Julski');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `users_messages`
--

CREATE TABLE `users_messages` (
  `usersMessagesId` int(11) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `messageId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `users_tasks`
--

CREATE TABLE `users_tasks` (
  `userTasksId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `taskId` int(11) NOT NULL,
  `daily` smallint(6) DEFAULT NULL,
  `createdDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `users_tasks`
--

INSERT INTO `users_tasks` (`userTasksId`, `userId`, `taskId`, `daily`, `createdDate`) VALUES
(301, 43, 229, 1, '0000-00-00'),
(303, 43, 231, 1, '0000-00-00'),
(304, 43, 232, 1, '0000-00-00'),
(305, 43, 233, 1, '0000-00-00'),
(306, 43, 227, 1, '0000-00-00'),
(316, 43, 243, 1, '0000-00-00'),
(317, 43, 244, 1, '0000-00-00'),
(318, 43, 245, 1, '0000-00-00'),
(319, 43, 246, 1, '0000-00-00'),
(320, 43, 247, 1, '0000-00-00'),
(321, 43, 248, 1, '0000-00-00'),
(322, 43, 249, 1, '0000-00-00'),
(323, 43, 242, 1, '0000-00-00'),
(328, 43, 252, 1, '0000-00-00'),
(331, 43, 255, 1, '0000-00-00'),
(332, 43, 256, 1, '0000-00-00'),
(333, 43, 257, 1, '0000-00-00'),
(334, 43, 258, 1, '0000-00-00'),
(335, 43, 259, 1, '0000-00-00'),
(337, 43, 261, 1, '0000-00-00'),
(338, 43, 262, 1, '0000-00-00'),
(339, 43, 263, 1, '0000-00-00'),
(340, 43, 264, 1, '0000-00-00'),
(341, 43, 265, 1, '0000-00-00'),
(342, 43, 266, 1, '0000-00-00'),
(343, 43, 267, 1, '0000-00-00'),
(350, 43, 274, 1, '0000-00-00'),
(353, 43, 277, 1, '0000-00-00'),
(354, 43, 278, 1, '0000-00-00'),
(355, 43, 279, 1, '0000-00-00'),
(356, 43, 280, 1, '0000-00-00'),
(484, 43, 552, 0, '2024-11-27'),
(485, 43, 553, 0, '2024-11-27'),
(487, 43, 555, 0, '2024-11-27'),
(488, 43, 556, 0, '2024-11-27'),
(489, 43, 557, 0, '2024-11-27'),
(490, 43, 558, 0, '2024-11-27'),
(493, 43, 549, 0, '2024-11-27'),
(494, 43, 561, 0, '2024-11-27'),
(502, 43, 570, 0, '2024-11-27'),
(505, 43, 573, 0, '2024-11-27'),
(506, 43, 574, 0, '2024-11-27'),
(507, 43, 575, 0, '2024-11-27'),
(508, 43, 576, 0, '2024-11-27'),
(509, 43, 577, 0, '2024-11-27'),
(510, 43, 578, 0, '2024-11-27'),
(513, 43, 581, 0, '2024-11-27'),
(515, 43, 583, 0, '2024-11-27'),
(517, 43, 585, 0, '2024-11-27'),
(518, 43, 586, 0, '2024-11-27'),
(558, 43, 630, 0, '2024-11-28'),
(560, 43, 632, 0, '2024-11-28'),
(561, 43, 633, 0, '2024-11-28'),
(562, 43, 634, 0, '2024-11-28'),
(563, 43, 635, 0, '2024-11-28'),
(564, 43, 628, 0, '2024-11-28'),
(567, 43, 638, 0, '2024-11-28'),
(568, 43, 640, 0, '2024-11-28'),
(569, 43, 641, 0, '2024-11-28'),
(570, 43, 642, 0, '2024-11-28'),
(571, 43, 643, 0, '2024-11-28'),
(572, 43, 644, 0, '2024-11-28'),
(573, 43, 645, 0, '2024-11-28'),
(574, 43, 646, 0, '2024-11-28'),
(575, 43, 647, 0, '2024-11-28'),
(576, 43, 648, 0, '2024-11-28'),
(577, 43, 649, 0, '2024-11-28'),
(578, 43, 650, 0, '2024-11-28'),
(579, 43, 651, 0, '2024-11-28'),
(580, 43, 652, 0, '2024-11-28'),
(581, 43, 653, 0, '2024-11-28'),
(582, 43, 654, 0, '2024-11-28'),
(583, 43, 656, 0, '2024-11-28'),
(584, 43, 657, 0, '2024-11-28'),
(585, 43, 658, 0, '2024-11-28'),
(586, 43, 659, 0, '2024-11-28'),
(587, 43, 669, 0, '2024-11-29'),
(588, 43, 670, 0, '2024-11-29'),
(589, 43, 671, 0, '2024-11-29'),
(590, 43, 672, 0, '2024-11-29'),
(591, 43, 673, 0, '2024-11-29'),
(592, 43, 674, 0, '2024-11-29'),
(593, 43, 675, 0, '2024-11-29'),
(594, 43, 668, 0, '2024-11-29'),
(595, 43, 667, 0, '2024-11-29'),
(596, 43, 666, 0, '2024-11-29'),
(597, 43, 678, 0, '2024-11-29'),
(598, 43, 680, 0, '2024-11-29'),
(599, 43, 681, 0, '2024-11-29'),
(600, 43, 682, 0, '2024-11-29'),
(601, 43, 683, 0, '2024-11-29'),
(602, 43, 684, 0, '2024-11-29'),
(603, 43, 685, 0, '2024-11-29'),
(604, 43, 686, 0, '2024-11-29'),
(605, 43, 687, 0, '2024-11-29'),
(606, 43, 688, 0, '2024-11-29'),
(607, 43, 689, 0, '2024-11-29'),
(608, 43, 690, 0, '2024-11-29'),
(609, 43, 691, 0, '2024-11-29'),
(610, 43, 694, 0, '2024-11-29'),
(611, 43, 695, 0, '2024-11-29'),
(612, 43, 696, 0, '2024-11-29'),
(613, 43, 697, 0, '2024-11-29'),
(668, 43, 782, 0, '2024-12-02'),
(669, 43, 783, 0, '2024-12-02'),
(670, 43, 784, 0, '2024-12-02'),
(671, 43, 785, 0, '2024-12-02'),
(672, 43, 786, 0, '2024-12-02'),
(673, 43, 787, 0, '2024-12-02'),
(674, 43, 788, 0, '2024-12-02'),
(675, 43, 781, 0, '2024-12-02'),
(676, 43, 780, 0, '2024-12-02'),
(677, 43, 779, 0, '2024-12-02'),
(678, 43, 791, 0, '2024-12-02'),
(679, 43, 793, 0, '2024-12-02'),
(680, 43, 794, 0, '2024-12-02'),
(681, 43, 795, 0, '2024-12-02'),
(682, 43, 796, 0, '2024-12-02'),
(683, 43, 797, 0, '2024-12-02'),
(684, 43, 798, 0, '2024-12-02'),
(685, 43, 799, 0, '2024-12-02'),
(686, 43, 800, 0, '2024-12-02'),
(687, 43, 801, 0, '2024-12-02'),
(688, 43, 802, 0, '2024-12-02'),
(689, 43, 803, 0, '2024-12-02'),
(690, 43, 804, 0, '2024-12-02'),
(691, 43, 807, 0, '2024-12-02'),
(692, 43, 808, 0, '2024-12-02'),
(693, 43, 809, 0, '2024-12-02'),
(694, 43, 810, 0, '2024-12-02'),
(696, 43, 825, 0, '2024-12-03'),
(697, 43, 826, 0, '2024-12-03'),
(698, 43, 827, 0, '2024-12-03'),
(699, 43, 828, 0, '2024-12-03'),
(700, 43, 829, 0, '2024-12-03'),
(701, 43, 830, 0, '2024-12-03'),
(702, 43, 831, 0, '2024-12-03'),
(703, 43, 824, 0, '2024-12-03'),
(704, 43, 834, 0, '2024-12-03'),
(705, 43, 836, 0, '2024-12-03'),
(706, 43, 837, 0, '2024-12-03'),
(707, 43, 838, 0, '2024-12-03'),
(708, 43, 839, 0, '2024-12-03'),
(709, 43, 840, 0, '2024-12-03'),
(710, 43, 841, 0, '2024-12-03'),
(711, 43, 842, 0, '2024-12-03'),
(712, 43, 843, 0, '2024-12-03'),
(713, 43, 844, 0, '2024-12-03'),
(714, 43, 845, 0, '2024-12-03'),
(715, 43, 846, 0, '2024-12-03'),
(716, 43, 847, 0, '2024-12-03'),
(717, 43, 850, 0, '2024-12-03'),
(718, 43, 851, 0, '2024-12-03'),
(719, 43, 852, 0, '2024-12-03'),
(720, 43, 853, 0, '2024-12-03');

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `alembic_version`
--
ALTER TABLE `alembic_version`
  ADD PRIMARY KEY (`version_num`);

--
-- Indexen voor tabel `animals`
--
ALTER TABLE `animals`
  ADD PRIMARY KEY (`animalId`),
  ADD KEY `animalTypeId` (`animalTypeId`);

--
-- Indexen voor tabel `animaltypes`
--
ALTER TABLE `animaltypes`
  ADD PRIMARY KEY (`animalTypeId`);

--
-- Indexen voor tabel `dailytasks`
--
ALTER TABLE `dailytasks`
  ADD PRIMARY KEY (`dailyTaskId`),
  ADD KEY `taskType` (`taskType`),
  ADD KEY `stockId` (`stockId`);

--
-- Indexen voor tabel `foodtypes`
--
ALTER TABLE `foodtypes`
  ADD PRIMARY KEY (`foodTypeId`);

--
-- Indexen voor tabel `foodtypes_animals`
--
ALTER TABLE `foodtypes_animals`
  ADD PRIMARY KEY (`foodTypesAnimalsId`),
  ADD KEY `foodTypeId` (`foodTypeId`),
  ADD KEY `animalTypeId` (`animalTypeId`);

--
-- Indexen voor tabel `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`messageId`);

--
-- Indexen voor tabel `rapports`
--
ALTER TABLE `rapports`
  ADD PRIMARY KEY (`rapportId`),
  ADD KEY `rapports_ibfk_1` (`userId`);

--
-- Indexen voor tabel `rapport_tasks`
--
ALTER TABLE `rapport_tasks`
  ADD PRIMARY KEY (`rapportTasksId`),
  ADD UNIQUE KEY `rapportId` (`rapportId`,`taskId`),
  ADD KEY `rapport_tasks_ibfk_2` (`taskId`);

--
-- Indexen voor tabel `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`stockId`),
  ADD KEY `foodTypeId` (`foodTypeId`);

--
-- Indexen voor tabel `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`taskId`),
  ADD KEY `tasks_ibfk_1` (`taskType`),
  ADD KEY `tasks_ibfk_2` (`stockId`),
  ADD KEY `animalTypeId` (`animalTypeId`),
  ADD KEY `tasks_ibfk_3` (`rapportId`);

--
-- Indexen voor tabel `tasktypes`
--
ALTER TABLE `tasktypes`
  ADD PRIMARY KEY (`taskTypeId`);

--
-- Indexen voor tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userId`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexen voor tabel `users_messages`
--
ALTER TABLE `users_messages`
  ADD PRIMARY KEY (`usersMessagesId`),
  ADD KEY `messageId` (`messageId`),
  ADD KEY `userId` (`userId`);

--
-- Indexen voor tabel `users_tasks`
--
ALTER TABLE `users_tasks`
  ADD PRIMARY KEY (`userTasksId`),
  ADD UNIQUE KEY `quniq` (`userId`,`taskId`),
  ADD KEY `taskId` (`taskId`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `animals`
--
ALTER TABLE `animals`
  MODIFY `animalId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT voor een tabel `animaltypes`
--
ALTER TABLE `animaltypes`
  MODIFY `animalTypeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT voor een tabel `dailytasks`
--
ALTER TABLE `dailytasks`
  MODIFY `dailyTaskId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `foodtypes`
--
ALTER TABLE `foodtypes`
  MODIFY `foodTypeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT voor een tabel `foodtypes_animals`
--
ALTER TABLE `foodtypes_animals`
  MODIFY `foodTypesAnimalsId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT voor een tabel `messages`
--
ALTER TABLE `messages`
  MODIFY `messageId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT voor een tabel `rapports`
--
ALTER TABLE `rapports`
  MODIFY `rapportId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT voor een tabel `rapport_tasks`
--
ALTER TABLE `rapport_tasks`
  MODIFY `rapportTasksId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `stocks`
--
ALTER TABLE `stocks`
  MODIFY `stockId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT voor een tabel `tasks`
--
ALTER TABLE `tasks`
  MODIFY `taskId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=855;

--
-- AUTO_INCREMENT voor een tabel `tasktypes`
--
ALTER TABLE `tasktypes`
  MODIFY `taskTypeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT voor een tabel `users`
--
ALTER TABLE `users`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT voor een tabel `users_messages`
--
ALTER TABLE `users_messages`
  MODIFY `usersMessagesId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT voor een tabel `users_tasks`
--
ALTER TABLE `users_tasks`
  MODIFY `userTasksId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=721;

--
-- Beperkingen voor geëxporteerde tabellen
--

--
-- Beperkingen voor tabel `animals`
--
ALTER TABLE `animals`
  ADD CONSTRAINT `animals_ibfk_1` FOREIGN KEY (`animalTypeId`) REFERENCES `animaltypes` (`animalTypeId`);

--
-- Beperkingen voor tabel `dailytasks`
--
ALTER TABLE `dailytasks`
  ADD CONSTRAINT `dailytasks_ibfk_1` FOREIGN KEY (`taskType`) REFERENCES `tasktypes` (`taskTypeId`),
  ADD CONSTRAINT `dailytasks_ibfk_2` FOREIGN KEY (`stockId`) REFERENCES `stocks` (`stockId`);

--
-- Beperkingen voor tabel `foodtypes_animals`
--
ALTER TABLE `foodtypes_animals`
  ADD CONSTRAINT `foodtypes_animals_ibfk_2` FOREIGN KEY (`foodTypeId`) REFERENCES `foodtypes` (`foodTypeId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `foodtypes_animals_ibfk_3` FOREIGN KEY (`animalTypeId`) REFERENCES `animaltypes` (`animalTypeId`) ON UPDATE CASCADE;

--
-- Beperkingen voor tabel `rapports`
--
ALTER TABLE `rapports`
  ADD CONSTRAINT `rapports_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`);

--
-- Beperkingen voor tabel `rapport_tasks`
--
ALTER TABLE `rapport_tasks`
  ADD CONSTRAINT `rapport_tasks_ibfk_1` FOREIGN KEY (`rapportId`) REFERENCES `rapports` (`rapportId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `rapport_tasks_ibfk_2` FOREIGN KEY (`taskId`) REFERENCES `tasks` (`taskId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Beperkingen voor tabel `stocks`
--
ALTER TABLE `stocks`
  ADD CONSTRAINT `stocks_ibfk_1` FOREIGN KEY (`foodTypeId`) REFERENCES `foodtypes` (`foodTypeId`);

--
-- Beperkingen voor tabel `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`taskType`) REFERENCES `tasktypes` (`taskTypeId`),
  ADD CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`stockId`) REFERENCES `stocks` (`stockId`),
  ADD CONSTRAINT `tasks_ibfk_3` FOREIGN KEY (`rapportId`) REFERENCES `rapports` (`rapportId`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `tasks_ibfk_4` FOREIGN KEY (`animalTypeId`) REFERENCES `animaltypes` (`animalTypeId`);

--
-- Beperkingen voor tabel `users_messages`
--
ALTER TABLE `users_messages`
  ADD CONSTRAINT `users_messages_ibfk_1` FOREIGN KEY (`messageId`) REFERENCES `messages` (`messageId`),
  ADD CONSTRAINT `users_messages_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`);

--
-- Beperkingen voor tabel `users_tasks`
--
ALTER TABLE `users_tasks`
  ADD CONSTRAINT `users_tasks_ibfk_1` FOREIGN KEY (`taskId`) REFERENCES `tasks` (`taskId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `users_tasks_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
