USE `ecom_clothe`;
SET NAMES utf8mb4;

START TRANSACTION;


INSERT INTO `Categories` (`Id`, `Name`) VALUES
('cat-ao-thun',   'Áo thun'),
('cat-ao-so-mi',  'Áo sơ mi'),
('cat-quan-jean', 'Quần Jeans'),
('cat-ao-khoac',  'Áo khoác');

INSERT INTO `Brand` (`Id`, `Name`, `Logo`) VALUES
('br-kiki',   'KIKI Basic',  '/Users/rimceel/Pictures/kiki/brands/kiki-basic.png'),
('br-urban',  'KIKI Urban',  '/Users/rimceel/Pictures/kiki/brands/kiki-urban.png'),
('br-uniqlo', 'Uniqlo',      '/Users/rimceel/Pictures/kiki/brands/uniqlo.png');

INSERT INTO `Attribute_value` (`Id`, `Name`, `Value`) VALUES
('av-size-m',   'Size',      'M'),
('av-size-l',   'Size',      'L'),
('av-size-30',  'Size',      '30'),
('av-col-blk',  'Color',     'Đen'),
('av-col-wht',  'Color',     'Trắng'),
('av-col-nvy',  'Color',     'Xanh Navy'),
('av-col-blu',  'Color',     'Xanh Denim'),
('av-mat-cot',  'Material',  'Cotton 100%'),
('av-mat-den',  'Material',  'Denim co giãn');

INSERT INTO `User` (`Phone_num`, `Gender`) VALUES
('0901000001', 1),
('0902000002', 0),
('0912345678', 0),
('0987654321', 1),
('0933445566', 0);


INSERT INTO `Admin` (`Phone_num`) VALUES
('0901000001'),
('0902000002');

INSERT INTO `Customer` (`Phone_num`) VALUES
('0901000001'),
('0912345678'),
('0987654321'),
('0933445566');

INSERT INTO `Account` (`Email`, `NickName`, `Password`, `Role`, `Status`, `Phone_num`) VALUES
('admin.thien@kiki.vn', 'Thanh Thiện (Admin)', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'ADMIN',    1, '0901000001'),
('thien.buyer@gmail.com', 'Thiện Buyer',       'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'CUSTOMER', 1, '0901000001'),
('admin.phuong@kiki.vn','Minh Phương (Admin)', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'ADMIN',    1, '0902000002'),
('minhanh@gmail.com',   'Minh Anh',            '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'CUSTOMER', 1, '0912345678'),
('hoangnam@gmail.com',  'Hoàng Nam',           '6cf615d5bcaac778352a8f1f3360d23f02f34ec182e259897fd6ce485d7870d4', 'CUSTOMER', 1, '0987654321'),
('lanhuong@gmail.com',  'Lan Hương',           'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'CUSTOMER', 1, '0933445566');

INSERT INTO `Address` (`Note`, `Street`, `District`, `City`, `Is_default`, `Ordinal_num`, `account_Email`) VALUES
('Giao giờ hành chính', '97 Man Thiện',     'TP. Thủ Đức', 'TP. Hồ Chí Minh', 1, 1, 'minhanh@gmail.com'),
('Nhà riêng buổi tối',  '245 Lê Văn Việt',  'TP. Thủ Đức', 'TP. Hồ Chí Minh', 0, 2, 'minhanh@gmail.com'),
('Gọi trước khi giao',  '12 Nguyễn Trãi',   'Quận 1',      'TP. Hồ Chí Minh', 1, 1, 'hoangnam@gmail.com'),
('Quầy lễ tân tầng 1',  '88 Cách Mạng T8',  'Quận 3',      'TP. Hồ Chí Minh', 1, 1, 'lanhuong@gmail.com'),
('Giao cổng bảo vệ',    '11 Nguyễn Đình Chiểu','Quận 1',   'TP. Hồ Chí Minh', 1, 1, 'thien.buyer@gmail.com');


INSERT INTO `Group_Product` (`Id`, `Name`, `Description`, `Categories_Id`, `Brand_Id`) VALUES
('gp-001', 'Áo Thun Cotton Oversize KIKI', 'Form rộng thoáng mát, chất liệu cotton 250gsm dày dặn.', 'cat-ao-thun',   'br-kiki'),
('gp-002', 'Áo Sơ Mi Oxford Cổ Đức',       'Vải Oxford ít nhăn, phù hợp đi học và công sở.',       'cat-ao-so-mi',  'br-urban'),
('gp-003', 'Quần Jeans Slimfit Cổ Điển',    'Denim co giãn nhẹ, giữ form tốt khi vận động.',       'cat-quan-jean', 'br-uniqlo'),
('gp-004', 'Áo Khoác Dù Chống Nắng KIKI',   'Vải dù 2 lớp trượt nước, có mũ trùm tiện lợi.',      'cat-ao-khoac',  'br-kiki');

INSERT INTO `Products` (`Id`, `Price`, `Is_active`, `Stock_quantity`, `Group_Product_Id`) VALUES
('prod-001-m-blk',  249000, 1, 35, 'gp-001'),
('prod-001-l-wht',  259000, 1,  5, 'gp-001'),
('prod-002-m-nvy',  389000, 1, 18, 'gp-002'),
('prod-003-30-blu', 599000, 1, 20, 'gp-003'),
('prod-004-l-blk',  450000, 1, 12, 'gp-004'),
('prod-004-m-blk',  450000, 0,  0, 'gp-004');

INSERT INTO `Have` (`Attribute_value_Id`, `Products_Id`) VALUES
('av-size-m',  'prod-001-m-blk'),
('av-col-blk', 'prod-001-m-blk'),
('av-mat-cot', 'prod-001-m-blk'),

('av-size-l',  'prod-001-l-wht'),
('av-col-wht', 'prod-001-l-wht'),
('av-mat-cot', 'prod-001-l-wht'),

('av-size-m',  'prod-002-m-nvy'),
('av-col-nvy', 'prod-002-m-nvy'),

('av-size-30', 'prod-003-30-blu'),
('av-col-blu', 'prod-003-30-blu'),
('av-mat-den', 'prod-003-30-blu'),

('av-size-l',  'prod-004-l-blk'),
('av-col-blk', 'prod-004-l-blk');

INSERT INTO `Images` (`Name`, `url`, `Ordinal_num`, `Products_Id`) VALUES
('ao-thun-den-truoc.jpg',  '/Users/rimceel/Pictures/kiki/products/ao-thun-den-truoc.jpg',  1, 'prod-001-m-blk'),
('ao-thun-den-sau.jpg',    '/Users/rimceel/Pictures/kiki/products/ao-thun-den-sau.jpg',    2, 'prod-001-m-blk'),
('ao-thun-trang-1.jpg',    '/Users/rimceel/Pictures/kiki/products/ao-thun-trang-1.jpg',    1, 'prod-001-l-wht'),
('so-mi-navy-1.jpg',       '/Users/rimceel/Pictures/kiki/products/so-mi-navy-1.jpg',       1, 'prod-002-m-nvy'),
('quan-jean-xanh-1.jpg',   '/Users/rimceel/Pictures/kiki/products/quan-jean-xanh-1.jpg',   1, 'prod-003-30-blu'),
('quan-jean-xanh-2.jpg',   '/Users/rimceel/Pictures/kiki/products/quan-jean-xanh-2.jpg',   2, 'prod-003-30-blu'),
('ao-khoac-den-1.jpg',     '/Users/rimceel/Pictures/kiki/products/ao-khoac-den-1.jpg',     1, 'prod-004-l-blk');


INSERT INTO `Orders` (`Id`, `Created_at`, `Order_status`, `Payment_status`, `Subtotal`, `Shipping_fee`, `Customer_Phone_num`) VALUES
('ord-2026-0001', '2026-11-18 10:15:00', 'COMPLETED', 'PAID',   1097000, 30000, '0912345678'),
('ord-2026-0002', '2026-11-20 14:30:00', 'SHIPPING',  'PAID',    648000, 25000, '0987654321'),
('ord-2026-0003', '2026-11-22 09:05:00', 'PENDING',   'UNPAID',  747000,     0, '0933445566'),
('ord-2026-0004', '2026-11-23 19:40:00', 'COMPLETED', 'PAID',    450000, 30000, '0901000001'),
('ord-2026-0005', '2026-11-24 11:20:00', 'CANCELLED', 'UNPAID',  259000, 25000, '0912345678');

INSERT INTO `Other_detail` (`Id`, `Quantity`, `Unit_price`, `Products_Id`, `Orders_Id`) VALUES
('od-001', 2, 249000, 'prod-001-m-blk',  'ord-2026-0001'),
('od-002', 1, 599000, 'prod-003-30-blu', 'ord-2026-0001'),
('od-003', 1, 259000, 'prod-001-l-wht',  'ord-2026-0002'),
('od-004', 1, 389000, 'prod-002-m-nvy',  'ord-2026-0002'),
('od-005', 3, 249000, 'prod-001-m-blk',  'ord-2026-0003'),
('od-006', 1, 450000, 'prod-004-l-blk',  'ord-2026-0004'),
('od-007', 1, 259000, 'prod-001-l-wht',  'ord-2026-0005');

INSERT INTO `Review` (`Customer_Phone_num`, `Products_Id`, `Created_at`, `Rating`, `Comment`) VALUES
('0912345678', 'prod-001-m-blk',  '2026-11-19 20:10:00', 5, 'Vải cotton dày dặn, mặc mát và đúng form oversize.'),
('0912345678', 'prod-003-30-blu', '2026-11-19 20:15:00', 4, 'Quần co giãn thoải mái, màu denim đẹp như ảnh.'),
('0901000001', 'prod-004-l-blk',  '2026-11-24 08:30:00', 5, 'Áo khoác nhẹ, đường may chắc chắn.');

INSERT INTO `Adjust` (`Admin_Phone_num`, `Created_at`, `Type_adjust`, `Object_name_adjusted`, `Type_Object`, `Id_Object_Adjusted`) VALUES
('0901000001', '2026-11-15 08:00:00', 'CREATE',  'Áo Thun Cotton Oversize KIKI',        'Group_Product', 'gp-001'),
('0901000001', '2026-11-16 09:30:00', 'RESTOCK', 'Áo Thun Cotton Oversize KIKI (+35)',  'Products',      'prod-001-m-blk'),
('0902000002', '2026-11-17 15:45:00', 'UPDATE',  'Áo Khoác Dù Chống Nắng KIKI (Ngừng bán M)', 'Products', 'prod-004-m-blk');

COMMIT;