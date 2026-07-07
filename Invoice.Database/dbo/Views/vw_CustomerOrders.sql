CREATE VIEW [dbo].[vw_CustomerOrders]
AS
SELECT 
	c.CustomerId,
	c.CustomerName,
	c.Email,
	c.CreatedDate AS CustomerCreatedDate,
	o.OrderId,
	o.OrderNumber,
	o.OrderDate,
	o.TotalAmount,
	o.Status AS OrderStatus
FROM [dbo].[Customer] c
LEFT JOIN [dbo].[Order] o ON c.CustomerId = o.CustomerId;
