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
--Modifico año a 2003 porque las modificacines van entre 1997 y 2005
SELECT *
FROM Person.Contact 
WHERE ModifiedDate > '01-01-2003';

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