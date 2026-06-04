-- Creaciòn de Tabla Insumos
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'inventario'
		AND  table_name='Insumos') THEN
		CREATE TABLE inventario.Insumos
		(
			IdInsumo SERIAL PRIMARY KEY,
			NombreInsumo VARCHAR(60) NOT NULL UNIQUE,
		    IdProveedor INT REFERENCES inventario.Proveedores(IdProveedor),
			UnidadMedida VARCHAR(20) NOT NULL, --KG,LITROS, UNIDADES, PAQUETES, ETC
			StockActual DECIMAL(10,2) DEFAULT 0,
			StockMinimo DECIMAL(10,2) DEFAULT 0,
			PrecioUnitario DECIMAL(10,2) DEFAULT 0,
			FechaUltimaCompra DATE,
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Insumos Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Insumos Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Mesas
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'operaciones'
		AND  table_name='mesas') THEN
		CREATE TABLE operaciones.Mesas
		(
			IdMesa SERIAL PRIMARY KEY,
			NombreMesa VARCHAR(60) NOT NULL UNIQUE,
		    Capacidad INT NOT NULL CHECK(Capacidad >0),
			Ubicacion VARCHAR(60) NOT NULL, 
			EstadoMesa VARCHAR(30) DEFAULT 'Disponible',
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Mesas Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Mesas Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Clientes
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'operaciones'
		AND  table_name='clientes') THEN
		CREATE TABLE operaciones.Clientes
		(
			IdCliente SERIAL PRIMARY KEY,
			IdPersona INT REFERENCES rrhh.Personas(IdPersona),
			VisitasTotales INT DEFAULT 0,
			ClienteVip BOOL DEFAULT FALSE,
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Mesas Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Mesas Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Ventas
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'operaciones'
		AND  table_name='ventas') THEN
		CREATE TABLE operaciones.Ventas
		(
			IdVenta SERIAL PRIMARY KEY,
			IdPersona INT REFERENCES rrhh.Personas(IdPersona),
			IdCliente INT REFERENCES operaciones.Clientes(IdCliente),
			IdMesa INT REFERENCES operaciones.Mesas(IdMesa),
			IdEmpleado INT REFERENCES rrhh.Empleados(IdEmpleados),
			FechaVenta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			SubTotal DECIMAL(10,2) DEFAULT 0,
			Descuento DECIMAL(10,2) DEFAULT 0,
			Impuesto DECIMAL(10,2) DEFAULT 0,
			MetodoPago VARCHAR(25) DEFAULT 'Efectivo',
			EstadoPago VARCHAR(25) DEFAULT 'Completada',
			Observacion TEXT,
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Mesas Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Mesas Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Ventas Detalles
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'operaciones'
		AND  table_name='ventasDetalle') THEN
		CREATE TABLE operaciones.VentasDetalle
		(
			IdVentasDetalle SERIAL PRIMARY KEY,
			IdVenta INT REFERENCES operaciones.Ventas(IdVenta),
			IdPlato INT REFERENCES inventario.Platos(IdPlato),
			Cantidad INT NOT NULL CHECK(Cantidad > 0),
			PrecioUnitario DECIMAL(10,2),
			SubTotal DECIMAL(10,2) GENERATED ALWAYS AS (Cantidad * PrecioUnitario) STORED,
			Notas TEXT,
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Ventas Detalle Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Ventas Detalle Ya Existe';
	END IF;
END $$;

-- Creaciòn de Tabla Reservas
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables
		WHERE table_schema = 'operaciones'
		AND  table_name='reservas') THEN
		CREATE TABLE operaciones.Reservas
		(
			IdReserva SERIAL PRIMARY KEY,
			IdCliente INT REFERENCES operaciones.Clientes(IdCliente),
			IdMesa INT REFERENCES operaciones.Mesas(IdMesa),
			FechaReserva DATE NOT NULL,
			HoraReserva TIME NOT NULL,
			NumPersonas INT NOT NULL,
			EstadoReservas VARCHAR(30) DEFAULT 'Confirmada',
			Notas TEXT,
			Estado BOOLEAN DEFAULT TRUE,			
			FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		) TABLESPACE ts_Restaurante_Datos;
				
		RAISE NOTICE 'Tabla Reservas Creado Exitosamente';
	ELSE
		RAISE NOTICE 'Tabla Reservas Ya Existe';
	END IF;
END $$;

-- Crear Indices en tablespace dedicado ---------------------------------------------------------------------------
DO $$
BEGIN
IF NOT EXISTS (SELECT 1 FROM pg_indexes
			   WHERE indexname='idx_Empleado_Cargo') THEN 	   
	CREATE INDEX idx_Empleado_Cargo ON rrhh.Empleados(IdCargo)
	TABLESPACE ts_Restaurante_Indices;
	RAISE NOTICE 'Indice idx_Empleado_Cargo Creado Exitosamente';
END IF;

IF NOT EXISTS (SELECT 1 FROM pg_indexes
			   WHERE indexname='idx_Empleado_Activo') THEN 	   
	CREATE INDEX idx_Empleado_Activo ON rrhh.Empleados(Estado)
	TABLESPACE ts_Restaurante_Indices;
	RAISE NOTICE 'Indice idx_Empleado_Activo Creado Exitosamente';
END IF;
END $$;

-- Crear Indices en tablespace dedicado
DO $$
BEGIN
IF NOT EXISTS (SELECT 1 FROM pg_indexes
			   WHERE indexname='idx_Platos_Categoria') THEN 	   
	CREATE INDEX idx_Platos_Categoria ON inventario.Platos(IdCategorias)
	TABLESPACE ts_Restaurante_Indices;
	RAISE NOTICE 'Indice idx_Platos_Categoria Creado Exitosamente';
END IF;

IF NOT EXISTS (SELECT 1 FROM pg_indexes
			   WHERE indexname='idx_Platos_Disponible') THEN 	   
	CREATE INDEX idx_Platos_Disponible ON inventario.Platos(Disponible)
	TABLESPACE ts_Restaurante_Indices;
	RAISE NOTICE 'Indice idx_Platos_Disponible Creado Exitosamente';
END IF;
END $$;

-- Crear Indices en tablespace dedicado
DO $$
BEGIN
IF NOT EXISTS (SELECT 1 FROM pg_indexes
			   WHERE indexname='idx_Ventas_Fecha') THEN 	   
	CREATE INDEX idx_Ventas_Fecha ON operaciones.Ventas(FechaVenta)
	TABLESPACE ts_Restaurante_Indices;
	RAISE NOTICE 'Indice idx_Platos_Categoria Creado Exitosamente';
END IF;

IF NOT EXISTS (SELECT 1 FROM pg_indexes
			   WHERE indexname='idx_Ventas_Cliente') THEN 	   
	CREATE INDEX idx_Ventas_Cliente ON operaciones.Ventas(IdCliente)
	TABLESPACE ts_Restaurante_Indices;
	RAISE NOTICE 'Indice idx_Ventas_Cliente Creado Exitosamente';
END IF;
END $$;

-- Crear Indices en tablespace dedicado
DO $$
BEGIN
IF NOT EXISTS (SELECT 1 FROM pg_indexes
			   WHERE indexname='idx_Venta_Detalle_Venta') THEN 	   
	CREATE INDEX idx_Venta_Detalle_Venta ON operaciones.VentasDetalle(IdVenta)
	TABLESPACE ts_Restaurante_Indices;
	RAISE NOTICE 'Indice idx_Venta_Detalle_Venta Creado Exitosamente';
END IF;

IF NOT EXISTS (SELECT 1 FROM pg_indexes
			   WHERE indexname='idx_Ventas_Detalle_Plato') THEN 	   
	CREATE INDEX idx_Ventas_Detalle_Plato ON operaciones.VentasDetalle(IdPlato)
	TABLESPACE ts_Restaurante_Indices;
	RAISE NOTICE 'Indice idx_Ventas_Cliente Creado Exitosamente';
END IF;
END $$;

-- Crear Indices en tablespace dedicado
DO $$
BEGIN
IF NOT EXISTS (SELECT 1 FROM pg_indexes
			   WHERE indexname='idx_Reservas_Fecha') THEN 	   
	CREATE INDEX idx_Reservas_Fecha ON operaciones.Reservas(FechaReserva)
	TABLESPACE ts_Restaurante_Indices;
	RAISE NOTICE 'Indice idx_Reservas_Fecha Creado Exitosamente';
END IF;
END $$;

-- Ver todas las tablas creadas
-- Catalogo Global
SELECT table_catalog AS NombreBaseDatos,
	   table_schema,
	   table_name
FROM information_schema.tables
WHERE table_type='BASE TABLE'
ORDER BY NombreBaseDatos,table_schema,table_name

-- Ver todas las tablas de la base de datos actual
SELECT schemaname,
	   tablename,
	   tablespace
FROM pg_tables
WHERE schemaname <> 'information_schema'
ORDER BY schemaname,tablename;

-- Ver todas las tablas de la base de datos actual SIN information_schema Y pg_catalog 
SELECT schemaname,
	   tablename,
	   tablespace
FROM pg_tables
WHERE schemaname NOT IN ('information_schema','pg_catalog')
ORDER BY schemaname,tablename;

-- Ver todas las tablas de esquemas especificos
SELECT table_schema,
	   table_name
FROM information_schema.tables
WHERE table_schema = 'operaciones'
ORDER BY table_schema;

-- Insertar Registros Cargos
DO $$
	BEGIN
		 INSERT INTO rrhh.cargos(nombrecargo,
		 						 salario_base,
								 descripcion
		 )
	VALUES('Gerente',3500.00,'Encargado de la administración general'),
		  ('Chef Principal',2800.00,'Jefe de cocina'),
		  ('Cocinero',1800.00,'Preparar los alimentos'),
		  ('Mesero',200.00,'Atención al cliente'),
		  ('Bartender',1500.00,'Preparar las bebidas'),
		  ('Cajero',400.00,'Manejo de caja y pagos'),
		  ('Limpieza',1000.00,'Mantenimiento de instalaciones')
		 ON CONFLICT (nombrecargo) DO NOTHING;
		 RAISE NOTICE 'Cargos Insertados';
END $$;

-- Visualizar los datos
SELECT * FROM rrhh.cargos;

-- Insertar registros Sexo
DO $$
	BEGIN
		 INSERT INTO rrhh.sexo(nombresexo
		 )
	VALUES('Masculino'),
		  ('Femenino')
		 ON CONFLICT (nombresexo) DO NOTHING;
		 RAISE NOTICE 'Sexo Insertados';
END $$;

-- Visualizar los datos
SELECT * FROM rrhh.sexo;

-- Insertar registros Tipo de documento
DO $$
	BEGIN
		 INSERT INTO rrhh.tipodocumento(nombretipodocumento
		 )
	VALUES('DNI - Documento Nacional de Identidad'),
		  ('CE - Carnet de Extranjeria'),
		  ('PAS - Pasaporte'),
		  ('PTP - Ppermiso Unico de Permanencia'),
		  ('RUC - Registro Unico de Contribuyentes'),
		  ('LM - Libreta Militare'),
		  ('CI - Cedula de Identidad'),
		  ('PN - Partida de Nacimiento'),
		  ('LIC - Licencia de Conducir')
		 ON CONFLICT (nombretipodocumento) DO NOTHING;
		 RAISE NOTICE 'Tipo Documento Insertados';
END $$;

-- Visualizar los datos
SELECT * FROM rrhh.tipodocumento;

-- Insertar registros Pais
DO $$
	BEGIN
		 INSERT INTO rrhh.pais(Descripcion)
	VALUES('Peru'),
		  ('Ecuador'),
		  ('Venezuela'),
		  ('Colombia'),
		  ('Brasil'),
		  ('Uruguay'),
		  ('Paraguay'),
		  ('Chile'),
		  ('Argentina'),
		  ('Mexico'),
		  ('Costa Rica'),
		  ('Honduras')
		 ON CONFLICT (Descripcion) DO NOTHING;
		 RAISE NOTICE 'Pais Insertados';
END $$;

-- Visualizar los datos
SELECT * FROM rrhh.pais;

-- Insertar registros Departamentos
DO $$
	BEGIN
		 INSERT INTO rrhh.departamento(Descripcion, IdPais)
	VALUES('Moquegua',1),
		  ('Manabri',2),
		  ('Caracas',3),
		  ('Bogota',4),
		  ('Brasilia',5),
		  ('Montevideo',6),
		  ('Chaco',7),
		  ('Santiago',8),
		  ('Buenos Aires',9),
		  ('Nuevo Leon',10),
		  ('San Jose',11),
		  ('Honduras',12)
		 ON CONFLICT (Descripcion) DO NOTHING;
		 RAISE NOTICE 'Pais Insertados';
END $$;

-- Visualizar los datos
SELECT * FROM rrhh.departamento;

-- Insertar registros Departamentos
DO $$
	BEGIN
		 INSERT INTO rrhh.provincia(Descripcion,IdDepartamento)
	VALUES('Prov. Moquegua',1),
		  ('Prov. Manabri',2),
		  ('Prov. Caracas',3),
		  ('Prov. Bogota',4),
		  ('Prov. Brasilia',5),
		  ('Prov. Montevideo',6),
		  ('Prov. Chaco',7),
		  ('Prov. Santiago',8),
		  ('Prov. Buenos Aires',9),
		  ('Prov. Nuevo Leon',10),
		  ('Prov. San Jose',11),
		  ('Prov. Honduras',12)
		 ON CONFLICT (Descripcion) DO NOTHING;
		 RAISE NOTICE 'Provincia Insertados';
END $$;

-- Visualizar los datos
SELECT * FROM rrhh.provincia;

-- Insertar registros Departamentos
DO $$
	BEGIN
		 INSERT INTO rrhh.distrito(Descripcion,IdProvincia)
	VALUES('Dist. Moquegua',1),
		  ('Dist. Manabri',2),
		  ('Dist. Caracas',3),
		  ('Dist. Bogota',4),
		  ('Dist. Brasilia',5),
		  ('Dist. Montevideo',6),
		  ('Dist. Chaco',7),
		  ('Dist. Santiago',8),
		  ('Dist. Buenos Aires',9),
		  ('Dist. Nuevo Leon',10),
		  ('Dist. San Jose',11),
		  ('Dist. Honduras',12)
		 ON CONFLICT (Descripcion) DO NOTHING;
		 RAISE NOTICE 'Distrito Insertados';
END $$;

-- Visualizar los datos
SELECT * FROM rrhh.distrito;

-- Insertar registros Departamentos
DO $$
	BEGIN
		 INSERT INTO rrhh.ciudad(Descripcion,IdDistrito)
	VALUES('Ciud. Moquegua',1),
		  ('Ciud. Manabri',2),
		  ('Ciud. Caracas',3),
		  ('Ciud. Bogota',4),
		  ('Ciud. Brasilia',5),
		  ('Ciud. Montevideo',6),
		  ('Ciud. Chaco',7),
		  ('Ciud. Santiago',8),
		  ('Ciud. Buenos Aires',9),
		  ('Ciud. Nuevo Leon',10),
		  ('Ciud. San Jose',11),
		  ('Ciud. Honduras',12)
		 ON CONFLICT (Descripcion) DO NOTHING;
		 RAISE NOTICE 'Distrito Insertados';
END $$;

-- Visualizar los datos
SELECT * FROM rrhh.ciudad;

-- INSERTAR REGISTROS Personas
DO $$
	BEGIN
		 INSERT INTO rrhh.personas(PrimerNombre,SegundoNombre,ApellidoPaterno,ApellidoMaterno,IdSexo,IdTipoDocumento,NumeroDocumento,CorreoElectronico,Telefono,IdCiudad,Direccion)
		                    VALUES('Genaro','Leonel','Campos','Carmen',1,1,'12345678','gleonelcamposc@gmail.com','964114162',1,'Manzanilla 241 - Cercado')/*,
		  ('FAbiola','leona','Carmona', 'Candelñaria',2,1,'12345677','Fabiola@gmail.com','964114163',1,'Ica 241 - Oriente'),
		  ('Marco ','Antonio','Canchos', 'Rodriguez',1,1,'12345676','Marco@gmail.com','964114164',1,'Chiclayo 259 - Sur'),
		  ('carlo','Luis','Flores', 'Yuto',1,1,'12345675','Jose@gmail.com','964114169',1,'CHincha Alta 214'),
		  ('Liz','Janet','Silvera', 'Flores',1,1,'12345674','Liz@gmail.com','964114161',1,'Cachiche Ica 698'),
		  ('Maria','Jose','Cantos', 'Carmen',1,1,'12345673','Yesenia@gmail.com','964114136',1,'San Clemente Pisco 215'),
		  ('Josefina','Chili','Camposte', 'Carmen',1,1,'12345672','Sheyla@gmail.com','964114129',1,'Lima Centor 987'),
		  ('Florinda','messa','Campos', 'Carmen',1,1,'12345671','Raquel@gmail.com','964114166',1,'Cañete 987'),
		  ('Flavio','Leoncio','Rodriguez', 'Tueros',1,1,'12345670','Blanca@gmail.com','964114111',1,'Tumbes 64'),
		  ('Norma','luz','Cardenas', 'Carmen',1,1,'12345668','Mayumi@gmail.com','964114122',1,'Ilo 874')
		  */ON CONFLICT (NumeroDocumento) DO NOTHING;
		  RAISE NOTICE 'Personas Insertados';
END $$;



select * from rrhh.sexo
/*
ERROR:  no hay restricción única o de exclusión que coincida con la especificación ON CONFLICT
CONTEXT:  sentencia SQL: «INSERT INTO rrhh.personas(PrimerNombre,SegundoNombre,
								   ApellidoPaterno,ApellidoMaterno,
								   IdSexo,IdTipoDocumento,
								   NumeroDocumento,CorreoElectronico,
								   Telefono,IdCiudad,Direccion
								   )
	VALUES('Genaro','Leonel','Campos', 'Carmen',1,1,'12345678','gleonelcamposc@gmail.com','964114162',1,'Manzanilla 241 - Cercado'),
		  ('FAbiola','leona','Carmona', 'Candelñaria',2,1,'12345677','Fabiola@gmail.com','964114163',1,'Ica 241 - Oriente'),
		  ('Marco ','Antonio','Canchos', 'Rodriguez',1,1,'12345676','Marco@gmail.com','964114164',1,'Chiclayo 259 - Sur'),
		  ('carlo','Luis','Flores', 'Yuto',1,1,'12345675','Jose@gmail.com','964114169',1,'CHincha Alta 214'),
		  ('Liz','Janet','Silvera', 'Flores',1,1,'12345674','Liz@gmail.com','964114161',1,'Cachiche Ica 698'),
		  ('Maria','Jose','Cantos', 'Carmen',1,1,'12345673','Yesenia@gmail.com','964114136',1,'San Clemente Pisco 215'),
		  ('Josefina','Chili','Camposte', 'Carmen',1,1,'12345672','Sheyla@gmail.com','964114129',1,'Lima Centor 987'),
		  ('Florinda','messa','Campos', 'Carmen',1,1,'12345671','Raquel@gmail.com','964114166',1,'Cañete 987'),
		  ('Flavio','Leoncio','Rodriguez', 'Tueros',1,1,'12345670','Blanca@gmail.com','964114111',1,'Tumbes 64'),
		  ('Norma','luz','Cardenas', 'Carmen',1,1,'12345668','Mayumi@gmail.com','964114122',1,'Ilo 874')
		  ON CONFLICT (numerodocumento) DO NOTHING»
función PL/pgSQL inline_code_block en la línea 3 en sentencia SQL 

SQL state: 42P10





*/




-- Visualizar los datos Personas
SELECT * FROM rrhh.personas;



SELECT * FROM rrhh.empleados


SELECT * FROM inventario.categorias
"SELECT * FROM inventario.insumos"
"SELECT * FROM inventario.platos"
"SELECT * FROM inventario.proveedores"
"SELECT * FROM operaciones.clientes"
"SELECT * FROM operaciones.mesas"
"SELECT * FROM operaciones.reservas"
"SELECT * FROM operaciones.ventas"
"SELECT * FROM operaciones.ventasdetalle"

"SELECT * FROM rrhh.sexoenum"


/* RONALDSHUÑA
- CONFIGURACION EN OTRO EQUIPO
- BACKUP(BASE DATOS)
- BACKUP(TABLESPACES)
- Kardex(Como Logica) 
- Base de datos para laboratorio (SQL Server)
- Transacciones
CHRISTIAN
Manual de buenas practicas para base de datos
*/