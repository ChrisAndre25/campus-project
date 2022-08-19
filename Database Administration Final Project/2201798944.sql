--NO 1
USE [msdb]
GO

/****** Object:  Job [Quarterly Report]    Script Date: 6/12/2020 11:09:37 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Data Collector]    Script Date: 6/12/2020 11:09:37 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Data Collector' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Data Collector'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Quarterly Report', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Generate quarterly report of all transactions that occur', 
		@category_name=N'Data Collector', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Quarterly Report]    Script Date: 6/12/2020 11:09:38 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Quarterly Report', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SELECT ht.TransactionID, CustomerName, StaffName, TransactionDate, [Total Item] = COUNT(dt.ItemID), [Total Quantity] = SUM(Quantity), [Total Purchases] = SUM(Quantity * ItemPrice)
FROM HeaderTransaction ht JOIN MsCustomer mc ON ht.CustomerID = mc.CustomerID JOIN MsStaff ms ON ht.StaffID = ms.StaffID JOIN DetailTransaction dt ON dt.TransactionID = ht.TransactionID JOIN MsItem mi ON dt.ItemID = mi.ItemID
WHERE YEAR(CURRENT_TIMESTAMP) = YEAR(TransactionDATE) AND MONTH(CURRENT_TIMESTAMP) - MONTH(TransactionDate)  < 3
GROUP BY ht.TransactionID, CustomerName, StaffName, TransactionDate', 
		@database_name=N'Sociolla', 
		@output_file_name=N'C:\ReportDetails.txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Quarterly Report', 
		@enabled=1, 
		@freq_type=16, 
		@freq_interval=31, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=3, 
		@active_start_date=20200612, 
		@active_end_date=99991231, 
		@active_start_time=230000, 
		@active_end_time=235959, 
		@schedule_uid=N'f608a655-1bc5-40e8-a593-37649a36e9ae'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

--NO 2
USE [msdb]
GO

/****** Object:  Job [Remaining Stock Report]    Script Date: 6/12/2020 11:10:18 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Data Collector]    Script Date: 6/12/2020 11:10:18 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Data Collector' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Data Collector'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Remaining Stock Report', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Generate a report to print out the remaining stock of every item', 
		@category_name=N'Data Collector', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Remaining Stock]    Script Date: 6/12/2020 11:10:18 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Remaining Stock', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SELECT dt.ItemID, ItemName, [Remaining] = ItemStock - SUM(Quantity) FROM DetailTransaction dt JOIN MsItem mi ON dt.ItemID = mi.ItemID
GROUP BY dt.ItemID, ItemName, ItemStock', 
		@database_name=N'Sociolla', 
		@output_file_name=N'C:\RemainingStock.txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Remaining Stock', 
		@enabled=1, 
		@freq_type=16, 
		@freq_interval=7, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=2, 
		@active_start_date=20200612, 
		@active_end_date=99991231, 
		@active_start_time=223000, 
		@active_end_time=235959, 
		@schedule_uid=N'8632aa5d-20f2-4f81-8115-53382def9c98'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


--NO 3
CREATE PROCEDURE ValidateItem @ItemID CHAR(5), @ItemName VARCHAR(50), @ItemStock INT, @ItemPrice BIGINT, @ItemBrandID CHAR(5), @ItemCategoryID CHAR(5)
AS 
IF EXISTS (SELECT * FROM MsItem WHERE ItemID = @ItemID AND ItemName = @ItemName)
BEGIN 
	Print 'Item already exist'
END
ELSE IF EXISTS (SELECT * FROM MsItem WHERE ItemName = @ItemName)
BEGIN
	Print 'This item already exists with different ID'
END
ELSE IF EXISTS (SELECT * FROM MsItem WHERE ItemID = @ItemID)
BEGIN	
	Print 'ID must be unique'
END
ELSE IF EXISTS (SELECT * FROM MsItem WHERE ItemName != @ItemName AND ItemID != @ItemID) 
BEGIN
	INSERT INTO MsItem VALUES (@ItemID, @ItemName, @ItemStock, @ItemPrice, (SELECT ItemBrandID FROM MsItemBrand WHERE ItemBrandID = @ItemBrandID), (SELECT ItemCategoryID FROM MsItemCategory WHERE ItemCategoryID = @ItemCategoryID))
END

EXEC ValidateItem 'IT034', 'Ki Gold Set', 23, 100000, 'IB001', 'IC001'
EXEC ValidateItem 'IT035', 'Ki Gold Set', 23, 100000, 'IB001', 'IC001'
EXEC ValidateItem 'IT034', 'Mediheal Set', 23, 100000, 'IB001', 'IC001'
EXEC ValidateItem 'IT035', 'Mediheal Set', 23, 100000, 'IB001', 'IC001'

--NO 4
CREATE PROCEDURE RemoveItem @ItemID CHAR(5)
AS
IF NOT EXISTS(SELECT * FROM MsItem WHERE ItemID = @ItemID)
BEGIN
	PRINT 'Item doesnt exist'
END
ELSE
IF @ItemID IN(SELECT TOP 5 dt.ItemID FROM MsItem mi JOIN DetailTransaction dt ON mi.ItemID = dt.ItemID GROUP BY dt.ItemID ORDER BY SUM(Quantity) DESC)
BEGIN
	PRINT 'Item cannot deleted because it is in the Top 5'
END
ELSE
BEGIN
	UPDATE MsItem SET ItemStock = 0 WHERE ItemID = @ItemID
END

EXEC RemoveItem 'IT035'
EXEC RemoveItem 'IT001'
EXEC RemoveItem 'IT023'

--NO 5
CREATE PROCEDURE DeleteItem @ItemID CHAR(5)
AS
IF NOT EXISTS(SELECT * FROM MsItem WHERE ItemID = @ItemID)
BEGIN
	PRINT 'Item doesnt exist'
END
ELSE IF EXISTS(SELECT * FROM DetailTransaction WHERE ItemID = @ItemID)
BEGIN
	PRINT 'Item cannot be removed'
END
ELSE
BEGIN
	DELETE FROM MsItem WHERE ItemID = @ItemID
END

EXEC DeleteItem 'IT035'
EXEC DeleteItem 'IT001'
EXEC DeleteItem 'IT034'

--NO 6
CREATE TRIGGER InsertItemTrigger ON MsItem INSTEAD OF INSERT
AS
DECLARE @ItemID CHAR(5), @ItemName VARCHAR(50), @ItemStock INT, @ItemPrice BIGINT, @ItemBrandID CHAR(5), @ItemCategoryID CHAR(5)
SET @ItemID = (SELECT ItemID FROM inserted)
SET @ItemName = (SELECT ItemName FROM inserted)
SET @ItemStock = (SELECT ItemStock FROM inserted)
SET @ItemPrice = (SELECT ItemPrice FROM inserted)
SET @ItemBrandID = (SELECT ItemBrandID FROM inserted)
SET @ItemCategoryID = (SELECT ItemCategoryID FROM inserted)
IF EXISTS (SELECT * FROM MsItem WHERE ItemID = @ItemID)
BEGIN 
	PRINT 'Item ID already exist'
END
ELSE IF @ItemID NOT LIKE 'IT[0-9][0-9][0-9]'
BEGIN
	PRINT 'Item ID must be in the right format'
END
ELSE IF @ItemStock <= 10
BEGIN
	PRINT 'Item Stock must be greater than 10'
END
ELSE IF @ItemBrandID NOT LIKE 'IB[0-9][0-9][0-9]'
BEGIN	
	PRINT 'Item Brand must be in the right format'
END
ELSE IF NOT EXISTS (SELECT * FROM MsItemBrand WHERE ItemBrandID = @ItemBrandID)
BEGIN
	PRINT @ItemBrandID + ' doesnt exist'
END
ELSE IF @ItemCategoryID NOT LIKE 'IC[0-9][0-9][0-9]'
BEGIN
	PRINT 'Item Category must be in the right format'
END
ELSE IF NOT EXISTS (SELECT * FROM MsItemCategory WHERE ItemCategoryID = @ItemCategoryID)
BEGIN
	PRINT @ItemCategoryID + ' doesnt exist'
END
ELSE
INSERT INTO MsItem VALUES (@ItemID, @ItemName, @ItemStock, @ItemPrice, @ItemBrandID, @ItemCategoryID)

INSERT INTO MsItem VALUES ('IT035', 'Mediheal Set', 14, 300000, 'IB015', 'IC005')
SELECT * FROM MsItem WHERE ItemID = 'IT035'

--NO 7
CREATE TRIGGER RefundTransaction ON HeaderTransaction INSTEAD OF UPDATE
AS
DECLARE @PaymentTypeID CHAR(5), @CustomerID CHAR(5)
SET @PaymentTypeID = (SELECT PaymentTypeID FROM inserted)
SET @CustomerID = (SELECT CustomerID FROM inserted)

BEGIN
DECLARE @OldPaymentType CHAR(5), @OldTransactionDate DATE, @PreviousStock INT
SET @OldPaymentType = (SELECT PaymentTypeID FROM HeaderTransaction WHERE CustomerID = @CustomerID)
SET @OldTransactionDate = (SELECT TransactionDate FROM HeaderTransaction WHERE CustomerID = @CustomerID)
SET @PreviousStock = (SELECT ItemStock FROM HeaderTransaction ht JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID JOIN MsItem mi ON dt.ItemID = mi.ItemID WHERE ht.CustomerID = @CustomerID)
	PRINT 'Old Transaction'
	PRINT '---------------'
	PRINT 'Payment Type: ' + @OldPaymentType
	PRINT 'Transaction Date: ' + CAST(@OldTransactionDate AS VARCHAR(50)) 
	PRINT 'Previous Stock: ' + CAST(@PreviousStock AS VARCHAR(50))

UPDATE HeaderTransaction
SET PaymentTypeID = @PaymentTypeID, TransactionDate = (SELECT CONVERT(CHAR(10), GETDATE(), 126))
WHERE CustomerID = @CustomerID

UPDATE MsItem
SET ItemStock = ItemStock + dt.Quantity
FROM MsItem mi JOIN DetailTransaction dt on mi.ItemID = dt.ItemID JOIN HeaderTransaction ht on dt.TransactionID = ht.TransactionID
WHERE ht.CustomerID = @CustomerID

DECLARE @NewPaymentType CHAR(5), @NewTransactionDate DATE, @NewStock INT
SET @NewPaymentType = (SELECT PaymentTypeID FROM HeaderTransaction WHERE CustomerID = @CustomerID)
SET @NewTransactionDate = (SELECT TransactionDate FROM HeaderTransaction WHERE CustomerID = @CustomerID)
SET @NewStock = (SELECT ItemStock FROM HeaderTransaction ht JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID JOIN MsItem mi ON dt.ItemID = mi.ItemID WHERE ht.CustomerID = @CustomerID)
	PRINT 'New Transaction'
	PRINT '---------------'
	PRINT 'Payment Type: ' + @NewPaymentType
	PRINT 'Transaction Date: ' + CAST(@NewTransactionDate AS VARCHAR(50)) 
	PRINT 'New Stock: ' + CAST(@NewStock AS VARCHAR(50))

--NO 8
CREATE PROCEDURE PrintReceipt @TransactionID CHAR(5)
AS
IF NOT EXISTS(SELECT * FROM HeaderTransaction WHERE TransactionID = @TransactionID)
BEGIN
PRINT 'Transaction ID doesnt exist' 
END
ELSE
BEGIN
DECLARE @TransactionDate DATE, @StaffName VARCHAR(50), @PaymentType VARCHAR(50), @CustomerName VARCHAR(50)
SET @TransactionDate = (SELECT TransactionDate FROM HeaderTransaction WHERE TransactionID = @TransactionID)
SET @StaffName = (SELECT StaffName FROM MsStaff ms JOIN HeaderTransaction ht ON ms.StaffID = ht.StaffID WHERE ht.TransactionID = @TransactionID)
SET @PaymentType = (SELECT PaymentTypeName FROM MsPaymentType mpt JOIN HeaderTransaction ht ON ht.PaymentTypeID = mpt.PaymentTypeID WHERE ht.TransactionID = @TransactionID)
SET @CustomerName = (SELECT CustomerName FROM MsCustomer mc JOIN HeaderTransaction ht ON mc.CustomerID = ht.CustomerID WHERE ht.TransactionID = @TransactionID)
	PRINT 'Hi There, ' + @CustomerName
	PRINT 'Here are your shopping details'
	PRINT '================================================='
	PRINT 'Transcation Date: ' + CAST(@TransactionDate AS VARCHAR(50))
	PRINT 'Cashier: ' + @StaffName
	PRINT 'Payment: ' + @PaymentType
	PRINT '================================================='
DECLARE @ItemName VARCHAR(50), @Quantity INT, @Brand VARCHAR(50), @Category VARCHAR(50), @ItemPrice INT, @TotalItem INT, @TotalPrice INT
SET @TotalPrice = 0
SET @TotalItem = 0
DECLARE Transaction_Cursor CURSOR FOR
SELECT ItemName, Quantity, ItemBrandName, ItemCategoryName, ItemPrice
FROM MsItemCategory mic, MsItemBrand mib, MsItem mi, DetailTransaction dt, HeaderTransaction ht
WHERE mic.ItemCategoryID = mi.ItemCategoryID AND mib.ItemBrandID = mi.ItemBrandID AND mi.ItemID = dt.ItemID AND dt.TransactionID = ht.TransactionID AND ht.TransactionID = @TransactionID
OPEN Transaction_Cursor
FETCH NEXT FROM Transaction_Cursor INTO @ItemName, @Quantity, @Brand, @Category, @ItemPrice
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Item: ' + @ItemName
	PRINT 'Quantity: ' + CAST(@Quantity AS VARCHAR(50))
	PRINT 'Brand: ' + @Brand
	PRINT 'Category: ' + @Category
	PRINT 'Price/Item: ' + CAST(@ItemPrice AS VARCHAR(50))
	PRINT 'Total: ' + CAST((@ItemPrice * @Quantity) AS VARCHAR(50))
	PRINT '================================================='
SET @TotalItem = @TotalItem + 1
SET @TotalPrice = @TotalPrice + (@ItemPrice * @Quantity)
FETCH NEXT FROM Transaction_Cursor INTO @ItemName, @Quantity, @Brand, @Category, @ItemPrice
END
	PRINT 'Total Item: ' + CAST(@TotalItem AS VARCHAR(50))
	PRINT 'Total Price: ' + CAST(@TotalPrice AS VARCHAR(50))
CLOSE Transaction_Cursor
DEALLOCATE Transaction_Cursor
END

EXEC PrintReceipt 'TR025'

--NO 9

CREATE PROCEDURE SearchItem @Brand VARCHAR(50)
AS
BEGIN
IF LEN(@Brand) <= 3
BEGIN
PRINT 'Keyword must be longer than 3 characters'
END
ELSE IF NOT EXISTS (SELECT ItemBrandName FROM MsItemBrand WHERE ItemBrandName LIKE '%' + @Brand + '%')
BEGIN
PRINT 'Brand doesnt exist'
END
ELSE
BEGIN
DECLARE @ItemID CHAR(5), @ItemName VARCHAR(50), @ItemStock INT, @ItemPrice BIGINT, @ItemBrandName VARCHAR(50)
SET @ItemBrandName = (SELECT ItemBrandName FROM MsItemBrand WHERE ItemBrandName LIKE '%' + @Brand + '%')
PRINT 'Brand: ' + @ItemBrandName
PRINT '----------------------------------'
DECLARE Item_Cursor CURSOR FOR
SELECT ItemID,ItemName,ItemStock,ItemPrice FROM MsItem mi JOIN MsItemBrand mb ON mi.ItemBrandID = mb.ItemBrandID WHERE mb.ItemBrandName = @ItemBrandName
OPEN Item_Cursor
FETCH NEXT FROM Item_Cursor INTO @ItemID, @ItemName, @ItemStock, @ItemPrice
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Item ID: ' + @ItemID
	PRINT 'Item Name: ' + @ItemName
	PRINT 'Item Stock: ' + CAST(@ItemStock AS VARCHAR(50))
	PRINT 'Item Price: ' + CAST(@ItemPrice AS VARCHAR(50))
	PRINT '===================================='
FETCH NEXT FROM Item_Cursor INTO @ItemID, @ItemName, @ItemStock, @ItemPrice
END
CLOSE Item_Cursor
DEALLOCATE Item_Cursor
END
END
EXEC SearchItem 'taph'


--NO 10

CREATE PROCEDURE DisplayTransaction @StartingMonth INT, @EndMonth INT, @TransactionYear CHAR (4)
AS
BEGIN
IF @EndMonth - @StartingMonth > 10 
BEGIN
	Print 'The maximum range is 10 months'
END
ELSE IF @EndMonth - @StartingMonth <= 10
BEGIN
	PRINT 'Showing results' + DATENAME(@StartingMonth) + @TransactionYear + 'until' + DATENAME(@EndMonth) + @TransactionYear
