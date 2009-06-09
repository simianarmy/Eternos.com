-- MySQL dump 10.11
--
-- Host: localhost    Database: eternos_devel
-- ------------------------------------------------------
-- Server version	5.0.51b

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `full_domain` varchar(255) default NULL,
  `subscription_discount_id` int(11) default NULL,
  `state` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `subscription_discount_id` (`subscription_discount_id`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,NULL,'2009-02-05 18:05:30','2009-02-05 18:05:30',NULL,NULL,NULL),(2,NULL,'2009-02-05 18:13:20','2009-02-05 18:13:20',NULL,NULL,NULL),(3,NULL,'2009-02-05 22:38:12','2009-02-05 22:38:12',NULL,NULL,NULL),(4,NULL,'2009-02-06 00:48:29','2009-02-06 00:48:29',NULL,NULL,'login'),(5,NULL,'2009-02-06 01:08:15','2009-02-06 01:08:15',NULL,NULL,'login'),(6,NULL,'2009-02-06 01:09:00','2009-02-06 01:09:00',NULL,NULL,'login'),(7,NULL,'2009-02-06 01:09:34','2009-02-06 01:09:34',NULL,NULL,'login'),(8,NULL,'2009-02-06 01:10:02','2009-02-06 01:10:02',NULL,NULL,'login'),(9,NULL,'2009-02-06 01:10:44','2009-02-06 01:10:44',NULL,NULL,'login'),(10,NULL,'2009-02-06 01:11:27','2009-02-06 01:11:27',NULL,NULL,'login'),(11,NULL,'2009-02-06 01:14:10','2009-02-06 01:14:10',NULL,NULL,'login'),(12,NULL,'2009-02-06 01:18:39','2009-02-06 01:18:39',NULL,NULL,'login'),(13,NULL,'2009-02-06 01:21:08','2009-02-06 01:21:08',NULL,NULL,'login'),(14,NULL,'2009-02-06 01:21:43','2009-02-06 01:21:43',NULL,NULL,'login'),(15,NULL,'2009-02-06 01:22:37','2009-02-06 01:22:37',NULL,NULL,'login'),(16,NULL,'2009-02-06 01:23:28','2009-02-06 01:23:28',NULL,NULL,'login'),(17,NULL,'2009-02-06 01:24:15','2009-02-06 01:24:15',NULL,NULL,'login'),(18,NULL,'2009-02-06 01:26:52','2009-02-06 01:26:52',NULL,NULL,'login'),(19,NULL,'2009-02-06 01:28:56','2009-02-06 01:28:56',NULL,NULL,'login'),(20,NULL,'2009-02-06 01:29:31','2009-02-06 01:29:31',NULL,NULL,'login'),(21,NULL,'2009-02-06 01:58:05','2009-02-06 01:58:05',NULL,NULL,'login'),(22,NULL,'2009-02-06 01:59:31','2009-02-06 01:59:31',NULL,NULL,'login'),(23,NULL,'2009-02-06 02:12:41','2009-02-06 02:12:41',NULL,NULL,'login'),(24,NULL,'2009-02-06 02:14:58','2009-02-06 02:14:58',NULL,NULL,'login'),(25,NULL,'2009-02-06 02:15:32','2009-02-06 02:15:32',NULL,NULL,'login'),(26,NULL,'2009-02-06 02:17:19','2009-02-06 02:17:19',NULL,NULL,'login'),(27,NULL,'2009-02-06 02:18:33','2009-02-06 02:18:33',NULL,NULL,'login'),(28,NULL,'2009-02-06 03:52:03','2009-02-06 03:52:03',NULL,NULL,'login'),(29,NULL,'2009-02-06 03:57:49','2009-02-06 03:57:49',NULL,NULL,'login'),(30,NULL,'2009-02-06 03:58:18','2009-02-06 03:58:18',NULL,NULL,'login'),(31,NULL,'2009-02-06 03:58:34','2009-02-06 03:58:34',NULL,NULL,'login'),(32,NULL,'2009-02-06 03:59:43','2009-02-06 03:59:43',NULL,NULL,'login'),(33,NULL,'2009-02-06 23:32:22','2009-02-06 23:32:22',NULL,NULL,'login'),(34,NULL,'2009-02-06 23:33:46','2009-02-06 23:33:46',NULL,NULL,'login'),(35,NULL,'2009-02-06 23:48:00','2009-02-06 23:48:00',NULL,NULL,'login'),(36,NULL,'2009-02-06 23:48:28','2009-02-06 23:48:28',NULL,NULL,'login'),(37,NULL,'2009-02-06 23:51:35','2009-02-06 23:51:35',NULL,NULL,'login'),(38,NULL,'2009-02-07 00:19:59','2009-02-07 00:19:59',NULL,NULL,'login'),(39,NULL,'2009-02-07 01:04:52','2009-02-07 01:04:52',NULL,NULL,'login'),(40,NULL,'2009-02-07 01:18:26','2009-02-07 01:18:26',NULL,NULL,'login'),(41,NULL,'2009-02-07 01:21:51','2009-02-07 01:21:51',NULL,NULL,'login'),(42,NULL,'2009-02-07 01:29:55','2009-02-07 01:29:55',NULL,NULL,'login'),(43,NULL,'2009-02-07 01:30:20','2009-02-07 01:30:20',NULL,NULL,'login'),(44,NULL,'2009-02-07 01:40:50','2009-02-07 01:40:50',NULL,NULL,'login'),(45,NULL,'2009-02-07 04:54:18','2009-02-07 04:54:18',NULL,NULL,'login'),(46,NULL,'2009-02-07 18:07:28','2009-02-07 18:07:28',NULL,NULL,'login'),(47,NULL,'2009-02-07 18:14:28','2009-02-07 18:14:28',NULL,NULL,'login'),(48,NULL,'2009-02-07 18:53:08','2009-02-07 18:53:08',NULL,NULL,'login'),(49,NULL,'2009-02-07 19:28:39','2009-02-07 19:28:39',NULL,NULL,'login'),(50,NULL,'2009-02-07 19:34:21','2009-02-07 19:34:21',NULL,NULL,'login'),(51,NULL,'2009-02-07 19:38:00','2009-02-07 19:38:00',NULL,NULL,'login'),(52,NULL,'2009-02-07 19:42:47','2009-02-07 19:42:47',NULL,NULL,'login'),(53,NULL,'2009-02-07 19:46:04','2009-02-07 19:46:04',NULL,NULL,'login'),(54,NULL,'2009-02-07 19:46:34','2009-02-07 19:46:34',NULL,NULL,'login'),(55,NULL,'2009-02-07 19:48:36','2009-02-07 19:48:36',NULL,NULL,'login'),(56,NULL,'2009-02-07 19:53:50','2009-02-07 19:53:50',NULL,NULL,'login'),(57,NULL,'2009-02-07 19:56:15','2009-02-07 19:56:15',NULL,NULL,'login'),(58,NULL,'2009-02-07 20:00:53','2009-02-07 20:00:53',NULL,NULL,'login'),(59,NULL,'2009-02-07 20:04:54','2009-02-07 20:04:54',NULL,NULL,'login'),(60,NULL,'2009-02-07 20:05:23','2009-02-07 20:05:23',NULL,NULL,'login'),(61,NULL,'2009-02-07 20:06:41','2009-02-07 20:06:41',NULL,NULL,'login'),(62,NULL,'2009-02-07 20:07:12','2009-02-07 20:07:12',NULL,NULL,'login'),(63,NULL,'2009-02-07 20:13:07','2009-02-07 20:13:07',NULL,NULL,'login'),(64,NULL,'2009-02-07 20:15:50','2009-02-07 20:15:50',NULL,NULL,'login'),(65,NULL,'2009-02-07 20:23:02','2009-02-07 20:23:02',NULL,NULL,'login'),(66,NULL,'2009-02-07 20:23:38','2009-02-07 20:23:38',NULL,NULL,'login'),(67,NULL,'2009-02-09 01:06:55','2009-02-09 01:06:55',NULL,NULL,'login'),(68,NULL,'2009-02-09 01:10:21','2009-02-09 01:10:21',NULL,NULL,'login'),(69,NULL,'2009-02-09 01:16:18','2009-02-09 01:16:18',NULL,NULL,'login'),(70,NULL,'2009-02-09 01:16:59','2009-02-09 01:16:59',NULL,NULL,'login'),(71,NULL,'2009-02-09 01:19:01','2009-02-09 01:19:01',NULL,NULL,'login'),(72,NULL,'2009-02-09 01:19:24','2009-02-09 01:19:24',NULL,NULL,'login'),(73,NULL,'2009-02-09 01:19:56','2009-02-09 01:19:56',NULL,NULL,'login'),(74,NULL,'2009-02-09 01:22:41','2009-02-09 01:22:41',NULL,NULL,'login'),(75,NULL,'2009-02-09 01:23:07','2009-02-09 01:23:07',NULL,NULL,'login'),(76,NULL,'2009-02-09 01:23:32','2009-02-09 01:23:32',NULL,NULL,'login'),(77,NULL,'2009-02-09 01:25:04','2009-02-09 01:25:04',NULL,NULL,'login'),(78,NULL,'2009-02-09 01:27:10','2009-02-09 01:27:10',NULL,NULL,'login'),(79,NULL,'2009-02-09 01:29:08','2009-02-09 01:29:08',NULL,NULL,'login'),(80,NULL,'2009-02-09 01:30:56','2009-02-09 01:30:56',NULL,NULL,'login'),(81,NULL,'2009-02-09 01:31:56','2009-02-09 01:31:56',NULL,NULL,'login'),(82,NULL,'2009-02-09 01:32:39','2009-02-09 01:32:39',NULL,NULL,'login'),(83,NULL,'2009-02-09 01:33:11','2009-02-09 01:33:11',NULL,NULL,'login'),(84,NULL,'2009-02-09 01:36:58','2009-02-09 01:36:58',NULL,NULL,'login'),(85,NULL,'2009-02-09 01:37:39','2009-02-09 01:37:39',NULL,NULL,'login'),(86,NULL,'2009-02-09 01:38:27','2009-02-09 01:38:27',NULL,NULL,'login'),(87,NULL,'2009-02-09 01:38:57','2009-02-09 01:38:57',NULL,NULL,'login'),(88,NULL,'2009-02-09 23:59:45','2009-02-09 23:59:45',NULL,NULL,'login'),(89,NULL,'2009-02-10 00:09:19','2009-02-10 00:09:19',NULL,NULL,'login'),(90,NULL,'2009-03-12 18:38:08','2009-03-12 18:38:08',NULL,NULL,'login'),(91,NULL,'2009-03-12 19:32:17','2009-03-26 02:40:20',NULL,NULL,'joined'),(96,NULL,'2009-05-19 14:16:33','2009-05-19 14:16:37',NULL,NULL,'joined'),(97,NULL,'2009-05-19 15:05:45','2009-05-19 15:05:48',NULL,NULL,'joined');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `address_books`
--

DROP TABLE IF EXISTS `address_books`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `address_books` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `website` varchar(255) default NULL,
  `icq` varchar(255) default NULL,
  `skype` varchar(255) default NULL,
  `msn` varchar(255) default NULL,
  `aol` varchar(255) default NULL,
  `ssn_b` blob,
  `birthdate` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `middle_name` varchar(255) default NULL,
  `name_suffix` varchar(255) default NULL,
  `gender` varchar(255) default NULL,
  `timezone` varchar(255) default NULL,
  `photo_file_name` varchar(255) default NULL,
  `photo_content_type` varchar(255) default NULL,
  `photo_file_size` int(11) default NULL,
  `photo_updated_at` datetime default NULL,
  `name_title` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `address_books`
--

LOCK TABLES `address_books` WRITE;
/*!40000 ALTER TABLE `address_books` DISABLE KEYS */;
INSERT INTO `address_books` VALUES (1,85,'shit','bird','','','','','',NULL,'2009-02-18','2009-02-18 23:00:24','2009-02-18 23:00:24','','',NULL,NULL,NULL,NULL,NULL,NULL,''),(5,88,'dr','no','','','','','',NULL,'2009-03-25','2009-03-25 19:24:25','2009-03-25 19:24:25','','',NULL,NULL,NULL,NULL,NULL,NULL,''),(6,89,'test','man',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-05-19 14:16:33','2009-05-19 14:16:33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,90,'dr','john',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-05-19 15:03:24','2009-05-19 15:03:24',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,91,'ass','hat',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-05-19 15:05:46','2009-05-19 15:05:46',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `address_books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL auto_increment,
  `addressable_id` int(11) default NULL,
  `addressable_type` varchar(255) default NULL,
  `location_type` varchar(255) NOT NULL,
  `street_2` varchar(255) default NULL,
  `region_id` int(11) default NULL,
  `country_id` int(11) default NULL,
  `custom_region` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `street_1` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `postal_code` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,1,'AddressBook','home','',1,4,NULL,'2009-02-18 23:00:24','2009-03-08 16:20:53','fass','somewhere',''),(2,1,'AddressBook','home','',NULL,NULL,NULL,'2009-02-18 23:02:43','2009-02-18 23:02:43','fass','',''),(3,1,'AddressBook','home','',NULL,NULL,NULL,'2009-02-18 23:03:07','2009-02-18 23:03:07','fass','',''),(4,1,'AddressBook','home','',NULL,NULL,NULL,'2009-02-18 23:06:56','2009-02-18 23:06:56','fass','',''),(5,5,'AddressBook','home','',NULL,NULL,NULL,'2009-03-25 19:24:25','2009-03-25 19:24:25','','',''),(6,5,'GuestInvitation','home','',NULL,16,NULL,'2009-04-16 06:11:27','2009-04-16 06:11:27','somewhere in hell','fucktown',''),(7,6,'GuestInvitation','home','',NULL,16,NULL,'2009-04-16 20:28:31','2009-04-20 23:46:21','ass clown town','zzzz','11112'),(8,9,'GuestInvitation','home','',4124,NULL,NULL,'2009-04-16 23:30:30','2009-04-16 23:30:30','111 asdflkadf','asdfasdf',''),(9,3,'GuestInvitation','home','',56,NULL,NULL,'2009-04-20 04:53:30','2009-04-20 04:53:30','asstow','shitsville','');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `albums`
--

DROP TABLE IF EXISTS `albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `albums` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `albums`
--

LOCK TABLES `albums` WRITE;
/*!40000 ALTER TABLE `albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `av_attachments`
--

DROP TABLE IF EXISTS `av_attachments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `av_attachments` (
  `id` int(11) NOT NULL auto_increment,
  `av_attachable_id` int(11) default NULL,
  `av_attachable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `recording_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `av_attachments`
--

LOCK TABLES `av_attachments` WRITE;
/*!40000 ALTER TABLE `av_attachments` DISABLE KEYS */;
INSERT INTO `av_attachments` VALUES (1,NULL,'Story',NULL,'2009-05-13 15:38:15',NULL),(2,NULL,'Story','2009-05-13 15:38:15','2009-05-13 15:39:20',65),(3,1,'Story','2009-05-13 15:39:20','2009-05-13 15:39:20',39);
/*!40000 ALTER TABLE `av_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `global` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (13,'drugs','2009-02-12 19:18:36','2009-02-12 19:18:36',0),(24,'Birth','2009-02-18 17:49:39','2009-02-18 17:49:39',1),(25,'Marriage','2009-02-18 17:49:39','2009-02-18 17:49:39',1),(26,'Children','2009-02-18 17:49:39','2009-02-18 17:49:39',1),(27,'Education','2009-02-18 17:49:39','2009-02-18 17:49:39',1),(28,'Career','2009-02-18 17:49:39','2009-02-18 17:49:39',1),(29,'fooobar','2009-02-23 17:58:17','2009-02-23 17:58:17',0),(30,'spackled','2009-02-23 20:55:18','2009-02-23 20:55:18',0),(31,'spackled','2009-02-23 20:59:01','2009-02-23 20:59:01',0),(32,'spackled','2009-02-23 21:13:53','2009-02-23 21:13:53',0),(33,'spackled','2009-02-23 21:14:36','2009-02-23 21:14:36',0),(34,'spackled','2009-02-23 21:15:24','2009-02-23 21:15:24',0),(35,'spackled','2009-02-23 21:15:53','2009-02-23 21:15:53',0),(36,'one or more?','2009-02-28 04:50:56','2009-02-28 04:50:56',0),(37,'test','2009-03-10 06:13:35','2009-03-10 06:13:35',0);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorizations`
--

DROP TABLE IF EXISTS `categorizations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `categorizations` (
  `id` int(11) NOT NULL auto_increment,
  `category_id` int(11) NOT NULL,
  `categorizable_id` int(11) default NULL,
  `categorizable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `categorizations`
--

LOCK TABLES `categorizations` WRITE;
/*!40000 ALTER TABLE `categorizations` DISABLE KEYS */;
INSERT INTO `categorizations` VALUES (1,8,1,'Story','2009-02-11 22:13:30','2009-02-11 22:13:30'),(2,13,2,'Story','2009-02-12 19:18:36','2009-02-12 19:18:36'),(3,29,3,'Story','2009-02-23 17:58:17','2009-02-23 17:58:17'),(4,26,4,'Story','2009-02-23 19:23:38','2009-02-23 19:23:38'),(5,30,5,'Story','2009-02-23 20:55:18','2009-02-23 20:55:18'),(6,31,6,'Story','2009-02-23 20:59:01','2009-02-23 20:59:01'),(7,32,7,'Story','2009-02-23 21:13:53','2009-02-23 21:13:53'),(8,33,8,'Story','2009-02-23 21:14:36','2009-02-23 21:14:36'),(9,34,9,'Story','2009-02-23 21:15:24','2009-02-23 21:15:24'),(10,35,10,'Story','2009-02-23 21:15:53','2009-02-23 21:15:53'),(11,33,11,'Story','2009-02-23 21:18:09','2009-02-23 21:18:09'),(12,29,12,'Story','2009-02-24 00:30:37','2009-02-24 00:30:37'),(13,27,13,'Story','2009-02-24 06:40:56','2009-02-24 06:40:56');
/*!40000 ALTER TABLE `categorizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circles`
--

DROP TABLE IF EXISTS `circles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `circles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `circles`
--

LOCK TABLES `circles` WRITE;
/*!40000 ALTER TABLE `circles` DISABLE KEYS */;
INSERT INTO `circles` VALUES (9,'Spouse','2009-02-18 17:49:40','2009-02-18 17:49:40',0),(10,'Child','2009-02-18 17:49:40','2009-02-18 17:49:40',0),(11,'Parent','2009-02-18 17:49:40','2009-02-18 17:49:40',0),(12,'Friend','2009-02-18 17:49:40','2009-02-18 17:49:40',0),(13,'Sibling','2009-02-18 17:49:40','2009-02-18 17:49:40',0),(14,'asshole','2009-03-30 20:38:40','2009-03-30 20:38:40',85),(15,'crazed uncle','2009-04-10 04:01:12','2009-04-10 04:01:12',88),(16,'mad aunt','2009-04-10 05:29:52','2009-04-10 05:29:52',88),(17,'mad stepchild','2009-04-10 05:30:09','2009-04-10 05:30:09',88),(18,'something','2009-04-15 23:08:44','2009-04-15 23:08:44',88),(19,'testshit','2009-04-21 23:09:25','2009-04-21 23:09:25',88),(20,'oh noas','2009-04-22 19:46:48','2009-04-22 19:46:48',88);
/*!40000 ALTER TABLE `circles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) default '',
  `comment` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `commentable_id` int(11) default NULL,
  `commentable_type` varchar(255) default NULL,
  `user_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,'','I find this offensive','2009-02-16 19:26:19','2009-02-16 19:26:19',2,'Element',85),(2,'','I think this could use some work','2009-02-17 18:24:36','2009-02-17 18:24:36',1,'Story',85),(3,'','and less suckiness','2009-02-17 18:24:52','2009-02-17 18:24:52',1,'Story',85),(4,'','ass','2009-02-17 18:28:11','2009-02-17 18:28:11',1,'Story',85),(5,'','greass','2009-02-17 18:28:21','2009-02-17 18:28:21',1,'Story',85),(6,'','fah fah fah evil','2009-02-17 18:31:40','2009-02-17 18:31:40',2,'Story',85),(7,'','foo','2009-02-18 06:06:54','2009-02-18 06:06:54',2,'Story',85),(8,'','crazy functionality','2009-03-05 23:58:28','2009-03-05 23:58:28',26,'Story',85);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_accessors`
--

DROP TABLE IF EXISTS `content_accessors`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `content_accessors` (
  `id` int(11) NOT NULL auto_increment,
  `content_authorization_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `circle_id` int(11) default NULL,
  `permissions` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `content_authorization_id` (`content_authorization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `content_accessors`
--

LOCK TABLES `content_accessors` WRITE;
/*!40000 ALTER TABLE `content_accessors` DISABLE KEYS */;
INSERT INTO `content_accessors` VALUES (11,328,89,12,1,'2009-03-18 04:54:13','2009-03-18 04:54:13'),(12,328,90,9,1,'2009-03-18 04:54:13','2009-03-18 04:54:13'),(34,415,0,9,1,'2009-03-25 16:27:34','2009-03-25 16:27:34'),(35,415,0,10,1,'2009-03-25 18:31:37','2009-03-25 18:31:37'),(36,443,0,18,1,'2009-05-15 18:34:34','2009-05-15 18:34:34'),(37,444,0,18,1,'2009-05-15 18:34:35','2009-05-15 18:34:35');
/*!40000 ALTER TABLE `content_accessors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_authorizations`
--

DROP TABLE IF EXISTS `content_authorizations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `content_authorizations` (
  `id` int(11) NOT NULL auto_increment,
  `authorizable_id` int(11) default NULL,
  `authorizable_type` varchar(255) default NULL,
  `privacy_level` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=448 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `content_authorizations`
--

LOCK TABLES `content_authorizations` WRITE;
/*!40000 ALTER TABLE `content_authorizations` DISABLE KEYS */;
INSERT INTO `content_authorizations` VALUES (1,NULL,'Story',2),(2,NULL,'Story',2),(3,NULL,'Story',2),(4,NULL,'Story',2),(5,NULL,'Story',2),(6,NULL,'Story',2),(7,NULL,'Story',2),(8,NULL,'Story',2),(9,NULL,'Story',2),(10,NULL,'Story',2),(11,NULL,'Story',2),(12,NULL,'Story',2),(13,NULL,'Story',2),(14,1,'Story',2),(15,NULL,'Story',2),(16,2,'Story',2),(17,NULL,'Story',2),(18,NULL,'Story',2),(19,NULL,'Story',2),(20,NULL,'Story',2),(21,NULL,'Story',2),(22,NULL,'Story',2),(23,NULL,'Content',2),(24,NULL,'Content',2),(25,NULL,'Content',2),(27,NULL,'Element',2),(28,NULL,'Element',2),(29,NULL,'Element',2),(30,NULL,'Element',2),(31,NULL,'Element',2),(32,NULL,'Element',2),(33,2,'Element',2),(34,NULL,'Element',2),(35,NULL,'Story',2),(37,NULL,'Element',2),(38,NULL,'Element',2),(39,NULL,'Element',2),(40,NULL,'Element',2),(41,NULL,'Element',2),(42,3,'Element',2),(44,NULL,'Element',2),(45,NULL,'Element',2),(46,NULL,'Element',2),(49,NULL,'Element',2),(50,NULL,'Element',2),(51,NULL,'Element',2),(52,NULL,'Element',2),(53,NULL,'Element',2),(54,NULL,'Element',2),(55,NULL,'Element',2),(56,NULL,'Element',2),(57,NULL,'Element',2),(58,NULL,'Element',2),(59,NULL,'Element',2),(60,NULL,'Element',2),(61,NULL,'Element',2),(62,NULL,'Element',2),(63,NULL,'Element',2),(64,NULL,'Element',2),(65,NULL,'Element',2),(66,NULL,'Element',2),(67,NULL,'Element',2),(68,NULL,'Element',2),(70,NULL,'Element',2),(75,NULL,'Story',2),(76,NULL,'Story',2),(77,NULL,'Story',2),(78,NULL,'Element',2),(80,NULL,'Story',2),(81,NULL,'Story',2),(82,NULL,'Story',2),(83,NULL,'Story',2),(84,NULL,'Story',2),(85,NULL,'Story',2),(86,NULL,'Story',2),(87,NULL,'Element',2),(88,NULL,'Story',2),(89,NULL,'Story',2),(90,NULL,'Story',2),(91,NULL,'Story',2),(92,NULL,'Story',2),(93,NULL,'Story',2),(94,NULL,'Story',2),(95,NULL,'Story',2),(96,NULL,'Story',2),(97,NULL,'Element',2),(102,NULL,'Element',2),(104,NULL,'Content',2),(106,NULL,'Content',2),(107,NULL,'Content',2),(108,NULL,'Element',2),(109,NULL,'Content',2),(113,NULL,'Element',2),(114,NULL,'Element',2),(115,NULL,'Story',2),(116,NULL,'Story',2),(117,NULL,'Story',2),(118,NULL,'Story',2),(119,NULL,'Story',2),(120,NULL,'Story',2),(121,NULL,'Story',2),(122,NULL,'Story',2),(123,NULL,'Content',2),(125,NULL,'Element',2),(127,NULL,'Element',2),(129,NULL,'Content',2),(131,NULL,'Story',2),(132,NULL,'Story',2),(133,NULL,'Story',2),(134,NULL,'Story',2),(135,NULL,'Story',2),(136,NULL,'Story',2),(137,NULL,'Story',2),(138,NULL,'Story',2),(139,NULL,'Story',2),(140,NULL,'Story',2),(141,NULL,'Story',2),(142,NULL,'Story',2),(143,NULL,'Story',2),(144,NULL,'Story',2),(145,NULL,'Story',2),(146,NULL,'Story',2),(147,NULL,'Story',2),(148,NULL,'Story',2),(149,NULL,'Story',2),(150,NULL,'Story',2),(151,NULL,'Story',2),(152,NULL,'Story',2),(153,NULL,'Story',2),(154,NULL,'Story',2),(155,NULL,'Story',2),(156,NULL,'Story',2),(157,NULL,'Story',2),(158,NULL,'Story',2),(159,NULL,'Story',2),(160,NULL,'Story',2),(161,NULL,'Story',2),(162,NULL,'Story',2),(163,NULL,'Story',2),(164,NULL,'Story',2),(165,NULL,'Story',2),(166,NULL,'Story',2),(167,NULL,'Story',2),(168,NULL,'Story',2),(169,NULL,'Story',2),(170,NULL,'Story',2),(171,3,'Story',2),(172,NULL,'Story',2),(173,NULL,'Story',2),(174,NULL,'Story',2),(175,NULL,'Story',2),(176,NULL,'Story',2),(177,NULL,'Story',2),(178,NULL,'Story',2),(179,NULL,'Story',2),(180,NULL,'Story',2),(181,NULL,'Story',2),(182,NULL,'Story',2),(183,NULL,'Story',2),(184,NULL,'Story',2),(185,NULL,'Story',2),(186,NULL,'Story',2),(187,NULL,'Story',2),(188,NULL,'Story',2),(189,NULL,'Story',2),(190,NULL,'Story',2),(191,NULL,'Story',2),(192,NULL,'Story',2),(193,NULL,'Story',2),(194,NULL,'Story',2),(195,NULL,'Story',2),(196,NULL,'Story',2),(197,NULL,'Story',2),(198,NULL,'Story',2),(199,NULL,'Story',2),(200,NULL,'Story',2),(201,NULL,'Story',2),(202,NULL,'Story',2),(203,NULL,'Story',2),(204,NULL,'Story',2),(205,NULL,'Story',2),(206,NULL,'Story',2),(207,NULL,'Story',2),(208,NULL,'Story',2),(209,NULL,'Story',2),(210,NULL,'Story',2),(211,NULL,'Story',2),(212,NULL,'Story',2),(213,NULL,'Story',2),(214,NULL,'Story',2),(215,NULL,'Story',2),(216,NULL,'Story',2),(217,NULL,'Story',2),(218,NULL,'Story',2),(219,4,'Story',2),(220,NULL,'Story',2),(221,NULL,'Story',2),(222,NULL,'Story',2),(223,NULL,'Story',2),(224,5,'Story',2),(225,6,'Story',2),(226,7,'Story',2),(227,8,'Story',2),(228,9,'Story',2),(229,10,'Story',2),(230,NULL,'Story',2),(231,NULL,'Story',2),(232,11,'Story',2),(233,NULL,'Story',2),(234,NULL,'Story',2),(235,NULL,'Story',2),(236,NULL,'Story',2),(237,12,'Story',2),(238,NULL,'Story',2),(239,NULL,'Story',2),(240,NULL,'Story',2),(241,NULL,'Story',2),(242,NULL,'Story',2),(243,NULL,'Story',2),(244,NULL,'Story',2),(245,NULL,'Story',2),(246,NULL,'Story',2),(247,NULL,'Story',2),(248,NULL,'Story',2),(249,NULL,'Story',2),(250,NULL,'Story',2),(251,NULL,'Story',2),(252,NULL,'Story',2),(253,NULL,'Story',2),(254,NULL,'Story',2),(255,NULL,'Story',2),(256,NULL,'Story',2),(257,NULL,'Story',2),(258,NULL,'Story',2),(259,NULL,'Story',2),(260,NULL,'Story',2),(261,NULL,'Story',2),(262,NULL,'Story',2),(263,NULL,'Story',2),(264,NULL,'Story',2),(265,NULL,'Story',2),(266,NULL,'Story',2),(267,13,'Story',2),(268,NULL,'Element',2),(269,NULL,'Story',2),(270,NULL,'Story',2),(271,NULL,'Story',2),(272,NULL,'Story',2),(273,NULL,'Story',2),(274,NULL,'Element',2),(275,NULL,'Story',2),(276,NULL,'Story',2),(277,NULL,'Element',2),(278,NULL,'Story',2),(279,NULL,'Story',2),(280,NULL,'Story',2),(281,NULL,'Story',2),(282,NULL,'Story',2),(283,NULL,'Story',2),(284,NULL,'Story',2),(285,NULL,'Story',2),(286,NULL,'Story',2),(287,NULL,'Story',2),(288,NULL,'Story',2),(289,NULL,'Story',2),(290,NULL,'Story',2),(291,NULL,'Story',2),(292,NULL,'Story',2),(293,NULL,'Story',2),(294,NULL,'Story',2),(295,NULL,'Story',2),(296,NULL,'Story',2),(297,NULL,'Story',2),(298,NULL,'Story',2),(299,NULL,'Story',2),(300,NULL,'Story',2),(301,NULL,'Story',2),(302,NULL,'Story',2),(303,NULL,'Story',2),(304,NULL,'Message',2),(305,NULL,'Message',2),(306,NULL,'Message',2),(307,NULL,'Message',2),(308,NULL,'Story',2),(309,NULL,'Story',2),(310,NULL,'Message',2),(311,NULL,'Message',1),(312,NULL,'Message',1),(313,NULL,'Message',1),(314,NULL,'Message',1),(315,NULL,'Message',1),(316,NULL,'Message',1),(317,NULL,'Message',1),(318,NULL,'Message',1),(319,NULL,'Message',1),(320,NULL,'Message',2),(321,NULL,'Message',2),(322,NULL,'Message',2),(323,NULL,'Message',2),(324,NULL,'Message',2),(325,NULL,'Message',2),(326,NULL,'Message',2),(327,NULL,'Message',2),(328,1,'Message',3),(332,NULL,'Element',2),(333,NULL,'Message',2),(334,NULL,'Message',2),(335,NULL,'Message',2),(336,NULL,'Message',2),(337,NULL,'Message',2),(338,NULL,'Message',2),(339,NULL,'Message',2),(340,NULL,'Message',2),(341,3,'Message',2),(342,NULL,'Message',2),(343,NULL,'Message',2),(344,NULL,'Message',2),(345,NULL,'Message',2),(346,NULL,'Message',2),(347,4,'Message',2),(348,NULL,'Story',1),(349,NULL,'Story',1),(350,14,'Story',1),(351,NULL,'Story',2),(352,15,'Story',2),(353,16,'Story',2),(354,17,'Story',2),(355,21,'Story',2),(356,NULL,'Story',2),(357,NULL,'Story',2),(358,NULL,'Story',2),(359,NULL,'Story',2),(360,NULL,'Story',2),(361,NULL,'Story',2),(362,22,'Story',2),(365,NULL,'Message',2),(366,23,'Story',2),(367,NULL,'Story',2),(368,24,'Story',2),(369,NULL,'Story',2),(370,25,'Story',2),(371,NULL,'Story',2),(372,NULL,'Story',2),(373,NULL,'Story',2),(374,NULL,'Story',2),(375,NULL,'Story',2),(376,NULL,'Story',2),(377,NULL,'Story',2),(378,NULL,'Story',2),(379,26,'Story',2),(380,NULL,'Story',2),(381,27,'Story',2),(382,5,'Message',2),(385,NULL,'Message',2),(386,7,'Element',2),(387,6,'Message',2),(389,7,'Message',2),(390,8,'Message',2),(391,9,'Message',2),(392,NULL,'Message',2),(393,NULL,'Message',2),(394,NULL,'Message',2),(395,NULL,'Message',2),(396,NULL,'Message',2),(397,NULL,'Message',2),(398,NULL,'Message',2),(399,NULL,'Message',2),(400,NULL,'Message',2),(401,NULL,'Message',2),(402,NULL,'Message',2),(403,NULL,'Message',2),(404,NULL,'Message',2),(405,NULL,'Message',2),(406,10,'Message',2),(407,NULL,'Message',2),(408,NULL,'Message',2),(409,NULL,'Message',2),(410,NULL,'Message',2),(411,NULL,'Story',2),(412,28,'Story',2),(413,NULL,'Message',2),(414,NULL,'Message',2),(415,11,'Message',3),(419,NULL,'Story',2),(420,NULL,'Story',2),(421,29,'Story',2),(425,NULL,'Message',2),(426,NULL,'Message',2),(427,NULL,'Message',2),(428,13,'Message',2),(429,NULL,'Message',2),(430,NULL,'Message',2),(431,14,'Message',2),(432,15,'Message',2),(433,NULL,'Story',2),(434,NULL,'Story',2),(435,NULL,'Story',2),(436,30,'Story',2),(437,NULL,'Story',2),(438,NULL,'Story',2),(439,NULL,'Story',2),(440,NULL,'Story',2),(441,NULL,'Story',2),(442,124,'Content',2),(443,127,'Content',3),(444,128,'Content',3),(445,129,'Content',2),(446,130,'Content',2),(447,131,'Content',2);
/*!40000 ALTER TABLE `content_authorizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contents`
--

DROP TABLE IF EXISTS `contents`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contents` (
  `id` int(11) NOT NULL auto_increment,
  `size` int(11) NOT NULL default '0',
  `type` varchar(255) NOT NULL default 'Document',
  `title` varchar(255) NOT NULL default 'Document',
  `filename` varchar(255) NOT NULL default 'Document',
  `thumbnail` varchar(255) default NULL,
  `bitrate` varchar(255) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_id` int(11) NOT NULL default '0',
  `parent_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `taken_at` datetime default NULL,
  `duration` varchar(255) default NULL,
  `version` int(11) default NULL,
  `processing_error_message` varchar(255) default NULL,
  `cdn_url` varchar(255) default NULL,
  `description` text,
  `fps` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `is_recording` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `contents`
--

LOCK TABLES `contents` WRITE;
/*!40000 ALTER TABLE `contents` DISABLE KEYS */;
INSERT INTO `contents` VALUES (123,8082,'Photo','Bushchimp','bushchimp.jpg',NULL,NULL,72,94,'2009-05-15 15:50:37','2009-05-15 15:50:38',88,NULL,'image/jpeg',NULL,NULL,NULL,'You did not provide both required access keys. Please provide the access_key_id and the secret_access_key.',NULL,NULL,NULL,'error',0),(124,59969,'Photo','Basecamp Account Plans','basecamp_account_plans.png',NULL,NULL,599,389,'2009-05-15 16:03:03','2009-05-15 16:06:03',88,NULL,'image/png',NULL,NULL,NULL,'You did not provide both required access keys. Please provide the access_key_id and the secret_access_key.',NULL,'',NULL,'error',0),(125,442355,'Photo','Brandy Cake.1','Brandy_cake.1.jpg',NULL,NULL,1147,1518,'2009-05-15 16:06:37','2009-05-15 16:06:40',88,NULL,'image/jpeg',NULL,NULL,NULL,'You did not provide both required access keys. Please provide the access_key_id and the secret_access_key.',NULL,NULL,NULL,'error',0),(126,885,'Video','Cloud','cloud.mov',NULL,' ',NULL,NULL,'2009-05-15 16:19:16','2009-05-15 16:19:18',88,NULL,'video/quicktime',NULL,'',NULL,'You did not provide both required access keys. Please provide the access_key_id and the secret_access_key.',NULL,NULL,NULL,'error',0),(127,442355,'Photo','Brandy Cake.1','Brandy_cake.1.jpg',NULL,NULL,1147,1518,'2009-05-15 17:42:35','2009-05-15 18:34:34',88,NULL,'image/jpeg',NULL,NULL,NULL,'You did not provide both required access keys. Please provide the access_key_id and the secret_access_key.',NULL,'',NULL,'error',0),(128,8082,'Photo','Bushchimp','bushchimp.jpg',NULL,NULL,72,94,'2009-05-15 17:42:40','2009-05-15 18:34:35',88,NULL,'image/jpeg',NULL,NULL,NULL,'You did not provide both required access keys. Please provide the access_key_id and the secret_access_key.',NULL,'',NULL,'error',0),(129,47661,'Photo','Cyclist','cyclist.jpg',NULL,NULL,576,446,'2009-05-15 18:37:00','2009-05-15 18:37:56',88,NULL,'image/jpeg',NULL,NULL,NULL,'You did not provide both required access keys. Please provide the access_key_id and the secret_access_key.',NULL,'',NULL,'error',0),(130,35885,'Photo','Drinky Crow','drinky_crow.jpg',NULL,NULL,450,235,'2009-05-15 18:37:04','2009-05-15 18:37:56',88,NULL,'image/jpeg','2006-05-29 09:42:58',NULL,NULL,'You did not provide both required access keys. Please provide the access_key_id and the secret_access_key.',NULL,'',NULL,'error',0),(131,5716096,'Music','01 Richter Scale Madness','01_Richter_Scale_Madness.mp3',NULL,'203 kb/s',NULL,NULL,'2009-05-15 18:37:10','2009-05-15 18:37:57',88,NULL,'audio/mpeg',NULL,'225010',NULL,'You did not provide both required access keys. Please provide the access_key_id and the secret_access_key.',NULL,'',NULL,'error',0);
/*!40000 ALTER TABLE `contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `countries` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `official_name` varchar(255) default NULL,
  `alpha_2_code` varchar(255) default NULL,
  `alpha_3_code` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=895 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (4,'Afghanistan','Islamic Republic of Afghanistan','AF','AFG'),(8,'Albania','Republic of Albania','AL','ALB'),(10,'Antarctica','Antarctica','AQ','ATA'),(12,'Algeria','People\'s Democratic Republic of Algeria','DZ','DZA'),(16,'American Samoa','American Samoa','AS','ASM'),(20,'Andorra','Principality of Andorra','AD','AND'),(24,'Angola','Republic of Angola','AO','AGO'),(28,'Antigua and Barbuda','Antigua and Barbuda','AG','ATG'),(31,'Azerbaijan','Republic of Azerbaijan','AZ','AZE'),(32,'Argentina','Argentine Republic','AR','ARG'),(36,'Australia','Australia','AU','AUS'),(40,'Austria','Republic of Austria','AT','AUT'),(44,'Bahamas','Commonwealth of the Bahamas','BS','BHS'),(48,'Bahrain','Kingdom of Bahrain','BH','BHR'),(50,'Bangladesh','People\'s Republic of Bangladesh','BD','BGD'),(51,'Armenia','Republic of Armenia','AM','ARM'),(52,'Barbados','Barbados','BB','BRB'),(56,'Belgium','Kingdom of Belgium','BE','BEL'),(60,'Bermuda','Bermuda','BM','BMU'),(64,'Bhutan','Kingdom of Bhutan','BT','BTN'),(68,'Bolivia','Republic of Bolivia','BO','BOL'),(70,'Bosnia and Herzegovina','Republic of Bosnia and Herzegovina','BA','BIH'),(72,'Botswana','Republic of Botswana','BW','BWA'),(74,'Bouvet Island','Bouvet Island','BV','BVT'),(76,'Brazil','Federative Republic of Brazil','BR','BRA'),(84,'Belize','Belize','BZ','BLZ'),(86,'British Indian Ocean Territory','British Indian Ocean Territory','IO','IOT'),(90,'Solomon Islands','Solomon Islands','SB','SLB'),(92,'Virgin Islands, British','British Virgin Islands','VG','VGB'),(96,'Brunei Darussalam','Brunei Darussalam','BN','BRN'),(100,'Bulgaria','Republic of Bulgaria','BG','BGR'),(104,'Myanmar','Union of Myanmar','MM','MMR'),(108,'Burundi','Republic of Burundi','BI','BDI'),(112,'Belarus','Republic of Belarus','BY','BLR'),(116,'Cambodia','Kingdom of Cambodia','KH','KHM'),(120,'Cameroon','Republic of Cameroon','CM','CMR'),(124,'Canada','Canada','CA','CAN'),(132,'Cape Verde','Republic of Cape Verde','CV','CPV'),(136,'Cayman Islands','Cayman Islands','KY','CYM'),(140,'Central African Republic','Central African Republic','CF','CAF'),(144,'Sri Lanka','Democratic Socialist Republic of Sri Lanka','LK','LKA'),(148,'Chad','Republic of Chad','TD','TCD'),(152,'Chile','Republic of Chile','CL','CHL'),(156,'China','People\'s Republic of China','CN','CHN'),(158,'Taiwan','Taiwan, Province of China','TW','TWN'),(162,'Christmas Island','Christmas Island','CX','CXR'),(166,'Cocos (Keeling) Islands','Cocos (Keeling) Islands','CC','CCK'),(170,'Colombia','Republic of Colombia','CO','COL'),(174,'Comoros','Union of the Comoros','KM','COM'),(175,'Mayotte','Mayotte','YT','MYT'),(178,'Congo','Republic of the Congo','CG','COG'),(180,'Congo, Democratic Republic of','Congo, The Democratic Republic of the','CD','COD'),(184,'Cook Islands','Cook Islands','CK','COK'),(188,'Costa Rica','Republic of Costa Rica','CR','CRI'),(191,'Croatia','Republic of Croatia','HR','HRV'),(192,'Cuba','Republic of Cuba','CU','CUB'),(196,'Cyprus','Republic of Cyprus','CY','CYP'),(203,'Czech Republic','Czech Republic','CZ','CZE'),(204,'Benin','Republic of Benin','BJ','BEN'),(208,'Denmark','Kingdom of Denmark','DK','DNK'),(212,'Dominica','Commonwealth of Dominica','DM','DMA'),(214,'Dominican Republic','Dominican Republic','DO','DOM'),(218,'Ecuador','Republic of Ecuador','EC','ECU'),(222,'El Salvador','Republic of El Salvador','SV','SLV'),(226,'Equatorial Guinea','Republic of Equatorial Guinea','GQ','GNQ'),(231,'Ethiopia','Federal Democratic Republic of Ethiopia','ET','ETH'),(232,'Eritrea','Eritrea','ER','ERI'),(233,'Estonia','Republic of Estonia','EE','EST'),(234,'Faroe Islands','Faroe Islands','FO','FRO'),(238,'Falkland Islands','Falkland Islands (Malvinas)','FK','FLK'),(239,'South Georgia','South Georgia and the South Sandwich Islands','GS','SGS'),(242,'Fiji','Republic of the Fiji Islands','FJ','FJI'),(246,'Finland','Republic of Finland','FI','FIN'),(248,'Ã…land Islands','Ã…land Islands','AX','ALA'),(250,'France','French Republic','FR','FRA'),(254,'French Guiana','French Guiana','GF','GUF'),(258,'French Polynesia','French Polynesia','PF','PYF'),(260,'French Southern Territories','French Southern Territories','TF','ATF'),(262,'Djibouti','Republic of Djibouti','DJ','DJI'),(266,'Gabon','Gabonese Republic','GA','GAB'),(268,'Georgia','Georgia','GE','GEO'),(270,'Gambia','Republic of the Gambia','GM','GMB'),(275,'Palestinian Territories','Occupied Palestinian Territory','PS','PSE'),(276,'Germany','Federal Republic of Germany','DE','DEU'),(288,'Ghana','Republic of Ghana','GH','GHA'),(292,'Gibraltar','Gibraltar','GI','GIB'),(296,'Kiribati','Republic of Kiribati','KI','KIR'),(300,'Greece','Hellenic Republic','GR','GRC'),(304,'Greenland','Greenland','GL','GRL'),(308,'Grenada','Grenada','GD','GRD'),(312,'Guadeloupe','Guadeloupe','GP','GLP'),(316,'Guam','Guam','GU','GUM'),(320,'Guatemala','Republic of Guatemala','GT','GTM'),(324,'Guinea','Republic of Guinea','GN','GIN'),(328,'Guyana','Republic of Guyana','GY','GUY'),(332,'Haiti','Republic of Haiti','HT','HTI'),(334,'Heard and McDonald Islands','Heard Island and McDonald ','HM','HMD'),(336,'Holy See (Vatican City State)','Holy See (Vatican City State)','VA','VAT'),(340,'Honduras','Republic of Honduras','HN','HND'),(344,'Hong Kong','Hong Kong Special Administrative Region of China','HK','HKG'),(348,'Hungary','Republic of Hungary','HU','HUN'),(352,'Iceland','Republic of Iceland','IS','ISL'),(356,'India','Republic of India','IN','IND'),(360,'Indonesia','Republic of Indonesia','ID','IDN'),(364,'Iran','Islamic Republic of Iran','IR','IRN'),(368,'Iraq','Republic of Iraq','IQ','IRQ'),(372,'Ireland','Ireland','IE','IRL'),(376,'Israel','State of Israel','IL','ISR'),(380,'Italy','Italian Republic','IT','ITA'),(384,'CÃ´te d\'Ivoire','Republic of CÃ´te d\'Ivoire','CI','CIV'),(388,'Jamaica','Jamaica','JM','JAM'),(392,'Japan','Japan','JP','JPN'),(398,'Kazakhstan','Republic of Kazakhstan','KZ','KAZ'),(400,'Jordan','Hashemite Kingdom of Jordan','JO','JOR'),(404,'Kenya','Republic of Kenya','KE','KEN'),(408,'North Korea','Democratic People\'s Republic of Korea','KP','PRK'),(410,'South Korea','Republic of Korea','KR','KOR'),(414,'Kuwait','State of Kuwait','KW','KWT'),(417,'Kyrgyzstan','Kyrgyz Republic','KG','KGZ'),(418,'Laos','Lao People\'s Democratic Republic','LA','LAO'),(422,'Lebanon','Lebanese Republic','LB','LBN'),(426,'Lesotho','Kingdom of Lesotho','LS','LSO'),(428,'Latvia','Republic of Latvia','LV','LVA'),(430,'Liberia','Republic of Liberia','LR','LBR'),(434,'Libya','Socialist People\'s Libyan Arab Jamahiriya','LY','LBY'),(438,'Liechtenstein','Principality of Liechtenstein','LI','LIE'),(440,'Lithuania','Republic of Lithuania','LT','LTU'),(442,'Luxembourg','Grand Duchy of Luxembourg','LU','LUX'),(446,'Macao','Macao Special Administrative Region of China','MO','MAC'),(450,'Madagascar','Republic of Madagascar','MG','MDG'),(454,'Malawi','Republic of Malawi','MW','MWI'),(458,'Malaysia','Malaysia','MY','MYS'),(462,'Maldives','Republic of Maldives','MV','MDV'),(466,'Mali','Republic of Mali','ML','MLI'),(470,'Malta','Republic of Malta','MT','MLT'),(474,'Martinique','Martinique','MQ','MTQ'),(478,'Mauritania','Islamic Republic of Mauritania','MR','MRT'),(480,'Mauritius','Republic of Mauritius','MU','MUS'),(484,'Mexico','United Mexican States','MX','MEX'),(492,'Monaco','Principality of Monaco','MC','MCO'),(496,'Mongolia','Mongolia','MN','MNG'),(498,'Moldova','Republic of Moldova','MD','MDA'),(499,'Montenegro','Republic of Montenegro','ME','MNE'),(500,'Montserrat','Montserrat','MS','MSR'),(504,'Morocco','Kingdom of Morocco','MA','MAR'),(508,'Mozambique','Republic of Mozambique','MZ','MOZ'),(512,'Oman','Sultanate of Oman','OM','OMN'),(516,'Namibia','Republic of Namibia','NA','NAM'),(520,'Nauru','Republic of Nauru','NR','NRU'),(524,'Nepal','Kingdom of Nepal','NP','NPL'),(528,'Netherlands','Kingdom of the Netherlands','NL','NLD'),(530,'Netherlands Antilles','Netherlands Antilles','AN','ANT'),(533,'Aruba','Aruba','AW','ABW'),(540,'New Caledonia','New Caledonia','NC','NCL'),(548,'Vanuatu','Republic of Vanuatu','VU','VUT'),(554,'New Zealand','New Zealand','NZ','NZL'),(558,'Nicaragua','Republic of Nicaragua','NI','NIC'),(562,'Niger','Republic of the Niger','NE','NER'),(566,'Nigeria','Federal Republic of Nigeria','NG','NGA'),(570,'Niue','Republic of Niue','NU','NIU'),(574,'Norfolk Island','Norfolk Island','NF','NFK'),(578,'Norway','Kingdom of Norway','NO','NOR'),(580,'Northern Mariana Islands','Commonwealth of the Northern Mariana Islands','MP','MNP'),(581,'U.S. Minor Outlying Islands','United States Minor Outlying Islands','UM','UMI'),(583,'Micronesia','Federated States of Micronesia','FM','FSM'),(584,'Marshall Islands','Republic of the Marshall Islands','MH','MHL'),(585,'Palau','Republic of Palau','PW','PLW'),(586,'Pakistan','Islamic Republic of Pakistan','PK','PAK'),(591,'Panama','Republic of Panama','PA','PAN'),(598,'Papua New Guinea','Papua New Guinea','PG','PNG'),(600,'Paraguay','Republic of Paraguay','PY','PRY'),(604,'Peru','Republic of Peru','PE','PER'),(608,'Philippines','Republic of the Philippines','PH','PHL'),(612,'Pitcairn','Pitcairn','PN','PCN'),(616,'Poland','Republic of Poland','PL','POL'),(620,'Portugal','Portuguese Republic','PT','PRT'),(624,'Guinea-Bissau','Republic of Guinea-Bissau','GW','GNB'),(626,'Timor-Leste','Democratic Republic of Timor-Leste','TL','TLS'),(630,'Puerto Rico','Puerto Rico','PR','PRI'),(634,'Qatar','State of Qatar','QA','QAT'),(638,'Reunion','Reunion','RE','REU'),(642,'Romania','Romania','RO','ROU'),(643,'Russian Federation','Russian Federation','RU','RUS'),(646,'Rwanda','Rwandese Republic','RW','RWA'),(652,'Saint BarthÃ©lemy','Saint BarthÃ©lemy','BL','BLM'),(654,'St. Helena','Saint Helena','SH','SHN'),(659,'St. Kitts and Nevis','Saint Kitts and Nevis','KN','KNA'),(660,'Anguilla','Anguilla','AI','AIA'),(662,'St. Lucia','Saint Lucia','LC','LCA'),(663,'St. Martin (French part)','Saint Martin (French part)','MF','MAF'),(666,'St. Pierre and Miquelon','Saint Pierre and Miquelon','PM','SPM'),(670,'St. Vincent and the Grenadines','Saint Vincent and the Grenadines','VC','VCT'),(674,'San Marino','Republic of San Marino','SM','SMR'),(678,'Sao Tome and Principe','Democratic Republic of Sao Tome and Principe','ST','STP'),(682,'Saudi Arabia','Kingdom of Saudi Arabia','SA','SAU'),(686,'Senegal','Republic of Senegal','SN','SEN'),(688,'Serbia','Republic of Serbia','RS','SRB'),(690,'Seychelles','Republic of Seychelles','SC','SYC'),(694,'Sierra Leone','Republic of Sierra Leone','SL','SLE'),(702,'Singapore','Republic of Singapore','SG','SGP'),(703,'Slovakia','Slovak Republic','SK','SVK'),(704,'Viet Nam','Socialist Republic of Viet Nam','VN','VNM'),(705,'Slovenia','Republic of Slovenia','SI','SVN'),(706,'Somalia','Somali Republic','SO','SOM'),(710,'South Africa','Republic of South Africa','ZA','ZAF'),(716,'Zimbabwe','Republic of Zimbabwe','ZW','ZWE'),(724,'Spain','Kingdom of Spain','ES','ESP'),(732,'Western Sahara','Western Sahara','EH','ESH'),(736,'Sudan','Republic of the Sudan','SD','SDN'),(740,'Suriname','Republic of Suriname','SR','SUR'),(744,'Svalbard and Jan Mayen','Svalbard and Jan Mayen','SJ','SJM'),(748,'Swaziland','Kingdom of Swaziland','SZ','SWZ'),(752,'Sweden','Kingdom of Sweden','SE','SWE'),(756,'Switzerland','Swiss Confederation','CH','CHE'),(760,'Syrian Arab Republic','Syrian Arab Republic','SY','SYR'),(762,'Tajikistan','Republic of Tajikistan','TJ','TJK'),(764,'Thailand','Kingdom of Thailand','TH','THA'),(768,'Togo','Togolese Republic','TG','TGO'),(772,'Tokelau','Tokelau','TK','TKL'),(776,'Tonga','Kingdom of Tonga','TO','TON'),(780,'Trinidad and Tobago','Republic of Trinidad and Tobago','TT','TTO'),(784,'United Arab Emirates','United Arab Emirates','AE','ARE'),(788,'Tunisia','Republic of Tunisia','TN','TUN'),(792,'Turkey','Republic of Turkey','TR','TUR'),(795,'Turkmenistan','Turkmenistan','TM','TKM'),(796,'Turks and Caicos Islands','Turks and Caicos Islands','TC','TCA'),(798,'Tuvalu','Tuvalu','TV','TUV'),(800,'Uganda','Republic of Uganda','UG','UGA'),(804,'Ukraine','Ukraine','UA','UKR'),(807,'Macedonia','The Former Yugoslav Republic of Macedonia','MK','MKD'),(818,'Egypt','Arab Republic of Egypt','EG','EGY'),(826,'United Kingdom','United Kingdom of Great Britain and Northern Ireland','GB','GBR'),(831,'Guernsey','Guernsey','GG','GGY'),(832,'Jersey','Jersey','JE','JEY'),(833,'Isle of Man','Isle of Man','IM','IMN'),(834,'Tanzania','United Republic of Tanzania','TZ','TZA'),(840,'United States','United States of America','US','USA'),(850,'Virgin Islands, U.S.','Virgin Islands of the United States','VI','VIR'),(854,'Burkina Faso','Burkina Faso','BF','BFA'),(858,'Uruguay','Eastern Republic of Uruguay','UY','URY'),(860,'Uzbekistan','Republic of Uzbekistan','UZ','UZB'),(862,'Venezuela','Bolivarian Republic of Venezuela','VE','VEN'),(876,'Wallis and Futuna','Wallis and Futuna','WF','WLF'),(882,'Samoa','Independent State of Samoa','WS','WSM'),(887,'Yemen','Republic of Yemen','YE','YEM'),(894,'Zambia','Republic of Zambia','ZM','ZMB');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `decorations`
--

DROP TABLE IF EXISTS `decorations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `decorations` (
  `id` int(11) NOT NULL auto_increment,
  `content_id` int(11) NOT NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `decoratable_type` varchar(255) NOT NULL,
  `decoratable_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_decorations_on_content_id` (`content_id`),
  KEY `index_decorations_on_polymorph` (`decoratable_id`,`decoratable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `decorations`
--

LOCK TABLES `decorations` WRITE;
/*!40000 ALTER TABLE `decorations` DISABLE KEYS */;
/*!40000 ALTER TABLE `decorations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deleted_accounts`
--

DROP TABLE IF EXISTS `deleted_accounts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `deleted_accounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `full_domain` varchar(255) default NULL,
  `subscription_discount_id` int(11) default NULL,
  `state` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `deleted_accounts`
--

LOCK TABLES `deleted_accounts` WRITE;
/*!40000 ALTER TABLE `deleted_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `deleted_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elements`
--

DROP TABLE IF EXISTS `elements`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `elements` (
  `id` int(11) NOT NULL auto_increment,
  `story_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `position` int(11) default NULL,
  `message` text,
  `title` varchar(255) default NULL,
  `start_at` datetime default NULL,
  `end_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `story_id` (`story_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `elements`
--

LOCK TABLES `elements` WRITE;
/*!40000 ALTER TABLE `elements` DISABLE KEYS */;
INSERT INTO `elements` VALUES (2,1,'2009-02-13 17:18:56','2009-02-23 00:27:30',1,'<p>ok what if I do this ???<img src=\"/javascripts/fckeditor/editor/images/smiley/msn/sad_smile.gif\" alt=\"\" /></p>','This is a title',NULL,NULL),(3,1,'2009-02-13 22:18:59','2009-02-13 22:18:59',2,'<p>shooby dooby doddd</p>','oh here\'s one',NULL,NULL),(7,22,'2009-03-20 02:54:22','2009-03-20 02:54:22',1,'<p>more text here in b/c my story is really long &amp; maybe I want to associate some pics</p>','oh man so lam',NULL,NULL);
/*!40000 ALTER TABLE `elements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest_invitations`
--

DROP TABLE IF EXISTS `guest_invitations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `guest_invitations` (
  `id` int(11) NOT NULL auto_increment,
  `sender_id` int(11) NOT NULL,
  `circle_id` int(11) default NULL,
  `email` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `contact_method` varchar(255) default NULL,
  `sent_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `attempts` int(11) NOT NULL default '0',
  `emergency_contact` tinyint(1) default NULL,
  `token` varchar(255) default NULL,
  `send_on` datetime default NULL,
  `status` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `guest_invitations`
--

LOCK TABLES `guest_invitations` WRITE;
/*!40000 ALTER TABLE `guest_invitations` DISABLE KEYS */;
INSERT INTO `guest_invitations` VALUES (2,88,19,'dr@phil.org','john dude','phone',NULL,'2009-04-15 22:56:35','2009-04-22 19:44:08',0,1,NULL,NULL,'pending'),(3,88,18,'ass@poop.com','dr no','mail',NULL,'2009-04-15 23:09:12','2009-04-22 00:10:27',0,0,NULL,NULL,'pending'),(4,88,20,'','ass grassy know','phone',NULL,'2009-04-15 23:15:21','2009-04-22 19:46:48',0,1,NULL,NULL,'dormant'),(5,88,16,'','crap man','mail',NULL,'2009-04-16 06:11:27','2009-04-16 06:11:27',0,0,NULL,NULL,'created'),(6,88,16,'','test','mail',NULL,'2009-04-16 20:28:31','2009-04-16 20:28:31',0,0,NULL,NULL,'created'),(9,88,10,'','jack black','mail',NULL,'2009-04-16 23:30:30','2009-04-20 23:47:10',0,0,NULL,NULL,'created'),(10,88,16,'ass@jok.com','future lock','email',NULL,'2009-04-17 00:01:50','2009-04-17 00:01:50',0,0,NULL,NULL,'created'),(11,88,10,'','jose cuervo','phone',NULL,'2009-04-18 00:49:58','2009-04-19 16:00:36',0,0,NULL,NULL,'pending');
/*!40000 ALTER TABLE `guest_invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invitations`
--

DROP TABLE IF EXISTS `invitations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `invitations` (
  `id` int(11) NOT NULL auto_increment,
  `sender_id` int(11) NOT NULL,
  `recipient_email` varchar(255) default NULL,
  `token` varchar(255) default NULL,
  `sent_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sender_id` (`sender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `invitations`
--

LOCK TABLES `invitations` WRITE;
/*!40000 ALTER TABLE `invitations` DISABLE KEYS */;
/*!40000 ALTER TABLE `invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `jobs` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) NOT NULL,
  `company` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `start_at` date default NULL,
  `end_at` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `profile_id` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `start_at` datetime default NULL,
  `end_at` datetime default NULL,
  `message` text NOT NULL,
  `category_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,85,'frick','2009-02-25 22:18:30','2009-03-18 21:45:00','2009-03-13 00:00:00','2009-03-31 00:00:00','<p>froo froo bad for me right wrong or shat upon</p>',NULL),(3,85,'shit','2009-02-27 02:10:30','2009-03-03 05:23:46','1913-02-01 00:00:00','1916-04-01 00:00:00','<p>poo poo poo</p>',NULL),(4,85,'ENTER A TITLE','2009-02-27 02:41:16','2009-03-18 21:45:42','2009-03-02 00:00:00','2010-03-12 00:00:00','<p>Enter your message here please</p>',NULL),(5,85,'some shit happened','2009-03-11 19:28:12','2009-03-19 00:09:06','1901-01-01 00:00:00','2009-03-18 00:00:00','<p>ok, poop</p>',24),(6,85,'testing','2009-03-20 02:57:36','2009-03-21 23:30:00','1898-01-01 00:00:00',NULL,'<p>Enter your message here</p>',NULL),(7,85,'testing postdate','2009-03-20 19:06:48','2009-03-20 19:06:48',NULL,NULL,'<p>Enter your message here</p>',NULL),(8,85,'testing2','2009-03-20 19:27:44','2009-03-20 19:27:45',NULL,NULL,'<p>Enter your message here</p>',NULL),(9,85,'should not work','2009-03-20 21:35:38','2009-03-20 21:35:38',NULL,NULL,'<p>Enter your message here</p>',NULL),(10,85,'ass','2009-03-20 22:47:59','2009-03-20 22:47:59',NULL,NULL,'<p>Enter your message here</p>',NULL),(11,88,'for siblings only','2009-03-24 23:36:45','2009-04-24 15:14:24',NULL,NULL,'<p>quick edit here</p>',NULL),(13,88,'test i cle','2009-04-22 23:43:53','2009-04-23 19:12:37',NULL,NULL,'<p>Enter your message herewow a pic just showed up:</p>                   <p><img src=\"../../../assets/0000/0101/jimmy-olsen-100-panel_thumb.jpg?1238093376\" alt=\"Jimmy-olsen-100-panel_thumb\" />&nbsp;&nbsp;&nbsp; ass clwon<img src=\"../../../assets/0000/0099/drinky_crow_thumb.jpg?1238093373\" alt=\"Drinky_crow_thumb\" /><span style=\"font-family: Arial;\">fdgsdfg<span style=\"font-size: xx-large;\">sdfgsdfg</span></span></p>                   <p><span style=\"font-family: Arial;\"><span style=\"font-size: xx-large;\">sfdgsdfg</span></span></p>                   <p><img src=\"../../../images/video-small-icon.gif?1235501727\" alt=\"Video-small-icon\" /> shwag farmers</p>                   <p>pretty cool so far....<img alt=\"Audio-small-icon\" src=\"../../../images/audio-small-icon.gif?1235501727\" /></p>                   <p>&nbsp;then this should work too<img style=\"width: 260px; height: 200px;\" src=\"../../../assets/0000/0095/cyclist_thumb.jpg?1238095350\" alt=\"Cyclist_thumb\" /></p>',NULL),(14,88,'d&d testing','2009-04-24 03:52:34','2009-04-24 14:56:07',NULL,NULL,'<p><a href=\"http://www.ass.com\">                         <img alt=\"Video-small-icon\" id=\"gallery_item_video_112\" src=\"/images/video-small-icon.gif?1235501727\" />                         Ice Cube - It Was a Good Day                       </a></p>                     <p>Enter your message here</p>                     <p>&nbsp;</p>                     <p>word</p>',NULL),(15,88,'testing stuff','2009-04-24 04:02:24','2009-04-25 21:43:57',NULL,NULL,'<p><object:music_108>                         <img alt=\"Audio-small-icon\" id=\"gallery_item_music_108\" src=\"/images/audio-small-icon.gif?1235501727\" />                         01 <strong>Richter</strong> Scale Madness                       </object:music_108></p><p><object:video_98>&nbsp;                         cloud.mov&nbsp;</object:video_98><object:video_98>&nbsp;</object:video_98><object:video_98>                       </object:video_98><object:photo_95>                         <img alt=\"Cyclist_thumb\" id=\"gallery_item_photo_95\" src=\"/assets/0000/0095/cyclist_thumb.jpg?1238095350\" />&nbsp;</object:photo_95><object:photo_95>                                                </object:photo_95></p>                 <p><object:photo_95>&nbsp;                         </object:photo_95><object:photo_95></object:photo_95>Enter your message here</p>                 <ol><li><img alt=\"Cyclist_thumb\" id=\"gallery_item_photo_95\" src=\"/assets/0000/0095/cyclist_thumb.jpg?1238095350\" /> as</li><li>2</li><li>3</li><li>&nbsp;</li></ol>                 <p>really ass</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>                 <p>&nbsp;</p>',NULL);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_authentication_associations`
--

DROP TABLE IF EXISTS `open_id_authentication_associations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `open_id_authentication_associations` (
  `id` int(11) NOT NULL auto_increment,
  `issued` int(11) default NULL,
  `lifetime` int(11) default NULL,
  `handle` varchar(255) default NULL,
  `assoc_type` varchar(255) default NULL,
  `server_url` blob,
  `secret` blob,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `open_id_authentication_associations`
--

LOCK TABLES `open_id_authentication_associations` WRITE;
/*!40000 ALTER TABLE `open_id_authentication_associations` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_authentication_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_authentication_nonces`
--

DROP TABLE IF EXISTS `open_id_authentication_nonces`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `open_id_authentication_nonces` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` int(11) NOT NULL,
  `server_url` varchar(255) default NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `open_id_authentication_nonces`
--

LOCK TABLES `open_id_authentication_nonces` WRITE;
/*!40000 ALTER TABLE `open_id_authentication_nonces` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_authentication_nonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `remote_ip` varchar(255) default NULL,
  `token` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
INSERT INTO `password_resets` VALUES (1,NULL,25,'127.0.0.1','7ef2ff32-6352-d676-b7ae-8733854cc025','2009-02-06 05:04:00'),(2,NULL,25,'127.0.0.1','fa7dcf66-f0ac-d2e2-e1b5-31f7d7d2496d','2009-02-06 20:46:44'),(5,NULL,25,'127.0.0.1','34cb66e6-6a6d-b5cb-4db2-b41e1a5f1376','2009-02-06 21:03:40'),(6,NULL,25,'127.0.0.1','a9eaf49f-1550-749b-0956-52bda7aeb3dd','2009-02-06 21:05:39'),(8,NULL,25,'127.0.0.1','b8548bf9-4a3f-401a-06f3-5b97d51bd47e','2009-02-06 21:35:50'),(9,NULL,25,'127.0.0.1','6b5f751e-5690-f0a9-a79e-8f20ef2b1289','2009-02-06 21:38:55');
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_numbers`
--

DROP TABLE IF EXISTS `phone_numbers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `phone_numbers` (
  `id` int(11) NOT NULL auto_increment,
  `phoneable_id` int(11) NOT NULL,
  `phoneable_type` varchar(255) NOT NULL,
  `phone_type` varchar(255) NOT NULL,
  `prefix` varchar(255) default NULL,
  `area_code` varchar(255) default NULL,
  `number` varchar(255) default NULL,
  `extension` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `phone_numbers`
--

LOCK TABLES `phone_numbers` WRITE;
/*!40000 ALTER TABLE `phone_numbers` DISABLE KEYS */;
INSERT INTO `phone_numbers` VALUES (2,4,'GuestInvitation','home','','','222 1111','','2009-04-15 23:15:21','2009-04-20 21:46:29'),(3,11,'GuestInvitation','home','1','212','333-4444','','2009-04-18 00:49:58','2009-04-18 00:49:58'),(4,11,'GuestInvitation','home','2','333','444-555','','2009-04-18 00:49:58','2009-04-18 00:49:58'),(5,2,'GuestInvitation','pager','','206','333-2221','','2009-04-20 04:49:03','2009-04-20 23:27:40');
/*!40000 ALTER TABLE `phone_numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photo_thumbnails`
--

DROP TABLE IF EXISTS `photo_thumbnails`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `photo_thumbnails` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `thumbnail` varchar(255) default NULL,
  `size` int(11) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `photo_thumbnails`
--

LOCK TABLES `photo_thumbnails` WRITE;
/*!40000 ALTER TABLE `photo_thumbnails` DISABLE KEYS */;
INSERT INTO `photo_thumbnails` VALUES (82,123,'image/jpeg','bushchimp_thumb.jpg','thumb',6947,72,94,'2009-05-15 15:50:37','2009-05-15 15:50:37'),(83,124,'image/png','basecamp_account_plans_thumb.png','thumb',8756,100,65,'2009-05-15 16:03:03','2009-05-15 16:03:03'),(84,125,'image/jpeg','Brandy_cake.1_thumb.jpg','thumb',5364,76,100,'2009-05-15 16:06:38','2009-05-15 16:06:38'),(85,127,'image/jpeg','Brandy_cake.1_thumb.jpg','thumb',5364,76,100,'2009-05-15 17:42:36','2009-05-15 17:42:36'),(86,128,'image/jpeg','bushchimp_thumb.jpg','thumb',6947,72,94,'2009-05-15 17:42:41','2009-05-15 17:42:41'),(87,129,'image/jpeg','cyclist_thumb.jpg','thumb',3033,100,77,'2009-05-15 18:37:00','2009-05-15 18:37:00'),(88,130,'image/jpeg','drinky_crow_thumb.jpg','thumb',1355,100,52,'2009-05-15 18:37:05','2009-05-15 18:37:05');
/*!40000 ALTER TABLE `photo_thumbnails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_schema_info`
--

DROP TABLE IF EXISTS `plugin_schema_info`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) default NULL,
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `plugin_schema_info`
--

LOCK TABLES `plugin_schema_info` WRITE;
/*!40000 ALTER TABLE `plugin_schema_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_schema_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `profiles` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `height` varchar(255) default NULL,
  `weight` varchar(255) default NULL,
  `race` varchar(255) default NULL,
  `gender` varchar(255) default NULL,
  `religion` varchar(255) default NULL,
  `political_views` varchar(255) default NULL,
  `sexual_orientation` varchar(255) default NULL,
  `nickname` varchar(255) default NULL,
  `ethnicity` varchar(255) default NULL,
  `children` varchar(255) default NULL,
  `death_date` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipients`
--

DROP TABLE IF EXISTS `recipients`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `recipients` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `alt_email` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `recipients`
--

LOCK TABLES `recipients` WRITE;
/*!40000 ALTER TABLE `recipients` DISABLE KEYS */;
/*!40000 ALTER TABLE `recipients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recordings`
--

DROP TABLE IF EXISTS `recordings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `recordings` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `filename` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `processing_error` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `command` varchar(255) default NULL,
  `command_expanded` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `recordings`
--

LOCK TABLES `recordings` WRITE;
/*!40000 ALTER TABLE `recordings` DISABLE KEYS */;
INSERT INTO `recordings` VALUES (39,85,'audio1236184922621.flv','complete',NULL,'2009-03-04 16:42:24','2009-03-04 16:42:26','ffmpeg -i $input_file$ -y -acodec copy $output_file$','ffmpeg -i /Applications/Red5/webapps/messageRecorder/streams/audio1236184922621.flv -y -acodec copy /var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/audio1236184922621,7574,0.mp3'),(52,85,'audio1236201042853.flv','complete',NULL,'2009-03-04 21:10:52','2009-03-04 21:10:59','ffmpeg -i $input_file$ -y -f mp3 $output_file$','ffmpeg -i \'/Applications/Red5/webapps/messageRecorder/streams/audio1236201042853.flv\' -y -f mp3 \'/var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/audio1236201042853,13194,0.mp3\''),(53,85,'video1236279388617.flv','pending',NULL,'2009-03-05 18:56:42','2009-03-05 18:56:42',NULL,NULL),(54,85,'audio1236279626780.flv','pending',NULL,'2009-03-05 19:00:31','2009-03-05 19:00:31',NULL,NULL),(56,85,'audio1236282423431.flv','complete',NULL,'2009-03-05 19:47:09','2009-03-05 19:47:10','ffmpeg -i $input_file$ -y -f mp3 -ab 192k $output_file$','ffmpeg -i \'/Applications/Red5/webapps/messageRecorder/streams/audio1236282423431.flv\' -y -f mp3 -ab 192k \'/var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/audio1236282423431,4222,0.mp3\''),(57,85,'video1236665522745.flv','complete',NULL,'2009-03-10 06:12:15','2009-03-10 06:12:20',NULL,NULL),(59,85,'audio1237679511169.flv','complete',NULL,'2009-03-21 23:51:56','2009-03-21 23:51:58','ffmpeg -i $input_file$ -y -f mp3 -ab 192k $output_file$','ffmpeg -i \'/Applications/Red5/webapps/messageRecorder/streams/audio1237679511169.flv\' -y -f mp3 -ab 192k \'/var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/audio1237679511169,4222,0.mp3\''),(60,88,'audio1238098393629.flv','complete',NULL,'2009-03-26 20:13:23','2009-03-26 20:13:24','ffmpeg -i $input_file$ -y -f mp3 -ab 192k $output_file$','ffmpeg -i \'/Applications/Red5/webapps/messageRecorder/streams/audio1238098393629.flv\' -y -f mp3 -ab 192k \'/var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/audio1238098393629,4222,0.mp3\''),(61,88,'video_1241803571225.flv','complete',NULL,'2009-05-08 17:26:29','2009-05-08 17:26:31',NULL,NULL),(62,88,'video_1241803694644.flv','complete',NULL,'2009-05-08 17:28:32','2009-05-08 17:28:33',NULL,NULL),(63,88,'video_1241803822695.flv','complete',NULL,'2009-05-08 17:30:33','2009-05-08 17:30:34',NULL,NULL),(64,88,'audio_1241804118842.flv','complete',NULL,'2009-05-08 17:35:29','2009-05-08 17:35:31','ffmpeg -i $input_file$ -y -f mp3 -ab 192k $output_file$','ffmpeg -i \'/Applications/Red5/webapps/messageRecorder/streams/audio_1241804118842.flv\' -y -f mp3 -ab 192k \'/var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/audio_1241804118842,4222,0.mp3\''),(65,88,'audio_1242156567109.flv','complete',NULL,'2009-05-12 19:29:43','2009-05-12 19:29:45','ffmpeg -i $input_file$ -y -f mp3 -ab 192k $output_file$','ffmpeg -i \'/Applications/Red5/webapps/messageRecorder/streams/audio_1242156567109.flv\' -y -f mp3 -ab 192k \'/var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/audio_1242156567109,4222,0.mp3\''),(66,88,'video_1242245128315.flv','pending',NULL,'2009-05-13 20:05:41','2009-05-13 20:05:41',NULL,NULL),(67,88,'video_1242247422779.flv','pending',NULL,'2009-05-13 20:44:05','2009-05-13 20:44:05',NULL,NULL),(68,88,'video_1242259943728.flv','pending',NULL,'2009-05-14 00:12:37','2009-05-14 00:12:37',NULL,NULL),(69,88,'video_1242260366447.flv','pending',NULL,'2009-05-14 00:19:43','2009-05-14 00:19:43',NULL,NULL),(70,88,'video_1242261311345.flv','error','ActiveRecord::AssociationTypeMismatch: Recording expected, got TrueClass','2009-05-14 00:35:31','2009-05-14 00:35:33',NULL,NULL),(71,88,'video_1242262079521.flv','error','ActiveRecord::AssociationTypeMismatch: Recording expected, got TrueClass','2009-05-14 00:48:19','2009-05-14 00:48:20',NULL,NULL),(72,88,'video_1242262670609.flv','error','ActiveRecord::AssociationTypeMismatch: Recording expected, got TrueClass','2009-05-14 00:57:58','2009-05-14 00:57:58',NULL,NULL),(73,88,'video_1242262670609.flv','error','ActiveRecord::AssociationTypeMismatch: Recording expected, got TrueClass','2009-05-14 00:58:01','2009-05-14 00:58:02',NULL,NULL),(74,88,'video_1242264400700.flv','error','ActiveRecord::AssociationTypeMismatch: Recording expected, got TrueClass','2009-05-14 01:26:53','2009-05-14 01:26:54',NULL,NULL),(75,88,'video_1242264451612.flv','error','ActiveRecord::AssociationTypeMismatch: Recording expected, got TrueClass','2009-05-14 01:27:39','2009-05-14 01:27:40',NULL,NULL),(76,88,'video_1242265161038.flv','complete',NULL,'2009-05-14 01:39:30','2009-05-14 01:39:36',NULL,NULL),(77,88,'audio_1242265314145.flv','error','ActiveRecord::AssociationTypeMismatch: Recording expected, got TrueClass','2009-05-14 01:42:01','2009-05-14 01:42:02','ffmpeg -i $input_file$ -y -f mp3 -ab 128k $output_file$','ffmpeg -i \'/Applications/Red5/webapps/messageRecorder/streams/audio_1242265314145.flv\' -y -f mp3 -ab 128k \'/var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/audio_1242265314145,5090,0.mp3\'');
/*!40000 ALTER TABLE `recordings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `regions` (
  `id` int(11) NOT NULL auto_increment,
  `country_id` int(11) NOT NULL,
  `group` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `abbreviation` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4366 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
INSERT INTO `regions` VALUES (1,20,NULL,'Canillo','002'),(2,20,NULL,'Encamp','003'),(3,20,NULL,'La Massana','004'),(4,20,NULL,'Ordino','005'),(5,20,NULL,'Sant JuliÃ  de LÃ²ria','006'),(6,20,NULL,'Andorra la Vella','007'),(7,20,NULL,'Escaldes-Engordany','008'),(8,784,NULL,'AbÅ« È¤aby','AZ'),(9,784,NULL,'AjmÄnAjmÄn','AJ'),(10,784,NULL,'Al Fujayrah','FU'),(11,784,NULL,'Ash ShÄriqah','SH'),(12,784,NULL,'Dubayy','DU'),(13,784,NULL,'Ra\'s al Khaymah','RK'),(14,784,NULL,'Umm al Qaywayn','UQ'),(15,4,NULL,'BadakhshÄn','BDS'),(16,4,NULL,'BÄdghÄ«s','BDG'),(17,4,NULL,'BaghlÄn','BGL'),(18,4,NULL,'Balkh','BAL'),(19,4,NULL,'BÄmÄ«Än','BAM'),(20,4,NULL,'DÄykondÄ«','DAY'),(21,4,NULL,'FarÄh','FRA'),(22,4,NULL,'FÄryÄb','FYB'),(23,4,NULL,'GhaznÄ«','GHA'),(24,4,NULL,'Ghowr','GHO'),(25,4,NULL,'Helmand','HEL'),(26,4,NULL,'HerÄt','HER'),(27,4,NULL,'JowzjÄn','JOW'),(28,4,NULL,'KÄbul','KAB'),(29,4,NULL,'KandahÄr','KAN'),(30,4,NULL,'KÄpÄ«sÄ','KAP'),(31,4,NULL,'Khowst','KHO'),(32,4,NULL,'Konar','KNR'),(33,4,NULL,'Kondoz','KDZ'),(34,4,NULL,'LaghmÄn','LAG'),(35,4,NULL,'Lowgar','LOW'),(36,4,NULL,'NangrahÄr','NAN'),(37,4,NULL,'NÄ«mrÅ«z','NIM'),(38,4,NULL,'NÅ«restÄn','NUR'),(39,4,NULL,'OrÅ«zgÄn','ORU'),(40,4,NULL,'PanjshÄ«r','PAN'),(41,4,NULL,'PaktÄ«Ä','PIA'),(42,4,NULL,'PaktÄ«kÄ','PKA'),(43,4,NULL,'ParwÄn','PAR'),(44,4,NULL,'SamangÄn','SAM'),(45,4,NULL,'Sar-e Pol','SAR'),(46,4,NULL,'TakhÄr','TAK'),(47,4,NULL,'Wardak','WAR'),(48,4,NULL,'ZÄbol','ZAB'),(49,28,NULL,'Saint George','003'),(50,28,NULL,'Saint John','004'),(51,28,NULL,'Saint Mary','005'),(52,28,NULL,'Saint Paul','006'),(53,28,NULL,'Saint Peter','007'),(54,28,NULL,'Saint Philip','008'),(55,28,NULL,'Barbuda','010'),(56,8,NULL,'Berat','BR'),(57,8,NULL,'BulqizÃ«','BU'),(58,8,NULL,'DelvinÃ«','DL'),(59,8,NULL,'Devoll','DV'),(60,8,NULL,'DibÃ«r','DI'),(61,8,NULL,'DurrÃ«s','DR'),(62,8,NULL,'Elbasan','EL'),(63,8,NULL,'Fier','FR'),(64,8,NULL,'Gramsh','GR'),(65,8,NULL,'GjirokastÃ«r','GJ'),(66,8,NULL,'Has','HA'),(67,8,NULL,'KavajÃ«','KA'),(68,8,NULL,'KolonjÃ«','ER'),(69,8,NULL,'KorÃ§Ã«','KO'),(70,8,NULL,'KrujÃ«','KR'),(71,8,NULL,'KuÃ§ovÃ«','KC'),(72,8,NULL,'KukÃ«s','KU'),(73,8,NULL,'Kurbin','KB'),(74,8,NULL,'LezhÃ«','LE'),(75,8,NULL,'Librazhd','LB'),(76,8,NULL,'LushnjÃ«','LU'),(77,8,NULL,'MalÃ«si e Madhe','MM'),(78,8,NULL,'MallakastÃ«r','MK'),(79,8,NULL,'Mat','MT'),(80,8,NULL,'MirditÃ«','MR'),(81,8,NULL,'Peqin','PQ'),(82,8,NULL,'PÃ«rmet','PR'),(83,8,NULL,'Pogradec','PG'),(84,8,NULL,'PukÃ«','PU'),(85,8,NULL,'SarandÃ«','SR'),(86,8,NULL,'Skrapar','SK'),(87,8,NULL,'ShkodÃ«r','SH'),(88,8,NULL,'TepelenÃ«','TE'),(89,8,NULL,'TiranÃ«','TR'),(90,8,NULL,'TropojÃ«','TP'),(91,8,NULL,'VlorÃ«','VL'),(92,51,NULL,'Erevan','ER'),(93,51,NULL,'Aragacotn','AG'),(94,51,NULL,'Ararat','AR'),(95,51,NULL,'Armavir','AV'),(96,51,NULL,'Gegarkunik','GR'),(97,51,NULL,'Kotayk','KT'),(98,51,NULL,'Lory','LO'),(99,51,NULL,'Sirak','SH'),(100,51,NULL,'Syunik','SU'),(101,51,NULL,'Tavus','TV'),(102,51,NULL,'Vayoc Jor','VD'),(103,24,NULL,'Bengo','BGO'),(104,24,NULL,'Benguela','BGU'),(105,24,NULL,'BiÃ©','BIE'),(106,24,NULL,'Cabinda','CAB'),(107,24,NULL,'Cuando-Cubango','CCU'),(108,24,NULL,'Cuanza Norte','CNO'),(109,24,NULL,'Cuanza Sul','CUS'),(110,24,NULL,'Cunene','CNN'),(111,24,NULL,'Huambo','HUA'),(112,24,NULL,'HuÃ­la','HUI'),(113,24,NULL,'Luanda','LUA'),(114,24,NULL,'Lunda Norte','LNO'),(115,24,NULL,'Lunda Sul','LSU'),(116,24,NULL,'Malange','MAL'),(117,24,NULL,'Moxico','MOX'),(118,24,NULL,'Namibe','NAM'),(119,24,NULL,'UÃ­ge','UIG'),(120,24,NULL,'Zaire','ZAI'),(121,32,NULL,'Capital federal','C'),(122,32,NULL,'Buenos Aires','B'),(123,32,NULL,'Catamarca','K'),(124,32,NULL,'Cordoba','X'),(125,32,NULL,'Corrientes','W'),(126,32,NULL,'Chaco','H'),(127,32,NULL,'Chubut','U'),(128,32,NULL,'Entre Rios','E'),(129,32,NULL,'Formosa','P'),(130,32,NULL,'Jujuy','Y'),(131,32,NULL,'La Pampa','L'),(132,32,NULL,'Mendoza','M'),(133,32,NULL,'Misiones','N'),(134,32,NULL,'Neuquen','Q'),(135,32,NULL,'Rio Negro','R'),(136,32,NULL,'Salta','A'),(137,32,NULL,'San Juan','J'),(138,32,NULL,'San Luis','D'),(139,32,NULL,'Santa Cruz','Z'),(140,32,NULL,'Santa Fe','S'),(141,32,NULL,'Santiago del Estero','G'),(142,32,NULL,'Tierra del Fuego','V'),(143,32,NULL,'Tucuman','T'),(144,40,NULL,'Burgenland','1'),(145,40,NULL,'KÃ¤rnten','2'),(146,40,NULL,'NiederÃ¶sterreich','3'),(147,40,NULL,'OberÃ¶sterreich','4'),(148,40,NULL,'Salzburg','5'),(149,40,NULL,'Steiermark','6'),(150,40,NULL,'Tirol','7'),(151,40,NULL,'Vorarlberg','8'),(152,40,NULL,'Wien','9'),(153,36,NULL,'New South Wales','NSW'),(154,36,NULL,'Queensland','QLD'),(155,36,NULL,'South Australia','SA'),(156,36,NULL,'Tasmania','TAS'),(157,36,NULL,'Victoria','VIC'),(158,36,NULL,'Western Australia','WA'),(159,36,NULL,'Australian Capital Territory','ACT'),(160,36,NULL,'Northern Territory','NT'),(161,31,NULL,'Æli BayramlÄ±','AB'),(162,31,NULL,'BakÄ±','BA'),(163,31,NULL,'GÉ™ncÉ™','GA'),(164,31,NULL,'LÉ™nkÉ™ran','LA'),(165,31,NULL,'MingÉ™Ã§evir','MI'),(166,31,NULL,'Naftalan','NA'),(167,31,NULL,'ÅžÉ™ki','SA'),(168,31,NULL,'SumqayÄ±t','SM'),(169,31,NULL,'ÅžuÅŸa','SS'),(170,31,NULL,'XankÉ™ndi','XA'),(171,31,NULL,'Yevlax','YE'),(172,31,NULL,'AbÅŸeron','ABS'),(173,31,NULL,'AÄŸcabÉ™di','AGC'),(174,31,NULL,'AÄŸdam','AGM'),(175,31,NULL,'AÄŸdaÅŸ','AGS'),(176,31,NULL,'AÄŸstafa','AGA'),(177,31,NULL,'AÄŸsu','AGU'),(178,31,NULL,'Astara','AST'),(179,31,NULL,'BabÉ™k','BAB'),(180,31,NULL,'BalakÉ™n','BAL'),(181,31,NULL,'BÉ™rdÉ™','BAR'),(182,31,NULL,'BeylÉ™qan','BEY'),(183,31,NULL,'BilÉ™suvar','BIL'),(184,31,NULL,'CÉ™brayÄ±l','CAB'),(185,31,NULL,'CÉ™lilabab','CAL'),(186,31,NULL,'Culfa','CUL'),(187,31,NULL,'DaÅŸkÉ™sÉ™n','DAS'),(188,31,NULL,'DÉ™vÉ™Ã§i','DAV'),(189,31,NULL,'FÃ¼zuli','FUZ'),(190,31,NULL,'GÉ™dÉ™bÉ™y','GAD'),(191,31,NULL,'Goranboy','GOR'),(192,31,NULL,'GÃ¶yÃ§ay','GOY'),(193,31,NULL,'HacÄ±qabul','HAC'),(194,31,NULL,'Ä°miÅŸli','IMI'),(195,31,NULL,'Ä°smayÄ±llÄ±','ISM'),(196,31,NULL,'KÉ™lbÉ™cÉ™r','KAL'),(197,31,NULL,'KÃ¼rdÉ™mir','KUR'),(198,31,NULL,'LaÃ§Ä±n','LAC'),(199,31,NULL,'LÉ™nkÉ™ran','LAN'),(200,31,NULL,'Lerik','LER'),(201,31,NULL,'MasallÄ±','MAS'),(202,31,NULL,'NeftÃ§ala','NEF'),(203,31,NULL,'OÄŸuz','OGU'),(204,31,NULL,'Ordubad','ORD'),(205,31,NULL,'QÉ™bÉ™lÉ™','QAB'),(206,31,NULL,'Qax','QAX'),(207,31,NULL,'Qazax','QAZ'),(208,31,NULL,'Qobustan','QOB'),(209,31,NULL,'Quba','QBA'),(210,31,NULL,'QubadlÄ±','QBI'),(211,31,NULL,'Qusar','QUS'),(212,31,NULL,'SaatlÄ±','SAT'),(213,31,NULL,'Sabirabad','SAB'),(214,31,NULL,'SÉ™dÉ™rÉ™k','SAD'),(215,31,NULL,'Åžahbuz','SAH'),(216,31,NULL,'ÅžÉ™ki','SAK'),(217,31,NULL,'Salyan','SAL'),(218,31,NULL,'ÅžamaxÄ±','SMI'),(219,31,NULL,'ÅžÉ™mkir','SKR'),(220,31,NULL,'Samux','SMX'),(221,31,NULL,'ÅžÉ™rur','SAR'),(222,31,NULL,'SiyÉ™zÉ™n','SIY'),(223,31,NULL,'ÅžuÅŸa','SUS'),(224,31,NULL,'TÉ™rtÉ™r','TAR'),(225,31,NULL,'Tovuz','TOV'),(226,31,NULL,'Ucar','UCA'),(227,31,NULL,'XaÃ§maz','XAC'),(228,31,NULL,'Xanlar','XAN'),(229,31,NULL,'XÄ±zÄ±','XIZ'),(230,31,NULL,'XocalÄ±','XCI'),(231,31,NULL,'XocavÉ™nd','XVD'),(232,31,NULL,'YardÄ±mlÄ±','YAR'),(233,31,NULL,'Yevlax','YEV'),(234,31,NULL,'ZÉ™ngilan','ZAN'),(235,31,NULL,'Zaqatala','ZAQ'),(236,31,NULL,'ZÉ™rdab','ZAR'),(237,70,NULL,'Federacija Bosna i Hercegovina','BIH'),(238,70,NULL,'Republika Srpska','SRP'),(239,52,NULL,'Christ Church','001'),(240,52,NULL,'Saint Andrew','002'),(241,52,NULL,'Saint George','003'),(242,52,NULL,'Saint James','004'),(243,52,NULL,'Saint John','005'),(244,52,NULL,'Saint Joseph','006'),(245,52,NULL,'Saint Lucy','007'),(246,52,NULL,'Saint Michael','008'),(247,52,NULL,'Saint Peter','009'),(248,52,NULL,'Saint Philip','010'),(249,52,NULL,'Saint Thomas','011'),(250,50,NULL,'Bandarban','001'),(251,50,NULL,'Barguna','002'),(252,50,NULL,'Bogra','003'),(253,50,NULL,'Brahmanbaria','004'),(254,50,NULL,'Bagerhat','005'),(255,50,NULL,'Barisal','006'),(256,50,NULL,'Bhola','007'),(257,50,NULL,'Comilla','008'),(258,50,NULL,'Chandpur','009'),(259,50,NULL,'Chittagong','010'),(260,50,NULL,'Cox\'s Bazar','011'),(261,50,NULL,'Chuadanga','012'),(262,50,NULL,'Dhaka','013'),(263,50,NULL,'Dinajpur','014'),(264,50,NULL,'Faridpur','015'),(265,50,NULL,'Feni','016'),(266,50,NULL,'Gopalganj','017'),(267,50,NULL,'Gazipur','018'),(268,50,NULL,'Gaibandha','019'),(269,50,NULL,'Habiganj','020'),(270,50,NULL,'Jamalpur','021'),(271,50,NULL,'Jessore','022'),(272,50,NULL,'Jhenaidah','023'),(273,50,NULL,'Jaipurhat','024'),(274,50,NULL,'Jhalakati','025'),(275,50,NULL,'Kishorganj','026'),(276,50,NULL,'Khulna','027'),(277,50,NULL,'Kurigram','028'),(278,50,NULL,'Khagrachari','029'),(279,50,NULL,'Kushtia','030'),(280,50,NULL,'Lakshmipur','031'),(281,50,NULL,'Lalmonirhat','032'),(282,50,NULL,'Manikganj','033'),(283,50,NULL,'Mymensingh','034'),(284,50,NULL,'Munshiganj','035'),(285,50,NULL,'Madaripur','036'),(286,50,NULL,'Magura','037'),(287,50,NULL,'Moulvibazar','038'),(288,50,NULL,'Meherpur','039'),(289,50,NULL,'Narayanganj','040'),(290,50,NULL,'Netrakona','041'),(291,50,NULL,'Narsingdi','042'),(292,50,NULL,'Narail','043'),(293,50,NULL,'Natore','044'),(294,50,NULL,'Nawabganj','045'),(295,50,NULL,'Nilphamari','046'),(296,50,NULL,'Noakhali','047'),(297,50,NULL,'Naogaon','048'),(298,50,NULL,'Pabna','049'),(299,50,NULL,'Pirojpur','050'),(300,50,NULL,'Patuakhali','051'),(301,50,NULL,'Panchagarh','052'),(302,50,NULL,'Rajbari','053'),(303,50,NULL,'Rajshahi','054'),(304,50,NULL,'Rangpur','055'),(305,50,NULL,'Rangamati','056'),(306,50,NULL,'Sherpur','057'),(307,50,NULL,'Satkhira','058'),(308,50,NULL,'Sirajganj','059'),(309,50,NULL,'Sylhet','060'),(310,50,NULL,'Sunamganj','061'),(311,50,NULL,'Shariatpur','062'),(312,50,NULL,'Tangail','063'),(313,50,NULL,'Thakurgaon','064'),(314,56,NULL,'Antwerpen','VAN'),(315,56,NULL,'Brabant Wallon','WBR'),(316,56,NULL,'Brussels-Capital Region','BRU'),(317,56,NULL,'Hainaut','WHT'),(318,56,NULL,'LiÃ¨ge','WLG'),(319,56,NULL,'Limburg','VLI'),(320,56,NULL,'Luxembourg','WLX'),(321,56,NULL,'Namur','WNA'),(322,56,NULL,'Oost-Vlaanderen','VOV'),(323,56,NULL,'Vlaams-Brabant','VBR'),(324,56,NULL,'West-Vlaanderen','VWV'),(325,854,NULL,'BalÃ©','BAL'),(326,854,NULL,'Bam','BAM'),(327,854,NULL,'Banwa','BAN'),(328,854,NULL,'BazÃ¨ga','BAZ'),(329,854,NULL,'Bougouriba','BGR'),(330,854,NULL,'Boulgou','BLG'),(331,854,NULL,'BoulkiemdÃ©','BLK'),(332,854,NULL,'ComoÃ©','COM'),(333,854,NULL,'Ganzourgou','GAN'),(334,854,NULL,'Gnagna','GNA'),(335,854,NULL,'Gourma','GOU'),(336,854,NULL,'Houet','HOU'),(337,854,NULL,'Ioba','IOB'),(338,854,NULL,'Kadiogo','KAD'),(339,854,NULL,'KÃ©nÃ©dougou','KEN'),(340,854,NULL,'Komondjari','KMD'),(341,854,NULL,'Kompienga','KMP'),(342,854,NULL,'Kossi','KOS'),(343,854,NULL,'KoulpÃ©logo','KOP'),(344,854,NULL,'Kouritenga','KOT'),(345,854,NULL,'KourwÃ©ogo','KOW'),(346,854,NULL,'LÃ©raba','LER'),(347,854,NULL,'Loroum','LOR'),(348,854,NULL,'Mouhoun','MOU'),(349,854,NULL,'Naouri','NAO'),(350,854,NULL,'Namentenga','NAM'),(351,854,NULL,'Nayala','NAY'),(352,854,NULL,'Noumbiel','NOU'),(353,854,NULL,'Oubritenga','OUB'),(354,854,NULL,'Oudalan','OUD'),(355,854,NULL,'PassorÃ©','PAS'),(356,854,NULL,'Poni','PON'),(357,854,NULL,'SanguiÃ©','SNG'),(358,854,NULL,'Sanmatenga','SMT'),(359,854,NULL,'SÃ©no','SEN'),(360,854,NULL,'Sissili','SIS'),(361,854,NULL,'Soum','SOM'),(362,854,NULL,'Sourou','SOR'),(363,854,NULL,'Tapoa','TAP'),(364,854,NULL,'Tui','TUI'),(365,854,NULL,'Yagha','YAG'),(366,854,NULL,'Yatenga','YAT'),(367,854,NULL,'Ziro','ZIR'),(368,854,NULL,'Zondoma','ZON'),(369,854,NULL,'ZoundwÃ©ogo','ZOU'),(370,100,NULL,'Blagoevgrad','001'),(371,100,NULL,'Burgas','002'),(372,100,NULL,'Varna','003'),(373,100,NULL,'Veliko Tarnovo','004'),(374,100,NULL,'Vidin','005'),(375,100,NULL,'Vratsa','006'),(376,100,NULL,'Gabrovo','007'),(377,100,NULL,'Dobrich','008'),(378,100,NULL,'Kardzhali','009'),(379,100,NULL,'Kyustendil','010'),(380,100,NULL,'Lovech','011'),(381,100,NULL,'Montana','012'),(382,100,NULL,'Pazardzhik','013'),(383,100,NULL,'Pernik','014'),(384,100,NULL,'Pleven','015'),(385,100,NULL,'Plovdiv','016'),(386,100,NULL,'Razgrad','017'),(387,100,NULL,'Ruse','018'),(388,100,NULL,'Silistra','019'),(389,100,NULL,'Sliven','020'),(390,100,NULL,'Smolyan','021'),(391,100,NULL,'Sofia-Grad','022'),(392,100,NULL,'Sofia','023'),(393,100,NULL,'Stara Zagora','024'),(394,100,NULL,'Targovishte','025'),(395,100,NULL,'Haskovo','026'),(396,100,NULL,'Shumen','027'),(397,100,NULL,'Yambol','028'),(398,48,NULL,'Al ManÄmah','013'),(399,48,NULL,'Al JanÅ«bÄ«yah','014'),(400,48,NULL,'Al Muá¸©arraq','015'),(401,48,NULL,'Al WusÅ£Ã¡','016'),(402,48,NULL,'Ash ShamÄlÄ«yah','017'),(403,108,NULL,'Bubanza','BB'),(404,108,NULL,'Bujumbura','BJ'),(405,108,NULL,'Bururi','BR'),(406,108,NULL,'Cankuzo','CA'),(407,108,NULL,'Cibitoke','CI'),(408,108,NULL,'Gitega','GI'),(409,108,NULL,'Karuzi','KR'),(410,108,NULL,'Kayanza','KY'),(411,108,NULL,'Kirundo','KI'),(412,108,NULL,'Makamba','MA'),(413,108,NULL,'Muramvya','MU'),(414,108,NULL,'Mwaro','MW'),(415,108,NULL,'Ngozi','NG'),(416,108,NULL,'Rutana','RT'),(417,108,NULL,'Ruyigi','RY'),(418,204,NULL,'Alibori','AL'),(419,204,NULL,'Atakora','AK'),(420,204,NULL,'Atlantique','AQ'),(421,204,NULL,'Borgou','BO'),(422,204,NULL,'Collines','CO'),(423,204,NULL,'Donga','DO'),(424,204,NULL,'Kouffo','KO'),(425,204,NULL,'Littoral','LI'),(426,204,NULL,'Mono','MO'),(427,204,NULL,'OuÃ©mÃ©','OU'),(428,204,NULL,'Plateau','PL'),(429,204,NULL,'Zou','ZO'),(430,96,NULL,'Belait','BE'),(431,96,NULL,'Brunei-Muara','BM'),(432,96,NULL,'Temburong','TE'),(433,96,NULL,'Tutong','TU'),(434,68,NULL,'Cochabamba','C'),(435,68,NULL,'Chuquisaca','H'),(436,68,NULL,'El Beni','B'),(437,68,NULL,'La Paz','L'),(438,68,NULL,'Oruro','O'),(439,68,NULL,'Pando','N'),(440,68,NULL,'PotosÃ­','P'),(441,68,NULL,'Santa Cruz','S'),(442,68,NULL,'Tarija','T'),(443,76,NULL,'Acre','AC'),(444,76,NULL,'Alagoas','AL'),(445,76,NULL,'Amazonas','AM'),(446,76,NULL,'AmapÃ¡','AP'),(447,76,NULL,'Bahia','BA'),(448,76,NULL,'CearÃ¡','CE'),(449,76,NULL,'EspÃ­rito Santo','ES'),(450,76,NULL,'Fernando de Noronha','FN'),(451,76,NULL,'GoiÃ¡s','GO'),(452,76,NULL,'MaranhÃ£o','MA'),(453,76,NULL,'Minas Gerais','MG'),(454,76,NULL,'Mato Grosso do Sul','MS'),(455,76,NULL,'Mato Grosso','MT'),(456,76,NULL,'ParÃ¡','PA'),(457,76,NULL,'ParaÃ­ba','PB'),(458,76,NULL,'Pernambuco','PE'),(459,76,NULL,'PiauÃ­','PI'),(460,76,NULL,'ParanÃ¡','PR'),(461,76,NULL,'Rio de Janeiro','RJ'),(462,76,NULL,'Rio Grande do Norte','RN'),(463,76,NULL,'RondÃ´nia','RO'),(464,76,NULL,'Roraima','RR'),(465,76,NULL,'Rio Grande do Sul','RS'),(466,76,NULL,'Santa Catarina','SC'),(467,76,NULL,'Sergipe','SE'),(468,76,NULL,'SÃ¢o Paulo','SP'),(469,76,NULL,'Tocantins','TO'),(470,76,NULL,'Distrito Federal','DF'),(471,44,NULL,'Acklins and Crooked Islands','AC'),(472,44,NULL,'Bimini','BI'),(473,44,NULL,'Cat Island','CI'),(474,44,NULL,'Exuma','EX'),(475,44,NULL,'Freeport','FP'),(476,44,NULL,'Fresh Creek','FC'),(477,44,NULL,'Governors Harbours Harbour','GH'),(478,44,NULL,'Green Turtle Cay','GT'),(479,44,NULL,'Harbour Island','HI'),(480,44,NULL,'High Rock','HR'),(481,44,NULL,'Inagua','IN'),(482,44,NULL,'Kemps Bay','KB'),(483,44,NULL,'Long Island','LI'),(484,44,NULL,'Marsh Harbour','MH'),(485,44,NULL,'Mayaguana','MG'),(486,44,NULL,'New Providence','NP'),(487,44,NULL,'Nicholls Town and Berry Islands','NB'),(488,44,NULL,'Ragged Island','RI'),(489,44,NULL,'Rock Sound','RS'),(490,44,NULL,'Sandy Point','SP'),(491,44,NULL,'San Salvador and Rum Cay','SR'),(492,64,NULL,'Paro','011'),(493,64,NULL,'Chhukha','012'),(494,64,NULL,'Ha','013'),(495,64,NULL,'Samtee','014'),(496,64,NULL,'Thimphu','015'),(497,64,NULL,'Tsirang','021'),(498,64,NULL,'Dagana','022'),(499,64,NULL,'Punakha','023'),(500,64,NULL,'Wangdue Phodrang','024'),(501,64,NULL,'Sarpang','031'),(502,64,NULL,'Trongsa','032'),(503,64,NULL,'Bumthang','033'),(504,64,NULL,'Zhemgang','034'),(505,64,NULL,'Trashigang','041'),(506,64,NULL,'Monggar','042'),(507,64,NULL,'Pemagatshel','043'),(508,64,NULL,'Lhuentse','044'),(509,64,NULL,'Samdrup Jongkha','045'),(510,64,NULL,'Gasa','GA'),(511,64,NULL,'Trashi Yangtse','TY'),(512,72,NULL,'Central','CE'),(513,72,NULL,'Ghanzi','GH'),(514,72,NULL,'Kgalagadi','KG'),(515,72,NULL,'Kgatleng','KL'),(516,72,NULL,'Kweneng','KW'),(517,72,NULL,'Ngamiland','NG'),(518,72,NULL,'North-East','NE'),(519,72,NULL,'North-West','NW'),(520,72,NULL,'South-East','SE'),(521,72,NULL,'Southern','SO'),(522,112,NULL,'BrÃ¨sckaja','BR'),(523,112,NULL,'Homel\'skaja','HO'),(524,112,NULL,'Hrodzenskaja','HR'),(525,112,NULL,'MahilÃ«uskaja','MA'),(526,112,NULL,'Minskaja','MI'),(527,112,NULL,'Vicebskaja','VI'),(528,84,NULL,'Belize','BZ'),(529,84,NULL,'Cayo','CY'),(530,84,NULL,'Corozal','CZL'),(531,84,NULL,'Orange Walk','OW'),(532,84,NULL,'Stann Creek','SC'),(533,84,NULL,'Toledo','TOL'),(534,124,NULL,'Alberta','AB'),(535,124,NULL,'British Columbia','BC'),(536,124,NULL,'Manitoba','MB'),(537,124,NULL,'New Brunswick','NB'),(538,124,NULL,'Newfoundland and Labrador','NL'),(539,124,NULL,'Nova Scotia','NS'),(540,124,NULL,'Ontario','ON'),(541,124,NULL,'Prince Edward Island','PE'),(542,124,NULL,'Quebec','QC'),(543,124,NULL,'Saskatchewan','SK'),(544,124,NULL,'Northwest Territories','NT'),(545,124,NULL,'Nunavut','NU'),(546,124,NULL,'Yukon Territory','YT'),(547,180,NULL,'Kinshasa','KN'),(548,180,NULL,'Bandundu','BN'),(549,180,NULL,'Bas-Congo','BC'),(550,180,NULL,'Ã‰quateur','EQ'),(551,180,NULL,'Haut-Congo','HC'),(552,180,NULL,'Kasai-Occidental','KW'),(553,180,NULL,'Kasai-Oriental','KE'),(554,180,NULL,'Katanga','KA'),(555,180,NULL,'Maniema','MA'),(556,180,NULL,'Nord-Kivu','NK'),(557,180,NULL,'Orientale','OR'),(558,180,NULL,'Sud-Kivu','SK'),(559,140,NULL,'Bamingui-Bangoran','BB'),(560,140,NULL,'Basse-Kotto','BK'),(561,140,NULL,'Haute-Kotto','HK'),(562,140,NULL,'Haut-Mbomou','HM'),(563,140,NULL,'KÃ©mo','KG'),(564,140,NULL,'Lobaye','LB'),(565,140,NULL,'MambÃ©rÃ©-KadÃ©Ã¯','HS'),(566,140,NULL,'Mbomou','MB'),(567,140,NULL,'Nana-MambÃ©rÃ©','NM'),(568,140,NULL,'Ombella-Mpokopoko','MP'),(569,140,NULL,'Ouaka','UK'),(570,140,NULL,'Ouham','AC'),(571,140,NULL,'Ouham-PendÃ©','OP'),(572,140,NULL,'Vakaga','VR'),(573,140,NULL,'Nana-GrÃ©bizi','KB'),(574,140,NULL,'Sangha-MbaÃ©rÃ©','SE'),(575,140,NULL,'Bangui','BGF'),(576,178,NULL,'LÃ©koumou','002'),(577,178,NULL,'Kouilou','005'),(578,178,NULL,'Likouala','007'),(579,178,NULL,'Cuvette','008'),(580,178,NULL,'Niari','009'),(581,178,NULL,'Bouenza','011'),(582,178,NULL,'Pool','012'),(583,178,NULL,'Sangha','013'),(584,178,NULL,'Plateaux','014'),(585,178,NULL,'Cuvette-Ouest','015'),(586,178,NULL,'Brazzaville','BZV'),(587,756,NULL,'Aargau','AG'),(588,756,NULL,'Appenzell Innerrhoden','AI'),(589,756,NULL,'Appenzell Ausserrhoden','AR'),(590,756,NULL,'Bern','BE'),(591,756,NULL,'Basel-Landschaft','BL'),(592,756,NULL,'Basel-Stadt','BS'),(593,756,NULL,'Fribourg','FR'),(594,756,NULL,'GenÃ¨ve','GE'),(595,756,NULL,'Glarus','GL'),(596,756,NULL,'GraubÃ¼nden','GR'),(597,756,NULL,'Jura','JU'),(598,756,NULL,'Luzern','LU'),(599,756,NULL,'NeuchÃ¢tel','NE'),(600,756,NULL,'Nidwalden','NW'),(601,756,NULL,'Obwalden','OW'),(602,756,NULL,'Sankt Gallen','SG'),(603,756,NULL,'Schaffhausen','SH'),(604,756,NULL,'Solothurn','SO'),(605,756,NULL,'Schwyz','SZ'),(606,756,NULL,'Thurgau','TG'),(607,756,NULL,'Ticino','TI'),(608,756,NULL,'Uri','UR'),(609,756,NULL,'Vaud','VD'),(610,756,NULL,'Valais','VS'),(611,756,NULL,'Zug','ZG'),(612,756,NULL,'ZÃ¼rich','ZH'),(613,384,NULL,'Lagunes','001'),(614,384,NULL,'Haut-Sassandra','002'),(615,384,NULL,'Savanes','003'),(616,384,NULL,'VallÃ©e du Bandama','004'),(617,384,NULL,'Moyen-ComoÃ©','005'),(618,384,NULL,'18 Montagnes','006'),(619,384,NULL,'Lacs','007'),(620,384,NULL,'Zanzan','008'),(621,384,NULL,'Bas-Sassandra','009'),(622,384,NULL,'DenguÃ©lÃ©','010'),(623,384,NULL,'Nzi-ComoÃ©','011'),(624,384,NULL,'MarahouÃ©','012'),(625,384,NULL,'Sud-ComoÃ©','013'),(626,384,NULL,'Worodouqou','014'),(627,384,NULL,'Sud-Bandama','015'),(628,384,NULL,'AgnÃ©bi','016'),(629,384,NULL,'Bafing','017'),(630,384,NULL,'Fromager','018'),(631,384,NULL,'Moyen-Cavally','019'),(632,152,NULL,'AisÃ©n del General Carlos IbÃ¡Ã±ez del Campo','AI'),(633,152,NULL,'Antofagasta','AN'),(634,152,NULL,'AraucanÃ­a','AR'),(635,152,NULL,'Atacama','AT'),(636,152,NULL,'BÃ­o-BÃ­o','BI'),(637,152,NULL,'Coquimbo','CO'),(638,152,NULL,'Libertador General Bernardo O\'Higgins','LI'),(639,152,NULL,'Los Lagos','LL'),(640,152,NULL,'Magallanes y AntÃ¡rtica Chilena','MA'),(641,152,NULL,'Maule','ML'),(642,152,NULL,'RegiÃ³n Metropolitana de Santiago','RM'),(643,152,NULL,'TarapacÃ¡','TA'),(644,152,NULL,'ValparaÃ­so','VS'),(645,120,NULL,'Adamaoua','AD'),(646,120,NULL,'Centre','CE'),(647,120,NULL,'East','ES'),(648,120,NULL,'Far North','EN'),(649,120,NULL,'Littoral','LT'),(650,120,NULL,'North','NO'),(651,120,NULL,'North-West','NW'),(652,120,NULL,'South','SU'),(653,120,NULL,'South-West','SW'),(654,120,NULL,'West','OU'),(655,156,NULL,'Beijing','011'),(656,156,NULL,'Tianjin','012'),(657,156,NULL,'Hebei','013'),(658,156,NULL,'Shanxi','014'),(659,156,NULL,'Nei Mongol','015'),(660,156,NULL,'Liaoning','021'),(661,156,NULL,'Jilin','022'),(662,156,NULL,'Heilongjiang','023'),(663,156,NULL,'Shanghai','031'),(664,156,NULL,'Jiangsu','032'),(665,156,NULL,'Zhejiang','033'),(666,156,NULL,'Anhui','034'),(667,156,NULL,'Fujian','035'),(668,156,NULL,'Jiangxi','036'),(669,156,NULL,'Shandong','037'),(670,156,NULL,'Henan','041'),(671,156,NULL,'Hubei','042'),(672,156,NULL,'Hunan','043'),(673,156,NULL,'Guangdong','044'),(674,156,NULL,'Guangxi','045'),(675,156,NULL,'Hainan','046'),(676,156,NULL,'Chongqing','050'),(677,156,NULL,'Sichuan','051'),(678,156,NULL,'Guizhou','052'),(679,156,NULL,'Yunnan','053'),(680,156,NULL,'Xizang','054'),(681,156,NULL,'Shaanxi','061'),(682,156,NULL,'Gansu','062'),(683,156,NULL,'Qinghai','063'),(684,156,NULL,'Ningxia','064'),(685,156,NULL,'Xinjiang','065'),(686,156,NULL,'Taiwan','071'),(687,156,NULL,'Xianggang','091'),(688,156,NULL,'Aomen','092'),(689,170,NULL,'Distrito Capital de BogotÃ¡','DC'),(690,170,NULL,'Amazonas','AMA'),(691,170,NULL,'Antioquia','ANT'),(692,170,NULL,'Arauca','ARA'),(693,170,NULL,'AtlÃ¡ntico','ATL'),(694,170,NULL,'BolÃ­var','BOL'),(695,170,NULL,'BoyacÃ¡','BOY'),(696,170,NULL,'Caldas','CAL'),(697,170,NULL,'CaquetÃ¡','CAQ'),(698,170,NULL,'Casanare','CAS'),(699,170,NULL,'Cauca','CAU'),(700,170,NULL,'Cesar','CES'),(701,170,NULL,'ChocÃ³','CHO'),(702,170,NULL,'CÃ³rdoba','COR'),(703,170,NULL,'Cundinamarca','CUN'),(704,170,NULL,'GuainÃ­a','GUA'),(705,170,NULL,'Guaviare','GUV'),(706,170,NULL,'Huila','HUI'),(707,170,NULL,'La Guajira','LAG'),(708,170,NULL,'Magdalena','MAG'),(709,170,NULL,'Meta','MET'),(710,170,NULL,'NariÃ±o','NAR'),(711,170,NULL,'Norte de Santander','NSA'),(712,170,NULL,'Putumayo','PUT'),(713,170,NULL,'QuindÃ­o','QUI'),(714,170,NULL,'Risaralda','RIS'),(715,170,NULL,'San AndrÃ©s, Providencia y Santa Catalina','SAP'),(716,170,NULL,'Santander','SAN'),(717,170,NULL,'Sucre','SUC'),(718,170,NULL,'Tolima','TOL'),(719,170,NULL,'Valle del Cauca','VAC'),(720,170,NULL,'VaupÃ©s','VAU'),(721,170,NULL,'Vichada','VID'),(722,188,NULL,'Alajuela','A'),(723,188,NULL,'Cartago','C'),(724,188,NULL,'Guanacaste','G'),(725,188,NULL,'Heredia','H'),(726,188,NULL,'LimÃ³n','L'),(727,188,NULL,'Puntarenas','P'),(728,188,NULL,'San JosÃ©','SJ'),(729,192,NULL,'Pinar del Rio','001'),(730,192,NULL,'La Habana','002'),(731,192,NULL,'Ciudad de La Habana','003'),(732,192,NULL,'Matanzas','004'),(733,192,NULL,'Villa Clara','005'),(734,192,NULL,'Cienfuegos','006'),(735,192,NULL,'Sancti SpÃ­ritus','007'),(736,192,NULL,'Ciego de Ãvila','008'),(737,192,NULL,'CamagÃ¼ey','009'),(738,192,NULL,'Las Tunas','010'),(739,192,NULL,'HolguÃ­n','011'),(740,192,NULL,'Granma','012'),(741,192,NULL,'Santiago de Cuba','013'),(742,192,NULL,'GuantÃ¡namo','014'),(743,192,NULL,'Isla de la Juventud','099'),(744,132,NULL,'Boa Vista','BV'),(745,132,NULL,'Brava','BR'),(746,132,NULL,'Calheta de SÃ£o Miguel','CS'),(747,132,NULL,'Maio','MA'),(748,132,NULL,'Mosteiros','MO'),(749,132,NULL,'PaÃºl','PA'),(750,132,NULL,'Porto Novo','PN'),(751,132,NULL,'Praia','PR'),(752,132,NULL,'Ribeira Grande','RG'),(753,132,NULL,'Sal','SL'),(754,132,NULL,'Santa Catarina','CA'),(755,132,NULL,'Santa Cruz','CR'),(756,132,NULL,'SÃ£o Domingos','SD'),(757,132,NULL,'SÃ£o Filipe','SF'),(758,132,NULL,'SÃ£o Nicolau','SN'),(759,132,NULL,'SÃ£o Vicente','SV'),(760,132,NULL,'Tarrafal','TA'),(761,196,NULL,'LefkosÃ­a','001'),(762,196,NULL,'LemesÃ³s','002'),(763,196,NULL,'LÃ¡rnaka','003'),(764,196,NULL,'AmmÃ³chostos','004'),(765,196,NULL,'PÃ¡fos','005'),(766,196,NULL,'KerÃ½neia','006'),(767,203,NULL,'Praha 1','101'),(768,203,NULL,'Praha 2','102'),(769,203,NULL,'Praha 3','103'),(770,203,NULL,'Praha 4','104'),(771,203,NULL,'Praha 5','105'),(772,203,NULL,'Praha 6','106'),(773,203,NULL,'Praha 7','107'),(774,203,NULL,'Praha 8','108'),(775,203,NULL,'Praha 9','109'),(776,203,NULL,'Praha 10','10A'),(777,203,NULL,'Praha 11','10B'),(778,203,NULL,'Praha 12','10C'),(779,203,NULL,'Praha 13','10D'),(780,203,NULL,'Praha 14','10E'),(781,203,NULL,'Praha 15','10F'),(782,203,NULL,'BeneÅ¡ov','201'),(783,203,NULL,'Beroun','202'),(784,203,NULL,'Kladno','203'),(785,203,NULL,'KolÃ­n','204'),(786,203,NULL,'KutnÃ¡ Hora','205'),(787,203,NULL,'MÄ›lnÃ­k','206'),(788,203,NULL,'MladÃ¡ Boleslav','207'),(789,203,NULL,'Nymburk','208'),(790,203,NULL,'Praha-vÃ½chod','209'),(791,203,NULL,'Praha-zÃ¡pad','20A'),(792,203,NULL,'PÅ™Ã­bram','20B'),(793,203,NULL,'RakovnÃ­k','20C'),(794,203,NULL,'ÄŒeskÃ© BudÄ›jovice','311'),(795,203,NULL,'ÄŒeskÃ½ Krumlov','312'),(796,203,NULL,'JindÅ™ichÅ¯v Hradec','313'),(797,203,NULL,'PÃ­sek','314'),(798,203,NULL,'Prachatice','315'),(799,203,NULL,'Strakonice','316'),(800,203,NULL,'TÃ¡bor','317'),(801,203,NULL,'DomaÅ¾lice','321'),(802,203,NULL,'Klatovy','322'),(803,203,NULL,'PlzeÅˆ-mÄ›sto','323'),(804,203,NULL,'PlzeÅˆ-jih','324'),(805,203,NULL,'PlzeÅˆ-sever','325'),(806,203,NULL,'Rokycany','326'),(807,203,NULL,'Tachov','327'),(808,203,NULL,'Cheb','411'),(809,203,NULL,'Karlovy Vary','412'),(810,203,NULL,'Sokolov','413'),(811,203,NULL,'DÄ›ÄÃ­n','421'),(812,203,NULL,'Chomutov','422'),(813,203,NULL,'LitomÄ›Å™ice','423'),(814,203,NULL,'Louny','424'),(815,203,NULL,'Most','425'),(816,203,NULL,'Teplice','426'),(817,203,NULL,'ÃšstÃ­ nad Labem','427'),(818,203,NULL,'ÄŒeskÃ¡ LÃ­pa','511'),(819,203,NULL,'Jablonec nad Nisou','512'),(820,203,NULL,'Liberec','513'),(821,203,NULL,'Semily','514'),(822,203,NULL,'Hradec KrÃ¡lovÃ©','521'),(823,203,NULL,'JiÄÃ­n','522'),(824,203,NULL,'NÃ¡chod','523'),(825,203,NULL,'Rychnov nad KnÄ›Å¾nou','524'),(826,203,NULL,'Trutnov','525'),(827,203,NULL,'Chrudim','531'),(828,203,NULL,'Pardubice','532'),(829,203,NULL,'Svitavy','533'),(830,203,NULL,'ÃšstÃ­ nad OrlicÃ­','534'),(831,203,NULL,'HavlÃ­ÄkÅ¯v Brod','611'),(832,203,NULL,'Jihlava','612'),(833,203,NULL,'PelhÅ™imov','613'),(834,203,NULL,'TÅ™ebÃ­Ä','614'),(835,203,NULL,'Å½dâ€™Ã¡r nad SÃ¡zavou','615'),(836,203,NULL,'Blansko','621'),(837,203,NULL,'Brno-mÄ›sto','622'),(838,203,NULL,'Brno-venkov','623'),(839,203,NULL,'BÅ™eclav','624'),(840,203,NULL,'HodonÃ­n','625'),(841,203,NULL,'VyÅ¡kov','626'),(842,203,NULL,'Znojmo','627'),(843,203,NULL,'JesenÃ­k','711'),(844,203,NULL,'Olomouc','712'),(845,203,NULL,'ProstÄ•jov','713'),(846,203,NULL,'PÅ™erov','714'),(847,203,NULL,'Å umperk','715'),(848,203,NULL,'KromÄ•Å™Ã­Å¾','721'),(849,203,NULL,'UherskÃ© HradiÅ¡tÄ•','722'),(850,203,NULL,'VsetÃ­n','723'),(851,203,NULL,'ZlÃ­n','724'),(852,203,NULL,'BruntÃ¡l','801'),(853,203,NULL,'FrÃ½dek - MÃ­stek','802'),(854,203,NULL,'KarvinÃ¡','803'),(855,203,NULL,'NovÃ½ JiÄÃ­n','804'),(856,203,NULL,'Opava','805'),(857,203,NULL,'Ostrava - mÄ›sto','806'),(858,276,NULL,'Baden-WÃ¼rttemberg','BW'),(859,276,NULL,'Bayern','BY'),(860,276,NULL,'Bremen','HB'),(861,276,NULL,'Hamburg','HH'),(862,276,NULL,'Hessen','HE'),(863,276,NULL,'Niedersachsen','NI'),(864,276,NULL,'Nordrhein-Westfalen','NW'),(865,276,NULL,'Rheinland-Pfalz','RP'),(866,276,NULL,'Saarland','SL'),(867,276,NULL,'Schleswig-Holstein','SH'),(868,276,NULL,'Berlin','BE'),(869,276,NULL,'Brandenburg','BB'),(870,276,NULL,'Mecklenburg-Vorpommern','MV'),(871,276,NULL,'Sachsen','SN'),(872,276,NULL,'Sachsen-Anhalt','ST'),(873,276,NULL,'ThÃ¼ringen','TH'),(874,262,NULL,'Ali Sabieh','AS'),(875,262,NULL,'Arta','AR'),(876,262,NULL,'Dikhil','DI'),(877,262,NULL,'Obock','OB'),(878,262,NULL,'Tadjourah','TA'),(879,262,NULL,'Djibouti','DJ'),(880,208,NULL,'Copenhagen','015'),(881,208,NULL,'Frederiksborg','020'),(882,208,NULL,'Roskilde','025'),(883,208,NULL,'Western Zealand','030'),(884,208,NULL,'StorstrÃ¸m','035'),(885,208,NULL,'Bornholm','040'),(886,208,NULL,'Funen','042'),(887,208,NULL,'Southern Jutland','050'),(888,208,NULL,'Ribe','055'),(889,208,NULL,'Vejle','060'),(890,208,NULL,'RingkÃ¸bing','065'),(891,208,NULL,'Aarhus','070'),(892,208,NULL,'Viborg','076'),(893,208,NULL,'Northern Jutland','080'),(894,212,NULL,'Saint Peter','001'),(895,212,NULL,'Saint Andrew','002'),(896,212,NULL,'Saint David','003'),(897,212,NULL,'Saint George','004'),(898,212,NULL,'Saint John','005'),(899,212,NULL,'Saint Joseph','006'),(900,212,NULL,'Saint Luke','007'),(901,212,NULL,'Saint Mark','008'),(902,212,NULL,'Saint Patrick','009'),(903,212,NULL,'Saint Paul','010'),(904,214,NULL,'Distrito Nacional (Santo Domingo)','001'),(905,214,NULL,'Azua','002'),(906,214,NULL,'Bahoruco','003'),(907,214,NULL,'Barahona','004'),(908,214,NULL,'DajabÃ³n','005'),(909,214,NULL,'Duarte','006'),(910,214,NULL,'La Estrelleta','007'),(911,214,NULL,'El Seybo','008'),(912,214,NULL,'Espaillat','009'),(913,214,NULL,'Independencia','010'),(914,214,NULL,'La Altagracia','011'),(915,214,NULL,'La Romana','012'),(916,214,NULL,'La Vega','013'),(917,214,NULL,'MarÃ­a Trinidad SÃ¡nchez','014'),(918,214,NULL,'Monte Cristi','015'),(919,214,NULL,'Pedernales','016'),(920,214,NULL,'Peravia','017'),(921,214,NULL,'Puerto Plata','018'),(922,214,NULL,'Salcedo','019'),(923,214,NULL,'SamanÃ¡','020'),(924,214,NULL,'San CristÃ³bal','021'),(925,214,NULL,'San Juan','022'),(926,214,NULL,'San Pedro de MacorÃ­s','023'),(927,214,NULL,'SÃ¡nchez RamÃ­rez','024'),(928,214,NULL,'Santiago','025'),(929,214,NULL,'Santiago RodrÃ­guez','026'),(930,214,NULL,'Valverde','027'),(931,214,NULL,'MonseÃ±or Nouel','028'),(932,214,NULL,'Monte Plata','029'),(933,214,NULL,'Hato Mayor','030'),(934,12,NULL,'Adrar','001'),(935,12,NULL,'Chlef','002'),(936,12,NULL,'Laghouat','003'),(937,12,NULL,'Oum el Bouaghi','004'),(938,12,NULL,'Batna','005'),(939,12,NULL,'BÃ©jaÃ¯a','006'),(940,12,NULL,'Biskra','007'),(941,12,NULL,'BÃ©char','008'),(942,12,NULL,'Blida','009'),(943,12,NULL,'Bouira','010'),(944,12,NULL,'Tamanghasset','011'),(945,12,NULL,'TÃ©bessa','012'),(946,12,NULL,'Tlemcen','013'),(947,12,NULL,'Tiaret','014'),(948,12,NULL,'Tizi Ouzou','015'),(949,12,NULL,'Alger','016'),(950,12,NULL,'Djelfa','017'),(951,12,NULL,'Jijel','018'),(952,12,NULL,'SÃ©tif','019'),(953,12,NULL,'SaÃ¯da','020'),(954,12,NULL,'Skikda','021'),(955,12,NULL,'Sidi Bel AbbÃ¨s','022'),(956,12,NULL,'Annaba','023'),(957,12,NULL,'Guelma','024'),(958,12,NULL,'Constantine','025'),(959,12,NULL,'MÃ©dÃ©a','026'),(960,12,NULL,'Mostaganem','027'),(961,12,NULL,'Msila','028'),(962,12,NULL,'Mascara','029'),(963,12,NULL,'Ouargla','030'),(964,12,NULL,'Oran','031'),(965,12,NULL,'El Bayadh','032'),(966,12,NULL,'Illizi','033'),(967,12,NULL,'Bordj Bou ArrÃ©ridj','034'),(968,12,NULL,'El Tarf','036'),(969,12,NULL,'Tindouf','037'),(970,12,NULL,'Tissemsilt','038'),(971,12,NULL,'El Oued','039'),(972,12,NULL,'Khenchela','040'),(973,12,NULL,'Souk Ahras','041'),(974,12,NULL,'Tipaza','042'),(975,12,NULL,'Mila','043'),(976,12,NULL,'AÃ¯n Defla','044'),(977,12,NULL,'Naama','045'),(978,12,NULL,'AÃ¯n TÃ©mouchent','046'),(979,12,NULL,'GhardaÃ¯a','047'),(980,12,NULL,'Relizane','048'),(981,218,NULL,'Azuay','A'),(982,218,NULL,'BolÃ­var','B'),(983,218,NULL,'CaÃ±ar','F'),(984,218,NULL,'Carchi','C'),(985,218,NULL,'Cotopaxi','X'),(986,218,NULL,'Chimborazo','H'),(987,218,NULL,'El Oro','O'),(988,218,NULL,'Esmeraldas','E'),(989,218,NULL,'GalÃ¡pagos','W'),(990,218,NULL,'Guayas','G'),(991,218,NULL,'Imbabura','I'),(992,218,NULL,'Loja','L'),(993,218,NULL,'Los RÃ­os','R'),(994,218,NULL,'ManabÃ­','M'),(995,218,NULL,'Morona-Santiago','S'),(996,218,NULL,'Napo','N'),(997,218,NULL,'Orellana','D'),(998,218,NULL,'Pastaza','Y'),(999,218,NULL,'Pichincha','P'),(1000,218,NULL,'SucumbÃ­os','U'),(1001,218,NULL,'Tungurahua','T'),(1002,218,NULL,'Zamora-Chinchipe','Z'),(1003,233,NULL,'Harjumaa','037'),(1004,233,NULL,'Hiiumaa','039'),(1005,233,NULL,'Ida-Virumaa','044'),(1006,233,NULL,'JÃµgevamaa','049'),(1007,233,NULL,'JÃ¤rvamaa','051'),(1008,233,NULL,'LÃ¤Ã¤nemaa','057'),(1009,233,NULL,'LÃ¤Ã¤ne-Virumaa','059'),(1010,233,NULL,'PÃµlvamaa','065'),(1011,233,NULL,'PÃ¤rnumaa','067'),(1012,233,NULL,'Raplamaa','070'),(1013,233,NULL,'Saaremaa','074'),(1014,233,NULL,'Tartumaa','078'),(1015,233,NULL,'Valgamaa','082'),(1016,233,NULL,'Viljandimaa','084'),(1017,233,NULL,'VÃµrumaa','086'),(1018,818,NULL,'Ad DaqahlÄ«yah','DK'),(1019,818,NULL,'Al Bahr al Ahmar','BA'),(1020,818,NULL,'Al Buhayrah','BH'),(1021,818,NULL,'Al FayyÅ«m','FYM'),(1022,818,NULL,'Al GharbÄ«yah','GH'),(1023,818,NULL,'Al IskandarÄ«yah','ALX'),(1024,818,NULL,'Al IsmÄ`Ä«lÄ«yah','IS'),(1025,818,NULL,'Al JÄ«zah','GZ'),(1026,818,NULL,'Al MinÅ«fÄ«yah','MNF'),(1027,818,NULL,'Al MinyÄ','MN'),(1028,818,NULL,'Al QÄhirah','C'),(1029,818,NULL,'Al QalyÅ«bÄ«yah','KB'),(1030,818,NULL,'Al WÄdÄ« al JadÄ«d','WAD'),(1031,818,NULL,'Ash SharqÄ«yah','SHR'),(1032,818,NULL,'As Suways','SUZ'),(1033,818,NULL,'AswÄn','ASN'),(1034,818,NULL,'AsyÅ«t','AST'),(1035,818,NULL,'BanÄ« Suwayf','BNS'),(1036,818,NULL,'BÅ«r Sa`Ä«d','PTS'),(1037,818,NULL,'DumyÄt','DT'),(1038,818,NULL,'JanÅ«b SÄ«nÄ','JS'),(1039,818,NULL,'Kafr ash Shaykh','KFS'),(1040,818,NULL,'MatrÅ«h','MT'),(1041,818,NULL,'QinÄ','KN'),(1042,818,NULL,'Shamal SÄ«nÄ','SIN'),(1043,818,NULL,'SÅ«hÄj','SHG'),(1044,232,NULL,'Anseba','AN'),(1045,232,NULL,'Debub','DU'),(1046,232,NULL,'Debubawi Keyih Bahri','DK'),(1047,232,NULL,'Gash-Barka','GB'),(1048,232,NULL,'Maakel','MA'),(1049,232,NULL,'Semenawi Keyih Bahri','SK'),(1050,724,NULL,'Ãlava','VI'),(1051,724,NULL,'Albacete','AB'),(1052,724,NULL,'Alicante','A'),(1053,724,NULL,'AlmerÃ­a','AL'),(1054,724,NULL,'Asturias','O'),(1055,724,NULL,'Ãvila','AV'),(1056,724,NULL,'Badajoz','BA'),(1057,724,NULL,'Baleares','IB'),(1058,724,NULL,'Barcelona','B'),(1059,724,NULL,'Burgos','BU'),(1060,724,NULL,'CÃ¡ceres','CC'),(1061,724,NULL,'CÃ¡diz','CA'),(1062,724,NULL,'Cantabria','S'),(1063,724,NULL,'CastellÃ³n','CS'),(1064,724,NULL,'Ciudad Real','CR'),(1065,724,NULL,'CÃ³rdoba','CO'),(1066,724,NULL,'Cuenca','CU'),(1067,724,NULL,'Girona','GI'),(1068,724,NULL,'Granada','GR'),(1069,724,NULL,'Guadalajara','GU'),(1070,724,NULL,'GuipÃºzcoa','SS'),(1071,724,NULL,'Huelva','H'),(1072,724,NULL,'Huesca','HU'),(1073,724,NULL,'JaÃ©n','J'),(1074,724,NULL,'A CoruÃ±a','C'),(1075,724,NULL,'La Rioja','LO'),(1076,724,NULL,'Las Palmas','GC'),(1077,724,NULL,'LeÃ³n','LE'),(1078,724,NULL,'Lleida','L'),(1079,724,NULL,'Lugo','LU'),(1080,724,NULL,'Madrid','M'),(1081,724,NULL,'MÃ¡laga','MA'),(1082,724,NULL,'Murcia','MU'),(1083,724,NULL,'Navarra','NA'),(1084,724,NULL,'Ourense','OR'),(1085,724,NULL,'Palencia','P'),(1086,724,NULL,'Pontevedra','PO'),(1087,724,NULL,'Salamanca','SA'),(1088,724,NULL,'Santa Cruz de Tenerife','TF'),(1089,724,NULL,'Segovia','SG'),(1090,724,NULL,'Sevilla','SE'),(1091,724,NULL,'Soria','SO'),(1092,724,NULL,'Tarragona','T'),(1093,724,NULL,'Teruel','TE'),(1094,724,NULL,'Toledo','TO'),(1095,724,NULL,'Valencia','V'),(1096,724,NULL,'Valladolid','VA'),(1097,724,NULL,'Vizcaya','BI'),(1098,724,NULL,'Zamora','ZA'),(1099,724,NULL,'Zaragoza','Z'),(1100,724,NULL,'Ceuta','CE'),(1101,724,NULL,'Melilla','ML'),(1102,231,NULL,'Ä€dÄ«s Ä€beba','AA'),(1103,231,NULL,'DirÄ“ Dawa','DD'),(1104,231,NULL,'Ä€far','AF'),(1105,231,NULL,'Ä€mara','AM'),(1106,231,NULL,'BÄ«nshangul Gumuz','BE'),(1107,231,NULL,'GambÄ“la Hizboch','GA'),(1108,231,NULL,'HÄrerÄ« Hizb','HA'),(1109,231,NULL,'OromÄ«ya','OR'),(1110,231,NULL,'SumalÄ“','SO'),(1111,231,NULL,'Tigray','TI'),(1112,231,NULL,'YeDebub BihÄ“roch BihÄ“reseboch na Hizboch','SN'),(1113,246,NULL,'Ahvenanmaan lÃ¤Ã¤ni','AL'),(1114,246,NULL,'EtelÃ¤-Suomen lÃ¤Ã¤ni','ES'),(1115,246,NULL,'ItÃ¤-Suomen lÃ¤Ã¤ni','IS'),(1116,246,NULL,'Lapin lÃ¤Ã¤ni','LL'),(1117,246,NULL,'LÃ¤nsi-Suomen lÃ¤Ã¤ni','LS'),(1118,246,NULL,'Oulun lÃ¤Ã¤ni','OL'),(1119,242,NULL,'Central','C'),(1120,242,NULL,'Eastern','E'),(1121,242,NULL,'Northern','N'),(1122,242,NULL,'Western','W'),(1123,242,NULL,'Rotum','R'),(1124,583,NULL,'Chuuk','TRK'),(1125,583,NULL,'Kosrae','KSA'),(1126,583,NULL,'Pohnpei','PNI'),(1127,583,NULL,'Yap','YAP'),(1128,250,NULL,'Ain','001'),(1129,250,NULL,'Aisne','002'),(1130,250,NULL,'Allier','003'),(1131,250,NULL,'Alpes-de-Haute-Provence','004'),(1132,250,NULL,'Hautes-Alpes','005'),(1133,250,NULL,'Alpes-Maritimes','006'),(1134,250,NULL,'ArdÃ¨che','007'),(1135,250,NULL,'Ardennes','008'),(1136,250,NULL,'AriÃ¨ge','009'),(1137,250,NULL,'Aube','010'),(1138,250,NULL,'Aude','011'),(1139,250,NULL,'Aveyron','012'),(1140,250,NULL,'Bouches-du-RhÃ´ne','013'),(1141,250,NULL,'Calvados','014'),(1142,250,NULL,'Cantal','015'),(1143,250,NULL,'Charente','016'),(1144,250,NULL,'Charente-Maritime','017'),(1145,250,NULL,'Cher','018'),(1146,250,NULL,'CorrÃ¨ze','019'),(1147,250,NULL,'Corse-du-Sud','02A'),(1148,250,NULL,'CÃ´te-d\'Or','021'),(1149,250,NULL,'CÃ´tes-d\'Armor','022'),(1150,250,NULL,'Creuse','023'),(1151,250,NULL,'Dordogne','024'),(1152,250,NULL,'Doubs','025'),(1153,250,NULL,'DrÃ´me','026'),(1154,250,NULL,'Eure','027'),(1155,250,NULL,'Eure-et-Loir','028'),(1156,250,NULL,'FinistÃ¨re','029'),(1157,250,NULL,'Gard','030'),(1158,250,NULL,'Haute-Garonne','031'),(1159,250,NULL,'Gers','032'),(1160,250,NULL,'Gironde','033'),(1161,250,NULL,'HÃ©rault','034'),(1162,250,NULL,'Ille-et-Vilaine','035'),(1163,250,NULL,'Indre','036'),(1164,250,NULL,'Indre-et-Loire','037'),(1165,250,NULL,'IsÃ¨re','038'),(1166,250,NULL,'Jura','039'),(1167,250,NULL,'Landes','040'),(1168,250,NULL,'Loir-et-Cher','041'),(1169,250,NULL,'Loire','042'),(1170,250,NULL,'Haute-Loire','043'),(1171,250,NULL,'Loire-Atlantique','044'),(1172,250,NULL,'Loiret','045'),(1173,250,NULL,'Lot','046'),(1174,250,NULL,'Lot-et-Garonne','047'),(1175,250,NULL,'LozÃ¨re','048'),(1176,250,NULL,'Maine-et-Loire','049'),(1177,250,NULL,'Manche','050'),(1178,250,NULL,'Marne','051'),(1179,250,NULL,'Haute-Marne','052'),(1180,250,NULL,'Mayenne','053'),(1181,250,NULL,'Meurthe-et-Moselle','054'),(1182,250,NULL,'Meuse','055'),(1183,250,NULL,'Morbihan','056'),(1184,250,NULL,'Moselle','057'),(1185,250,NULL,'NiÃ¨vre','058'),(1186,250,NULL,'Nord','059'),(1187,250,NULL,'Oise','060'),(1188,250,NULL,'Orne','061'),(1189,250,NULL,'Pas-de-Calais','062'),(1190,250,NULL,'Puy-de-DÃ´me','063'),(1191,250,NULL,'PyrÃ©nÃ©es-Atlantiques','064'),(1192,250,NULL,'Hautes-PyrÃ©nÃ©es','065'),(1193,250,NULL,'PyrÃ©nÃ©es-Orientales','066'),(1194,250,NULL,'Bas-Rhin','067'),(1195,250,NULL,'Haut-Rhin','068'),(1196,250,NULL,'RhÃ´ne','069'),(1197,250,NULL,'Haute-SaÃ´ne','070'),(1198,250,NULL,'SaÃ´ne-et-Loire','071'),(1199,250,NULL,'Sarthe','072'),(1200,250,NULL,'Savoie','073'),(1201,250,NULL,'Haute-Savoie','074'),(1202,250,NULL,'Paris','075'),(1203,250,NULL,'Seine-Maritime','076'),(1204,250,NULL,'Seine-et-Marne','077'),(1205,250,NULL,'Yvelines','078'),(1206,250,NULL,'Deux-SÃ¨vres','079'),(1207,250,NULL,'Somme','080'),(1208,250,NULL,'Tarn','081'),(1209,250,NULL,'Tarn-et-Garonne','082'),(1210,250,NULL,'Var','083'),(1211,250,NULL,'Vaucluse','084'),(1212,250,NULL,'VendÃ©e','085'),(1213,250,NULL,'Vienne','086'),(1214,250,NULL,'Haute-Vienne','087'),(1215,250,NULL,'Vosges','088'),(1216,250,NULL,'Yonne','089'),(1217,250,NULL,'Territoire de Belfort','090'),(1218,250,NULL,'Essonne','091'),(1219,250,NULL,'Hauts-de-Seine','092'),(1220,250,NULL,'Seine-Saint-Denis','093'),(1221,250,NULL,'Val-de-Marne','094'),(1222,250,NULL,'Val d\'Oise','095'),(1223,250,NULL,'Haute-Corse','02B'),(1224,250,NULL,'Clipperton','CP'),(1225,250,NULL,'Saint-BarthÃ©lemy','BL'),(1226,250,NULL,'Saint-Martin','MF'),(1227,250,NULL,'Nouvelle-CalÃ©donie','NC'),(1228,250,NULL,'PolynÃ©sie franÃ§aise','PF'),(1229,250,NULL,'Saint-Pierre-et-Miquelon','PM'),(1230,250,NULL,'Terres australes franÃ§aises','TF'),(1231,250,NULL,'Wallis et Futuna','WF'),(1232,250,NULL,'Mayotte','YT'),(1233,826,'England','Bedfordshire','BDF'),(1234,826,'England','Buckinghamshire','BKM'),(1235,826,'England','Cambridgeshire','CAM'),(1236,826,'England','Cheshire','CHS'),(1237,826,'England','Cornwall','CON'),(1238,826,'England','Cumbria','CMA'),(1239,826,'England','Derbyshire','DBY'),(1240,826,'England','Devon','DEV'),(1241,826,'England','Dorset','DOR'),(1242,826,'England','Durham','DUR'),(1243,826,'England','East Sussex','ESX'),(1244,826,'England','Essex','ESS'),(1245,826,'England','Gloucestershire','GLS'),(1246,826,'England','Hampshire','HAM'),(1247,826,'England','Hertfordshire','HRT'),(1248,826,'England','Kent','KEN'),(1249,826,'England','Lancashire','LAN'),(1250,826,'England','Leicestershire','LEC'),(1251,826,'England','Lincolnshire','LIN'),(1252,826,'England','Norfolk','NFK'),(1253,826,'England','North Yorkshire','NYK'),(1254,826,'England','Northamptonshire','NTH'),(1255,826,'England','Northumbarland','NBL'),(1256,826,'England','Nottinghamshire','NTT'),(1257,826,'England','Oxfordshire','OXF'),(1258,826,'England','Somerse','SOM'),(1259,826,'England','Staffordshire','STS'),(1260,826,'England','Suffolk','SFK'),(1261,826,'England','Surrey','SRY'),(1262,826,'England','West Sussex','WSX'),(1263,826,'England','Wiltshire','WIL'),(1264,826,'England','Worcestershire','WOR'),(1265,826,'England','Barking and Dagenham','BDG'),(1266,826,'England','Barnet','BNE'),(1267,826,'England','Bexley','BEX'),(1268,826,'England','Brent','BEN'),(1269,826,'England','Bromley','BRY'),(1270,826,'England','Camden','CMD'),(1271,826,'England','Croydon','CRY'),(1272,826,'England','Ealing','EAL'),(1273,826,'England','Enfield','ENF'),(1274,826,'England','Greenwich','GRE'),(1275,826,'England','Hackney','HCK'),(1276,826,'England','Hammersmith and Fulham','HMF'),(1277,826,'England','Haringey','HRY'),(1278,826,'England','Harrow','HRW'),(1279,826,'England','Havering','HAV'),(1280,826,'England','Hillingdon','HIL'),(1281,826,'England','Hounslow','HNS'),(1282,826,'England','Islington','ISL'),(1283,826,'England','Kensington and Chelsea','KEC'),(1284,826,'England','Kingston upon Thames','KTT'),(1285,826,'England','Lambeth','LBH'),(1286,826,'England','Lewisham','LEW'),(1287,826,'England','Merton','MRT'),(1288,826,'England','Newham','NWM'),(1289,826,'England','Redbridge','RDB'),(1290,826,'England','Richmond upon Thames','RIC'),(1291,826,'England','Southwark','SWK'),(1292,826,'England','Sutton','STN'),(1293,826,'England','Tower Hamlets','TWH'),(1294,826,'England','Waltham Forest','WFT'),(1295,826,'England','Wandsworth','WND'),(1296,826,'England','Westminster','WSM'),(1297,826,'England','Barnsley','BNS'),(1298,826,'England','Birmingham','BIR'),(1299,826,'England','Bolton','BOL'),(1300,826,'England','Bradford','BRD'),(1301,826,'England','Bury','BUR'),(1302,826,'England','Calderdale','CLD'),(1303,826,'England','Coventry','COV'),(1304,826,'England','Doncaster','DNC'),(1305,826,'England','Dudley','DUD'),(1306,826,'England','Gateshead','GAT'),(1307,826,'England','Kirklees','KIR'),(1308,826,'England','Knowsley','KWL'),(1309,826,'England','Leeds','LDS'),(1310,826,'England','Liverpool','LIV'),(1311,826,'England','Manchester','MAN'),(1312,826,'England','Newcastle upon Tyne','NET'),(1313,826,'England','North Tyneside','NTY'),(1314,826,'England','Oldham','OLD'),(1315,826,'England','Rochdale','RCH'),(1316,826,'England','Rotherham','ROT'),(1317,826,'England','Salford','SLF'),(1318,826,'England','Sandwell','SAW'),(1319,826,'England','Sefton','SFT'),(1320,826,'England','Sheffield','SHF'),(1321,826,'England','Solihull','SOL'),(1322,826,'England','South Tyneside','STY'),(1323,826,'England','St. Helens','SHN'),(1324,826,'England','Stockport','SKP'),(1325,826,'England','Sunderland','SND'),(1326,826,'England','Tameside','TAM'),(1327,826,'England','Trafford','TRF'),(1328,826,'England','Wakefield','WKF'),(1329,826,'England','Walsall','WLL'),(1330,826,'England','Wigan','WGN'),(1331,826,'England','Wirral','WRL'),(1332,826,'England','Wolverhampton','WLV'),(1333,826,'England','London, City of','LND'),(1334,826,'England','Bath and North East Somerset','BAS'),(1335,826,'England','Blackburn with Darwen','BBD'),(1336,826,'England','Blackpool','BPL'),(1337,826,'England','Bournemouth','BMH'),(1338,826,'England','Bracknell Forest','BRC'),(1339,826,'England','Brighton and Hove','BNH'),(1340,826,'England','Bristol, City of','BST'),(1341,826,'England','Darlington','DAL'),(1342,826,'England','Derby','DER'),(1343,826,'England','East Riding of Yorkshire','ERY'),(1344,826,'England','Halton','HAL'),(1345,826,'England','Hartlepool','HPL'),(1346,826,'England','Herefordshire, County of','HEF'),(1347,826,'England','Isle of Wight','IOW'),(1348,826,'England','Isles of Scilly','IOS'),(1349,826,'England','Kingston upon Hull, City of','KHL'),(1350,826,'England','Leicester','LCE'),(1351,826,'England','Luton','LUT'),(1352,826,'England','Medway','MDW'),(1353,826,'England','Middlesbrough','MDB'),(1354,826,'England','Milton Keynes','MIK'),(1355,826,'England','North East Lincolnshire','NEL'),(1356,826,'England','North Lincolnshire','NLN'),(1357,826,'England','North Somerset','NSM'),(1358,826,'England','Nottingham','NGM'),(1359,826,'England','Peterborough','PTE'),(1360,826,'England','Plymouth','PLY'),(1361,826,'England','Poole','POL'),(1362,826,'England','Portsmouth','POR'),(1363,826,'England','Reading','RDG'),(1364,826,'England','Redcar and Cleveland','RCC'),(1365,826,'England','Rutland','RUT'),(1366,826,'England','Shropshire','SHR'),(1367,826,'England','Slough','SLG'),(1368,826,'England','South Gloucestershire','SGC'),(1369,826,'England','Southampton','STH'),(1370,826,'England','Southend-on-Sea','SOS'),(1371,826,'England','Stockton-on-Tees','STT'),(1372,826,'England','Stoke-on-Trent','STE'),(1373,826,'England','Swindon','SWD'),(1374,826,'England','Telford and Wrekin','TFW'),(1375,826,'England','Thurrock','THR'),(1376,826,'England','Torbay','TOB'),(1377,826,'England','Warrington','WRT'),(1378,826,'England','Warwickshire','WAR'),(1379,826,'England','West Berkshire','WBX'),(1380,826,'England','Windsor and Maidenhead','WNM'),(1381,826,'England','Wokingham','WOK'),(1382,826,'England','York','YOR'),(1383,826,'Scotland','Aberdeen City','ABE'),(1384,826,'Scotland','Aberdeenshire','ABD'),(1385,826,'Scotland','Angus','ANS'),(1386,826,'Scotland','Argyll and Bute','AGB'),(1387,826,'Scotland','Clackmannanshire','CLK'),(1388,826,'Scotland','Dumfries and Galloway','DGY'),(1389,826,'Scotland','Dundee City','DND'),(1390,826,'Scotland','East Ayrshire','EAY'),(1391,826,'Scotland','East Dunbartonshire','EDU'),(1392,826,'Scotland','East Lothian','ELN'),(1393,826,'Scotland','East Renfrewshire','ERW'),(1394,826,'Scotland','Edinburgh, City of','EDH'),(1395,826,'Scotland','Eilean Siar','ELS'),(1396,826,'Scotland','Falkirk','FAL'),(1397,826,'Scotland','Fife','FIF'),(1398,826,'Scotland','Glasgow City','GLG'),(1399,826,'Scotland','Highland','HED'),(1400,826,'Scotland','Inverclyde','IVC'),(1401,826,'Scotland','Midlothian','MLN'),(1402,826,'Scotland','Moray','MRY'),(1403,826,'Scotland','North Ayrshire','NAY'),(1404,826,'Scotland','North Lanarkshire','NLK'),(1405,826,'Scotland','Orkney Islands','ORR'),(1406,826,'Scotland','Perth and Kinross','PKN'),(1407,826,'Scotland','Renfrewshire','RFW'),(1408,826,'Scotland','Scottish Borders, The','SCB'),(1409,826,'Scotland','Shetland Islands','ZET'),(1410,826,'Scotland','South Ayrshire','SAY'),(1411,826,'Scotland','South Lanarkshire','SLK'),(1412,826,'Scotland','Stirling','STG'),(1413,826,'Scotland','West Dunbartonshire','WDU'),(1414,826,'Scotland','West Lothian','WLN'),(1415,826,'Northern Ireland','Antrim','ANT'),(1416,826,'Northern Ireland','Ards','ARD'),(1417,826,'Northern Ireland','Armagh','ARM'),(1418,826,'Northern Ireland','Ballymena','BLA'),(1419,826,'Northern Ireland','Ballymoney','BLY'),(1420,826,'Northern Ireland','Banbridge','BNB'),(1421,826,'Northern Ireland','Belfast','BFS'),(1422,826,'Northern Ireland','Carrickfergus','CKF'),(1423,826,'Northern Ireland','Castlereagh','CSR'),(1424,826,'Northern Ireland','Coleraine','CLR'),(1425,826,'Northern Ireland','Cookstown','CKT'),(1426,826,'Northern Ireland','Craigavon','CGV'),(1427,826,'Northern Ireland','Derry','DRY'),(1428,826,'Northern Ireland','Down','DOW'),(1429,826,'Northern Ireland','Dungannon','DGN'),(1430,826,'Northern Ireland','Fermanagh','FER'),(1431,826,'Northern Ireland','Larne','LRN'),(1432,826,'Northern Ireland','Limavady','LMV'),(1433,826,'Northern Ireland','Lisburn','LSB'),(1434,826,'Northern Ireland','Magherafelt','MFT'),(1435,826,'Northern Ireland','Moyle','MYL'),(1436,826,'Northern Ireland','Newry and Mourne','NYM'),(1437,826,'Northern Ireland','Newtownabbey','NTA'),(1438,826,'Northern Ireland','North Down','NDN'),(1439,826,'Northern Ireland','Omagh','OMG'),(1440,826,'Northern Ireland','Strabane','STB'),(1441,826,'Wales','Blaenau Gwent','BGW'),(1442,826,'Wales','Bridgend','BGE'),(1443,826,'Wales','Caerphilly','CAY'),(1444,826,'Wales','Cardiff','CRF'),(1445,826,'Wales','Carmarthenshire','CMN'),(1446,826,'Wales','Ceredigion','CGN'),(1447,826,'Wales','Conwy','CWY'),(1448,826,'Wales','Denbighshire','DEN'),(1449,826,'Wales','Flintshire','FLN'),(1450,826,'Wales','Gwynedd','GWN'),(1451,826,'Wales','Isle of Anglesey','AGY'),(1452,826,'Wales','Merthyr Tydfil','MTY'),(1453,826,'Wales','Monmouthshire','MON'),(1454,826,'Wales','Neath Port Talbot','NTL'),(1455,826,'Wales','Newport','NWP'),(1456,826,'Wales','Pembrokeshire','PEM'),(1457,826,'Wales','Powys','POW'),(1458,826,'Wales','Rhondda, Cynon, Taff','RCT'),(1459,826,'Wales','Swansea','SWA'),(1460,826,'Wales','Torfaen','TOF'),(1461,826,'Wales','Vale of Glamorgan, The','VGL'),(1462,826,'Wales','Wrexham','WRX'),(1463,308,NULL,'Saint Andrew','01'),(1464,308,NULL,'Saint David','02'),(1465,308,NULL,'Saint George','03'),(1466,308,NULL,'Saint John','04'),(1467,308,NULL,'Saint Mark','05'),(1468,308,NULL,'Saint Patrick','06'),(1469,308,NULL,'Southern Grenadine Island','10'),(1470,268,NULL,'Abkhazia','AB'),(1471,268,NULL,'Ajaria','AJ'),(1472,268,NULL,'Tâ€™bilisi','TB'),(1473,268,NULL,'Guria','GU'),(1474,268,NULL,'Imeretâ€™i','IM'),(1475,268,NULL,'Kakhetâ€™i','KA'),(1476,268,NULL,'Kâ€™vemo Kâ€™artâ€™li','KK'),(1477,268,NULL,'Mtsâ€™khetâ€™a-Mtâ€™ianetâ€™i','MM'),(1478,268,NULL,'Racha-Lechâ€™khumi-Kâ€™vemo Svanetâ€™i','RL'),(1479,268,NULL,'Samegrelo-Zemo Svanetâ€™i','SZ'),(1480,268,NULL,'Samtsâ€™khe-Javakhetâ€™i','SJ'),(1481,268,NULL,'Shida Kâ€™artâ€™li','SK'),(1482,288,NULL,'Ashanti','AH'),(1483,288,NULL,'Brong-Ahafo','BA'),(1484,288,NULL,'Central','CP'),(1485,288,NULL,'Eastern','EP'),(1486,288,NULL,'Greater Accra','AA'),(1487,288,NULL,'Northern','NP'),(1488,288,NULL,'Upper East','UE'),(1489,288,NULL,'Upper West','UW'),(1490,288,NULL,'Volta','TV'),(1491,288,NULL,'Western','WP'),(1492,270,NULL,'Lower River','L'),(1493,270,NULL,'Central River','M'),(1494,270,NULL,'North Bank','N'),(1495,270,NULL,'Upper River','U'),(1496,270,NULL,'Western','W'),(1497,270,NULL,'Banjul','B'),(1498,324,NULL,'Beyla','BE'),(1499,324,NULL,'Boffa','BF'),(1500,324,NULL,'BokÃ©','BK'),(1501,324,NULL,'Coyah','CO'),(1502,324,NULL,'Dabola','DB'),(1503,324,NULL,'Dalaba','DL'),(1504,324,NULL,'Dinguiraye','DI'),(1505,324,NULL,'DubrÃ©ka','DU'),(1506,324,NULL,'Faranah','FA'),(1507,324,NULL,'ForÃ©cariah','FO'),(1508,324,NULL,'Fria','FR'),(1509,324,NULL,'Gaoual','GA'),(1510,324,NULL,'GuÃ©kÃ©dou','GU'),(1511,324,NULL,'Kankan','KA'),(1512,324,NULL,'KÃ©rouanÃ©','KE'),(1513,324,NULL,'Kindia','KD'),(1514,324,NULL,'Kissidougou','KS'),(1515,324,NULL,'Koubia','KB'),(1516,324,NULL,'Koundara','KN'),(1517,324,NULL,'Kouroussa','KO'),(1518,324,NULL,'LabÃ©','LA'),(1519,324,NULL,'LÃ©louma','LE'),(1520,324,NULL,'Lola','LO'),(1521,324,NULL,'Macenta','MC'),(1522,324,NULL,'Mali','ML'),(1523,324,NULL,'Mamou','MM'),(1524,324,NULL,'Mandiana','MD'),(1525,324,NULL,'NzÃ©rÃ©korÃ©','NZ'),(1526,324,NULL,'Pita','PI'),(1527,324,NULL,'Siguiri','SI'),(1528,324,NULL,'TÃ©limÃ©lÃ©','TE'),(1529,324,NULL,'TouguÃ©','TO'),(1530,324,NULL,'Yomou','YO'),(1531,226,NULL,'RegiÃ³n Continental','C'),(1532,226,NULL,'RegiÃ³n Insular','I'),(1533,226,NULL,'AnnobÃ³n','AN'),(1534,226,NULL,'Bioko Norte','BN'),(1535,226,NULL,'Bioko Sur','BS'),(1536,226,NULL,'Centro Sur','CS'),(1537,226,NULL,'KiÃ©-Ntem','KN'),(1538,226,NULL,'Litoral','LI'),(1539,226,NULL,'Wele-NzÃ¡s','WN'),(1540,300,NULL,'AitoloakarnanÃ­as','001'),(1541,300,NULL,'VoiotÃ­as','003'),(1542,300,NULL,'Ã‰vvoias','004'),(1543,300,NULL,'EvrytanÃ­as','005'),(1544,300,NULL,'FthiÃ³tidas','006'),(1545,300,NULL,'FokÃ­das','007'),(1546,300,NULL,'ArgolÃ­das','011'),(1547,300,NULL,'ArkadÃ­as','012'),(1548,300,NULL,'Achaá¸¯as','013'),(1549,300,NULL,'IleÃ­as','014'),(1550,300,NULL,'KorinthÃ­as','015'),(1551,300,NULL,'LakonÃ­as','016'),(1552,300,NULL,'MessinÃ­as','017'),(1553,300,NULL,'ZakÃ½nthoy','021'),(1554,300,NULL,'KÃ©rkyras','022'),(1555,300,NULL,'KefaloniÃ¡s kai IthÃ¡kis','023'),(1556,300,NULL,'LefkÃ¡das','024'),(1557,300,NULL,'Ãrtas','031'),(1558,300,NULL,'ThesprotÃ­as','032'),(1559,300,NULL,'IoannÃ­non','033'),(1560,300,NULL,'PrÃ©vezas','034'),(1561,300,NULL,'KardÃ­tsas','041'),(1562,300,NULL,'LÃ¡rissas','042'),(1563,300,NULL,'MagnisÃ­as','043'),(1564,300,NULL,'TrikÃ¡lon','044'),(1565,300,NULL,'GrevenÃ³n','051'),(1566,300,NULL,'DrÃ¡mas','052'),(1567,300,NULL,'ImathÃ­as','053'),(1568,300,NULL,'ThessalonÃ­kis','054'),(1569,300,NULL,'KavÃ¡las','055'),(1570,300,NULL,'KastoriÃ¡s','056'),(1571,300,NULL,'KilkÃ­s','057'),(1572,300,NULL,'KozÃ¡nis','058'),(1573,300,NULL,'PÃ©llas','059'),(1574,300,NULL,'PierÃ­as','061'),(1575,300,NULL,'SerrÃ³n','062'),(1576,300,NULL,'FlÃ³rinas','063'),(1577,300,NULL,'ChalkidikÃ­s','064'),(1578,300,NULL,'Ãgion Ã“ros','069'),(1579,300,NULL,'Ã‰vroy','071'),(1580,300,NULL,'XÃ¡nthis','072'),(1581,300,NULL,'RodÃ³pis','073'),(1582,300,NULL,'DodekanÃ­soy','081'),(1583,300,NULL,'KyklÃ¡don','082'),(1584,300,NULL,'LÃ©sboy','083'),(1585,300,NULL,'SÃ¡moy','084'),(1586,300,NULL,'ChÃ­oy','085'),(1587,300,NULL,'IrakleÃ­oy','091'),(1588,300,NULL,'LasithÃ­oy','092'),(1589,300,NULL,'RethÃ½mnoy','093'),(1590,300,NULL,'ChanÃ­on','094'),(1591,300,NULL,'AthinÃ³n','A1'),(1592,300,NULL,'AnatolikÃ­s AttikÃ­s','A2'),(1593,300,NULL,'PeiraiÃ³s','A3'),(1594,300,NULL,'DytikÃ­s AttikÃ­s','A4'),(1595,320,NULL,'Alta Verapaz','AV'),(1596,320,NULL,'Baja Verapaz','BV'),(1597,320,NULL,'Chimaltenango','CM'),(1598,320,NULL,'Chiquimula','CQ'),(1599,320,NULL,'El Progreso','PR'),(1600,320,NULL,'Escuintla','ES'),(1601,320,NULL,'Guatemala','GU'),(1602,320,NULL,'Huehuetenango','HU'),(1603,320,NULL,'Izabal','IZ'),(1604,320,NULL,'Jalapa','JA'),(1605,320,NULL,'Jutiapa','JU'),(1606,320,NULL,'PetÃ©n','PE'),(1607,320,NULL,'Quetzaltenango','QZ'),(1608,320,NULL,'QuichÃ©','QC'),(1609,320,NULL,'Retalhuleu','RE'),(1610,320,NULL,'SacatepÃ©quez','SA'),(1611,320,NULL,'San Marcos','SM'),(1612,320,NULL,'Santa Rosa','SR'),(1613,320,NULL,'SololÃ¡','SO'),(1614,320,NULL,'SuchitepÃ©quez','SU'),(1615,320,NULL,'TotonicapÃ¡n','TO'),(1616,320,NULL,'Zacapa','ZA'),(1617,624,NULL,'BafatÃ¡','BA'),(1618,624,NULL,'Biombo','BM'),(1619,624,NULL,'Bolama','BL'),(1620,624,NULL,'Cacheu','CA'),(1621,624,NULL,'GabÃº','GA'),(1622,624,NULL,'Oio','OI'),(1623,624,NULL,'Quinara','QU'),(1624,624,NULL,'Tombali','TO'),(1625,624,NULL,'Bissau','BS'),(1626,328,NULL,'Barima-Waini','BA'),(1627,328,NULL,'Cuyuni-Mazaruni','CU'),(1628,328,NULL,'Demerara-Mahaica','DE'),(1629,328,NULL,'East Berbice-Corentyne','EB'),(1630,328,NULL,'Essequibo Islands-West Demerara','ES'),(1631,328,NULL,'Mahaica-Berbice','MA'),(1632,328,NULL,'Pomeroon-Supenaam','PM'),(1633,328,NULL,'Potaro-Siparuni','PT'),(1634,328,NULL,'Upper Demerara-Berbice','UD'),(1635,328,NULL,'Upper Takutu-Upper Essequibo','UT'),(1636,340,NULL,'AtlÃ¡ntida','AT'),(1637,340,NULL,'ColÃ³n','CL'),(1638,340,NULL,'Comayagua','CM'),(1639,340,NULL,'CopÃ¡n','CP'),(1640,340,NULL,'CortÃ©s','CR'),(1641,340,NULL,'Choluteca','CH'),(1642,340,NULL,'El ParaÃ­so','EP'),(1643,340,NULL,'Francisco MorazÃ¡n','FM'),(1644,340,NULL,'Gracias a Dios','GD'),(1645,340,NULL,'IntibucÃ¡','IN'),(1646,340,NULL,'Islas de la BahÃ­a','IB'),(1647,340,NULL,'La Paz','LP'),(1648,340,NULL,'Lempira','LE'),(1649,340,NULL,'Ocotepeque','OC'),(1650,340,NULL,'Olancho','OL'),(1651,340,NULL,'Santa BÃ¡rbara','SB'),(1652,340,NULL,'Valle','VA'),(1653,340,NULL,'Yoro','YO'),(1654,191,NULL,'ZagrebaÄka Å¾upanija','001'),(1655,191,NULL,'Krapinsko-zagorska Å¾upanija','002'),(1656,191,NULL,'SisaÄko-moslavaÄka Å¾upanija','003'),(1657,191,NULL,'KarlovaÄka Å¾upanija','004'),(1658,191,NULL,'VaraÅ¾dinska Å¾upanija','005'),(1659,191,NULL,'KoprivniÄko-kriÅ¾evaÄka Å¾upanija','006'),(1660,191,NULL,'Bjelovarsko-bilogorska Å¾upanija','007'),(1661,191,NULL,'Primorsko-goranska Å¾upanija','008'),(1662,191,NULL,'LiÄko-senjska Å¾upanija','009'),(1663,191,NULL,'VirovitiÄko-podravska Å¾upanija','010'),(1664,191,NULL,'PoÅ¾eÅ¡ko-slavonska Å¾upanija','011'),(1665,191,NULL,'Brodsko-posavska Å¾upanija','012'),(1666,191,NULL,'Zadarska Å¾upanija','013'),(1667,191,NULL,'OsjeÄko-baranjska Å¾upanija','014'),(1668,191,NULL,'Å ibensko-kninska Å¾upanija','015'),(1669,191,NULL,'Vukovarsko-srijemska Å¾upanija','016'),(1670,191,NULL,'Splitsko-dalmatinska Å¾upanija','017'),(1671,191,NULL,'Istarska Å¾upanija','018'),(1672,191,NULL,'DubrovaÄko-neretvanska Å¾upanija','019'),(1673,191,NULL,'MeÄ‘imurska Å¾upanija','020'),(1674,191,NULL,'Grad Zagreb','021'),(1675,332,NULL,'Artibonite','AR'),(1676,332,NULL,'Centre','CE'),(1677,332,NULL,'Grande-Anse','GA'),(1678,332,NULL,'Nord','ND'),(1679,332,NULL,'Nord-Est','NE'),(1680,332,NULL,'Nord-Ouest','NO'),(1681,332,NULL,'Ouest','OU'),(1682,332,NULL,'Sud','SD'),(1683,332,NULL,'Sud-Est','SE'),(1684,348,NULL,'BÃ¡cs-Kiskun','BK'),(1685,348,NULL,'Baranya','BA'),(1686,348,NULL,'BÃ©kÃ©s','BE'),(1687,348,NULL,'Borsod-AbaÃºj-ZemplÃ©n','BZ'),(1688,348,NULL,'CsongrÃ¡d','CS'),(1689,348,NULL,'FejÃ©r','FE'),(1690,348,NULL,'GyÅ‘r-Moson-Sopron','GS'),(1691,348,NULL,'HajdÃº-Bihar','HB'),(1692,348,NULL,'Heves','HE'),(1693,348,NULL,'JÃ¡sz-Nagykun-Szolnok','JN'),(1694,348,NULL,'KomÃ¡rom-Esztergom','KE'),(1695,348,NULL,'NÃ³grÃ¡d','NO'),(1696,348,NULL,'Pest','PE'),(1697,348,NULL,'Somogy','SO'),(1698,348,NULL,'Szabolcs-SzatmÃ¡r-Bereg','SZ'),(1699,348,NULL,'Tolna','TO'),(1700,348,NULL,'Vas','VA'),(1701,348,NULL,'VeszprÃ©m (county)','VE'),(1702,348,NULL,'Zala','ZA'),(1703,348,NULL,'BÃ©kÃ©scsaba','BC'),(1704,348,NULL,'Debrecen','DE'),(1705,348,NULL,'DunaÃºjvÃ¡ros','DU'),(1706,348,NULL,'Eger','EG'),(1707,348,NULL,'GyÅ‘r','GY'),(1708,348,NULL,'HÃ³dmezÅ‘vÃ¡sÃ¡rhely','HV'),(1709,348,NULL,'KaposvÃ¡r','KV'),(1710,348,NULL,'KecskemÃ©t','KM'),(1711,348,NULL,'Miskolc','MI'),(1712,348,NULL,'Nagykanizsa','NK'),(1713,348,NULL,'NyÃ­regyhÃ¡za','NY'),(1714,348,NULL,'PÃ©cs','PS'),(1715,348,NULL,'SalgÃ³tarjÃ¡n','ST'),(1716,348,NULL,'Sopron','SN'),(1717,348,NULL,'Szeged','SD'),(1718,348,NULL,'SzÃ©kesfehÃ©rvÃ¡r','SF'),(1719,348,NULL,'SzekszÃ¡rd','SS'),(1720,348,NULL,'Szolnok','SK'),(1721,348,NULL,'Szombathely','SH'),(1722,348,NULL,'TatabÃ¡nya','TB'),(1723,348,NULL,'VeszprÃ©m','VM'),(1724,348,NULL,'Zalaegerszeg','ZE'),(1725,348,NULL,'Budapest','BU'),(1726,360,NULL,'Aceh','AC'),(1727,360,NULL,'Bali','BA'),(1728,360,NULL,'Bangka Belitung','BB'),(1729,360,NULL,'Banten','BT'),(1730,360,NULL,'Bengkulu','BE'),(1731,360,NULL,'Gorontalo','GO'),(1732,360,NULL,'Jambi','JA'),(1733,360,NULL,'Jawa Barat','JB'),(1734,360,NULL,'Jawa Tengah','JT'),(1735,360,NULL,'Jawa Timur','JI'),(1736,360,NULL,'Kalimantan Barat','KB'),(1737,360,NULL,'Kalimantan Tengah','KT'),(1738,360,NULL,'Kalimantan Selatan','KS'),(1739,360,NULL,'Kalimantan Timur','KI'),(1740,360,NULL,'Kepulauan Riau','KR'),(1741,360,NULL,'Lampung','LA'),(1742,360,NULL,'Maluku','MA'),(1743,360,NULL,'Maluku Utara','MU'),(1744,360,NULL,'Nusa Tenggara Barat','NB'),(1745,360,NULL,'Nusa Tenggara Timur','NT'),(1746,360,NULL,'Papua','PA'),(1747,360,NULL,'Riau','RI'),(1748,360,NULL,'Sulawesi Barat','SR'),(1749,360,NULL,'Sulawesi Selatan','SN'),(1750,360,NULL,'Sulawesi Tengah','ST'),(1751,360,NULL,'Sulawesi Tenggara','SG'),(1752,360,NULL,'Sulawesi Utara','SA'),(1753,360,NULL,'Sumatra Barat','SB'),(1754,360,NULL,'Sumatra Selatan','SS'),(1755,360,NULL,'Sumatera Utara','SU'),(1756,360,NULL,'Jakarta Raya','JK'),(1757,360,NULL,'Yogyakarta','YO'),(1758,372,NULL,'Cork','C'),(1759,372,NULL,'Clare','CE'),(1760,372,NULL,'Cavan','CN'),(1761,372,NULL,'Carlow','CW'),(1762,372,NULL,'Dublin','D'),(1763,372,NULL,'Donegal','DL'),(1764,372,NULL,'Galway','G'),(1765,372,NULL,'Kildare','KE'),(1766,372,NULL,'Kilkenny','KK'),(1767,372,NULL,'Kerry','KY'),(1768,372,NULL,'Longford','LD'),(1769,372,NULL,'Louth','LH'),(1770,372,NULL,'Limerick','LK'),(1771,372,NULL,'Leitrim','LM'),(1772,372,NULL,'Laois','LS'),(1773,372,NULL,'Meath','MH'),(1774,372,NULL,'Monaghan','MN'),(1775,372,NULL,'Mayo','MO'),(1776,372,NULL,'Offaly','OY'),(1777,372,NULL,'Roscommon','RN'),(1778,372,NULL,'Sligo','SO'),(1779,372,NULL,'Tipperary','TA'),(1780,372,NULL,'Waterford','WD'),(1781,372,NULL,'Westmeath','WH'),(1782,372,NULL,'Wicklow','WW'),(1783,372,NULL,'Wexford','WX'),(1784,376,NULL,'HaDarom','D'),(1785,376,NULL,'HaMerkaz','M'),(1786,376,NULL,'HaZafon','Z'),(1787,376,NULL,'Hefa','HA'),(1788,376,NULL,'Tel-Aviv','TA'),(1789,376,NULL,'Yerushalayim Al Quds','JM'),(1790,356,NULL,'Andhra Pradesh','AP'),(1791,356,NULL,'ArunÄchal Pradesh','AR'),(1792,356,NULL,'Assam','AS'),(1793,356,NULL,'BihÄr','BR'),(1794,356,NULL,'ChhattÄ«sgarh','CT'),(1795,356,NULL,'Goa','GA'),(1796,356,NULL,'GujarÄt','GJ'),(1797,356,NULL,'HaryÄna','HR'),(1798,356,NULL,'HimÄchal Pradesh','HP'),(1799,356,NULL,'Jammu and KashmÄ«r','JK'),(1800,356,NULL,'Jharkhand','JH'),(1801,356,NULL,'KarnÄtaka','KA'),(1802,356,NULL,'Kerala','KL'),(1803,356,NULL,'Madhya Pradesh','MP'),(1804,356,NULL,'MahÄrÄshtra','MH'),(1805,356,NULL,'Manipur','MN'),(1806,356,NULL,'MeghÄlaya','ML'),(1807,356,NULL,'Mizoram','MZ'),(1808,356,NULL,'NÄgÄland','NL'),(1809,356,NULL,'Orissa','OR'),(1810,356,NULL,'Punjab','PB'),(1811,356,NULL,'RÄjasthÄn','RJ'),(1812,356,NULL,'Sikkim','SK'),(1813,356,NULL,'Tamil NÄdu','TN'),(1814,356,NULL,'Tripura','TR'),(1815,356,NULL,'Uttaranchal','UL'),(1816,356,NULL,'Uttar Pradesh','UP'),(1817,356,NULL,'West Bengal','WB'),(1818,356,NULL,'Andaman and Nicobar Islands','AN'),(1819,356,NULL,'ChandÄ«garh','CH'),(1820,356,NULL,'DÄdra and Nagar Haveli','DN'),(1821,356,NULL,'DamÄn and Diu','DD'),(1822,356,NULL,'Delhi','DL'),(1823,356,NULL,'Lakshadweep','LD'),(1824,356,NULL,'Pondicherry','PY'),(1825,368,NULL,'Al Anbar','AN'),(1826,368,NULL,'Al Basrah','BA'),(1827,368,NULL,'Al Muthanna','MU'),(1828,368,NULL,'Al Qadisiyah','QA'),(1829,368,NULL,'An Najef','NA'),(1830,368,NULL,'Arbil','AR'),(1831,368,NULL,'As Sulaymaniyah','SW'),(1832,368,NULL,'At Ta\'mim','TS'),(1833,368,NULL,'Babil','BB'),(1834,368,NULL,'Baghdad','BG'),(1835,368,NULL,'Dahuk','DA'),(1836,368,NULL,'Dhi Qar','DQ'),(1837,368,NULL,'Diyala','DI'),(1838,368,NULL,'Karbala\'','KA'),(1839,368,NULL,'Maysan','MA'),(1840,368,NULL,'Ninawa','NI'),(1841,368,NULL,'Salah ad Din','SD'),(1842,368,NULL,'Wasit','WA'),(1843,364,NULL,'Ä€zarbÄyjÄn-e SharqÄ«','001'),(1844,364,NULL,'Ä€zarbÄyjÄn-e GharbÄ«','002'),(1845,364,NULL,'ArdabÄ«l','003'),(1846,364,NULL,'EÅŸfahÄn','004'),(1847,364,NULL,'ÄªlÄm','005'),(1848,364,NULL,'BÅ«shehr','006'),(1849,364,NULL,'TehrÄn','007'),(1850,364,NULL,'ChahÄr MahÄll va BakhtÄ«ÄrÄ«','008'),(1851,364,NULL,'KhÅ«zestÄn','010'),(1852,364,NULL,'ZanjÄn','011'),(1853,364,NULL,'SemnÄn','012'),(1854,364,NULL,'SÄ«stÄn va BalÅ«chestÄn','013'),(1855,364,NULL,'FÄrs','014'),(1856,364,NULL,'KermÄn','015'),(1857,364,NULL,'KordestÄn','016'),(1858,364,NULL,'KermÄnshÄh','017'),(1859,364,NULL,'KohgÄ«lÅ«yeh va BÅ«yer Ahmad','018'),(1860,364,NULL,'GÄ«lÄn','019'),(1861,364,NULL,'LorestÄn','020'),(1862,364,NULL,'MÄzandarÄn','021'),(1863,364,NULL,'MarkazÄ«','022'),(1864,364,NULL,'HormozgÄn','023'),(1865,364,NULL,'HamadÄn','024'),(1866,364,NULL,'Yazd','025'),(1867,364,NULL,'Qom','026'),(1868,364,NULL,'GolestÄn','027'),(1869,364,NULL,'QazvÄ«n','028'),(1870,364,NULL,'KhorÄsÄn-e JanÅ«bÄ«','029'),(1871,364,NULL,'KhorÄsÄn-e RazavÄ«','030'),(1872,364,NULL,'KhorÄsÄn-e ShemÄlÄ«','031'),(1873,352,NULL,'ReykjavÃ­k','000'),(1874,352,NULL,'HÃ¶fuÃ°borgarsvÃ¦Ã°iÃ°','001'),(1875,352,NULL,'SuÃ°urnes','002'),(1876,352,NULL,'Vesturland','003'),(1877,352,NULL,'VestfirÃ°ir','004'),(1878,352,NULL,'NorÃ°urland vestra','005'),(1879,352,NULL,'NorÃ°urland eystra','006'),(1880,352,NULL,'Austurland','007'),(1881,352,NULL,'SuÃ°urland','008'),(1882,380,NULL,'Agrigento','AG'),(1883,380,NULL,'Alessandria','AL'),(1884,380,NULL,'Ancona','AN'),(1885,380,NULL,'Aosta','AO'),(1886,380,NULL,'Arezzo','AR'),(1887,380,NULL,'Ascoli Piceno','AP'),(1888,380,NULL,'Asti','AT'),(1889,380,NULL,'Avellino','AV'),(1890,380,NULL,'Bari','BA'),(1891,380,NULL,'Belluno','BL'),(1892,380,NULL,'Benevento','BN'),(1893,380,NULL,'Bergamo','BG'),(1894,380,NULL,'Biella','BI'),(1895,380,NULL,'Bologna','BO'),(1896,380,NULL,'Bolzano','BZ'),(1897,380,NULL,'Brescia','BS'),(1898,380,NULL,'Brindisi','BR'),(1899,380,NULL,'Cagliari','CA'),(1900,380,NULL,'Caltanissetta','CL'),(1901,380,NULL,'Campobasso','CB'),(1902,380,NULL,'Carbonia-Iglesias','CI'),(1903,380,NULL,'Caserta','CE'),(1904,380,NULL,'Catania','CT'),(1905,380,NULL,'Catanzaro','CZ'),(1906,380,NULL,'Chieti','CH'),(1907,380,NULL,'Como','CO'),(1908,380,NULL,'Cosenza','CS'),(1909,380,NULL,'Cremona','CR'),(1910,380,NULL,'Crotone','KR'),(1911,380,NULL,'Cuneo','CN'),(1912,380,NULL,'Enna','EN'),(1913,380,NULL,'Ferrara','FE'),(1914,380,NULL,'Firenze','FI'),(1915,380,NULL,'Foggia','FG'),(1916,380,NULL,'ForlÃ¬','FO'),(1917,380,NULL,'Frosinone','FR'),(1918,380,NULL,'Genova','GE'),(1919,380,NULL,'Gorizia','GO'),(1920,380,NULL,'Grosseto','GR'),(1921,380,NULL,'Imperia','IM'),(1922,380,NULL,'Isernia','IS'),(1923,380,NULL,'La Spezia','SP'),(1924,380,NULL,'L\'Aquila','AQ'),(1925,380,NULL,'Latina','LT'),(1926,380,NULL,'Lecce','LE'),(1927,380,NULL,'Lecco','LC'),(1928,380,NULL,'Livorno','LI'),(1929,380,NULL,'Lodi','LO'),(1930,380,NULL,'Lucca','LU'),(1931,380,NULL,'Macerata','SC'),(1932,380,NULL,'Mantova','MN'),(1933,380,NULL,'Massa-Carrara','MS'),(1934,380,NULL,'Matera','MT'),(1935,380,NULL,'Medio Campidano','VS'),(1936,380,NULL,'Messina','ME'),(1937,380,NULL,'Milano','MI'),(1938,380,NULL,'Modena','MO'),(1939,380,NULL,'Napoli','NA'),(1940,380,NULL,'Novara','NO'),(1941,380,NULL,'Nuoro','NU'),(1942,380,NULL,'Ogliastra','OG'),(1943,380,NULL,'Olbia-Tempio','OT'),(1944,380,NULL,'Oristano','OR'),(1945,380,NULL,'Padova','PD'),(1946,380,NULL,'Palermo','PA'),(1947,380,NULL,'Parma','PR'),(1948,380,NULL,'Pavia','PV'),(1949,380,NULL,'Perugia','PG'),(1950,380,NULL,'Pesaro e Urbino','PS'),(1951,380,NULL,'Pescara','PE'),(1952,380,NULL,'Piacenza','PC'),(1953,380,NULL,'Pisa','PI'),(1954,380,NULL,'Pistoia','PT'),(1955,380,NULL,'Pordenone','PN'),(1956,380,NULL,'Potenza','PZ'),(1957,380,NULL,'Prato','PO'),(1958,380,NULL,'Ragusa','RG'),(1959,380,NULL,'Ravenna','RA'),(1960,380,NULL,'Reggio Calabria','RC'),(1961,380,NULL,'Reggio Emilia','RE'),(1962,380,NULL,'Rieti','RI'),(1963,380,NULL,'Rimini','RN'),(1964,380,NULL,'Roma','RM'),(1965,380,NULL,'Rovigo','RO'),(1966,380,NULL,'Salerno','SA'),(1967,380,NULL,'Sassari','SS'),(1968,380,NULL,'Savona','SV'),(1969,380,NULL,'Siena','SI'),(1970,380,NULL,'Siracusa','SR'),(1971,380,NULL,'Sondrio','SO'),(1972,380,NULL,'Taranto','TA'),(1973,380,NULL,'Teramo','TE'),(1974,380,NULL,'Terni','TR'),(1975,380,NULL,'Torino','TO'),(1976,380,NULL,'Trapani','TP'),(1977,380,NULL,'Trento','TN'),(1978,380,NULL,'Treviso','TV'),(1979,380,NULL,'Trieste','TS'),(1980,380,NULL,'Udine','UD'),(1981,380,NULL,'Varese','VA'),(1982,380,NULL,'Venezia','VE'),(1983,380,NULL,'Verbano-Cusio-Ossola','VB'),(1984,380,NULL,'Vercelli','VC'),(1985,380,NULL,'Verona','VR'),(1986,380,NULL,'Vibo Valentia','VV'),(1987,380,NULL,'Vicenza','VI'),(1988,380,NULL,'Viterbo','VT'),(1989,388,NULL,'Kingston','001'),(1990,388,NULL,'Saint Andrew','002'),(1991,388,NULL,'Saint Thomas','003'),(1992,388,NULL,'Portland','004'),(1993,388,NULL,'Saint Mary','005'),(1994,388,NULL,'Saint Ann','006'),(1995,388,NULL,'Trelawny','007'),(1996,388,NULL,'Saint James','008'),(1997,388,NULL,'Hanover','009'),(1998,388,NULL,'Westmoreland','010'),(1999,388,NULL,'Saint Elizabeth','011'),(2000,388,NULL,'Manchester','012'),(2001,388,NULL,'Clarendon','013'),(2002,388,NULL,'Saint Catherine','014'),(2003,400,NULL,'`Ajlun','AJ'),(2004,400,NULL,'Al `Aqabah','AQ'),(2005,400,NULL,'Al BalqÄ\'','BA'),(2006,400,NULL,'Al Karak','KA'),(2007,400,NULL,'Al Mafraq','MA'),(2008,400,NULL,'Amman','AM'),(2009,400,NULL,'AÅ£ Å¢afÄ«lah','AT'),(2010,400,NULL,'Az ZarqÄ\'','AZ'),(2011,400,NULL,'Irbid','JR'),(2012,400,NULL,'Jarash','JA'),(2013,400,NULL,'Ma`Än','MN'),(2014,400,NULL,'MÄdabÄ','MD'),(2015,392,NULL,'Hokkaido','001'),(2016,392,NULL,'Aomori','002'),(2017,392,NULL,'Iwate','003'),(2018,392,NULL,'Miyagi','004'),(2019,392,NULL,'Akita','005'),(2020,392,NULL,'Yamagata','006'),(2021,392,NULL,'Fukushima','007'),(2022,392,NULL,'Ibaraki','008'),(2023,392,NULL,'Tochigi','009'),(2024,392,NULL,'Gunma','010'),(2025,392,NULL,'Saitama','011'),(2026,392,NULL,'Chiba','012'),(2027,392,NULL,'Tokyo','013'),(2028,392,NULL,'Kanagawa','014'),(2029,392,NULL,'Niigata','015'),(2030,392,NULL,'Toyama','016'),(2031,392,NULL,'Ishikawa','017'),(2032,392,NULL,'Fukui','018'),(2033,392,NULL,'Yamanashi','019'),(2034,392,NULL,'Nagano','020'),(2035,392,NULL,'Gifu','021'),(2036,392,NULL,'Shizuoka','022'),(2037,392,NULL,'Aichi','023'),(2038,392,NULL,'Mie','024'),(2039,392,NULL,'Shiga','025'),(2040,392,NULL,'Kyoto','026'),(2041,392,NULL,'Osaka','027'),(2042,392,NULL,'Hyogo','028'),(2043,392,NULL,'Nara','029'),(2044,392,NULL,'Wakayama','030'),(2045,392,NULL,'Tottori','031'),(2046,392,NULL,'Shimane','032'),(2047,392,NULL,'Okayama','033'),(2048,392,NULL,'Hiroshima','034'),(2049,392,NULL,'Yamaguchi','035'),(2050,392,NULL,'Tokushima','036'),(2051,392,NULL,'Kagawa','037'),(2052,392,NULL,'Ehime','038'),(2053,392,NULL,'Kochi','039'),(2054,392,NULL,'Fukuoka','040'),(2055,392,NULL,'Saga','041'),(2056,392,NULL,'Nagasaki','042'),(2057,392,NULL,'Kumamoto','043'),(2058,392,NULL,'Oita','044'),(2059,392,NULL,'Miyazaki','045'),(2060,392,NULL,'Kagoshima','046'),(2061,392,NULL,'Okinawa','047'),(2062,404,NULL,'Nairobi Municipality','110'),(2063,404,NULL,'Central','200'),(2064,404,NULL,'Coast','300'),(2065,404,NULL,'Eastern','400'),(2066,404,NULL,'North-Eastern Kaskazini Mashariki','500'),(2067,404,NULL,'Rift Valley','700'),(2068,404,NULL,'Western Magharibi','900'),(2069,417,NULL,'Bishkek','GB'),(2070,417,NULL,'Batken','B'),(2071,417,NULL,'ChÃ¼','C'),(2072,417,NULL,'Jalal-Abad','J'),(2073,417,NULL,'Naryn','N'),(2074,417,NULL,'Osh','O'),(2075,417,NULL,'Talas','T'),(2076,417,NULL,'Ysyk-KÃ¶l','Y'),(2077,116,NULL,'Banteay Mean Chey','001'),(2078,116,NULL,'Battambang','002'),(2079,116,NULL,'Kampong Cham','003'),(2080,116,NULL,'Kampong Chhnang','004'),(2081,116,NULL,'Kampong Speu','005'),(2082,116,NULL,'Kampong Thom','006'),(2083,116,NULL,'Kampot','007'),(2084,116,NULL,'Kandal','008'),(2085,116,NULL,'Kach Kong','009'),(2086,116,NULL,'Krachoh','010'),(2087,116,NULL,'Mondol Kiri','011'),(2088,116,NULL,'Phnom Penh','012'),(2089,116,NULL,'Preah Vihear','013'),(2090,116,NULL,'Prey Veaeng','014'),(2091,116,NULL,'Pousaat','015'),(2092,116,NULL,'Rotanak Kiri','016'),(2093,116,NULL,'Siem Reab','017'),(2094,116,NULL,'Krong Preah Sihanouk','018'),(2095,116,NULL,'Stueng Traeng','019'),(2096,116,NULL,'Svaay Rieng','020'),(2097,116,NULL,'Taakaev','021'),(2098,116,NULL,'Otdar Mean Chey','022'),(2099,116,NULL,'Krong Kaeb','023'),(2100,116,NULL,'Krong Pailin','024'),(2101,296,NULL,'Gilbert Islands','G'),(2102,296,NULL,'Line Islands','L'),(2103,296,NULL,'Phoenix Islands','P'),(2104,659,NULL,'Christ Church Nichola Town','001'),(2105,659,NULL,'Saint Anne Sandy Point','002'),(2106,659,NULL,'Saint George Basseterre','003'),(2107,659,NULL,'Saint George Gingerland','004'),(2108,659,NULL,'Saint James Windward','005'),(2109,659,NULL,'Saint John Capisterre','006'),(2110,659,NULL,'Saint John Figtree','007'),(2111,659,NULL,'Saint Mary Cayon','008'),(2112,659,NULL,'Saint Paul Capisterre','009'),(2113,659,NULL,'Saint Paul Charlestown','010'),(2114,659,NULL,'Saint Peter Basseterre','011'),(2115,659,NULL,'Saint Thomas Lowland','012'),(2116,659,NULL,'Saint Thomas Middle Island','013'),(2117,659,NULL,'Trinity Palmetto Point','015'),(2118,174,NULL,'Anjouan Ndzouani','A'),(2119,174,NULL,'Grande Comore Ngazidja','G'),(2120,174,NULL,'MohÃ©li Moili','M'),(2121,408,NULL,'Chagang','CHA'),(2122,408,NULL,'Hamgyongbuk','HAB'),(2123,408,NULL,'Hamgyongnam','HAN'),(2124,408,NULL,'Hwanghaebuk','HWB'),(2125,408,NULL,'Hwanghaenam','HWN'),(2126,408,NULL,'Kangwon','KAN'),(2127,408,NULL,'Pyonganbuk','PYB'),(2128,408,NULL,'Pyongannam','PYN'),(2129,408,NULL,'Yanggang','YAN'),(2130,408,NULL,'Kaesong','KAE'),(2131,408,NULL,'Najin Sonbong','NAJ'),(2132,408,NULL,'Nampo','NAM'),(2133,408,NULL,'Pyongyang','PYO'),(2134,410,NULL,'Seoul Teugbyeolsi','011'),(2135,410,NULL,'Busan Gwang\'yeogsi','026'),(2136,410,NULL,'Daegu Gwang\'yeogsi','027'),(2137,410,NULL,'Incheon Gwang\'yeogsi','028'),(2138,410,NULL,'Gwangju Gwang\'yeogsi','029'),(2139,410,NULL,'Daejeon Gwang\'yeogsi','030'),(2140,410,NULL,'Ulsan Gwang\'yeogsi','031'),(2141,410,NULL,'Gyeonggido','041'),(2142,410,NULL,'Gang\'weondo','042'),(2143,410,NULL,'Chungcheongbukdo','043'),(2144,410,NULL,'Chungcheongnamdo','044'),(2145,410,NULL,'Jeonrabukdo','045'),(2146,410,NULL,'Jeonranamdo','046'),(2147,410,NULL,'Gyeongsangbukdo','047'),(2148,410,NULL,'Gyeongsangnamdo','048'),(2149,410,NULL,'Jejudo','049'),(2150,414,NULL,'Al Ahmadi','AH'),(2151,414,NULL,'Al FarwÄnÄ«yah','FA'),(2152,414,NULL,'Al Jahrah','JA'),(2153,414,NULL,'Al Kuwayt','KU'),(2154,414,NULL,'HawallÄ«','HA'),(2155,398,NULL,'Almaty','ALA'),(2156,398,NULL,'Astana','AST'),(2157,398,NULL,'Almaty','ALM'),(2158,398,NULL,'Aqmola','AKM'),(2159,398,NULL,'AqtÃ¶be','AKT'),(2160,398,NULL,'AtyraÅ«','ATY'),(2161,398,NULL,'Batys Quzaqstan','ZAP'),(2162,398,NULL,'MangghystaÅ«','MAN'),(2163,398,NULL,'OngtÃ¼stik Qazaqstan','YUZ'),(2164,398,NULL,'Pavlodar','PAV'),(2165,398,NULL,'Qaraghandy','KAR'),(2166,398,NULL,'Qostanay','KUS'),(2167,398,NULL,'Qyzylorda','KZY'),(2168,398,NULL,'Shyghys Qazaqstan','VOS'),(2169,398,NULL,'SoltÃ¼stik Quzaqstan','SEV'),(2170,398,NULL,'Zhambyl','ZHA'),(2171,418,NULL,'Vientiane','VT'),(2172,418,NULL,'Attapu','AT'),(2173,418,NULL,'BokÃ¨o','BK'),(2174,418,NULL,'Bolikhamxai','BL'),(2175,418,NULL,'Champasak','CH'),(2176,418,NULL,'Houaphan','HO'),(2177,418,NULL,'Khammouan','KH'),(2178,418,NULL,'Louang Namtha','LM'),(2179,418,NULL,'Louangphabang','LP'),(2180,418,NULL,'OudÃ´mxai','OU'),(2181,418,NULL,'PhÃ´ngsali','PH'),(2182,418,NULL,'Salavan','SL'),(2183,418,NULL,'SavannakhÃ©t','SV'),(2184,418,NULL,'Vientiane','VI'),(2185,418,NULL,'Xaignabouli','XA'),(2186,418,NULL,'XÃ©kong','XE'),(2187,418,NULL,'Xiangkhoang','XI'),(2188,418,NULL,'XiasÃ´mboun','XN'),(2189,438,NULL,'Balzers','001'),(2190,438,NULL,'Eschen','002'),(2191,438,NULL,'Gamprin','003'),(2192,438,NULL,'Mauren','004'),(2193,438,NULL,'Planken','005'),(2194,438,NULL,'Ruggell','006'),(2195,438,NULL,'Schaan','007'),(2196,438,NULL,'Schellenberg','008'),(2197,438,NULL,'Triesen','009'),(2198,438,NULL,'Triesenberg','010'),(2199,438,NULL,'Vaduz','011'),(2200,422,NULL,'AakkÃ¢r','AK'),(2201,422,NULL,'Baalbek-Hermel','BH'),(2202,422,NULL,'BÃ©qaa','BI'),(2203,422,NULL,'Beyrouth','BA'),(2204,422,NULL,'Liban-Nord','AS'),(2205,422,NULL,'Liban-Sud','JA'),(2206,422,NULL,'Mont-Liban','JL'),(2207,422,NULL,'NabatÃ®yÃ©','NA'),(2208,144,NULL,'Colombo','011'),(2209,144,NULL,'Gampaha','012'),(2210,144,NULL,'Kalutara','013'),(2211,144,NULL,'Kandy','021'),(2212,144,NULL,'Matale','022'),(2213,144,NULL,'Nuwara Eliya','023'),(2214,144,NULL,'Galle','031'),(2215,144,NULL,'Matara','032'),(2216,144,NULL,'Hambantota','033'),(2217,144,NULL,'Jaffna','041'),(2218,144,NULL,'Kilinochchi','042'),(2219,144,NULL,'Mannar','043'),(2220,144,NULL,'Vavuniya','044'),(2221,144,NULL,'Mullaittivu','045'),(2222,144,NULL,'Batticaloa','051'),(2223,144,NULL,'Ampara','052'),(2224,144,NULL,'Trincomalee','053'),(2225,144,NULL,'Kurunegala','061'),(2226,144,NULL,'Puttalum','062'),(2227,144,NULL,'Anuradhapura','071'),(2228,144,NULL,'Polonnaruwa','072'),(2229,144,NULL,'Badulla','081'),(2230,144,NULL,'Monaragala','082'),(2231,144,NULL,'Ratnapura','091'),(2232,144,NULL,'Kegalla','092'),(2233,430,NULL,'Bomi','BM'),(2234,430,NULL,'Bong','BG'),(2235,430,NULL,'Grand Bassa','GB'),(2236,430,NULL,'Grand Cape Mount','CM'),(2237,430,NULL,'Grand Gedeh','GG'),(2238,430,NULL,'Grand Kru','GK'),(2239,430,NULL,'Lofa','LO'),(2240,430,NULL,'Margibi','MG'),(2241,430,NULL,'Maryland','MY'),(2242,430,NULL,'Montserrado','MO'),(2243,430,NULL,'Nimba','NI'),(2244,430,NULL,'Rivercess','RI'),(2245,430,NULL,'Sinoe','SI'),(2246,426,NULL,'Berea','D'),(2247,426,NULL,'Butha-Buthe','B'),(2248,426,NULL,'Leribe','C'),(2249,426,NULL,'Mafeteng','E'),(2250,426,NULL,'Maseru','A'),(2251,426,NULL,'Mohale\'s Hoek','F'),(2252,426,NULL,'Mokhotlong','J'),(2253,426,NULL,'Qacha\'s Nek','H'),(2254,426,NULL,'Quthing','G'),(2255,426,NULL,'Thaba-Tseka','K'),(2256,440,NULL,'Alytaus','AL'),(2257,440,NULL,'Kauno','KU'),(2258,440,NULL,'KlaipÄ—dos','KL'),(2259,440,NULL,'MarijampolÄ—s','MR'),(2260,440,NULL,'PanevÄ—Å¾io','PN'),(2261,440,NULL,'Å iauliÅ³','SA'),(2262,440,NULL,'TauragÃ©s','TA'),(2263,440,NULL,'TelÅ¡iÅ³','TE'),(2264,440,NULL,'Utenos','UT'),(2265,440,NULL,'Vilniaus','VL'),(2266,442,NULL,'Diekirch','D'),(2267,442,NULL,'Grevenmacher','G'),(2268,442,NULL,'Luxembourg','L'),(2269,428,NULL,'Aizkraukle','AI'),(2270,428,NULL,'AlÅ«ksne','AL'),(2271,428,NULL,'Balvi','BL'),(2272,428,NULL,'Bauska','BU'),(2273,428,NULL,'CÄ“sis','CE'),(2274,428,NULL,'Daugavpils','DA'),(2275,428,NULL,'Dobele','DO'),(2276,428,NULL,'Gulbene','GU'),(2277,428,NULL,'JÄ“kabpils','JK'),(2278,428,NULL,'Jelgava','JL'),(2279,428,NULL,'KrÄslava','KR'),(2280,428,NULL,'KuldÄ«ga','KU'),(2281,428,NULL,'LiepÄja','LE'),(2282,428,NULL,'LimbaÅ¾i','LM'),(2283,428,NULL,'Ludza','LU'),(2284,428,NULL,'Madona','MA'),(2285,428,NULL,'Ogre','OG'),(2286,428,NULL,'PreiÄ¼i','PR'),(2287,428,NULL,'RÄ“zekne','RE'),(2288,428,NULL,'RÄ«ga','RI'),(2289,428,NULL,'Saldus','SA'),(2290,428,NULL,'Talsi','TA'),(2291,428,NULL,'Tukums','TU'),(2292,428,NULL,'Valka','VK'),(2293,428,NULL,'Valmiera','VM'),(2294,428,NULL,'Ventspils','VE'),(2295,428,NULL,'Daugavpils','DGV'),(2296,428,NULL,'Jelgava','JEL'),(2297,428,NULL,'JÅ«rmala','JUR'),(2298,428,NULL,'LiepÄja','LPX'),(2299,428,NULL,'RÄ“zekne','REZ'),(2300,428,NULL,'RÄ«ga','RIX'),(2301,428,NULL,'Ventspils','VEN'),(2302,434,NULL,'AjdÄbiyÄ','AJ'),(2303,434,NULL,'Al BuÅ£nÄn','BU'),(2304,434,NULL,'Al á¸¨izÄm al Akhá¸‘ar','HZ'),(2305,434,NULL,'Al Jabal al Akhá¸‘ar','JA'),(2306,434,NULL,'Al JifÄrah','JI'),(2307,434,NULL,'Al Jufrah','JU'),(2308,434,NULL,'Al Kufrah','KF'),(2309,434,NULL,'Al Marj','MJ'),(2310,434,NULL,'Al Marqab','MB'),(2311,434,NULL,'Al QaÅ£rÅ«n','QT'),(2312,434,NULL,'Al Qubbah','QB'),(2313,434,NULL,'Al WÄá¸©ah','WA'),(2314,434,NULL,'An NuqaÅ£ al Khams','NQ'),(2315,434,NULL,'Ash ShÄÅ£i\'','SH'),(2316,434,NULL,'Az ZÄwiyah','ZA'),(2317,434,NULL,'BanghÄzÄ«','BA'),(2318,434,NULL,'BanÄ« WalÄ«d','BW'),(2319,434,NULL,'Darnah','DR'),(2320,434,NULL,'GhadÄmis','GD'),(2321,434,NULL,'GharyÄn','GR'),(2322,434,NULL,'GhÄt','GT'),(2323,434,NULL,'JaghbÅ«b','JB'),(2324,434,NULL,'MiÅŸrÄtah','MI'),(2325,434,NULL,'Mizdah','MZ'),(2326,434,NULL,'Murzuq','MQ'),(2327,434,NULL,'NÄlÅ«t','NL'),(2328,434,NULL,'SabhÄ','SB'),(2329,434,NULL,'ÅžabrÄtah ÅžurmÄn','SS'),(2330,434,NULL,'Surt','SR'),(2331,434,NULL,'TÄjÅ«rÄ\' wa an NawÄá¸©Ä« al ArbÄÊ»','TN'),(2332,434,NULL,'Å¢arÄbulus','TB'),(2333,434,NULL,'TarhÅ«nah-MasallÄtah','TM'),(2334,434,NULL,'WÄdÄ« al á¸¨ayÄt','WD'),(2335,434,NULL,'Yafran-JÄdÅ«','YJ'),(2336,504,NULL,'Agadir','AGD'),(2337,504,NULL,'AÃ¯t Baha','BAH'),(2338,504,NULL,'AÃ¯t Melloul','MEL'),(2339,504,NULL,'Al Haouz','HAO'),(2340,504,NULL,'Al HoceÃ¯ma','HOC'),(2341,504,NULL,'Assa-Zag','ASZ'),(2342,504,NULL,'Azilal','AZI'),(2343,504,NULL,'Beni Mellal','BEM'),(2344,504,NULL,'Ben Sllmane','BES'),(2345,504,NULL,'Berkane','BER'),(2346,504,NULL,'Boujdour','BOD'),(2347,504,NULL,'Boulemane','BOM'),(2348,504,NULL,'Casablanca','CAS'),(2349,504,NULL,'Chefchaouene','CHE'),(2350,504,NULL,'Chichaoua','CHI'),(2351,504,NULL,'El Hajeb','HAJ'),(2352,504,NULL,'El Jadida','JDI'),(2353,504,NULL,'Errachidia','ERR'),(2354,504,NULL,'Essaouira','ESI'),(2355,504,NULL,'Es Smara','ESM'),(2356,504,NULL,'FÃ¨s','FES'),(2357,504,NULL,'Figuig','FIG'),(2358,504,NULL,'Guelmim','GUE'),(2359,504,NULL,'Ifrane','IFR'),(2360,504,NULL,'Jerada','JRA'),(2361,504,NULL,'Kelaat Sraghna','KES'),(2362,504,NULL,'KÃ©nitra','KEN'),(2363,504,NULL,'Khemisaet','KHE'),(2364,504,NULL,'Khenifra','KHN'),(2365,504,NULL,'Khouribga','KHO'),(2366,504,NULL,'LaÃ¢youne','LAA'),(2367,504,NULL,'Larache','LAP'),(2368,504,NULL,'Marrakech','MAR'),(2369,504,NULL,'MeknsÃ¨s','MEK'),(2370,504,NULL,'Nador','NAD'),(2371,504,NULL,'Ouarzazate','OUA'),(2372,504,NULL,'Oued ed Dahab','OUD'),(2373,504,NULL,'Oujda','OUJ'),(2374,504,NULL,'Rabat-SalÃ©','RBA'),(2375,504,NULL,'Safi','SAF'),(2376,504,NULL,'Sefrou','SEF'),(2377,504,NULL,'Settat','SET'),(2378,504,NULL,'Sidl Kacem','SIK'),(2379,504,NULL,'Tanger','TNG'),(2380,504,NULL,'Tan-Tan','TNT'),(2381,504,NULL,'Taounate','TAO'),(2382,504,NULL,'Taroudannt','TAR'),(2383,504,NULL,'Tata','TAT'),(2384,504,NULL,'Taza','TAZ'),(2385,504,NULL,'TÃ©touan','TET'),(2386,504,NULL,'Tiznit','TIZ'),(2387,498,NULL,'GÄƒgÄƒuzia','GA'),(2388,498,NULL,'ChiÅŸinÄƒu','CU'),(2389,498,NULL,'BÄƒlÅ£i','BA'),(2390,498,NULL,'Cahul','CA'),(2391,498,NULL,'ChiÅŸinÄƒu','CH'),(2392,498,NULL,'EdineÅ£','ED'),(2393,498,NULL,'LÄƒpuÅŸna','LA'),(2394,498,NULL,'Orhei','OR'),(2395,498,NULL,'Soroca','SO'),(2396,498,NULL,'Taraclia','TA'),(2397,498,NULL,'Tighina','TI'),(2398,498,NULL,'Ungheni','UN'),(2399,498,NULL,'StÃ®nga Nistrului','SN'),(2400,499,NULL,'Andrijevica','001'),(2401,499,NULL,'Bar','002'),(2402,499,NULL,'Berane','003'),(2403,499,NULL,'Bijelo Polje','004'),(2404,499,NULL,'Budva','005'),(2405,499,NULL,'Cetinje','006'),(2406,499,NULL,'Danilovgrad','007'),(2407,499,NULL,'Herceg-Novi','008'),(2408,499,NULL,'KolaÅ¡in','009'),(2409,499,NULL,'Kotor','010'),(2410,499,NULL,'Mojkovac','011'),(2411,499,NULL,'NikÅ¡iÄ‡','012'),(2412,499,NULL,'Plav','013'),(2413,499,NULL,'Pljevlja','014'),(2414,499,NULL,'PluÅ¾ine','015'),(2415,499,NULL,'Podgorica','016'),(2416,499,NULL,'RoÅ¾aje','017'),(2417,499,NULL,'Å avnik','018'),(2418,499,NULL,'Tivat','019'),(2419,499,NULL,'Ulcinj','020'),(2420,499,NULL,'Å½abljak','021'),(2421,450,NULL,'Antananarivo','T'),(2422,450,NULL,'Antsiranana','D'),(2423,450,NULL,'Fianarantsoa','F'),(2424,450,NULL,'Mahajanga','M'),(2425,450,NULL,'Toamasina','A'),(2426,450,NULL,'Toliara','U'),(2427,584,NULL,'Ailinglapalap','ALL'),(2428,584,NULL,'Ailuk','ALK'),(2429,584,NULL,'Arno','ARN'),(2430,584,NULL,'Aur','AUR'),(2431,584,NULL,'Ebon','EBO'),(2432,584,NULL,'Eniwetok','ENI'),(2433,584,NULL,'Jaluit','JAL'),(2434,584,NULL,'Kili','KIL'),(2435,584,NULL,'Kwajalein','KWA'),(2436,584,NULL,'Lae','LAE'),(2437,584,NULL,'Lib','LIB'),(2438,584,NULL,'Likiep','LIK'),(2439,584,NULL,'Majuro','MAJ'),(2440,584,NULL,'Maloelap','MAL'),(2441,584,NULL,'Mejit','MEJ'),(2442,584,NULL,'Mili','MIL'),(2443,584,NULL,'Namorik','NMK'),(2444,584,NULL,'Namu','NMU'),(2445,584,NULL,'Rongelap','RON'),(2446,584,NULL,'Ujae','UJA'),(2447,584,NULL,'Ujelang','UJL'),(2448,584,NULL,'Utirik','UTI'),(2449,584,NULL,'Wotho','WTN'),(2450,584,NULL,'Wotje','WTJ'),(2451,807,NULL,'Aerodrom','001'),(2452,807,NULL,'AraÄinovo','002'),(2453,807,NULL,'Berovo','003'),(2454,807,NULL,'Bitola','004'),(2455,807,NULL,'Bogdanci','005'),(2456,807,NULL,'Bogovinje','006'),(2457,807,NULL,'Bosilovo','007'),(2458,807,NULL,'Brvenica','008'),(2459,807,NULL,'Butel','009'),(2460,807,NULL,'Valandovo','010'),(2461,807,NULL,'Vasilevo','011'),(2462,807,NULL,'VevÄani','012'),(2463,807,NULL,'Veles','013'),(2464,807,NULL,'Vinica','014'),(2465,807,NULL,'VraneÅ¡tica','015'),(2466,807,NULL,'VrapÄiÅ¡te','016'),(2467,807,NULL,'Gazi Baba','017'),(2468,807,NULL,'Gevgelija','018'),(2469,807,NULL,'Gostivar','019'),(2470,807,NULL,'Gradsko','020'),(2471,807,NULL,'Debar','021'),(2472,807,NULL,'Debarca','022'),(2473,807,NULL,'DelÄevo','023'),(2474,807,NULL,'Demir Kapija','024'),(2475,807,NULL,'Demir Hisar','025'),(2476,807,NULL,'Dojran','026'),(2477,807,NULL,'Dolneni','027'),(2478,807,NULL,'Drugovo','028'),(2479,807,NULL,'GjorÄe Petrov','029'),(2480,807,NULL,'Å½elino','030'),(2481,807,NULL,'Zajas','031'),(2482,807,NULL,'Zelenikovo','032'),(2483,807,NULL,'Zrnovci','033'),(2484,807,NULL,'Ilinden','034'),(2485,807,NULL,'Jegunovce','035'),(2486,807,NULL,'Kavadarci','036'),(2487,807,NULL,'Karbinci','037'),(2488,807,NULL,'KarpoÅ¡','038'),(2489,807,NULL,'Kisela Voda','039'),(2490,807,NULL,'KiÄevo','040'),(2491,807,NULL,'KonÄe','041'),(2492,807,NULL,'KoÄani','042'),(2493,807,NULL,'Kratovo','043'),(2494,807,NULL,'Kriva Palanka','044'),(2495,807,NULL,'KrivogaÅ¡tani','045'),(2496,807,NULL,'KruÅ¡evo','046'),(2497,807,NULL,'Kumanovo','047'),(2498,807,NULL,'Lipkovo','048'),(2499,807,NULL,'Lozovo','049'),(2500,807,NULL,'Mavrovo-i-RostuÅ¡a','050'),(2501,807,NULL,'Makedonska Kamenica','051'),(2502,807,NULL,'Makedonski Brod','052'),(2503,807,NULL,'Mogila','053'),(2504,807,NULL,'Negotino','054'),(2505,807,NULL,'Novaci','055'),(2506,807,NULL,'Novo Selo','056'),(2507,807,NULL,'Oslomej','057'),(2508,807,NULL,'Ohrid','058'),(2509,807,NULL,'Petrovec','059'),(2510,807,NULL,'PehÄevo','060'),(2511,807,NULL,'Plasnica','061'),(2512,807,NULL,'Prilep','062'),(2513,807,NULL,'ProbiÅ¡tip','063'),(2514,807,NULL,'RadoviÅ¡','064'),(2515,807,NULL,'Rankovce','065'),(2516,807,NULL,'Resen','066'),(2517,807,NULL,'Rosoman','067'),(2518,807,NULL,'Saraj','068'),(2519,807,NULL,'Sveti Nikole','069'),(2520,807,NULL,'SopiÅ¡te','070'),(2521,807,NULL,'Staro NagoriÄane','071'),(2522,807,NULL,'Struga','072'),(2523,807,NULL,'Strumica','073'),(2524,807,NULL,'StudeniÄani','074'),(2525,807,NULL,'Tearce','075'),(2526,807,NULL,'Tetovo','076'),(2527,807,NULL,'Centar','077'),(2528,807,NULL,'Centar Å½upa','078'),(2529,807,NULL,'ÄŒair','079'),(2530,807,NULL,'ÄŒaÅ¡ka','080'),(2531,807,NULL,'ÄŒeÅ¡inovo-ObleÅ¡evo','081'),(2532,807,NULL,'ÄŒuÄer Sandevo','082'),(2533,807,NULL,'Å tip','083'),(2534,807,NULL,'Å uto Orizari','084'),(2535,466,NULL,'Kayes','001'),(2536,466,NULL,'Koulikoro','002'),(2537,466,NULL,'Sikasso','003'),(2538,466,NULL,'SÃ©gou','004'),(2539,466,NULL,'Mopti','005'),(2540,466,NULL,'Tombouctou','006'),(2541,466,NULL,'Gao','007'),(2542,466,NULL,'Kidal','008'),(2543,466,NULL,'Bamako','BK0'),(2544,104,NULL,'Sagaing','001'),(2545,104,NULL,'Bago','002'),(2546,104,NULL,'Magway','003'),(2547,104,NULL,'Mandalay','004'),(2548,104,NULL,'Tanintharyi','005'),(2549,104,NULL,'Yangon','006'),(2550,104,NULL,'Ayeyarwady','007'),(2551,104,NULL,'Kachin','011'),(2552,104,NULL,'Kayah','012'),(2553,104,NULL,'Kayin','013'),(2554,104,NULL,'Chin','014'),(2555,104,NULL,'Mon','015'),(2556,104,NULL,'Rakhine','016'),(2557,104,NULL,'Shan','017'),(2558,496,NULL,'Ulanbaatar','001'),(2559,496,NULL,'Orhon','035'),(2560,496,NULL,'Darhan uul','037'),(2561,496,NULL,'Hentiy','039'),(2562,496,NULL,'HÃ¶vsgÃ¶l','041'),(2563,496,NULL,'Hovd','043'),(2564,496,NULL,'Uvs','046'),(2565,496,NULL,'TÃ¶v','047'),(2566,496,NULL,'Selenge','049'),(2567,496,NULL,'SÃ¼hbaatar','051'),(2568,496,NULL,'Ã–mnÃ¶govi','053'),(2569,496,NULL,'Ã–vÃ¶rhangay','055'),(2570,496,NULL,'Dzavhan','057'),(2571,496,NULL,'Dundgovi','059'),(2572,496,NULL,'Dornod','061'),(2573,496,NULL,'Dornogovi','063'),(2574,496,NULL,'Govi-Sumber','064'),(2575,496,NULL,'Govi-Altay','065'),(2576,496,NULL,'Bulgan','067'),(2577,496,NULL,'Bayanhongor','069'),(2578,496,NULL,'Bayan-Ã–lgiy','071'),(2579,496,NULL,'Arhangay','073'),(2580,478,NULL,'Hodh ech Chargui','001'),(2581,478,NULL,'Hodh el Charbi','002'),(2582,478,NULL,'Assaba','003'),(2583,478,NULL,'Gorgol','004'),(2584,478,NULL,'Brakna','005'),(2585,478,NULL,'Trarza','006'),(2586,478,NULL,'Adrar','007'),(2587,478,NULL,'Dakhlet Nouadhibou','008'),(2588,478,NULL,'Tagant','009'),(2589,478,NULL,'Guidimaka','010'),(2590,478,NULL,'Tiris Zemmour','011'),(2591,478,NULL,'Inchiri','012'),(2592,478,NULL,'Nouakchott','NKC'),(2593,470,NULL,'Attard','001'),(2594,470,NULL,'Balzan','002'),(2595,470,NULL,'Birgu','003'),(2596,470,NULL,'Birkirkara','004'),(2597,470,NULL,'BirÅ¼ebbuÄ¡a','005'),(2598,470,NULL,'Bormla','006'),(2599,470,NULL,'Dingli','007'),(2600,470,NULL,'Fgura','008'),(2601,470,NULL,'Floriana','009'),(2602,470,NULL,'Fontana','010'),(2603,470,NULL,'Gudja','011'),(2604,470,NULL,'GÅ¼ira','012'),(2605,470,NULL,'GÄ§ajnsielem','013'),(2606,470,NULL,'GÄ§arb','014'),(2607,470,NULL,'GÄ§argÄ§ur','015'),(2608,470,NULL,'GÄ§asri','016'),(2609,470,NULL,'GÄ§axaq','017'),(2610,470,NULL,'Ä¦amrun','018'),(2611,470,NULL,'Iklin','019'),(2612,470,NULL,'Isla','020'),(2613,470,NULL,'Kalkara','021'),(2614,470,NULL,'KerÄ‹em','022'),(2615,470,NULL,'Kirkop','023'),(2616,470,NULL,'Lija','024'),(2617,470,NULL,'Luqa','025'),(2618,470,NULL,'Marsa','026'),(2619,470,NULL,'Marsaskala','027'),(2620,470,NULL,'Marsaxlokk','028'),(2621,470,NULL,'Mdina','029'),(2622,470,NULL,'MellieÄ§a','030'),(2623,470,NULL,'MÄ¡arr','031'),(2624,470,NULL,'Mosta','032'),(2625,470,NULL,'Mqabba','033'),(2626,470,NULL,'Msida','034'),(2627,470,NULL,'Mtarfa','035'),(2628,470,NULL,'Munxar','036'),(2629,470,NULL,'Nadur','037'),(2630,470,NULL,'Naxxar','038'),(2631,470,NULL,'Paola','039'),(2632,470,NULL,'Pembroke','040'),(2633,470,NULL,'PietÃ ','041'),(2634,470,NULL,'Qala','042'),(2635,470,NULL,'Qormi','043'),(2636,470,NULL,'Qrendi','044'),(2637,470,NULL,'Rabat GÄ§awdex','045'),(2638,470,NULL,'Rabat Malta','046'),(2639,470,NULL,'Safi','047'),(2640,470,NULL,'San Ä iljan','048'),(2641,470,NULL,'San Ä wann','049'),(2642,470,NULL,'San Lawrenz','050'),(2643,470,NULL,'San Pawl il-BaÄ§ar','051'),(2644,470,NULL,'Sannat','052'),(2645,470,NULL,'Santa LuÄ‹ija','053'),(2646,470,NULL,'Santa Venera','054'),(2647,470,NULL,'SiÄ¡Ä¡iewi','055'),(2648,470,NULL,'Sliema','056'),(2649,470,NULL,'Swieqi','057'),(2650,470,NULL,'Taâ€™ Xbiex','058'),(2651,470,NULL,'Tarxien','059'),(2652,470,NULL,'Valletta','060'),(2653,470,NULL,'XagÄ§ra','061'),(2654,470,NULL,'Xewkija','062'),(2655,470,NULL,'XgÄ§ajra','063'),(2656,470,NULL,'Å»abbar','064'),(2657,470,NULL,'Å»ebbuÄ¡ GÄ§awdex','065'),(2658,470,NULL,'Å»ebbuÄ¡ Malta','066'),(2659,470,NULL,'Å»ejtun','067'),(2660,470,NULL,'Å»urrieq','068'),(2661,480,NULL,'Beau Bassin-Rose Hill','BR'),(2662,480,NULL,'Curepipe','CU'),(2663,480,NULL,'Port Louis','PU'),(2664,480,NULL,'Quatre Bornes','QB'),(2665,480,NULL,'Vacoas-Phoenix','VP'),(2666,480,NULL,'Agalega Islands','AG'),(2667,480,NULL,'Cargados Carajos Shoals','CC'),(2668,480,NULL,'Rodrigues Island','RO'),(2669,480,NULL,'Black River','BL'),(2670,480,NULL,'Flacq','FL'),(2671,480,NULL,'Grand Port','GP'),(2672,480,NULL,'Moka','MO'),(2673,480,NULL,'Pamplemousses','PA'),(2674,480,NULL,'Plaines Wilhems','PW'),(2675,480,NULL,'Port Louis','PL'),(2676,480,NULL,'RiviÃ¨re du Rempart','RP'),(2677,480,NULL,'Savanne','SA'),(2678,462,NULL,'Seenu','001'),(2679,462,NULL,'Alif','002'),(2680,462,NULL,'Lhaviyani','003'),(2681,462,NULL,'Vaavu','004'),(2682,462,NULL,'Laamu','005'),(2683,462,NULL,'Haa Alif','007'),(2684,462,NULL,'Thaa','008'),(2685,462,NULL,'Meemu','012'),(2686,462,NULL,'Raa','013'),(2687,462,NULL,'Faafu','014'),(2688,462,NULL,'Dhaalu','017'),(2689,462,NULL,'Baa','020'),(2690,462,NULL,'Haa Dhaalu','023'),(2691,462,NULL,'Shaviyani','024'),(2692,462,NULL,'Noonu','025'),(2693,462,NULL,'Kaafu','026'),(2694,462,NULL,'Gaafu Aliff','027'),(2695,462,NULL,'Gaafu Daalu','028'),(2696,462,NULL,'Gnaviyani','029'),(2697,462,NULL,'Male','MLE'),(2698,454,NULL,'Balaka','BA'),(2699,454,NULL,'Blantyre','BL'),(2700,454,NULL,'Chikwawa','CK'),(2701,454,NULL,'Chiradzulu','CR'),(2702,454,NULL,'Chitipa','CT'),(2703,454,NULL,'Dedza','DE'),(2704,454,NULL,'Dowa','DO'),(2705,454,NULL,'Karonga','KR'),(2706,454,NULL,'Kasungu','KS'),(2707,454,NULL,'Likoma Island','LK'),(2708,454,NULL,'Lilongwe','LI'),(2709,454,NULL,'Machinga','MH'),(2710,454,NULL,'Mangochi','MG'),(2711,454,NULL,'Mchinji','MC'),(2712,454,NULL,'Mulanje','MU'),(2713,454,NULL,'Mwanza','MW'),(2714,454,NULL,'Mzimba','MZ'),(2715,454,NULL,'Nkhata Bay','NB'),(2716,454,NULL,'Nkhotakota','NK'),(2717,454,NULL,'Nsanje','NS'),(2718,454,NULL,'Ntcheu','NU'),(2719,454,NULL,'Ntchisi','NI'),(2720,454,NULL,'Phalombe','PH'),(2721,454,NULL,'Rumphi','RU'),(2722,454,NULL,'Salima','SA'),(2723,454,NULL,'Thyolo','TH'),(2724,454,NULL,'Zomba','ZO'),(2725,484,NULL,'Distrito Federal','DIF'),(2726,484,NULL,'Aguascalientes','AGU'),(2727,484,NULL,'Baja California','BCN'),(2728,484,NULL,'Baja California Sur','BCS'),(2729,484,NULL,'Campeche','CAM'),(2730,484,NULL,'Coahuila','COA'),(2731,484,NULL,'Colima','COL'),(2732,484,NULL,'Chiapas','CHP'),(2733,484,NULL,'Chihuahua','CHH'),(2734,484,NULL,'Durango','DUR'),(2735,484,NULL,'Guanajuato','GUA'),(2736,484,NULL,'Guerrero','GRO'),(2737,484,NULL,'Hidalgo','HID'),(2738,484,NULL,'Jalisco','JAL'),(2739,484,NULL,'MÃ©xico','MEX'),(2740,484,NULL,'MichoacÃ¡n','MIC'),(2741,484,NULL,'Morelos','MOR'),(2742,484,NULL,'Nayarit','NAY'),(2743,484,NULL,'Nuevo LeÃ³n','NLE'),(2744,484,NULL,'Oaxaca','OAX'),(2745,484,NULL,'Puebla','PUE'),(2746,484,NULL,'QuerÃ©taro','QUE'),(2747,484,NULL,'Quintana Roo','ROO'),(2748,484,NULL,'San Luis PotosÃ­','SLP'),(2749,484,NULL,'Sinaloa','SIN'),(2750,484,NULL,'Sonora','SON'),(2751,484,NULL,'Tabasco','TAB'),(2752,484,NULL,'Tamaulipas','TAM'),(2753,484,NULL,'Tlaxcala','TLA'),(2754,484,NULL,'Veracruz','VER'),(2755,484,NULL,'YucatÃ¡n','YUC'),(2756,484,NULL,'Zacatecas','ZAC'),(2757,458,NULL,'Johor','001'),(2758,458,NULL,'Kedah','002'),(2759,458,NULL,'Kelantan','003'),(2760,458,NULL,'Melaka','004'),(2761,458,NULL,'Negeri Sembilan','005'),(2762,458,NULL,'Pahang','006'),(2763,458,NULL,'Pulau Pinang','007'),(2764,458,NULL,'Perak','008'),(2765,458,NULL,'Perlis','009'),(2766,458,NULL,'Selangor','010'),(2767,458,NULL,'Terengganu','011'),(2768,458,NULL,'Sabah','012'),(2769,458,NULL,'Sarawak','013'),(2770,458,NULL,'Kuala Lumpur','014'),(2771,458,NULL,'Labuan','015'),(2772,458,NULL,'Putrajaya','016'),(2773,508,NULL,'Maputo (city)','MPM'),(2774,508,NULL,'Cabo Delgado','P'),(2775,508,NULL,'Gaza','G'),(2776,508,NULL,'Inhambane','I'),(2777,508,NULL,'Manica','B'),(2778,508,NULL,'Maputo','L'),(2779,508,NULL,'Numpula','N'),(2780,508,NULL,'Niassa','A'),(2781,508,NULL,'Sofala','S'),(2782,508,NULL,'Tete','T'),(2783,508,NULL,'Zambezia','Q'),(2784,516,NULL,'Caprivi','CA'),(2785,516,NULL,'Erongo','ER'),(2786,516,NULL,'Hardap','HA'),(2787,516,NULL,'Karas','KA'),(2788,516,NULL,'Khomas','KH'),(2789,516,NULL,'Kunene','KU'),(2790,516,NULL,'Ohangwena','OW'),(2791,516,NULL,'Okavango','OK'),(2792,516,NULL,'Omaheke','OH'),(2793,516,NULL,'Omusati','OS'),(2794,516,NULL,'Oshana','ON'),(2795,516,NULL,'Oshikoto','OT'),(2796,516,NULL,'Otjozondjupa','OD'),(2797,562,NULL,'Agadez','001'),(2798,562,NULL,'Diffa','002'),(2799,562,NULL,'Dosso','003'),(2800,562,NULL,'Maradi','004'),(2801,562,NULL,'Tahoua','005'),(2802,562,NULL,'TillabÃ©ri','006'),(2803,562,NULL,'Zinder','007'),(2804,562,NULL,'Niamey','008'),(2805,566,NULL,'Abuja','FC'),(2806,566,NULL,'Abia','AB'),(2807,566,NULL,'Adamawa','AD'),(2808,566,NULL,'Akwa Ibom','AK'),(2809,566,NULL,'Anambra','AN'),(2810,566,NULL,'Bauchi','BA'),(2811,566,NULL,'Bayelsa','BY'),(2812,566,NULL,'Benue','BE'),(2813,566,NULL,'Borno','BO'),(2814,566,NULL,'Cross River','CR'),(2815,566,NULL,'Delta','DE'),(2816,566,NULL,'Ebonyi','EB'),(2817,566,NULL,'Edo','ED'),(2818,566,NULL,'Ekiti','EK'),(2819,566,NULL,'Enugu','EN'),(2820,566,NULL,'Gombe','GO'),(2821,566,NULL,'Imo','IM'),(2822,566,NULL,'Jigawa','JI'),(2823,566,NULL,'Kaduna','KD'),(2824,566,NULL,'Kano','KN'),(2825,566,NULL,'Katsina','KT'),(2826,566,NULL,'Kebbi','KE'),(2827,566,NULL,'Kogi','KO'),(2828,566,NULL,'Kwara','KW'),(2829,566,NULL,'Lagos','LA'),(2830,566,NULL,'Nassarawa','NA'),(2831,566,NULL,'Niger','NI'),(2832,566,NULL,'Ogun','OG'),(2833,566,NULL,'Ondo','ON'),(2834,566,NULL,'Osun','OS'),(2835,566,NULL,'Oyo','OY'),(2836,566,NULL,'Plateau','PL'),(2837,566,NULL,'Rivers','RI'),(2838,566,NULL,'Sokoto','SO'),(2839,566,NULL,'Taraba','TA'),(2840,566,NULL,'Yobe','YO'),(2841,566,NULL,'Zamfara','ZA'),(2842,558,NULL,'Boaco','BO'),(2843,558,NULL,'Carazo','CA'),(2844,558,NULL,'Chinandega','CI'),(2845,558,NULL,'Chontales','CO'),(2846,558,NULL,'EstelÃ­','ES'),(2847,558,NULL,'Granada','GR'),(2848,558,NULL,'Jinotega','JI'),(2849,558,NULL,'LeÃ³n','LE'),(2850,558,NULL,'Madriz','MD'),(2851,558,NULL,'Managua','MN'),(2852,558,NULL,'Masaya','MS'),(2853,558,NULL,'Matagalpa','MT'),(2854,558,NULL,'Nueva Segovia','NS'),(2855,558,NULL,'RÃ­o San Juan','SJ'),(2856,558,NULL,'Rivas','RI'),(2857,558,NULL,'AtlÃ¡ntico Norte','AN'),(2858,558,NULL,'AtlÃ¡ntico Sur','AS'),(2859,528,NULL,'Drenthe','DR'),(2860,528,NULL,'Flevoland','FL'),(2861,528,NULL,'Friesland','FR'),(2862,528,NULL,'Gelderland','GE'),(2863,528,NULL,'Groningen','GR'),(2864,528,NULL,'Limburg','LI'),(2865,528,NULL,'Noord-Brabant','NB'),(2866,528,NULL,'Noord-Holland','NH'),(2867,528,NULL,'Overijssel','OV'),(2868,528,NULL,'Utrecht','UT'),(2869,528,NULL,'Zeeland','ZE'),(2870,528,NULL,'Zu360Holland','ZH'),(2871,578,NULL,'Ã˜stfold','001'),(2872,578,NULL,'Akershus','002'),(2873,578,NULL,'Oslo','003'),(2874,578,NULL,'Hedmark','004'),(2875,578,NULL,'Oppland','005'),(2876,578,NULL,'Buskerud','006'),(2877,578,NULL,'Vestfold','007'),(2878,578,NULL,'Telemark','008'),(2879,578,NULL,'Aust-Agder','009'),(2880,578,NULL,'Vest-Agder','010'),(2881,578,NULL,'Rogaland','011'),(2882,578,NULL,'Hordaland','012'),(2883,578,NULL,'Sogn og Fjordane','014'),(2884,578,NULL,'MÃ¸re og Romsdal','015'),(2885,578,NULL,'SÃ¸r-TrÃ¸ndelag','016'),(2886,578,NULL,'Nord-TrÃ¸ndelag','017'),(2887,578,NULL,'Nordland','018'),(2888,578,NULL,'Troms','019'),(2889,578,NULL,'Finnmark','020'),(2890,578,NULL,'Svalbard','021'),(2891,578,NULL,'Jan Mayen','022'),(2892,520,NULL,'Aiwo','001'),(2893,520,NULL,'Anabar','002'),(2894,520,NULL,'Anetan','003'),(2895,520,NULL,'Anibare','004'),(2896,520,NULL,'Baiti','005'),(2897,520,NULL,'Boe','006'),(2898,520,NULL,'Buada','007'),(2899,520,NULL,'Denigomodu','008'),(2900,520,NULL,'Ewa','009'),(2901,520,NULL,'Ijuw','010'),(2902,520,NULL,'Meneng','011'),(2903,520,NULL,'Nibok','012'),(2904,520,NULL,'Uaboe','013'),(2905,520,NULL,'Yaren','014'),(2906,554,NULL,'Auckland','AUK'),(2907,554,NULL,'Bay of Plenty','BOP'),(2908,554,NULL,'Canterbury','CAN'),(2909,554,NULL,'Hawkes Bay','HKB'),(2910,554,NULL,'Manawatu-Wanganui','MWT'),(2911,554,NULL,'Northland','NTL'),(2912,554,NULL,'Otago','OTA'),(2913,554,NULL,'Southland','STL'),(2914,554,NULL,'Taranaki','TKI'),(2915,554,NULL,'Waikato','WKO'),(2916,554,NULL,'Wellington','WGN'),(2917,554,NULL,'West Coast','WTC'),(2918,554,NULL,'Gisborne','GIS'),(2919,554,NULL,'Marlborough','MBH'),(2920,554,NULL,'Nelson','NSN'),(2921,554,NULL,'Tasman','TAS'),(2922,512,NULL,'Ad Dakhillyah','DA'),(2923,512,NULL,'Al Batinah','BA'),(2924,512,NULL,'Al Wusta','WU'),(2925,512,NULL,'Ash Sharqlyah','SH'),(2926,512,NULL,'Az Zahirah','ZA'),(2927,512,NULL,'Al Janblyah','JA'),(2928,512,NULL,'Masqat','MA'),(2929,512,NULL,'Musandam','MU'),(2930,591,NULL,'Kuna Yala','000'),(2931,591,NULL,'Bocas del Toro','001'),(2932,591,NULL,'CoclÃ©','002'),(2933,591,NULL,'ColÃ³n','003'),(2934,591,NULL,'ChiriquÃ­','004'),(2935,591,NULL,'DariÃ©n','005'),(2936,591,NULL,'Herrera','006'),(2937,591,NULL,'Los Santos','007'),(2938,591,NULL,'PanamÃ¡','008'),(2939,591,NULL,'Veraguas','009'),(2940,604,NULL,'El Callao','CAL'),(2941,604,NULL,'Amazonas','AMA'),(2942,604,NULL,'Ancash','ANC'),(2943,604,NULL,'ApurÃ­mac','APU'),(2944,604,NULL,'Arequipa','ARE'),(2945,604,NULL,'Ayacucho','AYA'),(2946,604,NULL,'Cajamarca','CAJ'),(2947,604,NULL,'Cusco','CUS'),(2948,604,NULL,'Huancavelica','HUV'),(2949,604,NULL,'HuÃ¡nuco','HUC'),(2950,604,NULL,'Ica','ICA'),(2951,604,NULL,'JunÃ­n','JUN'),(2952,604,NULL,'La Libertad','LAL'),(2953,604,NULL,'Lambayeque','LAM'),(2954,604,NULL,'Lima','LIM'),(2955,604,NULL,'Loreto','LOR'),(2956,604,NULL,'Madre de Dios','MDD'),(2957,604,NULL,'Moquegua','MOQ'),(2958,604,NULL,'Pasco','PAS'),(2959,604,NULL,'Piura','PIU'),(2960,604,NULL,'Puno','PUN'),(2961,604,NULL,'San MartÃ­n','SAM'),(2962,604,NULL,'Tacna','TAC'),(2963,604,NULL,'Tumbes','TUM'),(2964,604,NULL,'Ucayali','UCA'),(2965,598,NULL,'Port Moresby','NCD'),(2966,598,NULL,'Central','CPM'),(2967,598,NULL,'Chimbu','CPK'),(2968,598,NULL,'Eastern Highlands','EHG'),(2969,598,NULL,'East New Britain','EBR'),(2970,598,NULL,'East Sepik','ESW'),(2971,598,NULL,'Enga','EPW'),(2972,598,NULL,'Gulf','GPK'),(2973,598,NULL,'Madang','MPM'),(2974,598,NULL,'Manus','MRL'),(2975,598,NULL,'Milne Bay','MBA'),(2976,598,NULL,'Morobe','MPL'),(2977,598,NULL,'New Ireland','NIK'),(2978,598,NULL,'Northern','NPP'),(2979,598,NULL,'North Solomons','NSA'),(2980,598,NULL,'Sandaun','SAN'),(2981,598,NULL,'Southern Highlands','SHM'),(2982,598,NULL,'Western','WPD'),(2983,598,NULL,'Western Highlands','WHM'),(2984,598,NULL,'West New Britain','WBK'),(2985,608,NULL,'Abra','ABR'),(2986,608,NULL,'Agusan del Norte','AGN'),(2987,608,NULL,'Agusan del Sur','AGS'),(2988,608,NULL,'Aklan','AKL'),(2989,608,NULL,'Albay','ALB'),(2990,608,NULL,'Antique','ANT'),(2991,608,NULL,'Apayao','APA'),(2992,608,NULL,'Aurora','AUR'),(2993,608,NULL,'Basilan','BAS'),(2994,608,NULL,'Batasn','BAN'),(2995,608,NULL,'Batanes','BTN'),(2996,608,NULL,'Batangas','BTG'),(2997,608,NULL,'Benguet','BEN'),(2998,608,NULL,'Biliran','BIL'),(2999,608,NULL,'Bohol','BOH'),(3000,608,NULL,'Bukidnon','BUK'),(3001,608,NULL,'Bulacan','BUL'),(3002,608,NULL,'Cagayan','CAG'),(3003,608,NULL,'Camarines Norte','CAN'),(3004,608,NULL,'Camarines Sur','CAS'),(3005,608,NULL,'Camiguin','CAM'),(3006,608,NULL,'Capiz','CAP'),(3007,608,NULL,'Catanduanes','CAT'),(3008,608,NULL,'Cavite','CAV'),(3009,608,NULL,'Cebu','CEB'),(3010,608,NULL,'Compostela Valley','COM'),(3011,608,NULL,'Davao del Norte','DAV'),(3012,608,NULL,'Davao del Sur','DAS'),(3013,608,NULL,'Davao Oriental','DAO'),(3014,608,NULL,'Eastern Samar','EAS'),(3015,608,NULL,'Guimaras','GUI'),(3016,608,NULL,'Ifugao','IFU'),(3017,608,NULL,'Ilocos Norte','ILN'),(3018,608,NULL,'Ilocos Sur','ILS'),(3019,608,NULL,'Iloilo','ILI'),(3020,608,NULL,'Isabela','ISA'),(3021,608,NULL,'Kalinga-Apayso','KAL'),(3022,608,NULL,'Laguna','LAG'),(3023,608,NULL,'Lanao del Norte','LAN'),(3024,608,NULL,'Lanao del Sur','LAS'),(3025,608,NULL,'La Union','LUN'),(3026,608,NULL,'Leyte','LEY'),(3027,608,NULL,'Maguindanao','MAG'),(3028,608,NULL,'Marinduque','MAD'),(3029,608,NULL,'Masbate','MAS'),(3030,608,NULL,'Mindoro Occidental','MDC'),(3031,608,NULL,'Mindoro Oriental','MDR'),(3032,608,NULL,'Misamis Occidental','MSC'),(3033,608,NULL,'Misamis Oriental','MSR'),(3034,608,NULL,'Mountain Province','MOU'),(3035,608,NULL,'Negroe Occidental','NEC'),(3036,608,NULL,'Negros Oriental','NER'),(3037,608,NULL,'North Cotabato','NCO'),(3038,608,NULL,'Northern Samar','NSA'),(3039,608,NULL,'Nueva Ecija','NUE'),(3040,608,NULL,'Nueva Vizcaya','NUV'),(3041,608,NULL,'Palawan','PLW'),(3042,608,NULL,'Pampanga','PAM'),(3043,608,NULL,'Pangasinan','PAN'),(3044,608,NULL,'Quezon','QUE'),(3045,608,NULL,'Quirino','QUI'),(3046,608,NULL,'Rizal','RIZ'),(3047,608,NULL,'Romblon','ROM'),(3048,608,NULL,'Sarangani','SAR'),(3049,608,NULL,'Siquijor','SIG'),(3050,608,NULL,'Sorsogon','SOR'),(3051,608,NULL,'South Cotabato','SCO'),(3052,608,NULL,'Southern Leyte','SLE'),(3053,608,NULL,'Sultan Kudarat','SUK'),(3054,608,NULL,'Sulu','SLU'),(3055,608,NULL,'Surigao del Norte','SUN'),(3056,608,NULL,'Surigao del Sur','SUR'),(3057,608,NULL,'Tarlac','TAR'),(3058,608,NULL,'Tawi-Tawi','TAW'),(3059,608,NULL,'Western Samar','WSA'),(3060,608,NULL,'Zambales','ZMB'),(3061,608,NULL,'Zamboanga del Norte','ZAN'),(3062,608,NULL,'Zamboanga del Sur','ZAS'),(3063,608,NULL,'Zamboanga Sibiguey','ZSI'),(3064,586,NULL,'Islamabad','IS'),(3065,586,NULL,'Balochistan','BA'),(3066,586,NULL,'North-West Frontier','NW'),(3067,586,NULL,'Punjab','PB'),(3068,586,NULL,'Sindh','SD'),(3069,586,NULL,'Federally Administered Tribal Areas','TA'),(3070,586,NULL,'Azad Rashmir','JK'),(3071,586,NULL,'Northern Areas','NA'),(3072,616,NULL,'DolnoÅ›lÄ…skie','DS'),(3073,616,NULL,'Kujawsko-pomorskie','KP'),(3074,616,NULL,'Lubelskie','LU'),(3075,616,NULL,'Lubuskie','LB'),(3076,616,NULL,'ÅÃ³dzkie','LD'),(3077,616,NULL,'MaÅ‚opolskie','MA'),(3078,616,NULL,'Mazowieckie','MZ'),(3079,616,NULL,'Opolskie','OP'),(3080,616,NULL,'Podkarpackie','PK'),(3081,616,NULL,'Podlaskie','PD'),(3082,616,NULL,'Pomorskie','PM'),(3083,616,NULL,'ÅšlÄ…skie','SL'),(3084,616,NULL,'ÅšwiÄ™tokrzyskie','SK'),(3085,616,NULL,'WarmiÅ„sko-mazurskie','WN'),(3086,616,NULL,'Wielkopolskie','WP'),(3087,616,NULL,'Zachodniopomorskie','ZP'),(3088,620,NULL,'Aveiro','001'),(3089,620,NULL,'Beja','002'),(3090,620,NULL,'Braga','003'),(3091,620,NULL,'BraganÃ§a','004'),(3092,620,NULL,'Castelo Branco','005'),(3093,620,NULL,'Coimbra','006'),(3094,620,NULL,'Ã‰vora','007'),(3095,620,NULL,'Faro','008'),(3096,620,NULL,'Guarda','009'),(3097,620,NULL,'Leiria','010'),(3098,620,NULL,'Lisboa','011'),(3099,620,NULL,'Portalegre','012'),(3100,620,NULL,'Porto','013'),(3101,620,NULL,'SantarÃ©m','014'),(3102,620,NULL,'SetÃºbal','015'),(3103,620,NULL,'Viana do Castelo','016'),(3104,620,NULL,'Vila Real','017'),(3105,620,NULL,'Viseu','018'),(3106,620,NULL,'RegiÃ£o AutÃ³noma dos AÃ§ores','020'),(3107,620,NULL,'RegiÃ£o AutÃ³noma da Madeira','030'),(3108,585,NULL,'Aimeliik','002'),(3109,585,NULL,'Airai','004'),(3110,585,NULL,'Angaur','010'),(3111,585,NULL,'Hatobohei','050'),(3112,585,NULL,'Kayangel','100'),(3113,585,NULL,'Koror','150'),(3114,585,NULL,'Melekeok','212'),(3115,585,NULL,'Ngaraard','214'),(3116,585,NULL,'Ngarchelong','218'),(3117,585,NULL,'Ngardmau','222'),(3118,585,NULL,'Ngatpang','224'),(3119,585,NULL,'Ngchesar','226'),(3120,585,NULL,'Ngeremlengui','227'),(3121,585,NULL,'Ngiwal','228'),(3122,585,NULL,'Peleliu','350'),(3123,585,NULL,'Sonsorol','370'),(3124,600,NULL,'ConcepciÃ³n','001'),(3125,600,NULL,'Alto ParanÃ¡','010'),(3126,600,NULL,'Central','011'),(3127,600,NULL,'Ã‘eembucÃº','012'),(3128,600,NULL,'Amambay','013'),(3129,600,NULL,'CanindeyÃº','014'),(3130,600,NULL,'Presidente Hayes','015'),(3131,600,NULL,'Alto Paraguay','016'),(3132,600,NULL,'BoquerÃ³n','019'),(3133,600,NULL,'San Pedro','002'),(3134,600,NULL,'Cordillera','003'),(3135,600,NULL,'GuairÃ¡','004'),(3136,600,NULL,'CaaguazÃº','005'),(3137,600,NULL,'CaazapÃ¡','006'),(3138,600,NULL,'ItapÃºa','007'),(3139,600,NULL,'Misiones','008'),(3140,600,NULL,'ParaguarÃ­','009'),(3141,600,NULL,'AsunciÃ³n','ASU'),(3142,634,NULL,'Ad Dawhah','DA'),(3143,634,NULL,'Al Ghuwayriyah','GH'),(3144,634,NULL,'Al Jumayliyah','JU'),(3145,634,NULL,'Al Khawr','KH'),(3146,634,NULL,'Al Wakrah','WA'),(3147,634,NULL,'Ar Rayyan','RA'),(3148,634,NULL,'Jariyan al Batnah','JB'),(3149,634,NULL,'Madinat ash Shamal','MS'),(3150,634,NULL,'Umm Salal','US'),(3151,642,NULL,'Alba','AB'),(3152,642,NULL,'Arad','AR'),(3153,642,NULL,'ArgeÅŸ','AG'),(3154,642,NULL,'BacÄƒu','BC'),(3155,642,NULL,'Bihor','BH'),(3156,642,NULL,'BistriÅ£a-NÄƒsÄƒud','BN'),(3157,642,NULL,'BotoÅŸani','BT'),(3158,642,NULL,'BraÅŸov','BV'),(3159,642,NULL,'BrÄƒila','BR'),(3160,642,NULL,'BuzÄƒu','BZ'),(3161,642,NULL,'CaraÅŸ-Severin','CS'),(3162,642,NULL,'CÄƒlÄƒraÅŸi','CL'),(3163,642,NULL,'Cluj','CJ'),(3164,642,NULL,'ConstanÅ£a','CT'),(3165,642,NULL,'Covasna','CV'),(3166,642,NULL,'DÃ¢mboviÅ£a','DB'),(3167,642,NULL,'Dolj','DJ'),(3168,642,NULL,'GalaÅ£i','GL'),(3169,642,NULL,'Giurgiu','GR'),(3170,642,NULL,'Gorj','GJ'),(3171,642,NULL,'Harghita','HR'),(3172,642,NULL,'Hunedoara','HD'),(3173,642,NULL,'IalomiÅ£a','IL'),(3174,642,NULL,'IaÅŸi','IS'),(3175,642,NULL,'Ilfov','IF'),(3176,642,NULL,'MaramureÅŸ','MM'),(3177,642,NULL,'MehedinÅ£i','MH'),(3178,642,NULL,'MureÅŸ','MS'),(3179,642,NULL,'NeamÅ£','NT'),(3180,642,NULL,'Olt','OT'),(3181,642,NULL,'Prahova','PH'),(3182,642,NULL,'Satu Mare','SM'),(3183,642,NULL,'SÄƒlaj','SJ'),(3184,642,NULL,'Sibiu','SB'),(3185,642,NULL,'Suceava','SV'),(3186,642,NULL,'Teleorman','TR'),(3187,642,NULL,'TimiÅŸ','TM'),(3188,642,NULL,'Tulcea','TL'),(3189,642,NULL,'Vaslui','VS'),(3190,642,NULL,'VÃ¢lcea','VL'),(3191,642,NULL,'Vrancea','VN'),(3192,642,NULL,'BucureÅŸti','B'),(3193,688,NULL,'Beograd','000'),(3194,688,NULL,'Severna BaÄka','001'),(3195,688,NULL,'Srednji Banat','002'),(3196,688,NULL,'Severni Banat','003'),(3197,688,NULL,'JuÅ¾ni Banat','004'),(3198,688,NULL,'Zapadna BaÄka','005'),(3199,688,NULL,'JuÅ¾na BaÄka','006'),(3200,688,NULL,'Srem','007'),(3201,688,NULL,'MaÄva','008'),(3202,688,NULL,'Kolubara','009'),(3203,688,NULL,'Podunavlje','010'),(3204,688,NULL,'BraniÄevo','011'),(3205,688,NULL,'Å umadija','012'),(3206,688,NULL,'Pomoravlje','013'),(3207,688,NULL,'Bor','014'),(3208,688,NULL,'ZajeÄar','015'),(3209,688,NULL,'Zlatibor','016'),(3210,688,NULL,'Moravica','017'),(3211,688,NULL,'RaÅ¡ka','018'),(3212,688,NULL,'Rasina','019'),(3213,688,NULL,'NiÅ¡ava','020'),(3214,688,NULL,'Toplica','021'),(3215,688,NULL,'Pirot','022'),(3216,688,NULL,'Jablanica','023'),(3217,688,NULL,'PÄinja','024'),(3218,688,NULL,'Kosovo','025'),(3219,688,NULL,'PeÄ‡','026'),(3220,688,NULL,'Prizren','027'),(3221,688,NULL,'Kosovska Mitrovica','028'),(3222,688,NULL,'Kosovo-Pomoravlje','029'),(3223,643,NULL,'Adygeya','AD'),(3224,643,NULL,'Altay','AL'),(3225,643,NULL,'Bashkortostan','BA'),(3226,643,NULL,'Buryatiya','BU'),(3227,643,NULL,'Chechenskaya Respublika','CE'),(3228,643,NULL,'Chuvashskaya Respublika','CU'),(3229,643,NULL,'Dagestan','DA'),(3230,643,NULL,'Respublika Ingushetiya','IN'),(3231,643,NULL,'Kabardino-Balkarskaya','KB'),(3232,643,NULL,'Kalmykiya','KL'),(3233,643,NULL,'Karachayevo-Cherkesskaya','KC'),(3234,643,NULL,'Kareliya','KR'),(3235,643,NULL,'Khakasiya','KK'),(3236,643,NULL,'Komi','KO'),(3237,643,NULL,'Mariy El','ME'),(3238,643,NULL,'Mordoviya','MO'),(3239,643,NULL,'Sakha','SA'),(3240,643,NULL,'Severnaya Osetiya-Alaniya','SE'),(3241,643,NULL,'Tatarstan','TA'),(3242,643,NULL,'Tyva','TY'),(3243,643,NULL,'Udmurtskaya','UD'),(3244,643,NULL,'Altayskiy','ALT'),(3245,643,NULL,'Kamchatskiy','KAM'),(3246,643,NULL,'Khabarovskiy','KHA'),(3247,643,NULL,'Krasnodarskiy','KDA'),(3248,643,NULL,'Krasnoyarskiy','KYA'),(3249,643,NULL,'Permskiy','PER'),(3250,643,NULL,'Primorskiy','PRI'),(3251,643,NULL,'Stavropol\'skiy','STA'),(3252,643,NULL,'Amurskaya','AMU'),(3253,643,NULL,'Arkhangel\'skaya','ARK'),(3254,643,NULL,'Astrakhanskaya','AST'),(3255,643,NULL,'Belgorodskaya','BEL'),(3256,643,NULL,'Bryanskaya','BRY'),(3257,643,NULL,'Chelyabinskaya','CHE'),(3258,643,NULL,'Chitinskaya','CHI'),(3259,643,NULL,'Irkutiskaya','IRK'),(3260,643,NULL,'Ivanovskaya','IVA'),(3261,643,NULL,'Kaliningradskaya','KGD'),(3262,643,NULL,'Kaluzhskaya','KLU'),(3263,643,NULL,'Kemerovskaya','KEM'),(3264,643,NULL,'Kirovskaya','KIR'),(3265,643,NULL,'Kostromskaya','KOS'),(3266,643,NULL,'Kurganskaya','KGN'),(3267,643,NULL,'Kurskaya','KRS'),(3268,643,NULL,'Leningradskaya','LEN'),(3269,643,NULL,'Lipetskaya','LIP'),(3270,643,NULL,'Magadanskaya','MAG'),(3271,643,NULL,'Moskovskaya','MOS'),(3272,643,NULL,'Murmanskaya','MUR'),(3273,643,NULL,'Nizhegorodskaya','NIZ'),(3274,643,NULL,'Novgorodskaya','NGR'),(3275,643,NULL,'Novosibirskaya','NVS'),(3276,643,NULL,'Omskaya','OMS'),(3277,643,NULL,'Orenburgskaya','ORE'),(3278,643,NULL,'Orlovskaya','ORL'),(3279,643,NULL,'Penzenskaya','PNZ'),(3280,643,NULL,'Pskovskaya','PSK'),(3281,643,NULL,'Rostovskaya','ROS'),(3282,643,NULL,'Ryazanskaya','RYA'),(3283,643,NULL,'Sakhalinskaya','SAK'),(3284,643,NULL,'Samaraskaya','SAM'),(3285,643,NULL,'Saratovskaya','SAR'),(3286,643,NULL,'Smolenskaya','SMO'),(3287,643,NULL,'Sverdlovskaya','SVE'),(3288,643,NULL,'Tambovskaya','TAM'),(3289,643,NULL,'Tomskaya','TOM'),(3290,643,NULL,'Tul\'skaya','TUL'),(3291,643,NULL,'Tverskaya','TVE'),(3292,643,NULL,'Tyumenskaya','TYU'),(3293,643,NULL,'Ul\'yanovskaya','ULY'),(3294,643,NULL,'Vladimirskaya','VLA'),(3295,643,NULL,'Volgogradskaya','VGG'),(3296,643,NULL,'Vologodskaya','VLG'),(3297,643,NULL,'Voronezhskaya','VOR'),(3298,643,NULL,'Yaroslavskaya','YAR'),(3299,643,NULL,'Moskva','MOW'),(3300,643,NULL,'Sankt-Peterburg','SPE'),(3301,643,NULL,'Yevreyskaya','YEV'),(3302,643,NULL,'Aginsky Buryatskiy','AGB'),(3303,643,NULL,'Chukotskiy','CHU'),(3304,643,NULL,'Khanty-Mansiysky','KHM'),(3305,643,NULL,'Nenetskiy','NEN'),(3306,643,NULL,'Ust\'-Ordynskiy Buryatskiy','UOB'),(3307,643,NULL,'Yamalo-Nenetskiy','YAN'),(3308,646,NULL,'Ville de Kigali','001'),(3309,646,NULL,'Est','002'),(3310,646,NULL,'Nord','003'),(3311,646,NULL,'Ouest','004'),(3312,646,NULL,'Sud','005'),(3313,682,NULL,'Ar RiyÄá¸','001'),(3314,682,NULL,'Makkah','002'),(3315,682,NULL,'Al MadÄ«nah','003'),(3316,682,NULL,'Ash SharqÄ«yah','004'),(3317,682,NULL,'Al QaÅŸÄ«m','005'),(3318,682,NULL,'á¸¤Ä\'il','006'),(3319,682,NULL,'TabÅ«k','007'),(3320,682,NULL,'Al á¸¤udÅ«d ash ShamÄliyah','008'),(3321,682,NULL,'JÄ«zan','009'),(3322,682,NULL,'NajrÄn','010'),(3323,682,NULL,'Al BÄhah','011'),(3324,682,NULL,'Al Jawf','012'),(3325,682,NULL,'`AsÄ«r','014'),(3326,90,NULL,'Honiara','CT'),(3327,90,NULL,'Central','CE'),(3328,90,NULL,'Choiseul','CH'),(3329,90,NULL,'Guadalcanal','GU'),(3330,90,NULL,'Isabel','IS'),(3331,90,NULL,'Makira','MK'),(3332,90,NULL,'Malaita','ML'),(3333,90,NULL,'Rennell and Bellona','RB'),(3334,90,NULL,'Temotu','TE'),(3335,90,NULL,'Western','WE'),(3336,690,NULL,'Anse aux Pins','001'),(3337,690,NULL,'Anse Boileau','002'),(3338,690,NULL,'Anse Ã‰toile','003'),(3339,690,NULL,'Anse Louis','004'),(3340,690,NULL,'Anse Royale','005'),(3341,690,NULL,'Baie Lazare','006'),(3342,690,NULL,'Baie Sainte Anne','007'),(3343,690,NULL,'Beau Vallon','008'),(3344,690,NULL,'Bel Air','009'),(3345,690,NULL,'Bel Ombre','010'),(3346,690,NULL,'Cascade','011'),(3347,690,NULL,'Glacis','012'),(3348,690,NULL,'Grand\' Anse (MahÃ©)','013'),(3349,690,NULL,'Grand\' Anse (Praslin)','014'),(3350,690,NULL,'La Digue','015'),(3351,690,NULL,'La RiviÃ¨re Anglaise','016'),(3352,690,NULL,'Mont Buxton','017'),(3353,690,NULL,'Mont Fleuri','018'),(3354,690,NULL,'Plaisance','019'),(3355,690,NULL,'Pointe La Rue','020'),(3356,690,NULL,'Port Glaud','021'),(3357,690,NULL,'Saint Louis','022'),(3358,690,NULL,'Takamaka','023'),(3359,736,NULL,'Ash ShamÄlÄ«yah','001'),(3360,736,NULL,'ShamÄl DÄrfÅ«r','002'),(3361,736,NULL,'Al KharÅ£Å«m','003'),(3362,736,NULL,'An NÄ«l','004'),(3363,736,NULL,'KassalÄ','005'),(3364,736,NULL,'Al Qaá¸‘Ärif','006'),(3365,736,NULL,'Al JazÄ«rah','007'),(3366,736,NULL,'An NÄ«l al Abyaá¸‘','008'),(3367,736,NULL,'ShamÄl KurdufÄn','009'),(3368,736,NULL,'JanÅ«b DÄrfÅ«r','011'),(3369,736,NULL,'Gharb DÄrfÅ«r','012'),(3370,736,NULL,'JanÅ«b KurdufÄn','013'),(3371,736,NULL,'Gharb Baá¸©r al GhazÄl','014'),(3372,736,NULL,'ShamÄl Baá¸©r al GhazÄl','015'),(3373,736,NULL,'Gharb al IstiwÄ\'Ä«yah','016'),(3374,736,NULL,'Baá¸©r al Jabal','017'),(3375,736,NULL,'Al Buá¸©ayrÄt','018'),(3376,736,NULL,'Sharq al IstiwÄ\'Ä«yah','019'),(3377,736,NULL,'JÅ«nqalÄ«','020'),(3378,736,NULL,'WÄrÄb','021'),(3379,736,NULL,'Al Waá¸©dah','022'),(3380,736,NULL,'Aâ€˜ÄlÄ« an NÄ«l','023'),(3381,736,NULL,'An NÄ«l al Azraq','024'),(3382,736,NULL,'SinnÄr','025'),(3383,736,NULL,'Al Baá¸©r al Aá¸©mar','026'),(3384,752,NULL,'Blekinge','K'),(3385,752,NULL,'Dalarnas','W'),(3386,752,NULL,'Gotlands','I'),(3387,752,NULL,'GÃ¤vleborgs','X'),(3388,752,NULL,'Hallands','N'),(3389,752,NULL,'JÃ¤mtlande','Z'),(3390,752,NULL,'JÃ¶nkÃ¶pings','F'),(3391,752,NULL,'Kalmar','H'),(3392,752,NULL,'Kronobergs','G'),(3393,752,NULL,'Norrbottens','BD'),(3394,752,NULL,'SkÃ¥ne','M'),(3395,752,NULL,'Stockholms','AB'),(3396,752,NULL,'SÃ¶dermanlands','D'),(3397,752,NULL,'Uppsala','C'),(3398,752,NULL,'VÃ¤rmlands','S'),(3399,752,NULL,'VÃ¤sterbottens','AC'),(3400,752,NULL,'VÃ¤sternorrlands','Y'),(3401,752,NULL,'VÃ¤stmanlands','U'),(3402,752,NULL,'VÃ¤stra GÃ¶talands','Q'),(3403,752,NULL,'Ã–rebro','T'),(3404,752,NULL,'Ã–stergÃ¶tlands','E'),(3405,702,NULL,'Central Singapore','001'),(3406,702,NULL,'North East','002'),(3407,702,NULL,'North West','003'),(3408,702,NULL,'South East','004'),(3409,702,NULL,'South West','005'),(3410,654,NULL,'Saint Helena','SH'),(3411,654,NULL,'Tristan da Cunha','TA'),(3412,654,NULL,'Ascension','AC'),(3413,705,NULL,'AjdovÅ¡Äina','001'),(3414,705,NULL,'Beltinci','002'),(3415,705,NULL,'Bled','003'),(3416,705,NULL,'Bohinj','004'),(3417,705,NULL,'Borovnica','005'),(3418,705,NULL,'Bovec','006'),(3419,705,NULL,'Brda','007'),(3420,705,NULL,'Brezovica','008'),(3421,705,NULL,'BreÅ¾ice','009'),(3422,705,NULL,'TiÅ¡ina','010'),(3423,705,NULL,'Celje','011'),(3424,705,NULL,'Cerklje na Gorenjskem','012'),(3425,705,NULL,'Cerknica','013'),(3426,705,NULL,'Cerkno','014'),(3427,705,NULL,'ÄŒrenÅ¡ovci','015'),(3428,705,NULL,'ÄŒrna na KoroÅ¡kem','016'),(3429,705,NULL,'ÄŒrnomelj','017'),(3430,705,NULL,'Destrnik','018'),(3431,705,NULL,'DivaÄa','019'),(3432,705,NULL,'Dobrepolje','020'),(3433,705,NULL,'Dobrova-Polhov Gradec','021'),(3434,705,NULL,'Dol pri Ljubljani','022'),(3435,705,NULL,'DomÅ¾ale','023'),(3436,705,NULL,'Dornava','024'),(3437,705,NULL,'Dravograd','025'),(3438,705,NULL,'Duplek','026'),(3439,705,NULL,'Gorenja vas-Poljane','027'),(3440,705,NULL,'GoriÅ¡nica','028'),(3441,705,NULL,'Gornja Radgona','029'),(3442,705,NULL,'Gornji Grad','030'),(3443,705,NULL,'Gornji Petrovci','031'),(3444,705,NULL,'Grosuplje','032'),(3445,705,NULL,'Å alovci','033'),(3446,705,NULL,'Hrastnik','034'),(3447,705,NULL,'Hrpelje-Kozina','035'),(3448,705,NULL,'Idrija','036'),(3449,705,NULL,'Ig','037'),(3450,705,NULL,'Ilirska Bistrica','038'),(3451,705,NULL,'IvanÄna Gorica','039'),(3452,705,NULL,'Izola/Isola','040'),(3453,705,NULL,'Jesenice','041'),(3454,705,NULL,'JurÅ¡inci','042'),(3455,705,NULL,'Kamnik','043'),(3456,705,NULL,'Kanal','044'),(3457,705,NULL,'KidriÄevo','045'),(3458,705,NULL,'Kobarid','046'),(3459,705,NULL,'Kobilje','047'),(3460,705,NULL,'KoÄevje','048'),(3461,705,NULL,'Komen','049'),(3462,705,NULL,'Koper/Capodistria','050'),(3463,705,NULL,'Kozje','051'),(3464,705,NULL,'Kranj','052'),(3465,705,NULL,'Kranjska Gora','053'),(3466,705,NULL,'KrÅ¡ko','054'),(3467,705,NULL,'Kungota','055'),(3468,705,NULL,'Kuzma','056'),(3469,705,NULL,'LaÅ¡ko','057'),(3470,705,NULL,'Lenart','058'),(3471,705,NULL,'Lendava/Lendva','059'),(3472,705,NULL,'Litija','060'),(3473,705,NULL,'Ljubljana','061'),(3474,705,NULL,'Ljubno','062'),(3475,705,NULL,'Ljutomer','063'),(3476,705,NULL,'Logatec','064'),(3477,705,NULL,'LoÅ¡ka dolina','065'),(3478,705,NULL,'LoÅ¡ki Potok','066'),(3479,705,NULL,'LuÄe','067'),(3480,705,NULL,'Lukovica','068'),(3481,705,NULL,'MajÅ¡perk','069'),(3482,705,NULL,'Maribor','070'),(3483,705,NULL,'Medvode','071'),(3484,705,NULL,'MengeÅ¡','072'),(3485,705,NULL,'Metlika','073'),(3486,705,NULL,'MeÅ¾ica','074'),(3487,705,NULL,'Miren-Kostanjevica','075'),(3488,705,NULL,'Mislinja','076'),(3489,705,NULL,'MoravÄe','077'),(3490,705,NULL,'Moravske Toplice','078'),(3491,705,NULL,'Mozirje','079'),(3492,705,NULL,'Murska Sobota','080'),(3493,705,NULL,'Muta','081'),(3494,705,NULL,'Naklo','082'),(3495,705,NULL,'Nazarje','083'),(3496,705,NULL,'Nova Gorica','084'),(3497,705,NULL,'Novo mesto','085'),(3498,705,NULL,'Odranci','086'),(3499,705,NULL,'OrmoÅ¾','087'),(3500,705,NULL,'Osilnica','088'),(3501,705,NULL,'Pesnica','089'),(3502,705,NULL,'Piran/Pirano','090'),(3503,705,NULL,'Pivka','091'),(3504,705,NULL,'PodÄetrtek','092'),(3505,705,NULL,'Podvelka','093'),(3506,705,NULL,'Postojna','094'),(3507,705,NULL,'Preddvor','095'),(3508,705,NULL,'Ptuj','096'),(3509,705,NULL,'Puconci','097'),(3510,705,NULL,'RaÄe-Fram','098'),(3511,705,NULL,'RadeÄe','099'),(3512,705,NULL,'Radenci','100'),(3513,705,NULL,'Radlje ob Dravi','101'),(3514,705,NULL,'Radovljica','102'),(3515,705,NULL,'Ravne na KoroÅ¡kem','103'),(3516,705,NULL,'Ribnica','104'),(3517,705,NULL,'RogaÅ¡ovci','105'),(3518,705,NULL,'RogaÅ¡ka Slatina','106'),(3519,705,NULL,'Rogatec','107'),(3520,705,NULL,'RuÅ¡e','108'),(3521,705,NULL,'SemiÄ','109'),(3522,705,NULL,'Sevnica','110'),(3523,705,NULL,'SeÅ¾ana','111'),(3524,705,NULL,'Slovenj Gradec','112'),(3525,705,NULL,'Slovenska Bistrica','113'),(3526,705,NULL,'Slovenske Konjice','114'),(3527,705,NULL,'StarÅ¡e','115'),(3528,705,NULL,'Sveti Jurij','116'),(3529,705,NULL,'Å enÄur','117'),(3530,705,NULL,'Å entilj','118'),(3531,705,NULL,'Å entjernej','119'),(3532,705,NULL,'Å entjur pri Celju','120'),(3533,705,NULL,'Å kocjan','121'),(3534,705,NULL,'Å kofja Loka','122'),(3535,705,NULL,'Å kofljica','123'),(3536,705,NULL,'Å marje pri JelÅ¡ah','124'),(3537,705,NULL,'Å martno ob Paki','125'),(3538,705,NULL,'Å oÅ¡tanj','126'),(3539,705,NULL,'Å tore','127'),(3540,705,NULL,'Tolmin','128'),(3541,705,NULL,'Trbovlje','129'),(3542,705,NULL,'Trebnje','130'),(3543,705,NULL,'TrÅ¾iÄ','131'),(3544,705,NULL,'TurniÅ¡Äe','132'),(3545,705,NULL,'Velenje','133'),(3546,705,NULL,'Velike LaÅ¡Äe','134'),(3547,705,NULL,'Videm','135'),(3548,705,NULL,'Vipava','136'),(3549,705,NULL,'Vitanje','137'),(3550,705,NULL,'Vodice','138'),(3551,705,NULL,'Vojnik','139'),(3552,705,NULL,'Vrhnika','140'),(3553,705,NULL,'Vuzenica','141'),(3554,705,NULL,'Zagorje ob Savi','142'),(3555,705,NULL,'ZavrÄ','143'),(3556,705,NULL,'ZreÄe','144'),(3557,705,NULL,'Å½elezniki','146'),(3558,705,NULL,'Å½iri','147'),(3559,705,NULL,'Benedikt','148'),(3560,705,NULL,'Bistrica ob Sotli','149'),(3561,705,NULL,'Bloke','150'),(3562,705,NULL,'BraslovÄe','151'),(3563,705,NULL,'Cankova','152'),(3564,705,NULL,'Cerkvenjak','153'),(3565,705,NULL,'Dobje','154'),(3566,705,NULL,'Dobrna','155'),(3567,705,NULL,'Dobrovnik/Dobronak','156'),(3568,705,NULL,'Dolenjske Toplice','157'),(3569,705,NULL,'Grad','158'),(3570,705,NULL,'Hajdina','159'),(3571,705,NULL,'HoÄe-Slivnica','160'),(3572,705,NULL,'HodoÅ¡/Hodos','161'),(3573,705,NULL,'Horjul','162'),(3574,705,NULL,'Jezersko','163'),(3575,705,NULL,'Komenda','164'),(3576,705,NULL,'Kostel','165'),(3577,705,NULL,'KriÅ¾evci','166'),(3578,705,NULL,'Lovrenc na Pohorju','167'),(3579,705,NULL,'Markovci','168'),(3580,705,NULL,'MiklavÅ¾ na Dravskem polju','169'),(3581,705,NULL,'Mirna PeÄ','170'),(3582,705,NULL,'Oplotnica','171'),(3583,705,NULL,'Podlehnik','172'),(3584,705,NULL,'Polzela','173'),(3585,705,NULL,'Prebold','174'),(3586,705,NULL,'Prevalje','175'),(3587,705,NULL,'RazkriÅ¾je','176'),(3588,705,NULL,'Ribnica na Pohorju','177'),(3589,705,NULL,'Selnica ob Dravi','178'),(3590,705,NULL,'SodraÅ¾ica','179'),(3591,705,NULL,'SolÄava','180'),(3592,705,NULL,'Sveta Ana','181'),(3593,705,NULL,'Sveti AndraÅ¾ v Slovenskih goricah','182'),(3594,705,NULL,'Å empeter-Vrtojba','183'),(3595,705,NULL,'Tabor','184'),(3596,705,NULL,'Trnovska vas','185'),(3597,705,NULL,'Trzin','186'),(3598,705,NULL,'Velika Polana','187'),(3599,705,NULL,'VerÅ¾ej','188'),(3600,705,NULL,'Vransko','189'),(3601,705,NULL,'Å½alec','190'),(3602,705,NULL,'Å½etale','191'),(3603,705,NULL,'Å½irovnica','192'),(3604,705,NULL,'Å½uÅ¾emberk','193'),(3605,705,NULL,'Å martno pri Litiji','194'),(3606,703,NULL,'BanskobystrickÃ½','BC'),(3607,703,NULL,'BratislavskÃ½','BL'),(3608,703,NULL,'KoÅ¡ickÃ½','KI'),(3609,703,NULL,'Nitriansky','NJ'),(3610,703,NULL,'PreÅ¡ovskÃ½','PV'),(3611,703,NULL,'TrenÄiansky','TC'),(3612,703,NULL,'TrnavskÃ½','TA'),(3613,703,NULL,'Å½ilinskÃ½','ZI'),(3614,694,NULL,'Western Area (Freetown)','W'),(3615,694,NULL,'Eastern','E'),(3616,694,NULL,'Northern','N'),(3617,694,NULL,'Southern (Sierra Leone)','S'),(3618,674,NULL,'Acquaviva','001'),(3619,674,NULL,'Chiesanuova','002'),(3620,674,NULL,'Domagnano','003'),(3621,674,NULL,'Faetano','004'),(3622,674,NULL,'Fiorentino','005'),(3623,674,NULL,'Borgo Maggiore','006'),(3624,674,NULL,'San Marino','007'),(3625,674,NULL,'Montegiardino','008'),(3626,674,NULL,'Serravalle','009'),(3627,686,NULL,'Dakar','DK'),(3628,686,NULL,'Diourbel','DB'),(3629,686,NULL,'Fatick','FK'),(3630,686,NULL,'Kaolack','KL'),(3631,686,NULL,'Kolda','KD'),(3632,686,NULL,'Louga','LG'),(3633,686,NULL,'Matam','MT'),(3634,686,NULL,'Saint-Louis','SL'),(3635,686,NULL,'Tambacounda','TC'),(3636,686,NULL,'ThiÃ¨s','TH'),(3637,686,NULL,'Ziguinchor','ZG'),(3638,706,NULL,'Awdal','AW'),(3639,706,NULL,'Bakool','BK'),(3640,706,NULL,'Banaadir','BN'),(3641,706,NULL,'Bari','BR'),(3642,706,NULL,'Bay','BY'),(3643,706,NULL,'Galguduud','GA'),(3644,706,NULL,'Gedo','GE'),(3645,706,NULL,'Hiirsan','HI'),(3646,706,NULL,'Jubbada Dhexe','JD'),(3647,706,NULL,'Jubbada Hoose','JH'),(3648,706,NULL,'Mudug','MU'),(3649,706,NULL,'Nugaal','NU'),(3650,706,NULL,'Saneag','SA'),(3651,706,NULL,'Shabeellaha Dhexe','SD'),(3652,706,NULL,'Shabeellaha Hoose','SH'),(3653,706,NULL,'Sool','SO'),(3654,706,NULL,'Togdheer','TO'),(3655,706,NULL,'Woqooyi Galbeed','WO'),(3656,740,NULL,'Brokopondo','BR'),(3657,740,NULL,'Commewijne','CM'),(3658,740,NULL,'Coronie','CR'),(3659,740,NULL,'Marowijne','MA'),(3660,740,NULL,'Nickerie','NI'),(3661,740,NULL,'Para','PR'),(3662,740,NULL,'Paramaribo','PM'),(3663,740,NULL,'Saramacca','SA'),(3664,740,NULL,'Sipaliwini','SI'),(3665,740,NULL,'Wanica','WA'),(3666,678,NULL,'PrÃ­ncipe','P'),(3667,678,NULL,'SÃ£o TomÃ©','S'),(3668,222,NULL,'AhuachapÃ¡n','AH'),(3669,222,NULL,'CabaÃ±as','CA'),(3670,222,NULL,'CuscatlÃ¡n','CU'),(3671,222,NULL,'Chalatenango','CH'),(3672,222,NULL,'La Libertad','LI'),(3673,222,NULL,'La Paz','PA'),(3674,222,NULL,'La UniÃ³n','UN'),(3675,222,NULL,'MorazÃ¡n','MO'),(3676,222,NULL,'San Miguel','SM'),(3677,222,NULL,'San Salvador','SS'),(3678,222,NULL,'Santa Ana','SA'),(3679,222,NULL,'San Vicente','SV'),(3680,222,NULL,'Sonsonate','SO'),(3681,222,NULL,'UsulutÃ¡n','US'),(3682,760,NULL,'Al Hasakah','HA'),(3683,760,NULL,'Al Ladhiqiyah','LA'),(3684,760,NULL,'Al Qunaytirah','QU'),(3685,760,NULL,'Ar Raqqah','RA'),(3686,760,NULL,'As Suwayda\'','SU'),(3687,760,NULL,'Dar\'a','DR'),(3688,760,NULL,'Dayr az Zawr','DY'),(3689,760,NULL,'Dimashq','DI'),(3690,760,NULL,'Halab','HL'),(3691,760,NULL,'Hamah','HM'),(3692,760,NULL,'Homs','HI'),(3693,760,NULL,'Idlib','ID'),(3694,760,NULL,'Rif Dimashq','RD'),(3695,760,NULL,'Tartus','TA'),(3696,748,NULL,'Hhohho','HH'),(3697,748,NULL,'Lubombo','LU'),(3698,748,NULL,'Manzini','MA'),(3699,748,NULL,'Shiselweni','SH'),(3700,148,NULL,'Batha','BA'),(3701,148,NULL,'Borkou-Ennedi-Tibesti','BET'),(3702,148,NULL,'Chari-Baguirmi','CB'),(3703,148,NULL,'GuÃ©ra','GR'),(3704,148,NULL,'Hadjer Lamis','HL'),(3705,148,NULL,'Kanem','KA'),(3706,148,NULL,'Lac','LC'),(3707,148,NULL,'Logone-Occidental','LO'),(3708,148,NULL,'Logone-Oriental','LR'),(3709,148,NULL,'Mandoul','MA'),(3710,148,NULL,'Mayo-KÃ©bbi-Est','ME'),(3711,148,NULL,'Mayo-KÃ©bbi-Ouest','MO'),(3712,148,NULL,'Moyen-Chari','MC'),(3713,148,NULL,'Ndjamena','ND'),(3714,148,NULL,'OuaddaÃ¯','OD'),(3715,148,NULL,'Salamat','SA'),(3716,148,NULL,'TandjilÃ©','TA'),(3717,148,NULL,'Wadi Fira','WF'),(3718,768,NULL,'Centre','C'),(3719,768,NULL,'Kara','K'),(3720,768,NULL,'Maritime','M'),(3721,768,NULL,'Plateaux','P'),(3722,768,NULL,'Savannes','S'),(3723,764,NULL,'Krung Thep Maha Nakhon Bangkok','010'),(3724,764,NULL,'Samut Prakan','011'),(3725,764,NULL,'Nonthaburi','012'),(3726,764,NULL,'Pathum Thani','013'),(3727,764,NULL,'Phra Nakhon Si Ayutthaya','014'),(3728,764,NULL,'Ang Thong','015'),(3729,764,NULL,'Lop Buri','016'),(3730,764,NULL,'Sing Buri','017'),(3731,764,NULL,'Chai Nat','018'),(3732,764,NULL,'Saraburi','019'),(3733,764,NULL,'Chon Buri','020'),(3734,764,NULL,'Rayong','021'),(3735,764,NULL,'Chanthaburi','022'),(3736,764,NULL,'Trat','023'),(3737,764,NULL,'Chachoengsao','024'),(3738,764,NULL,'Prachin Buri','025'),(3739,764,NULL,'Nakhon Nayok','026'),(3740,764,NULL,'Sa Kaeo','027'),(3741,764,NULL,'Nakhon Ratchasima','030'),(3742,764,NULL,'Buri Ram','031'),(3743,764,NULL,'Surin','032'),(3744,764,NULL,'Si Sa Ket','033'),(3745,764,NULL,'Ubon Ratchathani','034'),(3746,764,NULL,'Yasothon','035'),(3747,764,NULL,'Chaiyaphum','036'),(3748,764,NULL,'Amnat Charoen','037'),(3749,764,NULL,'Nong Bua Lam Phu','039'),(3750,764,NULL,'Khon Kaen','040'),(3751,764,NULL,'Udon Thani','041'),(3752,764,NULL,'Loei','042'),(3753,764,NULL,'Nong Khai','043'),(3754,764,NULL,'Maha Sarakham','044'),(3755,764,NULL,'Roi Et','045'),(3756,764,NULL,'Kalasin','046'),(3757,764,NULL,'Sakon Nakhon','047'),(3758,764,NULL,'Nakhon Phanom','048'),(3759,764,NULL,'Mukdahan','049'),(3760,764,NULL,'Chiang Mai','050'),(3761,764,NULL,'Lamphun','051'),(3762,764,NULL,'Lampang','052'),(3763,764,NULL,'Uttaradit','053'),(3764,764,NULL,'Phrae','054'),(3765,764,NULL,'Nan','055'),(3766,764,NULL,'Phayao','056'),(3767,764,NULL,'Chiang Rai','057'),(3768,764,NULL,'Mae Hong Son','058'),(3769,764,NULL,'Nakhon Sawan','060'),(3770,764,NULL,'Uthai Thani','061'),(3771,764,NULL,'Kamphaeng Phet','062'),(3772,764,NULL,'Tak','063'),(3773,764,NULL,'Sukhothai','064'),(3774,764,NULL,'Phitsanulok','065'),(3775,764,NULL,'Phichit','066'),(3776,764,NULL,'Phetchabun','067'),(3777,764,NULL,'Ratchaburi','070'),(3778,764,NULL,'Kanchanaburi','071'),(3779,764,NULL,'Suphan Buri','072'),(3780,764,NULL,'Nakhon Pathom','073'),(3781,764,NULL,'Samut Sakhon','074'),(3782,764,NULL,'Samut Songkhram','075'),(3783,764,NULL,'Phetchaburi','076'),(3784,764,NULL,'Prachuap Khiri Khan','077'),(3785,764,NULL,'Nakhon Si Thammarat','080'),(3786,764,NULL,'Krabi','081'),(3787,764,NULL,'Phangnga','082'),(3788,764,NULL,'Phuket','083'),(3789,764,NULL,'Surat Thani','084'),(3790,764,NULL,'Ranong','085'),(3791,764,NULL,'Chumphon','086'),(3792,764,NULL,'Songkhla','090'),(3793,764,NULL,'Satun','091'),(3794,764,NULL,'Trang','092'),(3795,764,NULL,'Phatthalung','093'),(3796,764,NULL,'Pattani','094'),(3797,764,NULL,'Yala','095'),(3798,764,NULL,'Narathiwat','096'),(3799,764,NULL,'Phatthaya','S'),(3800,762,NULL,'Gorno-Badakhshan','GB'),(3801,762,NULL,'Khatlon','KT'),(3802,762,NULL,'Sughd','SU'),(3803,626,NULL,'Aileu','AL'),(3804,626,NULL,'Ainaro','AN'),(3805,626,NULL,'Baucau','BA'),(3806,626,NULL,'Bobonaro','BO'),(3807,626,NULL,'Cova Lima','CO'),(3808,626,NULL,'Dili','DI'),(3809,626,NULL,'Ermera','ER'),(3810,626,NULL,'Lautem','LA'),(3811,626,NULL,'LiquiÃ§a','LI'),(3812,626,NULL,'Manatuto','MT'),(3813,626,NULL,'Manufahi','MF'),(3814,626,NULL,'Oecussi','OE'),(3815,626,NULL,'Viqueque','VI'),(3816,795,NULL,'Ahal','A'),(3817,795,NULL,'Balkan','B'),(3818,795,NULL,'DaÅŸoguz','D'),(3819,795,NULL,'Lebap','L'),(3820,795,NULL,'Mary','M'),(3821,788,NULL,'Tunis','011'),(3822,788,NULL,'L\'Ariana','012'),(3823,788,NULL,'Ben Arous','013'),(3824,788,NULL,'La Manouba','014'),(3825,788,NULL,'Nabeul','021'),(3826,788,NULL,'Zaghouan','022'),(3827,788,NULL,'Bizerte','023'),(3828,788,NULL,'BÃ©ja','031'),(3829,788,NULL,'Jendouba','032'),(3830,788,NULL,'Le Kef','033'),(3831,788,NULL,'Siliana','034'),(3832,788,NULL,'Kairouan','041'),(3833,788,NULL,'Kasserine','042'),(3834,788,NULL,'Sidi Bouzid','043'),(3835,788,NULL,'Sousse','051'),(3836,788,NULL,'Monastir','052'),(3837,788,NULL,'Mahdia','053'),(3838,788,NULL,'Sfax','061'),(3839,788,NULL,'Gafsa','071'),(3840,788,NULL,'Tozeur','072'),(3841,788,NULL,'Kebili','073'),(3842,788,NULL,'GabÃ¨s','081'),(3843,788,NULL,'Medenine','082'),(3844,788,NULL,'Tataouine','083'),(3845,776,NULL,'\'Eua','001'),(3846,776,NULL,'Ha\'apai','002'),(3847,776,NULL,'Niuas','003'),(3848,776,NULL,'Tongatapu','004'),(3849,776,NULL,'Vava\'u','005'),(3850,792,NULL,'Adana','001'),(3851,792,NULL,'AdÄ±yaman','002'),(3852,792,NULL,'Afyon','003'),(3853,792,NULL,'AÄŸrÄ±','004'),(3854,792,NULL,'Amasya','005'),(3855,792,NULL,'Ankara','006'),(3856,792,NULL,'Antalya','007'),(3857,792,NULL,'Artvin','008'),(3858,792,NULL,'AydÄ±n','009'),(3859,792,NULL,'BalÄ±kesir','010'),(3860,792,NULL,'Bilecik','011'),(3861,792,NULL,'BingÃ¶l','012'),(3862,792,NULL,'Bitlis','013'),(3863,792,NULL,'Bolu','014'),(3864,792,NULL,'Burdur','015'),(3865,792,NULL,'Bursa','016'),(3866,792,NULL,'Ã‡anakkale','017'),(3867,792,NULL,'Ã‡ankÄ±rÄ±','018'),(3868,792,NULL,'Ã‡orum','019'),(3869,792,NULL,'Denizli','020'),(3870,792,NULL,'DiyarbakÄ±r','021'),(3871,792,NULL,'Edirne','022'),(3872,792,NULL,'ElazÄ±ÄŸ','023'),(3873,792,NULL,'Erzincan','024'),(3874,792,NULL,'Erzurum','025'),(3875,792,NULL,'EskiÅŸehir','026'),(3876,792,NULL,'Gaziantep','027'),(3877,792,NULL,'Giresun','028'),(3878,792,NULL,'GÃ¼mÃ¼ÅŸhane','029'),(3879,792,NULL,'HakkÃ¢ri','030'),(3880,792,NULL,'Hatay','031'),(3881,792,NULL,'Isparta','032'),(3882,792,NULL,'Ä°Ã§el','033'),(3883,792,NULL,'Ä°stanbul','034'),(3884,792,NULL,'Ä°zmir','035'),(3885,792,NULL,'Kars','036'),(3886,792,NULL,'Kastamonu','037'),(3887,792,NULL,'Kayseri','038'),(3888,792,NULL,'KÄ±rklareli','039'),(3889,792,NULL,'KÄ±rÅŸehir','040'),(3890,792,NULL,'Kocaeli','041'),(3891,792,NULL,'Konya','042'),(3892,792,NULL,'KÃ¼tahya','043'),(3893,792,NULL,'Malatya','044'),(3894,792,NULL,'Manisa','045'),(3895,792,NULL,'KahramanmaraÅŸ','046'),(3896,792,NULL,'Mardin','047'),(3897,792,NULL,'MuÄŸla','048'),(3898,792,NULL,'MuÅŸ','049'),(3899,792,NULL,'NevÅŸehir','050'),(3900,792,NULL,'NiÄŸde','051'),(3901,792,NULL,'Ordu','052'),(3902,792,NULL,'Rize','053'),(3903,792,NULL,'Sakarya','054'),(3904,792,NULL,'Samsun','055'),(3905,792,NULL,'Siirt','056'),(3906,792,NULL,'Sinop','057'),(3907,792,NULL,'Sivas','058'),(3908,792,NULL,'TekirdaÄŸ','059'),(3909,792,NULL,'Tokat','060'),(3910,792,NULL,'Trabzon','061'),(3911,792,NULL,'Tunceli','062'),(3912,792,NULL,'ÅžanlÄ±urfa','063'),(3913,792,NULL,'UÅŸak','064'),(3914,792,NULL,'Van','065'),(3915,792,NULL,'Yozgat','066'),(3916,792,NULL,'Zonguldak','067'),(3917,792,NULL,'Aksaray','068'),(3918,792,NULL,'Bayburt','069'),(3919,792,NULL,'Karaman','070'),(3920,792,NULL,'KÄ±rÄ±kkale','071'),(3921,792,NULL,'Batman','072'),(3922,792,NULL,'ÅžÄ±rnak','073'),(3923,792,NULL,'BartÄ±n','074'),(3924,792,NULL,'Ardahan','075'),(3925,792,NULL,'IÄŸdÄ±r','076'),(3926,792,NULL,'Yalova','077'),(3927,792,NULL,'KarabÃ¼k','078'),(3928,792,NULL,'Kilis','079'),(3929,792,NULL,'Osmaniye','080'),(3930,792,NULL,'DÃ¼zce','081'),(3931,780,NULL,'Couva-Tabaquite-Talparo','CTT'),(3932,780,NULL,'Diego Martin','DMN'),(3933,780,NULL,'Eastern Tobago','ETO'),(3934,780,NULL,'Penal-Debe','PED'),(3935,780,NULL,'Princes Town','PRT'),(3936,780,NULL,'Rio Claro-Mayaro','RCM'),(3937,780,NULL,'Sangre Grande','SGE'),(3938,780,NULL,'San Juan-Laventille','SJL'),(3939,780,NULL,'Siparia','SIP'),(3940,780,NULL,'Tunapuna-Piarco','TUP'),(3941,780,NULL,'Western Tobago','WTO'),(3942,780,NULL,'Arima','ARI'),(3943,780,NULL,'Chaguanas','CHA'),(3944,780,NULL,'Point Fortin','PTF'),(3945,780,NULL,'Port of Spain','POS'),(3946,780,NULL,'San Fernando','SFO'),(3947,798,NULL,'Funafuti','FUN'),(3948,798,NULL,'Nanumanga','NMG'),(3949,798,NULL,'Nanumea','NMA'),(3950,798,NULL,'Niutao','NIT'),(3951,798,NULL,'Nui','NIU'),(3952,798,NULL,'Nukufetau','NKF'),(3953,798,NULL,'Nukulaelae','NKL'),(3954,798,NULL,'Vaitupu','VAI'),(3955,158,NULL,'Changhua','CHA'),(3956,158,NULL,'Chiayi','CYQ'),(3957,158,NULL,'Hsinchu','HSQ'),(3958,158,NULL,'Hualien','HUA'),(3959,158,NULL,'Ilan','ILA'),(3960,158,NULL,'Kaohsiung','KHQ'),(3961,158,NULL,'Miaoli','MIA'),(3962,158,NULL,'Nantou','NAN'),(3963,158,NULL,'Penghu','PEN'),(3964,158,NULL,'Pingtung','PIF'),(3965,158,NULL,'Taichung','TXQ'),(3966,158,NULL,'Tainan','TNQ'),(3967,158,NULL,'Taipei','TPQ'),(3968,158,NULL,'Taitung','TTT'),(3969,158,NULL,'Taoyuan','TAO'),(3970,158,NULL,'Yunlin','YUN'),(3971,158,NULL,'Chiay City','CYI'),(3972,158,NULL,'Hsinchui City','HSZ'),(3973,158,NULL,'Keelung City','KEE'),(3974,158,NULL,'Taichung City','TXG'),(3975,158,NULL,'Tainan City','TNN'),(3976,158,NULL,'Kaohsiung City','KHH'),(3977,158,NULL,'Taipei City','TPE'),(3978,834,NULL,'Arusha','001'),(3979,834,NULL,'Dar-es-Salaam','002'),(3980,834,NULL,'Dodoma','003'),(3981,834,NULL,'Iringa','004'),(3982,834,NULL,'Kagera','005'),(3983,834,NULL,'Kaskazini Pemba','006'),(3984,834,NULL,'Kaskazini Unguja','007'),(3985,834,NULL,'Kigoma','008'),(3986,834,NULL,'Kilimanjaro','009'),(3987,834,NULL,'Kusini Pemba','010'),(3988,834,NULL,'Kusini Unguja','011'),(3989,834,NULL,'Lindi','012'),(3990,834,NULL,'Mara','013'),(3991,834,NULL,'Mbeya','014'),(3992,834,NULL,'Mjini Magharibi','015'),(3993,834,NULL,'Morogoro','016'),(3994,834,NULL,'Mtwara','017'),(3995,834,NULL,'Mwanza','018'),(3996,834,NULL,'Pwani','019'),(3997,834,NULL,'Rukwa','020'),(3998,834,NULL,'Ruvuma','021'),(3999,834,NULL,'Shinyanga','022'),(4000,834,NULL,'Singida','023'),(4001,834,NULL,'Tabora','024'),(4002,834,NULL,'Tanga','025'),(4003,834,NULL,'Manyara','026'),(4004,804,NULL,'Vinnytska oblast','005'),(4005,804,NULL,'Volynska oblast','007'),(4006,804,NULL,'Luhanska oblast','009'),(4007,804,NULL,'Dnipropetrovska oblast','012'),(4008,804,NULL,'Donetska oblast','014'),(4009,804,NULL,'Zhytomyrska oblast','018'),(4010,804,NULL,'Zakarpatska oblast','021'),(4011,804,NULL,'Zaporizka oblast','023'),(4012,804,NULL,'Ivano-Frankivska oblast','026'),(4013,804,NULL,'KyÃ¯vska miska rada','030'),(4014,804,NULL,'KyÃ¯vska oblast','032'),(4015,804,NULL,'Kirovohradska oblast','035'),(4016,804,NULL,'Sevastopol','040'),(4017,804,NULL,'Respublika Krym','043'),(4018,804,NULL,'L\'vivska oblast','046'),(4019,804,NULL,'MykolaÃ¯vska oblast','048'),(4020,804,NULL,'Odeska oblast','051'),(4021,804,NULL,'Poltavska oblast','053'),(4022,804,NULL,'Rivnenska oblast','056'),(4023,804,NULL,'Sumska oblast','059'),(4024,804,NULL,'Ternopilska oblast','061'),(4025,804,NULL,'Kharkivska oblast','063'),(4026,804,NULL,'Khersonska oblast','065'),(4027,804,NULL,'Khmelnytska oblast','068'),(4028,804,NULL,'Cherkaska oblast','071'),(4029,804,NULL,'Chernihivska oblast','074'),(4030,804,NULL,'Chernivetska oblast','077'),(4031,800,NULL,'Kalangala','101'),(4032,800,NULL,'Kampala','102'),(4033,800,NULL,'Kiboga','103'),(4034,800,NULL,'Luwero','104'),(4035,800,NULL,'Masaka','105'),(4036,800,NULL,'Mpigi','106'),(4037,800,NULL,'Mubende','107'),(4038,800,NULL,'Mukono','108'),(4039,800,NULL,'Nakasongola','109'),(4040,800,NULL,'Rakai','110'),(4041,800,NULL,'Sembabule','111'),(4042,800,NULL,'Kayunga','112'),(4043,800,NULL,'Wakiso','113'),(4044,800,NULL,'Mityana','114'),(4045,800,NULL,'Nakaseke','115'),(4046,800,NULL,'Bugiri','201'),(4047,800,NULL,'Busia','202'),(4048,800,NULL,'Iganga','203'),(4049,800,NULL,'Jinja','204'),(4050,800,NULL,'Kamuli','205'),(4051,800,NULL,'Kapchorwa','206'),(4052,800,NULL,'Katakwi','207'),(4053,800,NULL,'Kumi','208'),(4054,800,NULL,'Mbale','209'),(4055,800,NULL,'Pallisa','210'),(4056,800,NULL,'Soroti','211'),(4057,800,NULL,'Tororo','212'),(4058,800,NULL,'Kaberamaido','213'),(4059,800,NULL,'Mayuge','214'),(4060,800,NULL,'Sironko','215'),(4061,800,NULL,'Amuria','216'),(4062,800,NULL,'Budaka','217'),(4063,800,NULL,'Bukwa','218'),(4064,800,NULL,'Butaleja','219'),(4065,800,NULL,'Kaliro','220'),(4066,800,NULL,'Manafwa','221'),(4067,800,NULL,'Namutumba','222'),(4068,800,NULL,'Adjumani','301'),(4069,800,NULL,'Apac','302'),(4070,800,NULL,'Arua','303'),(4071,800,NULL,'Gulu','304'),(4072,800,NULL,'Kitgum','305'),(4073,800,NULL,'Kotido','306'),(4074,800,NULL,'Lira','307'),(4075,800,NULL,'Moroto','308'),(4076,800,NULL,'Moyo','309'),(4077,800,NULL,'Nebbi','310'),(4078,800,NULL,'Nakapiripirit','311'),(4079,800,NULL,'Pader','312'),(4080,800,NULL,'Yumbe','313'),(4081,800,NULL,'Amolatar','314'),(4082,800,NULL,'Kaabong','315'),(4083,800,NULL,'Koboko','316'),(4084,800,NULL,'Abim','317'),(4085,800,NULL,'Dokolo','318'),(4086,800,NULL,'Amuru','319'),(4087,800,NULL,'Maracha','320'),(4088,800,NULL,'Oyam','321'),(4089,800,NULL,'Bundibugyo','401'),(4090,800,NULL,'Bushenyi','402'),(4091,800,NULL,'Hoima','403'),(4092,800,NULL,'Kabale','404'),(4093,800,NULL,'Kabarole','405'),(4094,800,NULL,'Kasese','406'),(4095,800,NULL,'Kibaale','407'),(4096,800,NULL,'Kisoro','408'),(4097,800,NULL,'Masindi','409'),(4098,800,NULL,'Mbarara','410'),(4099,800,NULL,'Ntungamo','411'),(4100,800,NULL,'Rukungiri','412'),(4101,800,NULL,'Kamwenge','413'),(4102,800,NULL,'Kanungu','414'),(4103,800,NULL,'Kyenjojo','415'),(4104,800,NULL,'Ibanda','416'),(4105,800,NULL,'Isingiro','417'),(4106,800,NULL,'Kiruhura','418'),(4107,800,NULL,'Bulisa','419'),(4108,581,NULL,'Johnston Atoll','067'),(4109,581,NULL,'Midway Islands','071'),(4110,581,NULL,'Navassa Island','076'),(4111,581,NULL,'Wake Island','079'),(4112,581,NULL,'Baker Island','081'),(4113,581,NULL,'Howland Island','084'),(4114,581,NULL,'Jarvis Island','086'),(4115,581,NULL,'Kingman Reef','089'),(4116,581,NULL,'Palmyra Atoll','095'),(4117,840,NULL,'Alabama','AL'),(4118,840,NULL,'Alaska','AK'),(4119,840,NULL,'Arizona','AZ'),(4120,840,NULL,'Arkansas','AR'),(4121,840,NULL,'California','CA'),(4122,840,NULL,'Colorado','CO'),(4123,840,NULL,'Connecticut','CT'),(4124,840,NULL,'Delaware','DE'),(4125,840,NULL,'Florida','FL'),(4126,840,NULL,'Georgia','GA'),(4127,840,NULL,'Hawaii','HI'),(4128,840,NULL,'Idaho','ID'),(4129,840,NULL,'Illinois','IL'),(4130,840,NULL,'Indiana','IN'),(4131,840,NULL,'Iowa','IA'),(4132,840,NULL,'Kansas','KS'),(4133,840,NULL,'Kentucky','KY'),(4134,840,NULL,'Louisiana','LA'),(4135,840,NULL,'Maine','ME'),(4136,840,NULL,'Maryland','MD'),(4137,840,NULL,'Massachusetts','MA'),(4138,840,NULL,'Michigan','MI'),(4139,840,NULL,'Minnesota','MN'),(4140,840,NULL,'Mississippi','MS'),(4141,840,NULL,'Missouri','MO'),(4142,840,NULL,'Montana','MT'),(4143,840,NULL,'Nebraska','NE'),(4144,840,NULL,'Nevada','NV'),(4145,840,NULL,'New Hampshire','NH'),(4146,840,NULL,'New Jersey','NJ'),(4147,840,NULL,'New Mexico','NM'),(4148,840,NULL,'New York','NY'),(4149,840,NULL,'North Carolina','NC'),(4150,840,NULL,'North Dakota','ND'),(4151,840,NULL,'Ohio','OH'),(4152,840,NULL,'Oklahoma','OK'),(4153,840,NULL,'Oregon','OR'),(4154,840,NULL,'Pennsylvania','PA'),(4155,840,NULL,'Rhode Island','RI'),(4156,840,NULL,'South Carolina','SC'),(4157,840,NULL,'South Dakota','SD'),(4158,840,NULL,'Tennessee','TN'),(4159,840,NULL,'Texas','TX'),(4160,840,NULL,'Utah','UT'),(4161,840,NULL,'Vermont','VT'),(4162,840,NULL,'Virginia','VA'),(4163,840,NULL,'Washington','WA'),(4164,840,NULL,'West Virginia','WV'),(4165,840,NULL,'Wisconsin','WI'),(4166,840,NULL,'Wyoming','WY'),(4167,840,NULL,'District of Columbia','DC'),(4168,840,NULL,'American Samoa','AS'),(4169,840,NULL,'Guam','GU'),(4170,840,NULL,'Northern Mariana Islands','MP'),(4171,840,NULL,'Puerto Rico','PR'),(4172,840,NULL,'United States Minor Outlying Islands','UM'),(4173,840,NULL,'Virgin Islands','VI'),(4174,858,NULL,'Artigas','AR'),(4175,858,NULL,'Canelones','CA'),(4176,858,NULL,'Cerro Largo','CL'),(4177,858,NULL,'Colonia','CO'),(4178,858,NULL,'Durazno','DU'),(4179,858,NULL,'Flores','FS'),(4180,858,NULL,'Florida','FD'),(4181,858,NULL,'Lavalleja','LA'),(4182,858,NULL,'Maldonado','MA'),(4183,858,NULL,'Montevideo','MO'),(4184,858,NULL,'PaysandÃº','PA'),(4185,858,NULL,'RÃ­o Negro','RN'),(4186,858,NULL,'Rivera','RV'),(4187,858,NULL,'Rocha','RO'),(4188,858,NULL,'Salto','SA'),(4189,858,NULL,'San JosÃ©','SJ'),(4190,858,NULL,'Soriano','SO'),(4191,858,NULL,'TacuarembÃ³','TA'),(4192,858,NULL,'Treinta y Tres','TT'),(4193,860,NULL,'Toshkent','TK'),(4194,860,NULL,'Andijon','AN'),(4195,860,NULL,'Buxoro','BU'),(4196,860,NULL,'Farg\'ona','FA'),(4197,860,NULL,'Jizzax','JI'),(4198,860,NULL,'Namangan','NG'),(4199,860,NULL,'Navoiy','NW'),(4200,860,NULL,'Qashqadaryo','QA'),(4201,860,NULL,'Samarqand','SA'),(4202,860,NULL,'Sirdaryo','SI'),(4203,860,NULL,'Surxondaryo','SU'),(4204,860,NULL,'Toshkent','TO'),(4205,860,NULL,'Xorazm','XO'),(4206,860,NULL,'Qoraqalpog\'iston','QR'),(4207,670,NULL,'Charlotte','001'),(4208,670,NULL,'Saint Andrew','002'),(4209,670,NULL,'Saint David','003'),(4210,670,NULL,'Saint George','004'),(4211,670,NULL,'Saint Patrick','005'),(4212,670,NULL,'Grenadines','006'),(4213,862,NULL,'Dependencias Federales','W'),(4214,862,NULL,'Distrito Federal','A'),(4215,862,NULL,'Amazonas','Z'),(4216,862,NULL,'AnzoÃ¡tegui','B'),(4217,862,NULL,'Apure','C'),(4218,862,NULL,'Aragua','D'),(4219,862,NULL,'Barinas','E'),(4220,862,NULL,'BolÃ­var','F'),(4221,862,NULL,'Carabobo','G'),(4222,862,NULL,'Cojedes','H'),(4223,862,NULL,'Delta Amacuro','Y'),(4224,862,NULL,'FalcÃ³n','I'),(4225,862,NULL,'GuÃ¡rico','J'),(4226,862,NULL,'Lara','K'),(4227,862,NULL,'MÃ©rida','L'),(4228,862,NULL,'Miranda','M'),(4229,862,NULL,'Monagas','N'),(4230,862,NULL,'Nueva Esparta','O'),(4231,862,NULL,'Portuguesa','P'),(4232,862,NULL,'Sucre','R'),(4233,862,NULL,'TÃ¡chira','S'),(4234,862,NULL,'Trujillo','T'),(4235,862,NULL,'Vargas','X'),(4236,862,NULL,'Yaracuy','U'),(4237,862,NULL,'Zulia','V'),(4238,704,NULL,'Lai ChÃ¢u','001'),(4239,704,NULL,'LÃ o Cai','002'),(4240,704,NULL,'HÃ  Giang','003'),(4241,704,NULL,'Cao Báº±ng','004'),(4242,704,NULL,'SÆ¡n La','005'),(4243,704,NULL,'YÃªn BÃ¡i','006'),(4244,704,NULL,'TuyÃªn Quang','007'),(4245,704,NULL,'Láº¡ng SÆ¡n','009'),(4246,704,NULL,'Quáº£ng Ninh','013'),(4247,704,NULL,'HoÃ  BÃ¬nh','014'),(4248,704,NULL,'HÃ  TÃ¢y','015'),(4249,704,NULL,'Ninh BÃ¬nh','018'),(4250,704,NULL,'ThÃ¡i BÃ¬nh','020'),(4251,704,NULL,'Thanh HÃ³a','021'),(4252,704,NULL,'Nghá»‡ An','022'),(4253,704,NULL,'HÃ  Tá»‰nh','023'),(4254,704,NULL,'Quáº£ng BÃ¬nh','024'),(4255,704,NULL,'Quáº£ng Trá»‹','025'),(4256,704,NULL,'Thá»«a ThiÃªn-Huáº¿','026'),(4257,704,NULL,'Quáº£ng Nam','027'),(4258,704,NULL,'Kon Tum','028'),(4259,704,NULL,'Quáº£ng NgÃ£i','029'),(4260,704,NULL,'Gia Lai','030'),(4261,704,NULL,'BÃ¬nh Äá»‹nh','031'),(4262,704,NULL,'PhÃº YÃªn','032'),(4263,704,NULL,'Äáº¯c Láº¯k','033'),(4264,704,NULL,'KhÃ¡nh HÃ²a','034'),(4265,704,NULL,'LÃ¢m Äá»“ng','035'),(4266,704,NULL,'Ninh Thuáº­n','036'),(4267,704,NULL,'TÃ¢y Ninh','037'),(4268,704,NULL,'Äá»“ng Nai','039'),(4269,704,NULL,'BÃ¬nh Thuáº­n','040'),(4270,704,NULL,'Long An','041'),(4271,704,NULL,'BÃ  Rá»‹a - VÅ©ng TÃ u','043'),(4272,704,NULL,'An Giang','044'),(4273,704,NULL,'Äá»“ng ThÃ¡p','045'),(4274,704,NULL,'Tiá»n Giang','046'),(4275,704,NULL,'KiÃªn Giang','047'),(4276,704,NULL,'Cáº§n ThÆ¡','048'),(4277,704,NULL,'VÄ©nh Long','049'),(4278,704,NULL,'Báº¿n Tre','050'),(4279,704,NULL,'TrÃ  Vinh','051'),(4280,704,NULL,'SÃ³c TrÄƒng','052'),(4281,704,NULL,'Báº¯c Káº¡n','053'),(4282,704,NULL,'Báº¯c Giang','054'),(4283,704,NULL,'Báº¡c LiÃªu','055'),(4284,704,NULL,'Báº¯c Ninh','056'),(4285,704,NULL,'BÃ¬nh DÆ°Æ¡ng','057'),(4286,704,NULL,'BÃ¬nh PhÆ°á»›c','058'),(4287,704,NULL,'CÃ  Mau','059'),(4288,704,NULL,'ÄÃ  Náºµng, thÃ nh phá»‘','060'),(4289,704,NULL,'Háº£i Duong','061'),(4290,704,NULL,'Háº£i PhÃ²ng, thÃ nh phá»‘','062'),(4291,704,NULL,'HÃ  Nam','063'),(4292,704,NULL,'HÃ  Ná»™i, thá»§ Ä‘Ã´','064'),(4293,704,NULL,'Há»“ ChÃ­ Minh, thÃ nh phá»‘','065'),(4294,704,NULL,'HÆ°ng YÃªn','066'),(4295,704,NULL,'Nam Äá»‹nh','067'),(4296,704,NULL,'PhÃº Thá»','068'),(4297,704,NULL,'ThÃ¡i NguyÃªn','069'),(4298,704,NULL,'VÄ©nh PhÃºc','070'),(4299,704,NULL,'Äiá»‡n BiÃªn','071'),(4300,704,NULL,'Äáº¯k NÃ´ng','072'),(4301,704,NULL,'Háº­u Giang','073'),(4302,548,NULL,'Malampa','MAP'),(4303,548,NULL,'PÃ©nama','PAM'),(4304,548,NULL,'Sanma','SAM'),(4305,548,NULL,'ShÃ©fa','SEE'),(4306,548,NULL,'TafÃ©a','TAE'),(4307,548,NULL,'Torba','TOB'),(4308,882,NULL,'A\'ana','AA'),(4309,882,NULL,'Aiga-i-le-Tai','AL'),(4310,882,NULL,'Atua','AT'),(4311,882,NULL,'Fa\'asaleleaga','FA'),(4312,882,NULL,'Gaga\'emauga','GE'),(4313,882,NULL,'Gagaifomauga','GI'),(4314,882,NULL,'Palauli','PA'),(4315,882,NULL,'Satupa\'itea','SA'),(4316,882,NULL,'Tuamasaga','TU'),(4317,882,NULL,'Va\'a-o-Fonoti','VF'),(4318,882,NULL,'Vaisigano','VS'),(4319,887,NULL,'AbyÄn','AB'),(4320,887,NULL,'\'Adan','AD'),(4321,887,NULL,'Aá¸‘ á¸Äli\'','DA'),(4322,887,NULL,'Al Bayá¸‘Ä\'','BA'),(4323,887,NULL,'Al á¸¨udaydah','MU'),(4324,887,NULL,'Al Jawf','JA'),(4325,887,NULL,'Al Mahrah','MR'),(4326,887,NULL,'Al Maá¸©wÄ«t','MW'),(4327,887,NULL,'\'AmrÄn','AM'),(4328,887,NULL,'DhamÄr','DH'),(4329,887,NULL,'á¸¨aá¸‘ramawt','HD'),(4330,887,NULL,'á¸¨ajjah','HJ'),(4331,887,NULL,'Ibb','IB'),(4332,887,NULL,'Laá¸©ij','LA'),(4333,887,NULL,'Ma\'rib','MA'),(4334,887,NULL,'Åža\'dah','SD'),(4335,887,NULL,'Åžan\'Ä\'','SN'),(4336,887,NULL,'Shabwah','SH'),(4337,887,NULL,'TÄ\'izz','TA'),(4338,710,NULL,'Eastern Cape','EC'),(4339,710,NULL,'Free State','FS'),(4340,710,NULL,'Gauteng','GT'),(4341,710,NULL,'Kwazulu-Natal','NL'),(4342,710,NULL,'Limpopo','LP'),(4343,710,NULL,'Mpumalanga','MP'),(4344,710,NULL,'Northern Cape','NC'),(4345,710,NULL,'North-West','NW'),(4346,710,NULL,'Western Cape','WC'),(4347,894,NULL,'Western','001'),(4348,894,NULL,'Central','002'),(4349,894,NULL,'Eastern','003'),(4350,894,NULL,'Luapula','004'),(4351,894,NULL,'Northern','005'),(4352,894,NULL,'North-Western','006'),(4353,894,NULL,'Southern','007'),(4354,894,NULL,'Copperbelt','008'),(4355,894,NULL,'Lusaka','009'),(4356,716,NULL,'Bulawayo','BU'),(4357,716,NULL,'Harare','HA'),(4358,716,NULL,'Manicaland','MA'),(4359,716,NULL,'Mashonaland Central','MC'),(4360,716,NULL,'Mashonaland East','ME'),(4361,716,NULL,'Mashonaland West','MW'),(4362,716,NULL,'Masvingo','MV'),(4363,716,NULL,'Matabeleland North','MN'),(4364,716,NULL,'Matabeleland South','MS'),(4365,716,NULL,'Midlands','MI');
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relationships`
--

DROP TABLE IF EXISTS `relationships`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `relationships` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `guest_id` int(11) default NULL,
  `circle_id` int(11) default NULL,
  `description` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `relationships`
--

LOCK TABLES `relationships` WRITE;
/*!40000 ALTER TABLE `relationships` DISABLE KEYS */;
INSERT INTO `relationships` VALUES (1,85,86,10,NULL,'2009-02-18 18:30:14','2009-02-18 18:30:14'),(2,85,87,10,NULL,'2009-02-18 18:39:41','2009-02-18 18:39:41'),(3,85,86,12,NULL,'2009-02-24 15:01:44','2009-02-24 15:01:44'),(4,85,89,12,NULL,'2009-03-13 02:04:42','2009-03-13 02:04:42'),(5,85,90,9,NULL,'2009-03-13 02:48:47','2009-03-13 02:48:47'),(6,88,91,15,NULL,'2009-04-08 21:43:27','2009-04-16 20:30:28'),(7,88,92,10,NULL,'2009-04-09 04:38:41','2009-04-10 17:19:22'),(8,88,93,11,NULL,'2009-04-10 00:34:40','2009-04-10 00:35:02'),(9,88,94,16,NULL,'2009-04-10 04:01:12','2009-04-10 05:30:42');
/*!40000 ALTER TABLE `relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(40) default NULL,
  `authorizable_type` varchar(40) default NULL,
  `authorizable_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (97,'guest','User',85,'2009-02-18 18:30:14','2009-02-18 18:30:14'),(98,'admin','Account',90,'2009-03-12 18:38:09','2009-03-12 18:38:09'),(99,'admin','Account',91,'2009-03-12 19:32:17','2009-03-12 19:32:17'),(100,'guest','User',88,'2009-04-08 21:43:26','2009-04-08 21:43:26'),(105,'admin','Account',96,'2009-05-19 14:16:33','2009-05-19 14:16:33'),(106,'admin','Account',97,'2009-05-19 15:05:45','2009-05-19 15:05:45');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles_users` (
  `user_id` int(11) default NULL,
  `role_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES (87,98,'2009-03-12 18:38:09','2009-03-12 18:38:09'),(88,99,'2009-03-12 19:32:17','2009-03-12 19:32:17'),(89,105,'2009-05-19 14:16:33','2009-05-19 14:16:33'),(91,106,'2009-05-19 15:05:45','2009-05-19 15:05:45');
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20090203221302'),('20090203221303'),('20090218061714'),('20090401230612');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schools` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) NOT NULL,
  `country_id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `degree` varchar(255) default NULL,
  `fields` varchar(255) default NULL,
  `start_at` date default NULL,
  `end_at` date default NULL,
  `activities_societies` varchar(255) default NULL,
  `awards` varchar(255) default NULL,
  `recognitions` varchar(255) default NULL,
  `notes` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `profile_id` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES (3,'b125c895cc86114ab8ba8153b08cff68','BAh7BzoOcmV0dXJuX3RvMCIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6\nRmxhc2g6OkZsYXNoSGFzaHsGOgtub3RpY2UiHllvdSBoYXZlIGJlZW4gbG9n\nZ2VkIG91dC4GOgpAdXNlZHsGOwdU\n','2009-04-04 05:28:09','2009-04-04 05:28:12'),(4,'4de15b900ba9469e5ab587b846750bf0','BAh7BzoOcmV0dXJuX3RvMCIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6\nRmxhc2g6OkZsYXNoSGFzaHsGOgtub3RpY2UiHllvdSBoYXZlIGJlZW4gbG9n\nZ2VkIG91dC4GOgpAdXNlZHsGOwdU\n','2009-04-04 23:31:45','2009-04-04 23:31:49'),(6,'00ce4ae23270748c533099942acb4eaa','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 05:53:48','2009-05-15 05:53:48'),(7,'9d508ea3e1154b57ea1ea0984f5dfdd0','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 05:56:15','2009-05-15 05:56:15'),(8,'d5e6d8aa80b539c77ebdb39e95d58cc3','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 05:57:32','2009-05-15 05:57:32'),(9,'8fa4973890f9b9832b04dc95f8a576da','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 06:25:06','2009-05-15 06:25:06'),(10,'f3f1656b6f7ae0be95efa00c3e1a7acc','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 06:26:06','2009-05-15 06:26:06'),(11,'68caabe725307b7188f3ed2d66efb0ea','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 06:52:12','2009-05-15 06:52:12'),(12,'82cc10e44f613f801e91153090f4f91d','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 06:56:31','2009-05-15 06:56:31'),(13,'e4390a1c01c8c6be324092b901fd8aad','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 06:58:55','2009-05-15 06:58:55'),(14,'31825a29d7f49862350255fd96388771','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 07:02:52','2009-05-15 07:02:52'),(15,'60e08ff3a4731ebba817d7410327db65','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 15:08:52','2009-05-15 15:08:52'),(16,'ad63973ca0c914d66b7cf8088835312b','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 15:19:44','2009-05-15 15:19:44'),(17,'411de8e281c9aad02a81db9bd4fc9bb0','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 15:23:17','2009-05-15 15:23:17'),(18,'4cc796a41378f634eee2d50540f3fecd','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-05-15 15:41:22','2009-05-15 15:41:22'),(19,'17ed54abebffd77057854ba4cce7d31a','BAh7CDoMdXNlcl9pZGldOg5yZXR1cm5fdG8iES9tZW1iZXJfaG9tZSIKZmxh\nc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoK\nQHVzZWR7AA==\n','2009-05-15 19:36:34','2009-05-15 20:03:03'),(20,'1ce577f1732bc1d8271b564f47214e94','BAh7CyIVdXNlcl9jcmVkZW50aWFscyIBgDkwY2JjNWEyMThjN2VlODdlZTE1\nY2Q4YWZjNmRmMmU4NzIxM2U4MGIwMDEyZGFkNWZlMjRiZDM1ZTFjYjA0ODE5\nODJjYjNkM2JlYWFjYjgxNDYxYjFlMDMwY2Y5Mzg2ODA3NjY2MTI4YzI0M2Fl\nNmExMjY5ZjNiZTUyNWE4ZWIxOgx1c2VyX2lkMDoOcmV0dXJuX3RvIhEvbWVt\nYmVyX2hvbWU6FWZhY2Vib29rX3Nlc3Npb25VOhhGYWNlYm9va2VyOjpTZXNz\naW9uWwwiOzMudFE0dDlSeWprS2dYZllTMFZTZk1UQV9fLjg2NDAwLjEyNDI4\nNDk2MDAtMTAwNTczNzM3OGkEolXyO2wrB0BhFEoiHWxZWWZabm5QbmVEdUEx\nVjJpZE9BOGdfXzAiJWY5NDcyZDUzMDAxNWMzMTU5ODI4ZjBlZjdjOGI2ZDAz\nIiUzMDRmNDFkMmNiZjRjYzZjMzY2N2JkMTI1ODgwMGVmOSIYdXNlcl9jcmVk\nZW50aWFsc19pZDAiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZsYXNo\nOjpGbGFzaEhhc2h7BjoLbm90aWNlIiJVbmFibGUgdG8gbG9naW4gZnJvbSBG\nYWNlYm9vawY6CkB1c2VkewY7ClQ=\n','2009-05-18 18:12:42','2009-05-20 00:02:12');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stories`
--

DROP TABLE IF EXISTS `stories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `stories` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `start_at` datetime default NULL,
  `end_at` datetime default NULL,
  `theme_id` int(11) NOT NULL default '0',
  `photo_file_name` varchar(255) default NULL,
  `photo_content_type` varchar(255) default NULL,
  `photo_file_size` int(11) default NULL,
  `photo_updated_at` datetime default NULL,
  `category_id` int(11) default NULL,
  `type` varchar(255) default NULL,
  `story` text,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `stories`
--

LOCK TABLES `stories` WRITE;
/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
INSERT INTO `stories` VALUES (1,85,'test','2009-02-11 22:13:30','2009-02-17 18:24:03',NULL,NULL,0,'people.png','image/png',3211,'2009-02-17 18:24:02',NULL,NULL,NULL),(2,85,'foo fa fee','2009-02-12 19:18:36','2009-02-18 06:05:05',NULL,NULL,0,'drinky_crow.jpg','image/jpeg',35885,'2009-02-18 06:05:05',NULL,NULL,NULL),(3,85,'ass','2009-02-23 17:58:17','2009-02-23 17:58:17',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,85,'foo far','2009-02-23 19:23:38','2009-02-23 19:23:38',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,85,'foo shmar','2009-02-23 20:55:18','2009-02-23 20:55:18',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,85,'foo shmar','2009-02-23 20:59:01','2009-02-23 20:59:01',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,85,'foo shmar','2009-02-23 21:13:53','2009-02-23 21:13:53',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,85,'foo shmar','2009-02-23 21:14:36','2009-02-23 21:14:36',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,85,'foo shmar','2009-02-23 21:15:24','2009-02-23 21:15:24',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,85,'foo shmar','2009-02-23 21:15:53','2009-02-23 21:15:53',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(11,85,'shwah','2009-02-23 21:18:09','2009-02-23 21:18:09',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,85,'fail fail','2009-02-24 00:30:37','2009-02-24 00:30:37',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,85,'pants','2009-02-24 06:40:56','2009-02-24 06:40:56',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(14,85,'my recording test','2009-02-27 05:37:37','2009-02-27 05:37:37',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(15,85,'blahblah','2009-02-27 22:00:09','2009-02-27 22:00:09',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(16,85,'ass','2009-02-27 22:10:23','2009-02-27 22:10:23',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(17,85,'ass','2009-02-27 22:22:16','2009-02-27 22:22:16',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(18,85,'My Wedding','2009-02-27 23:54:29','2009-02-27 23:54:29',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(19,85,'My Wedding','2009-02-27 23:56:10','2009-02-27 23:56:10',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,85,'My Wedding','2009-02-28 00:19:23','2009-02-28 00:19:23',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,85,'i choo-choose you','2009-02-28 00:59:05','2009-02-28 00:59:05',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(22,85,'my high school reunion','2009-02-28 04:50:56','2009-03-20 02:53:38','1900-01-30 00:00:00','1906-03-01 00:00:00',0,'drinky_crow.jpg','image/jpeg',35885,'2009-03-12 19:39:02',28,NULL,NULL),(23,85,'testing audio recording playback','2009-03-03 22:41:10','2009-03-03 22:41:10',NULL,NULL,0,NULL,NULL,NULL,NULL,24,NULL,NULL),(24,85,'testing flv->mp3','2009-03-04 16:46:01','2009-03-04 16:46:01',NULL,NULL,0,NULL,NULL,NULL,NULL,24,NULL,NULL),(25,85,'wow audio worked?','2009-03-04 21:12:18','2009-03-04 21:12:18',NULL,NULL,0,NULL,NULL,NULL,NULL,28,NULL,NULL),(26,85,'swass recording','2009-03-05 19:50:02','2009-03-05 19:50:02',NULL,NULL,0,NULL,NULL,NULL,NULL,28,'Documentary',NULL),(27,85,'a video recording','2009-03-10 06:13:35','2009-03-10 06:13:36',NULL,NULL,0,NULL,NULL,NULL,NULL,37,'Documentary',NULL),(28,85,'testing audio','2009-03-22 16:15:57','2009-03-22 16:15:58',NULL,NULL,0,NULL,NULL,NULL,NULL,26,'Documentary',NULL),(29,88,'blargh','2009-03-26 20:14:24','2009-03-26 20:14:24','2009-03-24 00:00:00','2009-03-27 00:00:00',0,NULL,NULL,NULL,NULL,28,'Documentary',NULL),(30,88,'slamma','2009-05-13 20:46:12','2009-05-15 02:58:21',NULL,NULL,0,'Annick_s_Gratin_savoyard_zoom.jpg','image/jpeg',442040,'2009-05-15 02:58:20',24,NULL,'');
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_discounts`
--

DROP TABLE IF EXISTS `subscription_discounts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscription_discounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `code` varchar(255) default NULL,
  `amount` decimal(6,2) default '0.00',
  `percent` tinyint(1) default NULL,
  `start_on` date default NULL,
  `end_on` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscription_discounts`
--

LOCK TABLES `subscription_discounts` WRITE;
/*!40000 ALTER TABLE `subscription_discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscription_discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_payments`
--

DROP TABLE IF EXISTS `subscription_payments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscription_payments` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) default NULL,
  `subscription_id` int(11) default NULL,
  `amount` decimal(10,2) default '0.00',
  `transaction_id` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `setup` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `account_id` (`account_id`),
  KEY `subscription_id` (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscription_payments`
--

LOCK TABLES `subscription_payments` WRITE;
/*!40000 ALTER TABLE `subscription_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscription_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_plans`
--

DROP TABLE IF EXISTS `subscription_plans`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscription_plans` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `amount` decimal(10,2) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_limit` int(11) default NULL,
  `renewal_period` int(11) default '1',
  `setup_amount` decimal(10,2) default NULL,
  `trial_period` int(11) default '1',
  `allow_subdomain` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscription_plans`
--

LOCK TABLES `subscription_plans` WRITE;
/*!40000 ALTER TABLE `subscription_plans` DISABLE KEYS */;
INSERT INTO `subscription_plans` VALUES (1,'Free','0.00','2009-02-05 18:01:41','2009-02-05 18:01:41',2,1,NULL,NULL,0),(2,'Basic','10.00','2009-02-05 18:01:41','2009-02-05 18:01:41',5,1,NULL,NULL,0),(3,'Premium','30.00','2009-02-05 18:01:41','2009-02-05 18:01:41',NULL,1,NULL,NULL,0);
/*!40000 ALTER TABLE `subscription_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL auto_increment,
  `amount` decimal(10,2) default NULL,
  `next_renewal_at` datetime default NULL,
  `card_number` varchar(255) default NULL,
  `card_expiration` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `state` varchar(255) default 'trial',
  `subscription_plan_id` int(11) default NULL,
  `account_id` int(11) default NULL,
  `user_limit` int(11) default NULL,
  `renewal_period` int(11) default '1',
  `billing_id` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
INSERT INTO `subscriptions` VALUES (87,'10.00','2009-03-09 00:38:57',NULL,NULL,'2009-02-09 01:38:57','2009-02-09 01:38:57','active',2,87,5,1,NULL),(88,'0.00','2009-03-09 23:59:49',NULL,NULL,'2009-02-09 23:59:49','2009-02-09 23:59:49','active',1,88,2,1,NULL),(89,'0.00','2009-03-10 00:09:21',NULL,NULL,'2009-02-10 00:09:21','2009-02-10 00:09:21','active',1,89,2,1,NULL),(90,'0.00','2009-04-12 18:38:11',NULL,NULL,'2009-03-12 18:38:11','2009-03-12 18:38:11','active',1,90,2,1,NULL),(91,'0.00','2009-04-12 19:32:20',NULL,NULL,'2009-03-12 19:32:20','2009-03-12 19:32:20','active',1,91,2,1,NULL),(92,'0.00','2009-06-19 14:16:37',NULL,NULL,'2009-05-19 14:16:37','2009-05-19 14:16:37','active',1,96,2,1,NULL),(93,'0.00','2009-06-19 15:05:48',NULL,NULL,'2009-05-19 15:05:48','2009-05-19 15:05:48','active',1,97,2,1,NULL);
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) NOT NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type` (`taggable_id`,`taggable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
INSERT INTO `taggings` VALUES (71,43,129,'Content','2009-05-15 19:34:32',88),(72,43,130,'Content','2009-05-15 19:34:32',88),(73,43,131,'Content','2009-05-15 19:34:33',88);
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (43,'har');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `themes`
--

DROP TABLE IF EXISTS `themes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `themes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `themes`
--

LOCK TABLES `themes` WRITE;
/*!40000 ALTER TABLE `themes` DISABLE KEYS */;
/*!40000 ALTER TABLE `themes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_locks`
--

DROP TABLE IF EXISTS `time_locks`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `time_locks` (
  `id` int(11) NOT NULL auto_increment,
  `lockable_id` int(11) default NULL,
  `lockable_type` varchar(255) default NULL,
  `unlock_on` date default NULL,
  `days_after` int(11) default NULL,
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_time_locks_on_lockable` (`lockable_id`,`lockable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `time_locks`
--

LOCK TABLES `time_locks` WRITE;
/*!40000 ALTER TABLE `time_locks` DISABLE KEYS */;
INSERT INTO `time_locks` VALUES (52,4,'GuestInvitation','2013-04-22',NULL,NULL),(53,13,'Message','2009-04-22',NULL,'DeathLock');
/*!40000 ALTER TABLE `time_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timelines`
--

DROP TABLE IF EXISTS `timelines`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `timelines` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `timelines`
--

LOCK TABLES `timelines` WRITE;
/*!40000 ALTER TABLE `timelines` DISABLE KEYS */;
/*!40000 ALTER TABLE `timelines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transcodings`
--

DROP TABLE IF EXISTS `transcodings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `transcodings` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) NOT NULL,
  `size` int(11) default NULL,
  `filename` varchar(255) default NULL,
  `width` varchar(255) default NULL,
  `height` varchar(255) default NULL,
  `duration` varchar(255) default NULL,
  `video_codec` varchar(255) default NULL,
  `audio_codec` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `processing_error_message` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `bitrate` varchar(255) default NULL,
  `fps` varchar(255) default NULL,
  `command` varchar(255) default NULL,
  `command_expanded` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `transcodings`
--

LOCK TABLES `transcodings` WRITE;
/*!40000 ALTER TABLE `transcodings` DISABLE KEYS */;
INSERT INTO `transcodings` VALUES (1,4,668705,'/var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/Ice_Cube_-_It_Was_a_Good_Day6777-0.flv','320','240','15610','flv','mp3','processed',NULL,'2009-02-23 20:16:59','2009-02-23 20:18:00','64 kb/s',NULL,'ffmpeg -i $input_file$ -y -s $resolution$ -ar 44100 -ab 64k -f flv -r 29.97 $output_file$\nflvtool2 -U $output_file$','ffmpeg -i /Users/marcmauger/Documents/costasoft/projects/eternos.com/public/assets/0000/0004/Ice_Cube_-_It_Was_a_Good_Day.mpg -y -s 320x240 -ar 44100 -ab 64k -f flv -r 29.97 /var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/Ice_Cube_-_It_Was_a_Good_Day6777-0.flv,flvtool2 -U /var/folders/HW/HWbOzPIeEOqaqOUlV5TAF++++TI/-Tmp-/Ice_Cube_-_It_Was_a_Good_Day6777-0.flv'),(2,84,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'error','RVideo::TranscoderError::InvalidFile: Codec not supported by this build of ffmpeg','2009-03-13 21:21:43','2009-03-13 21:21:44',NULL,NULL,'ffmpeg -i $input_file$ -y -s $resolution$ -ar 44100 -ab 64k -f flv -r 29.97 $output_file$\nflvtool2 -U $output_file$',''),(3,98,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'error','RVideo::TranscoderError::InvalidFile: Codec not supported by this build of ffmpeg','2009-03-26 18:49:31','2009-03-26 18:49:32',NULL,NULL,'ffmpeg -i $input_file$ -y -s $resolution$ -ar 44100 -ab 64k -f flv -r 29.97 $output_file$\nflvtool2 -U $output_file$',''),(4,126,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'error','RVideo::TranscoderError::InvalidFile: Codec not supported by this build of ffmpeg','2009-05-15 16:19:17','2009-05-15 16:19:17',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `transcodings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `crypted_password` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `identity_url` varchar(255) default NULL,
  `state` varchar(255) NOT NULL default 'passive',
  `deleted_at` datetime default NULL,
  `invitation_id` int(11) default NULL,
  `invitation_limit` int(11) NOT NULL default '0',
  `type` varchar(255) default NULL,
  `account_id` int(11) default NULL,
  `last_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `password_salt` varchar(255) default NULL,
  `facebook_uid` bigint(20) default NULL,
  `last_request_at` datetime default NULL,
  `perishable_token` varchar(255) NOT NULL,
  `current_login_ip` varchar(255) default NULL,
  `failed_login_count` int(11) NOT NULL default '0',
  `current_login_at` datetime default NULL,
  `login_count` int(11) NOT NULL default '0',
  `persistence_token` varchar(255) NOT NULL,
  `last_login_ip` varchar(255) default NULL,
  `last_login_at` datetime default NULL,
  `email_hash` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (85,'eternos123@mailinator.com','eternos123@mailinator.com','efa306c63971dcad5355814c9f3ad212bb8a055e','2009-02-10 00:09:19','2009-02-27 17:38:07',NULL,'2009-02-10 00:09:38',NULL,'active',NULL,NULL,5,'Member',89,NULL,NULL,'',NULL,NULL,'',NULL,0,NULL,0,'',NULL,NULL,NULL),(87,'simian187@hotmail.com','simian187@hotmail.com','f5c942a34052579b5528c6edaaa319a4e8e171a1','2009-03-12 18:38:09','2009-03-12 18:38:09','d72193c118c6d39e837bb618d9caa015a3d25b18',NULL,NULL,'pending',NULL,NULL,5,NULL,90,NULL,NULL,'',NULL,NULL,'',NULL,0,NULL,0,'',NULL,NULL,NULL),(88,'eternos111@mailinator.com','eternos111@mailinator.com','d386d65d6be71b9839d1e02377e1465ee0f16bec','2009-03-12 19:32:18','2009-05-19 15:30:57',NULL,'2009-03-12 19:33:01',NULL,'active',NULL,NULL,5,'Member',91,'doctor','ass','',NULL,NULL,'',NULL,0,NULL,0,'',NULL,NULL,NULL),(89,'ass@grass.com','ass@grass.com',NULL,'2009-05-19 14:16:33','2009-05-19 14:16:33','65ddd2cb50111cbcfeb285f08cc946e83c89582a',NULL,NULL,'pending',NULL,NULL,5,NULL,96,'man','test',NULL,NULL,NULL,'',NULL,0,NULL,0,'',NULL,NULL,NULL),(90,'eternos1@mailinator.com','eternos1@mailinator.com','bd9e67e596f5710bf4200d988754f9b9997a62a6be00214a1210103258a2b3fb74f279678c73db0abfb3bf140439c5d6b424dbd8fad2a6d1bb7b1fd7ef48b948','2009-05-19 15:03:24','2009-05-19 15:03:24','24545e7311edee54846bdf87f97fa9edd9c3cbb3',NULL,NULL,'pending',NULL,NULL,5,NULL,NULL,'john','dr','jhrLJ_6bdejHAxFT6qvD',NULL,NULL,'',NULL,0,NULL,0,'',NULL,NULL,NULL),(91,'eternos2@mailinator.com','eternos2@mailinator.com','3bdf42aa790b61d4206d6d871cc074736a3730bdb24691f743dbdfd48db1890586fe2f45a65ab57541407ec6c04c8cdd2d32bbe66087ba444280a8c8adf1fae3','2009-05-19 15:05:45','2009-05-19 17:45:38',NULL,'2009-05-19 15:07:08',NULL,'active',NULL,NULL,5,'Member',97,'hat','ass','bUHGeqsGuz4BnK3vM8k_',NULL,NULL,'',NULL,0,NULL,0,'',NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-05-20  0:09:55
