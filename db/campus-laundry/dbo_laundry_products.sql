-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: dbo
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `laundry_products`
--

DROP TABLE IF EXISTS `laundry_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laundry_products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(100) NOT NULL,
  `product_fabric` varchar(100) DEFAULT NULL,
  `price` float NOT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `product_name` (`product_name`,`product_fabric`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laundry_products`
--

LOCK TABLES `laundry_products` WRITE;
/*!40000 ALTER TABLE `laundry_products` DISABLE KEYS */;
INSERT INTO `laundry_products` VALUES (1,'T-Shirt','Cotton',8.05),(2,'T-Shirt','Polyester',6.25),(3,'T-Shirt','Blend (Cotton-Polyester)',6.25),(4,'T-Shirt','Linen',9.25),(5,'T-Shirt','Rayon',9.5),(6,'T-Shirt','Modal',6.5),(7,'Jeans','Denim',6.99),(8,'Jeans','Cotton',9.99),(9,'Jeans','Polyester',9.25),(10,'Jeans','Blend (Cotton-Polyester)',7.05),(11,'Jeans','Spandex',6.99),(12,'Dress Shirt','Cotton',8.25),(13,'Dress Shirt','Polyester',9.05),(14,'Dress Shirt','Blend (Cotton-Polyester)',9.99),(15,'Dress Shirt','Silk',6.05),(16,'Dress Shirt','Linen',6.99),(17,'Blouse','Chiffon',7.25),(18,'Blouse','Silk',6.05),(19,'Blouse','Polyester',6.05),(20,'Blouse','Satin',6.5),(21,'Blouse','Cotton',8.25),(22,'Sweater','Wool',6.05),(23,'Sweater','Cashmere',9.99),(24,'Sweater','Acrylic',9.5),(25,'Sweater','Cotton',9.05),(26,'Sweater','Blend (Cotton-Polyester)',9.05),(27,'Sweater','Mohair',7.5),(28,'Suit','Wool',7.99),(29,'Suit','Polyester',7.99),(30,'Suit','Blend (Wool-Polyester)',7.25),(31,'Suit','Linen',7.25),(32,'Suit','Silk',6.05),(33,'Skirt','Cotton',9.25),(34,'Skirt','Polyester',9.25),(35,'Skirt','Blend (Cotton-Polyester)',8.05),(36,'Skirt','Denim',9.99),(37,'Skirt','Linen',7.05),(38,'Shorts','Cotton',9.05),(39,'Shorts','Polyester',7.25),(40,'Shorts','Blend (Cotton-Polyester)',8.99),(41,'Shorts','Linen',7.25),(42,'Shorts','Spandex',9.25),(43,'Jacket','Leather',9.99),(44,'Jacket','Denim',7.5),(45,'Jacket','Cotton',8.5),(46,'Jacket','Polyester',8.5),(47,'Jacket','Blend (Cotton-Polyester)',9.05),(48,'Jacket','Nylon',7.99),(49,'Leggings','Spandex',9.25),(50,'Leggings','Polyester',7.05),(51,'Leggings','Blend (Polyester-Spandex)',9.99),(52,'Leggings','Nylon',8.99),(53,'Leggings','Cotton',8.5),(54,'Pajamas','Flannel',6.99),(55,'Sweatshirt','Blend (Cotton-Polyester)',7.5),(56,'Swimwear','Blend (Nylon-Spandex)',7.25),(57,'Tracksuit','Blend (Cotton-Polyester)',6.25),(58,'Onesie','Cotton',9.99),(59,'Joggers','French Terry',7.05),(60,'Cardigan','Acrylic',7.05),(61,'Blouse',NULL,0),(62,'Cardigan',NULL,0),(63,'Dress Shirt',NULL,0),(64,'Jacket',NULL,0),(65,'Jeans',NULL,0),(66,'Joggers',NULL,0),(67,'Leggings',NULL,0),(68,'Onesie',NULL,0),(69,'Pajamas',NULL,0),(70,'Shorts',NULL,0),(71,'Skirt',NULL,0),(72,'Suit',NULL,0),(73,'Sweater',NULL,0),(74,'Sweatshirt',NULL,0),(75,'Swimwear',NULL,0),(76,'T-Shirt',NULL,0),(77,'Tracksuit',NULL,0);
/*!40000 ALTER TABLE `laundry_products` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-07-31 10:13:50
