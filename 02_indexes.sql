CREATE INDEX idx_orders_customer_created
    ON Orders (Customer_Phone_num, Created_at DESC, Id DESC);

CREATE INDEX idx_orders_payment_status_created
    ON Orders (Payment_status, Order_status, Created_at);

CREATE INDEX idx_orders_status_created
    ON Orders (Order_status, Created_at DESC);

CREATE INDEX idx_products_group_active_price
    ON Products (Group_Product_Id, Is_active, Price);

CREATE INDEX idx_products_stock_quantity
    ON Products (Stock_quantity);

CREATE INDEX idx_group_product_cat_brand
    ON Group_Product (Categories_Id, Brand_Id);

CREATE INDEX idx_group_product_name
    ON Group_Product (Name);

CREATE INDEX idx_review_product_created_rating
    ON Review (Products_Id, Created_at DESC, Rating);

CREATE INDEX idx_images_product_ordinal
    ON Images (Products_Id, Ordinal_num, url);

CREATE INDEX idx_address_email_default
    ON Address (account_Email, Is_default, Ordinal_num);

CREATE INDEX idx_adjust_admin_created
    ON Adjust (Admin_Phone_num, Created_at DESC, Id DESC);

CREATE INDEX idx_adjust_created
    ON Adjust (Created_at DESC, Id DESC);

CREATE INDEX idx_other_detail_order_product
    ON Other_detail (Orders_Id, Products_Id, Quantity);

CREATE INDEX idx_attr_name_value
    ON Attribute_value (Name, Value);

CREATE INDEX idx_categories_name
    ON Categories (Name);

CREATE INDEX idx_brand_name
    ON Brand (Name);
