-- MySQL dump 10.13  Distrib 8.0.33, for Linux (x86_64)
--
-- Host: std-mysql    Database: std_2438_exam_mezhitov
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('a6287050360f');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_genre`
--

DROP TABLE IF EXISTS `book_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_genre` (
  `book_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL,
  PRIMARY KEY (`book_id`,`genre_id`),
  KEY `fk_book_genre_genre_id_genres` (`genre_id`),
  CONSTRAINT `fk_book_genre_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `fk_book_genre_genre_id_genres` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_genre`
--

LOCK TABLES `book_genre` WRITE;
/*!40000 ALTER TABLE `book_genre` DISABLE KEYS */;
INSERT INTO `book_genre` VALUES (1,1),(3,1),(8,1),(9,1),(10,1),(13,1),(1,2),(3,2),(7,2),(9,2),(10,2),(13,2),(2,3),(3,3),(7,3),(10,3),(13,3);
/*!40000 ALTER TABLE `book_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `short_desc` text NOT NULL,
  `year` varchar(4) NOT NULL,
  `pub_house` varchar(100) NOT NULL,
  `author` varchar(100) NOT NULL,
  `volume` int(11) NOT NULL,
  `rating_sum` int(11) NOT NULL,
  `rating_num` int(11) NOT NULL,
  `image_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_books_image_id_images` (`image_id`),
  CONSTRAINT `fk_books_image_id_images` FOREIGN KEY (`image_id`) REFERENCES `images` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'Книга1','Описание1','2000','Издательство1','Автор11',10,10,3,'ea265e80-7d04-4bd1-a460-be1e2ad6d6c3'),(2,'Книга2','Описание2','2002','Издательство2','Автор2',20,4,2,'ea265e80-7d04-4bd1-a460-be1e2ad6d6c3'),(3,'Книга3','Описание3','2003','Издательство3','Автор3',30,4,2,'ea265e80-7d04-4bd1-a460-be1e2ad6d6c3'),(5,'книга4','описание4','2004','издательство4','автор4',40,0,0,'1d231c8e-740a-466e-ad8a-3a772dcc07f9'),(6,'книга5','описание5','1995','издатльство5','автор5',50,0,0,'1d231c8e-740a-466e-ad8a-3a772dcc07f9'),(7,'книга622','описание66','2023','издательство66','автор66',616,5,1,'1d231c8e-740a-466e-ad8a-3a772dcc07f9'),(8,'книга7','оыфвфывыф','1928','издательство7','автор7',50,0,0,'1d231c8e-740a-466e-ad8a-3a772dcc07f9'),(9,'книга8','ыавывы','2000','издательсвто8','автор8',4,0,0,'1d231c8e-740a-466e-ad8a-3a772dcc07f9'),(10,'книга9','описание9\r\n','2003','издательство9','автор9',65,0,0,'1d231c8e-740a-466e-ad8a-3a772dcc07f9'),(12,'книга10','описание10','2015','издательсвто10','автор10',10,0,0,'1d231c8e-740a-466e-ad8a-3a772dcc07f9'),(13,'книга11','аыввф','1990','издательство11','автор11',95,0,0,'1d231c8e-740a-466e-ad8a-3a772dcc07f9');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mark` int(11) NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime NOT NULL,
  `book_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_comments_book_id_books` (`book_id`),
  KEY `fk_comments_status_id_review_statuses` (`status_id`),
  KEY `fk_comments_user_id_users` (`user_id`),
  CONSTRAINT `fk_comments_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `fk_comments_status_id_review_statuses` FOREIGN KEY (`status_id`) REFERENCES `review_statuses` (`id`),
  CONSTRAINT `fk_comments_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,5,'фывфыв','2024-06-11 15:12:58',1,2,3),(2,5,'йцвфыв','2024-06-11 17:34:09',1,1,2),(3,2,'фывфыв','2024-06-11 18:08:23',3,1,2),(4,2,'ыфвфы','2024-06-11 19:53:24',3,2,1),(5,0,'ывфывфв','2024-06-11 19:53:48',2,2,1),(6,4,'ыфвфыв','2024-06-11 20:00:22',2,1,1),(7,5,'sadas','2024-06-13 23:35:55',7,3,1),(8,0,'ыфвфы','2024-06-13 23:36:14',1,3,1);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_genres_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (2,'Детектив'),(3,'История'),(1,'Фантастика');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `images` (
  `id` varchar(100) NOT NULL,
  `file_name` varchar(100) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `md5_hash` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_images_md5_hash` (`md5_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

LOCK TABLES `images` WRITE;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` VALUES ('1d231c8e-740a-466e-ad8a-3a772dcc07f9','1.png','image/png','db43e8673882a586c0ffa8979655ffcd'),('ea265e80-7d04-4bd1-a460-be1e2ad6d6c3','black.png','image/png','b8cec376cf50b942cc791aab6919afc6');
/*!40000 ALTER TABLE `images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_statuses`
--

DROP TABLE IF EXISTS `review_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_statuses`
--

LOCK TABLES `review_statuses` WRITE;
/*!40000 ALTER TABLE `review_statuses` DISABLE KEYS */;
INSERT INTO `review_statuses` VALUES (1,'На рассмотрении'),(2,'одобрена'),(3,'отклонена');
/*!40000 ALTER TABLE `review_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','admin'),(2,'moder','moder'),(3,'user','user');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `login` varchar(100) NOT NULL,
  `password_hash` varchar(256) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_login` (`login`),
  KEY `fk_users_role_id_roles` (`role_id`),
  CONSTRAINT `fk_users_role_id_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Иван','Иванов',NULL,'admin','pbkdf2:sha256:600000$jOmCi0ZPY90sQ1Yp$8802eaff99b7f2b596ea694edccf3ab5896eab2cbdc821ac0693d5430e7ee79a',1),(2,'Сергей','Сергеев',NULL,'moder','pbkdf2:sha256:600000$nWSaOqxFGOUQdyLh$d6f2e83820d2efd25e20277644776ad4720b7702914c7fe4c1d8680c6730fb03',2),(3,'Петр','Петров',NULL,'user','pbkdf2:sha256:600000$G15tABK2zeLh8APm$119db12b7958dd440d4adf70736dd5d445bbadf618d919d4cb299fc9302283c8',3);
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

-- Dump completed on 2024-06-14 14:02:43
