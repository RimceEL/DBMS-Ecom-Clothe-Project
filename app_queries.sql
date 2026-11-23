-- ============================================================================
-- 1. AccountDAO.java (12 câu lệnh)
-- ============================================================================

-- [AccountDAO.findByEmail] Tìm tài khoản theo email (cũng được gọi bởi existsEmail)
SELECT * FROM Account WHERE email = ?;

-- [AccountDAO.existsPhone] Kiểm tra SĐT đã tồn tại trong bảng User chưa
SELECT * FROM User WHERE Phone_num = ?;

-- [AccountDAO.insertUser] Thêm người dùng mới
INSERT INTO User (Phone_num, Gender) VALUES (?, ?);

-- [AccountDAO.insertCustomer] Thêm vai trò Customer (sau khi đã insertUser)
INSERT INTO Customer (Phone_num) VALUES (?);

-- [AccountDAO.insertAdmin] Thêm vai trò Admin (sau khi đã insertUser)
INSERT INTO Admin (Phone_num) VALUES (?);

-- [AccountDAO.insertAccount] Thêm tài khoản mới
INSERT INTO Account (Email, Password, NickName, Role, Status, Phone_num)
VALUES (?, ?, ?, ?, ?, ?);

-- [AccountDAO.updatePassword] Cập nhật mật khẩu đã băm SHA-256 theo email
UPDATE Account SET Password = ? WHERE Email = ?;

-- [AccountDAO.updateNickName] Cập nhật nickname theo email
UPDATE Account SET NickName = ? WHERE Email = ?;

-- [AccountDAO.updateGender] Cập nhật giới tính trong bảng User theo SĐT
UPDATE User SET Gender = ? WHERE Phone_num = ?;

-- [AccountDAO.findUserByPhone] Lấy thông tin User theo SĐT
SELECT * FROM User WHERE Phone_num = ?;

-- [AccountDAO.findAll] Lấy toàn bộ tài khoản cho màn hình quản trị
SELECT Email, NickName, Role, Status FROM Account;

-- [AccountDAO.updateStatus] Khóa / mở khóa tài khoản theo email
UPDATE Account SET Status = ? WHERE Email = ?;


-- ============================================================================
-- 2. AddressDAO.java (8 câu lệnh)
-- ============================================================================

-- [AddressDAO.findByEmail] Lấy toàn bộ địa chỉ của một tài khoản theo thứ tự
SELECT Note, Street, District, City, Is_default, Ordinal_num, account_Email
FROM Address
WHERE account_Email = ?
ORDER BY Ordinal_num ASC;

-- [AddressDAO.findDefault] Lấy địa chỉ mặc định của tài khoản
SELECT Note, Street, District, City, Is_default, Ordinal_num, account_Email
FROM Address
WHERE account_Email = ? AND Is_default = 1
ORDER BY Ordinal_num ASC
LIMIT 1;

-- [AddressDAO.getNextOrdinal] Lấy số thứ tự tiếp theo cho địa chỉ mới
SELECT COALESCE(MAX(Ordinal_num), 0) + 1 AS Next
FROM Address
WHERE account_Email = ?;

-- [AddressDAO.insert] Thêm địa chỉ mới
INSERT INTO Address (Note, Street, District, City, Is_default, Ordinal_num, account_Email)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- [AddressDAO.update] Cập nhật thông tin địa chỉ theo khóa ghép
UPDATE Address
SET Note = ?, Street = ?, District = ?, City = ?
WHERE account_Email = ? AND Ordinal_num = ?;

-- [AddressDAO.delete] Xóa địa chỉ theo khóa ghép
DELETE FROM Address
WHERE account_Email = ? AND Ordinal_num = ?;

-- [AddressDAO.clearDefault] Bỏ cờ mặc định của tất cả địa chỉ thuộc tài khoản
UPDATE Address
SET Is_default = 0
WHERE account_Email = ?;

-- [AddressDAO.setDefault] Đặt một địa chỉ cụ thể làm mặc định
UPDATE Address
SET Is_default = 1
WHERE account_Email = ? AND Ordinal_num = ?;


-- ============================================================================
-- 3. AdjustDAO.java (3 câu lệnh)
-- ============================================================================

-- [AdjustDAO.insert] Ghi một dòng nhật ký thao tác của Admin
INSERT INTO Adjust (
    Admin_Phone_num,
    Type_adjust,
    Object_name_adjusted,
    Type_Object,
    Id_Object_Adjusted
)
VALUES (?, ?, ?, ?, ?);

-- [AdjustDAO.findAll] Lấy toàn bộ nhật ký, mới nhất trước
SELECT * FROM Adjust
ORDER BY Created_at DESC, Id DESC;

-- [AdjustDAO.filter] Lọc nhật ký động theo SĐT Admin và khoảng ngày [from, to)
-- (Các điều kiện AND được ghép động nếu tham số khác null/rỗng)
SELECT *
FROM Adjust
WHERE 1 = 1
  AND Admin_Phone_num = ?
  AND Created_at >= ?
  AND Created_at < ?
ORDER BY Created_at DESC, Id DESC;


-- ============================================================================
-- 4. CatalogDAO.java (12 câu lệnh: 6 Categories + 6 Brand)
-- ============================================================================

-- ----- Categories -----

-- [CatalogDAO.findAllCategories] Lấy tất cả danh mục
SELECT * FROM Categories;

-- [CatalogDAO.insertCategory] Thêm danh mục mới
INSERT INTO Categories (Id, Name) VALUES (?, ?);

-- [CatalogDAO.findCategoryById] Tìm danh mục theo Id
SELECT * FROM Categories WHERE Id = ?;

-- [CatalogDAO.findCategoryByName] Tìm danh mục theo tên (không phân biệt hoa thường)
SELECT * FROM Categories WHERE LOWER(Name) = LOWER(?) LIMIT 1;

-- [CatalogDAO.updateCategory] Cập nhật tên danh mục
UPDATE Categories SET Name = ? WHERE Id = ?;

-- [CatalogDAO.deleteCategory] Xóa danh mục theo Id
DELETE FROM Categories WHERE Id = ?;

-- ----- Brand -----

-- [CatalogDAO.findAllBrands] Lấy tất cả thương hiệu
SELECT * FROM Brand;

-- [CatalogDAO.findBrandById] Tìm thương hiệu theo Id
SELECT * FROM Brand WHERE Id = ?;

-- [CatalogDAO.findBrandByName] Tìm thương hiệu theo tên (không phân biệt hoa thường)
SELECT * FROM Brand WHERE LOWER(Name) = LOWER(?) LIMIT 1;

-- [CatalogDAO.insertBrand] Thêm thương hiệu mới
INSERT INTO Brand (Id, Name, Logo) VALUES (?, ?, ?);

-- [CatalogDAO.updateBrand] Cập nhật tên và logo thương hiệu
UPDATE Brand SET Name = ?, Logo = ? WHERE Id = ?;

-- [CatalogDAO.deleteBrand] Xóa thương hiệu theo Id
DELETE FROM Brand WHERE Id = ?;


-- ============================================================================
-- 5. OrderDAO.java (10 câu lệnh)
-- ============================================================================

-- [OrderDAO.insertOrder] Thêm đơn hàng mới (Final_amount là cột VIRTUAL tự tính)
INSERT INTO Orders (
    Id,
    Created_at,
    Order_status,
    Payment_status,
    Subtotal,
    Shipping_fee,
    Customer_Phone_num
)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- [OrderDAO.insertDetail] Thêm một dòng chi tiết đơn hàng
INSERT INTO Other_detail (
    Id,
    Quantity,
    Unit_price,
    Products_Id,
    Orders_Id
)
VALUES (?, ?, ?, ?, ?);

-- [OrderDAO.findById] Tìm đơn hàng theo Id
SELECT *
FROM Orders
WHERE Id = ?;

-- [OrderDAO.findByCustomer] Lấy danh sách đơn hàng của một khách theo SĐT
SELECT *
FROM Orders
WHERE Customer_phone_num = ?
ORDER BY Created_at DESC, Id DESC;

-- [OrderDAO.findDetailsByOrder] Lấy chi tiết đơn hàng theo Orders_Id (cả bản thường & transaction)
SELECT *
FROM Other_detail
WHERE Orders_Id = ?;

-- [OrderDAO.filter] Lọc đơn hàng động theo trạng thái đơn, trạng thái thanh toán và khoảng ngày
-- (Các điều kiện AND được ghép động nếu tham số khác null/rỗng)
SELECT *
FROM Orders
WHERE 1 = 1
  AND Order_status = ?
  AND Payment_status = ?
  AND Created_at >= ?
  AND Created_at < ?
ORDER BY Created_at DESC, Id DESC;

-- [OrderDAO.updateOrderStatus] Cập nhật trạng thái đơn hàng
UPDATE Orders
SET Order_status = ?
WHERE Id = ?;

-- [OrderDAO.updatePaymentStatus] Cập nhật trạng thái thanh toán
UPDATE Orders
SET Payment_status = ?
WHERE Id = ?;

-- [OrderDAO.findOrderStatus] Lấy trạng thái hiện tại của đơn hàng
SELECT Order_status
FROM Orders
WHERE Id = ?;

-- [OrderDAO.findOrderStatusForUpdate] Khóa dòng đơn hàng trong transaction (chống race condition)
SELECT Order_status
FROM Orders
WHERE Id = ?
FOR UPDATE;


-- ============================================================================
-- 6. ProductDAO.java (31 câu lệnh)
-- ============================================================================

-- ----- Group_Product -----

-- [ProductDAO.searchGroups] Tìm kiếm & lọc nhóm sản phẩm động (kèm phân trang & sắp xếp)
SELECT gp.Id, gp.Name, gp.Description, gp.Categories_Id, gp.Brand_Id, MIN(p.Price) AS MinPrice
FROM Group_Product gp
LEFT JOIN Products p ON gp.Id = p.Group_Product_Id AND p.Is_active = 1
WHERE 1 = 1
  AND gp.Categories_Id = ?
  AND gp.Brand_Id = ?
  AND gp.Name LIKE ?
GROUP BY gp.Id, gp.Name, gp.Description, gp.Categories_Id, gp.Brand_Id
HAVING MIN(p.Price) >= ?
   AND MIN(p.Price) <= ?
ORDER BY CASE WHEN MIN(p.Price) IS NULL THEN 1 ELSE 0 END, MinPrice ASC
LIMIT ? OFFSET ?;

-- [ProductDAO.findGroupById] Tìm nhóm sản phẩm theo Id
SELECT * FROM Group_Product WHERE Id = ?;

-- [ProductDAO.insertGroup] Thêm nhóm sản phẩm mới
INSERT INTO Group_Product (Id, Name, Description, Categories_Id, Brand_Id)
VALUES (?, ?, ?, ?, ?);

-- [ProductDAO.updateGroup] Cập nhật nhóm sản phẩm
UPDATE Group_Product
SET Name = ?, Description = ?, Categories_Id = ?, Brand_Id = ?
WHERE Id = ?;

-- [ProductDAO.deleteGroup] Xóa nhóm sản phẩm
DELETE FROM Group_Product WHERE Id = ?;

-- ----- Products (biến thể) -----

-- [ProductDAO.findVariantsByGroup] Lấy toàn bộ biến thể thuộc một nhóm sản phẩm
SELECT * FROM Products WHERE Group_Product_Id = ?;

-- [ProductDAO.findVariantById] Tìm biến thể sản phẩm theo Id
SELECT * FROM Products WHERE Id = ?;

-- [ProductDAO.findMinPrice] Lấy giá thấp nhất của biến thể đang bán trong nhóm
SELECT COALESCE(MIN(Price), 0) AS MinPrice
FROM Products
WHERE Group_Product_Id = ? AND Is_active = 1;

-- [ProductDAO.insertVariant] Thêm biến thể sản phẩm mới
INSERT INTO Products (Id, Price, Is_active, Stock_quantity, Group_Product_Id)
VALUES (?, ?, ?, ?, ?);

-- [ProductDAO.updateVariant] Cập nhật giá, trạng thái bán và tồn kho của biến thể
UPDATE Products
SET Price = ?, Is_active = ?, Stock_quantity = ?
WHERE Id = ?;

-- [ProductDAO.deleteVariant] Xóa biến thể sản phẩm
DELETE FROM Products WHERE Id = ?;

-- [ProductDAO.findLowStock] Tìm các biến thể có tồn kho dưới ngưỡng cảnh báo
SELECT * FROM Products
WHERE Stock_quantity < ?
ORDER BY Stock_quantity ASC;

-- [ProductDAO.decreaseStock] Trừ tồn kho an toàn khi đặt hàng (trong transaction)
UPDATE Products
SET Stock_quantity = Stock_quantity - ?
WHERE Id = ? AND Stock_quantity >= ? AND Is_active = 1;

-- [ProductDAO.increaseStock] Hoàn lại tồn kho khi hủy đơn (trong transaction)
UPDATE Products
SET Stock_quantity = Stock_quantity + ?
WHERE Id = ?;

-- ----- Attribute_value & Have -----

-- [ProductDAO.findAttributesByProduct] Lấy danh sách thuộc tính của một biến thể
SELECT av.Id, av.Name, av.Value
FROM Attribute_value av
INNER JOIN Have h ON av.Id = h.Attribute_value_Id
WHERE h.Products_Id = ?;

-- [ProductDAO.findAllAttributeValues] Lấy tất cả giá trị thuộc tính
SELECT Id, Name, Value
FROM Attribute_value
ORDER BY Name, Value;

-- [ProductDAO.findAttributeValue] Tìm giá trị thuộc tính theo Name + Value (không phân biệt hoa thường)
SELECT Id, Name, Value
FROM Attribute_value
WHERE LOWER(Name) = LOWER(?) AND LOWER(Value) = LOWER(?)
LIMIT 1;

-- [ProductDAO.countAttributeUsage] Đếm số biến thể đang sử dụng từng giá trị thuộc tính
SELECT Attribute_value_Id, COUNT(*) AS Total
FROM Have
GROUP BY Attribute_value_Id;

-- [ProductDAO.insertAttributeValue] Thêm giá trị thuộc tính mới
INSERT INTO Attribute_value (Id, Name, Value) VALUES (?, ?, ?);

-- [ProductDAO.updateAttributeValue] Cập nhật giá trị thuộc tính
UPDATE Attribute_value SET Name = ?, Value = ? WHERE Id = ?;

-- [ProductDAO.deleteAttributeValue] Xóa giá trị thuộc tính
DELETE FROM Attribute_value WHERE Id = ?;

-- [ProductDAO.linkAttribute] Gắn thuộc tính cho biến thể sản phẩm
INSERT INTO Have (Attribute_value_Id, Products_Id) VALUES (?, ?);

-- [ProductDAO.unlinkAttribute] Gỡ thuộc tính khỏi biến thể sản phẩm
DELETE FROM Have WHERE Attribute_value_Id = ? AND Products_Id = ?;

-- ----- Images -----

-- [ProductDAO.findImagesByProduct] Lấy ảnh của một biến thể theo thứ tự
SELECT * FROM Images
WHERE Products_Id = ?
ORDER BY Ordinal_num ASC;

-- [ProductDAO.findImagesByGroup] Lấy toàn bộ ảnh của một nhóm sản phẩm theo thứ tự
SELECT i.Name, i.url, i.Ordinal_num, i.Products_Id
FROM Images i
INNER JOIN Products p ON i.Products_Id = p.Id
WHERE p.Group_Product_Id = ?
ORDER BY i.Ordinal_num ASC;

-- [ProductDAO.insertImage] Thêm ảnh mới cho biến thể
INSERT INTO Images (Name, url, Ordinal_num, Products_Id) VALUES (?, ?, ?, ?);

-- [ProductDAO.updateImage] Cập nhật đường dẫn URL và thứ tự ảnh
UPDATE Images
SET url = ?, Ordinal_num = ?
WHERE Products_Id = ? AND Name = ?;

-- [ProductDAO.deleteImage] Xóa ảnh theo khóa ghép
DELETE FROM Images WHERE Products_Id = ? AND Name = ?;

-- ----- Truy vấn gộp cho thẻ sản phẩm (CardSummary) -----

-- [ProductDAO.findNewestCardSummaries] Lấy top nhóm sản phẩm mới nhất kèm giá thấp nhất
SELECT gp.Id, gp.Name, COALESCE(MIN(p.Price), 0) AS MinPrice
FROM Group_Product gp
LEFT JOIN Products p ON gp.Id = p.Group_Product_Id AND p.Is_active = 1
GROUP BY gp.Id, gp.Name
ORDER BY gp.Id DESC
LIMIT ?;

-- [ProductDAO.findMinPricesByGroups] Lấy giá thấp nhất theo danh sách Group_Product_Id (batch IN)
SELECT Group_Product_Id, COALESCE(MIN(Price), 0) AS MinPrice
FROM Products
WHERE Group_Product_Id IN (?, ?) AND Is_active = 1
GROUP BY Group_Product_Id;

-- [ProductDAO.findFirstImageUrlsByGroups] Lấy URL ảnh đầu tiên theo danh sách Group_Product_Id (batch IN)
SELECT p.Group_Product_Id, i.url
FROM Images i
INNER JOIN Products p ON i.Products_Id = p.Id
WHERE p.Group_Product_Id IN (?, ?)
ORDER BY i.Ordinal_num ASC;


-- ============================================================================
-- 7. ReviewDAO.java (9 câu lệnh)
-- ============================================================================

-- [ReviewDAO.insert] Thêm đánh giá mới
INSERT INTO Review (Customer_Phone_num, Products_Id, Created_at, Rating, Comment)
VALUES (?, ?, ?, ?, ?);

-- [ReviewDAO.update] Cập nhật điểm đánh giá và bình luận
UPDATE Review
SET Rating = ?, Comment = ?
WHERE Customer_Phone_num = ? AND Products_Id = ?;

-- [ReviewDAO.delete] Xóa đánh giá
DELETE FROM Review
WHERE Customer_Phone_num = ? AND Products_Id = ?;

-- [ReviewDAO.exists] Kiểm tra khách đã đánh giá biến thể này chưa
SELECT 1
FROM Review
WHERE Customer_Phone_num = ? AND Products_Id = ?;

-- [ReviewDAO.hasPurchased] Kiểm tra khách đã mua biến thể trong đơn hàng đạt trạng thái COMPLETED chưa
SELECT 1
FROM Orders o
INNER JOIN Other_detail od ON o.Id = od.Orders_Id
WHERE o.Customer_Phone_num = ?
  AND od.Products_Id = ?
  AND o.Order_status = ?;

-- [ReviewDAO.findByProduct] Lấy danh sách đánh giá của một biến thể, mới nhất trước
SELECT *
FROM Review
WHERE Products_Id = ?
ORDER BY Created_at DESC;

-- [ReviewDAO.findByGroup] Lấy danh sách đánh giá của cả nhóm sản phẩm, mới nhất trước
SELECT r.Customer_Phone_num, r.Products_Id, r.Created_at, r.Rating, r.Comment
FROM Review r
INNER JOIN Products p ON r.Products_Id = p.Id
WHERE p.Group_Product_Id = ?
ORDER BY r.Created_at DESC;

-- [ReviewDAO.getAverageRating] Điểm trung bình của một biến thể
SELECT COALESCE(AVG(Rating), 0) AS AvgRating
FROM Review
WHERE Products_Id = ?;

-- [ReviewDAO.getAverageRatingByGroup] Điểm trung bình của cả nhóm sản phẩm
SELECT COALESCE(AVG(r.Rating), 0) AS AvgRating
FROM Review r
INNER JOIN Products p ON r.Products_Id = p.Id
WHERE p.Group_Product_Id = ?;


-- ============================================================================
-- 8. StatisticDAO.java (5 câu lệnh)
-- ============================================================================

-- [StatisticDAO.revenueByDay] Doanh thu theo ngày trong khoảng [from, to]
SELECT
    DATE(Created_at)  AS order_date,
    COUNT(*)          AS total_orders,
    SUM(Final_amount) AS revenue
FROM Orders
WHERE Created_at >= ?
  AND Created_at <  ?
  AND Payment_status = 'PAID'
  AND Order_status  <> 'CANCELLED'
GROUP BY DATE(Created_at)
ORDER BY order_date;

-- [StatisticDAO.revenueByMonth] Doanh thu theo tháng trong một năm
SELECT
    MONTH(Created_at) AS month,
    COUNT(*)          AS total_orders,
    SUM(Final_amount) AS revenue
FROM Orders
WHERE Created_at >= ?
  AND Created_at <  ?
  AND Payment_status = 'PAID'
  AND Order_status  <> 'CANCELLED'
GROUP BY MONTH(Created_at)
ORDER BY month;

-- [StatisticDAO.revenueByYear] Doanh thu theo năm
SELECT
    YEAR(Created_at)  AS year,
    COUNT(*)          AS total_orders,
    SUM(Final_amount) AS revenue
FROM Orders
WHERE Payment_status = 'PAID'
  AND Order_status  <> 'CANCELLED'
GROUP BY YEAR(Created_at)
ORDER BY year;

-- [StatisticDAO.topSellingProducts] Top sản phẩm bán chạy (theo tổng Quantity)
SELECT
    gp.Name           AS product_name,
    SUM(od.Quantity)  AS total_sold
FROM Other_detail od
JOIN Orders        o  ON o.Id  = od.Orders_Id
JOIN Products      p  ON p.Id  = od.Products_Id
JOIN Group_Product gp ON gp.Id = p.Group_Product_Id
WHERE o.Payment_status = 'PAID'
  AND o.Order_status  <> 'CANCELLED'
GROUP BY gp.Id, gp.Name
ORDER BY total_sold DESC, gp.Id
LIMIT ?;

-- [StatisticDAO.orderCountByStatus] Thống kê số đơn hàng theo từng trạng thái
SELECT
    Order_status AS status,
    COUNT(*)     AS total_orders
FROM Orders
GROUP BY Order_status
ORDER BY total_orders DESC, Order_status;