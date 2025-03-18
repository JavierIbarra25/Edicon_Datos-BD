-- Creación de la base de datos
DROP DATABASE IF EXISTS Agencia_Modelos;
CREATE DATABASE Agencia_Modelos CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;

USE Agencia_Modelos;

-- Creación de las tablas

-- Creación de la tabla Modelos

CREATE TABLE Modelos (
	Cod_Modelo 		Numeric(6),
	Nombre			Varchar(25) NOT NULL,
	Apellido1		Varchar(25) NOT NULL,
	Apellido2		Varchar(25),
	Fec_Nacimiento	Date,
	Sexo			Varchar(6) NOT NULL,
	Pais			Varchar(20) NOT NULL,
	Altura			Numeric(3,2) NOT NULL,
	Color_Ojos		Varchar(25),
	CONSTRAINT PK_Modelos PRIMARY KEY (Cod_Modelo),
	CONSTRAINT CH_Mod_Cod CHECK (Cod_Modelo >= 0), 
	CONSTRAINT CH_Mod_Sexo CHECK (Sexo IN ('HOMBRE','MUJER')), 
	CONSTRAINT CH_Mod_Altura CHECK (Altura BETWEEN 1 AND 2.30)
);

-- Creación de la tabla Certamenes

CREATE TABLE Certamenes (
	Cod_Certamen 	Numeric(6),
	Nombre			Varchar(25) NOT NULL,
	Temporada		Varchar(25) NOT NULL,
	Ciudad			Varchar(50) NOT NULL,
	Fec_Inicio		Date,
	Fec_Fin			Date,
	CONSTRAINT PK_Certamenes PRIMARY KEY (Cod_Certamen),
	CONSTRAINT CH_Cert_Cod CHECK (Cod_Certamen >= 0)	
);

-- Creación de la tabla Diseniadores

CREATE TABLE Diseniadores (
	Cod_Diseniador 	Numeric(6),
	Nombre			Varchar(25) NOT NULL,
	Pais			Varchar (20) NOT NULL,
	Anio_Inicio		Numeric(4),
	CONSTRAINT PK_Diseniadores PRIMARY KEY (Cod_Diseniador),
	CONSTRAINT CH_Disen_Cod CHECK(Cod_Diseniador >= 0),
	CONSTRAINT CH_Disen_Anio CHECK(Anio_Inicio BETWEEN 1900 AND 2030)	
);

-- Creación de la tabla Desfiles

CREATE TABLE Desfiles (
	Cod_Certamen 	Numeric (6),
	Cod_Modelo 		Numeric (6),
	Cod_Diseniador 	Numeric (6),
	Fecha			Date,
	CONSTRAINT PK_Desfiles PRIMARY KEY (Cod_Certamen,Cod_Diseniador,Cod_Modelo,Fecha),
	CONSTRAINT FK_Desf_Cert FOREIGN KEY (Cod_Certamen) REFERENCES Certamenes (Cod_Certamen) ON DELETE CASCADE,	
	CONSTRAINT FK_Desf_Mod FOREIGN KEY (Cod_Modelo) REFERENCES Modelos (Cod_Modelo) ON DELETE CASCADE,
	CONSTRAINT FK_Desf_Disen FOREIGN KEY (Cod_Diseniador) REFERENCES Diseniadores (Cod_Diseniador) ON DELETE CASCADE
);

-- 1. Introducir dos tuplas en cada relación. 

INSERT INTO Modelos (Cod_Modelo, Nombre, Apellido1, Apellido2, Fec_Nacimiento, Sexo, Pais, Altura, Color_Ojos) VALUES
(1, 'Ana', 'García', 'López', '1995-05-15', 'MUJER', 'España', 1.75, 'Marrones'),
(2, 'Carlos', 'Martínez', 'Sánchez', '1990-08-22', 'HOMBRE', 'Mexico', 1.85, 'Azules');

INSERT INTO Certamenes (Cod_Certamen, Nombre, Temporada, Ciudad, Fec_Inicio, Fec_Fin) VALUES
(101, 'Cibeles', 'Otoño/Invierno', 'Madrid', '2023-09-01', '2023-09-10'),
(102, 'Milán Fashion Week', 'Primavera/Verano', 'Milán', '2023-02-20', '2023-02-28');

INSERT INTO Diseniadores (Cod_Diseniador, Nombre, Pais, Anio_Inicio) VALUES
(201, 'Manuel', 'España', 2005),
(202, 'Giorgio', 'Italia', 1990);

INSERT INTO Desfiles (Cod_Certamen, Cod_Modelo, Cod_Diseniador, Fecha) VALUES
(101, 1, 201, '2023-09-05'),  -- Ana García en Cibeles, diseñado por Manuel
(102, 2, 202, '2023-02-25');  -- Carlos Martínez en Milán Fashion Week, diseñado por Giorgio

-- 2.  Añadir 1 cm a la altura de las modelos de ojos azules.

update modelos m 
set Altura = Altura + 0.1
where Color_Ojos like 'Azules';

select Altura, m.Color_Ojos  from modelos m;

-- 3. Cambiar la temporada de los certámenes que tienen temporada “Otoño – Invierno 2016” por “OTOÑO – INVIERNO 2016”.

update certamenes c 
set Temporada = 'OTOÑO/INVIERNO'
where Temporada = 'Otoño/Invierno';

select Temporada from certamenes c ;

-- 4. Eliminar las modelos femeninas que desfilaron en el año 2023.

delete m
from Modelos m, Desfiles d
where m.Cod_Modelo = d.Cod_Modelo
  and YEAR(d.Fecha) = 2023
  and m.Sexo = 'MUJER';


select*from modelos m; 
-- 5. Eliminar los modelos masculinos que sólo han hecho desfiles para diseñadores de su país.

-- Paso 1: creamos una vista que nos ayude a identificar los modelos masculinos que solo han trabajado con diseñadores de su mismo país.

CREATE VIEW Modelos_Solo_Diseniadores_Mismo_Pais AS
select m.Cod_Modelo
from Modelos m
inner join Desfiles d on m.Cod_Modelo = d.Cod_Modelo
inner join Diseniadores di on d.Cod_Diseniador = di.Cod_Diseniador
where m.Sexo = 'HOMBRE'
and m.Pais = di.Pais
group by m.Cod_Modelo
having COUNT(di.Pais) = 1;


-- Paso 2: Eliminar estos modelos de la base de datos

delete from Modelos
where Cod_Modelo in (select Cod_Modelo from Modelos_Solo_Diseniadores_Mismo_Pais);

select*from modelos m;

-- 6. Eliminar los modelos (masculinos y femeninas) que han desfilado en certámenes de Barcelona o en certámenes de Madrid.

delete m
from modelos m
inner join Desfiles d on m.Cod_Modelo = d.Cod_Modelo
inner join Certamenes c on d.Cod_Certamen = c.Cod_Certamen
where c.Ciudad in ('Barcelona', 'Madrid');

-- 7. Eliminar los modelos (masculinos y femeninas) que han desfilado en todos los certámenes de Madrid.

delete m
from modelos m
inner join Desfiles d on m.Cod_Modelo = d.Cod_Modelo
inner join Certamenes c on d.Cod_Certamen = c.Cod_Certamen
where c.Ciudad in ('Madrid');
