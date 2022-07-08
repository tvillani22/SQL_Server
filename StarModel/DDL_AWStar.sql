USE master
DROP DATABASE IF EXISTS AW_Star
GO
CREATE DATABASE AW_star
GO
USE AW_star
GO
--DROP SCHEMA IF EXISTS Star
--GO
--CREATE SCHEMA Star
--GO

----------------------------------FUNCTIONS------------------------------------
CREATE FUNCTION [dbo].[ufnLeadingZeros](
    @Value int
) 
RETURNS varchar(8) 
WITH SCHEMABINDING 
AS 
BEGIN
    DECLARE @ReturnValue varchar(8);
    SET @ReturnValue = CONVERT(varchar(8), @Value);
    SET @ReturnValue = REPLICATE('0', 8 - DATALENGTH(@ReturnValue)) + @ReturnValue;
    RETURN (@ReturnValue);
END;
GO


----------------------------------TYPES------------------------------------
CREATE TYPE [dbo].[AccountNumber] FROM [nvarchar](15) NULL
CREATE TYPE [dbo].[Flag] FROM [bit] NOT NULL
CREATE TYPE [dbo].[Name] FROM [nvarchar](50) NULL
CREATE TYPE [dbo].[OrderNumber] FROM [nvarchar](25) NULL
GO

----------------------------------DIM TABLES------------------------------------
CREATE TABLE DimSalesPerson(
	[SalesPersonID] [int] NOT NULL,
	[FirstName] [dbo].[Name] NOT NULL,
	[MiddleName] [dbo].[Name] NULL,
	[LastName] [dbo].[Name] NOT NULL,
	[TerritoryName] [dbo].[Name] NOT NULL,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[Group] [nvarchar](50) NOT NULL,
	[SalesQuota] [money] NULL,
	[Bonus] [money] NOT NULL,
	[CommissionPct] [smallmoney] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SalesPerson_SalesPersonID] PRIMARY KEY CLUSTERED 
(
	[SalesPersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE DimProduct(
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] BIT NOT NULL,
	[FinishedGoodsFlag] BIT NOT NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductCategoryName] [dbo].[Name] NOT NULL,
    [ProductSubcategoryName] [dbo].[Name] NOT NULL,
	[ProductModelName] [dbo].[Name] NOT NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE DimSalesTerritory(
	[TerritoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] varchar(50) NOT NULL,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[Group] [nvarchar](50) NOT NULL,
	[CostYTD] [money] NOT NULL,
	[CostLastYear] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SalesTerritory_TerritoryID] PRIMARY KEY CLUSTERED 
(
	[TerritoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE DimShipMethod(
	[ShipMethodID] [int] IDENTITY(1,1) NOT NULL,
	[Name] varchar(50) NOT NULL,
	[ShipBase] [money] NOT NULL,
	[ShipRate] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ShipMethod_ShipMethodID] PRIMARY KEY CLUSTERED 
(
	[ShipMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE DimSpecialOffer(
	[SpecialOfferID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[DiscountPct] [smallmoney] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[MinQty] [int] NOT NULL,
	[MaxQty] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SpecialOffer_SpecialOfferID] PRIMARY KEY CLUSTERED 
(
	[SpecialOfferID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE DimAddress(
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateProvinceName] [varchar](50) NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE DimCreditCard(
	[CreditCardID] [int] IDENTITY(1,1) NOT NULL,
	[CardType] [nvarchar](50) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CreditCard_CreditCardID] PRIMARY KEY CLUSTERED 
(
	[CreditCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE DimCustomer(
    [CustomerID_ContactID] [int] NOT NULL, --IDENTITY(1,1) 
	[CustomerID] [int]  NOT NULL,
    --[AccountNumber]  AS (isnull('AW'+[dbo].[ufnLeadingZeros]([CustomerID]),'')),
	[CustomerType] [nchar](1) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_DimCustome] PRIMARY KEY CLUSTERED 
(
	CustomerID_ContactID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


--DATE TABLE
DROP TABLE IF EXISTS DimDate
CREATE TABLE DimDate(
	[Date] [datetime] NOT NULL,
	[Year] [int] NOT NULL,
	[MonthNumber] [tinyint]  NOT NULL,
    [MonthNameShort] [nvarchar](3) NOT NULL,
	[MonthNameLong] [nvarchar](20) NOT NULL,
    [Day] [nvarchar](10)  NOT NULL,
	[DayOfWeek] [int]  NOT NULL,
    [Quarter] [tinyint]  NOT NULL,
    [Week] [tinyint]  NOT NULL,
 CONSTRAINT [PK_DimCustomer] PRIMARY KEY CLUSTERED 
(
	Date ASC
)
)
GO

----------------------------------FACT TABLE------------------------------------
CREATE TABLE [FactSalesOrderDetail](
    [SalesOrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[SalesOrderID] [int] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL DEFAULT ((0)),	
	[OrderDate] [datetime] NOT NULL DEFAULT (getdate()),
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL DEFAULT ((1)),
	[OnlineOrderFlag] [dbo].[Flag] NOT NULL  DEFAULT ((1)),
	[SalesOrderNumber]  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')),
	[PurchaseOrderNumber] [dbo].[OrderNumber] NULL,
	[AccountNumber] [dbo].[AccountNumber] NULL,    
    [CustomerID_ContactID] [int] NOT NULL,    
    [SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[TaxAmt] [money] NOT NULL DEFAULT ((0.00)),
	[Freight] [money] NOT NULL DEFAULT ((0.00)),
	[Comment] [nvarchar](128) NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[OrderQty] [smallint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SpecialOfferID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitPriceDiscount] [money] NOT NULL DEFAULT ((0.0)),
	[LineTotal]  AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
    [LineTotalRaw] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL  DEFAULT (getdate()),
 CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID] PRIMARY KEY CLUSTERED 
(
	[SalesOrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--FOREIGN KEY CONSTRAINTS
ALTER TABLE [FactSalesOrderDetail] WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimAddress_BillToAddressID] FOREIGN KEY([BillToAddressID])
REFERENCES [DimAddress] ([AddressID])
GO

ALTER TABLE [FactSalesOrderDetail] WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimAddress_ShipToAddressID] FOREIGN KEY([ShipToAddressID])
REFERENCES [DimAddress] ([AddressID])
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimCreditCard_CreditCardID] FOREIGN KEY([CreditCardID])
REFERENCES [DimCreditCard] ([CreditCardID])
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimCustomer_CustomerID_ContactID] FOREIGN KEY([CustomerID_ContactID])
REFERENCES [DimCustomer] ([CustomerID_ContactID])
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimSalesPerson_SalesPersonID] FOREIGN KEY([SalesPersonID])
REFERENCES [DimSalesPerson] ([SalesPersonID])
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimSalesTerritory_TerritoryID] FOREIGN KEY([TerritoryID])
REFERENCES [DimSalesTerritory] ([TerritoryID])
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimShipMethod_ShipMethodID] FOREIGN KEY([ShipMethodID])
REFERENCES [DimShipMethod] ([ShipMethodID])
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimSpecialOffer_SpecialOfferID] FOREIGN KEY([SpecialOfferID])
REFERENCES [DimSpecialOffer] ([SpecialOfferID])
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimProduct_ProductID] FOREIGN KEY([ProductID])
REFERENCES [DimProduct] ([ProductID])
GO


ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimDate_OrderDate] FOREIGN KEY([OrderDate])
REFERENCES [DimDate] ([Date])
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimDate_DueDate] FOREIGN KEY([DueDate])
REFERENCES [DimDate] ([Date])
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [FK_FactSalesOrderDetail_DimDate_ShipDate] FOREIGN KEY([ShipDate])
REFERENCES [DimDate] ([Date])
GO


--CHECK CONSTRAINTS
ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [CK_FactSalesOrderDetail_DueDate] CHECK  (([DueDate]>=[OrderDate]))
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD CONSTRAINT [CK_FactSalesOrderDetail_Freight] CHECK (([Freight]>=(0.00)))
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_FactSalesOrderDetail_ShipDate] CHECK (([ShipDate]>=[OrderDate] OR [ShipDate] IS NULL))
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_FactSalesOrderDetail_Status] CHECK (([Status]>=(0) AND [Status]<=(8)))
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_FactSalesOrderDetail_TaxAmt] CHECK  (([TaxAmt]>=(0.00)))
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderDetail_OrderQty] CHECK  (([OrderQty]>(0)))
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderDetail_UnitPrice] CHECK  (([UnitPrice]>=(0.00)))
GO

ALTER TABLE [FactSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount] CHECK  (([UnitPriceDiscount]>=(0.00)))
GO


----------------------------------FLAG TABLE------------------------------------
CREATE TABLE UpdateRuns(
	[UpdateID] [int] IDENTITY(1,1) NOT NULL,
	[UpdateDate] [datetime] NOT NULL
)