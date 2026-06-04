-- crear la base de datos donde vamos a crear nuestra tabla
CREATE TABLE biblioteca.usuario
(
IdUsuario INT AUTO_INCREMENT PRIMARY KEY,
Nombres VARCHAR(100) NOT NULL,
Apellidos VARCHAR(100),
Email VARCHAR(100) UNIQUE,
Telefono VARCHAR(25),
Direccion VARCHAR(300),
FechaCreación TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
Estado BOOL DEFAULT TRUE
)ENCRYPTION = 'N';

-- Pasar Tablas a otra DB
/*RENAME TABLE bliblioteca.autor TO DB.autor;*/

-- Eliminar base de datos
/*DROP DATABASE biblioteca;*/

#Visualizar la tabla de usuario
SELECT * FROM biblioteca.usuario;

#Insertar registros
INSERT INTO biblioteca.usuario (Nombres,
             Apellidos,
             Email,
             Telefono,
             Direccion
             )
VALUES('Juan', 'perez', 'Juan@gmail', '964887112', 'Lima'),
	  ('Maria', 'perez', 'Maria@gmail', '964887113', 'Lima'),
      ('Carlo', 'perez', 'Carlo@gmail', '9648871142', 'Lima'),
      ('Ana', 'perez', 'Ana@gmail', '964887115', 'Lima'),
      ('Pedro', 'perez', 'Pedro@gmail', '964887116', 'Lima'),
      ('Laura', 'perez', 'Laura@gmail', '964887117', 'Lima'),
      ('Yarel', 'perez', 'Yarel@gmail', '964887118', 'Lima'),
      ('Jose', 'perez', 'Jose@gmail', '964887119', 'Lima'),
      ('Kiara', 'perez', 'Kiara@gmail', '964887110', 'Lima'),
      ('Elena', 'perez', 'Elena@gmail', '964887111', 'Lima');

-- Tabla rol
CREATE TABLE Rol(
IdRol INT AUTO_INCREMENT PRIMARY KEY,
Descripcion VARCHAR(50)
)ENCRYPTION = 'N';

-- Insertar registros en roles
INSERT INTO Rol(Descripcion)
VALUES('Autopr'),('Usuario'),('Bibliotecario');

CREATE TABLE Persona(
IdPersona INT AUTO_INCREMENT PRIMARY KEY,
Nombre VARCHAR(150) NOT NULL,
Apellidos VARCHAR(150) NOT NULL,
FechaNacimiento DATE,
Nacionalidad VARCHAR(100),
Email VARCHAR(150),
Estado BOOLEAN DEFAULT TRUE
)ENCRYPTION = 'N';

-- Insertar los registros
INSERT INTO Biblioteca.persona(Nombre,
                               Apellidos,
                               FechaNacimiento,
                               Nacionalidad,
                               Email)
VALUES('Jose','Vilca Paniagua','2001-08-01','Peruana','j.vilca@skill.com'),
	  ('Teddy','Requiz','2002-10-14','Colombiana','t.requiz@skill.com'),
      ('Fray','Ccopa','2023-09-02','Mexicana','Fray.ccopa@skill.com'),
      ('Yarel','Damian Almerco','2004-08-02','Brasileña','y.jeferson@skill.com');

select * from Persona;

CREATE TABLE PersonaRol(
IdPersona INT,
IdRol INT,
PRIMARY KEY(IdPersona,IdRol),
FOREIGN KEY(IdPersona) REFERENCES Persona(IdPersona),
FOREIGN KEY(IdRol) REFERENCES Rol(IdRol)
)ENCRYPTION = 'N';


-- insertar registro
INSERT INTO PersonaRol(IdPersona, IdRol)
VALUES(1,1),
      (2,1),
      (3,1),
      (4,1),
      (3,2),
      (4,3);

-- Ver todas las colecciones disponibles
SHOW COLLATION; -- utf8mb4_unicode_ci

SHOW COLLATION WHERE Charset ='utf8mb4_unicode_ci';

SHOW VARIABLES LIKE 'lc_messages'; -- 'lc_messages', 'en_US'

-- cambiar mi idioma
SET lc_messages = 'en_US';

-- Probar con cambio de fecha
SELECT DATE_FORMAT(NOW(), '%w, %D %M %Y');
SELECT DATE_FORMAT(NOW(), '%w, %D de %M de %Y');

/*Join*/

-- left join
-- rigth join
-- join


SELECT * FROM PersonaRol;

-- usar join
SELECT PR.IdPersona,
       P.Nombre,
       P.Apellidos,
       P.FechaNacimiento,
       P.Email 
FROM personaRol PR
INNER JOIN Persona P ON PR.IdPersona=p.IdPersona;

/*Exportar registros*/
SELECT PR.IdPersona,
       P.Nombre,
       P.Apellidos,
       P.FechaNacimiento,
       P.Email
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Persona.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '¨'
LINES TERMINATED BY '\n'      
FROM personaRol PR
INNER JOIN Persona P ON PR.IdPersona=p.IdPersona;

-- agregar otra relacion ahora con la tabla rol
SELECT PR.IdPersona,
       P.Nombre,
       P.Apellidos,
       P.FechaNacimiento,
       P.Email,
       R.Descripcion
FROM personaRol PR
INNER JOIN Persona P ON PR.IdPersona=p.IdPersona
INNER JOIN Rol R ON PR.IdRol=R.IdRol;


/*Exportar registros*/
SELECT PR.IdPersona,
       P.Nombre,
       P.Apellidos,
       P.FechaNacimiento,
       P.Email,
       R.Descripcion
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Persona_Roles.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '¨'
LINES TERMINATED BY '\n'  
FROM personaRol PR
INNER JOIN Persona P ON PR.IdPersona=p.IdPersona
INNER JOIN Rol R ON PR.IdRol=R.IdRol;

-- Exportar cabecera
(
SELECT 'IdPersona',
       'Nombre',
       'Apellidos',
       'FechaNacimiento',
       'Email',
       'Descripcion'
)
UNION ALL
(
SELECT PR.IdPersona,
       P.Nombre,
       P.Apellidos,
       P.FechaNacimiento,
       P.Email,
       R.Descripcion
FROM personaRol PR
INNER JOIN Persona P ON PR.IdPersona=p.IdPersona
INNER JOIN Rol R ON PR.IdRol=R.IdRol
)
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Persona_Roles_nombres.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '¨'
LINES TERMINATED BY '\n';

-- creacion del formato de tabla para importar
CREATE TABLE UsuariosImportar(
IdPersona INT,
Nombres VARCHAR(200),
Apellidos VARCHAR(300),
FechaNacimiento DATE,
Email VARCHAR(400),
Descripcion VARCHAR(500)
)ENCRYPTION = 'N';

-- visualizar la tabla creada para importacion
SELECT * FROM UsuariosImportar;

-- Importar datos desde un archivo
LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Persona_Roles_nombres.csv'
INTO TABLE UsuariosImportar
FIELDS TERMINATED BY ','
ENCLOSED BY '¨'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(IdPersona, Nombres, Apellidos, FechaNacimiento, Email);

/*21:51:42	LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Persona_Roles_nombres.csv' INTO TABLE UsuariosImportar FIELDS TERMINATED BY ',' ENCLOSED BY '¨' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS (IdPersona, Nombres, Apellidos, FechaNacimiento, Email)	Error Code: 3948. Loading local data is disabled; this must be enabled on both the client and server sides	0.015 sec
*/

-- Activamos la carga local debido al mensaje de error
SET GLOBAL local_infile=1;

-- Verificacion que este activo la carga
SHOW GLOBAL VARIABLES LIKE 'local_infile';