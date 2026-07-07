CREATE TABLE [dbo].[Order]
(
	[OrderId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[CustomerId] INT NOT NULL,
	[OrderNumber] NVARCHAR(50) NOT NULL,
	[OrderDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
	[TotalAmount] DECIMAL(18,2) NOT NULL DEFAULT 0,
	[Status] NVARCHAR(20) NOT NULL DEFAULT 'Pending',
	CONSTRAINT [FK_Order_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer]([CustomerId])
);
