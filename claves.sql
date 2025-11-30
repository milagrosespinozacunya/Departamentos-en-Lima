---claves primarias de las dimensiones
ALTER TABLE dimtiempo
ALTER COLUMN id_tiempo NVARCHAR(10) NOT NULL;

ALTER TABLE dimtiempo
ADD CONSTRAINT PK_dimtiempo PRIMARY KEY (id_tiempo);

ALTER TABLE dimdistrito
ADD CONSTRAINT PK_dimdistrito PRIMARY KEY (Distrito);

ALTER TABLE diminmueble
ALTER COLUMN IdInmuebleTemp NVARCHAR(216) NOT NULL;

ALTER TABLE diminmueble
ADD CONSTRAINT PK_diminmueble PRIMARY KEY (IdInmuebleTemp);

----claves foraneas en tablas de hechos

---venta
ALTER TABLE hechosventa
ALTER COLUMN id_tiempo NVARCHAR(10) NOT NULL;

ALTER TABLE hechosventa
ALTER COLUMN IdInmuebleTemp VARCHAR(216) NOT NULL;

ALTER TABLE hechosventa
ADD CONSTRAINT FK_hechosventa_dimtiempo
FOREIGN KEY (id_tiempo) REFERENCES dimtiempo(id_tiempo);


ALTER TABLE hechosventa
ALTER COLUMN IdInmuebleTemp NVARCHAR(216) NOT NULL;

ALTER TABLE hechosventa
ADD CONSTRAINT FK_hechosventa_diminmueble
FOREIGN KEY (IdInmuebleTemp) REFERENCES diminmueble(IdInmuebleTemp);

ALTER TABLE hechosventa
ADD CONSTRAINT FK_hechosventa_dimdistrito
FOREIGN KEY (Distrito) REFERENCES dimdistrito(Distrito);

---alquilr

-- Asegurar tipos correctos
ALTER TABLE hechosalquiler
ALTER COLUMN id_tiempo NVARCHAR(10) NOT NULL;

ALTER TABLE hechosalquiler
ALTER COLUMN IdInmuebleTemp NVARCHAR(216) NOT NULL;

-- Clave foránea con dimtiempo
ALTER TABLE hechosalquiler
ADD CONSTRAINT FK_hechosalquiler_dimtiempo
FOREIGN KEY (id_tiempo) REFERENCES dimtiempo(id_tiempo);

-- Clave foránea con diminmueble
ALTER TABLE hechosalquiler
ADD CONSTRAINT FK_hechosalquiler_diminmueble
FOREIGN KEY (IdInmuebleTemp) REFERENCES diminmueble(IdInmuebleTemp);

-- Clave foránea con dimdistrito
ALTER TABLE hechosalquiler
ADD CONSTRAINT FK_hechosalquiler_dimdistrito
FOREIGN KEY (Distrito) REFERENCES dimdistrito(Distrito);
