-- Creación de la base de datos
DROP DATABASE IF EXISTS farmaceutica;
CREATE DATABASE farmaceutica CHARSET utf8mb4 COLLATE utf8mb4_spanish_ci;

-- Elección de la base de datos
USE farmaceutica;

-- Creación de la relación MEDICAMENTOS

CREATE TABLE Medicamentos(
	CodMedicamento	Numeric(8),
	Nombre			Varchar(25) NOT NULL,
	Descripcion		Varchar(200) NOT NULL,
	Precio			Numeric(6,2) NOT NULL,
	Stock			Numeric(4) DEFAULT 0 NOT NULL,
	CONSTRAINT PK_Medicamentos PRIMARY KEY(CodMedicamento),
	CONSTRAINT CH_Cod CHECK(CodMedicamento>=0),
	CONSTRAINT CH_Precio CHECK(Precio>0),
	CONSTRAINT CH_Stock CHECK(Stock>=0)
);

-- Creación de la relación FARMACIAS

CREATE TABLE Farmacias(
	CodFarmacia 	Numeric(8),
	Nombre			Varchar(25) NOT NULL,
	Direccion		Varchar(100) NOT NULL,
	Provincia		Varchar(20) NOT NULL,
	AnioApertura	Numeric(4),
	CONSTRAINT PK_Farmacias PRIMARY KEY(CodFarmacia),
	CONSTRAINT CH_Apertura CHECK(AnioApertura>=1800 AND AnioApertura<=2200)
);

-- Creación de la relación REPARTIDORES

CREATE TABLE Repartidores(
	NIF 			Varchar(12),
	Nombre			Varchar(25) NOT NULL,
	Apellido1		Varchar(25) NOT NULL,
	Apellido2		Varchar(25),
	FechaNacimiento	Date,
	Direccion		Varchar(100) NOT NULL,
	Provincia		Varchar(20) NOT NULL,
	Sueldo			Numeric(6,2) NOT NULL,
	CONSTRAINT PK_Repartidores PRIMARY KEY(NIF),
	CONSTRAINT CH_Sueldo CHECK(Sueldo>=100)
);

-- Creación de la relación REPARTOS

CREATE TABLE Repartos(
	NIF_Repartidor	Varchar(12),
	CodFarmacia 	Numeric(8),
	CodMedicamento	Numeric(8),
	Fecha			Date,
	Cantidad		Numeric(4) DEFAULT 1 NOT NULL,
	CONSTRAINT PK_Repartos PRIMARY KEY(NIF_Repartidor,CodFarmacia,CodMedicamento,Fecha),
	CONSTRAINT FK_RepRepartidores FOREIGN KEY (NIF_Repartidor)
			REFERENCES Repartidores (NIF) 
			ON DELETE CASCADE,
	CONSTRAINT FK_RepFarmacias FOREIGN KEY(CodFarmacia)
			REFERENCES Farmacias (CodFarmacia)
			ON DELETE CASCADE,
	CONSTRAINT FK_RepMedicamentos FOREIGN KEY (CodMedicamento)
			REFERENCES Medicamentos (CodMedicamento)
			ON DELETE CASCADE,
	CONSTRAINT CH_Cantidad CHECK(Cantidad>0)
);


-- 1. Introducir en las diferentes tablas las siguientes tuplas iniciales:

INSERT INTO Medicamentos (CodMedicamento, Nombre, Descripcion, Precio, Stock) values
(1, 'ASPIRINA', '' , 3.00, 30),
(2, 'GELOCATIL', '' , 5.00, 30),
(3, 'IBUPROFENO', '' , 2.00, 60),
(4, 'CARIBAN', '' , 2.50, 20);

INSERT INTO farmacias (CodFarmacia, Nombre, Direccion, Provincia, AnioApertura) values
(1, 'GAMO', '' , 'Madrid', 2000),
(2, 'LDO. GARCÍA PÉREZ', '' , 'Barcelona', 1880),
(3, 'LDO. VARGAS', '' , 'Almeria', 1986),
(4, 'PÉREZ E HIJOS', '' , 'Málaga', 1930),
(5, 'VDA. DE LORENZO E HIJOS', '' , 'Madrid', 1896);

INSERT INTO repartidores (NIF, Nombre, Apellido1, Apellido2, FechaNacimiento, Direccion, Provincia, Sueldo) values
('1A', 'LUIS', 'GARCÍA' , 'LÓPEZ', '1979-02-16', '', 'MADRID', 2000.00),
('2B', 'JUAN', 'GARCÍA' , 'LÓPEZ', '1985-02-04', '', 'BARCELONA', 1580.00),
('3C', 'PEDRO', 'ROMANCO' , 'PETRI', NULL, '', 'MADRID', 1000.00),
('4D', 'MARÍA', 'VÁZQUEZ' , 'LÓPEZ', '1990-02-24', '', 'ALMERIA', 2500.00);


INSERT INTO repartos (NIF_Repartidor, CodFarmacia, CodMedicamento, Fecha, Cantidad) values
('2B', 2, 1, '2016-02-08', 6),
('2B', 5, 3, '2016-02-03', 10),
('3C', 4, 2, '2016-02-08', 10);

-- 1. Hallar el nombre de los medicamentos cuyo precio es inferior a 3 euros

select Nombre from medicamentos m 
where Precio < 3;

-- 2. Hallar el nombre de las farmacias que hay en la provincia de Madrid (Usa LIKE)

select Nombre from farmacias f 
where Provincia like 'Madrid';

-- 3. Hallar el nombre de los repartidores que su sueldo es 1500 euros o superior.

select nombre from repartidores r 
where Sueldo >= 1500;

-- 4. Hallar las fechas en las que ha repartido “Juan García López”. 

select Fecha, NIF_Repartidor 
from repartos r 
inner join repartidores r2 on NIF = NIF_Repartidor
where Nombre = 'Juan'
and Apellido1 = 'García'
and Apellido2 = 'López';

-- 5. Hallar el nombre de las farmacias a las que ha repartido “Juan García López”. 

select f.Nombre
from farmacias f 
inner join repartos r on r.CodFarmacia = f.CodFarmacia
inner join repartidores r2 on NIF = NIF_Repartidor
where r2.Nombre = 'Juan'
and r2.Apellido1 = 'García'
and r2.Apellido2 = 'López';

-- 6. Hallar el nombre de los medicamentos que nunca se han repartido en Málaga Pista: Usa NOT IN

select Nombre from medicamentos m
where CodMedicamento not in (
	select CodMedicamento from repartos r 
	inner join farmacias f on f.CodFarmacia = r.CodFarmacia
	where Provincia = 'Málaga'
);

-- 7. Hallar el nombre de los medicamentos que sólo se han repartido en Málaga Pista: Usa NOT IN(… AND Provincia<>'MALAGA') )

select Nombre from medicamentos m
where CodMedicamento in (
	select CodMedicamento from repartos r 
	inner join farmacias f on f.CodFarmacia = r.CodFarmacia
	where Provincia = 'Málaga'
)
and CodMedicamento not in (
	select CodMedicamento from repartos r 
	inner join farmacias f on f.CodFarmacia = r.CodFarmacia
	where Provincia <> 'Málaga'
);

-- 8. Hallar el número de repartos que ha realizado “Juan García López”.

select COUNT(*) as Número_Pedidos
from repartos r 
inner join repartidores r2 on NIF = NIF_Repartidor
where r2.Nombre = 'Juan'
and r2.Apellido1 = 'García'
and r2.Apellido2 = 'López';

-- 9. Hallar el nombre de los medicamentos que se han repartido en Madrid y Barcelona (Pista: puede que no haya ninguno) 

select Nombre from medicamentos m
where CodMedicamento in (
	select CodMedicamento from repartos r 
	inner join farmacias f on f.CodFarmacia = r.CodFarmacia
	where Provincia = 'Málaga'
	
intersect

    select CodMedicamento from repartos r 
	inner join farmacias f on f.CodFarmacia = r.CodFarmacia
	where Provincia = 'Madrid'
);

-- 10. Hallar el nombre de los medicamentos que se han repartido en Madrid o Barcelona(Pista: el resultado no está vacío, y una opción es utilizar UNION)

select Nombre from medicamentos m
where CodMedicamento in (
	select CodMedicamento from repartos r 
	inner join farmacias f on f.CodFarmacia = r.CodFarmacia
	where Provincia = 'Barcelona'
	
union

    select CodMedicamento from repartos r 
	inner join farmacias f on f.CodFarmacia = r.CodFarmacia
	where Provincia = 'Madrid'
);

-- usando IN

select distinct  m.Nombre
from medicamentos m
inner join repartos r on m.CodMedicamento = r.CodMedicamento
inner join farmacias f on r.CodFarmacia = f.CodFarmacia
where f.Provincia in ('Madrid', 'Barcelona');

-- 11. Hallar el nombre del repartidor o repartidores que tienen el mayor sueldo. Pista: Usa MAX(Sueldo)

select r.Nombre, r.Apellido1, r.Apellido2, Sueldo
from repartidores r  
where Sueldo = (select MAX(Sueldo) from repartidores r2 );


-- 12. Hallar el nombre de los medicamentos que se han repartido en más de dos farmacias de Almería. Pista: Usa HAVING Count(Distinct F.CodFarmacia) > 2)

select m.Nombre
from medicamentos m
inner join repartos r on m.CodMedicamento = r.CodMedicamento
inner join farmacias f on r.CodFarmacia = f.CodFarmacia
where Provincia = 'Almería'
group by m.Nombre
having COUNT(Distinct F.CodFarmacia) > 2;

-- 13. Hallar el nombre del repartidor que más repartos ha realizado. Pista:
-- CREATE VIEW V_Rep_NumRepart (NIF_Repartidor, Num_Repartos) AS
-- SELECT NIF_Repartidor,Count(*)
-- FROM Repartos
-- GROUP BY NIF_Repartidor;

CREATE VIEW V_Rep_NumRepart (NIF_Repartidor, Num_Repartos) AS
SELECT NIF_Repartidor,Count(*)
FROM Repartos
GROUP BY NIF_Repartidor;

select r.Nombre, r.Apellido1, r.Apellido2, v.Num_Repartos
from repartidores r
inner join V_Rep_NumRepart v on r.NIF = v.NIF_Repartidor
where v.Num_Repartos = (select MAX(Num_Repartos) from V_Rep_NumRepart);

-- 14. Hallar el sueldo medio de los repartidores de Madrid.

select AVG(Sueldo) as Sueldo_medio
from repartidores r 
where Provincia = 'Madrid';

-- 15. Hallar el nombre de los medicamentos que se han distribuido a todas las farmacias de Santander. Pista: Usa lo siguiente
-- HAVING Count(DISTINCT F.CodFarmacia)=(SELECT Count(*)FROM Farmacias WHERE Provincia='SANTANDER')

select m.Nombre
from medicamentos m
inner join repartos r on m.CodMedicamento = r.CodMedicamento
inner join farmacias f on r.CodFarmacia = f.CodFarmacia
where Provincia = 'Santander'
group by m.Nombre
HAVING Count(DISTINCT F.CodFarmacia)=(SELECT Count(*)FROM Farmacias WHERE Provincia='SANTANDER');

-- 16. Hallar el valor de la mercancía repartida por “Luis García López”



















