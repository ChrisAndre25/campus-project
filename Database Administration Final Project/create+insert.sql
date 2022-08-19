USE master
GO
IF NOT EXISTS(SELECT name FROM master.dbo.sysdatabases WHERE name = 'Sociolla')
	CREATE DATABASE Sociolla
GO
USE Sociolla
GO
CREATE TABLE MsItemBrand(
	ItemBrandID CHAR(5) PRIMARY KEY CHECK (ItemBrandID LIKE 'IB[0-9][0-9][0-9]') NOT NULL,
	ItemBrandName VARCHAR(30) NOT NULL
)

CREATE TABLE MsItemCategory(
	ItemCategoryID CHAR(5) PRIMARY KEY CHECK (ItemCategoryID like 'IC[0-9][0-9][0-9]') NOT NULL,
	ItemCategoryName VARCHAR(20) NOT NULL
)

CREATE TABLE MsItem(
	ItemID CHAR(5) PRIMARY KEY CHECK (ItemID LIKE 'IT[0-9][0-9][0-9]') NOT NULL,
	ItemName VARCHAR(50) NOT NULL,
	ItemStock INT NOT NULL,
	ItemPrice BIGINT NOT NULL,
	ItemBrandID CHAR(5) FOREIGN KEY REFERENCES MsItemBrand(ItemBrandID) ON UPDATE CASCADE ON DELETE CASCADE,
	ItemCategoryID CHAR(5) FOREIGN KEY REFERENCES MsItemCategory(ItemCategoryID) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE MsPaymentType(
	PaymentTypeID CHAR(5) PRIMARY KEY CHECK (PaymentTypeID LIKE 'PT[0-9][0-9][0-9]') NOT NULL,
	PaymentTypeName VARCHAR(20) NOT NULL
)

CREATE TABLE MsCustomer(
	CustomerID CHAR(5) PRIMARY KEY CHECK (CustomerID LIKE 'CS[0-9][0-9][0-9]') NOT NULL,
	CustomerName VARCHAR(25) NOT NULL,
	CustomerDOB DATE NOT NULL,
	CustomerGender CHAR(6) NOT NULL,
	CustomerEmail VARCHAR(35) NOT NULL,
	CustomerPhone CHAR(12) NOT NULL
)

CREATE TABLE MsStaff(
	StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]') NOT NULL,
	StaffName VARCHAR(25) NOT NULL,
	StaffGender CHAR(6) NOT NULL,
	StaffSalary BIGINT NOT NULL,
	StaffDOB DATE NOT NULL
)

CREATE TABLE HeaderTransaction(
	TransactionID CHAR(5) PRIMARY KEY CHECK (TransactionID LIKE 'TR[0-9][0-9][0-9]') NOT NULL,
	CustomerID CHAR(5) FOREIGN KEY REFERENCES MsCustomer(CustomerID),
	StaffID CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffID), 
	PaymentTypeID CHAR(5) FOREIGN KEY REFERENCES MsPaymentType(PaymentTypeID),
	TransactionDate DATE NOT NULL
)

CREATE TABLE DetailTransaction(
	TransactionID CHAR(5) FOREIGN KEY REFERENCES HeaderTransaction(TransactionID),
	ItemID CHAR(5) FOREIGN KEY REFERENCES MsItem(ItemID),
	Quantity INT NOT NULL,
	PRIMARY KEY(TransactionID, ItemID)
)

INSERT INTO MsItemCategory VALUES('IC001','Make Up')
INSERT INTO MsItemCategory VALUES('IC002','Skin Care')
INSERT INTO MsItemCategory VALUES('IC003','Hair Care')
INSERT INTO MsItemCategory VALUES('IC004','Nails')
INSERT INTO MsItemCategory VALUES('IC005','Bath & Body')

INSERT INTO MsItemBrand VALUES('IB001','Banana Boat')
INSERT INTO MsItemBrand VALUES('IB002','Cetaphil')
INSERT INTO MsItemBrand VALUES('IB003','Matrix')
INSERT INTO MsItemBrand VALUES('IB004','Tree Hut')
INSERT INTO MsItemBrand VALUES('IB005','NYX Professional Makeup')
INSERT INTO MsItemBrand VALUES('IB006','Inglot')
INSERT INTO MsItemBrand VALUES('IB007','Klorane')
INSERT INTO MsItemBrand VALUES('IB008','Laneige')
INSERT INTO MsItemBrand VALUES('IB009','Loreal Paris')
INSERT INTO MsItemBrand VALUES('IB010','Daeng Gi Meo Ri')
INSERT INTO MsItemBrand VALUES('IB011','Maybelline')
INSERT INTO MsItemBrand VALUES('IB012','DrJart')
INSERT INTO MsItemBrand VALUES('IB013','LA Girl')
INSERT INTO MsItemBrand VALUES('IB014','Urban Decay')
INSERT INTO MsItemBrand VALUES('IB015','Aveeno')

INSERT INTO MsItem VALUES('IT001', 'Two Tone Tint Lip Bar', 35, 368500, 'IB008', 'IC001')
INSERT INTO MsItem VALUES('IT002', 'Gentle Skin Cleanser', 14, 322400, 'IB002', 'IC002')
INSERT INTO MsItem VALUES('IT003', 'Setting Spray Addiction', 11, 576700, 'IB014', 'IC001')
INSERT INTO MsItem VALUES('IT004', 'Scalp Care Set', 15, 271000, 'IB003', 'IC003')
INSERT INTO MsItem VALUES('IT005', 'Ceramidin Facial Mask', 20, 49300, 'IB012', 'IC002')
INSERT INTO MsItem VALUES('IT006', 'Mango Butter Shampoo', 14, 315000, 'IB007', 'IC003')
INSERT INTO MsItem VALUES('IT007', 'Bare With Me Complete', 17, 721000, 'IB001', 'IC005')
INSERT INTO MsItem VALUES('IT008', 'Superstar Baby', 19, 277200, 'IB011', 'IC001')
INSERT INTO MsItem VALUES('IT009', 'Dry & Shine', 16, 250000, 'IB006', 'IC004')
INSERT INTO MsItem VALUES('IT010', 'Oily Skin Cleanser', 16, 297000, 'IB002', 'IC002')
INSERT INTO MsItem VALUES('IT011', 'White Perfect Clinical Night Cream', 12, 173600, 'IB009', 'IC002')
INSERT INTO MsItem VALUES('IT012', 'O2M Breathable Base', 13, 285000, 'IB006', 'IC004')
INSERT INTO MsItem VALUES('IT013', 'Skin Relief Bundle', 12, 458000, 'IB015', 'IC005')
INSERT INTO MsItem VALUES('IT014', 'Superstay Power Duo',32, 181900, 'IB001', 'IC001')
INSERT INTO MsItem VALUES('IT015', 'Tropical Mango', 10, 428000, 'IB004', 'IC005')
INSERT INTO MsItem VALUES('IT016', 'Vitalising Treatment Duo', 13, 200000, 'IB010', 'IC003')
INSERT INTO MsItem VALUES('IT017', 'Color Sensational Powder Matte Bundle', 12, 147000, 'IB011', 'IC001')
INSERT INTO MsItem VALUES('IT018', 'Perfect Bare California', 10, 425000, 'IB005', 'IC001')
INSERT INTO MsItem VALUES('IT019', 'Power Skin Refiner Light', 17, 400000, 'IB008', 'IC002')
INSERT INTO MsItem VALUES('IT020', 'Sport Coolzone SPF 50', 17, 228800, 'IB001', 'IC005')
INSERT INTO MsItem VALUES('IT021', 'Damaged Hair Kit', 16, 326000, 'IB003', 'IC003')
INSERT INTO MsItem VALUES('IT022', 'Water Bank Moisture Cream', 12, 450000, 'IB008', 'IC002')
INSERT INTO MsItem VALUES('IT023', 'O2M Breathable Top Coat', 16, 285000, 'IB006', 'IC004')
INSERT INTO MsItem VALUES('IT024', 'Coconut Lime', 14, 428000, 'IB004', 'IC005')
INSERT INTO MsItem VALUES('IT025', 'Ultra Matte Junkies', 13, 576700, 'IB001', 'IC004')
INSERT INTO MsItem VALUES('IT026', 'Sport Sunscreen Lotion SPF 30', 12, 136400, 'IB001', 'IC005')
INSERT INTO MsItem VALUES('IT027', 'Anti-Oily Scalp Care Set', 14, 420000, 'IB003', 'IC003')
INSERT INTO MsItem VALUES('IT028', 'Color Pop', 14, 90000, 'IB013', 'IC004')
INSERT INTO MsItem VALUES('IT029', 'Revitalift Toner', 19, 123600, 'IB009', 'IC002')
INSERT INTO MsItem VALUES('IT030', 'Calcium Nail Builder', 10, 90000, 'IB013', 'IC004')
INSERT INTO MsItem VALUES('IT031', 'Dermask Micro Jet Clearing Solution', 11, 69000, 'IB012', 'IC002')
INSERT INTO MsItem VALUES('IT032', 'Lotion Travel Set', 17, 188000, 'IB015', 'IC005')
INSERT INTO MsItem VALUES('IT033', 'Oat Milk Shampoo', 13, 315000, 'IB007', 'IC003')
INSERT INTO MsItem VALUES('IT034', 'Ki Gold Set', 13, 210000, 'IB010', 'IC003')

INSERT INTO MsPaymentType VALUES('PT001', 'Credit Card')
INSERT INTO MsPaymentType VALUES('PT002', 'Debit Card')
INSERT INTO MsPaymentType VALUES('PT003', 'Cash')
INSERT INTO MsPaymentType VALUES('PT004', 'OVO')
INSERT INTO MsPaymentType VALUES('PT005', 'GoPay')
INSERT INTO MsPaymentType VALUES('PT006', 'ShopeePay')
INSERT INTO MsPaymentType VALUES('PT007', 'Refund')

INSERT INTO MsCustomer VALUES ('CS001', 'Rodd Bothram', '1973-05-16', 'Male', 'rbothram0@auda.org.au', '855-600-9156')
INSERT INTO MsCustomer VALUES ('CS002', 'Morris Peskin', '1987-11-08', 'Male', 'mpeskin1@wikimedia.org', '100-499-7885')
INSERT INTO MsCustomer VALUES ('CS003', 'Neel McCurley', '1985-11-15', 'Male', 'nmccurley2@arstechnica.com', '317-863-7308')
INSERT INTO MsCustomer VALUES ('CS004', 'Riva Kidston', '1978-04-17', 'Female', 'rkidston3@cpanel.net', '598-274-6617')
INSERT INTO MsCustomer VALUES ('CS005', 'Eldon Lawley', '1993-08-16', 'Male', 'elawley4@dmoz.org', '222-118-6715')
INSERT INTO MsCustomer VALUES ('CS006', 'Marc Stedmond', '1989-09-30', 'Male', 'mstedmond5@creativecommons.org', '733-465-1764')
INSERT INTO MsCustomer VALUES ('CS007', 'Connor Galilee', '2007-09-14', 'Male', 'cgalilee6@buzzfeed.com', '158-519-7658')
INSERT INTO MsCustomer VALUES ('CS008', 'Tonye Canape', '1972-05-09', 'Female', 'tcanape7@friendfeed.com', '221-836-3989')
INSERT INTO MsCustomer VALUES ('CS009', 'Carmelle Ferrierio', '1989-03-20', 'Female', 'cferrierio8@go.com', '796-512-7914')
INSERT INTO MsCustomer VALUES ('CS010', 'Abraham Pladen', '1992-05-01', 'Male', 'apladen9@tamu.edu', '202-330-9523')
INSERT INTO MsCustomer VALUES ('CS011', 'Ingemar Audsley', '1999-11-11', 'Male', 'iaudsleya@wix.com', '387-125-9949')
INSERT INTO MsCustomer VALUES ('CS012', 'Dun Shearston', '1989-09-28', 'Male', 'dshearstonb@princeton.edu', '856-353-3740')
INSERT INTO MsCustomer VALUES ('CS013', 'Barnabas Durdle', '1996-11-15', 'Male', 'bdurdlec@spotify.com', '877-269-2158')
INSERT INTO MsCustomer VALUES ('CS014', 'Alon Godlonton', '1984-02-03', 'Male', 'agodlontond@naver.com', '804-435-4438')
INSERT INTO MsCustomer VALUES ('CS015', 'Aurlie McNellis', '1973-07-14', 'Female', 'amcnellise@liveinternet.ru', '497-671-9297')
INSERT INTO MsCustomer VALUES ('CS016', 'Dar Townby', '1975-03-21', 'Male', 'dtownbyf@posterous.com', '672-946-3633')
INSERT INTO MsCustomer VALUES ('CS017', 'Ximenez Macbeth', '2003-08-18', 'Male', 'xmacbethg@pinterest.com', '774-414-1151')
INSERT INTO MsCustomer VALUES ('CS018', 'Ellerey Cunio', '1972-03-22', 'Male', 'ecunioh@gmpg.org', '571-418-4565')
INSERT INTO MsCustomer VALUES ('CS019', 'Inigo Newick', '1981-08-04', 'Male', 'inewicki@slideshare.net', '699-876-8545')
INSERT INTO MsCustomer VALUES ('CS020', 'Dallis Daviot', '1982-05-13', 'Male', 'ddaviotj@weather.com', '319-407-0431')

INSERT INTO MsStaff VALUES ('ST001', 'Marni Boyles', 'Female', 4345000, '2002-01-15')
INSERT INTO MsStaff VALUES ('ST002', 'Rowena O'' Mahony', 'Female', 5825000, '1999-05-28')
INSERT INTO MsStaff VALUES ('ST003', 'Wilburt Mussetti', 'Male', 5077000, '1991-03-14')
INSERT INTO MsStaff VALUES ('ST004', 'Randal Salway', 'Male', 4453000, '1989-03-22')
INSERT INTO MsStaff VALUES ('ST005', 'Joey Emloch', 'Male', 5139000, '1985-03-23')
INSERT INTO MsStaff VALUES ('ST006', 'Krystal Beardon', 'Female', 3880000, '1998-08-15')
INSERT INTO MsStaff VALUES ('ST007', 'Rickard Neely', 'Male', 4019000, '1989-08-05')
INSERT INTO MsStaff VALUES ('ST008', 'Boigie Epinay', 'Male', 5562000, '2002-01-15')
INSERT INTO MsStaff VALUES ('ST009', 'Andie Sunners', 'Female', 4261000, '1986-10-18')
INSERT INTO MsStaff VALUES ('ST010', 'Aggi Hobben', 'Female', 4931000, '1995-11-18')
INSERT INTO MsStaff VALUES ('ST011', 'Winnie Felce', 'Female', 3501000, '1990-07-11')
INSERT INTO MsStaff VALUES ('ST012', 'Emogene Noah', 'Female', 3958000, '1991-07-24')
INSERT INTO MsStaff VALUES ('ST013', 'Shoshana Lammerts', 'Female', 4259000, '1990-09-01')
INSERT INTO MsStaff VALUES ('ST014', 'Candis Downes', 'Female', 3770000, '1987-01-21')
INSERT INTO MsStaff VALUES ('ST015', 'Nicola Oakenfall', 'Female', 4490000, '1992-05-05')
INSERT INTO MsStaff VALUES ('ST016', 'Jocelin Goodnow', 'Female', 5554000, '1986-10-23')
INSERT INTO MsStaff VALUES ('ST017', 'Robby Roblett', 'Male', 3990000, '1996-10-04')
INSERT INTO MsStaff VALUES ('ST018', 'Cordy Dunster', 'Male', 5097000, '1998-06-18')
INSERT INTO MsStaff VALUES ('ST019', 'Everett Ackermann', 'Male', 3964000, '1996-01-04')
INSERT INTO MsStaff VALUES ('ST020', 'Emmalynn Copsey', 'Female', 5727000, '1987-10-29')

INSERT INTO HeaderTransaction VALUES('TR001', 'CS008', 'ST012', 'PT004', '2018-01-04')
INSERT INTO HeaderTransaction VALUES('TR002', 'CS002', 'ST017', 'PT001', '2018-06-03')
INSERT INTO HeaderTransaction VALUES('TR003', 'CS005', 'ST003', 'PT003', '2018-06-29')
INSERT INTO HeaderTransaction VALUES('TR004', 'CS014', 'ST009', 'PT005', '2018-09-20')
INSERT INTO HeaderTransaction VALUES('TR005', 'CS011', 'ST007', 'PT006', '2018-11-01')
INSERT INTO HeaderTransaction VALUES('TR006', 'CS017', 'ST014', 'PT006', '2018-11-03')
INSERT INTO HeaderTransaction VALUES('TR007', 'CS019', 'ST011', 'PT002', '2018-11-30')
INSERT INTO HeaderTransaction VALUES('TR008', 'CS007', 'ST001', 'PT004', '2018-12-15')
INSERT INTO HeaderTransaction VALUES('TR009', 'CS012', 'ST013', 'PT005', '2019-01-17')
INSERT INTO HeaderTransaction VALUES('TR010', 'CS010', 'ST005', 'PT003', '2019-04-22')
INSERT INTO HeaderTransaction VALUES('TR011', 'CS016', 'ST010', 'PT002', '2019-04-25')
INSERT INTO HeaderTransaction VALUES('TR012', 'CS009', 'ST015', 'PT001', '2019-05-09')
INSERT INTO HeaderTransaction VALUES('TR013', 'CS003', 'ST019', 'PT002', '2019-05-19')
INSERT INTO HeaderTransaction VALUES('TR014', 'CS001', 'ST016', 'PT002', '2019-06-13')
INSERT INTO HeaderTransaction VALUES('TR015', 'CS006', 'ST002', 'PT003', '2019-08-17')
INSERT INTO HeaderTransaction VALUES('TR016', 'CS020', 'ST004', 'PT002', '2019-09-21')
INSERT INTO HeaderTransaction VALUES('TR017', 'CS004', 'ST006', 'PT001', '2019-10-09')
INSERT INTO HeaderTransaction VALUES('TR018', 'CS013', 'ST020', 'PT005', '2019-11-09')
INSERT INTO HeaderTransaction VALUES('TR019', 'CS015', 'ST008', 'PT002', '2019-12-05')
INSERT INTO HeaderTransaction VALUES('TR020', 'CS018', 'ST015', 'PT004', '2020-02-03')
INSERT INTO HeaderTransaction VALUES('TR021', 'CS005', 'ST018', 'PT006', '2020-03-01')
INSERT INTO HeaderTransaction VALUES('TR022', 'CS019', 'ST017', 'PT001', '2020-03-20')
INSERT INTO HeaderTransaction VALUES('TR023', 'CS003', 'ST006', 'PT002', '2020-04-05')
INSERT INTO HeaderTransaction VALUES('TR024', 'CS014', 'ST009', 'PT004', '2020-04-11')
INSERT INTO HeaderTransaction VALUES('TR025', 'CS008', 'ST003', 'PT003', '2020-04-19')

INSERT INTO DetailTransaction VALUES ('TR019', 'IT026', 3)
INSERT INTO DetailTransaction VALUES ('TR020', 'IT029', 3)
INSERT INTO DetailTransaction VALUES ('TR015', 'IT019', 6)
INSERT INTO DetailTransaction VALUES ('TR002', 'IT007', 10)
INSERT INTO DetailTransaction VALUES ('TR022', 'IT014', 7)
INSERT INTO DetailTransaction VALUES ('TR009', 'IT005', 6)
INSERT INTO DetailTransaction VALUES ('TR014', 'IT012', 6)
INSERT INTO DetailTransaction VALUES ('TR011', 'IT010', 3)
INSERT INTO DetailTransaction VALUES ('TR021', 'IT032', 9)
INSERT INTO DetailTransaction VALUES ('TR002', 'IT012', 5)
INSERT INTO DetailTransaction VALUES ('TR020', 'IT026', 4)
INSERT INTO DetailTransaction VALUES ('TR017', 'IT030', 9)
INSERT INTO DetailTransaction VALUES ('TR024', 'IT004', 5)
INSERT INTO DetailTransaction VALUES ('TR008', 'IT025', 1)
INSERT INTO DetailTransaction VALUES ('TR013', 'IT029', 4)
INSERT INTO DetailTransaction VALUES ('TR007', 'IT011', 5)
INSERT INTO DetailTransaction VALUES ('TR011', 'IT021', 4)
INSERT INTO DetailTransaction VALUES ('TR004', 'IT017', 3)
INSERT INTO DetailTransaction VALUES ('TR018', 'IT013', 9)
INSERT INTO DetailTransaction VALUES ('TR021', 'IT020', 10)
INSERT INTO DetailTransaction VALUES ('TR011', 'IT008', 4)
INSERT INTO DetailTransaction VALUES ('TR001', 'IT005', 7)
INSERT INTO DetailTransaction VALUES ('TR006', 'IT003', 1)
INSERT INTO DetailTransaction VALUES ('TR010', 'IT002', 7)
INSERT INTO DetailTransaction VALUES ('TR002', 'IT001', 7)
INSERT INTO DetailTransaction VALUES ('TR005', 'IT027', 7)
INSERT INTO DetailTransaction VALUES ('TR003', 'IT016', 8)
INSERT INTO DetailTransaction VALUES ('TR012', 'IT023', 2)
INSERT INTO DetailTransaction VALUES ('TR021', 'IT003', 7)
INSERT INTO DetailTransaction VALUES ('TR024', 'IT033', 3)
INSERT INTO DetailTransaction VALUES ('TR010', 'IT010', 8)
INSERT INTO DetailTransaction VALUES ('TR017', 'IT001', 8)
INSERT INTO DetailTransaction VALUES ('TR024', 'IT020', 1)
INSERT INTO DetailTransaction VALUES ('TR003', 'IT019', 9)
INSERT INTO DetailTransaction VALUES ('TR016', 'IT006', 3)
INSERT INTO DetailTransaction VALUES ('TR012', 'IT024', 8)
INSERT INTO DetailTransaction VALUES ('TR023', 'IT001', 8)
INSERT INTO DetailTransaction VALUES ('TR003', 'IT007', 2)
INSERT INTO DetailTransaction VALUES ('TR025', 'IT031', 1)
INSERT INTO DetailTransaction VALUES ('TR018', 'IT009', 9)

EXEC sp_msforeachtable 'SELECR * FROM ?'
