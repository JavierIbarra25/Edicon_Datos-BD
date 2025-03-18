-- Creación de la base de datos
DROP DATABASE IF EXISTS Control_Infracciones;
CREATE DATABASE Control_Infracciones CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;

USE Control_Infracciones;

-- Creación de las tablas

-- Creación de la tabla VEHICULOS

CREATE TABLE VEHICULOS (
    Matricula VARCHAR(7),
    Marca VARCHAR(25) NOT NULL,
    Modelo VARCHAR(25) NOT NULL,
    Tipo VARCHAR(25),
    FechMatricula DATE NOT NULL,
    Color VARCHAR(15) NOT null,
    
    CONSTRAINT PK_Vehiculos PRIMARY KEY (Matricula)
);

-- Creación de la tabla AGENTES

CREATE TABLE AGENTES (
    NIF VARCHAR(12),
    Nombre VARCHAR(25) NOT NULL,
    Apellido1 VARCHAR(25) NOT NULL,
    Apellido2 VARCHAR(25),
    Categoria VARCHAR(15),
    FechaIngreso DATE,
    
    CONSTRAINT PK_Agentes PRIMARY KEY (NIF)
);

-- Creación de la tabla INFRACCIONES

CREATE TABLE INFRACCIONES (
    Cod_I INT,
    Nombre VARCHAR(25),
    Descripcion VARCHAR(200),
    Cuantia DECIMAL(6,2) NOT NULL DEFAULT 100,
    
    CONSTRAINT PK_Infracciones PRIMARY KEY (Cod_I),
    CONSTRAINT CH_CodI CHECK (Cod_I > 0 AND Cod_I < 1000),
    CONSTRAINT CH_CodCuant CHECK (Cuantia BETWEEN 10 AND 999.99)
);

-- Creación de la tabla MULTAS

CREATE TABLE MULTAS (
    Matricula VARCHAR(7),
    NIF_Agente VARCHAR(12),
    Cod_I INT,
    Fecha DATE,
    Lugar VARCHAR(200),
    
    CONSTRAINT PK_Multas PRIMARY KEY (Matricula, NIF_Agente, Cod_I, Fecha),
    CONSTRAINT PK_Mult_Matr FOREIGN KEY (Matricula) REFERENCES VEHICULOS(Matricula) ON DELETE CASCADE,
    CONSTRAINT PK_Mult_NIF FOREIGN KEY (NIF_Agente) REFERENCES AGENTES(NIF) ON DELETE CASCADE,
    CONSTRAINT PK_Mult_Cod FOREIGN KEY (Cod_I) REFERENCES INFRACCIONES(Cod_I) ON DELETE CASCADE
);

-- 3. Añadir a la tabla MULTAS el atributo pagada. Sólo admite el valor 1 o 0 (1 pagada 0 pendiente de pago). Por defecto tomará el valor 0. No admite valores nulos

ALTER TABLE MULTAS 
ADD COLUMN Pagada INT NOT NULL DEFAULT 0 CHECK (Pagada IN (0, 1)) AFTER Lugar;

-- 4. Introducir dos tuplas en cada relación. 

INSERT INTO VEHICULOS (Matricula, Marca, Modelo, Tipo, FechMatricula, Color) VALUES 
('1111AAR', 'SEAT', 'LEÓN', 'UTILITARIO', '2015-02-27', 'ROJO'),
('2222BBR', 'FORD', 'FIESTA', 'UTILITARIO', '2010-10-27', 'ROJO'),
('3333CCA', 'PEUGEOT', '307', 'UTILITARIO', '2002-07-20', 'AZUL'),
('4444DDA', 'CITRÖEN', 'C4', 'UTILITARIO', '2012-05-21', 'AZUL'),
('5555EEB', 'PEUGEOT', '807', 'UTILITARIO', '2015-07-20', 'BLANCO'),
('6666FFR', 'PEUGEOT', '207', 'UTILITARIO', '2010-07-20', 'ROJO');

INSERT INTO AGENTES (NIF, Nombre, Apellido1, Apellido2, Categoria, FechaIngreso) VALUES 
('1111A', 'LUIS', 'GARCÍA', 'LÓPEZ', 'SARGENTO', NULL),
('2222A', 'MARÍA', 'LÓPEZ', 'LÓPEZ', 'SARGENTO', NULL),
('3333A', 'JUAN', 'PÉREZ', 'LÓPEZ', 'SARGENTO', NULL),
('4444A', 'PEDRO', 'GARCÍA', 'DOMÍNGUEZ', 'CABO', NULL),
('5555A', 'MANUEL', 'LIMA', 'SÁNCHEZ', 'CABO', NULL),
('6666A', 'DOLORES', 'FUNDI', 'PINEL', 'CAPITÁN', NULL);

INSERT INTO INFRACCIONES (Cod_I, Nombre, Descripcion, Cuantia) VALUES 
(1, 'APARCAMIENTO', NULL, 100),
(2, 'CONDUCCIÓN TEMERARIA', NULL, 500),
(3, 'ADELANTAMIENTO PROHIBIDO', NULL, 300),
(4, 'UTILIZACIÓN MÓVIL', NULL, 200);

INSERT INTO MULTAS (Matricula, NIF_Agente, Cod_I, fecha, Lugar, Pagada) VALUES 
('1111AAR', '1111A', 1, '2017-02-01', 'EN LA CALLE', 0),
('3333CCA', '1111A', 1, '2017-02-01', 'EN LA CALLE', 0),
('5555EEB', '1111A', 1, '2016-02-01', 'EN LA CALLE', 0),
('5555EEB', '1111A', 1, '2016-07-01', 'EN LA CALLE', 0),
('1111AAR', '2222A', 3, '2016-02-04', 'EN LA CALLE', 0),
('2222BBR', '2222A', 1, '2016-06-04', 'EN LA CALLE', 0),
('6666FFR', '2222A', 1, '2017-05-04', 'EN LA CALLE', 0),
('3333CCA', '2222A', 1, '2016-05-04', 'EN LA CALLE', 0),
('2222BBR', '3333A', 1, '2016-06-04', 'EN LA CALLE', 0),
('6666FFR', '3333A', 1, '2017-05-04', 'EN LA CALLE', 0),
('1111AAR', '3333A', 1, '2016-09-04', 'EN LA CALLE', 0),
('5555EEB', '4444A', 1, '2016-11-04', 'EN LA CALLE', 0),
('3333CCA', '4444A', 1, '2016-02-04', 'EN LA CALLE', 0),
('2222BBR', '5555A', 1, '2016-12-04', 'EN LA CALLE', 0),
('6666FFR', '5555A', 1, '2017-05-04', 'EN LA CALLE', 0);

-- 5. Hallar la marca y modelo de todos los vehículos.

select Marca, Modelo from vehiculos v ;

-- 6. Hallar el nombre y apellidos de todos los sargentos.

select Nombre, Apellido1, Apellido2 from agentes a;

-- 7. Aumentar un 10% la cuantía de las infracciones que superan los 300 euros

update infracciones i 
set Cuantia = i.Cuantia * 1.10
where i.Cuantia > 300;

-- 8. Hallar el nombre y apellidos de los agentes que han multado a vehículos rojos.

select a.Nombre, a.Apellido1, a.Apellido2 
from agentes a
inner join multas m on a.NIF = m.NIF_Agente 
inner join vehiculos v on m.Matricula = v.Matricula 
where v.Color = 'Rojo';

-- 9. Hallar el nombre y apellidos de los agentes que únicamente han multado a vehículos rojos.

select distinct a.NIF ,a.Nombre, a.Apellido1, a.Apellido2 
from agentes a
inner join multas m on a.NIF = m.NIF_Agente 
inner join vehiculos v on m.Matricula = v.Matricula 
where v.Color = 'Rojo'
and a.NIF not in (
	select m2.NIF_Agente 
	from multas m2 
	inner join vehiculos v2 on m2.Matricula = v2.Matricula 
	where v2.Color <> 'Rojo'
);

-- 10. Hallar el nombre y apellidos de los agentes que nunca han multado a vehículos rojos.

select a.Nombre, a.Apellido1, a.Apellido2 
from agentes a
where a.NIF not in (
	select m.NIF_Agente 
	from multas m
	inner join vehiculos v on m.Matricula = v.Matricula 
	where v.Color = 'Rojo'
);

-- 11. Hallar el nombre y apellidos de los agentes que han multado a vehículos rojos o a vehículos azules.

select distinct a.Nombre, a.Apellido1, a.Apellido2 
from agentes a
inner join multas m on a.NIF = m.NIF_Agente 
inner join vehiculos v on m.Matricula = v.Matricula 
where v.Color in ('Rojo', 'AZUL');

-- 12. Hallar el nombre y apellidos de los agentes que han multado a vehículos rojos y a vehículos azules.

select distinct a.Nombre, a.Apellido1, a.Apellido2 
from agentes a
inner join multas m on a.NIF = m.NIF_Agente 
inner join vehiculos v on m.Matricula = v.Matricula 
where v.Color in ('Rojo', 'AZUL')
group by a.NIF 
having SUM(v.Color = 'Rojo') > 0 AND SUM(v.Color = 'Azul') > 0;

-- 13. Hallar el nombre y apellidos de los agentes que han multado a todos los vehículos rojos

select distinct a.Nombre, a.Apellido1, a.Apellido2 
from agentes a
inner join multas m on a.NIF = m.NIF_Agente 
inner join vehiculos v on m.Matricula = v.Matricula 
where v.Color in ('Rojo', 'AZUL')
group by a.NIF 
having count(v.matricula) = (
	select COUNT(*)
	from vehiculos v2 
	where v2.Color = 'Rojo'
);

-- 14. Hallar el nombre y apellidos del agente que más multas ha puesto en el pasado año.

select a.Nombre, a.Apellido1, a.Apellido2 
from agentes a
inner join multas m on a.NIF = m.NIF_Agente
where YEAR(m.Fecha) in (2016,2017)
group by a.NIF 
order by COUNT(m.Matricula) desc
limit 1;

-- 15. Hallar el nombre y apellidos del agente que ha puesto la última multa.

select a.Nombre, a.Apellido1, a.Apellido2 
from agentes a
inner join multas m on a.NIF = m.NIF_Agente
order by m.Fecha  desc
limit 1;

-- 16. Eliminar todas las tablas.

drop table agentes;
drop table infracciones;
drop table multas;
drop table vehiculos;
