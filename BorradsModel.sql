CREATE PROCEDURE UpdateDW 
    @LastModified_old date,   
    @LastModified_new  date   
AS   
    SELECT *
    FROM <Placeholder for table name> 
    WHERE ModifiedDate >= @LastModified_old AND ModifiedDate < @LastModified_new




GO  

Data Source=DESKTOP-ADS10L2\SQLEXPRESS;Initial Catalog=AW_star;Integrated Security=False;User ID=pi2;Password=pi_SQL_server0

Data Source=DESKTOP-ADS10L2\SQLEXPRESS;Initial Catalog=AW_star;Integrated Security=False;User ID=pi2;Password=pi_SQL_server0

Data Source=DESKTOP-ADS10L2\SQLEXPRESS;Initial Catalog=AdventureWorks;Integrated Security=False;User ID=pi2;Password=pi_SQL_server0


MERGE Production.UnitMeasure AS target
USING (SELECT @UnitMeasureCode, @Name) AS source (UnitMeasureCode, Name)
ON (target.UnitMeasureCode = source.UnitMeasureCode)
WHEN MATCHED THEN 
    UPDATE SET Name = source.Name
WHEN NOT MATCHED THEN   
    INSERT (UnitMeasureCode, Name)
    VALUES (source.UnitMeasureCode, source.Name)
    OUTPUT deleted.*, $action, inserted.* INTO #MyTempTable;


@CONCAT('SELECT *
FROM Production.Product
WHERE ModifiedDate >= ',
activity('Retrieve last update date').output.value,
' AND ModifiedDate < ',
pipeline().parameters.update_until
)

CREATE PROCEDURE UpdateProcedure @Marketing [Production].[Product]
AS
BEGIN
MERGE [dbo].[DimProduct] AS target
USING @Marketing AS source
ON (target.ProductID = source.ProductID)
WHEN MATCHED THEN
    UPDATE SET Name = source.Name
WHEN NOT MATCHED THEN
    INSERT (ProductID, ProductNumber)
    VALUES (source.ProfileID, source.ProductNumber);
END









CREATE PROCEDURE spOverwriteMarketing @Marketing [dbo].[MarketingType] READONLY, @category varchar(256)
AS
BEGIN
MERGE [dbo].[Marketing] AS target
USING @Marketing AS source
ON (target.ProfileID = source.ProfileID and target.Category = @category)
WHEN MATCHED THEN
    UPDATE SET State = source.State
WHEN NOT MATCHED THEN
    INSERT (ProfileID, State, Category)
    VALUES (source.ProfileID, source.State, source.Category);
END


@activity('Retrieve last update date').output.value[0].last_update_row


@CONCAT('SELECT *
FROM Production.Product
WHERE ModifiedDate >= ',
activity('Retrieve last update date').output.value[0].last_update_row,
' AND ModifiedDate < ',
pipeline().parameters.update_until
)




CREATE PROCEDURE UpdateCreditCard
    @LastModified_old date,   
    @LastModified_new  date    
AS
BEGIN
SELECT CreditCardID, CardType, ModifiedDate
FROM Sales.CreditCard 
WHERE ModifiedDate >= @LastModified_old AND ModifiedDate < @LastModified_new
END








