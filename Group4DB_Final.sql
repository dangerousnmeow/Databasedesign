--use master
--alter database Group4DB set single_user with rollback immediate
--drop database Group4DB

CREATE DATABASE Group4DB
use Group4DB

--Entities(Comprehensive DDL):
--STAGE1 ENTITIES
/*WebsiteCustomerAccount*/
CREATE TABLE [WebsiteCustomerAccount] (
  [CustomerID] int  NOT NULL,
  [CustomerEmailAddress] varchar(70) NOT NULL,
  [CustomerLastName] varchar(20),
  [EncryptedPassword] varbinary(300)  NOT NULL,
  CONSTRAINT [prim_wca] PRIMARY KEY ([CustomerID]),
  CONSTRAINT [check_id_wca] CHECK ([CustomerID]>(0))
)  


/*ShippingRecord*/
CREATE TABLE [ShippingRecord] (
  [TrackingNumber] int  NOT NULL,
  [ShippingMethod] varchar(20) NOT NULL,
  [PackageWeight] decimal(10,2),
  [ShippingName] varchar(25),
  [Street] varchar(50),
  [City] varchar(50),
  [State] varchar(50),
  [Zipcode] varchar(50),
  [ShippingDate] date,
  CONSTRAINT [prim_sp] PRIMARY KEY ([TrackingNumber]),
  CONSTRAINT [check_id_sr] CHECK ([TrackingNumber]>(0))
)  


/*EmployeeInfo*/
CREATE TABLE [EmployeeInfo] (
  [EmployeeID] int  NOT NULL,
  [EmployeeFirstName] varchar(25) NOT NULL,
  [EmployeeMiddleName] varchar(15) NULL,
  [EmployeeLastName] varchar(25) NOT NULL,
  [PhoneNumber] varchar(30),
  [SickDays] tinyint,
  [VacationDays] tinyint,
  [JoininDate] date  NOT NULL,
  [Designation_LeaveDate] date,
  [EmployeeTitle] varchar(30) NOT NULL,
  [EmployeeEmailAddress] varchar(70),
  [ManagerID] int,
  [EmployeeChecking_SavingAccountNumber] int,
  [EncryptedSSN] varbinary(250)  NOT NULL,
  CONSTRAINT [prim_ei] PRIMARY KEY ([EmployeeID]),
  CONSTRAINT [check_id_ei] CHECK ([EmployeeID]>(0))
)  


/*Product*/
CREATE TABLE [Product] (
  [ProductID] int  NOT NULL,
  [ProductName] varchar(50) NOT NULL,
  [ProductColor] varchar(30),
  [ProductMaterial] varchar(30),
  [ProductPrice] decimal(10,2),
  [ProductImage] image,
  [WebsiteLink] ntext,
  CONSTRAINT [prim_product] PRIMARY KEY ([ProductID]),
  CONSTRAINT [check_id_product] CHECK ([ProductID]>(0))
)  


/*Supplies*/
CREATE TABLE [Supplies] (
  [SupplierID] int  NOT NULL,
  [SupplierName] varchar(50) NOT NULL,
  [SupplierStreetAddress] varchar(70),
  [SupplierCity] varchar(50),
  [SupplierState] varchar(50),
  [SupplierZipcode] varchar(50),
  [SupplierContactInfo] varchar(70),
  CONSTRAINT [prim_supplies] PRIMARY KEY ([SupplierID]),
  CONSTRAINT [check_id_sup] CHECK ([SupplierID]>(0))
)  


--STAGE2 ENTITIES
/*SuppliesProductDetail*/
CREATE TABLE [SuppliesProductDetail] (
  [SuppliesProductID] int  NOT NULL,
  [SupplierID] int  NOT NULL,
  [ProductID] int  NOT NULL,
  [SupplyDate] date  NOT NULL,
  CONSTRAINT [prim_spd] PRIMARY KEY ([SuppliesProductID]),
  CONSTRAINT [foreign_spd_1] FOREIGN KEY ([SupplierID]) REFERENCES [Supplies] ([SupplierID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [foreign_spd_2] FOREIGN KEY ([ProductID]) REFERENCES [Product] ([ProductID]) ON DELETE NO ACTION ON UPDATE NO ACTION
)  


/*EmployeeReimbursement*/
CREATE TABLE [EmployeeReimbursement] (
  [ReimbursementID] int  NOT NULL,
  [EmployeeID] int  NOT NULL,
  [ReimbursementDescription] varchar(70),
  [Price] decimal(8,2),
  [ReceiptInfo] varchar(50),
  [DateforReceipt] date  NULL,
  [DepositDate] date  NULL,
  CONSTRAINT [prim_er] PRIMARY KEY ([ReimbursementID]),
  CONSTRAINT [foreign_er_1] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeeInfo] ([EmployeeID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [check_id_er] CHECK ([ReimbursementID]>(0))
)  



/*Warehouse*/
CREATE TABLE [Warehouse] (
  [WarehouseID] int  NOT NULL,
  [EmployeeID] int  NOT NULL,
  [StreetAddress] varchar(70),
  [City] varchar(50),
  [State] varchar(50),
  [Zipcode] varchar(50),
  CONSTRAINT [prim_warehouse] PRIMARY KEY ([WarehouseID]),
  CONSTRAINT [foreign_warehouse_1] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeeInfo] ([EmployeeID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [check_id_warehouse] CHECK ([WarehouseID]>(0))
)  


/*WarehouseProduct*/
CREATE TABLE [WarehouseProduct] (
  [WarehouseID] int  NOT NULL,
  [ProductID] int  NOT NULL,
  [ProductQuantity] int  NULL,
  [ProductName ] varchar(50),
  CONSTRAINT [prim_wp_1] PRIMARY KEY ([WarehouseID], [ProductID]),
  CONSTRAINT [foreign_wp_1] FOREIGN KEY ([WarehouseID]) REFERENCES [Warehouse] ([WarehouseID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [foreign_wp_2] FOREIGN KEY ([ProductID]) REFERENCES [Product] ([ProductID]) ON DELETE NO ACTION ON UPDATE NO ACTION
)  



/*EmployeeSalary*/
CREATE TABLE [EmployeeSalary] (
  [EmployeeSalaryID] int  NOT NULL,
  [EmployeeID] int  NOT NULL,
  [BaseSalary] decimal(10,2),
  [Bonus] decimal(8,2),
  [TotalSalary] decimal(10,2),
  CONSTRAINT [prim_es] PRIMARY KEY ([EmployeeSalaryID]),
  CONSTRAINT [foreign_es_1] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeeInfo] ([EmployeeID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [check_id_es] CHECK ([EmployeeSalaryID]>(0))
)  


/*Revenue*/
CREATE TABLE [Revenue] (
  [RevenueID] int  NOT NULL,
  [EmployeeSalaryID] int  NOT NULL,
  [Tax] decimal(12,2),
  [TotalRevenue] decimal(12,2),
  [Date] date,
  CONSTRAINT [prim_revenue] PRIMARY KEY ([RevenueID]),
  CONSTRAINT [foreign_revenue_1] FOREIGN KEY ([EmployeeSalaryID]) REFERENCES [EmployeeSalary] ([EmployeeSalaryID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [check_id_revenue] CHECK ([RevenueID]>(0))
)  



/*CustomerOrder*/
CREATE TABLE [CustomerOrder] (
  [OrderID] int  NOT NULL,
  [CustomerID] int  NOT NULL,
  [RevenueID] int  NOT NULL,
  [BillingStreetAddress] varchar(70),
  [BillingAddressCity] varchar(50),
  [BillingAddressState] varchar(50),
  [BillingAddressZipcode] varchar(50),
  [ShippingStreetAddress] varchar(50),
  [ShippingAddressCity] varchar(50),
  [ShippingAddressState] varchar(50),
  [ShippingAddressZipcode] varchar(50),
  [TrackingNumber] int  NOT NULL,
  [TotalPrice] decimal(12,2)  NOT NULL,
  [ShippingMethods] varchar(50),
  [OrderDate] date  NOT NULL,
  CONSTRAINT [prim_co] PRIMARY KEY ([OrderID]),
  CONSTRAINT [foreign_co_1] FOREIGN KEY ([CustomerID]) REFERENCES [WebsiteCustomerAccount] ([CustomerID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [foreign_co_2] FOREIGN KEY ([RevenueID]) REFERENCES [Revenue] ([RevenueID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [check_id] CHECK ([OrderID]>(0))
)  



/*EmployeeDirectDeposit*/
CREATE TABLE [EmployeeDirectDeposit] (
  [EmployeeID] int  NOT NULL,
  [DepositDate] date  NOT NULL,
  [DepositAmount] decimal(8,2),
  CONSTRAINT [prim_pdd] PRIMARY KEY  ([EmployeeID], [DepositDate]),
  CONSTRAINT [check_id_edd] CHECK ([EmployeeID]>(0)),
  CONSTRAINT [check_depositamount] CHECK ([DepositAmount]>(1000) AND [DepositAmount]<(100000))
)  



--STAGE3 ENTITIES
/*OrderDetail*/
CREATE TABLE [OrderDetail] (
  [OrderDetailID] int  NOT NULL,
  [OrderID] int  NOT NULL,
  [ProductID] int  NOT NULL,
  [WarehouseID] int  NOT NULL,
  [Quantity] int,
  CONSTRAINT [prim_od] PRIMARY KEY ([OrderDetailID]),
  CONSTRAINT [foreign_od_1] FOREIGN KEY ([OrderID]) REFERENCES [CustomerOrder] ([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [foreign_od_2] FOREIGN KEY ([WarehouseID], [ProductID]) REFERENCES [WarehouseProduct] ([WarehouseID], [ProductID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [check_id_od] CHECK ([OrderDetailID]>(0))
)  



/*Return*/
CREATE TABLE [Return] (
  [ReturnID] int  NOT NULL,
  [OrderID] int  NOT NULL,
  [ProductID] int  NOT NULL,
  [WarehouseID] int  NOT NULL,
  [ReturnDate] date  NOT NULL,
  [ReturnQuantity] int  NOT NULL,
  CONSTRAINT [prim_return] PRIMARY KEY ([ReturnID]),
  CONSTRAINT [foreign_return_1] FOREIGN KEY ([OrderID]) REFERENCES [CustomerOrder] ([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [foreign_return_2] FOREIGN KEY ([WarehouseID], [ProductID]) REFERENCES [WarehouseProduct] ([WarehouseID], [ProductID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
)  



/*ShippingTask*/
CREATE TABLE [ShippingTask] (
  [TaskID] int  NOT NULL,
  [OrderID] int  NOT NULL,
  [EmployeeID] int  NOT NULL,
  [TrackingNumber] int  NOT NULL,
  [ShippingDate] date,
  CONSTRAINT [prim_st] PRIMARY KEY ([TaskID]),
  CONSTRAINT [foreign_st_1] FOREIGN KEY ([OrderID]) REFERENCES [CustomerOrder] ([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [foreign_st_2] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeeInfo] ([EmployeeID]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [foreign_st_3] FOREIGN KEY ([TrackingNumber]) REFERENCES [ShippingRecord] ([TrackingNumber]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [check_id_st] CHECK ([TaskID]>(0))
)  


--SQL codes for Data Encryption, Table-Level Constraint, Computed Columns, Creating Views:
-- Data Encryption 
-- Data Encryption Example

CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'Group4_P@ssword';

--Create certificate to protect symmetric key
CREATE CERTIFICATE group4Certificate
WITH Subject = 'group4Certificate',
EXPIRY_DATE = '2025-04-01';

--Create symmetric key to encrypt data
CREATE SYMMETRIC KEY group4Symmetrickey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE group4Certificate;

--Open symmetric key, data insertion will show in the following stage 
OPEN SYMMETRIC KEY group4Symmetrickey
DECRYPTION BY CERTIFICATE group4Certificate;

GO

--Table-Level ConstraintS
---no more than 5 return 1 month function
CREATE FUNCTION num_return_1m
(@cid int)
RETURNS int
AS
BEGIN
	DECLARE @count int = 0
	
	SELECT @count = num 
	FROM(
	SELECT TOP 1 COUNT(ReturnID) AS num
	FROM(
	SELECT r.ReturnID, r.OrderID, MONTH(r.ReturnDate) [month], c.CustomerID
	FROM Group4DB.dbo.[Return] r 
	LEFT JOIN Group4DB.dbo.CustomerOrder c
	ON r.OrderID = c.OrderID) t 
	GROUP BY [month], CustomerID 
	HAVING CustomerID = @cid
	ORDER BY COUNT(ReturnID) DESC) a 
	
	RETURN @count
END
;
GO

--DROP FUNCTION num_return_1m;
--ALTER TABLE Group4DB.dbo.CustomerOrder drop CONSTRAINT BanMuchReturn;


--add constraint
ALTER TABLE Group4DB.dbo.CustomerOrder ADD CONSTRAINT BanMuchReturn CHECK
(dbo.num_return_1m(CustomerID) < 5) ;


GO
----no more than 30 days to return function
CREATE FUNCTION interval_r_o(@rid int)
RETURNS int
AS
BEGIN
	DECLARE @days int = 0
	
	SELECT @days = DATEDIFF(d, ShippingDate, ReturnDate) 
	FROM(
 	SELECT r.ReturnID, r.OrderID, r.ReturnDate, t.ShippingDate
	FROM Group4DB.dbo.[Return] r 
	LEFT JOIN Group4DB.dbo.ShippingTask t
	ON r.OrderID = t.OrderID) a 
	WHERE ReturnID = @rid

	RETURN @days
END
;
GO

ALTER TABLE Group4DB.dbo.[Return] ADD CONSTRAINT BanLongDayReturn_ CHECK
(dbo.interval_r_o(ReturnID) < 30);

----Add salary range constraint
ALTER TABLE Group4DB.dbo.EmployeeSalary ADD CONSTRAINT Salaryrange CHECK
(TotalSalary>1000 AND TotalSalary<100000);
GO


--Computed Columns 

--Function to get total salary from basesalary + bonus + reimbursement
CREATE FUNCTION GetTotalSalary(@EmploID INT, @EmploID2 INT)
RETURNS Decimal(10,2)
AS 
BEGIN 
	DECLARE @TotalSalary Decimal(10,2)
	SELECT  @TotalSalary = (es.BaseSalary + es.Bonus + er.Price)
	        FROM Group4DB.dbo.EmployeeReimbursement er
	        JOIN Group4DB.dbo.EmployeeSalary es
	        ON er.EmployeeID = es.EmployeeID 
	        WHERE er.EmployeeID = @EmploID 
	        AND es.EmployeeID = @EmploID2
    RETURN @TotalSalary
END;
GO

--Creating Views Example

--view1--
--This view shows details of orders 
--such as product...
--DROP VIEW
--DROP VIEW vwOrderDetail;

CREATE VIEW vwOrderDetail 
AS 
SELECT co.OrderID,co.OrderDate,co.TotalPrice,co.TrackingNumber,temp.ProductID,temp.[ProductName ]
From dbo.CustomerOrder co
Join 
(SELECT od.OrderID,od.OrderDetailID,wp.ProductID,wp.[ProductName ]
From dbo.[OrderDetail ] od
Join dbo.WarehouseProduct wp
On od.ProductID=wp.ProductID
) temp
On co.OrderID = temp.OrderID;

GO

--test
--SELECT * FROM vwEmployeeSalaryDetail;

--view2--
--This view show employee salary information 

CREATE VIEW vwEmployeeSalaryDetail AS SELECT einfo.EmployeeID,einfo.EmployeeLastName,einfo.EmployeeFirstName,temp.BaseSalary,temp.Bonus,
temp.Tax,temp1.ReimbursementID,temp1.ReceiptInfo,temp1.Price,temp2.DepositAmount

From dbo.EmployeeInfo einfo
JOIN
 (Select esalary.EmployeeID,esalary.EmployeeSalaryID, er.RevenueID,er.TotalRevenue,er.Tax,esalary.BaseSalary,esalary.Bonus,esalary.TotalSalary
 From dbo.EmployeeSalary esalary
	JOIN dbo.Revenue er
	ON er.EmployeeSalaryID=esalary.EmployeeSalaryID
 )temp
 ON temp.EmployeeID=einfo.EmployeeID
JOIN
(Select *
FROM dbo.EmployeeReimbursement ereimbusrsement)temp1
ON temp1.EmployeeID=einfo.EmployeeID
JOIN
(SELECT *
FROM dbo.EmployeeDirectDeposit edd)temp2
ON temp2.EmployeeID=einfo.EmployeeID
GO


--Codes for Inserting Data:

USE Group4DB
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('1',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'PassTs1')),'rb@gmail.com','Bai')
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('2',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'LIJDHKjosg02')),'rjlsgji@gmail.com','Wilson')
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('3',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'Pdjglsd2344')),'unok@outlook.com','Uno')
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('4',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'Mjohn22')),'Mjohn@gmail.com','Mayer')
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('5',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'MersSaku998')),'Sakullepmu@mers.com','Sakuso')
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('6',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'SummerisFun11')),'LeeLevis@gmail.com','Levis')
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('7',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'Sarahpaww')),'Ssarah@gmail.com','Sarah')
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('8',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'Misapingal')),'hpignmisa@gmail.com','Misa')
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('9',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'DJGPksjgi223')),'Brandonk@gmail.com','Kong')
INSERT INTO WebsiteCustomerAccount
(
    CustomerID, EncryptedPassword,CustomerEmailAddress,CustomerLastName
)
VALUES 
('10',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'Timspsw0782')),'Timkill@gmail.com','Killingback')
--test
--SELECT CustomerID, CONVERT(VARCHAR,DECRYPTBYKEY(EncryptedPassword)) FROM WebsiteCustomerAccount


--Insert Date for ShippingRecord

INSERT INTO Group4DB.dbo.ShippingRecord(TrackingNumber, ShippingMethod, PackageWeight, ShippingName, Street,
City, State, Zipcode, ShippingDate)
VALUES 
(9001, 'Priority', '12.40', 'UPS', '140 N Main St', 'Phoenix', 'AZ', 85258, '2021-01-26'), 
(9002, 'Express', '10.40', 'UPS', '138 W Courier Pl', 'Hanover', 'NH', 05258, '2021-01-10'),
(9003, 'Priority', '5.63', 'UPS', '8956 Via Linda', 'Peoria', 'AZ', 85258, '2021-03-26'),
(9004, 'Priority', '8.45', 'UPS', '36 Jolly St', 'Boston', 'MA', 02119, '2021-01-31'),
(9005, 'Standard', '12.41', 'UPS', '89 N Centre St', 'Andover', 'MA', 02116, '2021-03-04'),
(9006, 'Standard', '6.50', 'UPS', '768 Happy Pl', 'San Jose', 'CA', 61789, '2021-02-10'),
(9007, 'Priority', '7.89', 'UPS', '67 Dartmouth Ave', 'Boston', 'MA', 01189, '2021-01-26'),
(9008, 'Express', '1.44', 'UPS', '140 N Main St', 'Scottsdale', 'AZ', 85258, '2021-01-26'),
(9009, 'Standard', '2.50', 'UPS', '123 Centre St', 'Avondale', 'AZ', 83268, '2021-01-03'),
(9010, 'Express', '5.00', 'UPS', '73 Huntington Ave', 'Boston', 'MA', 02116, '2021-03-01');


--Insert Data for Employee Info
INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2346','Sarah','','Minh','9808976678','0','10','2020-03-01','','director',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'388984857')),'sarah@groupcompany.com','','2030999837')

INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2347','Lee','','VAN','9809887354','0','9','2020-04-10','','scientist',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'876789378')),'Lee@groupcompany.com','2346','293864902')

INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2348','Misa','','Cup','9808987654','0','10','2020-03-15','','principle scientist',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'879876543')),'Cup@groupcompany.com','2346','2030990876')
INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2349','Santa','','Claus','8769872736','0','10','2020-05-10','','associate scientist',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'9876789932')),'Santalove@groupcompany.com','2347','203847565')
INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2350','Donovan','H','Wilson','9872634409','0','10','2020-03-10','','HR',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'987667892')),'Donovan@gmail.com','2347','828465967')
INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2351','Yan','','Nyugen','8376509875','1','15','2021-01-01','','Techinician',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'987654827')),'Nygn@groupcompany.com','2350','837465678')
INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2352','Lee','','Vanderbilt','8376789932','2','15','2020-10-05','','Technician',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'987477532')),'Vanderbilt@gmail.com','2350','209984756')
INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2353','Cece','','Cox','7587689932','0','10','2020-03-12','','Intern',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'987654293')),'cece@gmail.com','2351','98763845')
INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2354','Kiang','','Fed','8759309882','0','10','2020-03-01','','Intern',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'864523456')),'kiang@groupcompany.com','2351','345676')
INSERT INTO EmployeeInfo
(
    EmployeeID,EmployeeFirstName,EmployeeMiddleName,EmployeeLastName,PhoneNumber,SickDays,VacationDays,JoininDate,Designation_LeaveDate,
    EmployeeTitle,EncryptedSSN,EmployeeEmailAddress,ManagerID,EmployeeChecking_SavingAccountNumber
)
VALUES 
('2355','Mimi','','Uno','2734998753','0','5','2020-03-30','','Financial Assitant',EncryptByKey(key_GUID(N'group4Symmetrickey'),CONVERT(VARBINARY,'283769381')),'mimi@groupcompany.com','2351','743684')


--Insert Data for Product

INSERT INTO Group4DB.dbo.Product(ProductID, ProductName, ProductColor, ProductMaterial , ProductPrice , ProductImage , WebsiteLink)
VALUES 
(111, 'Water Bottle', 'Blue', 'Metal', 4.99,'', 'https://thatsthefinger.com'),
(222, 'Frying Pan', 'Black', 'Stainless Steel', 26,'', 'http://eelslap.com'),
(333, 'Backpack', 'Brown', 'Leather', 62,'', 'https://longdogechallenge.com'),
(444, 'Coffee Cup', 'White', 'Ceramic', 10.99,'', 'https://heeeeeeeey.com'),
(555, 'Coffee Cup', 'Red', 'Ceramic', 12.99,'', 'https://hooooooooo.com'),
(666, 'Plushie', 'Red', 'Cotton', 6.66,'', 'https://cant-not-tweet-this.com'),
(777, 'Chair', 'White', 'Leather', 120,'', 'https://smashthewalls.com'),
(888, 'Table', 'Black', 'Wood', 150.60,'', 'https://puginarug.com'),
(999, 'Plant Pot', 'Red', 'Clay', 10,'', 'https://jacksonpollock.org'),
(112, 'Laundry Bag', 'Pink', 'Cotton', 15,'', 'http://beesbeesbees.com');

--Insert Data Supplies

INSERT INTO Group4DB.dbo.Supplies(SupplierID, SupplierName, SupplierStreetAddress, SupplierCity, SupplierState, SupplierZipcode, SupplierContactInfo)
VALUES 
(2001, 'HydateMe Inc', '950 W Arlington St', 'Spokane', 'WA', 31276, '956-432-9901'),
(2002, 'CoffeeBean .Co', '43 E West Side', 'Seattle', 'WA', 31216, '956-234-9901'),
(2003, 'LeafyGreens', '53 Penchant Dr', 'Indianapolis', 'IN', 52493, '694-432-8534'),
(2004, 'UniDell', '43 Airport Blvd', 'Chicago', 'IL', 28650, '450-432-6930'),
(2005, 'LiveLaughLove Manufacturers', '34 N Northsight Blvd', 'Scottsdale', 'AZ', 85258, '866-001-8808'),
(2006, 'Bikers Inc', '67 W Killington Ln', 'Spokane', 'WA', 31276, '956-111-2020'),
(2007, 'Rotormolla', '1 Paul Revere Ave', 'Waltham', 'MA', 23100, '617-666-7777'),
(2008, 'Orange Inc', '55 Islander St', 'Honolulu', 'HI', 96701, '525-500-5901'),
(2009, 'Sungsam Pvt Ltd', '201 Via Linda', 'Alburqurque', 'NM', 87001, '386-432-9109'),
(2010, 'Doors-98-XP', '84 Grenade Ln', 'West Lebanon', 'NH', 31002, '159-480-5737');

--Insert Data SuupliesProductDetail

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('101','2001','111','2021-04-04')

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('102','2002','112','2021-04-04')

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('103','2003','222','2021-04-01')

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('104','2004','333','2021-03-20')

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('105','2005','444','2021-03-10')

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('106','2006','555','2021-03-22')

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('107','2007','666','2021-03-20')

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('108','2008','777','2020-02-01')

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('109','2009','888','2020-02-10')

INSERT INTO SuppliesProductDetail
(
    SuppliesProductID,
    SupplierID,
    ProductID,
    SupplyDate
)
VALUES
('110','2010','999','2020-02-28')


--Insert Data EmployeeReimbursement

INSERT INTO Group4DB.dbo.EmployeeReimbursement(ReimbursementID, EmployeeID, ReimbursementDescription, Price, ReceiptInfo, DateforReceipt, DepositDate)
VALUES 
(6700, 2346, 'Travel', 693.5, 'Flight Ticket', '2021-01-01', '2021-01-31'),
(6701, 2347, 'Food', 50, 'Meal Receipts', '2021-01-01', '2021-01-31'),
(6702, 2348, 'Lodging', 1500, 'Hotel Receipt', '2021-01-10', '2021-02-10'),
(6703, 2349, 'Food', 76.99, 'Meal Receipts', '2021-02-21', '2021-02-28'),
(6704, 2350, 'Food', 36.50, 'Meal Receipts', '2021-02-05', '2021-03-01'),
(6705, 2351, 'Travel', 38.30, 'Gas Receipts', '2021-01-31', '2021-02-15'),
(6706, 2352, 'Lodging', 300, 'AirBnB Receipt', '2021-02-01', '2021-03-31'),
(6707, 2353, 'Travel', 604.5, 'Flight Ticket', '2021-02-22', '2021-03-21'),
(6708, 2354, 'Food', 37.80, 'Meal Receipts', '2021-03-21', '2021-04-01'),
(6709, 2355, 'Travel', 231.69, 'Train Tickets', '2021-01-15', '2021-02-26');

--Insert Data for Warehouse
INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1001','2346','1 Arlington Dr','Medford','MA','02111')
INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1002','2347','10 Ocean Blvd','Burlington','MA','02123')
INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1003','2348','22 University Pl','Edmond','OK','43502')

INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1004','2347','3 Pleasant St','Revere','MA','02987')
INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1005','2348','12 Wheale Rd','Rockport','MA','02119')
INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1006','2349','3 Foxrun Rd','Hamilton','MA','02166')
INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1007','2350','9 Washinton St apt822','Quincy','MA','02145')
INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1008','2351','19 Holy Ave','Braintree','MA','02181')
INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1009','2352','3 Nowa T Blvd','Dorchester','MA','02125')
INSERT INTO Warehouse 
(
    WarehouseID,
    EmployeeID,
    StreetAddress,
    City,
    State,
    Zipcode
)
VALUES
('1010','2353','100 Williams Blvd','South Boston','MA','02121')

--Insert data for WarehouseProduct
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1001','111',10,'Water Bottle')
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1002','112',15,'Laundry Bag')
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1003','222',19,'Frying Pan')
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1004','333',3,'Backpack')
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1005','444',5,'Coffee Cup')
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1006','555',7,'Coffee Cup')
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1007','666',9,'Plushie')
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1008','777',9,'Chair')
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1009','888',11,'Table')
INSERT INTO WarehouseProduct 
(WarehouseID,ProductID,ProductQuantity,[ProductName ])
values
('1010','999',80,'Plant Pot')

--Insert Data EmployeeSalary

INSERT INTO Group4DB.dbo.EmployeeSalary(EmployeeSalaryID , EmployeeID, BaseSalary, Bonus)
VALUES 
(7801, 2346, 33030.71, 500), 
(7802, 2347, 50750.50, 100), 
(7803, 2348, 27030.31, 400.63), 
(7804, 2349, 32030.00, 600), 
(7805, 2350, 31030.34, 200), 
(7806, 2351, 29030.71, 500), 
(7807, 2352, 85030.00, 0), 
(7808, 2353, 65030.68, 150.50), 
(7809, 2354, 40301.00, 122), 
(7810, 2355, 47830.12, 540);

--Insert dbo.revenue
INSERT  [dbo].[Revenue]([RevenueID],[EmployeeSalaryID],[Tax],[TotalRevenue],[Date])
VALUES 
	(88901,7801,33.50,10000.3,CAST(N'2019-01-01T00:00:00.000' AS DateTime)),
	(88902,7802,23.50,12000.4,CAST(N'2020-01-01T00:00:00.000' AS DateTime)),
	(88903,7803,3.50,2000.4,CAST(N'2021-01-01T10:00:00.000' AS DateTime)),
	(88904,7804,13.20,4000.7,CAST(N'2018-03-11T10:00:00.000' AS DateTime)),
	(88905,7805,33.40,6000.8,CAST(N'2020-02-01T10:00:00.000' AS DateTime)),
	(88906,7806,76.30,12030.2,CAST(N'2021-02-02T10:00:00.000' AS DateTime)),
	(88907,7807,23.56,99.6,CAST(N'2021-01-11T10:00:00.000' AS DateTime)),
	(88908,7808,67.40,4056.3,CAST(N'2020-11-07T10:00:00.000' AS DateTime)),
	(88909,7809,88.56,12123.7,CAST(N'2020-09-01T10:00:00.000' AS DateTime)),
	(88910,7810,99.7,66.4,CAST(N'2020-01-01T10:00:00.000' AS DateTime))

--insert dbo.CustomerOrder
INSERT [dbo].[CustomerOrder]
([CustomerID],[OrderID],[RevenueID],
[BillingStreetAddress],[BillingAddressCity],[BillingAddressState],[BillingAddressZipcode],
[ShippingStreetAddress],[ShippingAddressCity],[ShippingAddressState],[ShippingAddressZipcode],
[ShippingMethods],[OrderDate],[TotalPrice],[TrackingNumber])

VALUES
(1,90001,88901,
N'55 Fruit Street',N'Boston',N'MA','02118',
'759 Chestnut Street',N'Springfield', N'MA','02119',
'car',CAST(N'2021-01-01' AS Date),10000.2,794),

(2,90002,88902,
N'20 Administration Road',N'Bridgewater',N'MA','02118',
'14 Prospect Street',N'Springfield', N'MA','02119',
'car',CAST(N'2021-01-01' AS Date),1000.2,795),

(3,90003,88903,
N'800 Washington Street',N'Boston',N'MA','02118',
'2100 Dorchester Avenue',N'Boston', N'MA','02118',
'car',CAST(N'2021-01-01' AS Date),100.2,796),

(4,90004,88904,
N'2100 Dorchester Avenue',N'Boston',N'MA','02118',
'2100 Dorchester Avenue',N'Boston', N'MA','02118',
'car',CAST(N'2021-01-01' AS Date),7900.2,797),

(5,90005,88905,
N'1153 Centre Street',N'Boston',N'MA','02118',
'2100 Dorchester Avenue',N'Boston', N'MA','02118',
'car',CAST(N'2021-01-01' AS Date),791.2,798),

(6,90006,88906,
N'25 Carleton Street',N'Cambridge',N'MA','02118',
'2100 Dorchester Avenue',N'Boston', N'MA','02118',
'car',CAST(N'2021-01-01' AS Date),791.2,799),

(7,90007,88907,
N'800 Washington Street',N'Cambridge',N'MA','02118',
N'800 Washington Street',N'Boston', N'MA','02118',
'car',CAST(N'2021-01-01' AS Date),791.2,800),

(8,90008,88908,
N'25 Carleton Street',N'Cambridge',N'MA','02118',
N'25 Carleton Street',N'Boston', N'MA','02118',
'car',CAST(N'2021-01-01' AS Date),791.2,801),

(9,90009,88909,
N'1153 Centre Street',N'Cambridge',N'MA','02118',
N'1153 Centre Street',N'Boston', N'MA','02118',
'car',CAST(N'2021-01-01' AS Date),91.2,802),

(10,90010,88910,
N'300 Longwood Avenue',N'Cambridge',N'MA','02118',
N'300 Longwood Avenue',N'Boston', N'MA','02118',
'car',CAST(N'2021-01-01' AS Date),91.2,803)

--employee direct deposit
INSERT [dbo].[EmployeeDirectDeposit]([EmployeeID],[DepositDate],[DepositAmount])
	VALUES
	(2346,CAST(N'2021-01-01T00:00:00.000' AS DateTime),1002),
	(2347,CAST(N'2021-01-01T00:00:00.000' AS DateTime),2000),
	(2348,CAST(N'2021-01-01T00:00:00.000' AS DateTime),1100),
	(2349,CAST(N'2021-01-01T00:00:00.000' AS DateTime),1121),
	(2350,CAST(N'2021-01-01T00:00:00.000' AS DateTime),1131),
	(2351,CAST(N'2021-01-01T00:00:00.000' AS DateTime),1109),
	(2352,CAST(N'2021-01-01T00:00:00.000' AS DateTime),1180),
	(2353,CAST(N'2021-01-01T00:00:00.000' AS DateTime),1700),
	(2354,CAST(N'2021-01-01T00:00:00.000' AS DateTime),1781),
	(2355,CAST(N'2021-01-01T00:00:00.000' AS DateTime),1600);

--Update table with values from function that calculates TotalSalary
UPDATE Group4DB.dbo.EmployeeSalary 
SET TotalSalary = (dbo.GetTotalSalary(EmployeeID, EmployeeID));

-- insert into orderdetail
INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77001,90001, 111,1001,2004);

INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77002,90002, 112,1002,67);

INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77003,90003, 222,1003,3);

INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77004,90003, 444,1005,1);

INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77005,90003, 999,1010,1);

INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77006,90004, 888,1009,50);

INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77007,90004, 999,1010,17);

INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77008,90005, 666,1007,119);

INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77009,90006, 333,1004,13);

INSERT INTO [OrderDetail](OrderDetailID, OrderID, ProductID, WarehouseID, Quantity)
VALUES (77010,90007, 555,1006,61);


-- insert into Return
INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22201, 90001, 111,1001,'2021-01-03',30);

INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22202, 90001, 111,1001,'2021-01-04',44);

INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22203, 90004, 888,1009,'2021-01-06',10);

INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22204, 90003, 222,1003,'2021-01-07',1);

INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22205, 90003, 444,1005,'2021-01-06',1);


INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22206, 90003, 999,1010,'2021-01-06',1);

INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22207, 90007, 555,1006,'2021-01-04',11);

INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22208, 90005, 666,1007,'2021-01-06',1);

INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22209, 90006, 333,1004,'2021-01-02',1);

INSERT INTO [Return](ReturnID, OrderID, ProductID, WarehouseID, ReturnDate, ReturnQuantity)
VALUES (22210, 90006, 333,1004,'2021-01-04',1);


-- insert into Shipping task
INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103001, 90001, 2346, 9001,'2021-01-01');

INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103002, 90002, 2347, 9002,'2021-01-01');

INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103003, 90003, 2348, 9003,'2021-01-01');

INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103004, 90004, 2349, 9004,'2021-01-01');

INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103005, 90005, 2350, 9005,'2021-01-01');

INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103006, 90006, 2351, 9006,'2021-01-01');

INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103007, 90007, 2352, 9007,'2021-01-01');

INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103008, 90008, 2353, 9008,'2021-01-01');
INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103009, 90009, 2354, 9009,'2021-01-01');
INSERT INTO [ShippingTask](TaskID, OrderID, EmployeeID, TrackingNumber, ShippingDate)
VALUES (103010, 90010, 2355, 9010,'2021-01-01');