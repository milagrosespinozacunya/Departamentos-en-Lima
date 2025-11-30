-- 1. Crear tabla temporal con datos enteros y vista corregida
DROP TABLE IF EXISTS venta_temp;

SELECT 
  [F1] AS id_tiempo,
  [Año],
  [Trimestre],
  COALESCE([Precio en dólares corrientes], 0) AS [Precio en dólares corrientes],
  COALESCE([Tipo de cambio], 1.0) AS [Tipo de cambio],
  COALESCE([IPC], 100.0) AS [IPC],
  COALESCE([Precio en soles corrientes], 0) AS [Precio en soles corrientes],
  COALESCE([Precio en soles constantes de 2009], 0) AS [Precio en soles constantes de 2009],
  
  -- Limpieza y formato del distrito
  CONCAT(UPPER(LEFT(LTRIM(RTRIM(Distrito)),1)), LOWER(SUBSTRING(LTRIM(RTRIM(Distrito)),2,LEN(Distrito)))) AS Distrito,
  
  CAST([Superficie ] AS INT) AS Superficie,
  CAST([Número de habitaciones] AS INT) AS [Número de habitaciones],
  CAST([Número de baños] AS INT) AS [Número de baños],
  CAST([Número de garajes] AS INT) AS [Número de garages],
  CAST([Piso de ubicación] AS INT) AS [Piso de ubicación],
  CASE 
    WHEN CAST([Vista al exterior] AS INT) = 11 THEN 1
    ELSE CAST([Vista al exterior] AS INT)
  END AS [Vista al exterior],
  CAST([Años de antigüedad] AS INT) AS [Años de antigüedad]

INTO venta_temp
FROM dbo.venta
WHERE [Año] >= 2015;

-- 2. Calcular promedios
WITH promedios AS (
  SELECT 
    ROUND(AVG(CAST(Superficie AS FLOAT)), 0) AS Sup,
    ROUND(AVG(CAST([Número de habitaciones] AS FLOAT)), 0) AS Hab,
    ROUND(AVG(CAST([Número de baños] AS FLOAT)), 0) AS Ban,
    ROUND(AVG(CAST([Número de garages] AS FLOAT)), 0) AS Gar,
    ROUND(AVG(CAST([Piso de ubicación] AS FLOAT)), 0) AS Piso,
    ROUND(AVG(CAST([Vista al exterior] AS FLOAT)), 0) AS Vista,
    ROUND(AVG(CAST([Años de antigüedad] AS FLOAT)), 0) AS Ant
  FROM venta_temp
)

-- 3. Crear tabla limpia con imputación y clave
SELECT 
  v.id_tiempo,
  v.Año,
  v.Trimestre,
  v.[Precio en dólares corrientes],
  v.[Tipo de cambio],
  v.[IPC],
  v.[Precio en soles corrientes],
  v.[Precio en soles constantes de 2009],
  v.Distrito,
  
  COALESCE(v.Superficie, p.Sup) AS Superficie,
  COALESCE(v.[Número de habitaciones], p.Hab) AS [Número de habitaciones],
  COALESCE(v.[Número de baños], p.Ban) AS [Número de baños],
  COALESCE(v.[Número de garages], p.Gar) AS [Número de garages],
  COALESCE(v.[Piso de ubicación], p.Piso) AS [Piso de ubicación],
  COALESCE(v.[Vista al exterior], p.Vista) AS [Vista al exterior],
  COALESCE(v.[Años de antigüedad], p.Ant) AS [Años de antigüedad],

  -- Clave temporal
  CAST(COALESCE(v.Superficie, p.Sup) AS VARCHAR) + '-' +
  CAST(COALESCE(v.[Número de habitaciones], p.Hab) AS VARCHAR) + '-' +
  CAST(COALESCE(v.[Número de baños], p.Ban) AS VARCHAR) + '-' +
  CAST(COALESCE(v.[Número de garages], p.Gar) AS VARCHAR) + '-' +
  CAST(COALESCE(v.[Piso de ubicación], p.Piso) AS VARCHAR) + '-' +
  CAST(COALESCE(v.[Vista al exterior], p.Vista) AS VARCHAR) + '-' +
  CAST(COALESCE(v.[Años de antigüedad], p.Ant) AS VARCHAR) AS IdInmuebleTemp

INTO venta_limpio
FROM venta_temp v
CROSS JOIN promedios p;

-- 4. Crear tabla de hechos con id_venta
DROP TABLE IF EXISTS hechosventa;

SELECT 
  ROW_NUMBER() OVER (ORDER BY Año, Trimestre, id_tiempo) AS id_venta,
  *
INTO hechosventa
FROM venta_limpio;


select*from hechosventa
ORDER BY id_venta