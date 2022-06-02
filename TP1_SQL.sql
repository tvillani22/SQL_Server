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
3 - De la tabla [Person].[Contact],muestra todos los registros que se modificaron después del 1/1/2013.
*/
--Modifico año a 2003 porque las modificacines van entre 1997 y 2005 y ordeno para evidenciar
SELECT *
FROM Person.Contact 
WHERE ModifiedDate > '2003-01-01'
ORDER BY ModifiedDate;

/*
4 - De la tabla [Person]. [Address], muestre los nombres de las ciudades sin repetirlos.
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
6 - De la tabla [Sales]. [CreditCard], muestre todas las tarjetas 
con un año de vencimiento anterior al 2018.
*/
-- Reemplazo 2018 por 2006 porque los vencimientos van entre 2005 y 2008
SELECT *
FROM Sales.CreditCard
WHERE ExpYear < '2006';

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
-- Evito notación punto ara no tener que crear una schema.
SELECT *
INTO Test_Tarjetas_vencidas 
FROM Sales.CreditCard   
WHERE ExpYear < '2006';

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
WHERE ExpYear < '2006';

--Verifico
SELECT TOP(5) *
FROM Test_Tarjetas_vencidas
ORDER BY bandera DESC;

--Para eliminarla
DROP TABLE Test_Tarjetas_vencidas;

/*
11 - Crear una vista donde se muestre lo desarrollado en el punto 2
*/


/*
12 - Crear una vista donde se muestren los datos de los empleados cuyo cumpleaños 
sea el dia de "hoy", mostrando la fecha de nacimiento con el formato análogo a “15/11/2021”.
*/


/*
12bis - A partir de la tabla SalesOrderHeader, Crear un Stored Procedure donde 
se muestren el dinero recaudado entre 2 fechas que se ingresaran por parametro.
*/


/*
13 - Traer el nombre de las tablas pertenecientes al esquema Production.
*/


/*
14 - Traer por codigo la query utilizada para crear la vista correspondiente al punto 11.
*/


/*
15 - Traer por interfaz la query utilizada para crear la tabla Person.Contact.
*/


/*
16 - Traer por Codigo la query utilizada para crear la tabla Person.Contact.
*/