--
-- Structure de la table `afk_process`
--

DROP TABLE IF EXISTS `afk_process`;
CREATE TABLE IF NOT EXISTS `afk_process` (
  `identifier` varchar(60) CHARACTER SET utf8mb4 NOT NULL,
  `afkid` int NOT NULL,
  `time` int NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `afk_process`
--

INSERT INTO `afk_process` (`identifier`, `afkid`, `time`) VALUES
('char1:3172435d4ea98b7fa901a507510cdb88f173e93b', 2, 299);
COMMIT;

--
-- Structure de la table `afk_stats`
--

DROP TABLE IF EXISTS `afk_stats`;
CREATE TABLE IF NOT EXISTS `afk_stats` (
  `identifier` varchar(60) NOT NULL,
  `allmoney` int NOT NULL,
  `afks` int NOT NULL,
  `afkshours` int NOT NULL,
  `PlayerName` varchar(255) NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `afk_stats`
--

INSERT INTO `afk_stats` (`identifier`, `allmoney`, `afks`, `afkshours`, `PlayerName`) VALUES
('char1:3172435d4ea98b7fa901a507510cdb88f173e93b', 150000, 1, 20, 'Majordi 0ms WorkShop');
COMMIT;
