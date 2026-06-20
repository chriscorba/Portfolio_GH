-- PROCEDIMIENTO ALMACENADOS.- Permiten encapsular lógica de negocio y operaciones complejas en la base de datos, facilitando la reutilización y el mantenimiento del código. Algunos tipos comunes de procedimientos almacenados incluyen:
-- LISTADO.- Permite obtener datos de una o varias tablas, aplicando filtros, ordenamientos y paginación según sea necesario.
-- Created by GitHub Copilot in SSMS - review carefully before executing
CREATE PROCEDURE sp_ListarClientes
AS
BEGIN
    BEGIN TRY
        SELECT 
            IdCliente,
            Nombre,
            Apellido,
            Cedula,
            Email,
            Telefono,
            Direccion,
            FechaRegistro,
            Activo
        FROM Maestras.Clientes
        WHERE Activo = 1
        ORDER BY Nombre, Apellido;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS MensajeError,
            ERROR_NUMBER() AS CodigoError;
    END CATCH
END
GO
-- Ejecutar: EXEC sp_ListarClientes;
GO
-- LISTADO CON PARAMETRO
-- Created by GitHub Copilot in SSMS - review carefully before executing
CREATE PROCEDURE sp_BuscarClientePorCedula
    @Cedula NVARCHAR(20)
AS
BEGIN
    BEGIN TRY
        IF @Cedula IS NULL OR @Cedula = ''
        BEGIN
            SELECT 'Error: Cédula no puede estar vacía' AS Resultado;
            RETURN;
        END
        
        SELECT 
            IdCliente,
            Nombre,
            Apellido,
            Cedula,
            Email,
            Telefono,
            Direccion,
            FechaRegistro,
            Activo
        FROM Maestras.Clientes
        WHERE Cedula = @Cedula AND Activo = 1;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS MensajeError;
    END CATCH
END
GO

-- Ejecutar: EXEC sp_BuscarClientePorCedula @Cedula = '1001001001';
GO
-- INSERTAR
-- Created by GitHub Copilot in SSMS - review carefully before executing

CREATE PROCEDURE sp_InsertarCliente
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Cedula NVARCHAR(20),
    @Email NVARCHAR(100) = NULL,
    @Telefono NVARCHAR(20) = NULL,
    @Direccion NVARCHAR(255) = NULL,
    @IdCliente INT OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Validaciones
        IF @Nombre IS NULL OR @Nombre = ''
            THROW 50001, 'El nombre es requerido', 1;
        
        IF @Apellido IS NULL OR @Apellido = ''
            THROW 50002, 'El apellido es requerido', 1;
        
        IF @Cedula IS NULL OR @Cedula = ''
            THROW 50003, 'La cédula es requerida', 1;
        
        -- Verificar cédula duplicada
        IF EXISTS (SELECT 1 FROM Maestras.Clientes WHERE Cedula = @Cedula)
            THROW 50004, 'La cédula ya existe en el sistema', 1;
        
        -- Insertar registro
        INSERT INTO Maestras.Clientes 
            (Nombre, Apellido, Cedula, Email, Telefono, Direccion, Activo)
        VALUES 
            (@Nombre, @Apellido, @Cedula, @Email, @Telefono, @Direccion, 1);
        
        SET @IdCliente = SCOPE_IDENTITY();
        
        SELECT 'Cliente insertado exitosamente' AS Resultado, @IdCliente AS IdCliente;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS MensajeError,
            ERROR_NUMBER() AS CodigoError;
        SET @IdCliente = 0;
    END CATCH
END
GO

-- Ejecutar:
-- DECLARE @IdCliente INT;
-- EXEC sp_InsertarCliente 
--     @Nombre = 'Fernando', 
--     @Apellido = 'Ramírez', 
--     @Cedula = '1001001999',
--     @Email = 'fernando@email.com',
--     @IdCliente = @IdCliente OUTPUT;
-- SELECT @IdCliente AS NuevoId;
GO
-- ACTULIZAR
-- Created by GitHub Copilot in SSMS - review carefully before executing

CREATE PROCEDURE sp_ActualizarCliente
    @IdCliente INT,
    @Nombre NVARCHAR(100) = NULL,
    @Apellido NVARCHAR(100) = NULL,
    @Email NVARCHAR(100) = NULL,
    @Telefono NVARCHAR(20) = NULL,
    @Direccion NVARCHAR(255) = NULL
AS
BEGIN
    BEGIN TRY
        IF @IdCliente IS NULL OR @IdCliente <= 0
            THROW 50005, 'Id de cliente inválido', 1;
        
        -- Verificar que el cliente existe
        IF NOT EXISTS (SELECT 1 FROM Maestras.Clientes WHERE IdCliente = @IdCliente)
            THROW 50006, 'El cliente no existe', 1;
        
        UPDATE Maestras.Clientes
        SET 
            Nombre = ISNULL(@Nombre, Nombre),
            Apellido = ISNULL(@Apellido, Apellido),
            Email = ISNULL(@Email, Email),
            Telefono = ISNULL(@Telefono, Telefono),
            Direccion = ISNULL(@Direccion, Direccion)
        WHERE IdCliente = @IdCliente;
        
        SELECT 'Cliente actualizado exitosamente' AS Resultado;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS MensajeError,
            ERROR_NUMBER() AS CodigoError;
    END CATCH
END
GO

-- Ejecutar:
-- EXEC sp_ActualizarCliente 
--     @IdCliente = 1,
--     @Email = 'nuevo@email.com',
--     @Telefono = '555-1234';
GO
-- ELIMINAR LÓGICO
-- Created by GitHub Copilot in SSMS - review carefully before executing

CREATE PROCEDURE sp_EliminarClienteLogico
    @IdCliente INT
AS
BEGIN
    BEGIN TRY
        IF @IdCliente IS NULL OR @IdCliente <= 0
            THROW 50007, 'Id de cliente inválido', 1;
        
        IF NOT EXISTS (SELECT 1 FROM Maestras.Clientes WHERE IdCliente = @IdCliente)
            THROW 50008, 'El cliente no existe', 1;
        
        UPDATE Maestras.Clientes
        SET Activo = 0
        WHERE IdCliente = @IdCliente;
        
        SELECT 'Cliente desactivado exitosamente' AS Resultado;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS MensajeError,
            ERROR_NUMBER() AS CodigoError;
    END CATCH
END
GO
-- Ejecutar: EXEC sp_EliminarClienteLogico @IdCliente = 1;
GO
-- ELIMINAR FÍSICO
-- Created by GitHub Copilot in SSMS - review carefully before executing

CREATE PROCEDURE sp_EliminarClienteFisico
    @IdCliente INT
AS
BEGIN
    BEGIN TRY
        IF @IdCliente IS NULL OR @IdCliente <= 0
            THROW 50009, 'Id de cliente inválido', 1;
        
        IF NOT EXISTS (SELECT 1 FROM Maestras.Clientes WHERE IdCliente = @IdCliente)
            THROW 50010, 'El cliente no existe', 1;
        
        -- ADVERTENCIA: Verificar dependencias (RegistrosVehiculos)
        IF EXISTS (SELECT 1 FROM Transacciones.RegistrosVehiculos WHERE IdCliente = @IdCliente)
            THROW 50011, 'No se puede eliminar: Cliente tiene registros de vehículos asociados', 1;
        
        DELETE FROM Maestras.Clientes
        WHERE IdCliente = @IdCliente;
        
        SELECT 'Cliente eliminado permanentemente' AS Resultado;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS MensajeError,
            ERROR_NUMBER() AS CodigoError;
    END CATCH
END
GO

-- Ejecutar: EXEC sp_EliminarClienteFisico @IdCliente = 100;
GO
-- TRIGGER.-    Permiten ejecutar automáticamente un bloque de código en respuesta a eventos específicos en la base de datos, como inserciones, actualizaciones o eliminaciones. Algunos tipos comunes de triggers incluyen:
-- TRIGGER DE AUDITORIA LÓGICO(AGREGAR, MODIFICAR, ELIMINAR LÓGICO, ELIMINAR FÍSICO)
-- TRIGGER DE AUDITORIA FÍSICO
-- Created by GitHub Copilot in SSMS - review carefully before executing

CREATE TRIGGER tr_Clientes_INSERT
ON Maestras.Clientes
AFTER INSERT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Procesos.Auditoria 
            (TablaModificada, TipoOperacion, RegistroId, DatosAnteriores, 
             DatosNuevos, FechaOperacion, Usuario)
        SELECT 
            'Clientes',
            'INSERT',
            i.IdCliente,
            'NULL (Nuevo registro)',
            'Nombre: ' + i.Nombre + ' | Apellido: ' + i.Apellido + 
            ' | Cedula: ' + i.Cedula + ' | Email: ' + ISNULL(i.Email, 'N/A') +
            ' | Activo: ' + CAST(i.Activo AS VARCHAR),
            GETDATE(),
            SYSTEM_USER
        FROM inserted i;
        
        PRINT 'Auditoría: Cliente agregado exitosamente';
    END TRY
    BEGIN CATCH
        PRINT 'Error en trigger INSERT: ' + ERROR_MESSAGE();
    END CATCH
END
GO
-- Created by GitHub Copilot in SSMS - review carefully before executing

CREATE TRIGGER tr_Clientes_UPDATE
ON Maestras.Clientes
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO Procesos.Auditoria 
            (TablaModificada, TipoOperacion, RegistroId, DatosAnteriores, 
             DatosNuevos, FechaOperacion, Usuario)
        SELECT 
            'Clientes',
            'UPDATE',
            d.IdCliente,
            'Nombre: ' + d.Nombre + ' | Apellido: ' + d.Apellido + 
            ' | Email: ' + ISNULL(d.Email, 'N/A') + ' | Telefono: ' + ISNULL(d.Telefono, 'N/A'),
            'Nombre: ' + i.Nombre + ' | Apellido: ' + i.Apellido + 
            ' | Email: ' + ISNULL(i.Email, 'N/A') + ' | Telefono: ' + ISNULL(i.Telefono, 'N/A'),
            GETDATE(),
            SYSTEM_USER
        FROM inserted i
        INNER JOIN deleted d ON i.IdCliente = d.IdCliente
        WHERE (d.Nombre <> i.Nombre 
            OR d.Apellido <> i.Apellido 
            OR ISNULL(d.Email, '') <> ISNULL(i.Email, '')
            OR ISNULL(d.Telefono, '') <> ISNULL(i.Telefono, ''));
        
        PRINT 'Auditoría: Cliente actualizado';
    END TRY
    BEGIN CATCH
        PRINT 'Error en trigger UPDATE: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- Prueba:
-- UPDATE Maestras.Clientes 
-- SET Email = 'newemail@email.com' 
-- WHERE IdCliente = 1;
GO
-- Prueba:
-- INSERT INTO Maestras.Clientes (Nombre, Apellido, Cedula, Email, Telefono, Direccion, Activo)
-- VALUES ('TestTrigger', 'Insert', '1111111111', 'test@email.com', '555-1111', 'Calle Test', 1);
GO
-- Created by GitHub Copilot in SSMS - review carefully before executing

CREATE TRIGGER tr_Clientes_DELETE_LOGICO
ON Maestras.Clientes
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        -- Capturar solo cambios de Activo = 1 a Activo = 0
        INSERT INTO Procesos.Auditoria 
            (TablaModificada, TipoOperacion, RegistroId, DatosAnteriores, 
             DatosNuevos, FechaOperacion, Usuario)
        SELECT 
            'Clientes',
            'DELETE_LOGICO',
            d.IdCliente,
            'Nombre: ' + d.Nombre + ' | Cedula: ' + d.Cedula + 
            ' | Activo: ' + CAST(d.Activo AS VARCHAR),
            'Nombre: ' + i.Nombre + ' | Cedula: ' + i.Cedula + 
            ' | Activo: ' + CAST(i.Activo AS VARCHAR),
            GETDATE(),
            SYSTEM_USER
        FROM inserted i
        INNER JOIN deleted d ON i.IdCliente = d.IdCliente
        WHERE d.Activo = 1 AND i.Activo = 0;
        
        PRINT 'Auditoría: Cliente desactivado (Eliminación lógica)';
    END TRY
    BEGIN CATCH
        PRINT 'Error en trigger DELETE LÓGICO: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- Prueba:
-- UPDATE Maestras.Clientes 
-- SET Activo = 0 
-- WHERE IdCliente = 2;
GO
-- Created by GitHub Copilot in SSMS - review carefully before executing

CREATE TRIGGER tr_Clientes_DELETE_FISICO
ON Maestras.Clientes
AFTER DELETE
AS
BEGIN
    BEGIN TRY
        INSERT INTO Procesos.Auditoria 
            (TablaModificada, TipoOperacion, RegistroId, DatosAnteriores, 
             DatosNuevos, FechaOperacion, Usuario)
        SELECT 
            'Clientes',
            'DELETE_FISICO',
            d.IdCliente,
            'Nombre: ' + d.Nombre + ' | Apellido: ' + d.Apellido + 
            ' | Cedula: ' + d.Cedula + ' | Email: ' + ISNULL(d.Email, 'N/A') +
            ' | Fecha Registro: ' + CAST(d.FechaRegistro AS VARCHAR),
            'REGISTRO ELIMINADO PERMANENTEMENTE',
            GETDATE(),
            SYSTEM_USER
        FROM deleted d;
        
        PRINT 'Auditoría: Cliente eliminado físicamente (Permanentemente)';
    END TRY
    BEGIN CATCH
        PRINT 'Error en trigger DELETE FÍSICO: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- Prueba:
-- DELETE FROM Maestras.Clientes 
-- WHERE IdCliente = 100;
GO
/*SEGURIDAD EN SQL SERVER
- USUARIOS (Autenticación Windows, Autenticación SQL,Modo mixto)
- ROLES (db_owner, db_datareader, db_datawriter)
*/
-- TUNNING.- Permite optimizar el rendimiento de las consultas y operaciones en la base de datos mediante diversas técnicas, como:
-- Optimización con Indices
--  1.- Clustered .-  Organiza los datos físicamente en el disco según el orden de las claves del índice. Solo puede haber un índice clustered por tabla, ya que determina la estructura de almacenamiento de los datos.
CREATE CLUSTERED INDEX IX_RegistrosVehiculos_Pla on Transacciones.RegistrosVehiculos(Placa);
GO
--2.- Non-Clustered.- Crea una estructura de índice separada que apunta a las filas de datos. Puede haber múltiples índices non-clustered en una tabla, lo que permite mejorar el rendimiento de las consultas que no se benefician del índice clustered.
CREATE NONCLUSTERED INDEX IX_RegistrosVehiculos_IdCliente on Transacciones.RegistrosVehiculos(IdCliente);
GO
--3.- Unique
-- 4.- Filtered
--  5.- Columnstore

/*- Consultas avanzadas*/

-- COPIAS DE SEGURIDAD.- Permiten proteger los datos de una base de datos mediante la creación de copias de seguridad que se pueden restaurar en caso de pérdida de datos, corrupción o desastres. Algunos tipos comunes de copias de seguridad incluyen:
-- Backup Full.- Realiza una copia completa de la base de datos, incluyendo todos los datos y objetos. Es la base para otros tipos de copias de seguridad.
BACKUP DATABASE BD_Cochera
TO DISK = '/var/opt/mssql/backups/BD_Cochera_Full.bak' 
WITH FORMAT, 
INIT, NAME = 'Backup Completo BD_Cochera';
GO
-- Backup Transaccional (Log).- Realiza una copia de seguridad de las transacciones registr
-- Created by GitHub Copilot in SSMS - review carefully before executing
DECLARE @BackupDir NVARCHAR(260) = N'/var/opt/mssql/backups';
DECLARE @DatabaseName SYSNAME = N'BD_Cochera';
DECLARE @FileName NVARCHAR(300) = @BackupDir + N'\' + @DatabaseName + N'_LogBackup_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + N'.trn';

BACKUP LOG [BD_Cochera]
TO DISK = @FileName
WITH INIT,
     CHECKSUM,
     STATS = 10,
     COMPRESSION (ALGORITHM = ZSTD);
GO
-- Backup Diferencial.- Realiza una copia de seguridad de los cambios realizados desde la última copia de seguridad completa, lo que permite restaurar la base de datos a un punto específico en el tiempo.
-- Created by GitHub Copilot in SSMS - review carefully before executing
DECLARE @BackupDir NVARCHAR(260) = N'/var/opt/mssql/backups';
DECLARE @DatabaseName SYSNAME = N'BD_Cochera';
DECLARE @FileName NVARCHAR(300) = @BackupDir + N'\' + @DatabaseName + N'_DifferentialBackup_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + N'.bak';

BACKUP DATABASE [BD_Cochera]
TO DISK = @FileName
WITH DIFFERENTIAL,
     INIT,
     CHECKSUM,
     STATS = 10,
     COMPRESSION (ALGORITHM = ZSTD);
GO
/*
Alertas en SQL Server
- Creación de Alertas Email
- Envios de reportes por Email
- Configuración de Database Mail
*/
-- JOIN EN SQL SERVER.- Permite combinar filas de dos o más tablas basándose en una condición relacionada entre ellas. Algunos tipos comunes de JOIN incluyen:
-- INNER JOIN.- Devuelve solo las filas que tienen coincidencias en ambas tablas.
SELECT C.IdCliente, C.Nombre, R.Placa
FROM Maestras.Clientes C
INNER JOIN Transacciones.RegistrosVehiculos R ON C.IdCliente = R.IdCliente;
GO
-- LEFT JOIN.- Devuelve todas las filas de la tabla de la izquierda y las filas coincidentes de la tabla de la derecha. Si no hay coincidencia, los valores de la tabla de la derecha serán NULL.
SELECT C.IdCliente, C.Nombre, R.Placa
FROM Maestras.Clientes C
LEFT JOIN Transacciones.RegistrosVehiculos R ON C.IdCliente = R.IdCliente;
GO
-- RIGHT JOIN.- Devuelve todas las filas de la tabla de la derecha y las filas coincidentes de la tabla de la izquierda. Si no hay coincidencia, los valores de la tabla de la izquierda serán NULL.
SELECT C.IdCliente, C.Nombre, R.Placa
FROM Maestras.Clientes C
RIGHT JOIN Transacciones.RegistrosVehiculos R ON C.IdCliente = R.IdCliente;
GO
-- FULL OUTER.- Devuelve todas las filas cuando hay una coincidencia en una de las tablas. Si no hay coincidencia, los valores de la tabla sin coincidencia serán NULL.
SELECT C.IdCliente, C.Nombre, R.Placa
FROM Maestras.Clientes C
FULL OUTER JOIN Transacciones.RegistrosVehiculos R ON C.IdCliente = R.IdCliente;
GO
-- CROSS JOIN.- Devuelve el producto cartesiano de las filas de las tablas involucradas, es decir, combina cada fila de la primera tabla con cada fila de la segunda tabla.
SELECT C.IdCliente, C.Nombre, R.Placa
FROM Maestras.Clientes C
CROSS JOIN Transacciones.RegistrosVehiculos R;
-- OPERADOR LIKE.- Permite realizar búsquedas de patrones en columnas de texto utilizando comodines como:
-- %.- Representa cero o más caracteres.
SELECT IdCliente, Nombre, Apellido
FROM Maestras.Clientes
WHERE Nombre LIKE 'J%';  -- Nombres que comienzan con 'J'
GO
-- _.- Representa un solo carácter.
SELECT IdCliente, Nombre, Apellido
FROM Maestras.Clientes
WHERE Apellido LIKE 'S_n%';  -- Apellidos que comienzan con 'S', tienen una letra en medio y luego cualquier cosa
GO
-- ESTRUCTURA CASE.- Permite realizar evaluaciones condicionales en consultas SQL, devolviendo resultados diferentes según las condiciones especificadas.
SELECT IdCliente, Nombre, Activo,
       CASE 
           WHEN Activo = 1 THEN 'Activo'
           ELSE 'Inactivo'
       END AS EstadoCliente
FROM Maestras.Clientes;
GO
-- CURSORES.- Permiten recorrer fila por fila un conjunto de resultados y realizar operaciones específicas en cada fila. Aunque su uso no es recomendado para grandes conjuntos de datos debido a problemas de rendimiento, pueden ser útiles en ciertos escenarios.
-- Created by GitHub Copilot in SSMS - review carefully before executing
DECLARE @IdCliente INT;
DECLARE @Nombre NVARCHAR(100);
DECLARE @Apellido NVARCHAR(100);

DECLARE cursor_clientes CURSOR FOR
    SELECT IdCliente, Nombre, Apellido
    FROM Maestras.Clientes
    WHERE Activo = 1;

OPEN cursor_clientes;
FETCH NEXT FROM cursor_clientes INTO @IdCliente, @Nombre, @Apellido;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Id: ' + CAST(@IdCliente AS VARCHAR) + 
          ' | Nombre: ' + @Nombre + ' ' + @Apellido;
    
    FETCH NEXT FROM cursor_clientes INTO @IdCliente, @Nombre, @Apellido;
END

CLOSE cursor_clientes;
DEALLOCATE cursor_clientes;
GO
-- FUNCIONES DE SISTEMA.- Permiten realizar operaciones específicas en consultas SQL, como manipulación de cadenas, fechas, matemáticas, entre otras. Algunas funciones comunes incluyen:
-- GEDTDATE.- Devuelve la fecha y hora actual del sistema.
SELECT GETDATE() AS FechaActual;
GO
-- ISNULL.- Permite reemplazar un valor NULL por un valor especificado.
SELECT IdCliente, Nombre, Email, ISNULL(Email, 'No proporcionado') AS EmailCompleto
FROM Maestras.Clientes;
GO
-- COALESCE.- Devuelve el primer valor no NULL de una lista de expresiones.
SELECT IdCliente, Nombre, Email, COALESCE(Email, 'No proporcionado') AS EmailCompleto
FROM Maestras.Clientes;
GO
-- NEWID.- Genera un valor único global (GUID) que se puede usar como identificador único en tablas o para otros propósitos.
SELECT NEWID() AS NuevoGUID;
GO
--ARCHIVOS XML.- Permite trabajar con datos en formato XML, facilitando la integración con aplicaciones web y servicios RESTful.
SELECT * 
FROM Maestras.Clientes
FOR XML AUTO,ROOT('Cabecera'), ELEMENTS
GO
-- ARCHIVOS JSON.- Permite trabajar con datos en formato JSON, facilitando la integración con aplicaciones web y servicios RESTful.
SELECT * 
FROM Maestras.Clientes
FOR JSON AUTO, ROOT('Clientes')
GO
-- OPERADOR OPENROWSET.- Permite acceder a datos de fuentes externas, como archivos CSV, Excel o bases de datos remotas, directamente desde una consulta SQL.
SELECT TOP 10 *
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
                'Excel 12.0; 
                 Database=/var/opt/mssql/datasets/CIE10.xlsx; 
                 HDR=YES',
                'SELECT * FROM [CIE10$]');-- AL NOMBRE DE LA HOJA DE EXCEL SE LE AGREGA EL SIGNO $ AL FINAL
GO
-- HABILITAR 
/*
Mens. 15281, Nivel 16, Estado 1, Línea 60
SQL Server bloqueó el acceso a STATEMENT 'OpenRowset/OpenDatasource' del componente 'Ad Hoc Distributed Queries' porque este componente está desactivado como parte de la configuración de seguridad de este servidor. Un administrador del sistema puede habilitar el uso de 'Ad Hoc Distributed Queries' mediante sp_configure. Para obtener más información acerca de cómo habilitar 'Ad Hoc Distributed Queries', busque 'Ad Hoc Distributed Queries' en los Libros en pantalla de SQL Server.
*/
EXEC sp_configure 'show advanced options', 1;
exec sp_configure 'Ad Hoc Distributed Queries', 1;
reconfigure;
exec sp_configure 'show advanced options', 0;
GO
/*VERIFCAR INSTANCIA*/
EXEC SYS.sp_enum_oledb_providers
/*
Mens. 7302, Nivel 16, Estado 1, Línea 60
No se puede crear una instancia del proveedor OLE DB 'Microsoft.ACE.OLEDB.12.0' para el servidor vinculado '(null)'.
*/
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO
EXEC master.dbo.sp_MSset_oledb_prop
    N'Microsoft.ACE.OLEDB.12.0',
    N'AllowInProcess',1
GO
-- CARGA MASIVA BULK INSERT.- Permite cargar grandes volúmenes de datos desde archivos externos (CSV, TXT) a tablas de SQL Server de manera eficiente.
SELECT * FROM Maestras.Clientes;--100
GO
CREATE TABLE [Maestras].[Clientess](	
	[Nombre] [nvarchar](100) NOT NULL,
	[Apellido] [nvarchar](100) NOT NULL,
	[Cedula] [nvarchar](20) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Telefono] [nvarchar](20) NULL,
	[Direccion] [nvarchar](255) NULL,	
	[Activo] [bit] NULL,
) ON [PRIMARY]
GO
BULK INSERT Maestras.Clientess
FROM '/var/opt/mssql/datasets/Clientes.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',--'\n', en vez de '\n' se esta usando el valor hexadecimal 0x0d0a en UBUNTU
    FIRSTROW = 2,
    --CODEPAGE = '65001',
    TABLOCK
);
GO
SELECT * FROM Maestras.Clientess;--100
GO
-- AUTOMATIZACIÓN CON JOB.- Permite programar tareas recurrentes en SQL Server, como:
-- Mantenimiento de índices.- Reorganización o reconstrucción de índices para mejorar el rendimiento de las consultas.
SELECT 
    OBJECT_NAME(i.object_id) AS Tabla,
    i.name AS Indice,
    i.type_desc AS TipoIndice,
    i.is_disabled AS IndiceDeshabilitado
FROM sys.indexes i
WHERE OBJECT_NAME(i.object_id) = 'RegistrosVehiculos';
GO
-- Generación de reportes y limpieza de datos.- Programar tareas para generar reportes periódicos o limpiar datos antiguos.
SELECT 
    IdRegistro, Placa, FechaIngreso, TiempoHoras
FROM Transacciones.RegistrosVehiculos
WHERE FechaIngreso < DATEADD(MONTH, -6, GETDATE());  -- Registros anteriores a 6 meses
GO
-- Backup automáticos.- Programar copias de seguridad regulares para proteger los datos.
-- VERIFCAR LA BD_COCHERA LAS COPIAS DE SEGURIDAD
SELECT 
    name AS BaseDatos,
    backup_start_date AS FechaBackup,
    backup_finish_date AS FechaFinBackup,
    backup_size / 1024 / 1024 AS TamañoMB
FROM msdb.dbo.backupset
WHERE database_name = 'BD_COCHERA'
GO
-- TIPOS DE OPERADORES
-- Operadores aritméticos: +, -, *, / y %.- Permiten realizar operaciones matemáticas básicas entre valores numéricos.
SELECT 10 + 5 AS Suma,
       10 - 5 AS Resta,
       10 * 5 AS Multiplicacion,
       10 / 5 AS Division,
       10 % 3 AS Modulo;
GO
-- Operadores lógicos: AND, OR, NOT.- Permiten combinar condiciones lógicas en cláusulas WHERE para filtrar resultados.
SELECT IdCliente,
       Nombre,
       Apellido,
       Activo
FROM Maestras.Clientes
WHERE Activo = 1 AND Cedula IS NOT NULL;  -- Clientes activos con cédula no nula
GO
SELECT IdCliente,
       Nombre,
       Apellido,
       Activo
FROM Maestras.Clientes
WHERE Activo = 1 OR Cedula IS NOT NULL;  -- Clientes activos o con cédula no nula
GO
SELECT IdCliente,
       Nombre,
       Apellido,
       Activo
FROM Maestras.Clientes
WHERE NOT (Activo = 0);  -- Clientes que no están inactivos
GO
-- Operadores de comparación.- Permiten comparar valores y devolver un resultado booleano (verdadero o falso). Algunos ejemplos son:
-- 1. Igualdad (=)
-- Buscar cliente específico
SELECT IdCliente, Nombre, Apellido, Cedula
FROM Maestras.Clientes
WHERE IdCliente = 5;
GO
--2. No Igual (<>)
-- Buscar todos los clientes excepto uno
SELECT Nombre, Apellido, Email
FROM Maestras.Clientes
WHERE Activo <> 0;  -- Clientes activos
GO
--3. Mayor que (>)
-- Registros con más de 8 horas de estancia
SELECT IdRegistro, Placa, FechaIngreso, TiempoHoras
FROM Transacciones.RegistrosVehiculos
WHERE TiempoHoras > 8;
GO
-- 4. Menor que (<)
-- Registros con menos de 2 horas
SELECT IdRegistro, Placa, TiempoHoras
FROM Transacciones.RegistrosVehiculos
WHERE TiempoHoras < 2;
GO
--Transacciones.Pagos
-- 5. Mayor o igual (>=)
-- Pagos de $50 o más
SELECT IdPago, Monto, MetodoPago, FechaPago
FROM Transacciones.Pagos
WHERE Monto >= 50.00;
GO
-- 6. Menor o igual (<=)
-- Pagos de $100 o menos
SELECT IdPago, Monto, Estado
FROM Transacciones.Pagos
WHERE Monto <= 100.00;
GO
--Combinando Múltiples Operadores
-- Pagos entre $25 y $75 que estén PAGADOS
SELECT IdPago, Monto, Estado, FechaPago
FROM Transacciones.Pagos
WHERE Monto >= 25.00 
  AND Monto <= 75.00
  AND Estado = 'PAGADO';
GO
-- Clientes activos cuya cédula no está vacía
SELECT IdCliente, Nombre, Cedula
FROM Maestras.Clientes
WHERE Activo = 1
  AND Cedula <> '';
GO
-- Operadores con Fechas
-- Registros de hoy o posteriores
SELECT IdRegistro, Placa, FechaIngreso
FROM Transacciones.RegistrosVehiculos
WHERE FechaIngreso >= CAST(GETDATE() AS DATE);
GO
-- Eventos anteriores a hoy
SELECT IdEvento, Tipo, FechaEvento
FROM Procesos.BitacoraEventos
WHERE FechaEvento < CAST(GETDATE() AS DATE);
GO
-- DATOS AGRUPADOS.- Permiten agrupar filas que tienen valores iguales en columnas específicas y realizar cálculos sobre cada grupo.
SELECT V.IdTipoVehiculo AS Codigo,
       TV.Descripcion AS TipoVehiculo,
       COUNT(*) AS Cantidad 
FROM Transacciones.RegistrosVehiculos V 
INNER JOIN Maestras.TiposVehiculos TV ON V.IdTipoVehiculo = TV.IdTipoVehiculo
GROUP BY V.IdTipoVehiculo,TV.Descripcion;
GO
-- FUNCIONES AGREGADAS.- Permiten realizar cálculos sobre un conjunto de valores y devolver un solo valor.
-- SUM.- Permite calcular la suma total de un conjunto de valores numéricos.
SELECT SUM(Monto) AS TotalIngresos FROM Transacciones.Pagos;
GO
-- COUNT.- Permite contar el número de filas que cumplen una condición específica o el número total de filas en una tabla.
SELECT COUNT(*) AS TotalRegistros FROM Transacciones.RegistrosVehiculos;
GO
-- AVG.- Permite calcular el valor promedio de un conjunto de valores numéricos.
SELECT AVG(Monto) AS PromedioIngresos FROM Transacciones.Pagos;
GO
-- MIN.- Permite encontrar el valor mínimo en un conjunto de valores numéricos.
SELECT MIN(Monto) AS MontoMinimo FROM Transacciones.Pagos;
GO
-- MAX.- Permite encontrar el valor máximo en un conjunto de valores numéricos.
SELECT MAX(Monto) AS MontoMaximo FROM Transacciones.Pagos;
GO
-- PIVOT.- Permite transformar filas en columnas, facilitando la visualización de datos agregados.
-- Contar Registros por Tipo de Vehículo y Estado
SELECT 
    tv.Descripcion AS TipoVehiculo,
    [EN_COCHERA] AS EnCochera,
    [EGRESADO] AS Egresado
FROM (
    SELECT 
        rv.IdTipoVehiculo,
        rv.Estado,
        COUNT(*) AS Cantidad
    FROM Transacciones.RegistrosVehiculos rv
    GROUP BY rv.IdTipoVehiculo, rv.Estado
) AS source_table
PIVOT (
    SUM(Cantidad)
    FOR Estado IN ([EN_COCHERA], [EGRESADO])
) AS pivot_table
INNER JOIN Maestras.TiposVehiculos tv ON pivot_table.IdTipoVehiculo = tv.IdTipoVehiculo
ORDER BY TipoVehiculo;
GO
--  Ingresos por Tipo de Vehículo y Método de Pago
SELECT 
    tv.Descripcion AS TipoVehiculo,
    [EFECTIVO] AS Efectivo,
    [TARJETA] AS Tarjeta,
    [TRANSFERENCIA] AS Transferencia
FROM (
    SELECT 
        rv.IdTipoVehiculo,
        p.MetodoPago,
        SUM(p.Monto) AS Ingresos
    FROM Transacciones.Pagos p
    INNER JOIN Transacciones.RegistrosVehiculos rv ON p.IdRegistro = rv.IdRegistro
    GROUP BY rv.IdTipoVehiculo, p.MetodoPago
) AS source_table
PIVOT (
    SUM(Ingresos)
    FOR MetodoPago IN ([EFECTIVO], [TARJETA], [TRANSFERENCIA])
) AS pivot_table
INNER JOIN Maestras.TiposVehiculos tv ON pivot_table.IdTipoVehiculo = tv.IdTipoVehiculo
ORDER BY TipoVehiculo;
GO
-- UNPIVOT
SELECT 
    tv.Descripcion AS TipoVehiculo,
    tarifa_type AS TipoTarifa,
    tarifa_value AS Valor
FROM (
    SELECT 
        IdTipoVehiculo,
        TarifaPorHora,
        TarifaDiaria,
        TarifaMensual
    FROM Maestras.Tarifas
    WHERE FechaVigencia = CAST(GETDATE() AS DATE)
) AS source_table
UNPIVOT (
    tarifa_value FOR tarifa_type IN (TarifaPorHora, TarifaDiaria, TarifaMensual)
) AS unpivot_table
INNER JOIN Maestras.TiposVehiculos tv ON unpivot_table.IdTipoVehiculo = tv.IdTipoVehiculo
ORDER BY TipoVehiculo, TipoTarifa;
GO
SELECT 
    tv.Descripcion AS TipoVehiculo,
    tarifa_type AS TipoTarifa,
    tarifa_value AS Valor
FROM (
    SELECT 
        IdTipoVehiculo,
        TarifaPorHora,
        TarifaDiaria,
        TarifaMensual
    FROM Maestras.Tarifas
    WHERE FechaVigencia = CAST(GETDATE() AS DATE)
) AS source_table
UNPIVOT (
    tarifa_value FOR tarifa_type IN (TarifaPorHora, TarifaDiaria, TarifaMensual)
) AS unpivot_table
INNER JOIN Maestras.TiposVehiculos tv ON unpivot_table.IdTipoVehiculo = tv.IdTipoVehiculo
ORDER BY TipoVehiculo, TipoTarifa;
GO
-- Despivotar Estado de Pagos y Multas
SELECT 
    id,
    tipo_movimiento,
    estado,
    monto
FROM (
    SELECT 
        IdPago AS id,
        'Pago' AS tipo_movimiento,
        Estado,
        Monto
    FROM Transacciones.Pagos
    
    UNION ALL
    
    SELECT 
        IdMulta,
        'Multa',
        Estado,
        Monto
    FROM Transacciones.Multas
) AS combined_data
ORDER BY tipo_movimiento, id;
GO
-- MANEJO DE CONTROL DE ERRORES
-- Funcion ERROR_MESSAGE.- Devuelve el mensaje de error generado por la ultima instruccion que causo un error
BEGIN TRY
    -- Error intencional: IdCliente es INT, no VARCHAR
    SELECT * FROM Maestras.Clientes WHERE IdCliente = 'ABC123';
END TRY
BEGIN CATCH
    SELECT 
        ERROR_MESSAGE() AS MensajeError,
        ERROR_NUMBER() AS NumeroError,
        ERROR_SEVERITY() AS NivelSeveridad,
        ERROR_STATE() AS Estado;
END CATCH
GO
-- Insertar con Validación
BEGIN TRY
    -- Intentar insertar cliente con cédula duplicada
    INSERT INTO Maestras.Clientes (Nombre, Apellido, Cedula, Email, Telefono, Direccion, Activo)
    VALUES ('Test', 'Usuario', '1001001001', 'test@email.com', '555-0000', 'Calle Test', 1);
END TRY
BEGIN CATCH
    SELECT 
        ERROR_MESSAGE() AS MensajeError,
        'Maestras.Clientes' AS TablaAfectada,
        GETDATE() AS FechaError;
END CATCH
GO
-- Funcion ERROR_NUMBER.-  Devuelve el número de error generado por la última instrucción que causó un error.
BEGIN TRY
    -- Error: Violación de restricción UNIQUE en Cedula
    INSERT INTO Maestras.Clientes (Nombre, Apellido, Cedula, Email, Telefono, Direccion, Activo)
    VALUES ('Juan', 'Pérez', '1001001001', 'juan@email.com', '555-1111', 'Calle 1', 1);
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS CodigoError,
        ERROR_MESSAGE() AS MensajeError,
        ERROR_SEVERITY() AS Severidad,
        ERROR_LINE() AS LineaError;
END CATCH
GO
--  Detectar Tipo de Error
BEGIN TRY
    -- Intentar insertar cédula duplicada
    INSERT INTO Maestras.Clientes (Nombre, Apellido, Cedula, Email, Telefono, Direccion, Activo)
    VALUES ('María', 'López', '1001001001', 'maria@email.com', '555-2222', 'Calle 2', 1);
END TRY
BEGIN CATCH
    DECLARE @CodigoError INT = ERROR_NUMBER();
    
    SELECT 
        @CodigoError AS CodigoError,
        ERROR_MESSAGE() AS MensajeError,
        CASE 
            WHEN @CodigoError = 2627 THEN 'Error: Cédula duplicada'
            WHEN @CodigoError = 515 THEN 'Error: Campo requerido vacío'
            WHEN @CodigoError = 241 THEN 'Error: Tipo de dato inválido'
            ELSE 'Error desconocido'
        END AS TipoError;
END CATCH
GO
-- MANIPULACION DE FUNCIONES DE CADENA
-- Left.- Devuelve un número especifico de caracteres desde el inicio de una cadena
SELECT LEFT('Hola Mundo', 4) AS ResultadoLeft;
GO
-- Right.- Devuelve un número especifico de caracteres desde el final de una cadena
SELECT RIGHT('Hola Mundo', 5) AS ResultadoRight;
GO
-- Substring.- Devuelve un número especifico de caracteres desde un punto especifico de una cadena
SELECT SUBSTRING('Hola Mundo', 6, 5) AS ResultadoSubstring;
GO
-- Len.- Devuelve la longitud de una cadena
SELECT LEN('Hola Mundo') AS ResultadoLength;
GO
-- Replace.- Reemplaza una cadena por otra
SELECT REPLACE('Hola Mundo', 'Mundo', 'SQL SERVER') AS ResultadoReplace;
GO






-- Trabajando Funciones de Fecha
-- GetDate.- Devuelve la fecha y hora actual del sistema
SELECT GETDATE() AS FechaActual;
GO
-- DATEPART.- Especifica una parte de la fecha (año, mes, día, hora, minuto, segundo)
SELECT DATEPART(YEAR, GETDATE()) AS AñoActual,
       DATEPART(MONTH, GETDATE()) AS MesActual,
       DATEPART(DAY, GETDATE()) AS DiaActual;
GO
-- DATENAME.- Devuelve el nombre de una parte de la fecha (año, mes, día, hora, minuto, segundo)
SELECT DATENAME(WEEKDAY, GETDATE()) AS NombreSemanaActual,
       DATENAME(MONTH, GETDATE()) AS NombreMesActual,
       DATENAME(DAY, GETDATE()) AS NombreDiaActual;
GO
-- DATEADD.- Agrega un intervalo de tiempo a una fecha (Fecha + tiempo)
SELECT DATEADD(DAY, 7,GETDATE()) AS FechaDentroDeUnaSemana,
       DATEADD(MONTH,1,GETDATE()) AS FechaDentroDeUnMes,
       DATEADD(YEAR, 1,GETDATE()) AS FechaDentroDeUnAño;
GO
--DATEDIFF.- Devuelve la diferencia entre dos fechas en una unidad de tiempo especificada (Año, Mes, día, Hora, Minuto, Segundo)
SELECT DATEDIFF(DAY, '2024-01-01', GETDATE()) AS DiasDesdeInicioDeAño,
       DATEDIFF(MONTH, '2024-01-01', GETDATE()) AS MesesDesdeInicioDeAño,
       DATEDIFF(YEAR, '2020-01-01', GETDATE()) AS AñosDesde2020;
GO
--FORMAT.- Devuelve una cadena con formato de fecha y hora según se
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') AS FechaFormateada,
       FORMAT(GETDATE(), 'MM/dd/yyyy') AS FechaConNombreDelMes,
       FORMAT(GETDATE(), 'hh:mm:ss tt') AS HoraFormateada;
GO

