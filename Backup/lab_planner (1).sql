-- phpMyAdmin SQL Dump
-- version 5.2.1deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Gegenereerd op: 26 nov 2024 om 14:53
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
(20, 'Sheep food');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `foodtypes_animals`
--

CREATE TABLE `foodtypes_animals` (
  `foodTypesAnimalsId` int(11) NOT NULL,
  `foodTypeId` int(11) DEFAULT NULL,
  `animalTypeId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(30, 'jakubski : 2024-11-26', NULL, NULL, 'found 5 eggs.', '2024-11-26', 43);

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
(36, 1000, 19, 200),
(37, 1000, 13, 200),
(38, 995, 17, 200),
(39, 1000, 15, 200),
(40, 1000, 11, 200),
(41, 995, 16, 200),
(42, 1000, 14, 200),
(43, 995, 18, 200),
(44, 1000, 20, 200),
(45, 1000, 12, 200);

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
(240, 'Clean and refill food/water/grit bowls for finches.', 'Use the finch food, and the specified grit. Add vitamins to the water for all birds.', 2, 14, 1, '2024-11-26 11:39:38', NULL, NULL, 38, 5, 1, 30, 17),
(241, 'Clean and refill food/water/grit bowls for chinese Dwarf Quails', 'Use the quail food and the specified grit. Add vitamins to water for all birds.', 1, 14, 1, '2024-11-26 11:40:37', NULL, NULL, 43, 5, 1, 30, 17),
(242, 'Clean and refill the food bowls for pigeons', 'Use pigeon food and the specified grit. Add vitamins to water for all birds.', 1, 14, 1, '2024-11-26 11:41:29', NULL, NULL, 41, 5, 1, 30, 17),
(243, 'Clean the aviary cage.', 'Clean the finch house only if no finches are living in them.', 2, 15, 0, '2024-11-26 11:43:08', NULL, NULL, NULL, 0, 1, 30, 17),
(244, 'Add nest material as needed to houses.', 'Do not forget the houses of the Dwarf Quails!', 2, 15, 0, '2024-11-26 11:44:38', NULL, NULL, NULL, 0, 1, 30, 17),
(245, 'Put fallen perches back on their place.', '.', 2, 15, 0, '2024-11-26 11:45:12', NULL, NULL, NULL, 0, 1, 30, 17),
(246, 'Record any deaths', 'Record any deaths in the exceptionalities field in your rapport.', 2, 16, 0, '2024-11-26 11:45:48', NULL, NULL, NULL, 0, 1, 30, 17),
(247, 'Record any new births.', '.', 2, 16, 0, '2024-11-26 11:46:25', NULL, NULL, NULL, 0, 1, 30, 17),
(248, 'Egg collection', 'Remove pigeon eggs daily from under the pigeons.', 2, 16, 0, '2024-11-26 11:46:59', NULL, NULL, NULL, 0, 1, 30, 17),
(249, 'Check for ratholes and close them with stones and sand.', '.', 2, 16, 0, '2024-11-26 11:47:35', NULL, NULL, NULL, 0, 1, 30, 17),
(250, 'Feed and give water to the the pigs.', 'Use the pig pellets.', 2, 14, 0, '2024-11-26 12:17:56', NULL, NULL, 42, 5, 1, NULL, 18),
(251, 'Add straw if needed.', '.', 2, 14, 0, '2024-11-26 12:20:23', NULL, NULL, NULL, 0, 1, NULL, 18),
(252, 'Note any special observations.', 'Note them in the exceptionality field in the rapport.', 2, 16, 0, '2024-11-26 12:21:39', NULL, NULL, NULL, 0, 1, 30, 18),
(254, 'Clean the feed machines from outside to inside.', '.', 2, 15, 0, '2024-11-26 12:22:51', NULL, NULL, NULL, 0, 1, 30, 13),
(255, 'Collect the eggs.', 'Collect the eggs and take the directly to building M. Date the eggs with a pencil and place them in a cardboard egg carton. Store the cartons in the cabinet and log the number of eggs collected.', 2, 16, 0, '2024-11-26 12:23:53', NULL, NULL, NULL, 0, 1, 30, 13),
(256, 'Clean and refill grit bowls.', '.', 2, 15, 0, '2024-11-26 12:24:23', NULL, NULL, NULL, 0, 1, 30, 13),
(257, 'Put fallen perches back on their place.', '.', 1, 15, 0, '2024-11-26 12:24:48', NULL, NULL, NULL, 0, 1, 30, 13),
(258, 'Check for ratholes and close them with stones and sand. Report in the exceptionality in the rapport.', '.', 1, 16, 0, '2024-11-26 12:25:36', NULL, NULL, NULL, 0, 1, 30, 13),
(259, 'Check if the electric fence is on.', '.', 1, 16, 0, '2024-11-26 12:25:57', NULL, NULL, NULL, 0, 1, 30, 13),
(260, 'Record any deaths.', '.', 2, 16, 0, '2024-11-26 12:26:19', NULL, NULL, NULL, 0, 1, 30, 13),
(261, 'Feed the goose.', '.', 2, 14, 0, '2024-11-26 12:27:11', NULL, NULL, 39, 5, 1, 30, 12),
(262, 'Clean and refill the pond.', '.', 2, 15, 0, '2024-11-26 12:27:35', NULL, NULL, NULL, 0, 1, 30, 12),
(263, 'Clean the geese houses.', '.', 2, 15, 0, '2024-11-26 12:27:56', NULL, NULL, NULL, 0, 1, 30, 12),
(264, 'Remove anny eggs.', 'Put the removed eggs in building M with the other eggs.', 2, 16, 0, '2024-11-26 12:28:28', NULL, NULL, NULL, 0, 1, 30, 12),
(265, 'Feed the horses.', 'Use hay, and chec', 1, 14, 0, '2024-11-26 12:29:22', NULL, NULL, 40, 5, 1, 30, 15),
(266, 'Clean and refill the water and provide pellets.', '.', 2, 14, 0, '2024-11-26 12:29:51', NULL, NULL, NULL, 0, 1, 30, 15),
(267, 'Remove manure from the floors on the ground.', '.', 2, 15, 0, '2024-11-26 12:30:16', NULL, NULL, NULL, 0, 1, 30, 15),
(269, 'Clean and refill water bowls, with vitamin C, check the salt lick.', '.', 2, 15, 0, '2024-11-26 12:32:06', NULL, NULL, NULL, 0, 1, 30, 16),
(270, 'Clean the floor and add straw if needed.', '.', 2, 15, 0, '2024-11-26 12:32:26', NULL, NULL, NULL, 0, 1, 30, 16),
(271, 'Feed the sheep.', '.', 2, 14, 0, '2024-11-26 14:01:50', NULL, NULL, 44, 8, 1, 30, 16),
(272, 'Clean and refill the food and water bowls.', 'Fill the feed bowls with pellets and hay.', 2, 14, 0, '2024-11-26 14:07:31', NULL, NULL, 37, 5, 1, 30, 14),
(273, 'Remove manure from the floor and pot stall.', 'Only remove the wettest spots and poop, and add straw if neccessary.', 2, 15, 0, '2024-11-26 14:08:20', NULL, NULL, NULL, 0, 1, 30, 14),
(274, 'Check if the salt lick is still hanging and in good condition.', '.', 2, 14, 0, '2024-11-26 14:08:51', NULL, NULL, NULL, 0, 1, 30, 14),
(275, 'Check if the electric fence is on.', 'If not replace the battery, and refill the old one.', 2, 16, 0, '2024-11-26 14:09:31', NULL, NULL, NULL, 0, 1, 30, 14),
(276, 'Brush the horses.', '.', 1, 17, 0, '2024-11-26 14:10:01', NULL, NULL, NULL, 0, 1, 30, NULL),
(277, 'Brush the cows.', '.', 1, 17, 0, '2024-11-26 14:10:18', NULL, NULL, NULL, 0, 0, 30, NULL),
(278, 'Organize and clean the hay tent.', '.', 1, 17, 0, '2024-11-26 14:10:38', NULL, NULL, NULL, 0, 1, 30, NULL),
(279, 'Clean tools and put them back neatly.', '.', 1, 17, 0, '2024-11-26 14:10:54', NULL, NULL, NULL, 0, 1, 30, NULL),
(280, 'Monitor the inventory of animal supplies.', '.', 1, 17, 0, '2024-11-26 14:11:19', NULL, NULL, NULL, 0, 1, 30, NULL);

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
(43, '$2b$12$OSquvFtre0pZLuDf2TPYae3BFh30U4TMwPtZUo.eezCdkelccsa76', 0, 'jakubski');

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
  `taskId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `users_tasks`
--

INSERT INTO `users_tasks` (`userTasksId`, `userId`, `taskId`) VALUES
(306, 43, 227),
(301, 43, 229),
(303, 43, 231),
(304, 43, 232),
(305, 43, 233),
(325, 43, 240),
(324, 43, 241),
(323, 43, 242),
(316, 43, 243),
(317, 43, 244),
(318, 43, 245),
(319, 43, 246),
(320, 43, 247),
(321, 43, 248),
(322, 43, 249),
(328, 43, 252),
(331, 43, 255),
(332, 43, 256),
(333, 43, 257),
(334, 43, 258),
(335, 43, 259),
(336, 43, 260),
(337, 43, 261),
(338, 43, 262),
(339, 43, 263),
(340, 43, 264),
(341, 43, 265),
(342, 43, 266),
(343, 43, 267),
(345, 43, 269),
(346, 43, 270),
(347, 43, 271),
(348, 43, 272),
(349, 43, 273),
(350, 43, 274),
(351, 43, 275),
(352, 43, 276),
(353, 43, 277),
(354, 43, 278),
(355, 43, 279),
(356, 43, 280);

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
  ADD KEY `rapportId` (`rapportId`),
  ADD KEY `animalTypeId` (`animalTypeId`);

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
  ADD UNIQUE KEY `uidx` (`userId`,`taskId`),
  ADD KEY `taskId` (`taskId`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `animals`
--
ALTER TABLE `animals`
  MODIFY `animalId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT voor een tabel `animaltypes`
--
ALTER TABLE `animaltypes`
  MODIFY `animalTypeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT voor een tabel `dailytasks`
--
ALTER TABLE `dailytasks`
  MODIFY `dailyTaskId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `foodtypes`
--
ALTER TABLE `foodtypes`
  MODIFY `foodTypeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT voor een tabel `foodtypes_animals`
--
ALTER TABLE `foodtypes_animals`
  MODIFY `foodTypesAnimalsId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT voor een tabel `messages`
--
ALTER TABLE `messages`
  MODIFY `messageId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT voor een tabel `rapports`
--
ALTER TABLE `rapports`
  MODIFY `rapportId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT voor een tabel `rapport_tasks`
--
ALTER TABLE `rapport_tasks`
  MODIFY `rapportTasksId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `stocks`
--
ALTER TABLE `stocks`
  MODIFY `stockId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT voor een tabel `tasks`
--
ALTER TABLE `tasks`
  MODIFY `taskId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=281;

--
-- AUTO_INCREMENT voor een tabel `tasktypes`
--
ALTER TABLE `tasktypes`
  MODIFY `taskTypeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT voor een tabel `users`
--
ALTER TABLE `users`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT voor een tabel `users_messages`
--
ALTER TABLE `users_messages`
  MODIFY `usersMessagesId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT voor een tabel `users_tasks`
--
ALTER TABLE `users_tasks`
  MODIFY `userTasksId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=357;

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
  ADD CONSTRAINT `foodtypes_animals_ibfk_2` FOREIGN KEY (`foodTypeId`) REFERENCES `foodtypes` (`foodTypeId`),
  ADD CONSTRAINT `foodtypes_animals_ibfk_3` FOREIGN KEY (`animalTypeId`) REFERENCES `animaltypes` (`animalTypeId`);

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
  ADD CONSTRAINT `tasks_ibfk_3` FOREIGN KEY (`rapportId`) REFERENCES `rapports` (`rapportId`),
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
