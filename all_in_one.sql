CREATE DATABASE IF NOT EXISTS `ecom_clothe`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

USE `ecom_clothe`;

CREATE TABLE IF NOT EXISTS `Attribute_value` (
  `Id` varchar(36) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Value` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_attr_name_value` (`Name`,`Value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Brand` (
  `Id` varchar(36) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Logo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_brand_name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Categories` (
  `Id` varchar(36) NOT NULL,
  `Name` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_categories_name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `User` (
  `Phone_num` char(10) NOT NULL,
  `Gender` tinyint(1) NOT NULL,
  PRIMARY KEY (`Phone_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Account` (
  `Email` varchar(50) NOT NULL,
  `NickName` varchar(100) NOT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `Role` varchar(50) NOT NULL,
  `Status` tinyint(1) NOT NULL,
  `Phone_num` char(10) NOT NULL,
  PRIMARY KEY (`Email`),
  KEY `fk_Account_User` (`Phone_num`),
  CONSTRAINT `fk_Account_User` FOREIGN KEY (`Phone_num`) REFERENCES `User` (`Phone_num`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Address` (
  `Note` text NOT NULL,
  `Street` varchar(255) NOT NULL,
  `District` varchar(255) NOT NULL,
  `City` varchar(255) NOT NULL,
  `Is_default` tinyint(1) NOT NULL,
  `Ordinal_num` int NOT NULL,
  `account_Email` varchar(50) NOT NULL,
  PRIMARY KEY (`account_Email`,`Ordinal_num`),
  KEY `idx_address_email_default` (`account_Email`,`Is_default`,`Ordinal_num`),
  CONSTRAINT `fk|Address|Account` FOREIGN KEY (`account_Email`) REFERENCES `Account` (`Email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Admin` (
  `Phone_num` char(10) NOT NULL,
  PRIMARY KEY (`Phone_num`),
  CONSTRAINT `fk|Admin|User` FOREIGN KEY (`Phone_num`) REFERENCES `User` (`Phone_num`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Customer` (
  `Phone_num` char(10) NOT NULL,
  PRIMARY KEY (`Phone_num`),
  CONSTRAINT `fk|Customer|User` FOREIGN KEY (`Phone_num`) REFERENCES `User` (`Phone_num`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Group_Product` (
  `Id` varchar(36) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `Categories_Id` varchar(36) NOT NULL,
  `Brand_Id` varchar(36) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk|Group_Product|Categories` (`Categories_Id`),
  KEY `fk|Group_Product|Brand` (`Brand_Id`),
  KEY `idx_group_product_cat_brand` (`Categories_Id`,`Brand_Id`),
  KEY `idx_group_product_name` (`Name`),
  CONSTRAINT `fk|Group_Product|Brand` FOREIGN KEY (`Brand_Id`) REFERENCES `Brand` (`Id`),
  CONSTRAINT `fk|Group_Product|Categories` FOREIGN KEY (`Categories_Id`) REFERENCES `Categories` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Orders` (
  `Id` varchar(36) NOT NULL,
  `Created_at` timestamp NOT NULL,
  `Order_status` varchar(20) NOT NULL,
  `Payment_status` varchar(20) NOT NULL,
  `Subtotal` double NOT NULL,
  `Shipping_fee` double NOT NULL,
  `Customer_Phone_num` char(10) NOT NULL,
  `Final_amount` double GENERATED ALWAYS AS ((`Subtotal` + `Shipping_fee`)) VIRTUAL,
  PRIMARY KEY (`Id`),
  KEY `fk|Orders|Customer` (`Customer_Phone_num`),
  KEY `idx_orders_customer_created` (`Customer_Phone_num`,`Created_at`,`Id`),
  KEY `idx_orders_payment_status_created` (`Payment_status`,`Order_status`,`Created_at`),
  KEY `idx_orders_status_created` (`Order_status`,`Created_at`),
  CONSTRAINT `fk|Orders|Customer1` FOREIGN KEY (`Customer_Phone_num`) REFERENCES `Customer` (`Phone_num`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Products` (
  `Id` varchar(36) NOT NULL,
  `Price` double NOT NULL,
  `Is_active` tinyint(1) NOT NULL,
  `Stock_quantity` int NOT NULL,
  `Group_Product_Id` varchar(36) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk|Products_Group|Product` (`Group_Product_Id`),
  KEY `idx_products_group_active_price` (`Group_Product_Id`,`Is_active`,`Price`),
  KEY `idx_products_stock_quantity` (`Stock_quantity`),
  CONSTRAINT `fk_Products_Group_Product1` FOREIGN KEY (`Group_Product_Id`) REFERENCES `Group_Product` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Review` (
  `Customer_Phone_num` char(10) NOT NULL,
  `Products_Id` varchar(36) NOT NULL,
  `Created_at` timestamp NOT NULL,
  `Rating` tinyint(1) NOT NULL,
  `Comment` text DEFAULT NULL,
  PRIMARY KEY (`Customer_Phone_num`,`Products_Id`),
  KEY `fk|Review|Products` (`Products_Id`),
  KEY `fk|Review|Customer` (`Customer_Phone_num`),
  KEY `idx_review_product_created_rating` (`Products_Id`,`Created_at`,`Rating`),
  CONSTRAINT `fk|Review|Customer` FOREIGN KEY (`Customer_Phone_num`) REFERENCES `Customer` (`Phone_num`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk|Review|Products` FOREIGN KEY (`Products_Id`) REFERENCES `Products` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Adjust` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Admin_Phone_num` char(10) NOT NULL,
  `Created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `Type_adjust` varchar(55) NOT NULL,
  `Object_name_adjusted` varchar(255) NOT NULL,
  `Type_Object` varchar(50) NOT NULL,
  `Id_Object_Adjusted` varchar(36) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk|Adjust|Admin` (`Admin_Phone_num`),
  KEY `idx_adjust_admin_created` (`Admin_Phone_num`,`Created_at`,`Id`),
  KEY `idx_adjust_created` (`Created_at`,`Id`),
  CONSTRAINT `fk|Adjust|Admin` FOREIGN KEY (`Admin_Phone_num`) REFERENCES `Admin` (`Phone_num`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=120008;

CREATE TABLE IF NOT EXISTS `Have` (
  `Attribute_value_Id` varchar(36) NOT NULL,
  `Products_Id` varchar(36) NOT NULL,
  PRIMARY KEY (`Attribute_value_Id`,`Products_Id`),
  KEY `fk|Have|Products` (`Products_Id`),
  KEY `fk|Have|Attribute_value` (`Attribute_value_Id`),
  CONSTRAINT `fk|Have|Attribute_value` FOREIGN KEY (`Attribute_value_Id`) REFERENCES `Attribute_value` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk|Have|Products` FOREIGN KEY (`Products_Id`) REFERENCES `Products` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Images` (
  `Name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `Ordinal_num` tinyint(1) NOT NULL,
  `Products_Id` varchar(36) NOT NULL,
  PRIMARY KEY (`Products_Id`,`Name`),
  KEY `idx_images_product_ordinal` (`Products_Id`,`Ordinal_num`,`url`),
  CONSTRAINT `fk|Images|Products` FOREIGN KEY (`Products_Id`) REFERENCES `Products` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `Other_detail` (
  `Quantity` int NOT NULL,
  `Unit_price` double NOT NULL,
  `Id` varchar(36) NOT NULL,
  `Products_Id` varchar(36) NOT NULL,
  `Orders_Id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk|Other_detail|Products` (`Products_Id`),
  KEY `fk|Other_detail|Orders` (`Orders_Id`),
  KEY `idx_other_detail_order_product` (`Orders_Id`,`Products_Id`,`Quantity`),
  CONSTRAINT `fk|Other_detail|Orders` FOREIGN KEY (`Orders_Id`) REFERENCES `Orders` (`Id`),
  CONSTRAINT `fk|Other_detail|Products` FOREIGN KEY (`Products_Id`) REFERENCES `Products` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE OR REPLACE VIEW vw_product_catalog AS
SELECT
    gp.Id                                                                        AS Group_Product_Id,
    gp.Name                                                                      AS Product_Name,
    gp.Description,
    c.Id                                                                         AS Category_Id,
    c.Name                                                                       AS Category_Name,
    b.Id                                                                         AS Brand_Id,
    b.Name                                                                       AS Brand_Name,
    COUNT(DISTINCT CASE WHEN p.Is_active = 1 THEN p.Id END)                      AS Active_Variant_Count,
    COALESCE(MIN(CASE WHEN p.Is_active = 1 THEN p.Price END), 0)                 AS Min_Price,
    COALESCE(MAX(CASE WHEN p.Is_active = 1 THEN p.Price END), 0)                 AS Max_Price,
    COALESCE(SUM(CASE WHEN p.Is_active = 1 THEN p.Stock_quantity ELSE 0 END), 0) AS Total_Active_Stock,
    COALESCE(ROUND(AVG(r.Rating), 2), 0)                                         AS Avg_Rating,
    COUNT(DISTINCT CONCAT(r.Customer_Phone_num, '|', r.Products_Id))             AS Review_Count
FROM Group_Product gp
JOIN Categories c       ON c.Id = gp.Categories_Id
JOIN Brand b            ON b.Id = gp.Brand_Id
LEFT JOIN Products p    ON p.Group_Product_Id = gp.Id
LEFT JOIN Review r      ON r.Products_Id = p.Id
GROUP BY gp.Id, gp.Name, gp.Description, c.Id, c.Name, b.Id, b.Name;

CREATE OR REPLACE VIEW vw_product_variant_details AS
SELECT
    p.Id    AS Product_Id,
    gp.Id   AS Group_Product_Id,
    gp.Name AS Group_Name,
    c.Name  AS Category_Name,
    b.Name  AS Brand_Name,
    p.Price,
    p.Stock_quantity,
    p.Is_active,
    GROUP_CONCAT(
        CONCAT(av.Name, ': ', av.Value)
        ORDER BY av.Name, av.Value
        SEPARATOR ' | '
    )       AS Attributes
FROM Products p
JOIN Group_Product gp        ON gp.Id = p.Group_Product_Id
JOIN Categories c            ON c.Id = gp.Categories_Id
JOIN Brand b                 ON b.Id = gp.Brand_Id
LEFT JOIN Have h             ON h.Products_Id = p.Id
LEFT JOIN Attribute_value av ON av.Id = h.Attribute_value_Id
GROUP BY p.Id, gp.Id, gp.Name, c.Name, b.Name, p.Price, p.Stock_quantity, p.Is_active;

CREATE OR REPLACE VIEW vw_order_summary AS
SELECT
    o.Id                          AS Order_Id,
    o.Created_at,
    o.Customer_Phone_num,
    u.Gender                      AS Customer_Gender,
    o.Order_status,
    o.Payment_status,
    o.Subtotal,
    o.Shipping_fee,
    o.Final_amount,
    COUNT(od.Id)                  AS Line_Item_Count,
    COALESCE(SUM(od.Quantity), 0) AS Total_Quantity
FROM Orders o
JOIN Customer cust        ON cust.Phone_num = o.Customer_Phone_num
JOIN `User` u             ON u.Phone_num = cust.Phone_num
LEFT JOIN Other_detail od ON od.Orders_Id = o.Id
GROUP BY
    o.Id, o.Created_at, o.Customer_Phone_num, u.Gender,
    o.Order_status, o.Payment_status, o.Subtotal, o.Shipping_fee, o.Final_amount;

CREATE OR REPLACE VIEW vw_daily_revenue AS
SELECT
    DATE(Created_at)  AS Order_Date,
    COUNT(*)          AS Total_Orders,
    SUM(Subtotal)     AS Total_Subtotal,
    SUM(Shipping_fee) AS Total_Shipping_Fee,
    SUM(Final_amount) AS Total_Revenue
FROM Orders
WHERE Payment_status = 'PAID'
  AND Order_status <> 'CANCELLED'
GROUP BY DATE(Created_at);

CREATE OR REPLACE VIEW vw_low_stock_products AS
SELECT
    p.Id    AS Product_Id,
    gp.Name AS Group_Name,
    c.Name  AS Category_Name,
    b.Name  AS Brand_Name,
    p.Price,
    p.Stock_quantity
FROM Products p
JOIN Group_Product gp ON gp.Id = p.Group_Product_Id
JOIN Categories c     ON c.Id = gp.Categories_Id
JOIN Brand b          ON b.Id = gp.Brand_Id
WHERE p.Is_active = 1
  AND p.Stock_quantity < 10;

CREATE OR REPLACE VIEW vw_admin_adjust_log AS
SELECT
    a.Id AS Log_Id,
    a.Created_at,
    a.Admin_Phone_num,
    a.Type_adjust,
    a.Type_Object,
    a.Id_Object_Adjusted,
    a.Object_name_adjusted
FROM Adjust a
JOIN Admin adm ON adm.Phone_num = a.Admin_Phone_num;



DELIMITER //

DROP TRIGGER IF EXISTS trg_products_before_insert //
CREATE TRIGGER trg_products_before_insert
BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
    IF NEW.Price < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Giá sản phẩm (Price) không được âm.';
    END IF;
    IF NEW.Stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Số lượng tồn kho (Stock_quantity) không được âm.';
    END IF;
END //

DROP TRIGGER IF EXISTS trg_products_before_update //
CREATE TRIGGER trg_products_before_update
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.Price < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Giá sản phẩm (Price) không được âm.';
    END IF;
    IF NEW.Stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Số lượng tồn kho (Stock_quantity) không được âm.';
    END IF;
END //

DROP TRIGGER IF EXISTS trg_other_detail_before_insert //
CREATE TRIGGER trg_other_detail_before_insert
BEFORE INSERT ON Other_detail
FOR EACH ROW
BEGIN
    IF NEW.Quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Số lượng mua (Quantity) phải lớn hơn 0.';
    END IF;
    IF NEW.Unit_price < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Đơn giá (Unit_price) không được âm.';
    END IF;
END //

DROP TRIGGER IF EXISTS trg_orders_before_insert //
CREATE TRIGGER trg_orders_before_insert
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Subtotal < 0 OR NEW.Shipping_fee < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subtotal và Shipping_fee không được âm.';
    END IF;
    IF UPPER(NEW.Order_status) NOT IN ('PENDING', 'SHIPPING', 'COMPLETED', 'CANCELLED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order_status không hợp lệ.';
    END IF;
    IF UPPER(NEW.Payment_status) NOT IN ('UNPAID', 'PAID') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Payment_status không hợp lệ.';
    END IF;
END //

DROP TRIGGER IF EXISTS trg_orders_before_update //
CREATE TRIGGER trg_orders_before_update
BEFORE UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Subtotal < 0 OR NEW.Shipping_fee < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subtotal và Shipping_fee không được âm.';
    END IF;
    IF UPPER(NEW.Order_status) NOT IN ('PENDING', 'SHIPPING', 'COMPLETED', 'CANCELLED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order_status không hợp lệ.';
    END IF;
    IF UPPER(NEW.Payment_status) NOT IN ('UNPAID', 'PAID') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Payment_status không hợp lệ.';
    END IF;
END //

DROP TRIGGER IF EXISTS trg_review_before_insert //
CREATE TRIGGER trg_review_before_insert
BEFORE INSERT ON Review
FOR EACH ROW
BEGIN
    IF NEW.Rating < 1 OR NEW.Rating > 5 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Điểm đánh giá (Rating) phải nằm trong khoảng từ 1 đến 5.';
    END IF;
END //

DROP TRIGGER IF EXISTS trg_review_before_update //
CREATE TRIGGER trg_review_before_update
BEFORE UPDATE ON Review
FOR EACH ROW
BEGIN
    IF NEW.Rating < 1 OR NEW.Rating > 5 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Điểm đánh giá (Rating) phải nằm trong khoảng từ 1 đến 5.';
    END IF;
END //

DROP TRIGGER IF EXISTS trg_account_before_insert //
CREATE TRIGGER trg_account_before_insert
BEFORE INSERT ON Account
FOR EACH ROW
BEGIN
    IF UPPER(NEW.Role) NOT IN ('CUSTOMER', 'ADMIN') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Vai trò (Role) chỉ được phép là Customer hoặc Admin.';
    END IF;
END //



DROP PROCEDURE IF EXISTS sp_get_revenue_by_date_range //
CREATE PROCEDURE sp_get_revenue_by_date_range(
    IN p_from DATE,
    IN p_to   DATE
)
BEGIN
    SELECT
        DATE(Created_at)  AS order_date,
        COUNT(*)          AS total_orders,
        SUM(Subtotal)     AS subtotal_sum,
        SUM(Shipping_fee) AS shipping_sum,
        SUM(Final_amount) AS revenue
    FROM Orders
    WHERE Created_at >= TIMESTAMP(p_from, '00:00:00')
      AND Created_at <  TIMESTAMP(DATE_ADD(p_to, INTERVAL 1 DAY), '00:00:00')
      AND Payment_status = 'PAID'
      AND Order_status <> 'CANCELLED'
    GROUP BY DATE(Created_at)
    ORDER BY order_date ASC;
END //

DROP PROCEDURE IF EXISTS sp_get_top_selling_products //
CREATE PROCEDURE sp_get_top_selling_products(
    IN p_limit INT
)
BEGIN
    DECLARE v_limit INT DEFAULT 10;
    IF p_limit IS NOT NULL AND p_limit > 0 THEN
        SET v_limit = p_limit;
    END IF;

    SELECT
        gp.Id                            AS group_product_id,
        gp.Name                          AS product_name,
        b.Name                           AS brand_name,
        c.Name                           AS category_name,
        SUM(od.Quantity)                 AS total_sold,
        SUM(od.Quantity * od.Unit_price) AS gross_sales
    FROM Other_detail od
    JOIN Orders o         ON o.Id = od.Orders_Id
    JOIN Products p       ON p.Id = od.Products_Id
    JOIN Group_Product gp ON gp.Id = p.Group_Product_Id
    JOIN Brand b          ON b.Id = gp.Brand_Id
    JOIN Categories c     ON c.Id = gp.Categories_Id
    WHERE o.Payment_status = 'PAID'
      AND o.Order_status <> 'CANCELLED'
    GROUP BY gp.Id, gp.Name, b.Name, c.Name
    ORDER BY total_sold DESC, gp.Id ASC
    LIMIT v_limit;
END //

DROP PROCEDURE IF EXISTS sp_get_low_stock_products //
CREATE PROCEDURE sp_get_low_stock_products(
    IN p_threshold INT
)
BEGIN
    SELECT
        p.Id    AS product_id,
        gp.Name AS group_name,
        c.Name  AS category_name,
        b.Name  AS brand_name,
        p.Price,
        p.Stock_quantity,
        p.Is_active
    FROM Products p
    JOIN Group_Product gp ON gp.Id = p.Group_Product_Id
    JOIN Categories c     ON c.Id = gp.Categories_Id
    JOIN Brand b          ON b.Id = gp.Brand_Id
    WHERE p.Stock_quantity < p_threshold
    ORDER BY p.Stock_quantity ASC, p.Id ASC;
END //

DROP PROCEDURE IF EXISTS sp_search_product_groups //
CREATE PROCEDURE sp_search_product_groups(
    IN p_category_id VARCHAR(36),
    IN p_brand_id    VARCHAR(36),
    IN p_min_price   DOUBLE,
    IN p_max_price   DOUBLE,
    IN p_keyword     VARCHAR(255),
    IN p_limit       INT,
    IN p_offset      INT
)
BEGIN
    DECLARE v_limit  INT DEFAULT 20;
    DECLARE v_offset INT DEFAULT 0;

    IF p_limit IS NOT NULL AND p_limit > 0 THEN
        SET v_limit = p_limit;
    END IF;
    IF p_offset IS NOT NULL AND p_offset >= 0 THEN
        SET v_offset = p_offset;
    END IF;

    SELECT
        gp.Id,
        gp.Name,
        gp.Description,
        gp.Categories_Id,
        gp.Brand_Id,
        MIN(p.Price) AS MinPrice
    FROM Group_Product gp
    LEFT JOIN Products p
        ON gp.Id = p.Group_Product_Id AND p.Is_active = 1
    WHERE (p_category_id IS NULL OR p_category_id = '' OR gp.Categories_Id = p_category_id)
      AND (p_brand_id IS NULL    OR p_brand_id = ''    OR gp.Brand_Id = p_brand_id)
      AND (p_keyword IS NULL     OR p_keyword = ''     OR gp.Name LIKE CONCAT('%', p_keyword, '%'))
    GROUP BY gp.Id, gp.Name, gp.Description, gp.Categories_Id, gp.Brand_Id
    HAVING (p_min_price IS NULL OR MIN(p.Price) >= p_min_price)
       AND (p_max_price IS NULL OR MIN(p.Price) <= p_max_price)
    ORDER BY gp.Id DESC
    LIMIT v_limit OFFSET v_offset;
END //

DROP PROCEDURE IF EXISTS sp_get_customer_order_history //
CREATE PROCEDURE sp_get_customer_order_history(
    IN p_customer_phone CHAR(10)
)
BEGIN
    SELECT
        o.Id                          AS order_id,
        o.Created_at,
        o.Order_status,
        o.Payment_status,
        o.Subtotal,
        o.Shipping_fee,
        o.Final_amount,
        COUNT(od.Id)                  AS line_items,
        COALESCE(SUM(od.Quantity), 0) AS total_items
    FROM Orders o
    LEFT JOIN Other_detail od ON od.Orders_Id = o.Id
    WHERE o.Customer_Phone_num = p_customer_phone
    GROUP BY
        o.Id, o.Created_at, o.Order_status, o.Payment_status,
        o.Subtotal, o.Shipping_fee, o.Final_amount
    ORDER BY o.Created_at DESC, o.Id DESC;
END //

DROP PROCEDURE IF EXISTS sp_restock_product_with_log //
CREATE PROCEDURE sp_restock_product_with_log(
    IN p_product_id  VARCHAR(36),
    IN p_added_qty   INT,
    IN p_admin_phone CHAR(10)
)
BEGIN
    DECLARE v_group_name VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_added_qty <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Số lượng nhập kho (p_added_qty) phải lớn hơn 0.';
    END IF;

    START TRANSACTION;

    SELECT gp.Name INTO v_group_name
    FROM Products p
    JOIN Group_Product gp ON gp.Id = p.Group_Product_Id
    WHERE p.Id = p_product_id
    FOR UPDATE;

    IF v_group_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Không tìm thấy biến thể sản phẩm cần nhập kho.';
    END IF;

    UPDATE Products
    SET Stock_quantity = Stock_quantity + p_added_qty
    WHERE Id = p_product_id;

    INSERT INTO Adjust (
        Admin_Phone_num,
        Type_adjust,
        Object_name_adjusted,
        Type_Object,
        Id_Object_Adjusted
    )
    VALUES (
        p_admin_phone,
        'RESTOCK',
        CONCAT(v_group_name, ' (+', p_added_qty, ')'),
        'Products',
        p_product_id
    );

    COMMIT;
END //

DELIMITER ;
