CREATE DATABASE  IF NOT EXISTS `dbo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `dbo`;

DROP TABLE IF EXISTS `order_pickup_details`;
CREATE TABLE `order_pickup_details` (
  `order_pickup_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `pickup_date` date NOT NULL,
  `pickup_time` varchar(50) DEFAULT NULL,
  `address_id` int NOT NULL,
  PRIMARY KEY (`order_pickup_id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `address_id` (`address_id`),
  CONSTRAINT `order_pickup_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_pickup_details_ibfk_2` FOREIGN KEY (`address_id`) REFERENCES `customer_address` (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
