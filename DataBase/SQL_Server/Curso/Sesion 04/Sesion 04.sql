




























































































-- Trabajando Funciones de Fecha
-- GetDate.- Devuelve la fecga y hora actual del sistema
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
-- DATEADD.- Agrega un intervalo de tiempo a una fecha
SELECT DATEADD(DAY, 7,GETDATE()) AS FechaDentroDeUnaSemana,
       DATEADD(MONTH,1,GETDATE()) AS FechaDentroDeUnMes,
       DATEADD(YEAR, 1,GETDATE()) AS FechaDentroDeUnAño;
GO
--DATEDIFF.- Devuelve la diferencia entre dos fechas en una unidad de tiempo especificada (Año, Mes, día, Hora, Minuto, Segundo)
SELECT DATEDIFF(DAY, '2024-01-01', GETDATE()) AS DiasDesdeInicioDeAño,
       DATEDIFF(MONTH, '2024-01-01', GETDATE()) AS MesesDesdeInicioDeAño,
       DATEDIFF(YEAR, '2024-01-01', GETDATE()) AS AñosDesde2020;
GO
--FORMAT.- Devuelve una cadena con formato de fecha y hora según se
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') AS FechaFormateada,
       FORMAT(GETDATE(), 'MM/dd/yyyy') AS FechaConNombreDelMes,
       FORMAT(GETDATE(), 'hh:mm:ss tt') AS HoraFormateada;
GO

