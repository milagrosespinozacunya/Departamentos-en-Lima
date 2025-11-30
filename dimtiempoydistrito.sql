---distrito
DROP TABLE IF EXISTS dimdistrito;

SELECT DISTINCT
  Distrito
INTO dimdistrito
FROM (
  SELECT Distrito FROM hechosventa
  UNION
  SELECT Distrito FROM hechosalquiler
) AS Distrito;

select*from dimdistrito
----tiempo
DROP TABLE IF EXISTS dimtiempo;

SELECT DISTINCT
  id_tiempo,
  Año,
  Trimestre
INTO dimtiempo
FROM (
  SELECT id_tiempo, Año, Trimestre FROM venta_limpio
  UNION
  SELECT id_tiempo, Año, Trimestre FROM alquiler_limpio
) AS tiempos;
select*from dimtiempo
order by id_tiempo


--------- inmueble
DROP TABLE IF EXISTS diminmueble;

SELECT DISTINCT
  IdInmuebleTemp,
  Superficie,
  [Número de habitaciones],
  [Número de baños],
  [Número de garages],
  [Piso de ubicación],
  [Vista al exterior],
  [Años de antigüedad]
INTO diminmueble
FROM (
  SELECT 
    IdInmuebleTemp,
    Superficie,
    [Número de habitaciones],
    [Número de baños],
    [Número de garages],
    [Piso de ubicación],
    [Vista al exterior],
    [Años de antigüedad]
  FROM venta_limpio

  UNION

  SELECT 
    IdInmuebleTemp,
    Superficie,
    [Número de habitaciones],
    [Número de baños],
    [Número de garages],
    [Piso de ubicación],
    [Vista al exterior],
    [Años de antigüedad]
  FROM alquiler_limpio
) AS inmuebles;

select*from diminmueble