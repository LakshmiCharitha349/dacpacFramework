CREATE PROCEDURE [dbo].[usp_UpdateCustomer]
	@CustomerId INT,
	@CustomerName NVARCHAR(100),
	@Email NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[Customer]
	SET 
		CustomerName = @CustomerName,
		Email = @Email,
		ModifiedDate = GETUTCDATE()
	WHERE CustomerId = @CustomerId;

	SELECT @@ROWCOUNT AS RowsAffected;
END;
