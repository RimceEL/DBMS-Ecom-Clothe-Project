DELIMITER //

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
