-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 06, 2024 at 06:37 AM
-- Server version: 10.4.16-MariaDB
-- PHP Version: 7.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smart_digital_mobility_experience`
--

-- --------------------------------------------------------

--
-- Table structure for table `bus_booking_table`
--

CREATE TABLE `bus_booking_table` (
  `Booking_ID` int(11) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Passenger_ID` int(11) NOT NULL,
  `Bus_ID` int(11) NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `Time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `bus_information_table`
--

CREATE TABLE `bus_information_table` (
  `Bus_ID` int(11) NOT NULL,
  `Start_Location` varchar(100) NOT NULL,
  `End_Location` varchar(100) NOT NULL,
  `Bus_Number` varchar(50) NOT NULL,
  `Ticket_Price` decimal(10,2) NOT NULL,
  `Bus_Name` varchar(100) NOT NULL,
  `Total_Seats` int(11) NOT NULL,
  `Route_Number` varchar(50) NOT NULL,
  `Start_Time` time NOT NULL,
  `travel_date` date DEFAULT NULL,
  `Booked_Seats` int(11) DEFAULT 0,
  `Booked_Seats_Number` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`Booked_Seats_Number`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bus_information_table`
--

INSERT INTO `bus_information_table` (`Bus_ID`, `Start_Location`, `End_Location`, `Bus_Number`, `Ticket_Price`, `Bus_Name`, `Total_Seats`, `Route_Number`, `Start_Time`, `travel_date`, `Booked_Seats`, `Booked_Seats_Number`) VALUES
(1, 'Colombo', 'Galle', 'NT-10-100', '1000.00', 'SLTB Express', 49, 'H01', '06:30:00', '2024-11-07', 4, '[2, 6, 10, 14]'),
(2, 'Colombo', 'Galle', 'NT-10-101', '900.00', 'Private A/C Bus', 49, 'H01', '07:45:00', '2024-11-07', 4, '[1, 3, 7, 15]'),
(3, 'Colombo', 'Galle', 'NT-10-102', '900.00', 'SLTB Semi-Luxury', 49, 'H01', '09:00:00', '2024-11-07', 4, '[5, 11, 13, 16]'),
(4, 'Colombo', 'Galle', 'NT-10-103', '900.00', 'Private Sleeper Bus', 49, 'H01', '10:30:00', '2024-11-07', 4, '[8, 12, 17, 18]'),
(5, 'Colombo', 'Galle', 'NT-10-104', '900.00', 'SLTB Luxury', 49, 'H01', '12:00:00', '2024-11-07', 4, '[4, 9, 14, 19]'),
(6, 'Colombo', 'Matara', 'NT-10-105', '1300.00', 'SLTB Express', 49, 'M01', '06:15:00', '2024-11-08', 4, '[4, 8, 15, 20]'),
(7, 'Colombo', 'Matara', 'NT-10-106', '1300.00', 'Private A/C Bus', 49, 'M01', '07:30:00', '2024-11-08', 5, '[2, 9, 12, 19,33]'),
(8, 'Colombo', 'Matara', 'NT-10-107', '1300.00', 'SLTB Semi-Luxury', 49, 'M01', '09:00:00', '2024-11-08', 6, '[3, 10, 14, 18,1,8]'),
(9, 'Colombo', 'Matara', 'NT-10-108', '1300.00', 'Private Sleeper Bus', 49, 'M01', '11:00:00', '2024-11-08', 2, '[1, 7]'),
(10, 'Colombo', 'Matara', 'NT-10-109', '1300.00', 'SLTB Luxury', 49, 'M01', '13:00:00', '2024-11-08', 2, '[5, 16]');

-- --------------------------------------------------------

--
-- Table structure for table `driver_information_table`
--

CREATE TABLE `driver_information_table` (
  `Driver_ID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Bus_Number` varchar(50) NOT NULL,
  `Phone_Number` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `driver_information_table`
--

INSERT INTO `driver_information_table` (`Driver_ID`, `Name`, `Email`, `Password`, `Bus_Number`, `Phone_Number`) VALUES
(6, 'Driver User', 'aselarohana0522@gmail.com', '$2b$12$u6iP7zTMd3KFkNF7PTiK7.FCsJiHnUA0rZ7SnGRLA46xmaX33stvS', 'BUS123', '0987654321');

-- --------------------------------------------------------

--
-- Table structure for table `passenger_information_table`
--

CREATE TABLE `passenger_information_table` (
  `Passenger_ID` int(11) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Phone_Number` varchar(20) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `passenger_information_table`
--

INSERT INTO `passenger_information_table` (`Passenger_ID`, `Email`, `Phone_Number`, `Password`, `Name`) VALUES
(11, 'aselarohana336@gmail.com', '0763146805', '$2b$12$GaI6YPGQRFZ/ItzO2k/XrufcrE4u3IzT1ouQv.tkMlk2vYNFvXJXW', 'Asela'),
(20, 'bandaraharshana740@gmail.com', '0788241989', '$2b$12$0j64PLPUKPfebtnqDy8vZ.kqaTbqWmlb7M33njlaD/9v7R1AljYBS', 'Chamidu'),
(21, 'aselarohana0522@gmail.com', '0763146805', '$2b$12$ru6aCRVeUxY6aLNWwzKX8eh2o6.HwswyPl9qcvB66ITR3FETMTohe', 'Asela'),
(22, 'sudanthapriyamal2001@gmail.com', '0123456789', '$2b$12$FcT0JU2F8sGmNJiHGzYob.fvhXvd6fENDWuaa7XONKGenANry40Hy', 'Sudantha@10');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `admin_id` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `admin_id`, `email`, `password`, `created_at`) VALUES
(5, '100', 'aselarohana0522@gmail.com', '$2b$12$ek6WhUfpxHhK0clMF6daTOCLacnUwp3wgS2G9aSRfXL0FIFe7Mav6', '2024-11-05 19:50:19'),
(7, '105', 'thariduniroshan232@gmail.com', '$2b$12$DnZM0KUAtUTBu2TMjoYPTeEB1KP8qsg2NlEG03jUoXb0jGmQHnN/O', '2024-11-05 20:06:15'),
(8, '106', 'thariduniroshavvn232@gmail.com', '$2b$12$PKjM8uFUaFXtIKJjOL6jDOb8verX.J/QNMPqhro.4ZI0.caCUYRAW', '2024-11-05 20:07:45');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bus_booking_table`
--
ALTER TABLE `bus_booking_table`
  ADD PRIMARY KEY (`Booking_ID`),
  ADD KEY `Passenger_ID` (`Passenger_ID`),
  ADD KEY `Bus_ID` (`Bus_ID`);

--
-- Indexes for table `bus_information_table`
--
ALTER TABLE `bus_information_table`
  ADD PRIMARY KEY (`Bus_ID`);

--
-- Indexes for table `driver_information_table`
--
ALTER TABLE `driver_information_table`
  ADD PRIMARY KEY (`Driver_ID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `passenger_information_table`
--
ALTER TABLE `passenger_information_table`
  ADD PRIMARY KEY (`Passenger_ID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_id` (`admin_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bus_booking_table`
--
ALTER TABLE `bus_booking_table`
  MODIFY `Booking_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bus_information_table`
--
ALTER TABLE `bus_information_table`
  MODIFY `Bus_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `driver_information_table`
--
ALTER TABLE `driver_information_table`
  MODIFY `Driver_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `passenger_information_table`
--
ALTER TABLE `passenger_information_table`
  MODIFY `Passenger_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bus_booking_table`
--
ALTER TABLE `bus_booking_table`
  ADD CONSTRAINT `bus_booking_table_ibfk_1` FOREIGN KEY (`Passenger_ID`) REFERENCES `passenger_information_table` (`Passenger_ID`),
  ADD CONSTRAINT `bus_booking_table_ibfk_2` FOREIGN KEY (`Bus_ID`) REFERENCES `bus_information_table` (`Bus_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
