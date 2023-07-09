CREATE DATABASE  IF NOT EXISTS `dbo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `dbo`;
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
-- Dumping events for database 'dbo'
--

--
-- Dumping routines for database 'dbo'
--
/*!50003 DROP PROCEDURE IF EXISTS `usp_get_customer_address_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `usp_get_customer_address_list`(
    IN p_customer_id INT
)
BEGIN

	select address_id, customer_id, street, city,
    province, country, postal_code, IF(is_active, 'true','false') as is_active
    from customer_address
    where customer_id = p_customer_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `usp_get_customer_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `usp_get_customer_details`(
    IN p_email VARCHAR(100)
)
BEGIN
    SELECT c.customer_id AS customer_id, first_name, 
    last_name, c.email AS email, date_of_birth, gender
    FROM customer c
    LEFT JOIN customer_details cd ON c.customer_id = cd.customer_id
    WHERE c.email = p_email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `usp_get_customer_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `usp_get_customer_login`(
    IN p_email VARCHAR(100),
    IN p_password TEXT
)
BEGIN
    DECLARE v_CustomerID INT;

    -- Insert statements for procedure here
    SELECT customer_id INTO v_CustomerID  
    FROM customer WHERE email = p_email;

    IF v_CustomerID IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
            FROM customer
            WHERE customer_id = v_CustomerID
              AND `password` = p_password
        ) THEN
            -- Password is correct
            SELECT 'true' AS query_status, 'Login successful' AS message, v_CustomerID AS customer_id;
        ELSE
            -- Password is incorrect
            SELECT 'false' AS query_status, 'Incorrect password' AS message, 0 AS customer_id;
        END IF;
    ELSE
        -- Email does not exist
        SELECT 'false' AS query_status, 'Email not found' AS message, 0 AS customer_id;
    END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `usp_get_customer_order_by_order_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `usp_get_customer_order_by_order_id`(
    IN p_customer_id INT,
    IN p_order_id INT
)
sp: BEGIN

    SELECT o.order_id, o.customer_id, 
            o.items_count, o.order_date, o.order_weight, 
            p.total_price, p.payment_status,
            p.payment_date,
            (SELECT JSON_ARRAYAGG(JSON_OBJECT(
                'product_id', ops.product_id,
                'quantity', ops.quantity,
                'laundry_type', ops.laundry_type,
                'price', ops.price
            )) FROM order_product_summary ops WHERE ops.order_id = o.order_id) AS laundry_items,
            (SELECT JSON_OBJECT(
                'pickup_date', opt.pickup_date,
                'pickup_time', opt.pickup_time,
                'address_id', (select CONCAT(street,",", city,",", province,",",country,",", postal_code) from customer_address ca where ca.address_id = opt.address_id)
            ) FROM order_pickup_details opt WHERE opt.order_id = o.order_id) AS pickup_details
    FROM orders o left join payments p on o.order_id = p.order_id
    where o.order_id = p_order_id and o.customer_id = p_customer_id;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `usp_get_laundry_items` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `usp_get_laundry_items`(
    IN p_wash TINYINT(1)
)
BEGIN
    IF p_wash = 1 THEN
        SELECT product_id, product_name, product_fabric, COALESCE(price, 0) AS price
        FROM laundry_products
        WHERE product_fabric IS NULL;
    ELSE
        SELECT product_id, product_name, product_fabric, COALESCE(price, 0) AS price
        FROM laundry_products;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `usp_set_customer_address` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `usp_set_customer_address`(
    IN p_customer_id INT,
    IN p_street VARCHAR(100),
    IN p_city VARCHAR(50),
    IN p_province VARCHAR(50),
    IN p_postal_code VARCHAR(20),
    IN p_country VARCHAR(50),
    IN p_latitude FLOAT,
    IN p_longitude FLOAT,
    IN p_address_id INT
)
sp:BEGIN

    IF p_address_id IS NULL THEN
        UPDATE customer_address
        SET is_default = 0
        WHERE customer_id = p_customer_id;

        INSERT INTO customer_address (customer_id, street, city, province, postal_code, country, latitude, longitude, is_active, is_default)
        VALUES (p_customer_id, p_street, p_city, p_province, p_postal_code, p_country, p_latitude, p_longitude, 1, 1);

        SELECT 'true' AS query_status, 'Successfully Created Address' AS message;
        LEAVE sp;
    ELSE
        IF EXISTS (SELECT 1 FROM customer_address WHERE address_id = p_address_id) THEN
            IF EXISTS (SELECT 1 FROM customer_address WHERE address_id = p_address_id AND customer_id = p_customer_id) THEN
                
                Update customer_address
                set is_default = 0
                where customer_id = p_customer_id;
                
                UPDATE customer_address
                SET street = p_street,
                    city = p_city,
                    province = p_province,
                    postal_code = p_postal_code,
                    country = p_country,
                    latitude = p_latitude,
                    longitude = p_longitude,
                    is_active = 1,
                    is_default = 1
                WHERE address_id = p_address_id AND customer_id = p_customer_id;

                SELECT 'true' AS query_status, 'Successfully Updated Address' AS message;
            ELSE
                SELECT 'false' AS query_status, 'Address ID and customer ID mismatch' AS message;
            END IF;
        ELSE
            SELECT 'false' AS query_status, 'Invalid Address ID' AS message;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `usp_set_customer_address_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `usp_set_customer_address_status`(
	IN p_customer_id INT,
	IN p_address_id INT,
    IN p_active INT
)
sp: BEGIN
	IF NOT EXISTS (
        SELECT 1 FROM customer_address 
        WHERE customer_id = p_customer_id 
        AND address_id = p_address_id
    ) THEN
		SELECT 'false' AS query_status, 'Address not found' AS message;
		LEAVE sp;
	END IF;
	
	UPDATE customer_address
	SET is_active = p_active
	WHERE customer_id = p_customer_id AND address_id = p_address_id;
	
    SELECT 'true' AS query_status, CONCAT('Address ', IF(p_active, 'activated', 'inactivated') , ' successfully') AS message;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `usp_set_customer_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `usp_set_customer_order`(
    IN p_customer_id INT,
    IN p_items_count INT,
    IN p_total_price FLOAT,
    IN p_laundry_items JSON,
    IN p_pickup_details JSON,
    IN p_order_weight FLOAT,
    IN p_subscribed_id INT,
    IN p_order_id INT
)
sp:BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
    DECLARE `new_order` BOOL DEFAULT 0;
	-- DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
    
	IF NOT EXISTS (select 1 from customer where customer_id = p_customer_id) 
    THEN
		select 'false' as  query_status, 'customer id not found' as message, p_order_id AS order_id;
        LEAVE sp;
    END IF;
    
	IF (p_order_id is not null) 
		AND 
		NOT EXISTS(SELECT 1 FROM orders WHERE order_id = p_order_ID AND customer_id = p_customer_id) 
	THEN
		SELECT 'false' AS query_status, 'order id and customer id mismatch' AS message, p_order_id AS order_id;
		LEAVE sp;
	END IF;
    
    START TRANSACTION;
    
    IF p_order_id IS NULL 
    THEN
		SET `new_order` = 1;
        
		INSERT INTO `dbo`.`orders`
		(
		`customer_id`, `items_count`, `order_weight`,
		`subscribed_id`, `order_date`)
        VALUES 
        (
        p_customer_id, p_items_count, p_order_weight,
		p_subscribed_id, NOW());
        
        SET p_order_id = LAST_INSERT_ID();
        
        INSERT INTO order_status 
        (order_id, order_status, updated_date) 
        VALUES (p_order_id, 'created', NOW());
        
        INSERT INTO payments 
        (order_id, customer_id, payment_status, total_price, payment_date) 
        VALUES 
        (p_order_id, p_customer_id, 'pending', p_total_price, NOW());       
    END IF;
    
    DROP TEMPORARY TABLE IF EXISTS orderSummaryTest;
    CREATE TEMPORARY TABLE orderSummaryTest (
        order_id INT,
        product_id INT,
        quantity INT,
        laundry_type VARCHAR(100),
        price FLOAT
    );

    INSERT INTO orderSummaryTest (order_id, product_id, quantity, laundry_type, price)
    SELECT p_order_id, product_id, quantity, laundry_type, price
    FROM JSON_TABLE(p_laundry_items,
        '$[*]'
        COLUMNS (
            product_id INT PATH '$.product_id',
            quantity INT PATH '$.quantity',
            price FLOAT PATH '$.price',
            laundry_type VARCHAR(100) PATH '$.laundry_type'
        )
    ) AS jt;

    DELETE ops
    FROM order_product_summary ops
    LEFT JOIN orderSummaryTest ost 
		ON ops.order_id = ost.order_id 
		AND ops.product_id = ost.product_id
        AND ops.laundry_type = ost.laundry_type
    WHERE ost.product_id IS NULL 
		AND ost.laundry_type is null
		AND ops.order_id = p_order_id;
    
    
    -- Insert new records
    INSERT INTO order_product_summary 
    (order_id, product_id, quantity, laundry_type, price)
     SELECT 
		 ost.order_id, 
		 ost.product_id, 
		 ost.quantity, 
		 ost.laundry_type, 
		ost.price
     FROM orderSummaryTest ost
     ON DUPLICATE KEY UPDATE
         order_product_summary.quantity = ost.quantity,
         order_product_summary.price = ost.price;
         
	DROP TEMPORARY TABLE IF EXISTS orderPickupTest;
    CREATE TEMPORARY TABLE orderPickupTest(
		order_id INT,
        pickup_date Date,
        pickup_time varchar(100),
        address_id INT    
    );
    
    INSERT INTO orderPickupTest (order_id, pickup_date, pickup_time, address_id)
    SELECT p_order_id, op_jt.pickup_date, op_jt.pickup_time, op_jt.address_id
    FROM JSON_TABLE(p_pickup_details,
		'$'
        COLUMNS (
            pickup_date Date PATH '$.pickup_date',
            pickup_time varchar(100) PATH '$.pickup_time',
            address_id INT PATH '$.address_id'
        )
    ) AS op_jt;
    
    -- Insert new records
    INSERT INTO order_pickup_details
    (order_id, pickup_date, pickup_time, address_id)
     SELECT 
		 opt.order_id, 
		 opt.pickup_date, 
		 opt.pickup_time, 
		 opt.address_id
     FROM orderPickupTest opt
     ON DUPLICATE KEY UPDATE
         order_pickup_details.pickup_date = opt.pickup_date,
         order_pickup_details.pickup_time = opt.pickup_time,
         order_pickup_details.address_id = opt.address_id;         
		
    IF `_rollback` THEN
		ROLLBACK;  
        SELECT 'false' AS query_status, 'Failed to create order' AS message, null AS order_id;
    ELSE
        COMMIT;
        SELECT 'true' AS query_status, CONCAT('Order ',IF(`new_order`,'Created', 'Updated'),' Successfully') AS message, p_order_id AS order_id;
    END IF;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `usp_set_customer_registration` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `usp_set_customer_registration`(
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password TEXT,
    IN p_phone_number VARCHAR(20)
)
sp: BEGIN
    -- Check if customer already exists
    IF EXISTS (SELECT 1 FROM customer WHERE email = p_email) THEN
        SELECT 'false' AS query_status, 'Customer already exists' AS message;
        LEAVE sp;
    END IF;

    -- Insert customer record
    INSERT INTO customer (first_name, last_name, `password`, email, is_active)
    VALUES (p_first_name, p_last_name, p_password, p_email, 1);

    -- Get the newly inserted Customer_ID
    SET @Customer_ID = LAST_INSERT_ID();

    -- Insert customer phone number if provided
    IF p_phone_number IS NOT NULL THEN
        UPDATE customer_phone_number
        set is_default = 0
        WHERE customer_id = @Customer_ID;

        INSERT INTO customer_phone_number (customer_id, phone_number, is_active, is_default)
        VALUES (@Customer_ID, p_phone_number,1,1);
    END IF;

    SELECT 'true' AS query_status, 'Registration successful' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-07-07 20:16:14
