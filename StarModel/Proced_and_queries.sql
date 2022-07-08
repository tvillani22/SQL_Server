--PROCEDURE DE ACTUALIZACION DE FLAG (COMUN A TODAS)
CREATE PROCEDURE UpdateFlag    
    @LastModified_new  date   
AS
BEGIN
INSERT INTO UpdateRuns
values (@LastModified_new)
END

---------------------------------------------------

---------------------------------TABLA DIMCUSTOMER------------------------------
--VERSION 1
-----DEL LADO DE SOURCE: query en la GUI de source tab en copy activity de ADF

/*
--RawQuery
SELECT CHECKSUM(CONCAT(cus.CustomerID, ContactID))  AS CustomerID_ContactID, cus.CustomerID, CustomerType, Name, cus.ModifiedDate
FROM Sales.Customer cus
JOIN Sales.Store sto
	 ON cus.CustomerID = sto.CustomerID
JOIN Sales.StoreContact sco
	ON sco.CustomerID = sto.CustomerID
WHERE cus.ModifiedDate >= '2000-01-01' AND cus.ModifiedDate < '2004-06-01'
*/

@concat(
'SELECT CHECKSUM(CONCAT(cus.CustomerID, ContactID)) AS CustomerID_ContactID, cus.CustomerID, CustomerType, Name, cus.ModifiedDate
FROM Sales.Customer cus
JOIN Sales.Store sto
	 ON cus.CustomerID = sto.CustomerID
JOIN Sales.StoreContact sco
	ON sco.CustomerID = sto.CustomerID
WHERE cus.ModifiedDate >= ''',
activity('Retrieve last update date').output.firstRow.update_date,
''' AND cus.ModifiedDate < ''',
pipeline().parameters.update_until,
'''' 
)

-----DEL LADO DE SINK: en la GUI de sink tab en copy activity de ADF usando upsert y mapping trivial

---------------------------------
--VERSION 2
-----DEL LADO DE SOURCE: StoredProcedure en DB SOURCE
CREATE PROCEDURE UpdateDimCustomer 
    @LastModified_old date,   
    @LastModified_new  date   
AS
BEGIN
SELECT CHECKSUM(CONCAT(cus.CustomerID, ContactID))  AS CustomerID_ContactID, cus.CustomerID, CustomerType, Name, cus.ModifiedDate
FROM Sales.Customer cus
JOIN Sales.Store sto
	 ON cus.CustomerID = sto.CustomerID
JOIN Sales.StoreContact sco
	ON sco.CustomerID = sto.CustomerID
WHERE cus.ModifiedDate >= @LastModified_old AND cus.ModifiedDate < @LastModified_new
END


-----DEL LADO DE SOURCE: TableType mimmicking lo que viene de source y StoredProcedure en DB SINK
CREATE TYPE  sourcetype AS TABLE(
	[CustomerID_ContactID] [int],
	[CustomerID] [int],
	[CustomerType] [nchar](1),
	[Name] [nvarchar](100),
	[ModifiedDate] [datetime] 
)

CREATE PROCEDURE UpdateDimCustomer (@source sourcetype READONLY)
AS
BEGIN
MERGE [dbo].[DimCustomer] AS target
USING @source  AS source
ON (target.CustomerID_ContactID = source.CustomerID_ContactID)
WHEN MATCHED THEN
    UPDATE SET CustomerID = source.CustomerID, CustomerType = source.CustomerType, Name = source.Name, ModifiedDate = source.ModifiedDate
WHEN NOT MATCHED THEN
    INSERT 
    VALUES (source.CustomerID_ContactID, source.CustomerID, source.CustomerType, source.Name, source.ModifiedDate);
END

---------------------------------TABLA DIMXXX---------------------------