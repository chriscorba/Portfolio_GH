-- base de datos
/*
Base de datos .- el contenedeor de las tablas, pa. v....
Esquemas.- Sinonimo de base de datos en MySQL
*/
-- CREAR LAS BASE DE DATOS
-- CREAR UNA BASE DE DATOS BIBLIOTECA
CREATE DATABASE Biblioteca;

-- permite utilizar las verificaciones
DROP DATABASE IF EXISTS Biblioteca;
CREATE DATABASE IF NOT EXISTS Biblioteca;

-- BASES DE DATOS CON COLECCION DE DATOS DE NUESTRO SISTEMA OPERATIVO
DROP DATABASE IF EXISTS Biblioteca;
CREATE DATABASE IF NOT EXISTS Biblioteca
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

-- adapte al lenguaje español que estamos usando (español y ingles)
DROP DATABASE IF EXISTS Biblioteca;
CREATE DATABASE IF NOT EXISTS Biblioteca
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- crear una base de datos para produccion
DROP DATABASE IF EXISTS Biblioteca;
CREATE DATABASE IF NOT EXISTS Biblioteca
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci
DEFAULT ENCRYPTION = 'Y';
-- COMMENT'Base de datos principal del sistema de Biblioteca Universitaria';

-- Visualizar la creacion de la base de datos
SHOW CREATE DATABASE Biblioteca;
#'Biblioteca', 'CREATE DATABASE `Biblioteca` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION=\'Y\' */'
 
 /*ESQUEMAS*/
 CREATE SCHEMA IF NOT EXISTS biblioteca;

/*Verificar la base de datos si esta encriptada*/
SELECT SCHEMA_NAME,
	DEFAULT_ENCRYPTION
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME= 'biblioteca';

-- CREAR UNA TABLA libros
-- UTILIZAR LA BASE DE DATOS
USE biblioteca;

-- Crear mi tabla
CREATE TABLE Libro(
Id INT AUTO_INCREMENT PRIMARY KEY,
Titulo VARCHAR(225),
Autor VARCHAR(100),
Contenido TEXT
) ENCRYPTION = 'N';

-- VISUALIZAR LAS TABLAS
SELECT *
FROM Libro;

-- insertar registros
INSERT INTO Libro (Titulo,Autor,Contenido)
VALUES('Curso de MYSQL','Genaro Leonel','Comandos Basicos');

-- Una Tabla de autores
CREATE TABLE Biblioteca.Autores(
IdAutor INT AUTO_INCREMENT PRIMARY KEY,
Nombres VARCHAR (150) NOT NULL,
Apellidos VARCHAR (150) NOT NULL,
FechaNacimiento DATE,
Nacionalidad VARCHAR(100),
FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
Estado BOOLEAN DEFAULT TRUE -- 1 FALSE 0
) ENCRYPTION = 'N';

-- Verificar la Tabla
SELECT *
FROM Biblioteca.Autores;

-- insertar autores
USE Biblioteca;

INSERT INTO Autores(Nombres, Apellidos, FechaNacimiento, Nacionalidad)
VALUES ('Gabriel','Garcia Marquez','1927-06-03','Colombiano'),
       ('Mario','Vargas LLosa','1936-03-28','Peruano'),
       ('Jorge Luis','Borgues','1899-06-28','Argentino'),
       ('Pablo','Neruda','1904-07-12','Chileno'),
       ('Isabel','Allende','1942-07-12','chilena'),
       ('Julio','Cortazar','1914-08-26','Argentino'),
       ('Carlos','Fuentes','1928-11-11','Mexicano');
       
-- Actualizar registros
UPDATE Autores SET Estado=true
WHERE IdAutor=2;
/*22:28:47	UPDATE Autores SET Estado=false	Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.	0.000 sec
*/
-- para poder actualizar varios valores es necesario desactivar la seguridad
SET SQL_SAFE_UPDATES = 0; #PARA INACTIVAR
SET SQL_SAFE_UPDATES = 0; #PARA ACTIVAR

-- Podemos cambiar el Nombre de la Tabla
RENAME TABLE Biblioteca.Autores TO Autor;

-- Visualizar la estructura de la tabla
DESCRIBE Autores;

-- Modificar el tamaño de un campo
-- Nombres varchar(150) se esta cambiando a (300)
ALTER TABLE Autores
MODIFY COLUMN Nombres VARCHAR(300);

-- Cambiar el nombre de la columna
ALTER TABLE Autores
CHANGE COLUMN FechaNacimiento FNacimiento DATE;

-- Insertar nuevos campos
ALTER TABLE Autores
ADD COLUMN Correo VARCHAR(300);

-- Eliminar campo
ALTER TABLE Autores
DROP COLUMN Correo;

-- Eliminar restricciones como FOREIGN KEY
SHOW CREATE TABLE Autores;

ALTER TABLE Autores
DROP FOREIGN KEY fkulibro;

-- Tabla podemos guardar objetos
CREATE TABLE Imagenes(
IdImagenes INT PRIMARY KEY,
Archivo MEDIUMBLOB) ENCRYPTION = 'N';

-- Insertar el Registro
INSERT INTO Imagenes(IdImagenes, Archivo)
VALUES(1, LOAD_FILE ('D:\L4D2.JPG'));

-- Visualizar la Tabala con el Objeto
SELECT * FROM Imagenes;

-- Visualizar la Carpeta Permitida por MYSQL
SHOW VARIABLES LIKE 'secure_file_priv';
/*'secure_file_priv', 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\'
*/

INSERT INTO Imagenes(IdImagenes, Archivo)
VALUES(2, LOAD_FILE ('C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\L4D2.JPG'));

INSERT INTO Imagenes(IdImagenes, Archivo)
VALUES(3, LOAD_FILE ('C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\L4D2.JPG')); #Aqui recien aparece en BLOB

-- Visualizar la Tabala con el Objeto
SELECT * FROM Imagenes;

-- Verificar existencia de archivo
SELECT LENGTH (LOAD_FILE('C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\L4D2.JPG'));