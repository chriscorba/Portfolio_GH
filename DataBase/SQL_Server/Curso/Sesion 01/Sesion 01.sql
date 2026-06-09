-- Ver la version de sql server
SELECT @@VERSION
GO
-- Restaurar Base de Datos
USE master -- Usar primeramente la base de datos de sistema
GO
RESTORE DATABASE AdventureWorks
FROM DISK = N'E:\Practicas\SQL SERVER\C\AdventureWorks2025.bak'
WITH FILE = 1,
MOVE N'AdventureWorks' TO N'E:\Practicas\SQL SERVER\D\AdventureWorks2025.mdf',
MOVE N'AdventureWorks_log' TO N'E:\Practicas\SQL SERVER\E\AdventureWorks2025_log.ldf',
NOUNLOAD,
STATS=5
GO
/*
Mens. 3234, Nivel 16, Estado 2, Línea 7
Logical file 'AdventureWorks2025' is not part of database 'AdventureWorks'. Use RESTORE FILELISTONLY to list the logical file names.
Mens. 3013, Nivel 16, Estado 1, Línea 7
RESTORE DATABASE is terminating abnormally.
*/


-- Verificar la existencia que este el back up
RESTORE FILELISTONLY
FROM DISK = N'E:\Practicas\SQL SERVER\C\AdventureWorks2025.bak'

-- Crear Back Up
BACKUP DATABASE AdventureWorks
TO DISK = N'E:\Practicas\SQL SERVER\E\AdventureWorks2025_Comprimido.bak'
WITH COMPRESSION, INIT
GO
-- Crear nuestra base de datos
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'BD_Cochera')
BEGIN
	ALTER DATABASE BD_Cochera SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE BD_Cochera
END
GO
CREATE DATABASE BD_Cochera
ON PRIMARY (
NAME = 'BD_Cochera',
FILENAME = 'E:\Practicas\SQL SERVER\D\BD_Cochera.mdf',
SIZE=15MB,
MAXSIZE=30MB,
FILEGROWTH=5MB
)
LOG ON (
NAME = 'BD_Cochera_log',
FILENAME = 'E:\Practicas\SQL SERVER\E\BD_Cochera.ldf',
SIZE=5MB,
MAXSIZE=10MB,
FILEGROWTH=10MB
)COLLATE Modern_Spanish_CI_AS
GO
/*
MOSTRAR LAS 10 PRIMERAS PERSONAS
DE LA BASE DE DATOS ADW. DE LA PERSONA
*/
SELECT TOP 10 *
FROM AdventureWorks.Person.Person
ORDER BY BusinessEntityID ASC
GO
/*
MOSTRAR LAS 10 PRIMERAS NOMBRES PERO QUE
ESTEN CONECTADOS SUS NOMBRES Y APELLIDOS
*/
SELECT TOP 10 
		BusinessEntityID,
		FirstName +' '+ MiddleName +' '+ LastName AS NombreCompletos
FROM AdventureWorks.Person.Person
ORDER BY BusinessEntityID ASC
GO
SELECT TOP 10 
		BusinessEntityID,
		CONCAT(FirstName ,' ',
			   MiddleName,' ',
			   LastName) AS NombreCompletos
FROM AdventureWorks.Person.Person
ORDER BY BusinessEntityID ASC
GO
--Separar base de datos de la instancia
sp_detach_db 'BD_Cochera'
GO
sp_detach_db 'AdventureWorks'
GO
-- Adjuntar la Base de Datos
CREATE DATABASE AdventureWorks
ON (FILENAME= N'E:\Practicas\SQL SERVER\D\AdventureWorks2025.mdf'),
   (FILENAME= N'E:\Practicas\SQL SERVER\E\AdventureWorks2025_log.ldf')
FOR ATTACH
GO
CREATE DATABASE BD_Cochera
ON (FILENAME = N'E:\Practicas\SQL SERVER\D\BD_Cochera.mdf'),
   (FILENAME = N'E:\Practicas\SQL SERVER\E\BD_Cochera.ldf')
FOR ATTACH
GO