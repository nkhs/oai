-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 02, 2019 at 10:07 PM
-- Server version: 5.7.27-0ubuntu0.16.04.1
-- PHP Version: 7.0.33-0ubuntu0.16.04.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `oai_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `apn`
--

CREATE TABLE `apn` (
  `id` int(11) NOT NULL,
  `apn-name` varchar(60) NOT NULL,
  `pdn-type` enum('IPv4','IPv6','IPv4v6','IPv4_or_IPv6') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `apn`
--

INSERT INTO `apn` (`id`, `apn-name`, `pdn-type`) VALUES
(1, 'oai.ipv4', 'IPv4');

-- --------------------------------------------------------

--
-- Table structure for table `mmeidentity`
--

CREATE TABLE `mmeidentity` (
  `idmmeidentity` int(11) NOT NULL,
  `mmehost` varchar(255) DEFAULT NULL,
  `mmerealm` varchar(200) DEFAULT NULL,
  `UE-Reachability` tinyint(1) NOT NULL COMMENT 'Indicates whether the MME supports UE Reachability Notifcation'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mmeidentity`
--

INSERT INTO `mmeidentity` (`idmmeidentity`, `mmehost`, `mmerealm`, `UE-Reachability`) VALUES
(2, 'mme2.openair4G.eur', 'openair4G.eur', 0),
(1, 'nano.openair4G.eur', 'openair4G.eur', 0),
(5, 'abeille.openair4G.eur', 'openair4G.eur', 0),
(4, 'yang.openair4G.eur', 'openair4G.eur', 0),
(3, 'mme3.openair4G.eur', 'openair4G.eur', 0),
(6, 'calisson.openair4G.eur', 'openair4G.eur', 0),
(8, 'yang.openair4G.eur', 'openair4G.eur', 0);

-- --------------------------------------------------------

--
-- Table structure for table `pdn`
--

CREATE TABLE `pdn` (
  `id` int(11) NOT NULL,
  `apn` varchar(60) NOT NULL,
  `pdn_type` enum('IPv4','IPv6','IPv4v6','IPv4_or_IPv6') NOT NULL DEFAULT 'IPv4',
  `pdn_ipv4` varchar(15) DEFAULT '0.0.0.0',
  `pdn_ipv6` varchar(45) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT '0:0:0:0:0:0:0:0',
  `aggregate_ambr_ul` int(10) UNSIGNED DEFAULT '50000000',
  `aggregate_ambr_dl` int(10) UNSIGNED DEFAULT '100000000',
  `pgw_id` int(11) NOT NULL,
  `users_imsi` varchar(15) NOT NULL,
  `qci` tinyint(3) UNSIGNED NOT NULL DEFAULT '9',
  `priority_level` tinyint(3) UNSIGNED NOT NULL DEFAULT '15',
  `pre_emp_cap` enum('ENABLED','DISABLED') DEFAULT 'DISABLED',
  `pre_emp_vul` enum('ENABLED','DISABLED') DEFAULT 'DISABLED',
  `LIPA-Permissions` enum('LIPA-prohibited','LIPA-only','LIPA-conditional') NOT NULL DEFAULT 'LIPA-only'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pdn`
--

INSERT INTO `pdn` (`id`, `apn`, `pdn_type`, `pdn_ipv4`, `pdn_ipv6`, `aggregate_ambr_ul`, `aggregate_ambr_dl`, `pgw_id`, `users_imsi`, `qci`, `priority_level`, `pre_emp_cap`, `pre_emp_vul`, `LIPA-Permissions`) VALUES
(1, 'oai.ipv4', 'IPv4', '0.0.0.0', '0:0:0:0:0:0:0:0', 50000000, 100000000, 3, '467070000000001', 9, 15, 'DISABLED', 'ENABLED', 'LIPA-only'),
(41, 'oai.ipv4', 'IPv4', '0.0.0.0', '0:0:0:0:0:0:0:0', 50000000, 100000000, 3, '467070000000002', 9, 15, 'DISABLED', 'ENABLED', 'LIPA-only'),
(40, 'oai.ipv4', 'IPv4', '0.0.0.0', '0:0:0:0:0:0:0:0', 50000000, 100000000, 3, '467070000000003', 9, 15, 'DISABLED', 'ENABLED', 'LIPA-only'),
(42, 'oai.ipv4', 'IPv4', '0.0.0.0', '0:0:0:0:0:0:0:0', 50000000, 100000000, 3, '467070000000004', 9, 15, 'DISABLED', 'ENABLED', 'LIPA-only');

-- --------------------------------------------------------

--
-- Table structure for table `pgw`
--

CREATE TABLE `pgw` (
  `id` int(11) NOT NULL,
  `ipv4` varchar(15) NOT NULL,
  `ipv6` varchar(39) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pgw`
--

INSERT INTO `pgw` (`id`, `ipv4`, `ipv6`) VALUES
(1, '127.0.0.1', '0:0:0:0:0:0:0:1'),
(3, '192.168.1.1', '');

-- --------------------------------------------------------

--
-- Table structure for table `terminal-info`
--

CREATE TABLE `terminal-info` (
  `imei` varchar(15) NOT NULL,
  `sv` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `imsi` varchar(15) NOT NULL COMMENT 'IMSI is the main reference key.',
  `msisdn` varchar(46) DEFAULT NULL COMMENT 'The basic MSISDN of the UE (Presence of MSISDN is optional).',
  `imei` varchar(15) DEFAULT NULL COMMENT 'International Mobile Equipment Identity',
  `imei_sv` varchar(2) DEFAULT NULL COMMENT 'International Mobile Equipment Identity Software Version Number',
  `ms_ps_status` enum('PURGED','NOT_PURGED') DEFAULT 'PURGED' COMMENT 'Indicates that ESM and EMM status are purged from MME',
  `rau_tau_timer` int(10) UNSIGNED DEFAULT '120',
  `ue_ambr_ul` bigint(20) UNSIGNED DEFAULT '50000000' COMMENT 'The Maximum Aggregated uplink MBRs to be shared across all Non-GBR bearers according to the subscription of the user.',
  `ue_ambr_dl` bigint(20) UNSIGNED DEFAULT '100000000' COMMENT 'The Maximum Aggregated downlink MBRs to be shared across all Non-GBR bearers according to the subscription of the user.',
  `access_restriction` int(10) UNSIGNED DEFAULT '60' COMMENT 'Indicates the access restriction subscription information. 3GPP TS.29272 #7.3.31',
  `mme_cap` int(10) UNSIGNED ZEROFILL DEFAULT NULL COMMENT 'Indicates the capabilities of the MME with respect to core functionality e.g. regional access restrictions.',
  `mmeidentity_idmmeidentity` int(11) NOT NULL DEFAULT '0',
  `key` varbinary(16) NOT NULL DEFAULT '0' COMMENT 'UE security key',
  `RFSP-Index` smallint(5) UNSIGNED NOT NULL DEFAULT '1' COMMENT 'An index to specific RRM configuration in the E-UTRAN. Possible values from 1 to 256',
  `urrp_mme` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'UE Reachability Request Parameter indicating that UE activity notification from MME has been requested by the HSS.',
  `sqn` bigint(20) UNSIGNED ZEROFILL NOT NULL,
  `rand` varbinary(16) NOT NULL,
  `OPc` varbinary(16) DEFAULT NULL COMMENT 'Can be computed by HSS'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`imsi`, `msisdn`, `imei`, `imei_sv`, `ms_ps_status`, `rau_tau_timer`, `ue_ambr_ul`, `ue_ambr_dl`, `access_restriction`, `mme_cap`, `mmeidentity_idmmeidentity`, `key`, `RFSP-Index`, `urrp_mme`, `sqn`, `rand`, `OPc`) VALUES
('467070000000002', '001011234561000', '35609204079210', NULL, 'NOT_PURGED', 120, 50000000, 100000000, 47, 0000000000, 4, 0x8baf473f2f8fd09487cccbd7097c6862, 1, 0, 00000000000000018426, 0x15a4e40836352a4760631469e350330b, 0xe734f8734007d6c5ce7a0508809e7e9c),
('467070000000003', '001011234561000', '35609204079210', NULL, 'NOT_PURGED', 120, 50000000, 100000000, 47, 0000000000, 4, 0x8baf473f2f8fd09487cccbd7097c6862, 1, 0, 00000000000000025667, 0x2c43c34b08bf521377cc8744dadf6642, 0xe734f8734007d6c5ce7a0508809e7e9c),
('467070000000004', '001011234561000', '35609204079210', NULL, 'NOT_PURGED', 120, 50000000, 100000000, 47, 0000000000, 4, 0x8baf473f2f8fd09487cccbd7097c6862, 1, 0, 00000000000000021133, 0xe695ef3e0b11916974a06705b755ea10, 0xe734f8734007d6c5ce7a0508809e7e9c),
('467070000000001', '001011234561000', '35609204079210', NULL, 'NOT_PURGED', 120, 50000000, 100000000, 47, 0000000000, 4, 0x8baf473f2f8fd09487cccbd7097c6862, 1, 0, 00000000000000025897, 0x19cbc95daa05be2945f86c39b86f7e64, 0xe734f8734007d6c5ce7a0508809e7e9c);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `apn`
--
ALTER TABLE `apn`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `apn-name` (`apn-name`);

--
-- Indexes for table `mmeidentity`
--
ALTER TABLE `mmeidentity`
  ADD PRIMARY KEY (`idmmeidentity`);

--
-- Indexes for table `pdn`
--
ALTER TABLE `pdn`
  ADD PRIMARY KEY (`id`,`pgw_id`,`users_imsi`),
  ADD KEY `fk_pdn_pgw1_idx` (`pgw_id`),
  ADD KEY `fk_pdn_users1_idx` (`users_imsi`);

--
-- Indexes for table `pgw`
--
ALTER TABLE `pgw`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ipv4` (`ipv4`),
  ADD UNIQUE KEY `ipv6` (`ipv6`);

--
-- Indexes for table `terminal-info`
--
ALTER TABLE `terminal-info`
  ADD UNIQUE KEY `imei` (`imei`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`imsi`,`mmeidentity_idmmeidentity`),
  ADD KEY `fk_users_mmeidentity_idx1` (`mmeidentity_idmmeidentity`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `apn`
--
ALTER TABLE `apn`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `mmeidentity`
--
ALTER TABLE `mmeidentity`
  MODIFY `idmmeidentity` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;
--
-- AUTO_INCREMENT for table `pdn`
--
ALTER TABLE `pdn`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;
--
-- AUTO_INCREMENT for table `pgw`
--
ALTER TABLE `pgw`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
