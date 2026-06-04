/*
COMENTAR LINEA TENEMOS DOS OPCIONES
1. --
2. #

COMENTAR CON #
*/
#ESTA VE TODAS LAS BASES DE DATOS
SHOW DATABASES; -- MUESTRA TODAS LAS BASES DE DATOS EXISTENTES

-- VERIFICAR USUARIOS EXISTENTES
SELECT user, host, plugin
FROM mysql.user;

-- cambiar el plugin de autenticación
#ALTER USER 'root'@'localhost' IDENTIFIED
#WITH mysql_native_pasword BY '123456';

-- verificar que no existan usuarios anonimos
SELECT user, host
FROM mysql.user
WHERE User='';

-- restriccion los accesos remotos root
#DELETE FROM mysql.user
#WHERE user='root'
#AND Host NOT IN('Localhost', '127.0.0.1', '::1');

#DELETE FROM mysql.user WHERE user='root' AND Host NOT IN('Localhost','127.0.0.1','::1');

-- Dar privilegios a root
FLUSH PRIVILEGES;

#verificación de seguridad
-- verificar que el servidor este activo
sc query MySQL80 -- En el CMD
/*Corriendo o OK*/

/*conectarse de forma anonima*/
mysql -u '' -p -- no deberia aceptar

/*Conectar con la ip de mysql*/
mysql -h 127-0-0-1 -u root -p

/*configuración de archivo de MySQL*/
# C:\ProgramData\MySQL\MySQL Server 8.0

/*reiniciar servicio*/
net stop MySQL80
net start MySQL80

[mysql]

/* Conmfiguracion Init

#Ruta de instalación
basedir="C:\Program Files\MySQL\MySQL Server 8.0\"

#Ruta de instalación
basedir="C:\ProgramData\MySQL\MySQL Server 8.0\"

#Deshabilitar conexiones TCP/IP
skip-networking

#Evitar resolucion DNS
skip-name-resolve
*/

-- Crear usuario dedicado
CREATE USER 'app_usuario'@'localhost'
IDENTIFIED BY '1234';

-- Asignar privilegios
GRANT SELECT, INSERT, UPDATE, DELETE ON sakila.* TO 'app_usuario'@'localhost';

FLUSH PRIVILEGES;

-- asignar base de datos para filtrar registros
USE sakila;

-- ver rergistros
SELECT * FROM actor
LIMIT 3;

-- verificar los permisos de lo usuarios
SHOW GRANTS FOR 'app_usuario'@'localhost';
SHOW GRANTS FOR 'root'@'localhost';
