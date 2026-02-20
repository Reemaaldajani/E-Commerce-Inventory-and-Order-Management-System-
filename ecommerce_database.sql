-- CREATE DATABASE IF NOT EXISTS `retail_system`;
-- USE `retail_system`;

-- 1. إنشاء الجداول (مرتبة حسب العلاقات)
CREATE TABLE IF NOT EXISTS Product (
    Product_ID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    Stock_Level INT NOT NULL,
    PRIMARY KEY (Product_ID)
);

CREATE TABLE IF NOT EXISTS Customer (
    Customer_ID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Contact VARCHAR(100),
    PRIMARY KEY (Customer_ID)
);

CREATE TABLE IF NOT EXISTS `Order` (
    Order_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Order_Date DATE,
    Status VARCHAR(50),
    PRIMARY KEY (Order_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

CREATE TABLE IF NOT EXISTS Order_Product (
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY (Order_ID) REFERENCES `Order`(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

CREATE TABLE IF NOT EXISTS ShippingDetails (
    Shipping_Tracking_Number INT NOT NULL,
    Order_ID INT NOT NULL,
    Status VARCHAR(50),
    Delivery_Date DATE,
    PRIMARY KEY (Shipping_Tracking_Number),
    FOREIGN KEY (Order_ID) REFERENCES `Order`(Order_ID)
);

-- 2. إدخال البيانات (تأكد من تشغيلها مرة واحدة لتجنب خطأ التكرار)
INSERT INTO Product VALUES
(1, 'Scented Candle', 'Handmade candle with a lavender smell.', 10.00, 0),
(2, 'Mini Candle', 'Small handmade candle with a hint of vanilla smell', 6.00, 300),
(3, 'Herbal Tea', 'Natural tea mix made from dried herbs and flowers.', 20.00, 70),
(4, 'Handmade Soap', 'Natural soap with olive oil and lavender.', 25.00, 0),
(5, 'Clay Mug', 'Handmade mug made from red clay.', 30.00, 250);

INSERT INTO Customer VALUES
(1, 'Rahaf', 'Rahaf11@gmail.com'),
(2, 'Sara', 'Ssaraa.45@hotmail.com'),
(3, 'Asayil', 'asayilB@gmail.com'),
(4, 'Reema', 'Reema7@yahoo.com'),
(5, 'lama', 'LLaam.12@gmail.com');

INSERT INTO `Order` VALUES
(1, 1, '2025-04-01', 'Delivered'),
(2, 2, '2025-04-03', 'In Progress'),
(3, 1, '2025-04-02', 'Cancelled'),
(4, 3, '2025-04-04', 'Pending'),
(5, 4, '2025-04-05', 'Returned'),
(6, 1, '2025-04-03', 'Out for Delivery'),
(7, 5, '2025-04-02', 'Delayed'),
(8, 3, '2025-04-08', 'Delivered'),
(9, 4, '2025-04-09', 'Delivered'),
(10, 3, '2025-04-10', 'In Progress'),
(11, 4, '2025-04-11', 'Pending'),
(12, 3, '2025-04-12', 'Delivered'),
(13, 3, '2025-04-13', 'Cancelled'),
(14, 1, '2025-04-14', 'Delivered'),
(15, 4, '2025-04-15', 'Delivered');

INSERT INTO Order_Product VALUES
(1, 2, 1, 25.00), (2, 3, 3, 35.00), (3, 2, 2, 25.00), (4, 4, 1, 60.00),
(5, 5, 4, 45.00), (6, 1, 1, 18.50), (7, 2, 5, 25.00), (8, 1, 1, 18.50),
(9, 2, 2, 25.00), (10, 3, 1, 20.00), (11, 4, 1, 60.00), (12, 5, 2, 30.00),
(13, 1, 2, 18.50), (14, 2, 1, 25.00), (15, 3, 2, 20.00);

INSERT INTO ShippingDetails VALUES
(201, 1, 'In Transit', '2025-04-15'), (202, 2, 'Delivered', '2025-04-14'),
(203, 3, 'Shipped', '2025-04-12'), (204, 4, 'Pending', NULL),
(205, 5, 'Returned', '2025-04-21'), (206, 6, 'Out for Delivery', '2025-04-14'),
(207, 7, 'Delivered', '2025-04-13'), (208, 8, 'Delivered', '2025-04-21'),
(209, 9, 'Returned', '2025-04-21'), (210, 10, 'Delivered', '2025-04-16'),
(211, 11, 'Delivered', '2025-04-13'), (212, 12, 'Delivered', '2025-04-14'),
(213, 13, 'Cancelled', NULL), (214, 14, 'Delivered', '2025-04-16'),
(215, 15, 'Delivered', '2025-04-17');

-- 3. الاستعلامات (يمكنك تشغيل كل واحد على حدة لرؤية النتائج)
-- تقرير إعادة التعبئة
SELECT * FROM Product WHERE Stock_Level = 0;

-- الأرباح لكل منتج
SELECT p.Product_ID, p.Name, SUM(op.Quantity * op.Price) AS Total_Sales
FROM Product p
JOIN Order_Product op ON p.Product_ID = op.Product_ID
GROUP BY p.Product_ID, p.Name;

-- العملاء المخلصون
SELECT c.Customer_ID, c.Name, COUNT(o.Order_ID) AS OrderCount
FROM Customer c
JOIN `Order` o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) > 3;

-- قيمة الأصول
SELECT SUM(Price * Stock_Level) AS Total_Inventory_Value FROM Product;

-- ملخص توصيل يوم 15-04
SELECT o.Order_ID, o.Customer_ID, o.Order_Date, o.Status,
       c.Name AS Customer_Name, c.Contact,
       s.Status AS Shipping_Status, s.Delivery_Date
FROM `Order` o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
LEFT JOIN ShippingDetails s ON o.Order_ID = s.Order_ID
WHERE o.Order_Date = '2025-04-15';
