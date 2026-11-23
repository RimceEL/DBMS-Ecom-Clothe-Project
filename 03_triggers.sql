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

DELIMITER ;
