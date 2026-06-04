-- verificar si existe el tablespace
SELECT spcname
FROM pg_tablespace
WHERE spcname = 'tsp_restaurante'

-- Eliminar mi tsp_restaurante
DROP TABLESPACE IF EXIST tp_restaurante;

CREATE TABLESPACE ts_Restaurante_Datos
OWNER postgres
LOCATION 'E:\Practicas\Postgres\Tablespace\Restaurante_Datos'

-- Mensaje de creación
SELECT 'TABLESPACE ts_Restaurante_Datos CREADO EXITOSAMENTE' AS Mensaje;

-- Mi tablespace Indice
CREATE TABLESPACE ts_Restaurante_Indices
OWNER postgres
LOCATION 'E:\Practicas\Postgres\Tablespace\Restaurante_Indices';

-- Mi tablespace BackUp
CREATE TABLESPACE ts_Restaurante_BackUp
OWNER postgres
LOCATION 'E:\Practicas\Postgres\Tablespace\Restaurante_BackUp';

-- Creacion de la base de datos
-- VER LA CONFIGURACION DE LAS BASES DE DATOS SEGUN PLANTILLA
SELECT datname,
	   datcollate,
	   datctype
FROM pg_database;

-- ver la configuracion de la base actual
SELECT current_database(),
	   datcollate,
	   datctype
FROM pg_database
WHERE datname = current_database();

-- Tener mas detalle
SELECT collname,
	   collcollate,
	   collctype
FROM pg_collation
ORDER BY collname;

-- Verificar que no exista la base de datos
SELECT 1
FROM pg_database
WHERE datname = 'Restaurante_DB'

-- Crear nuestra base de datos
CREATE DATABASE Restaurante_DB
WITH
	OWNER = postgres
	ENCODING = 'UTF8'
	LC_COLLATE = 'Spanish_Peru.1252'
	LC_CTYPE = 'Spanish_Peru.1252'
	TABLESPACE = ts_Restaurante_Datos
	CONNECTION LIMIT = 100;

-- Verificar las bases de datos
SELECT *
FROM pg_database
WHERE datname = 'restaurante_db' -- postgrest guarda las bases de datos en minusculas por mas que se creen en mayusculas, asi que el llamado debe ser en minusculas

/* Error de que existen usuario conectados*/
SELECT pid,
	   usename,
	   application_name
FROM pg_stat_activity
WHERE datname = 'restaurante_db'

/*Finalizar sesiones activas*/
SELECT pg_terminate_backend(pid)	 
FROM pg_stat_activity
WHERE datname = 'restaurante_db'
AND pid <> pg_backend_pid();

-- Creación de Esquemas
DO $$
BEGIN
	 IF NOT EXISTS (SELECT 1 FROM information_schema.schemata
	 	WHERE schema_name = 'rrhh') THEN
	 	CREATE SCHEMA RRHH AUTHORIZATION postgres;
	 	RAISE NOTICE 'Esquema de RRHH creado exitosamente';
	 ELSE
		RAISE NOTICE 'Esquema de RRHH ya existe';
	 END IF;
END $$

-- Creación de Esquemas Operaciones
DO $$
BEGIN
	 IF NOT EXISTS (SELECT 1 FROM information_schema.schemata
	 	WHERE schema_name = 'operaciones') THEN
	 	CREATE SCHEMA Operaciones AUTHORIZATION postgres;
	 	RAISE NOTICE 'Esquema de Operaciones creado exitosamente';
	 ELSE
		RAISE NOTICE 'Esquema de Operaciones ya existe';
	 END IF;
END $$

-- Creación de Esquemas Inventario
DO $$
BEGIN
	 IF NOT EXISTS (SELECT 1 FROM information_schema.schemata
	 	WHERE schema_name = 'inventario') THEN
	 	CREATE SCHEMA Inventario AUTHORIZATION postgres;
	 	RAISE NOTICE 'Esquema de Inventario creado exitosamente';
	 ELSE
		RAISE NOTICE 'Esquema de Inventario ya existe';
	 END IF;
END $$

-- Pasar tablas de un esquema a otro, por ejemplo pasar la "Tabla 1"de esquema public a otro esquema XXX
ALTER TABLE Public.Tabla1 SET SCHEMA XXX;


-- Creaciòn de Tabla Cargos
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='cargos') THEN
		CREATE TABLE rrhh.cargos
		(
			IdCargo SERIAL PRIMARY KEY,
			NombreCargo VARCHAR(60) NOT NULL UNIQUE,
			Salario_Base DECIMAL(10,2) NOT NULL,
			Descripcion TEXT,
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Cargos Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Cargos Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Sexos
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='sexo') THEN
		CREATE TABLE rrhh.Sexo
		(
			IdSexo SERIAL PRIMARY KEY,
			NombreSexo VARCHAR(60) NOT NULL UNIQUE CHECK(NombreSexo IN('Masculino','Femenino')),
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Sexo Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Sexo Ya Existe';
	END IF;
END $$;

-- Crear nuetro ENUM
CREATE TYPE rrhh.Sexo_Enum AS ENUM('Masculino','Femenino');

-- Creaciòn de Tabla Sexos ENUM
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='sexoenum') THEN
		CREATE TABLE rrhh.SexoEnum
		(
			IdSexo SERIAL PRIMARY KEY,
			NombreSexo rrhh.Sexo_Enum NOT NULL,
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Sexo ENUM Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Sexo ENUM Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Tipos de documentos
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='tipodocumento') THEN
		CREATE TABLE rrhh.TipoDocumento
		(
			IdTipoDocumento SERIAL PRIMARY KEY,
			NombreTipoDocumento VARCHAR(60) NOT NULL UNIQUE,
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Tipo Documento Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Tipo Documento Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Pais
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='pais') THEN
		CREATE TABLE rrhh.Pais
		(
			IdPais SERIAL PRIMARY KEY,
			Descripcion VARCHAR(60) NOT NULL UNIQUE,
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Pais Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Pais Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Departamento
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='departamento') THEN
		CREATE TABLE rrhh.Departamento
		(
			IdDepartamento SERIAL PRIMARY KEY,
			Descripcion VARCHAR(60) NOT NULL UNIQUE,
			IdPais INT REFERENCES rrhh.pais(IdPais),
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Departamento Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Departamento Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Provincia
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='provincia') THEN
		CREATE TABLE rrhh.Provincia
		(
			IdProvincia SERIAL PRIMARY KEY,
			Descripcion VARCHAR(60) NOT NULL UNIQUE,
			IdDepartamento INT REFERENCES rrhh.departamento(IdDepartamento),
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Provincia Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Provincia Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Distrito
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='distrito') THEN
		CREATE TABLE rrhh.Distrito
		(
			IdDistrito SERIAL PRIMARY KEY,
			Descripcion VARCHAR(60) NOT NULL UNIQUE,
			IdProvincia INT REFERENCES rrhh.provincia(IdProvincia),
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Distrito Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Distrito Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Ciudad
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='ciudad') THEN
		CREATE TABLE rrhh.Ciudad
		(
			IdCiudad SERIAL PRIMARY KEY,
			Descripcion VARCHAR(60) NOT NULL UNIQUE,
			IdDistrito INT REFERENCES rrhh.distrito(IdDistrito),
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Ciudad Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Ciudad Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Personas
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='personas') THEN
		CREATE TABLE rrhh.Personas
		(
			IdPersona SERIAL PRIMARY KEY,
			PrimerNombre VARCHAR(60) NOT NULL,
			SegundoNombre VARCHAR(60) NOT NULL,
			ApellidoPaterno VARCHAR(60) NOT NULL,
			ApellidoMaterno VARCHAR(60) NOT NULL,
			IdSexo INT REFERENCES rrhh.sexo(IdSexo),
			IdTipoDocumento INT REFERENCES rrhh.tipodocumento(IdTipoDocumento),
			NumeroDocumento VARCHAR(25),
		    CorreoElectronico VARCHAR(50) CHECK(CorreoElectronico ~*'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
			Telefono VARCHAR(25),
			IdCiudad INT REFERENCES rrhh.ciudad(IdCiudad),
			Direccion VARCHAR(200),
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Cargos Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Cargos Ya Existe';
	END IF;
END $$;


-- Creaciòn de Tabla Empleados
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'rrhh'
		AND  table_name='empleados') THEN
		CREATE TABLE rrhh.Empleados
		(
			IdEmpleados SERIAL PRIMARY KEY,
			IdPersona INT REFERENCES rrhh.Personas(IdPersona),
			FechaContratacion DATE,
			IdCargo INT REFERENCES rrhh.cargos(IdCargo),
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Empleados Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Empleados Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Proveedores
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'inventario'
		AND  table_name='proveedores') THEN
		CREATE TABLE inventario.Proveedores
		(
			IdProveedor SERIAL PRIMARY KEY,
			IdPersona INT REFERENCES rrhh.Personas(IdPersona),
			NombreEmpresa VARCHAR(200) NOT NULL,
			Contacto VARCHAR(150) NOT NULL,
			Telefono VARCHAR(25),
			CorreoElectronico VARCHAR(50) CHECK(CorreoElectronico ~*'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
			IdCiudad INT REFERENCES rrhh.ciudad(IdCiudad),
			Direccion TEXT,			
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Proveedores Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Proveedores Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Categorias
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'inventario'
		AND  table_name='categorias') THEN
		CREATE TABLE inventario.Categorias
		(
			IdCategoria SERIAL PRIMARY KEY,
			Nombrecategoria VARCHAR(60) NOT NULL UNIQUE,
			Descripcion TEXT,			
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Categorias Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Categorias Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Platos
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'inventario'
		AND  table_name='platos') THEN
		CREATE TABLE inventario.Platos
		(
			IdPlato SERIAL PRIMARY KEY,
			NombrePlatos VARCHAR(60) NOT NULL UNIQUE,
			Descripcion TEXT,
			IdCategorias INT REFERENCES inventario.categorias(IdCategoria),
			Precio DECIMAL(10,2)NOT NULL CHECK (Precio >0),
			Costo DECIMAL(10,2)NOT NULL CHECK (Costo >0),
			TiempoPreparacion INT,  -- MINUTOS
			Disponible BOOLEAN DEFAULT TRUE,			
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Platos Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Platos Ya Existe';
	END IF;
END $$;





/* RONALDSHUÑA
- CONFIGURACION EN OTRO EQUIPO
- BACKUP(BASE DATOS)
- BACKUP(TABLESPACES)


*/
