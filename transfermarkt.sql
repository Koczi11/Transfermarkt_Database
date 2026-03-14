/*
 Navicat Premium Dump SQL

 Source Server         : transfermarkt server
 Source Server Type    : MariaDB
 Source Server Version : 100432 (10.4.32 21.06.17-maxscale)
 Source Host           : serverless-us-central1.sysp0000.db2.skysql.com:4035
 Source Schema         : transfermarkt

 Target Server Type    : MariaDB
 Target Server Version : 100432 (10.4.32 21.06.17-maxscale)
 File Encoding         : 65001

 Date: 26/01/2026 13:20:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for !shared_queries
-- ----------------------------
DROP TABLE IF EXISTS `!shared_queries`;
CREATE TABLE `!shared_queries`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `query_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of !shared_queries
-- ----------------------------
INSERT INTO `!shared_queries` VALUES (1, 'Event', 'create or replace event admin_check\r\non schedule every 1 day\r\nDO\r\n  create or replace view admin_check AS\r\n  select u.user_name, u.user_id, (select count(*) from admin) as count\r\n  FROM admin a\r\n  JOIN user u ON a.user_id = u.user_id;', '2026-01-13 13:04:21');
INSERT INTO `!shared_queries` VALUES (2, 'TriggerUpdate', 'DELIMITER $$\r\n\r\ncreate or replace TRIGGER OLD_PLAYER_UPDATE\r\nAfter UPDATE on player\r\nfor each row\r\nbegin\r\n  IF TIMESTAMPDIFF(YEAR, NEW.player_birth_date, NOW()) >= 40 THEN\r\n    UPDATE oldboys \r\n    SET \r\n        oldboy_club_id = NEW.club_id,\r\n        oldboy_name = NEW.player_name,\r\n        oldboy_nationality = NEW.player_nationality,\r\n        oldboy_birth_date = NEW.player_birth_date,\r\n        oldboy_position = NEW.player_position,\r\n        oldboy_market_value = NEW.player_market_value,\r\n        oldboy_height = NEW.player_height,\r\n        oldboy_foot = NEW.player_foot,\r\n        oldboy_last_modified_by_admin_id = NEW.player_last_modified_by_admin_id\r\n    WHERE oldboy_id = NEW.player_id;\r\n\r\n    END IF;\r\nEND $$\r\n\r\nDELIMITER ;', '2026-01-13 13:04:57');
INSERT INTO `!shared_queries` VALUES (3, 'TriggerInsert', 'DELIMITER $$\r\n\r\ncreate or replace TRIGGER OLD_PLAYER_INSERT\r\nAfter insert on player\r\nfor each row\r\nbegin\r\n  IF TIMESTAMPDIFF(YEAR, NEW.player_birth_date, NOW()) >= 40 THEN\r\n    INSERT INTO oldboys (\r\n          oldboy_id, \r\n          oldboy_club_id, \r\n          oldboy_name, \r\n          oldboy_nationality, \r\n          oldboy_birth_date, \r\n          oldboy_position, \r\n          oldboy_market_value, \r\n          oldboy_height, \r\n          oldboy_foot, \r\n          oldboy_last_modified_by_admin_id\r\n      )\r\n      VALUES (\r\n          NEW.player_id, \r\n          NEW.club_id, \r\n          NEW.player_name, \r\n          NEW.player_nationality, \r\n          NEW.player_birth_date, \r\n          NEW.player_position, \r\n          NEW.player_market_value, \r\n          NEW.player_height, \r\n          NEW.player_foot, \r\n          NEW.player_last_modified_by_admin_id\r\n      );\r\n    END IF;\r\nEND $$\r\n\r\nDELIMITER ;', '2026-01-13 13:05:29');
INSERT INTO `!shared_queries` VALUES (4, 'Recursive1', 'with recursive Match_Calendar as (\r\n  SELECT\r\n    cast(\"2026-02-01\" as date) as match_date,\r\n    1 as match_day_number\r\n\r\n  Union all\r\n\r\n  SELECT\r\n    DATE_ADD(match_date, INTERVAL 7 DAY),\r\n    match_day_number + 1\r\n  FROM Match_Calendar\r\n  WHERE match_day_number < 10\r\n)\r\n\r\nSELECT * from Match_Calendar', '2026-01-13 13:06:56');
INSERT INTO `!shared_queries` VALUES (5, 'Recursive2', 'WITH RECURSIVE player_path AS (\r\n  SELECT\r\n    player_id,\r\n    from_club_id,\r\n    to_club_id,\r\n    transer_t_date,\r\n    1 as step,\r\n    CAST(CONCAT(IFNULL(from_club_id, \"Wolny\"), \" -> \", to_club_id) AS char(255)) as path\r\n  FROM transfer\r\n  WHERE player_id = 1\r\n  AND transer_t_date = (SELECT MIN(transer_t_date) FROM transfer WHERE player_id = 1)\r\n\r\n  UNION ALL\r\n\r\n  SELECT\r\n    t.player_id,\r\n    t.from_club_id,\r\n    t.to_club_id,\r\n    t.transer_t_date,\r\n    pp.step + 1,\r\n    CONCAT(pp.path, \" -> \", t.to_club_id)\r\n  FROM transfer t\r\n  INNER JOIN player_path pp \r\n    ON t.from_club_id = pp.to_club_id \r\n    AND t.player_id = pp.player_id\r\n    AND t.transer_t_date > pp.transer_t_date\r\n)\r\nSELECT * FROM player_path;', '2026-01-13 13:07:45');
INSERT INTO `!shared_queries` VALUES (6, 'FullText', 'select player_name from player\r\n\r\nwhere match(player_name)\r\nagainst(\"+Kamil\" in boolean mode);', '2026-01-13 13:08:05');
INSERT INTO `!shared_queries` VALUES (7, 'Transakcja', 'START TRANSACTION;\r\n\r\nUPDATE player \r\nSET club_id = 2 \r\nWHERE player_id = 3;\r\n\r\nINSERT INTO transfer (\r\n    player_id, \r\n    from_club_id, \r\n    to_club_id, \r\n    transer_t_date, \r\n    transer_t_fee\r\n) \r\nVALUES (\r\n    3,\r\n    1,\r\n    2,\r\n    CURDATE(),\r\n    1000000.00\r\n);', '2026-01-14 13:19:27');
INSERT INTO `!shared_queries` VALUES (8, 'Funkcja ', 'DELIMITER //\r\nCREATE FUNCTION calculate_manager_fee(fee DECIMAL(12,2))\r\nRETURNS DECIMAL(12,2)\r\nDETERMINISTIC\r\nBEGIN\r\n  DECLARE commission DECIMAL(12,2);\r\n  \r\n  IF fee IS NULL OR fee <= 0 THEN\r\n    RETURN 0.00;\r\n  END IF;\r\n  \r\n  IF fee < 1000000 THEN\r\n    SET commission = fee * 0.10;\r\n  ELSE\r\n    SET commission = fee * 0.06;\r\n  END IF;\r\n  \r\n  RETURN commission;\r\nEND //\r\nDELIMITER ;', '2026-01-17 11:16:46');
INSERT INTO `!shared_queries` VALUES (9, 'Funkcja użycie', 'SELECT\r\n  t.transfer_id, p.player_name,\r\n  t.from_club_id, c.Club_name as \'klub sprzedający\',\r\n  t.transer_t_fee as \'kwota transferu\',\r\n  t.to_club_id, c2.Club_name as \'klub pozyskujący\',\r\n  calculate_manager_fee(t.transer_t_fee) as \'prowizja managera\',\r\n  (t.transer_t_fee - calculate_manager_fee(t.transer_t_fee)) as \'zysk klubu sprzedającego\'\r\nFROM\r\n  transfer t \r\nJOIN\r\n  player p ON t.player_id = p.player_id\r\nJOIN\r\n  club c on t.from_club_id = c.club_id\r\nJOIN\r\n  club c2 on t.to_club_id = c2.club_id;', '2026-01-17 11:30:51');
INSERT INTO `!shared_queries` VALUES (10, 'Procedura', 'DELIMITER //\r\n\r\ncreate or replace PROCEDURE update_player_value\r\n(\r\n  in p_player_id INT,\r\n  in p_new_value DECIMAL(10, 2)\r\n)\r\nBEGIN\r\n  declare v_exists INT;\r\n  \r\n  select count(*) into v_exists from player\r\n  where player_id = p_player_id;\r\n  \r\n  if v_exists > 0 THEN\r\n    update player\r\n    set player_market_value = p_new_value\r\n    Where player_id = p_player_id;\r\n  end if;\r\nEND//\r\n\r\nDELIMITER ;', '2026-01-17 20:10:28');
INSERT INTO `!shared_queries` VALUES (11, 'Procedura użycie', 'call update_player_value(1, 100);', '2026-01-17 20:12:54');
INSERT INTO `!shared_queries` VALUES (12, '---------------------------', '--------------------------', '2026-01-17 20:12:58');
INSERT INTO `!shared_queries` VALUES (13, 'Wiek pilkarza', 'select player_name, TIMESTAMPDIFF(YEAR,player_birth_date,CURDATE()) as wiek from player;', '2026-01-18 18:27:42');
INSERT INTO `!shared_queries` VALUES (14, 'inicjał + nazwisko', 'select player_id, CONCAT(SUBSTRING(player_name, 1,1),\".\" ,SUBSTRING_INDEX(player_name, \" \", -1))from player;', '2026-01-18 18:27:51');
INSERT INTO `!shared_queries` VALUES (15, 'Funkcja podatek przy transferze + excemption handler', 'DELIMITER $$\r\n\r\nCREATE OR REPLACE FUNCTION TransferTax (a DECIMAL(12,2))\r\nRETURNS DECIMAL(12,2)\r\nDETERMINISTIC\r\nBEGIN\r\n    DECLARE wynik DECIMAL(12,2);\r\n    BEGIN\r\n        -- Handler\r\n        DECLARE EXIT HANDLER FOR SQLEXCEPTION\r\n        BEGIN\r\n            SET wynik = -1.00;\r\n        END;\r\n\r\n        IF a < 0 THEN\r\n            SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'Ujemna kwota\';\r\n        END IF;\r\n\r\n        IF a < 1000000 THEN\r\n            SET wynik = a * 0.10;\r\n        ELSE\r\n            SET wynik = a * 0.06;\r\n        END IF;\r\n    END; \r\n    RETURN wynik;\r\nEND$$\r\n\r\nDELIMITER ;', '2026-01-18 18:28:14');
INSERT INTO `!shared_queries` VALUES (16, ' Zapis tabeli z wersjonowaniem sprzed minuty przed updatem', 'select * from transfer for system_time as of (NOW() - INTERVAL 1 MINUTE);', '2026-01-18 18:28:20');
INSERT INTO `!shared_queries` VALUES (17, 'zapis wyszukania wszystkiego o danym ID orderowane po row_end', 'Select * from transfer FOR SYSTEM_TIME ALL WHERE transfer_id = 2 order by row_end desc; ', '2026-01-18 18:28:32');
INSERT INTO `!shared_queries` VALUES (18, 'Porownanie przeszłosci z terazniejszoscia, join do tej samej tabeli + system versioning', 'select N.transfer_id AS ID ,\r\n       N.transer_t_fee as Nowy,\r\n       S.transer_t_fee as Stary\r\n       from transfer for SYSTEM_TIME AS OF (NOW() - INTERVAL 1 HOUR) as S \r\n       JOIN transfer N on S.transfer_id = N.transfer_id;', '2026-01-18 18:28:42');
INSERT INTO `!shared_queries` VALUES (19, 'ranking zarobkow (top 3) CTE', 'with rankingZarobkow as (\r\n  select C.club_name,\r\n         P.player_name,\r\n         CON.PC_salary,\r\n         DENSE_RANK() OVER (PARTITION BY C.Club_name order by CON.PC_salary desc) as ranking\r\n                               \r\nfrom club C JOIN pLayer P On P.club_id = C.club_id\r\nJOIN player_contract CON ON CON.player_id = P.player_id)\r\n\r\nselect * from rankingZarobkow where ranking <= 3;', '2026-01-18 18:28:56');
INSERT INTO `!shared_queries` VALUES (20, 'koszt za gola z CTE', 'WITH SumaGoli AS (\r\n    SELECT \r\n        player_id, \r\n        SUM(PMS_goals) as lacznie_goli\r\n    FROM player_match_stats\r\n    GROUP BY player_id\r\n)\r\nSELECT \r\n    P.player_name,\r\n    T.transer_t_fee AS Koszt_Transferu,\r\n    GS.lacznie_goli AS Liczba_Goli,\r\n    ROUND(T.transer_t_fee / NULLIF(GS.lacznie_goli, 0), 2) AS Koszt_Za_Gola\r\nFROM player P\r\nJOIN transfer T ON P.player_id = T.player_id\r\nLEFT JOIN SumaGoli GS ON P.player_id = GS.player_id;', '2026-01-18 18:29:29');
INSERT INTO `!shared_queries` VALUES (21, '-------------------------------', '----------------------------', '2026-01-18 18:29:47');

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `user_id` int(11) NOT NULL,
  `admin_since` date NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `fk_admin_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, '2020-01-01');

-- ----------------------------
-- Table structure for admin_permissions
-- ----------------------------
DROP TABLE IF EXISTS `admin_permissions`;
CREATE TABLE `admin_permissions`  (
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `granted_at` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `permission_id`) USING BTREE,
  INDEX `fk_admin_permissions_perm_id`(`permission_id`) USING BTREE,
  CONSTRAINT `fk_admin_permissions_admin_id` FOREIGN KEY (`user_id`) REFERENCES `admin` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_admin_permissions_perm_id` FOREIGN KEY (`permission_id`) REFERENCES `permission_list` (`permission_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_permissions
-- ----------------------------
INSERT INTO `admin_permissions` VALUES (1, 1, '2026-01-14 13:33:22');
INSERT INTO `admin_permissions` VALUES (1, 2, '2026-01-14 13:33:22');

-- ----------------------------
-- Table structure for club
-- ----------------------------
DROP TABLE IF EXISTS `club`;
CREATE TABLE `club`  (
  `club_id` int(32) NOT NULL AUTO_INCREMENT,
  `league_id` int(32) NOT NULL,
  `Club_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Club_stadium` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Club_f_year` date NULL DEFAULT NULL,
  PRIMARY KEY (`club_id`) USING BTREE,
  UNIQUE INDEX `idx_club_name`(`Club_name`) USING BTREE,
  INDEX `fk_club_league`(`league_id`) USING BTREE,
  FULLTEXT INDEX `ft_club_search`(`Club_name`),
  CONSTRAINT `fk_club_league` FOREIGN KEY (`league_id`) REFERENCES `league` (`league_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club
-- ----------------------------
INSERT INTO `club` VALUES (1, 1, 'Legia Warszawa', 'Stadion Wojska Polskiego', '1916-01-01');
INSERT INTO `club` VALUES (2, 1, 'Lech Poznań', 'Stadion Miejski', '1922-03-19');
INSERT INTO `club` VALUES (3, 2, 'Dynamo Kijów', 'Stadion Olimpijski', '1927-05-13');
INSERT INTO `club` VALUES (4, 3, 'Manchester City', 'Etihad Stadium', '1880-01-01');
INSERT INTO `club` VALUES (5, 4, 'Real Madryt', 'Santiago Bernabeu', '1902-03-06');
INSERT INTO `club` VALUES (11, 1, 'Arsenal FC', 'Emirates Stadium', '1886-01-01');
INSERT INTO `club` VALUES (12, 1, 'Liverpool FC', 'Anfield', '1892-06-03');
INSERT INTO `club` VALUES (13, 1, 'Manchester United', 'Old Trafford', '1878-01-01');
INSERT INTO `club` VALUES (14, 1, 'Chelsea FC', 'Stamford Bridge', '1905-03-10');
INSERT INTO `club` VALUES (20, 2, 'Real Madrid', 'Santiago Bernabeu', '1902-03-06');
INSERT INTO `club` VALUES (21, 2, 'FC Barcelona', 'Spotify Camp Nou', '1899-11-29');
INSERT INTO `club` VALUES (22, 2, 'Atletico Madrid', 'Civitas Metropolitano', '1903-04-26');
INSERT INTO `club` VALUES (30, 3, 'Bayern Munich', 'Allianz Arena', '1900-02-27');
INSERT INTO `club` VALUES (31, 3, 'Bayer Leverkusen', 'BayArena', '1904-07-01');
INSERT INTO `club` VALUES (32, 3, 'Borussia Dortmund', 'Signal Iduna Park', '1909-12-19');
INSERT INTO `club` VALUES (40, 4, 'Inter Milan', 'San Siro', '1908-03-09');
INSERT INTO `club` VALUES (41, 4, 'AC Milan', 'San Siro', '1899-12-16');
INSERT INTO `club` VALUES (42, 4, 'Juventus', 'Allianz Stadium', '1897-11-01');
INSERT INTO `club` VALUES (43, 4, 'Napoli', 'Stadio Diego Armando Maradona', '1926-08-25');
INSERT INTO `club` VALUES (52, 5, 'Raków Częstochowa', 'Miejski Stadion Piłkarski Raków', '1921-03-01');
INSERT INTO `club` VALUES (53, 5, 'Pogoń Szczecin', 'Stadion Miejski im. Floriana Krygiera', '1948-04-21');
INSERT INTO `club` VALUES (54, 5, 'Górnik Zabrze', 'Arena Zabrze', '1948-12-14');
INSERT INTO `club` VALUES (60, 6, 'PSG', 'Parc des Princes', '1970-08-12');

-- ----------------------------
-- Table structure for club_stats
-- ----------------------------
DROP TABLE IF EXISTS `club_stats`;
CREATE TABLE `club_stats`  (
  `club_id` int(32) NOT NULL,
  `CS_season` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CS_position` int(32) NULL DEFAULT NULL,
  `CS_wins` int(32) UNSIGNED NULL DEFAULT NULL,
  `CS_draws` int(32) UNSIGNED NULL DEFAULT NULL,
  `CS_loses` int(32) UNSIGNED NULL DEFAULT NULL,
  `CS_goal_scored` int(32) UNSIGNED NULL DEFAULT NULL,
  `CS_goal_conceded` int(32) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`club_id`, `CS_season`) USING BTREE,
  CONSTRAINT `fk_cs_club_id` FOREIGN KEY (`club_id`) REFERENCES `club` (`club_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_stats
-- ----------------------------
INSERT INTO `club_stats` VALUES (1, '2025/2026', 1, 10, 2, 1, 25, 10);
INSERT INTO `club_stats` VALUES (2, '2025/2026', 2, 9, 3, 1, 22, 12);

-- ----------------------------
-- Table structure for club_trophy
-- ----------------------------
DROP TABLE IF EXISTS `club_trophy`;
CREATE TABLE `club_trophy`  (
  `club_trophy_id` int(32) NOT NULL AUTO_INCREMENT,
  `club_id` int(32) NOT NULL,
  `trophy_id` int(32) NOT NULL,
  `CT_wins` int(32) UNSIGNED NULL DEFAULT NULL,
  `CT_last_win` year NULL DEFAULT NULL,
  PRIMARY KEY (`club_trophy_id`) USING BTREE,
  INDEX `idx_club_id`(`club_id`) USING BTREE,
  INDEX `idx_trophy_id`(`trophy_id`) USING BTREE,
  CONSTRAINT `fk_ct_club_id` FOREIGN KEY (`club_id`) REFERENCES `club` (`club_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ct_trophy_id` FOREIGN KEY (`trophy_id`) REFERENCES `trophy` (`trophy_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_trophy
-- ----------------------------
INSERT INTO `club_trophy` VALUES (1, 1, 1, 15, 2021);
INSERT INTO `club_trophy` VALUES (2, 2, 1, 8, 2022);
INSERT INTO `club_trophy` VALUES (3, 5, 3, 14, 2022);
INSERT INTO `club_trophy` VALUES (4, 20, 3, 15, 2024);
INSERT INTO `club_trophy` VALUES (5, 10, 1, 10, 2024);
INSERT INTO `club_trophy` VALUES (6, 30, 1, 33, 2023);
INSERT INTO `club_trophy` VALUES (7, 50, 1, 15, 2021);

-- ----------------------------
-- Table structure for coach
-- ----------------------------
DROP TABLE IF EXISTS `coach`;
CREATE TABLE `coach`  (
  `coach_id` int(32) NOT NULL AUTO_INCREMENT,
  `club_id` int(32) NOT NULL,
  `coach_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `coach_nationality` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `coach_birth_date` date NULL DEFAULT NULL,
  `coach_last_modified_by_admin_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`coach_id`) USING BTREE,
  INDEX `fk_coach_club_id`(`club_id`) USING BTREE,
  INDEX `fk_coach_modified_by_admin`(`coach_last_modified_by_admin_id`) USING BTREE,
  CONSTRAINT `fk_coach_club_id` FOREIGN KEY (`club_id`) REFERENCES `club` (`club_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_coach_modified_by_admin` FOREIGN KEY (`coach_last_modified_by_admin_id`) REFERENCES `admin` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coach
-- ----------------------------
INSERT INTO `coach` VALUES (1, 4, 'Pep Guardiola', 'Hiszpania', '1971-01-18', 1);
INSERT INTO `coach` VALUES (2, 1, 'Goncalo Feio', 'Portugalia', '1990-01-17', 1);
INSERT INTO `coach` VALUES (10, 10, 'Pep Guardiola', 'Hiszpania', '1971-01-18', NULL);
INSERT INTO `coach` VALUES (11, 11, 'Mikel Arteta', 'Hiszpania', '1982-03-26', NULL);
INSERT INTO `coach` VALUES (12, 12, 'Arne Slot', 'Holandia', '1978-09-17', NULL);
INSERT INTO `coach` VALUES (13, 13, 'Ruben Amorim', 'Portugalia', '1985-01-27', NULL);
INSERT INTO `coach` VALUES (20, 20, 'Carlo Ancelotti', 'Włochy', '1959-06-10', NULL);
INSERT INTO `coach` VALUES (21, 21, 'Hansi Flick', 'Niemcy', '1965-02-24', NULL);
INSERT INTO `coach` VALUES (22, 22, 'Diego Simeone', 'Argentyna', '1970-04-28', NULL);
INSERT INTO `coach` VALUES (30, 30, 'Vincent Kompany', 'Belgia', '1986-04-10', NULL);
INSERT INTO `coach` VALUES (31, 31, 'Xabi Alonso', 'Hiszpania', '1981-11-25', NULL);
INSERT INTO `coach` VALUES (40, 40, 'Simone Inzaghi', 'Włochy', '1976-04-05', NULL);
INSERT INTO `coach` VALUES (42, 42, 'Thiago Motta', 'Włochy', '1982-08-28', NULL);
INSERT INTO `coach` VALUES (50, 50, 'Goncalo Feio', 'Portugalia', '1990-01-17', NULL);
INSERT INTO `coach` VALUES (51, 51, 'Niels Frederiksen', 'Dania', '1970-11-05', NULL);
INSERT INTO `coach` VALUES (52, 52, 'Marek Papszun', 'Polska', '1974-08-08', NULL);

-- ----------------------------
-- Table structure for coach_contract
-- ----------------------------
DROP TABLE IF EXISTS `coach_contract`;
CREATE TABLE `coach_contract`  (
  `contract_id` int(32) NOT NULL AUTO_INCREMENT,
  `coach_id` int(32) NOT NULL,
  `club_id` int(32) NOT NULL,
  `CC_s_date` date NULL DEFAULT NULL,
  `CC_e_date` date NULL DEFAULT NULL,
  `CC_salary` decimal(12, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`contract_id`) USING BTREE,
  INDEX `fk_contract_club_id`(`club_id`) USING BTREE,
  INDEX `fk_coach_contract_player_id`(`coach_id`) USING BTREE,
  CONSTRAINT `coach_contract_ibfk_1` FOREIGN KEY (`club_id`) REFERENCES `club` (`club_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coach_contract_ibfk_2` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`coach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coach_contract
-- ----------------------------
INSERT INTO `coach_contract` VALUES (1, 1, 4, '2016-07-01', '2025-06-30', 20000000.00);
INSERT INTO `coach_contract` VALUES (2, 2, 1, '2024-04-10', '2025-06-30', 500000.00);
INSERT INTO `coach_contract` VALUES (3, 10, 10, '2016-07-01', '2025-06-30', 20000000.00);
INSERT INTO `coach_contract` VALUES (4, 11, 11, '2019-12-22', '2027-06-30', 10000000.00);
INSERT INTO `coach_contract` VALUES (5, 20, 20, '2021-06-01', '2026-06-30', 12000000.00);
INSERT INTO `coach_contract` VALUES (6, 22, 22, '2011-12-23', '2027-06-30', 30000000.00);
INSERT INTO `coach_contract` VALUES (7, 31, 31, '2022-10-05', '2026-06-30', 6000000.00);
INSERT INTO `coach_contract` VALUES (8, 50, 50, '2024-04-10', '2025-06-30', 400000.00);
INSERT INTO `coach_contract` VALUES (9, 52, 52, '2023-01-01', '2026-06-30', 800000.00);

-- ----------------------------
-- Table structure for league
-- ----------------------------
DROP TABLE IF EXISTS `league`;
CREATE TABLE `league`  (
  `league_id` int(32) NOT NULL AUTO_INCREMENT,
  `league_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `league_country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `league_season` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`league_id`) USING BTREE,
  UNIQUE INDEX `idx_name`(`league_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of league
-- ----------------------------
INSERT INTO `league` VALUES (1, 'PKO Ekstraklasa', 'Polska', '2025/2026');
INSERT INTO `league` VALUES (2, 'Premier Liha', 'Ukraina', '2025/2026');
INSERT INTO `league` VALUES (3, 'Premier League', 'Anglia', '2025/2026');
INSERT INTO `league` VALUES (4, 'La Liga', 'Hiszpania', '2025/2026');
INSERT INTO `league` VALUES (5, 'Ekstraklasa', 'Poland', NULL);
INSERT INTO `league` VALUES (6, 'Ligue 1', 'Francja', '2025/2026');

-- ----------------------------
-- Table structure for match
-- ----------------------------
DROP TABLE IF EXISTS `match`;
CREATE TABLE `match`  (
  `match_id` int(32) NOT NULL AUTO_INCREMENT,
  `league_id` int(32) NOT NULL,
  `match_home_club_id` int(32) NOT NULL,
  `match_away_club_id` int(32) NOT NULL,
  `match_match_date` date NULL DEFAULT NULL,
  `match_stadium` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `match_home_goals` int(32) UNSIGNED NULL DEFAULT NULL,
  `match_away_goals` int(32) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`match_id`) USING BTREE,
  INDEX `uniq_match`(`league_id`, `match_home_club_id`, `match_away_club_id`, `match_match_date`) USING BTREE,
  INDEX `fk_match_home`(`match_home_club_id`) USING BTREE,
  INDEX `fk_match_away_club_id`(`match_away_club_id`) USING BTREE,
  CONSTRAINT `fk_match_away_club_id` FOREIGN KEY (`match_away_club_id`) REFERENCES `club` (`club_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_match_home` FOREIGN KEY (`match_home_club_id`) REFERENCES `club` (`club_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_match_league_id` FOREIGN KEY (`league_id`) REFERENCES `league` (`league_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of match
-- ----------------------------
INSERT INTO `match` VALUES (1, 1, 1, 2, '2025-10-15', 'Stadion Wojska Polskiego', 2, 1);
INSERT INTO `match` VALUES (10, 1, 10, 11, '2025-09-01', 'Etihad Stadium', 2, 2);
INSERT INTO `match` VALUES (11, 2, 20, 21, '2025-10-28', 'Santiago Bernabeu', 0, 4);
INSERT INTO `match` VALUES (12, 3, 30, 32, '2025-11-04', 'Allianz Arena', 3, 1);
INSERT INTO `match` VALUES (13, 5, 50, 51, '2025-05-12', 'Stadion Wojska Polskiego', 1, 0);
INSERT INTO `match` VALUES (14, 4, 40, 41, '2025-09-20', 'San Siro', 2, 1);
INSERT INTO `match` VALUES (20, 1, 13, 12, '2025-09-15', 'Old Trafford', 0, 3);
INSERT INTO `match` VALUES (21, 5, 52, 50, '2025-04-01', 'Miejski Stadion Piłkarski Raków', 1, 1);
INSERT INTO `match` VALUES (22, 4, 40, 42, '2025-10-27', 'San Siro', 4, 4);
INSERT INTO `match` VALUES (23, 3, 31, 30, '2025-12-01', 'BayArena', 2, 3);
INSERT INTO `match` VALUES (24, 2, 22, 20, '2025-09-29', 'Civitas Metropolitano', 1, 1);
INSERT INTO `match` VALUES (25, 1, 11, 13, '2025-12-04', 'Emirates Stadium', 2, 0);

-- ----------------------------
-- Table structure for oldboys
-- ----------------------------
DROP TABLE IF EXISTS `oldboys`;
CREATE TABLE `oldboys`  (
  `oldboy_id` int(32) NOT NULL AUTO_INCREMENT,
  `oldboy_club_id` int(32) NULL DEFAULT NULL,
  `oldboy_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `oldboy_nationality` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `oldboy_birth_date` date NOT NULL,
  `oldboy_position` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `oldboy_market_value` decimal(12, 2) NULL DEFAULT NULL,
  `oldboy_height` int(11) NULL DEFAULT NULL,
  `oldboy_foot` enum('left','right','both') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `oldboy_last_modified_by_admin_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`oldboy_id`, `oldboy_birth_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 217 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic PARTITION BY RANGE (year(`oldboy_birth_date`))
PARTITIONS 13
(PARTITION `ancient` VALUES LESS THAN (1920) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_1920` VALUES LESS THAN (1930) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_1930` VALUES LESS THAN (1940) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_1940` VALUES LESS THAN (1950) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_1950` VALUES LESS THAN (1960) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_1960` VALUES LESS THAN (1970) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_1970` VALUES LESS THAN (1980) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_1980` VALUES LESS THAN (1990) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_1990` VALUES LESS THAN (2000) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_2000` VALUES LESS THAN (2010) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_2010` VALUES LESS THAN (2020) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_2020` VALUES LESS THAN (2030) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `future` VALUES LESS THAN (MAXVALUE) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 )
;

-- ----------------------------
-- Records of oldboys
-- ----------------------------
INSERT INTO `oldboys` VALUES (7, NULL, 'Zbigniew Boniek', 'Polska', '1956-03-03', 'Napastnik', 0.00, 181, 'right', NULL);
INSERT INTO `oldboys` VALUES (3, 2, 'Cristiano Ronaldo', 'Portugalia', '1985-02-05', 'Napastnik', 5000000.00, 187, 'both', NULL);
INSERT INTO `oldboys` VALUES (213, 54, 'Lukas Podolski', 'Niemcy', '1985-06-04', 'Napastnik', 200000.00, 182, 'left', NULL);
INSERT INTO `oldboys` VALUES (216, 20, 'Luka Modric', 'Chorwacja', '1985-09-09', 'Pomocnik', 6000000.00, 172, 'both', NULL);

-- ----------------------------
-- Table structure for permission_list
-- ----------------------------
DROP TABLE IF EXISTS `permission_list`;
CREATE TABLE `permission_list`  (
  `permission_id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `permission_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`permission_id`) USING BTREE,
  UNIQUE INDEX `idx_permission_name`(`permission_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permission_list
-- ----------------------------
INSERT INTO `permission_list` VALUES (1, 'EDIT_PLAYER', 'Możliwość edycji danych zawodnika');
INSERT INTO `permission_list` VALUES (2, 'APPROVE_TRANSFER', 'Zatwierdzanie transferów');
INSERT INTO `permission_list` VALUES (3, 'DELETE_USER', 'Usuwanie użytkowników');

-- ----------------------------
-- Table structure for player
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player`  (
  `player_id` int(32) NOT NULL AUTO_INCREMENT,
  `club_id` int(32) NULL DEFAULT NULL,
  `player_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `player_nationality` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `player_birth_date` date NULL DEFAULT NULL,
  `player_position` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `player_market_value` decimal(12, 2) NULL DEFAULT NULL,
  `player_height` int(11) NULL DEFAULT NULL,
  `player_foot` enum('left','right','both') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `player_last_modified_by_admin_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`player_id`) USING BTREE,
  INDEX `idx_player_club_id`(`club_id`) USING BTREE,
  INDEX `fk_player_last_modified_by_admin`(`player_last_modified_by_admin_id`) USING BTREE,
  FULLTEXT INDEX `ft_player_search`(`player_name`),
  CONSTRAINT `fk_player_club_id` FOREIGN KEY (`club_id`) REFERENCES `club` (`club_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_player_last_modified_by_admin` FOREIGN KEY (`player_last_modified_by_admin_id`) REFERENCES `admin` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 217 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of player
-- ----------------------------
INSERT INTO `player` VALUES (1, 3, 'Kamil Klimas', 'Ukraina', '2005-01-28', 'Bramkarz', 100.00, 178, 'right', NULL);
INSERT INTO `player` VALUES (2, 4, 'Erling Haaland', 'Norwegia', '2000-07-21', 'Napastnik', 180000000.00, 195, 'left', NULL);
INSERT INTO `player` VALUES (3, 2, 'Cristiano Ronaldo', 'Portugalia', '1985-02-05', 'Napastnik', 5000000.00, 187, 'both', NULL);
INSERT INTO `player` VALUES (4, 1, 'Bartosz Kapustka', 'Polska', '1996-12-23', 'Pomocnik', 1500000.00, 180, 'right', NULL);
INSERT INTO `player` VALUES (7, NULL, 'Zbigniew Boniek', 'Polska', '1956-03-03', 'Napastnik', 0.00, 181, 'right', NULL);
INSERT INTO `player` VALUES (101, 10, 'Erling Haaland', 'Norwegia', '2000-07-21', 'Napastnik', 180000000.00, 195, 'left', NULL);
INSERT INTO `player` VALUES (102, 10, 'Kevin De Bruyne', 'Belgia', '1991-06-28', 'Pomocnik', 60000000.00, 181, 'right', NULL);
INSERT INTO `player` VALUES (103, 10, 'Rodri', 'Hiszpania', '1996-06-22', 'Pomocnik', 110000000.00, 190, 'right', NULL);
INSERT INTO `player` VALUES (104, 11, 'Bukayo Saka', 'Anglia', '2001-09-05', 'Napastnik', 120000000.00, 178, 'left', NULL);
INSERT INTO `player` VALUES (105, 11, 'Declan Rice', 'Anglia', '1999-01-14', 'Pomocnik', 110000000.00, 188, 'right', NULL);
INSERT INTO `player` VALUES (106, 12, 'Mohamed Salah', 'Egipt', '1992-06-15', 'Napastnik', 65000000.00, 175, 'left', NULL);
INSERT INTO `player` VALUES (107, 12, 'Virgil van Dijk', 'Holandia', '1991-07-08', 'Obrońca', 32000000.00, 193, 'right', NULL);
INSERT INTO `player` VALUES (108, 13, 'Bruno Fernandes', 'Portugalia', '1994-09-08', 'Pomocnik', 70000000.00, 179, 'right', NULL);
INSERT INTO `player` VALUES (109, 20, 'Kylian Mbappe', 'Francja', '1998-12-20', 'Napastnik', 180000000.00, 178, 'right', NULL);
INSERT INTO `player` VALUES (110, 20, 'Jude Bellingham', 'Anglia', '2003-06-29', 'Pomocnik', 180000000.00, 186, 'right', NULL);
INSERT INTO `player` VALUES (111, 20, 'Vinicius Junior', 'Brazylia', '2000-07-12', 'Napastnik', 150000000.00, 176, 'right', NULL);
INSERT INTO `player` VALUES (112, 21, 'Robert Lewandowski', 'Polska', '1988-08-21', 'Napastnik', 15000000.00, 185, 'right', NULL);
INSERT INTO `player` VALUES (113, 21, 'Lamine Yamal', 'Hiszpania', '2007-07-13', 'Napastnik', 75000000.00, 180, 'left', NULL);
INSERT INTO `player` VALUES (114, 21, 'Pedri', 'Hiszpania', '2002-11-25', 'Pomocnik', 80000000.00, 174, 'right', NULL);
INSERT INTO `player` VALUES (115, 30, 'Harry Kane', 'Anglia', '1993-07-28', 'Napastnik', 110000000.00, 188, 'right', NULL);
INSERT INTO `player` VALUES (116, 30, 'Jamal Musiala', 'Niemcy', '2003-02-26', 'Pomocnik', 110000000.00, 184, 'right', NULL);
INSERT INTO `player` VALUES (117, 30, 'Manuel Neuer', 'Niemcy', '1986-03-27', 'Bramkarz', 5000000.00, 193, 'right', NULL);
INSERT INTO `player` VALUES (118, 31, 'Florian Wirtz', 'Niemcy', '2003-05-03', 'Pomocnik', 110000000.00, 177, 'right', NULL);
INSERT INTO `player` VALUES (119, 40, 'Lautaro Martinez', 'Argentyna', '1997-08-22', 'Napastnik', 110000000.00, 174, 'right', NULL);
INSERT INTO `player` VALUES (120, 41, 'Rafael Leao', 'Portugalia', '1999-06-10', 'Napastnik', 90000000.00, 188, 'right', NULL);
INSERT INTO `player` VALUES (121, 42, 'Dusan Vlahovic', 'Serbia', '2000-01-28', 'Napastnik', 65000000.00, 190, 'left', NULL);
INSERT INTO `player` VALUES (122, 43, 'Khvicha Kvaratskhelia', 'Gruzja', '2001-02-12', 'Pomocnik', 80000000.00, 183, 'both', NULL);
INSERT INTO `player` VALUES (123, 60, 'Ousmane Dembele', 'Francja', '1997-05-15', 'Napastnik', 60000000.00, 178, 'both', NULL);
INSERT INTO `player` VALUES (124, 60, 'Gianluigi Donnarumma', 'Włochy', '1999-02-25', 'Bramkarz', 40000000.00, 196, 'right', NULL);
INSERT INTO `player` VALUES (200, 40, 'Piotr Zieliński', 'Polska', '1994-05-20', 'Pomocnik', 25000000.00, 180, 'both', NULL);
INSERT INTO `player` VALUES (201, 21, 'Wojciech Szczęsny', 'Polska', '1990-04-18', 'Bramkarz', 6000000.00, 195, 'right', NULL);
INSERT INTO `player` VALUES (202, 11, 'Jakub Kiwior', 'Polska', '2000-02-15', 'Obrońca', 25000000.00, 189, 'left', NULL);
INSERT INTO `player` VALUES (203, 50, 'Bartosz Kapustka', 'Polska', '1996-12-23', 'Pomocnik', 1500000.00, 180, 'right', NULL);
INSERT INTO `player` VALUES (204, 50, 'Paweł Wszołek', 'Polska', '1992-04-30', 'Pomocnik', 1200000.00, 186, 'right', NULL);
INSERT INTO `player` VALUES (205, 50, 'Rafał Augustyniak', 'Polska', '1993-10-14', 'Obrońca', 800000.00, 185, 'right', NULL);
INSERT INTO `player` VALUES (206, 51, 'Mikael Ishak', 'Szwecja', '1993-03-31', 'Napastnik', 2500000.00, 184, 'right', NULL);
INSERT INTO `player` VALUES (207, 51, 'Ali Gholizadeh', 'Iran', '1996-03-10', 'Pomocnik', 1500000.00, 176, 'left', NULL);
INSERT INTO `player` VALUES (208, 51, 'Bartosz Salamon', 'Polska', '1991-05-01', 'Obrońca', 500000.00, 194, 'right', NULL);
INSERT INTO `player` VALUES (209, 52, 'Ivi Lopez', 'Hiszpania', '1994-06-29', 'Napastnik', 2000000.00, 174, 'right', NULL);
INSERT INTO `player` VALUES (210, 52, 'Fran Tudor', 'Chorwacja', '1995-09-27', 'Obrońca', 3000000.00, 173, 'right', NULL);
INSERT INTO `player` VALUES (211, 53, 'Kamil Grosicki', 'Polska', '1988-06-08', 'Pomocnik', 500000.00, 180, 'right', NULL);
INSERT INTO `player` VALUES (212, 53, 'Efthymios Koulouris', 'Grecja', '1996-03-06', 'Napastnik', 1500000.00, 186, 'right', NULL);
INSERT INTO `player` VALUES (213, 54, 'Lukas Podolski', 'Niemcy', '1985-06-04', 'Napastnik', 200000.00, 182, 'left', NULL);
INSERT INTO `player` VALUES (214, 42, 'Arkadiusz Milik', 'Polska', '1994-02-28', 'Napastnik', 6000000.00, 186, 'left', NULL);
INSERT INTO `player` VALUES (215, 30, 'Thomas Muller', 'Niemcy', '1989-09-13', 'Napastnik', 8000000.00, 185, 'right', NULL);
INSERT INTO `player` VALUES (216, 20, 'Luka Modric', 'Chorwacja', '1985-09-09', 'Pomocnik', 6000000.00, 172, 'both', NULL);

-- ----------------------------
-- Table structure for player_contract
-- ----------------------------
DROP TABLE IF EXISTS `player_contract`;
CREATE TABLE `player_contract`  (
  `contract_id` int(32) NOT NULL AUTO_INCREMENT,
  `player_id` int(32) NOT NULL,
  `PC_club_id` int(32) NOT NULL,
  `PC_s_date` date NULL DEFAULT NULL,
  `PC_e_date` date NULL DEFAULT NULL,
  `PC_salary` decimal(12, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`contract_id`) USING BTREE,
  INDEX `fk_contract_club_id`(`PC_club_id`) USING BTREE,
  INDEX `fk_player_contract_player_id`(`player_id`) USING BTREE,
  CONSTRAINT `fk_contract_club_id` FOREIGN KEY (`PC_club_id`) REFERENCES `club` (`club_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_player_contract_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of player_contract
-- ----------------------------
INSERT INTO `player_contract` VALUES (1, 1, 3, '2023-01-01', '2026-06-30', 1200.00);
INSERT INTO `player_contract` VALUES (2, 2, 4, '2022-07-01', '2027-06-30', 15000000.00);
INSERT INTO `player_contract` VALUES (3, 3, 5, '2009-07-01', '2018-06-30', 10000000.00);
INSERT INTO `player_contract` VALUES (4, 4, 1, '2020-09-01', '2026-06-30', 2000000.00);
INSERT INTO `player_contract` VALUES (5, 1, 3, '2024-07-01', '2028-06-30', 15.00);
INSERT INTO `player_contract` VALUES (6, 2, 4, '2024-07-01', '2028-06-30', 27000000.00);
INSERT INTO `player_contract` VALUES (7, 3, 2, '2024-07-01', '2028-06-30', 750000.00);
INSERT INTO `player_contract` VALUES (8, 4, 1, '2024-07-01', '2028-06-30', 225000.00);
INSERT INTO `player_contract` VALUES (9, 7, 0, '2024-07-01', '2028-06-30', 0.00);
INSERT INTO `player_contract` VALUES (10, 101, 10, '2024-07-01', '2028-06-30', 27000000.00);
INSERT INTO `player_contract` VALUES (11, 102, 10, '2024-07-01', '2028-06-30', 9000000.00);
INSERT INTO `player_contract` VALUES (12, 103, 10, '2024-07-01', '2028-06-30', 16500000.00);
INSERT INTO `player_contract` VALUES (13, 104, 11, '2024-07-01', '2028-06-30', 18000000.00);
INSERT INTO `player_contract` VALUES (14, 105, 11, '2024-07-01', '2028-06-30', 16500000.00);
INSERT INTO `player_contract` VALUES (15, 106, 12, '2024-07-01', '2028-06-30', 9750000.00);
INSERT INTO `player_contract` VALUES (16, 107, 12, '2024-07-01', '2028-06-30', 4800000.00);
INSERT INTO `player_contract` VALUES (17, 108, 13, '2024-07-01', '2028-06-30', 10500000.00);
INSERT INTO `player_contract` VALUES (18, 109, 20, '2024-07-01', '2028-06-30', 27000000.00);
INSERT INTO `player_contract` VALUES (19, 110, 20, '2024-07-01', '2028-06-30', 27000000.00);
INSERT INTO `player_contract` VALUES (20, 111, 20, '2024-07-01', '2028-06-30', 22500000.00);
INSERT INTO `player_contract` VALUES (21, 112, 21, '2024-07-01', '2028-06-30', 2250000.00);
INSERT INTO `player_contract` VALUES (22, 113, 21, '2024-07-01', '2028-06-30', 11250000.00);
INSERT INTO `player_contract` VALUES (23, 114, 21, '2024-07-01', '2028-06-30', 12000000.00);
INSERT INTO `player_contract` VALUES (24, 115, 30, '2024-07-01', '2028-06-30', 16500000.00);
INSERT INTO `player_contract` VALUES (25, 116, 30, '2024-07-01', '2028-06-30', 16500000.00);
INSERT INTO `player_contract` VALUES (26, 117, 30, '2024-07-01', '2028-06-30', 750000.00);
INSERT INTO `player_contract` VALUES (27, 118, 31, '2024-07-01', '2028-06-30', 16500000.00);
INSERT INTO `player_contract` VALUES (28, 119, 40, '2024-07-01', '2028-06-30', 16500000.00);
INSERT INTO `player_contract` VALUES (29, 120, 41, '2024-07-01', '2028-06-30', 13500000.00);
INSERT INTO `player_contract` VALUES (30, 121, 42, '2024-07-01', '2028-06-30', 9750000.00);
INSERT INTO `player_contract` VALUES (31, 122, 43, '2024-07-01', '2028-06-30', 12000000.00);
INSERT INTO `player_contract` VALUES (32, 123, 60, '2024-07-01', '2028-06-30', 9000000.00);
INSERT INTO `player_contract` VALUES (33, 124, 60, '2024-07-01', '2028-06-30', 6000000.00);
INSERT INTO `player_contract` VALUES (34, 200, 40, '2024-07-01', '2028-06-30', 3750000.00);
INSERT INTO `player_contract` VALUES (35, 201, 21, '2024-07-01', '2028-06-30', 900000.00);
INSERT INTO `player_contract` VALUES (36, 202, 11, '2024-07-01', '2028-06-30', 3750000.00);
INSERT INTO `player_contract` VALUES (37, 203, 50, '2024-07-01', '2028-06-30', 225000.00);
INSERT INTO `player_contract` VALUES (38, 204, 50, '2024-07-01', '2028-06-30', 180000.00);
INSERT INTO `player_contract` VALUES (39, 205, 50, '2024-07-01', '2028-06-30', 120000.00);
INSERT INTO `player_contract` VALUES (40, 206, 51, '2024-07-01', '2028-06-30', 375000.00);
INSERT INTO `player_contract` VALUES (41, 207, 51, '2024-07-01', '2028-06-30', 225000.00);
INSERT INTO `player_contract` VALUES (42, 208, 51, '2024-07-01', '2028-06-30', 75000.00);
INSERT INTO `player_contract` VALUES (43, 209, 52, '2024-07-01', '2028-06-30', 300000.00);
INSERT INTO `player_contract` VALUES (44, 210, 52, '2024-07-01', '2028-06-30', 450000.00);
INSERT INTO `player_contract` VALUES (45, 211, 53, '2024-07-01', '2028-06-30', 75000.00);
INSERT INTO `player_contract` VALUES (46, 212, 53, '2024-07-01', '2028-06-30', 225000.00);
INSERT INTO `player_contract` VALUES (47, 213, 54, '2024-07-01', '2028-06-30', 30000.00);
INSERT INTO `player_contract` VALUES (48, 214, 42, '2024-07-01', '2028-06-30', 900000.00);
INSERT INTO `player_contract` VALUES (49, 215, 30, '2024-07-01', '2028-06-30', 1200000.00);
INSERT INTO `player_contract` VALUES (50, 216, 20, '2024-07-01', '2028-06-30', 900000.00);

-- ----------------------------
-- Table structure for player_match_stats
-- ----------------------------
DROP TABLE IF EXISTS `player_match_stats`;
CREATE TABLE `player_match_stats`  (
  `match_id` int(32) NOT NULL,
  `player_id` int(32) NOT NULL,
  `PMS_minutes_played` int(32) UNSIGNED NULL DEFAULT NULL,
  `PMS_goals` int(32) UNSIGNED NULL DEFAULT NULL,
  `PMS_assists` int(32) UNSIGNED NULL DEFAULT NULL,
  `PMS_yellow_cards` int(32) UNSIGNED NULL DEFAULT NULL,
  `PMS_red_cards` int(32) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`match_id`, `player_id`) USING BTREE,
  INDEX `fk_pms_player_id`(`player_id`) USING BTREE,
  CONSTRAINT `fk_pms_match_id` FOREIGN KEY (`match_id`) REFERENCES `match` (`match_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pms_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of player_match_stats
-- ----------------------------
INSERT INTO `player_match_stats` VALUES (1, 4, 90, 1, 1, 0, 0);
INSERT INTO `player_match_stats` VALUES (10, 101, 90, 2, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (10, 102, 85, 0, 2, 0, 0);
INSERT INTO `player_match_stats` VALUES (10, 104, 90, 1, 0, 1, 0);
INSERT INTO `player_match_stats` VALUES (10, 105, 90, 1, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (11, 109, 90, 0, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (11, 110, 90, 0, 0, 1, 0);
INSERT INTO `player_match_stats` VALUES (11, 112, 90, 2, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (11, 113, 70, 1, 1, 0, 0);
INSERT INTO `player_match_stats` VALUES (12, 115, 90, 3, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (12, 116, 88, 0, 2, 0, 0);
INSERT INTO `player_match_stats` VALUES (13, 203, 90, 1, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (13, 206, 90, 0, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (20, 106, 90, 1, 1, 0, 0);
INSERT INTO `player_match_stats` VALUES (20, 107, 90, 0, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (20, 111, 90, 0, 0, 1, 0);
INSERT INTO `player_match_stats` VALUES (20, 112, 60, 0, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (21, 203, 88, 1, 0, 1, 0);
INSERT INTO `player_match_stats` VALUES (21, 205, 90, 0, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (21, 209, 90, 1, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (21, 210, 90, 0, 1, 0, 0);
INSERT INTO `player_match_stats` VALUES (22, 119, 90, 1, 1, 0, 0);
INSERT INTO `player_match_stats` VALUES (22, 121, 90, 2, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (22, 200, 20, 1, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (23, 115, 90, 2, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (23, 116, 75, 0, 1, 0, 0);
INSERT INTO `player_match_stats` VALUES (23, 117, 90, 0, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (23, 118, 90, 1, 1, 0, 0);
INSERT INTO `player_match_stats` VALUES (24, 110, 90, 0, 0, 0, 0);
INSERT INTO `player_match_stats` VALUES (24, 111, 90, 0, 1, 1, 0);
INSERT INTO `player_match_stats` VALUES (24, 204, 90, 0, 0, 0, 0);

-- ----------------------------
-- Table structure for transfer
-- ----------------------------
DROP TABLE IF EXISTS `transfer`;
CREATE TABLE `transfer`  (
  `transfer_id` int(32) NOT NULL AUTO_INCREMENT COMMENT 'id transferu',
  `player_id` int(32) NOT NULL COMMENT 'id zawodnika dotyczącego kontraktu',
  `from_club_id` int(32) NULL DEFAULT NULL COMMENT 'id klubu sprzedającego',
  `to_club_id` int(32) NULL DEFAULT NULL COMMENT 'id klubu nabywającego',
  `transer_t_date` date NULL DEFAULT NULL COMMENT 'data transferu',
  `transer_t_fee` decimal(12, 2) NULL DEFAULT NULL COMMENT 'kwota transferu',
  `transfer_entered_by_admin_id` int(11) NULL DEFAULT NULL COMMENT 'Id admina, który wprowadził i zatwierdził transfer',
  PRIMARY KEY (`transfer_id`) USING BTREE,
  INDEX `fk_transfer_player_id`(`player_id`) USING BTREE,
  INDEX `fk_transfer_from_club_id`(`from_club_id`) USING BTREE,
  INDEX `fk_transfer_to_club_id`(`to_club_id`) USING BTREE,
  INDEX `fk_transfer_entered_by_admin`(`transfer_entered_by_admin_id`) USING BTREE,
  CONSTRAINT `fk_transfer_entered_by_admin` FOREIGN KEY (`transfer_entered_by_admin_id`) REFERENCES `admin` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_transfer_from_club_id` FOREIGN KEY (`from_club_id`) REFERENCES `club` (`club_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_transfer_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_transfer_to_club_id` FOREIGN KEY (`to_club_id`) REFERENCES `club` (`club_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic WITH SYSTEM VERSIONING;

-- ----------------------------
-- Records of transfer
-- ----------------------------
INSERT INTO `transfer` VALUES (2, 4, 2, 1, '2024-07-01', 500000.00, 1);
INSERT INTO `transfer` VALUES (3, 1, 1, 2, '2026-01-14', 1000000.00, NULL);
INSERT INTO `transfer` VALUES (4, 1, 2, 3, '2026-01-14', 1000000.00, NULL);
INSERT INTO `transfer` VALUES (5, 1, 2, 3, '2026-01-14', 1000000.00, NULL);
INSERT INTO `transfer` VALUES (8, 1, 1, 2, '2026-01-17', 1000000.00, NULL);
INSERT INTO `transfer` VALUES (10, 101, 32, 10, '2022-07-01', 60000000.00, NULL);
INSERT INTO `transfer` VALUES (11, 109, 60, 20, '2024-07-01', 0.00, NULL);
INSERT INTO `transfer` VALUES (12, 110, 32, 20, '2023-07-01', 103000000.00, NULL);
INSERT INTO `transfer` VALUES (13, 112, 30, 21, '2022-07-19', 45000000.00, NULL);
INSERT INTO `transfer` VALUES (14, 115, 12, 30, '2023-08-12', 95000000.00, NULL);
INSERT INTO `transfer` VALUES (15, 105, 12, 11, '2023-07-15', 116000000.00, NULL);
INSERT INTO `transfer` VALUES (16, 203, 11, 50, '2020-08-01', 0.00, NULL);
INSERT INTO `transfer` VALUES (17, 200, 43, 40, '2024-07-01', 0.00, NULL);
INSERT INTO `transfer` VALUES (18, 201, 42, 21, '2024-10-02', 0.00, NULL);

-- ----------------------------
-- Table structure for trophy
-- ----------------------------
DROP TABLE IF EXISTS `trophy`;
CREATE TABLE `trophy`  (
  `trophy_id` int(32) NOT NULL AUTO_INCREMENT,
  `trophy_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `trophy_type` enum('league','cup','supercup','friendly','Tymbark') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `trophy_established_year` int(32) NULL DEFAULT NULL,
  PRIMARY KEY (`trophy_id`) USING BTREE,
  UNIQUE INDEX `idx_trophy_name`(`trophy_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of trophy
-- ----------------------------
INSERT INTO `trophy` VALUES (1, 'Mistrzostwo Polski', 'league', 1921);
INSERT INTO `trophy` VALUES (2, 'Puchar Polski', 'cup', 1925);
INSERT INTO `trophy` VALUES (3, 'Liga Mistrzów', 'cup', 1955);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_is_online` tinyint(1) NULL DEFAULT NULL,
  `user_created_at` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `user_last_log` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `idx_user_name`(`user_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin_main', 'haslo123', 1, '2026-01-14 13:27:04', NULL);

-- ----------------------------
-- Table structure for user_favourite_club
-- ----------------------------
DROP TABLE IF EXISTS `user_favourite_club`;
CREATE TABLE `user_favourite_club`  (
  `user_id` int(11) NOT NULL,
  `club_id` int(11) NOT NULL,
  `UFC_added_date` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `club_id`) USING BTREE,
  INDEX `fk_fav_club_club_id`(`club_id`) USING BTREE,
  CONSTRAINT `fk_fav_club_club_id` FOREIGN KEY (`club_id`) REFERENCES `club` (`club_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fav_club_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_favourite_club
-- ----------------------------
INSERT INTO `user_favourite_club` VALUES (1, 1, '2026-01-14 13:34:03');

-- ----------------------------
-- Table structure for user_favourite_player
-- ----------------------------
DROP TABLE IF EXISTS `user_favourite_player`;
CREATE TABLE `user_favourite_player`  (
  `user_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `UFP_added_date` datetime NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `player_id`) USING BTREE,
  INDEX `fk_fav_player_player_id`(`player_id`) USING BTREE,
  CONSTRAINT `fk_fav_player_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fav_player_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_favourite_player
-- ----------------------------
INSERT INTO `user_favourite_player` VALUES (1, 1, '2026-01-14 13:34:04');

-- ----------------------------
-- Table structure for user_followed_league
-- ----------------------------
DROP TABLE IF EXISTS `user_followed_league`;
CREATE TABLE `user_followed_league`  (
  `user_id` int(11) NOT NULL,
  `league_id` int(11) NOT NULL,
  `UFL_followed_since` datetime NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `league_id`) USING BTREE,
  INDEX `fk_followed_league_league_id`(`league_id`) USING BTREE,
  CONSTRAINT `fk_followed_league_league_id` FOREIGN KEY (`league_id`) REFERENCES `league` (`league_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_followed_league_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_followed_league
-- ----------------------------
INSERT INTO `user_followed_league` VALUES (1, 1, '2026-01-14 13:34:03');

-- ----------------------------
-- View structure for admin_check
-- ----------------------------
DROP VIEW IF EXISTS `admin_check`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `admin_check` AS select `u`.`user_name` AS `user_name`,`u`.`user_id` AS `user_id`,(select count(0) from `admin`) AS `count` from (`admin` `a` join `user` `u` on(`a`.`user_id` = `u`.`user_id`));

-- ----------------------------
-- View structure for tabele_z_partycjonowaniem
-- ----------------------------
DROP VIEW IF EXISTS `tabele_z_partycjonowaniem`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `tabele_z_partycjonowaniem` AS select `information_schema`.`PARTITIONS`.`TABLE_NAME` AS `table_name`,`information_schema`.`PARTITIONS`.`PARTITION_METHOD` AS `partition_method`,count(0) AS `partitions_count` from `information_schema`.`PARTITIONS` where `information_schema`.`PARTITIONS`.`TABLE_SCHEMA` = 'transfermarkt' and `information_schema`.`PARTITIONS`.`PARTITION_NAME` is not null group by `information_schema`.`PARTITIONS`.`TABLE_NAME`,`information_schema`.`PARTITIONS`.`PARTITION_METHOD`;

-- ----------------------------
-- View structure for tabele_z_wersjonowaniem
-- ----------------------------
DROP VIEW IF EXISTS `tabele_z_wersjonowaniem`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `tabele_z_wersjonowaniem` AS select `information_schema`.`TABLES`.`TABLE_NAME` AS `Tabela`,`information_schema`.`TABLES`.`TABLE_TYPE` AS `Typ`,`information_schema`.`TABLES`.`ENGINE` AS `Silnik` from `information_schema`.`TABLES` where `information_schema`.`TABLES`.`TABLE_SCHEMA` = database() and `information_schema`.`TABLES`.`TABLE_TYPE` = 'SYSTEM VERSIONED';

-- ----------------------------
-- Function structure for calculate_goals_per_90
-- ----------------------------
DROP FUNCTION IF EXISTS `calculate_goals_per_90`;
delimiter ;;
CREATE FUNCTION `calculate_goals_per_90`(p_player_id INT)
 RETURNS decimal(10,2)
  DETERMINISTIC
BEGIN
    DECLARE v_total_goals INT;
    DECLARE v_total_minutes INT;
    DECLARE v_result DECIMAL(10, 2);
    DECLARE EXIT HANDLER FOR SQLSTATE '22012'
    BEGIN
        RETURN 0.00;
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RETURN -1.00; 
    END;
    SELECT SUM(PMS_goals), SUM(PMS_minutes_played)
    INTO v_total_goals, v_total_minutes
    FROM player_match_stats
    WHERE player_id = p_player_id;

    IF v_total_minutes IS NULL OR v_total_minutes = 0 THEN
        RETURN 0.00;
    ELSE
        SET v_result = (v_total_goals / v_total_minutes) * 90;
        RETURN v_result;
    END IF;

END

/* wywołania:
Napastnicy:
SELECT 
    player_name, 
    calculate_goals_per_90(player_id) AS Gole_Na_90_Minut
FROM player 
WHERE player_id IN (101, 115);

Bramkarz/Obronca:
SELECT 
    player_name, 
    calculate_goals_per_90(player_id) AS Gole_Na_90_Minut
FROM player 
WHERE player_id IN (107, 117);


Test ID którego nie ma w tabeli:
SELECT calculate_goals_per_90(99999) AS Wynik_Dla_Ducha;

Topka:
SELECT 
    p.player_name,
    c.Club_name,
    calculate_goals_per_90(p.player_id) AS Skutecznosc
FROM player p
JOIN club c ON p.club_id = c.club_id
-- Opcjonalnie: Pokaż tylko tych, co grali
WHERE p.player_id IN (SELECT player_id FROM player_match_stats)
ORDER BY Skutecznosc DESC
LIMIT 10;

test handlera:
INSERT INTO player_match_stats (match_id, player_id, PMS_minutes_played, PMS_goals) 
VALUES (10, 204, 0, 0);

SELECT calculate_goals_per_90(204);

*/
;;
delimiter ;

-- ----------------------------
-- Function structure for calculate_manager_fee
-- ----------------------------
DROP FUNCTION IF EXISTS `calculate_manager_fee`;
delimiter ;;
CREATE FUNCTION `calculate_manager_fee`(fee DECIMAL(12,2))
 RETURNS decimal(12,2)
  DETERMINISTIC
BEGIN
  DECLARE commission DECIMAL(12,2);
  
  IF fee IS NULL OR fee <= 0 THEN
    RETURN 0.00;
  END IF;
  
  IF fee < 1000000 THEN
    SET commission = fee * 0.10;
  ELSE
    SET commission = fee * 0.06;
  END IF;
  
  RETURN commission;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for TransferTax
-- ----------------------------
DROP FUNCTION IF EXISTS `TransferTax`;
delimiter ;;
CREATE FUNCTION `TransferTax`(a DECIMAL(12,2))
 RETURNS decimal(12,2)
  DETERMINISTIC
BEGIN
    DECLARE wynik DECIMAL(12,2);
    BEGIN
        -- Handler
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET wynik = -1.00;
        END;

        IF a < 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ujemna kwota';
        END IF;

        IF a < 1000000 THEN
            SET wynik = a * 0.10;
        ELSE
            SET wynik = a * 0.06;
        END IF;
    END; 
    RETURN wynik;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for update_player_value
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_player_value`;
delimiter ;;
CREATE PROCEDURE `update_player_value`(in p_player_id INT,
  in p_new_value DECIMAL(10, 2))
BEGIN
  declare v_exists INT;
  
  select count(*) into v_exists from player
  where player_id = p_player_id;
  
  if v_exists > 0 THEN
    update player
    set player_market_value = p_new_value
    Where player_id = p_player_id;
  end if;
END
;;
delimiter ;

-- ----------------------------
-- Event structure for admin_check
-- ----------------------------
DROP EVENT IF EXISTS `admin_check`;
delimiter ;;
CREATE EVENT `admin_check`
ON SCHEDULE
EVERY '1' DAY STARTS '2026-01-13 12:50:44'
DO create or replace view admin_check AS
  select u.user_name, u.user_id, (select count(*) from admin) as count
  FROM admin a
  JOIN `user` u ON a.user_id = u.user_id
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table player
-- ----------------------------
DROP TRIGGER IF EXISTS `OLD_PLAYER_INSERT`;
delimiter ;;
CREATE TRIGGER `OLD_PLAYER_INSERT` AFTER INSERT ON `player` FOR EACH ROW begin
  IF TIMESTAMPDIFF(YEAR, NEW.player_birth_date, NOW()) >= 40 THEN
    INSERT INTO oldboys (
          oldboy_id, 
          oldboy_club_id, 
          oldboy_name, 
          oldboy_nationality, 
          oldboy_birth_date, 
          oldboy_position, 
          oldboy_market_value, 
          oldboy_height, 
          oldboy_foot, 
          oldboy_last_modified_by_admin_id
      )
      VALUES (
          NEW.player_id, 
          NEW.club_id, 
          NEW.player_name, 
          NEW.player_nationality, 
          NEW.player_birth_date, 
          NEW.player_position, 
          NEW.player_market_value, 
          NEW.player_height, 
          NEW.player_foot, 
          NEW.player_last_modified_by_admin_id
      );
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table player
-- ----------------------------
DROP TRIGGER IF EXISTS `OLD_PLAYER_UPDATE`;
delimiter ;;
CREATE TRIGGER `OLD_PLAYER_UPDATE` AFTER UPDATE ON `player` FOR EACH ROW begin
  IF TIMESTAMPDIFF(YEAR, NEW.player_birth_date, NOW()) >= 40 THEN
    UPDATE oldboys 
    SET 
        oldboy_club_id = NEW.club_id,
        oldboy_name = NEW.player_name,
        oldboy_nationality = NEW.player_nationality,
        oldboy_birth_date = NEW.player_birth_date,
        oldboy_position = NEW.player_position,
        oldboy_market_value = NEW.player_market_value,
        oldboy_height = NEW.player_height,
        oldboy_foot = NEW.player_foot,
        oldboy_last_modified_by_admin_id = NEW.player_last_modified_by_admin_id
    WHERE oldboy_id = NEW.player_id;
    
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
