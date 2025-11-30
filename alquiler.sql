-- 1. Crear tabla temporal con datos enteros y vista corregida
DROP TABLE IF EXISTS alquiler_temp;

SELECT 
  [F1] AS id_tiempo,
  [Año],
  [Trimestre],
  COALESCE([Alquiler mensual en dólares corrientes], 0) AS [Alquiler mensual en dólares corrientes],
  COALESCE([Tipo de cambio], 1.0) AS [Tipo de cambio],
  COALESCE([IPC], 100.0) AS [IPC],
  COALESCE([Alquiler mensual en soles corrientes], 0) AS [Alquiler mensual en soles corrientes],
  COALESCE([Alquiler mensual en soles constantes de 2009], 0) AS [Alquiler mensual en soles constantes de 2009],

  -- Limpieza y formato del distrito
  CONCAT(UPPER(LEFT(LTRIM(RTRIM(Distrito)),1)), LOWER(SUBSTRING(LTRIM(RTRIM(Distrito)),2,LEN(Distrito)))) AS Distrito,

  CAST([Superficie] AS INT) AS Superficie,
  CAST([Número de habitaciones] AS INT) AS [Número de habitaciones],
  CAST([Número de baños] AS INT) AS [Número de baños],
  CAST([Número de garages] AS INT) AS [Número de garages],
  CAST([Piso de ubicación] AS INT) AS [Piso de ubicación],
  CASE 
    WHEN CAST([Vista al exterior] AS INT) = 11 THEN 1
    ELSE CAST([Vista al exterior] AS INT)
  END AS [Vista al exterior],
  CAST([Años de antigüedad] AS INT) AS [Años de antigüedad]

INTO alquiler_temp
FROM dbo.alquiler
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
  FROM alquiler_temp
)

-- 3. Crear tabla limpia con imputación y clave
SELECT 
  a.id_tiempo,
  a.Año,
  a.Trimestre,
  a.[Alquiler mensual en dólares corrientes],
  a.[Tipo de cambio],
  a.[IPC],
  a.[Alquiler mensual en soles corrientes],
  a.[Alquiler mensual en soles constantes de 2009],
  a.Distrito,

  COALESCE(a.Superficie, p.Sup) AS Superficie,
  COALESCE(a.[Número de habitaciones], p.Hab) AS [Número de habitaciones],
  COALESCE(a.[Número de baños], p.Ban) AS [Número de baños],
  COALESCE(a.[Número de garages], p.Gar) AS [Número de garages],
  COALESCE(a.[Piso de ubicación], p.Piso) AS [Piso de ubicación],
  COALESCE(a.[Vista al exterior], p.Vista) AS [Vista al exterior],
  COALESCE(a.[Años de antigüedad], p.Ant) AS [Años de antigüedad],

  -- Clave temporal para DimInmueble
  CAST(COALESCE(a.Superficie, p.Sup) AS VARCHAR) + '-' +
  CAST(COALESCE(a.[Número de habitaciones], p.Hab) AS VARCHAR) + '-' +
  CAST(COALESCE(a.[Número de baños], p.Ban) AS VARCHAR) + '-' +
  CAST(COALESCE(a.[Número de garages], p.Gar) AS VARCHAR) + '-' +
  CAST(COALESCE(a.[Piso de ubicación], p.Piso) AS VARCHAR) + '-' +
  CAST(COALESCE(a.[Vista al exterior], p.Vista) AS VARCHAR) + '-' +
  CAST(COALESCE(a.[Años de antigüedad], p.Ant) AS VARCHAR) AS IdInmuebleTemp

INTO alquiler_limpio
FROM alquiler_temp a
CROSS JOIN promedios p;

-- 4. Crear tabla de hechos con id_alquiler
DROP TABLE IF EXISTS hechosalquiler;

SELECT 
  ROW_NUMBER() OVER (ORDER BY Año, Trimestre, id_tiempo) AS id_alquiler,
  *
INTO hechosalquiler
FROM alquiler_limpio;


select*from hechosalquiler
order by id_alquiler