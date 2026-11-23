CREATE OR REPLACE VIEW vw_product_catalog AS
SELECT
    gp.Id                                           AS Group_Product_Id,
    gp.Name                                         AS Product_Name,
    gp.Description,
    c.Id                                            AS Category_Id,
    c.Name                                          AS Category_Name,
    b.Id                                            AS Brand_Id,
    b.Name                                          AS Brand_Name,
    COUNT(DISTINCT CASE WHEN p.Is_active = 1 THEN p.Id END) AS Active_Variant_Count,
    COALESCE(MIN(CASE WHEN p.Is_active = 1 THEN p.Price END), 0) AS Min_Price,
    COALESCE(MAX(CASE WHEN p.Is_active = 1 THEN p.Price END), 0) AS Max_Price,
    COALESCE(SUM(CASE WHEN p.Is_active = 1 THEN p.Stock_quantity ELSE 0 END), 0) AS Total_Active_Stock,
    COALESCE(ROUND(AVG(r.Rating), 2), 0)            AS Avg_Rating,
    COUNT(DISTINCT CONCAT(r.Customer_Phone_num, '|', r.Products_Id)) AS Review_Count
FROM Group_Product gp
JOIN Categories c       ON c.Id = gp.Categories_Id
JOIN Brand b            ON b.Id = gp.Brand_Id
LEFT JOIN Products p    ON p.Group_Product_Id = gp.Id
LEFT JOIN Review r      ON r.Products_Id = p.Id
GROUP BY gp.Id, gp.Name, gp.Description, c.Id, c.Name, b.Id, b.Name;

CREATE OR REPLACE VIEW vw_product_variant_details AS
SELECT
    p.Id                 AS Product_Id,
    gp.Id                AS Group_Product_Id,
    gp.Name              AS Group_Name,
    c.Name               AS Category_Name,
    b.Name               AS Brand_Name,
    p.Price,
    p.Stock_quantity,
    p.Is_active,
    GROUP_CONCAT(
        CONCAT(av.Name, ': ', av.Value)
        ORDER BY av.Name, av.Value
        SEPARATOR ' | '
    )                    AS Attributes
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
    p.Id       AS Product_Id,
    gp.Name    AS Group_Name,
    c.Name     AS Category_Name,
    b.Name     AS Brand_Name,
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
