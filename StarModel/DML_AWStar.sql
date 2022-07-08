USE AW_star
GO
-------------------------------------------------------------------------------
--PRELIMINAR LOADS

--Date Table
DECLARE @startdate date, @enddate date
SET @startdate = '2001-01-01'
SET @enddate = '2004-12-31'

WHILE @startdate <= @enddate
    BEGIN
        INSERT INTO DimDate --(Date, Year, Month, MonthNameShort, MonthNameLong,Day, DayOfWeek, Quarter, Week)
            SELECT @startdate, YEAR(@startdate),  MONTH(@startdate),
			SUBSTRING(DATENAME(month, @startdate),1,3), DATENAME(month, @startdate), DAY(@startdate), DATEPART(weekday, @startdate),  DATEPART(quarter, @startdate), DATEPART(week, @startdate)
        SET @startdate = DATEADD(dd, 1, @startdate)
    END
GO

--Initial Flag
INSERT INTO UpdateRuns
SELECT '2000-01-01'

--Dim Dummies
INSERT INTO DimDate
VALUES ( '1900-01-01', YEAR('1900-01-01'),  MONTH('1900-01-01'),
		SUBSTRING(DATENAME(month, '1900-01-01'),1,3), DATENAME(month, '1900-01-01'), DAY('1900-01-01'), DATEPART(weekday, '1900-01-01'),  DATEPART(quarter, '1900-01-01'), DATEPART(week, '1900-01-01') )

INSERT INTO DimSalesPerson
VALUES (0, 'unassigned', ' ', ' ', ' ', ' ', ' ', 0, 0, 0, '1900-01-01')

INSERT INTO DimProduct
VALUES ('unassigned', ' ', 0, 0, ' ', 0, 0, 0, 0, ' ', ' ', ' ', 0.0, 0,
        ' ', ' ', ' ', ' ', ' ', ' ', '1900-01-01', '1900-01-01', '1900-01-01', '1900-01-01')

INSERT INTO DimSalesTerritory
VALUES ('unassigned', ' ', ' ', 0, 0, '1900-01-01')

INSERT INTO DimShipMethod
VALUES ('unassigned', 0, 0, '1900-01-01')

INSERT INTO DimSpecialOffer 
VALUES ('unassigned', 0, ' ', ' ', '1900-01-01', 
        '1900-01-01', 0, 0, '1900-01-01')

INSERT INTO DimAddress
VALUES ('unassigned', ' ', ' ', ' ', '1900-01-01')

INSERT INTO DimCreditCard
VALUES ('unassigned', '1900-01-01')

INSERT INTO DimCustomer
VALUES (0, 0, ' ', ' ', '1900-01-01')
GO