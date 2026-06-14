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
CREATE SCHEMA Transacciones
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
EXECUTE sp_CrearEsquemas 'Maestras,Transacciones,Procesos';





-- Verificar la creación de los esquemas
SELECT *
FROM sys.schemas
GO

-- Created by GitHub Copilot in SSMS - review carefully before executing

-- =====================================================
-- ESQUEMA: Maestras (Datos de Referencia)
-- =====================================================

-- Tabla de Clientes
CREATE TABLE Maestras.Clientes (
    IdCliente INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Cedula NVARCHAR(20) UNIQUE NOT NULL,
    Email NVARCHAR(100),
    Telefono NVARCHAR(20),
    Direccion NVARCHAR(255),
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Activo BIT DEFAULT 1
);

-- Tabla de Tipos de Vehículos
CREATE TABLE Maestras.TiposVehiculos (
    IdTipoVehiculo INT PRIMARY KEY IDENTITY(1,1),
    Descripcion NVARCHAR(100) NOT NULL UNIQUE,
    TarifaPorHora DECIMAL(10,2) NOT NULL,
    TarifaDiaria DECIMAL(10,2) NOT NULL,
    Activo BIT DEFAULT 1
);

-- Tabla de Espacios de Estacionamiento
CREATE TABLE Maestras.EspaciosEstacionamiento (
    IdEspacio INT PRIMARY KEY IDENTITY(1,1),
    NumeroEspacio NVARCHAR(50) NOT NULL UNIQUE,
    Piso INT NOT NULL,
    IdTipoVehiculo INT NOT NULL,
    Disponible BIT DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Espacios_TipoVehiculo FOREIGN KEY (IdTipoVehiculo) 
        REFERENCES Maestras.TiposVehiculos(IdTipoVehiculo)
);

-- Tabla de Tarifas
CREATE TABLE Maestras.Tarifas (
    IdTarifa INT PRIMARY KEY IDENTITY(1,1),
    IdTipoVehiculo INT NOT NULL,
    TarifaPorHora DECIMAL(10,2) NOT NULL,
    TarifaDiaria DECIMAL(10,2) NOT NULL,
    TarifaMensual DECIMAL(10,2),
    FechaVigencia DATE NOT NULL,
    Activa BIT DEFAULT 1,
    CONSTRAINT FK_Tarifas_TipoVehiculo FOREIGN KEY (IdTipoVehiculo) 
        REFERENCES Maestras.TiposVehiculos(IdTipoVehiculo)
);

-- =====================================================
-- ESQUEMA: Transacciones (Movimientos/Operaciones)
-- =====================================================

-- Tabla de Registros de Ingreso/Egreso
CREATE TABLE Transacciones.RegistrosVehiculos (
    IdRegistro INT PRIMARY KEY IDENTITY(1,1),
    IdCliente INT NOT NULL,
    IdEspacio INT NOT NULL,
    Placa NVARCHAR(20) NOT NULL,
    IdTipoVehiculo INT NOT NULL,
    FechaIngreso DATETIME NOT NULL DEFAULT GETDATE(),
    FechaEgreso DATETIME,
    TiempoHoras DECIMAL(10,2),
    Estado NVARCHAR(20) DEFAULT 'EN_COCHERA', -- EN_COCHERA, EGRESADO
    CONSTRAINT FK_Registros_Cliente FOREIGN KEY (IdCliente) 
        REFERENCES Maestras.Clientes(IdCliente),
    CONSTRAINT FK_Registros_Espacio FOREIGN KEY (IdEspacio) 
        REFERENCES Maestras.EspaciosEstacionamiento(IdEspacio),
    CONSTRAINT FK_Registros_TipoVehiculo FOREIGN KEY (IdTipoVehiculo) 
        REFERENCES Maestras.TiposVehiculos(IdTipoVehiculo)
);

-- Tabla de Pagos
CREATE TABLE Transacciones.Pagos (
    IdPago INT PRIMARY KEY IDENTITY(1,1),
    IdRegistro INT NOT NULL,
    Monto DECIMAL(10,2) NOT NULL,
    FechaPago DATETIME DEFAULT GETDATE(),
    MetodoPago NVARCHAR(50) NOT NULL, -- EFECTIVO, TARJETA, TRANSFERENCIA
    Referencia NVARCHAR(100),
    Estado NVARCHAR(20) DEFAULT 'PAGADO', -- PAGADO, PENDIENTE, CANCELADO
    CONSTRAINT FK_Pagos_Registro FOREIGN KEY (IdRegistro) 
        REFERENCES Transacciones.RegistrosVehiculos(IdRegistro)
);

-- Tabla de Multas/Infracciones
CREATE TABLE Transacciones.Multas (
    IdMulta INT PRIMARY KEY IDENTITY(1,1),
    IdRegistro INT NOT NULL,
    Concepto NVARCHAR(255) NOT NULL,
    Monto DECIMAL(10,2) NOT NULL,
    FechaMulta DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(20) DEFAULT 'PENDIENTE', -- PENDIENTE, PAGADA, ANULADA
    CONSTRAINT FK_Multas_Registro FOREIGN KEY (IdRegistro) 
        REFERENCES Transacciones.RegistrosVehiculos(IdRegistro)
);

-- =====================================================
-- ESQUEMA: Procesos (Gestión de Procesos)
-- =====================================================

-- Tabla de Bitácora de Eventos
CREATE TABLE Procesos.BitacoraEventos (
    IdEvento INT PRIMARY KEY IDENTITY(1,1),
    Tipo NVARCHAR(50) NOT NULL, -- INGRESO, EGRESO, PAGO, MULTA, ERROR
    Descripcion NVARCHAR(MAX) NOT NULL,
    FechaEvento DATETIME DEFAULT GETDATE(),
    UsuarioId NVARCHAR(100),
    TablaAfectada NVARCHAR(100),
    IdRegistroAfectado INT
);

-- Tabla de Auditoría
CREATE TABLE Procesos.Auditoria (
    IdAuditoria INT PRIMARY KEY IDENTITY(1,1),
    TablaModificada NVARCHAR(100) NOT NULL,
    TipoOperacion NVARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
    RegistroId INT,
    DatosAnteriores NVARCHAR(MAX),
    DatosNuevos NVARCHAR(MAX),
    FechaOperacion DATETIME DEFAULT GETDATE(),
    Usuario NVARCHAR(100)
);

-- =====================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

CREATE INDEX IX_Clientes_Cedula ON Maestras.Clientes(Cedula);
CREATE INDEX IX_EspaciosEstacionamiento_Disponible ON Maestras.EspaciosEstacionamiento(Disponible);
CREATE INDEX IX_RegistrosVehiculos_Placa ON Transacciones.RegistrosVehiculos(Placa);
CREATE INDEX IX_RegistrosVehiculos_Estado ON Transacciones.RegistrosVehiculos(Estado);
CREATE INDEX IX_Pagos_Estado ON Transacciones.Pagos(Estado);
CREATE INDEX IX_Multas_Estado ON Transacciones.Multas(Estado);
GO
-- Created by GitHub Copilot in SSMS - review carefully before executing
-- Script de Datos de Prueba - Mínimo 100 registros por tabla
-- Respetando relaciones de integridad referencial

-- =====================================================
-- 1. INSERTAR DATOS EN MAESTRAS.TiposVehiculos (Base para otras tablas)
-- =====================================================

INSERT INTO Maestras.TiposVehiculos (Descripcion, TarifaPorHora, TarifaDiaria, Activo)
VALUES 
('Auto Compacto', 5.00, 40.00, 1),
('Auto Mediano', 6.00, 48.00, 1),
('Auto Grande', 7.50, 60.00, 1),
('SUV Pequeño', 8.00, 65.00, 1),
('SUV Grande', 10.00, 80.00, 1),
('Pickup', 9.00, 72.00, 1),
('Van', 12.00, 95.00, 1),
('Moto', 3.00, 20.00, 1),
('Bicicleta', 1.50, 10.00, 1),
('Comercial Pequeño', 11.00, 85.00, 1);

-- =====================================================
-- 2. INSERTAR DATOS EN MAESTRAS.Clientes (Mínimo 100)
-- =====================================================

INSERT INTO Maestras.Clientes (Nombre, Apellido, Cedula, Email, Telefono, Direccion, FechaRegistro, Activo)
VALUES 
('Juan', 'García', '1001001001', 'juan.garcia@email.com', '555-0001', 'Calle 1 #100', GETDATE(), 1),
('María', 'López', '1001001002', 'maria.lopez@email.com', '555-0002', 'Calle 2 #200', GETDATE(), 1),
('Carlos', 'Rodríguez', '1001001003', 'carlos.r@email.com', '555-0003', 'Calle 3 #300', GETDATE(), 1),
('Ana', 'Martínez', '1001001004', 'ana.martinez@email.com', '555-0004', 'Calle 4 #400', GETDATE(), 1),
('Pedro', 'Fernández', '1001001005', 'pedro.f@email.com', '555-0005', 'Calle 5 #500', GETDATE(), 1),
('Laura', 'González', '1001001006', 'laura.g@email.com', '555-0006', 'Calle 6 #600', GETDATE(), 1),
('Diego', 'Hernández', '1001001007', 'diego.h@email.com', '555-0007', 'Calle 7 #700', GETDATE(), 1),
('Sofía', 'Pérez', '1001001008', 'sofia.p@email.com', '555-0008', 'Calle 8 #800', GETDATE(), 1),
('Miguel', 'Sánchez', '1001001009', 'miguel.s@email.com', '555-0009', 'Calle 9 #900', GETDATE(), 1),
('Elena', 'Torres', '1001001010', 'elena.t@email.com', '555-0010', 'Calle 10 #1000', GETDATE(), 1);

-- Insertar 90 registros más con un loop para completar 100
DECLARE @i INT = 11;
WHILE @i <= 100
BEGIN
    INSERT INTO Maestras.Clientes (Nombre, Apellido, Cedula, Email, Telefono, Direccion, FechaRegistro, Activo)
    VALUES 
    ('Cliente' + CAST(@i AS VARCHAR), 'Apellido' + CAST(@i AS VARCHAR), '100100' + RIGHT('0000' + CAST(@i AS VARCHAR), 4), 
     'cliente' + CAST(@i AS VARCHAR) + '@email.com', '555-' + RIGHT('0000' + CAST(@i AS VARCHAR), 4), 
     'Calle ' + CAST(@i AS VARCHAR) + ' #' + CAST(@i * 100 AS VARCHAR), DATEADD(DAY, -@i, GETDATE()), 1);
    SET @i = @i + 1;
END

-- =====================================================
-- 3. INSERTAR DATOS EN MAESTRAS.EspaciosEstacionamiento (Mínimo 100)
-- =====================================================

-- Generar 100 espacios distribuidos en 5 pisos (20 espacios por piso)
DECLARE @piso INT = 1;
DECLARE @espacio INT = 1;
DECLARE @tipoVehiculo INT;

WHILE @espacio <= 100
BEGIN
    -- Distribuir tipos de vehículos: 20 de cada tipo
    SET @tipoVehiculo = ((@espacio - 1) % 5) + 1;
    
    INSERT INTO Maestras.EspaciosEstacionamiento (NumeroEspacio, Piso, IdTipoVehiculo, Disponible, FechaCreacion)
    VALUES 
    ('E-' + RIGHT('000' + CAST(@espacio AS VARCHAR), 3), 
     CEILING(CAST(@espacio AS FLOAT) / 20),
     @tipoVehiculo,
     CASE WHEN (@espacio % 3) = 0 THEN 0 ELSE 1 END, -- 33% ocupados
     DATEADD(MONTH, -6, GETDATE()));
    
    SET @espacio = @espacio + 1;
END

-- =====================================================
-- 4. INSERTAR DATOS EN MAESTRAS.Tarifas (Mínimo 100 - Histórico de Tarifas)
-- =====================================================

-- Insertar tarifas para cada tipo de vehículo con diferentes fechas de vigencia
DECLARE @tipoVeh INT = 1;
DECLARE @fechaVig DATE;
DECLARE @mes INT = 0;

WHILE @tipoVeh <= 10
BEGIN
    SET @mes = 0;
    WHILE @mes <= 11 -- 12 meses de histórico
    BEGIN
        INSERT INTO Maestras.Tarifas (IdTipoVehiculo, TarifaPorHora, TarifaDiaria, TarifaMensual, FechaVigencia, Activa)
        SELECT 
            @tipoVeh,
            TarifaPorHora + (@mes * 0.10),
            TarifaDiaria + (@mes * 0.80),
            (TarifaDiaria + (@mes * 0.80)) * 20,
            DATEADD(MONTH, @mes - 12, CAST(GETDATE() AS DATE)),
            CASE WHEN @mes = 0 THEN 1 ELSE 0 END
        FROM Maestras.TiposVehiculos
        WHERE IdTipoVehiculo = @tipoVeh;
        
        SET @mes = @mes + 1;
    END
    SET @tipoVeh = @tipoVeh + 1;
END

-- =====================================================
-- 5. INSERTAR DATOS EN TRANSACCIONES.RegistrosVehiculos (Mínimo 100)
-- =====================================================

DECLARE @cliente INT = 1;
DECLARE @espacio INT = 1;
DECLARE @tipo INT;
DECLARE @placa NVARCHAR(20);
DECLARE @diasAtras INT = 0;
DECLARE @registro INT = 1;

WHILE @registro <= 120 -- 120 registros para más variedad
BEGIN
    SET @cliente = ((@registro - 1) % 100) + 1;
    SET @espacio = ((@registro - 1) % 100) + 1;
    
    SELECT @tipo = IdTipoVehiculo FROM Maestras.EspaciosEstacionamiento WHERE IdEspacio = @espacio;
    SET @placa = 'ABC-' + RIGHT('0000' + CAST(@registro AS VARCHAR), 4);
    SET @diasAtras = FLOOR((@registro - 1) / 3);
    
    INSERT INTO Transacciones.RegistrosVehiculos 
    (IdCliente, IdEspacio, Placa, IdTipoVehiculo, FechaIngreso, FechaEgreso, TiempoHoras, Estado)
    VALUES 
    (@cliente, 
     @espacio, 
     @placa,
     @tipo,
     DATEADD(HOUR, -(@diasAtras * 24 + (@registro % 24)), GETDATE()),
     CASE WHEN (@registro % 3) = 0 THEN NULL 
          ELSE DATEADD(HOUR, -(@diasAtras * 24 + ((@registro - 2) % 24)), GETDATE()) 
     END,
     CASE WHEN (@registro % 3) = 0 THEN NULL ELSE FLOOR(RAND() * 24) + 1 END,
     CASE WHEN (@registro % 3) = 0 THEN 'EN_COCHERA' ELSE 'EGRESADO' END);
    
    SET @registro = @registro + 1;
END

-- =====================================================
-- 6. INSERTAR DATOS EN TRANSACCIONES.Pagos (Mínimo 100)
-- =====================================================

DECLARE @pago INT = 1;
DECLARE @monto DECIMAL(10,2);

WHILE @pago <= 100
BEGIN
    SELECT @monto = (TiempoHoras * TarifaPorHora)
    FROM Transacciones.RegistrosVehiculos rv
    INNER JOIN Maestras.TiposVehiculos tv ON rv.IdTipoVehiculo = tv.IdTipoVehiculo
    WHERE rv.IdRegistro = @pago AND rv.Estado = 'EGRESADO' AND rv.TiempoHoras IS NOT NULL;
    
    IF @monto IS NOT NULL AND @monto > 0
    BEGIN
        INSERT INTO Transacciones.Pagos 
        (IdRegistro, Monto, FechaPago, MetodoPago, Referencia, Estado)
        VALUES 
        (@pago,
         @monto,
         DATEADD(HOUR, 2, (SELECT FechaEgreso FROM Transacciones.RegistrosVehiculos WHERE IdRegistro = @pago)),
         CASE WHEN (@pago % 3) = 0 THEN 'EFECTIVO' 
              WHEN (@pago % 3) = 1 THEN 'TARJETA'
              ELSE 'TRANSFERENCIA' END,
         'REF-' + RIGHT('0000' + CAST(@pago AS VARCHAR), 5),
         'PAGADO');
    END
    
    SET @pago = @pago + 1;
END

-- =====================================================
-- 7. INSERTAR DATOS EN TRANSACCIONES.Multas (Mínimo 100)
-- =====================================================

DECLARE @multa INT = 1;

WHILE @multa <= 100
BEGIN
    IF (@multa % 4) = 0 -- Crear multas cada 4 registros de vehículos
    BEGIN
        INSERT INTO Transacciones.Multas 
        (IdRegistro, Concepto, Monto, FechaMulta, Estado)
        VALUES 
        (@multa,
         CASE WHEN (@multa % 5) = 0 THEN 'Exceso de tiempo'
              WHEN (@multa % 5) = 1 THEN 'Daño al vehículo'
              WHEN (@multa % 5) = 2 THEN 'Parqueo indebido'
              WHEN (@multa % 5) = 3 THEN 'Falta de pago'
              ELSE 'Violación de normas' END,
         CASE WHEN (@multa % 7) = 0 THEN 50.00
              WHEN (@multa % 7) = 1 THEN 75.00
              WHEN (@multa % 7) = 2 THEN 100.00
              ELSE 25.00 END,
         DATEADD(DAY, -((@multa / 4) % 30), GETDATE()),
         CASE WHEN (@multa % 2) = 0 THEN 'PENDIENTE' ELSE 'PAGADA' END);
    END
    
    SET @multa = @multa + 1;
END

-- =====================================================
-- 8. INSERTAR DATOS EN PROCESOS.BitacoraEventos (Mínimo 100)
-- =====================================================

DECLARE @evento INT = 1;

WHILE @evento <= 100
BEGIN
    INSERT INTO Procesos.BitacoraEventos 
    (Tipo, Descripcion, FechaEvento, UsuarioId, TablaAfectada, IdRegistroAfectado)
    VALUES 
    (CASE WHEN (@evento % 4) = 0 THEN 'INGRESO'
          WHEN (@evento % 4) = 1 THEN 'EGRESO'
          WHEN (@evento % 4) = 2 THEN 'PAGO'
          ELSE 'MULTA' END,
     'Evento #' + CAST(@evento AS VARCHAR) + ' procesado correctamente',
     DATEADD(MINUTE, -@evento * 5, GETDATE()),
     'sa',
     CASE WHEN (@evento % 4) = 0 THEN 'RegistrosVehiculos'
          WHEN (@evento % 4) = 1 THEN 'RegistrosVehiculos'
          WHEN (@evento % 4) = 2 THEN 'Pagos'
          ELSE 'Multas' END,
     (@evento % 50) + 1);
    
    SET @evento = @evento + 1;
END

-- =====================================================
-- 9. INSERTAR DATOS EN PROCESOS.Auditoria (Mínimo 100)
-- =====================================================

DECLARE @auditoria INT = 1;

WHILE @auditoria <= 100
BEGIN
    INSERT INTO Procesos.Auditoria 
    (TablaModificada, TipoOperacion, RegistroId, DatosAnteriores, DatosNuevos, FechaOperacion, Usuario)
    VALUES 
    (CASE WHEN (@auditoria % 3) = 0 THEN 'Clientes'
          WHEN (@auditoria % 3) = 1 THEN 'RegistrosVehiculos'
          ELSE 'Pagos' END,
     CASE WHEN (@auditoria % 2) = 0 THEN 'INSERT' ELSE 'UPDATE' END,
     (@auditoria % 50) + 1,
     'NULL',
     'Registro #' + CAST(@auditoria AS VARCHAR),
     DATEADD(DAY, -(@auditoria / 2), GETDATE()),
     'sa');
    
    SET @auditoria = @auditoria + 1;
END

-- =====================================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- =====================================================

SELECT 
    SCHEMA_NAME(t.schema_id) AS Esquema,
    t.name AS Tabla,
    SUM(p.rows) AS TotalRegistros
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE SCHEMA_NAME(t.schema_id) IN ('Maestras', 'Transacciones', 'Procesos')
    AND p.index_id IN (0, 1)
GROUP BY t.schema_id, t.name
ORDER BY Esquema, Tabla;
GO
/*SELECCIONAR TODAS LAS TABLAS*/
SELECT t.name AS Tabla,
       s.name AS Esquema,
       CONCAT('SELECT * FROM ',s.name,'.',t.name) AS Consulta
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name IN ('Maestras', 'Transacciones', 'Procesos')
GO
SELECT * FROM Maestras.Clientes
SELECT * FROM Transacciones.RegistrosVehiculos
SELECT * FROM Transacciones.Pagos
SELECT * FROM Transacciones.Multas
SELECT * FROM Procesos.BitacoraEventos
SELECT * FROM Procesos.Auditoria
SELECT * FROM Maestras.TiposVehiculos
SELECT * FROM Maestras.EspaciosEstacionamiento
SELECT * FROM Maestras.Tarifas
GO