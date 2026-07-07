/*
 Test Data Script
 Only runs in development environment
 Creates sample data for testing
*/

-- Insert test customers if they don't exist
IF NOT EXISTS (SELECT 1 FROM [dbo].[Customer] WHERE CustomerName = 'Test Customer 1')
BEGIN
	PRINT 'Inserting test customers...';

	INSERT INTO [dbo].[Customer] (CustomerName, Email)
	VALUES 
		('Test Customer 1', 'test1@example.com'),
		('Test Customer 2', 'test2@example.com'),
		('Test Customer 3', 'test3@example.com'),
		('Test Customer 4', 'test4@example.com'),
		('Test Customer 5', 'test5@example.com');

	PRINT 'Test customers inserted.';
END;

-- Insert test orders if they don't exist
IF NOT EXISTS (SELECT 1 FROM [dbo].[Order] WHERE OrderNumber = 'ORD-TEST-001')
BEGIN
	PRINT 'Inserting test orders...';

	DECLARE @CustomerId1 INT = (SELECT TOP 1 CustomerId FROM [dbo].[Customer] WHERE CustomerName = 'Test Customer 1');
	DECLARE @CustomerId2 INT = (SELECT TOP 1 CustomerId FROM [dbo].[Customer] WHERE CustomerName = 'Test Customer 2');

	IF @CustomerId1 IS NOT NULL AND @CustomerId2 IS NOT NULL
	BEGIN
		INSERT INTO [dbo].[Order] (CustomerId, OrderNumber, OrderDate, TotalAmount, Status)
		VALUES 
			(@CustomerId1, 'ORD-TEST-001', GETUTCDATE(), 150.00, 'Completed'),
			(@CustomerId1, 'ORD-TEST-002', GETUTCDATE(), 275.50, 'Pending'),
			(@CustomerId2, 'ORD-TEST-003', GETUTCDATE(), 99.99, 'Completed'),
			(@CustomerId2, 'ORD-TEST-004', GETUTCDATE(), 450.00, 'Shipped');

		PRINT 'Test orders inserted.';
	END;
END;

PRINT 'Test data loaded successfully.';
