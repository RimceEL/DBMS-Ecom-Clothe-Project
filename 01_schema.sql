CREATE DATABASE IF NOT EXISTS `ecom_clothe`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

USE `ecom_clothe`;

CREATE TABLE `Attribute_value` (
  `Id` varchar(36) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Value` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_attr_name_value` (`Name`,`Value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE TABLE `Brand` (
  `Id` varchar(36) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Logo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_brand_name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE TABLE `Categories` (
  `Id` varchar(36) NOT NULL,
  `Name` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_categories_name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE TABLE `User` (
  `Phone_num` char(10) NOT NULL,
  `Gender` tinyint(1) NOT NULL,
  PRIMARY KEY (`Phone_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE TABLE `Account` (
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



CREATE TABLE `Address` (
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



CREATE TABLE `Admin` (
  `Phone_num` char(10) NOT NULL,
  PRIMARY KEY (`Phone_num`),
  CONSTRAINT `fk|Admin|User` FOREIGN KEY (`Phone_num`) REFERENCES `User` (`Phone_num`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE TABLE `Customer` (
  `Phone_num` char(10) NOT NULL,
  PRIMARY KEY (`Phone_num`),
  CONSTRAINT `fk|Customer|User` FOREIGN KEY (`Phone_num`) REFERENCES `User` (`Phone_num`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE TABLE `Group_Product` (
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



CREATE TABLE `Orders` (
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



CREATE TABLE `Products` (
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



CREATE TABLE `Review` (
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



CREATE TABLE `Adjust` (
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



CREATE TABLE `Have` (
  `Attribute_value_Id` varchar(36) NOT NULL,
  `Products_Id` varchar(36) NOT NULL,
  PRIMARY KEY (`Attribute_value_Id`,`Products_Id`),
  KEY `fk|Have|Products` (`Products_Id`),
  KEY `fk|Have|Attribute_value` (`Attribute_value_Id`),
  CONSTRAINT `fk|Have|Attribute_value` FOREIGN KEY (`Attribute_value_Id`) REFERENCES `Attribute_value` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk|Have|Products` FOREIGN KEY (`Products_Id`) REFERENCES `Products` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE TABLE `Images` (
  `Name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `Ordinal_num` tinyint(1) NOT NULL,
  `Products_Id` varchar(36) NOT NULL,
  PRIMARY KEY (`Products_Id`,`Name`),
  KEY `idx_images_product_ordinal` (`Products_Id`,`Ordinal_num`,`url`),
  CONSTRAINT `fk|Images|Products` FOREIGN KEY (`Products_Id`) REFERENCES `Products` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE TABLE `Other_detail` (
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