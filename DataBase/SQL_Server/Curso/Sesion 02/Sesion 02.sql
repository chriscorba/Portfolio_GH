-- Configuración de Email
-- Google cuenta (Activar verificación en dos pasos)
-- Verificación en dos pasos
-- Nombre de aplicación: SQL Server 2025 - Skill
-- Contraseña de aplicación: ixukspnaqtwxkfaj
-- Habilitar el servicio de correo Database Mail
sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE;
GO
-- Configuración 'Database Mail Xps'
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
-- Usar base de datos msdb
-- Verificar si existe una configuración previa
SELECT name,
       description
FROM msdb.dbo.sysmail_profile
WHERE name = 'Notificaciones'
GO
--Eliminar
EXECUTE msdb.dbo.sysmail_delete_profile_sp
        @profile_name = 'Notificaciones'
GO
-- Crear el perfil (Notificación)
IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysmail_profile
    WHERE name = 'Notificaciones'
)
BEGIN
    EXECUTE msdb.dbo.sysmail_add_profile_sp
            @profile_name = 'Notificaciones',
            @description = 'Perfil para usar notificaciones salientes mediante Gmail';
END 
GO
-- Otorgar permiso Base de Datos
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
        @profile_name = 'Notificaciones',
        @principal_name = 'public',
        @is_default = 1;
GO
-- Verificar que no existe una cuenta previa
SELECT name,
       email_address,
       description
FROM msdb.dbo.sysmail_account
WHERE name = 'Christian Cordova - Notificaciones'
GO
-- Eliminar cuenta
EXECUTE msdb.dbo.sysmail_delete_account_sp
        @account_name = 'Christian Cordova - Notificaciones'
GO
-- Crear cuenta de correo de Base de Datos
IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysmail_account
    WHERE name = 'Christian Cordova - Notificaciones'
)
BEGIN
    EXECUTE msdb.dbo.sysmail_add_account_sp
            @account_name = 'Christian Cordova - Notificaciones',
            @email_address = 'chrisalexcorba@gmail.com',
            @description = 'Cuenta de correo para envio de notificaciones salientes',
            @mailserver_name = 'smtp.gmail.com',
            @port = 587, ---465
            @enable_ssl = 1,
            @username = 'chrisalexcorba@gmail.com',
            @password = 'ixukspnaqtwxkfaj';
END 
GO
-- Eliminar cuenta
EXECUTE msdb.dbo.sysmail_delete_profileaccount_sp
        @profile_name = 'Notificaciones',
        @account_name = 'Christian Cordova - Notificaciones'

-- Eliminar
EXEC msdb.dbo.sysmail_delete_profileaccount_sp
        @profile_name = 'Notificaciones'

EXEC msdb.dbo.sysmail_delete_principalprofile_sp
        @profile_name = 'Notificaciones'

EXEC msdb.dbo.sysmail_delete_account_sp
        @account_name = 'Christian Cordova - Notificaciones'

EXEC msdb.dbo.sysmail_delete_profile_sp
        @profile_name = 'Notificaciones'

-- Asociar cuenta al perfil
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
        @profile_name = 'Notificaciones',
        @account_name = 'Christian Cordova - Notificaciones',
        @sequence_number = 1;

-- Verificar el funcionamiento de la notificación
EXECUTE msdb.dbo.sp_send_dbmail
        @profile_name = 'Notificaciones',
        @recipients = 'chrisalexcorba@gmail.com',
        @subject = 'Prueba de notificación de éxito automatizado',
        @body = 'Este es un mensaje de prueba para verificar el funcionamiento de Database Mail.';
GO

-- Verificar correos enviados
SELECT mailitem_id,       
       recipients,
       subject,
       sent_status,
       send_request_date,
       sent_date
FROM msdb.dbo.sysmail_mailitems



-- Verificar configuracion de correos
SELECT a.name AS NombreCuenta,
       a.email_address,
       a.display_name,
       s.servername,
       s.port,
       s.enable_ssl,
       s.username
FROM msdb.dbo.sysmail_account A
INNER JOIN msdb.dbo.sysmail_server S ON A.account_id = S.account_id
WHERE A.name = 'Christian Cordova - Notificaciones'


-- reiniciar nuestro mail
EXECUTE msdb.dbo.sysmail_stop_sp
GO
EXECUTE msdb.dbo.sysmail_start_sp
GO
-- Limpiado de colas
DELETE FROM msdb.dbo.sysmail_unsentitems

-- Probar nueva
EXECUTE msdb.dbo.sp_send_dbmail
        @profile_name = 'Notificaciones',
        @recipients = 'chrisalexcorba@gmail.com',
        @subject = 'Prueba de notificación de éxito automatizado',
        @body = 'Este es un mensaje de prueba para verificar el funcionamiento de Database Mail.';


-- Ver que nos esta generando el error de no enviar
SELECT *
FROM msdb.dbo.sysmail_event_log
ORDER BY log_date DESC
GO


















/*CREAR ESQUEMAS*/
CREATE SCHEMA Maestras
GO
CREATE SCHEMA Transaccionales
GO
CREATE SCHEMA Procesos
GO
-- USAR LA BASE DE DATOS COCHERA PARA CREAR LOS ESQUEMAS
USE BD_Cochera
GO
/*Crear un conjunto de esquemas*/
CREATE PROCEDURE sp_CrearEsquemas
@ListaEsquema NVARCHAR(MAX)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX)
    CREATE TABLE #Esquemas (Nombre NVARCHAR(128), FechaCreacion DATETIME DEFAULT GETDATE())
    INSERT INTO #Esquemas (Nombre)
    SELECT value
    FROM STRING_SPLIT(@ListaEsquema, ',')
    DECLARE Esquema_Cursor CURSOR FOR
    SELECT Nombre
    FROM #Esquemas
    OPEN Esquema_Cursor
    FETCH NEXT FROM Esquema_Cursor INTO @sql
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = 'CREATE SCHEMA ' + QUOTENAME(@sql) + ';'
        EXEC sp_executesql @sql
        FETCH NEXT FROM Esquema_Cursor INTO @sql
    END
    CLOSE Esquema_Cursor
    DEALLOCATE Esquema_Cursor
    DROP TABLE #Esquemas
END
GO
-- Crear los Esquemas
EXECUTE sp_CrearEsquemas 'Maestras,Transaccionales,Procesos'






-- Verificar la creación de los esquemas
SELECT *
FROM sys.schemas
GO
