-- INSERTAR REGISTROS Personas
DO $$
	BEGIN
		 INSERT INTO rrhh.personas(PrimerNombre,SegundoNombre,ApellidoPaterno,ApellidoMaterno,IdSexo,IdTipoDocumento,NumeroDocumento,CorreoElectronico,Telefono,IdCiudad,Direccion)
		                    VALUES('Genaro','Leonel','Campos','Carmen',1,1,'12345678','gleonelcamposc@gmail.com','964114162',1,'Manzanilla 241 - Cercado'),
		  ('Fabiola','leona','Carmona', 'Candelñaria',2,1,'12345677','Fabiola@gmail.com','964114163',1,'Ica 241 - Oriente'),
		  ('Marco ','Antonio','Canchos', 'Rodriguez',1,1,'12345676','Marco@gmail.com','964114164',1,'Chiclayo 259 - Sur'),
		  ('carlo','Luis','Flores', 'Yuto',1,1,'12345675','Jose@gmail.com','964114169',1,'CHincha Alta 214'),
		  ('Liz','Janet','Silvera', 'Flores',1,1,'12345674','Liz@gmail.com','964114161',1,'Cachiche Ica 698'),
		  ('Maria','Jose','Cantos', 'Carmen',1,1,'12345673','Yesenia@gmail.com','964114136',1,'San Clemente Pisco 215'),
		  ('Josefina','Chili','Camposte', 'Carmen',1,1,'12345672','Sheyla@gmail.com','964114129',1,'Lima Centor 987'),
		  ('Florinda','messa','Campos', 'Carmen',1,1,'12345671','Raquel@gmail.com','964114166',1,'Cañete 987'),
		  ('Flavio','Leoncio','Rodriguez', 'Tueros',1,1,'12345670','Blanca@gmail.com','964114111',1,'Tumbes 64'),
		  ('Norma','luz','Cardenas', 'Carmen',1,1,'12345668','Mayumi@gmail.com','964114122',1,'Ilo 874')
		  ON CONFLICT (NumeroDocumento) DO NOTHING;
		  RAISE NOTICE 'Personas Insertados';
END $$;

-- Verificar si existen duplicados previamente
SELECT NumeroDocumento,
	   COUNT(*)
FROM rrhh.personas
GROUP BY NumeroDocumento
HAVING COUNT(*) > 1;

-- Verifica la estructura de la tabla
SELECT
		tc.constraint_name,
		tc.constraint_type,
		kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
	 ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_schema = 'rrhh'
AND tc.table_name = 'personas';

-- Poner restricción de unicidad en el campo NumeroDocumento
ALTER TABLE rrhh.personas
ADD CONSTRAINT uq_personas_numerodocumento
UNIQUE (NumeroDocumento);


/*
ERROR:  no hay restricción única o de exclusión que coincida con la especificación ON CONFLICT
CONTEXT:  sentencia SQL: «INSERT INTO rrhh.personas(PrimerNombre,SegundoNombre,
								   ApellidoPaterno,ApellidoMaterno,
								   IdSexo,IdTipoDocumento,
								   NumeroDocumento,CorreoElectronico,
								   Telefono,IdCiudad,Direccion
								   )
	VALUES('Genaro','Leonel','Campos', 'Carmen',1,1,'12345678','gleonelcamposc@gmail.com','964114162',1,'Manzanilla 241 - Cercado'),
		  ('Fabiola','leona','Carmona', 'Candelñaria',2,1,'12345677','Fabiola@gmail.com','964114163',1,'Ica 241 - Oriente'),
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

-- Podemos actualizar un registro
UPDATE rrhh.personas
SET NumeroDocumento = '48986523'
WHERE IdPersona = 2
;

-- Agregar registro a departamento
SELECT * FROM rrhh.departamento;


INSERT INTO rrhh.Departamento(Descripcion,IdPais)
VALUES('Tumbes',1)

-- Vistas
SELECT * FROM rrhh.personas;

-- JOIN
CREATE VIEW v_listadoPersonas
AS
SELECT P.IdPersona,
       P.PrimerNombre,
       P.SegundoNombre,
       P.ApellidoPaterno,
       P.ApellidoMaterno,
       --P.IdSexo,
       S.NombreSexo,
       --P.IdTipoDocumento,
       TD.NombreTipoDocumento,
       P.NumeroDocumento,
       P.CorreoElectronico,
       P.Telefono,
       --P.IdCiudad,
       CONCAT('Pais: ',PPP.Descripcion,' | ','Departamento: ',DD.Descripcion,' | ','Provincia: ',PP.Descripcion,' | ',
       'Distrito: ',D.Descripcion,' | ','Ciudad: ',C.Descripcion,' | ','Dirección actual: ',P.Direccion) AS Direccion,
       P.Estado,
       P.FechaCreacion
FROM rrhh.Personas P
INNER JOIN rrhh.Sexo S ON P.IdSexo = S.IdSexo
INNER JOIN rrhh.TipoDocumento TD ON P.IdTipoDocumento = TD.IdTipoDocumento
INNER JOIN rrhh.Ciudad C ON P.IdCiudad = C.IdCiudad
INNER JOIN rrhh.Distrito D ON D.IdDistrito = C.IdDistrito
INNER JOIN rrhh.Provincia PP ON PP.IdProvincia = D.IdProvincia
INNER JOIN rrhh.Departamento DD ON DD.IdDepartamento = PP.IdDepartamento
INNER JOIN rrhh.Pais PPP ON PPP.IdPais = DD.IdPais

-- VISUALIZAR LOS DATOS DE LA VISTA
SELECT * FROM v_listadoPersonas;

SELECT * FROM rrhh.Pais
SELECT * FROM rrhh.Departamento
SELECT * FROM rrhh.Provincia
SELECT * FROM rrhh.Distrito
SELECT * FROM rrhh.Ciudad
SELECT * FROM rrhh.TipoDocumento
SELECT * FROM rrhh.Sexo

-- PAGINACION
-- BASICA
SELECT * FROM v_listadoPersonas
ORDER BY ApellidoPaterno
LIMIT 2 OFFSET 0;

SELECT * FROM v_listadoPersonas
ORDER BY IdPersona
LIMIT 2 OFFSET 4;

-- Funcion de Paginacion
CREATE OR REPLACE FUNCTION Paginar_Personas(
p_Pagina INT DEFAULT 1,
p_Por_Pagina INT DEFAULT 4,
p_Ordenar_Por TEXT DEFAULT 'ApellidoPaterno',
p_Orden TEXT DEFAULT 'ASC'
)
RETURNS TABLE(
    IdPersona INT,
    PrimerNombre VARCHAR,
    SegundoNombre VARCHAR,
    ApellidoPaterno VARCHAR,
    ApellidoMaterno VARCHAR,
    NombreSexo VARCHAR,
    NombreTipoDocumento VARCHAR,
    NumeroDocumento VARCHAR,
    CorreoElectronico VARCHAR,
    Telefono VARCHAR
) AS $$
DECLARE v_Offset INT;
BEGIN
-- CALCULAR EL OFFSET
v_Offset := (p_Pagina - 1) * p_Por_Pagina;

-- EJECUTAR LA CONSULTA DINAMICA
RETURN QUERY EXECUTE format(
'SELECT P.IdPersona,
       P.PrimerNombre,
       P.SegundoNombre,
       P.ApellidoPaterno,
       P.ApellidoMaterno,
       S.NombreSexo,
       TD.NombreTipoDocumento,
       P.NumeroDocumento,
       P.CorreoElectronico,
       P.Telefono
FROM rrhh.Personas P
INNER JOIN rrhh.Sexo S ON P.IdSexo = S.IdSexo
INNER JOIN rrhh.TipoDocumento TD ON P.IdTipoDocumento = TD.IdTipoDocumento
INNER JOIN rrhh.Ciudad C ON P.IdCiudad = C.IdCiudad
INNER JOIN rrhh.Distrito D ON D.IdDistrito = C.IdDistrito
INNER JOIN rrhh.Provincia PP ON PP.IdProvincia = D.IdProvincia
INNER JOIN rrhh.Departamento DD ON DD.IdDepartamento = PP.IdDepartamento
INNER JOIN rrhh.Pais PPP ON PPP.IdPais = DD.IdPais
ORDER BY %I %s
LIMIT %s OFFSET %s',
p_Ordenar_Por,
p_Orden,
p_Por_Pagina,
v_Offset
);
END;
$$ LANGUAGE plpgsql

SELECT * FROM Paginar_Personas(1,4,'primernombre','DESC');

/*
COMENTARIOS DE ERRORES


COMENTARIOS DE ERRORES



COMENTARIOS DE ERRORES


COMENTARIOS DE ERRORES


COMENTARIOS DE ERRORES



COMENTARIOS DE ERRORES



COMENTARIOS DE ERRORES



COMENTARIOS DE ERRORES


COMENTARIOS DE ERRORES



*/

-- Crear Usuarios
-- Eliminar un usuario o rol
DROP ROLE IF EXISTS Administrador;

/*
no se puede eliminar el rol «administrador» porque otros objetos dependen de él




*/
-- Revocar o eliminar permisos otorgados a un rol
REVOKE ALL PRIVILEGES ON DATABASE restaurante_db
FROM Administrador;

-- Crear Roles
CREATE ROLE Administrador WITH LOGIN PASSWORD '1234'
SUPERUSER;

-- Asignar permisos a los roles
GRANT ALL PRIVILEGES ON DATABASE restaurante_db
TO Administrador;

GRANT ALL PRIVILEGES ON DATABASE postgres
TO Administrador;

-- Ver roles
SELECT rolname, rolsuper
FROM pg_roles
WHERE rolname = 'administrador';

/*
C:\Program Files\PostgreSQL\18\bin>psql -U administrador -d postgres
Contraseña para usuario administrador:

psql: error: falló la conexión al servidor en «localhost» (::1), puerto 5432: FATAL:  la autentificación password falló para el usuario «administrador»

C:\Windows\System32>c

*/


CREATE ROLE genaro WITH
    LOGIN 
    SUPERUSER
	CREATEDB
	CREATEROLE
    INHERIT
    NOREPLICATION
	BYPASSRLS
    CONNECTION LIMIT -1
	PASSWORD '1234';


-- Back Up pg_dump (cmd)
-- Back Up Completo
pg_dump -U postgres -F c -b -v -f "E:\Practicas\Postgres\restaurante_db_08062026.backup"

pg_dump -U postgres -F c -b -Z9 -v -f "E:\Practicas\Postgres\restaurante_db_08062026_comprimido.backup"

-- Back Up solo Esquema
pg_dump -U postgres -F c -s -v -f "E:\Practicas\Postgres\restaurante_db_08062026_solo_esquema.backup"

-- Back Up solo Datos
pg_dump -U postgres -F c -a -v -f "E:\Practicas\Postgres\restaurante_db_08062026_solo_datos.backup"

-- Back Up en SQL plano
pg_dump -U postgres -F p -b -v -f "E:\Practicas\Postgres\restaurante_db_08062026.sql"





SELECT * FROM rrhh.empleados
SELECT * FROM inventario.categorias
SELECT * FROM inventario.insumos
SELECT * FROM inventario.platos
SELECT * FROM inventario.proveedores
SELECT * FROM operaciones.clientes
SELECT * FROM operaciones.mesas
SELECT * FROM operaciones.reservas
SELECT * FROM operaciones.ventas
SELECT * FROM operaciones.ventasdetalle
SELECT * FROM rrhh.sexoenum


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