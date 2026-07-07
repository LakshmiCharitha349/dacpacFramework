CREATE PROCEDURE [dbo].[usp_InsertCustomer]
	@CustomerName NVARCHAR(100),
	@Email NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[Customer] (CustomerName, Email)
	VALUES (@CustomerName, @Email);

	SELECT SCOPE_IDENTITY() AS CustomerId;
END;
