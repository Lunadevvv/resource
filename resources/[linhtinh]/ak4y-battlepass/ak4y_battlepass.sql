CREATE TABLE IF NOT EXISTS `ak4y_battlepass` (
  `citizenid` varchar(255) DEFAULT NULL,
  `currentXP` int(11) DEFAULT NULL,
  `premium` int(11) DEFAULT 0,
  `standartTasks` longtext DEFAULT NULL,
  `premiumTasks` longtext DEFAULT NULL,
  `rewards` longtext DEFAULT NULL,
  `standartResetTime` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ak4y_battlepass_premiumcodes` (
  `code` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
