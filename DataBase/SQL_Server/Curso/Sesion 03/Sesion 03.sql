-- CONSULTAS
-- Consultas Básicas (Clausula WHERE, DISTINCT, IN, ORDER BY)
SELECT *
FROM BD_Cochera.Procesos.Auditoria
GO
-- Consulta Básica con la Cláusula WHERE 
SELECT * 
FROM BD_Cochera.Maestras.Clientes
WHERE Apellido = 'García'
GO
SELECT * 
FROM BD_Cochera.Maestras.TiposVehiculos
WHERE TarifaDiaria > 90
GO
SELECT * 
FROM BD_Cochera.Maestras.TiposVehiculos
WHERE TarifaDiaria < 90
GO
-- Consulta básica con la DISTINCT
SELECT DISTINCT --IdEspacio,
       --NumeroEspacio,
       --Piso,
       IdTipoVehiculo --,
       --Disponible,
       --FechaCreacion
FROM BD_Cochera.Maestras.EspaciosEstacionamiento
GO
-- IdTipoVehiculo
--20.1 2 3 4 5
--19.1 2 3 4 5
--18.1 2 3 4 5
--17.1 2 3 4 5
--16.1 2 3 4 5
--15.1 2 3 4 5
--14.1 2 3 4 5
--13.1 2 3 4 5
--12.1 2 3 4 5
--11.1 2 3 4 5
--10.1 2 3 4 5
--9. 1 2 3 4 5
--8. 1 2 3 4 5
--7. 1 2 3 4 5
--6. 1 2 3 4 5
--5. 1 2 3 4 5
--4. 1 2 3 4 5
--3. 1 2 3 4 5
--2. 1 2 3 4 5
--1. 1 2 3 4 5
GO
-- Consultas Básicas con la Cláusula IN
SELECT * 
FROM BD_Cochera.Maestras.Clientes
WHERE Apellido = 'García' AND Apellido = 'López'
GO
SELECT * 
FROM BD_Cochera.Maestras.Clientes
WHERE Apellido = 'Rodríguez' AND Nombre = 'Carlos'
GO
SELECT * 
FROM BD_Cochera.Maestras.Clientes
WHERE Apellido = 'García' OR Apellido = 'López'
GO
SELECT * 
FROM BD_Cochera.Maestras.Clientes
WHERE Apellido IN ('García', 'López')
GO
-- Consulta Básica con la Cláusula ORDER BY
SELECT *
FROM BD_Cochera.Maestras.Tarifas
ORDER BY TarifaMensual DESC
GO
SELECT *
FROM BD_Cochera.Maestras.Tarifas
ORDER BY TarifaMensual ASC
GO
SELECT *
FROM BD_Cochera.Maestras.Tarifas
ORDER BY TarifaMensual
GO
-- Consulta Básica con BETWEEN
SELECT *
FROM BD_Cochera.Transacciones.RegistrosVehiculos
WHERE CAST(FechaIngreso AS DATE) = '2026-16-09'
GO
SELECT *
FROM BD_Cochera.Transacciones.RegistrosVehiculos
WHERE FechaIngreso BETWEEN '2026-06-01' AND '2026-12-31'
/* 
FROM BD_Cochera.Transacciones.RegistrosVehiculos
WHERE TRY_CONVERT (DATE,FechaIngreso,103) BETWEEN '2026-06-01' AND '2026-12-31' -- Si el resultado pide conversion de datos tipo Varchar en datetime
*/
SELECT *
FROM BD_Cochera.Transacciones.RegistrosVehiculos
WHERE IdTipoVehiculo BETWEEN 4 AND 5
GO
SELECT *
FROM BD_Cochera.Transacciones.RegistrosVehiculos
--WHERE IdTipoVehiculo BETWEEN >= 2 AND <=5
WHERE IdTipoVehiculo BETWEEN 2 AND 5
GO
-- Consultas Avanzadas (Group By)
SELECT MetodoPago,
       COUNT(*) AS CantidadPagos
FROM BD_Cochera.Transacciones.Pagos
GROUP BY MetodoPago
GO
-- Consultas Avanzadas Having
SELECT Concepto,
       COUNT(*) AS CantidadMultas       
FROM BD_Cochera.Transacciones.Multas
GROUP BY Concepto
GO
SELECT MetodoPago,
       COUNT(*) AS CantidadPagos
FROM BD_Cochera.Transacciones.Pagos
--WHERE COUNT(*) > 5
GROUP BY MetodoPago
HAVING COUNT(*) > 33
GO
-- Consultas Avanzadas Funciones de agregación (COUNT, SUM, AVG)
--COUNT
SELECT COUNT(*) AS TotalBitacora
FROM BD_Cochera.Procesos.BitacoraEventos
GO
--SUM
SELECT SUM(IdRegistroAfectado) AS TotalBitacora
FROM BD_Cochera.Procesos.BitacoraEventos
GO
--AVG
SELECT AVG(IdRegistroAfectado) AS TotalBitacora
FROM BD_Cochera.Procesos.BitacoraEventos
GO
-- Consultas Avanzadas operadores lógicos (AND, OR , NOT)
--AND
SELECT *
FROM BD_Cochera.Procesos.BitacoraEventos
WHERE Tipo = 'Egreso' AND TablaAfectada = 'RegistrosVehiculos'
GO
--OR
SELECT *
FROM BD_Cochera.Procesos.BitacoraEventos
WHERE TablaAfectada = 'Pagos' OR TablaAfectada = 'RegistrosVehiculos'
GO
--NOT
SELECT *
FROM BD_Cochera.Procesos.BitacoraEventos
WHERE NOT TablaAfectada = 'Pagos'
GO
-- SubConsultas (SELECT, FROM, WHERE)
-- SELECT
SELECT DISTINCT Tipo,
       (SELECT COUNT(*) FROM BD_Cochera.Procesos.BitacoraEventos PBE
        WHERE BE.IdEvento = PBE.IdEvento
       ) AS TotalBitacora
FROM BD_Cochera.Procesos.BitacoraEventos BE
GO
-- FROM
SELECT *
FROM (SELECT TablaAfectada,
             COUNT(*) AS TotalBitacora
      FROM BD_Cochera.Procesos.BitacoraEventos
      GROUP BY TablaAfectada) AS Resumen
      WHERE TotalBitacora > 25
GO
-- WHERE
SELECT *
FROM BD_Cochera.Procesos.BitacoraEventos
WHERE TablaAfectada IN(SELECT TablaAfectada             
      FROM BD_Cochera.Procesos.BitacoraEventos)
GO
SELECT *
FROM BD_Cochera.Procesos.BitacoraEventos
WHERE IdRegistroAfectado IN(SELECT AVG(IdRegistroAfectado)             
      FROM BD_Cochera.Procesos.BitacoraEventos)
GO
-- CTE (Common Table Expression)
WITH Ctes_Eventos AS(
SELECT IdEvento,
       Tipo,
       TablaAfectada,
       IdRegistroAfectado,
       FechaEvento
FROM BD_Cochera.Procesos.BitacoraEventos BE
)
SELECT Tipo,
       COUNT(*) AS TotalBitacora
FROM Ctes_Eventos
GROUP BY Tipo
GO
-- VISTAS
USE BD_Cochera
GO
CREATE SCHEMA Vistas
GO
-- Vistas Simples
CREATE VIEW Vistas.VistaEventos AS 
SELECT IdEvento,
       Tipo,
       TablaAfectada,
       IdRegistroAfectado,
       FechaEvento
FROM Procesos.BitacoraEventos BE
WHERE Tipo = 'Ingreso'
GO
-- USO DE VISTAS
SELECT * FROM Vistas.VistaEventos
GO
CREATE VIEW Vistas.VistaEventos_Egreso AS
SELECT IdEvento,
       Tipo,
       TablaAfectada,
       IdRegistroAfectado,
       FechaEvento
FROM Procesos.BitacoraEventos BE
WHERE Tipo = 'Egreso'
GO
-- USO DE VISTAS
SELECT * FROM Vistas.VistaEventos_Egreso
GO
CREATE VIEW Vistas.VistaEventos_Multa AS
SELECT IdEvento,
       Tipo,
       TablaAfectada,
       IdRegistroAfectado,
       FechaEvento
FROM Procesos.BitacoraEventos BE
WHERE Tipo = 'Multa'
GO
-- USO DE VISTAS
SELECT * FROM Vistas.VistaEventos_Multa
GO
CREATE VIEW Vistas.VistaEventos_Pago AS
SELECT IdEvento,
       Tipo,
       TablaAfectada,
       IdRegistroAfectado,
       FechaEvento
FROM Procesos.BitacoraEventos BE
WHERE Tipo = 'Pago'
GO
-- USO DE VISTAS
SELECT * FROM Vistas.VistaEventos_Pago
-- Vistas Complejas
-- Joins
CREATE VIEW Vistas.Vw_VistaRegistrosCliente AS
SELECT RV.IdRegistro,
       --RV.IdCliente,
       CONCAT(C.Apellido,' ',C.Nombre) AS Cliente,
       --RV.IdEspacio,
       EE.Piso,
       RV.Placa,
       --RV.IdTipoVehiculo,
       TV.Descripcion AS TipoVehiculo,
       RV.FechaIngreso
FROM Transacciones.RegistrosVehiculos RV
INNER JOIN Maestras.Clientes C ON RV.IdCliente = C.IdCliente
INNER JOIN Maestras.TiposVehiculos TV ON RV.IdTipoVehiculo = TV.IdTipoVehiculo
INNER JOIN Maestras.EspaciosEstacionamiento EE ON RV.IdEspacio= EE.IdEspacio
GO
-- USO DE VISTAS
SELECT * FROM Vistas.Vw_VistaRegistrosCliente
GO
SELECT *
FROM Maestras.EspaciosEstacionamiento
GO
-- SubConsulta
CREATE VIEW Vistas.Vw_VistaResumenBitacora AS
SELECT *
FROM (SELECT TablaAfectada,
             COUNT(*) AS TotalBitacora
      FROM BD_Cochera.Procesos.BitacoraEventos
      GROUP BY TablaAfectada) AS Resumen
      WHERE TotalBitacora > 25
GO
-- USO DE VISTAS
SELECT * FROM Vistas.Vw_VistaResumenBitacora
GO
-- Group by
CREATE VIEW Vistas.Vw_VistaResumenBitacora_Tipo AS
SELECT Tipo,
       COUNT(*) AS TotalBitacora
FROM  BD_Cochera.Procesos.BitacoraEventos BE
GROUP BY Tipo
GO
-- USO DE VISTAS
SELECT * FROM Vistas.Vw_VistaResumenBitacora_Tipo
GO
-- Funciones
CREATE VIEW Vistas.Vw_VistaResumenBitacora_Funciones AS
SELECT SUM(IdRegistroAfectado) AS TotalBitacora,
       AVG(IdRegistroAfectado) AS PromedioBitacora,
       COUNT(*) AS CantidadBitacora
FROM BD_Cochera.Procesos.BitacoraEventos
GO
-- USO DE VISTAS
SELECT * FROM Vistas.Vw_VistaResumenBitacora_Funciones  
GO
-- Vistas Indexadas (Materializadas)
CREATE VIEW Vw_VistaResumenBitacora_Funciones_Indexada 
WITH SCHEMABINDING
AS
SELECT IdEvento AS Codigo,
       SUM(IdRegistroAfectado) AS TotalBitacora,
       COUNT_BIG(*) AS CantidadBitacoraBig
FROM Procesos.BitacoraEventos
GROUP BY IdEvento
GO








-- Ver vista Indexada
SELECT * FROM Vw_VistaResumenBitacora_Funciones_Indexada
GO
-- Vistas Particionadas (Optimizar el rendimiento)
CREATE VIEW Vw_VistaResumenBitacora_Particionada
AS
SELECT * FROM Ventas2024 -- Falta crear la tabla Ventas2024
UNION ALL
SELECT * FROM Ventas2025 -- Falta crear la tabla Ventas2025
UNION ALL
SELECT * FROM Ventas2026 -- Falta crear la tabla Ventas2026
GO
-- Verificar el funcionamiento de la Notificación
EXECUTE msdb.dbo.sp_send_dbmail
        @profile_name = 'Notificaciones',
        @recipients = 'chrisalexcorba@gmail.com',
        @subject = 'Reporte de Ingresos',
        @body = 'Se adjunta el reporte de ingresos de los vehiculos',
        @query = 'SELECT IdEvento,
                      Tipo,
                      TablaAfectada,
                      IdRegistroAfectado,
                      FechaEvento
                FROM BD_Cochera.Procesos.BitacoraEventos BE
                WHERE Tipo = ''Ingreso''',
        @attach_query_result_as_file = 1,
        @query_attachment_filename = 'Ingresos.csv'
GO
-- Consultar correos enviados
SELECT sent_status,
       subject,             
       recipients,       
       send_request_date
FROM msdb.dbo.sysmail_mailitems
ORDER BY send_request_date DESC
GO
-- Consultar correos con errores
SELECT log_date,
       event_type,             
       description
FROM msdb.dbo.sysmail_event_log
ORDER BY log_date DESC
GO
-- Funciones de conversión de datos
-- CAST .- Convierte valores de un tipo a otro
SELECT ProductID,
       Name,
       ListPrice,
       CAST(ListPrice AS INT) AS ListPriceInt
FROM AdventureWorks.Production.PRODUCT
WHERE ListPrice > 0
GO
-- CONVERT.- Convierte valores y permite formatear fecha/numeros
SELECT ProductID,
       Name,
       ListPrice,
       CONVERT(VARCHAR,SellEndDate,103) AS FechaDDMMYYYY,
       CONVERT(VARCHAR,SellEndDate,120) AS FechaFormateada
FROM AdventureWorks.Production.PRODUCT
WHERE ListPrice > 0
GO
-- PARSE.- Convierte valores de texto a numeros o a fechas
SELECT PARSE(GETDATE() AS DATE USING 'es-Es') As FechaActual
GO



-- TRY_CAST.- Igual al CAST pero devuelve NULL si la conversion falla
SELECT ProductID,
       Name,
       ListPrice,
       TRY_CAST(FinishedGoodsFlag AS INT) AS FinishedGoodsFlagInt
FROM AdventureWorks.Production.PRODUCT
WHERE ListPrice > 0
GO
-- TRY_CONVERT.-
SELECT ProductID,
       Name,
       ListPrice,
       TRY_CONVERT(DATE, SELLENDDATE) AS FinishedGoodsFlagInt
FROM AdventureWorks.Production.PRODUCT
WHERE ListPrice > 0
GO
-- TRY_PARSE.- Igual al PARSE pero devuelve NULL si la conversion falla
SELECT ProductID,
       Name,
       ListPrice,
       TRY_PARSE('20/08/2026' AS DATE USING 'es-Es') AS FinishedGoodsFlagInt
FROM AdventureWorks.Production.PRODUCT
WHERE ListPrice > 0
GO

