-- consultas
SELECT *		-- REPRESENTA TODOS LOS CAMPOS
FROM personarol;

SELECT IdPersona AS CodigoPersona,
       IdRol CodigoRol
FROM PersonaRol;

SELECT IdUsuario
	   Nombres,
       Apellidos,
	   Email,
       Telefono,
       Direccion,
       FechaCreación
FROM usuario
WHERE Estado=TRUE;

-- ASC/DESC (ASCIENDE DESCIENDE)
SELECT IdUsuario
	   Nombres,
       Apellidos,
	   Email,
       Telefono,
       Direccion,
       FechaCreación
FROM usuario
WHERE Estado=TRUE
ORDER BY Nombres DESC;

SELECT IdUsuario
	   Nombres,
       Apellidos,
	   Email,
       Telefono,
       Direccion,
       FechaCreación
FROM usuario
WHERE Estado=TRUE
ORDER BY Nombres ASC;

SELECT IdUsuario
	   Nombres,
       Apellidos,
	   Email,
       Telefono,
       Direccion,
       FechaCreación
FROM usuario
WHERE Estado=TRUE
ORDER BY Nombres;

-- CASE
SELECT IdUsuario
	   Nombres,
       Apellidos,
	   Email,
       Telefono,
       CASE WHEN Direccion='AYACUCHO' THEN 'Peru'
            WHEN Direccion='LIMA' THEN 'Bolivia'
       ELSE 'internacionales' END Ubicación,
       FechaCreación,
       CASE WHEN Estado=TRUE THEN 'Activo' ELSE 'Inactivo' END AS Estado
FROM usuario
WHERE Estado=TRUE
ORDER BY Nombres;

-- poder ver la descripcion de la tabla
DESCRIBE usuario;

-- funciones de fecha
/*
NOW().- FECHA Y HORA ACTUAL
DATEIFF().- DIFERENCIAS ENTRE FECHAS
DATE_ADD().- SUMA TIEMPO DE UNA FECHA
DATE_FORMAT().-FORMATEAR LA FECHA
*/

SELECT IdUsuario
	   Nombres,
       Apellidos,
	   Email,
       Telefono,
       Direccion,
       DATEIFF(NOW(),FechaCreación) DiferenciasFechas
FROM usuario;

-- Actualizar
UPDATE Usuario
SET FechaCreación='2022-05-03'
WHERE IdUsuario = 5;

-- subconsultas correlacionada
SELECT IdUsuario
	   Nombres,
       Apellidos,
	   Email,
       Telefono,
       Direccion
FROM usuario
WHERE EXISTS(
SELECT 1
FROM Usuario
WHERE Direccion = 'Ica'
);

SELECT*
FROM Usuario
WHERE Direccion IN(
SELECT Direccion
FROM Usuario
WHERE Direccion = 'Ica'
);

/*Funciones agregacion con Group By
SUM
COUNT
AVG
MAX
MIN
*/
SELECT IdUsuario
	   Nombres,
       Apellidos,
	   Email,
       Telefono,
       Direccion,
       MAX(IdUsuario)
FROM usuario
GROUP BY IdUsuario;

SELECT MAX(IdUsuario)
FROM usuario;

SELECT COUNT(IdUsuario)
FROM usuario;

SELECT MIN(IdUsuario)
FROM usuario;

SELECT AVG(IdUsuario)
FROM usuario;

SELECT SUM(IdUsuario)
FROM usuario;

/* Funciones de cadena
CONCAT.- UNIR O CONCATENAR CAMPOS
SUBSTRING.- EXTRAER PARTES DE UNA CADENA
UPPER.- CONVERTIR A MAYUSCULA
LOWER.- CONVERTIR A MINUSCULA
*/
SELECT IdUsuario
	   Nombres,
       UPPER(NOMBRES) AS Mayuscula,
       Apellidos,
       SUBSTRING(Apellidos,4,2),
       CONCAT(Nombres,'',Apellidos) AS NombreCompleto,
       CONCAT(
              UPPER(LEFT(Nombres,1)),
              LOWER(SUBSTRING(Apellidos,2)),
       '',
       UPPER(LEFT(Nombres,1)),
             LOWER(SUBSTRING(Apellidos,2))) AS NombreCompletoConLetrainicialesMayusca,
	   Email,
       Telefono,
       LOWER(Direccion) AS Minuscula
FROM usuario;

/*
LOCATE.- BUSCAR TEXTO EN UNA CADENA
INSTR.- CADENA POR TEXT
*/
SELECT IdUsuario,
	   LOCATE('ua',Nombres),
       Nombres,
       Apellidos,
       INSTR(Apellidos,'re')
	   Email,
       Telefono,
       Direccion
FROM usuario
GROUP BY IdUsuario;

-- CTE (Comon Express Table)
WITH CTES_Usuario AS (SELECT IdUsuario,
	   LOCATE('ua',Nombres) AS LOCATE,
       Nombres,
       Apellidos,
       INSTR(Apellidos,'re') AS INSTR,
	   Email,
       Telefono,
       Direccion
FROM Usuario
GROUP BY IdUsuario)

SELECT LOCATE,
	   Nombres,
       Telefono
FROM CTES_Usuario;

-- VISTAS
/*
VISTAS SIMPLES
VISTAS COMPLEJAS
*/
-- VISTAS SIMPLES
CREATE VIEW v_Usuario
AS
SELECT IdUsuario,
	   LOCATE('ua',Nombres),
       Nombres,
       Apellidos,
       INSTR(Apellidos,'re')
	   Email,
       Telefono,
       Direccion
FROM usuario
GROUP BY IdUsuario;

-- Usamos
SELECT * FROM v_Usuario;

-- Vista compleja
CREATE VIEW v_PersonasConRoles
AS
SELECT PR.IdPersona,
       P.Nombre,
       P.Apellidos,
       P.FechaNacimiento,
       P.Email,
       R.Descripcion
FROM personaRol PR
INNER JOIN Persona P ON PR.IdPersona=p.IdPersona
INNER JOIN Rol R ON PR.IdRol=R.IdRol;

-- Usamos
SELECT * FROM v_PersonasConRoles;

-- Vistas Materializadas

SELECT IdUsuario,
       Nombres,
       Apellidos,
       Email,
       Telefono,
       Direccion
FROM usuario
WHERE Direccion IN ('Lima','Ica','Chincha');


-- Tablas Materializadas
CREATE TABLE Usuario_Mat
ENCRYPTION = 'N' AS
SELECT IdUsuario,
       Nombres,
       Apellidos,
       Email,
       Telefono,
       Direccion
FROM Usuario
WHERE Direccion IN ('Lima','Ica','Chincha');







-- Utiliza
SELECT * FROM Usuario_Mat;

INSERT INTO biblioteca.usuario (Nombres,
             Apellidos,
             Email,
             Telefono,
             Direccion
             )
VALUES('Juan', 'perez', 'Juan2@gmail', '964887112', 'Lima'),
	  ('Maria', 'perez', 'Maria2@gmail', '964887113', 'Ica'),
      ('Carlo', 'perez', 'Carlo2@gmail', '9648871142', 'Chincha'),
      ('Ana', 'perez', 'Ana2@gmail', '964887115', 'Ayacucho'),
      ('Pedro', 'perez', 'Pedro2@gmail', '964887116', 'Tumbes'),
      ('Laura', 'perez', 'Laura2@gmail', '964887117', 'Piura'),
      ('Yarel', 'perez', 'Yarel2@gmail', '964887118', 'Chiclayo'),
      ('Jose', 'perez', 'Jose2@gmail', '964887119', 'Tacna'),
      ('Kiara', 'perez', 'Kiara2@gmail', '964887110', 'Arequipa'),
      ('Elena', 'perez', 'Elena2@gmail', '964887111', 'Puno');

-- Actualizar la Tabla Materializada
REPLACE INTO Usuario_Mat
SELECT IdUsuario,
       Nombres,
       Apellidos,
       Email,
       Telefono,
       Direccion
FROM Usuario
WHERE Direccion IN ('Lima','Ica','Chincha');

-- activar eventos scheduler
SET GLOBAL event_scheduler = ON;

-- Crear el evento
CREATE EVENT Actualizarcadammnuto
ON SCHEDULE EVERY 1 MINUTE
DO
REPLACE INTO Usuario_Mat
SELECT IdUsuario,
       Nombres,
       Apellidos,
       Email,
       Telefono,
       Direccion
FROM Usuario
WHERE Direccion IN ('Lima','Ica','Chincha');

SELECT * FROM Usuario;
SELECT * FROM Usuario_Mat;

/*PROCEDIMIENTOS ALMACENADOS*/
-- LISTAR
DELIMITER //
CREATE PROCEDURE sp_Listar_Usuario()
BEGIN
	SELECT IdUsuario,
		   Nombres,
		   Apellidos,
		   Email,
		   Telefono,
		   Direccion
	FROM Usuario;
END//

-- USAR
CALL sp_Listar_Usuario();

-- LISTAR CON PARAMETROS
DELIMITER //
CREATE PROCEDURE sp_Listar_Usuario_Nombres(IN p_Nombres VARCHAR(100))
BEGIN
	SELECT IdUsuario ,
		   Nombres,
		   Apellidos,
		   Email,
		   Telefono,
		   Direccion
	FROM Usuario
    WHERE Nombres LIKE CONCAT('%',p_Nombres,'%');
END//

-- USAR
CALL sp_Listar_Usuario_Nombres('jasmin');

-- Insertar
DELIMITER //
CREATE PROCEDURE sp_Agregar_Usuario(
IN p_Nombres VARCHAR(100),
IN p_Apellidos VARCHAR(100),
IN p_Email VARCHAR(100),
IN p_Telefono VARCHAR(100),
IN p_Direccion VARCHAR(100)
)
BEGIN
	INSERT INTO biblioteca.usuario (Nombres,
				 Apellidos,
				 Email,
				 Telefono,
				 Direccion
				 )
	VALUES(p_Nombres,
           p_Apellidos,
           p_Email,
           p_Telefono,
           p_Direccion
           );
END//

-- USAR
CALL sp_Agregar_Usuario('Arlena',
                        'Santiago Arenas',
                        'JasminArlena@gmail',
                        '964884501',
                        'Lima Este');

-- MODIFICAR
DELIMITER //
CREATE PROCEDURE sp_Modificar_Usuario(
IN p_Id INT,
IN p_Nombres VARCHAR(100),
IN p_Apellidos VARCHAR(100),
IN p_Email VARCHAR(100),
IN p_Telefono VARCHAR(100),
IN p_Direccion VARCHAR(100)
)
BEGIN
	UPDATE biblioteca.usuario SET Nombres= p_Nombres,
				 Apellidos=p_Apellidos,
				 Email=p_Email,
				 Telefono=p_Telefono,
				 Direccion=p_Direccion
	WHERE IdUsuario = p_Id;
END//

-- Usar
CALL sp_Modificar_Usuario(1,'Juancito',
                        'Bustamante Cardenas',
                        'juancito@gmail',
                        '964887201',
                        'Lima norte');

-- ELIMINAR
DELIMITER //
CREATE PROCEDURE sp_Eliminar_Usuario(
IN p_Id INT
)
BEGIN
	DELETE FROM biblioteca.usuario
	WHERE IdUsuario = p_Id;
END//

-- Usar
CALL sp_Eliminar_Usuario(6);

-- CRUD(INSERTAR, ACTUALIZAR, ELIMINAR,LISTAR SIN PARAMETRO, LISTAR CON PARAMETRO)

-- TRIGGER (AUDITORIA)
CREATE TABLE IF NOT EXISTS Auditoria(
IdAuditoria INTEGER AUTO_INCREMENT PRIMARY KEY,
TablaAfectada VARCHAR(150),
IdRegistro INT,
Usuario VARCHAR(100),
Accion VARCHAR(30),
FechaAccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)ENCRYPTION = 'N';

-- Trigger para la Auditoria
DELIMITER //
CREATE TRIGGER tr_Auditoria_Insertar
AFTER INSERT ON usuario
FOR EACH ROW
BEGIN
	INSERT INTO Auditoria(TablaAfectada,
						  IdeRegistro,
                          Usuario,
                          Accion
                          )
	 VALUES('Usuario', NEW.IdUsuario, USER(), 'Insertar');
END//

-- TABLA AUDITORIA
SELECT*
FROM Auditoria;

-- TRIGGER (AUDITORIA)
CREATE TABLE IF NOT EXISTS Auditoria2(
IdAuditoria INTEGER AUTO_INCREMENT PRIMARY KEY,
TablaAfectada VARCHAR(150),
Operacion VARCHAR(30),
IdRegistro INT,
DatosAnteriores  TEXT,
DatosNuevos  TEXT,
Usuario VARCHAR(100),
FechaAccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ipConexion VARCHAR(50)
)ENCRYPTION = 'N';

-- Trigger para la Auditoria insertar
DELIMITER //
CREATE TRIGGER tr_Auditoria_Insertar_Usuario
AFTER INSERT ON usuario
FOR EACH ROW
BEGIN
	INSERT INTO Auditoria(TablaAfectada,
						  Operacion,
                          IdRegistro,
						  DatosNuevos,
                          Usuario,
                          ipConexion
                          )
	 VALUES('Usuario',
			'INSERT',
            NEW.IdUsuario,
            CONCAT('Codigo registro es: ',NEW.IdUsuario),
            CURRENT_USER(),
            (SELECT SUBSTRING_INDEX(USER(),'@',-1))
            );
END//

-- Trigger para la Auditoria insertar
DELIMITER //
CREATE TRIGGER tr_Auditoria_Modificar_Usuario
AFTER UPDATE ON usuario
FOR EACH ROW
BEGIN
	INSERT INTO Auditoria(TablaAfectada,
						  Operacion,
                          IdRegistro,
                          DatosAnteriores,
						  DatosNuevos,
                          Usuario,
                          ipConexion
                          )
	 VALUES('Usuario',
			'ACTUALIZAR',
            NEW.IdUsuario,
            CONCAT('Codigo registro es: ',OLD.IdUsuario),
            CONCAT('Codigo registro es: ',NEW.IdUsuario),
            CURRENT_USER(),
            (SELECT SUBSTRING_INDEX(USER(),'@',-1))
            );
END//

-- Trigger para la Auditoria Eliminar
DELIMITER //
CREATE TRIGGER tr_Auditoria_Eliminar_Usuario
BEFORE DELETE ON usuario
FOR EACH ROW
BEGIN
	INSERT INTO Auditoria(TablaAfectada,
						  Operacion,
                          IdRegistro,
                          DatosAnteriores,
						  DatosNuevos,
                          Usuario,
                          ipConexion
                          )
	 VALUES('Usuario',
			'ELIMINAR',
            OLD.IdUsuario,
            OLD.IdUsuario,
            CONCAT('Codigo registro es: ',OLD.IdUsuario, OLD.Nombres),
            CURRENT_USER(),
            (SELECT SUBSTRING_INDEX(USER(),'@',-1))
            );
END//













CREATE DATABASE Nueva1;






-- copias de seguridad
-- un back up full de DB desde el CMD
/*
C:\Windows\System32>mysqldump -u root -p --databases biblioteca >"C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\biblioteca_full_28052026.sql"
Enter password: ****
*/
-- herramienta llamada MYSQL DUMP


-- restaurar DB desde cmd
/*
C:\Windows\System32>MySQL -u root -p nueva1 <"C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\nueva1_full_28052026.sql
Enter password: ****
*/










-- TABLA AUDITORIA

