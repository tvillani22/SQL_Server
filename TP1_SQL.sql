/* 1. De la tabla [Person].[Contact], mostrar todos los datos de la tabla, ordenando por Apellido ascendente,
y nombre descendente */
SELECT *
FROM Person.Contact
ORDER BY LastName, FirstName DESC;


/* 2.  De la tabla [Person].[Contact], muestre los nombres de las personas que comienzan con 'D'
o que comienzan con "A", ordenado alfabéticamente. */
SELECT pc.FirstName
FROM Person.Contact AS pc
WHERE pc.FirstName LIKE 'D%' OR pc.FirstName LIKE 'A%'
ORDER BY 1;

/*
3 - De la tabla [Person].[Contact], muestra todos los registros que se modificaron después del 1/1/2013.
*/
--Modifico año a 2003 porque las modificaciones van entre 1997 y 2005 y ordeno para evidenciar
SELECT *
FROM Person.Contact 
WHERE ModifiedDate > '2003-01-01'
ORDER BY ModifiedDate;

/*
4 - De la tabla [Person].[Address], muestre los nombres de las ciudades sin repetirlos.
*/
SELECT DISTINCT City 
FROM Person.Address;

/*
5 - Mostrar la cantidad de ventas que se realizaron con cada tipo de tarjetas de credito 
(se deben trabajar las tablas SalesOrderHeader y CreditCard).
*/
SELECT cc.CardType, COUNT(*) AS cantidad_ventas
FROM Sales.SalesOrderHeader soh
JOIN Sales.CreditCard cc
    ON  soh.CreditCardID = cc.CreditCardID
GROUP BY cc.CardType;

-- Verifico que coincide con el total de ventas con tarjeta y que hay ventas sin tarjeta
SELECT COUNT(*) num_vtas_con_tarjeta
FROM  Sales.SalesOrderHeader
WHERE CreditCardID IS NOT NULL;

SELECT COUNT(*) num_vtas_sin_tarjeta
FROM  Sales.SalesOrderHeader
WHERE CreditCardID IS NULL;

SELECT COUNT(*) num_vtas_total
FROM  Sales.SalesOrderHeader;

/*
6 - De la tabla [Sales].[CreditCard], muestre todas las tarjetas 
con un año de vencimiento anterior al 2018.
*/
-- Reemplazo 2018 por 2006 porque los vencimientos van entre 2005 y 2008
SELECT *
FROM Sales.CreditCard
WHERE ExpYear < 2006;

/*
7 - Traer de la tabla Person.Contact los datos de contacto de todos los que NO son empleados 
(HumanResources.Employee)
*/
SELECT pc.*
FROM Person.Contact pc
LEFT JOIN HumanResources.Employee hre
    ON pc.ContactID = hre.ContactID
WHERE hre.ContactID IS NULL;

/*
8 - Crear una tabla [Test].[Tarjetas_vencidas] y cargar en la misma el resultado de la consulta 7
*/
-- Asumo que se refiere a la consulta 6
-- Evito notación punto para no tener que crear una schema.
SELECT *
INTO Test_Tarjetas_vencidas 
FROM Sales.CreditCard   
WHERE ExpYear < 2006;

--Verifico
SELECT TOP(5) *
FROM Test_Tarjetas_vencidas;

/*
9 - En la tabla [Test].[Tarjetas_vencidas] crear una nueva columna "bandera" con tipo int.
*/
-- Uso 0 como valor default
ALTER TABLE Test_Tarjetas_vencidas ADD bandera INT NOT NULL DEFAULT(0);

--Verifico
SELECT TOP(5) *
FROM Test_Tarjetas_vencidas;

/*
10 - Actualizar la tabla Test.Tarjetas_vencidas y dar valor 1 a la columna "bandera" 
cuando el vencimiento anterior del año 2015.
*/
--Elijo 2006 en lugar de 2015 porque los vencimientos van entre 2005 y 2008
UPDATE Test_Tarjetas_vencidas
SET bandera = 1
WHERE ExpYear < 2006;

--Verifico
SELECT TOP(5) *
FROM Test_Tarjetas_vencidas
ORDER BY bandera DESC;

--Para eliminarla
DROP TABLE Test_Tarjetas_vencidas
GO;

/*
11 - Crear una vista donde se muestre lo desarrollado en el punto 2
*/
CREATE VIEW test_view
AS SELECT pc.FirstName
FROM person.Contact AS pc
WHERE pc.FirstName LIKE 'D%' or pc.FirstName LIKE 'A%'
GO;

--Chequeo que está
SELECT TOP(5) *
FROM test_view;

--Para eliminarla
DROP VIEW IF EXISTS test_view
GO;

/*
12 - Crear una vista donde se muestren los datos de los empleados cuyo cumpleaños 
sea el dia de "hoy", mostrando la fecha de nacimiento con el formato análogo a “15/11/2021”.
*/
CREATE VIEW birthday_view AS
SELECT FORMAT(hre.BirthDate, 'dd/MM/yyyy') AS BirthDate, pc.*
FROM HumanResources.Employee hre
JOIN Person.Contact pc
      ON pc.ContactID = hre.ContactID
WHERE (MONTH(hre.BirthDate) = MONTH(GETDATE()) AND DAY(hre.BirthDate) = DAY(GETDATE())) OR
      (FORMAT(hre.BirthDate, 'dd/MM') = '29/02' AND FORMAT(GETDATE(), 'dd/MM') = '01/03')
GO;

--Verifico
SELECT *
FROM birthday_view;

--Para eliminarla
DROP VIEW IF EXISTS birthday_view
GO;

/*
12bis - A partir de la tabla SalesOrderHeader, Crear un Stored Procedure donde 
se muestren el dinero recaudado entre 2 fechas que se ingresaran por parametro.
*/
CREATE PROCEDURE GetRevenueTest
    @BeginDate date,   
    @EndDate date   
AS    
    SELECT SUM(TotalDue) ingresos
    FROM Sales.SalesOrderHeader
    WHERE OrderDate BETWEEN @BeginDate AND @EndDate
GO;

-- Ejecuto
EXECUTE GetRevenueTest @BeginDate = N'2002-03-01', @EndDate = N'2003-03-01';
-- o
--EXECUTE GetRevenueTest N'2002-03-01', N'2003-03-01';

-- Para eliminarlo
DROP  PROCEDURE IF EXISTS  GetRevenueTest;


/*
13 - Traer el nombre de las tablas pertenecientes al esquema Production.
*/
-- Incluyendo views
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Production'
ORDER BY TABLE_NAME;

-- Sin incluir views
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Production' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Alternativa 2 (query a sys.tables y usando function schema_name, no incluye views)
SELECT schema_name(schema_id) AS schema_name, name AS table_name
FROM sys.tables
WHERE schema_name(schema_id) = 'Production'
ORDER BY table_name;


/*
14 - Traer por codigo la query utilizada para crear la vista correspondiente al punto 11.
*/
sp_helptext 'dbo.test_view';

/*
15 - Traer por interfaz la query utilizada para crear la tabla Person.Contact.

En Azure Data Studio:(el usado) Abriendo el panel de servers sobre la izquierda de la pantalla,
desplegando el server actual, el directorio `Tables`, haciendo click derecho sobre `Person.Contact`
y seleccionando `Script as Create` me abre un archivo `.sql` con el `CREATE` statement
correspondiente a esa tabla.

En SQL Server Management Studio: Acá una explicación con las imágenes de la GUI: 
https://docs.microsoft.com/en-us/sql/ssms/scripting/generate-scripts-sql-server-management-studio?view=sql-server-ver16).
*/

/*
16 - Traer por Codigo la query utilizada para crear la tabla Person.Contact.

Entiendo que no hay análogo a la herramienta sp_helptext para tablas...
(https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-helptext-transact-sql?view=sql-server-ver16) 
...y que hay algunos objetos de SQL Server para los cuales se puede obtener el script vía T-SQL y otros para los que no, en cuyo caso se puede
armar algo específico con SQL Server Management Objects Framework (aka SMO).
*/