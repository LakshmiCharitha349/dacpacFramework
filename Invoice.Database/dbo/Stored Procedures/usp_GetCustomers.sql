CREATE PROCEDURE [dbo].[usp_GetCustomers]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		CustomerId,
		CustomerName,
		Email,
		CreatedDate,
		ModifiedDate
	FROM [dbo].[Customer]
	ORDER BY CustomerName;
END;
