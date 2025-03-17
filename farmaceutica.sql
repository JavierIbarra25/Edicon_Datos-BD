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

-- 2. Modificar el sueldo de los repartidores de Madrid, asignándoles un sueldo de 1200 euros.

select * from repartidores r;

update repartidores r 
set sueldo = 1200
where Provincia like 'Madrid';

select * from repartidores r where r.Provincia like 'Madrid';

-- 3. Eliminar las farmacias a las que no se les ha hecho ningún reparto.

delete from farmacias 
where farmacias.CodFarmacia not in (select r.CodFarmacia from repartos r );

-- Verificar que la Farmacia sin reparto ha sido eliminada
select*from farmacias f ;

-- 4. Reducir en un 10% el sueldo de los repartidores que han hecho menos de 10 repartos en el último mes.

update Repartidores
set Sueldo = Sueldo * 0.9
where NIF in (
    select NIF
    from (
        select r.NIF
        from Repartidores r
        left join  Repartos r2 on r.NIF = r2.NIF_Repartidor
            and r2.Fecha >= DATE_SUB((select MAX(Fecha) from Repartos), interval 1 month)
        group BY r.NIF
        having count(r2.NIF_Repartidor) < 10
    ) as subquery
);

select*from repartidores r ;

-- 5. Aumentar en un 15% el precio del medicamento que más se ha repartido (unidades).

-- Paso 1: Obtener la cantidad máxima repartida y los medicamentos que la tienen

select CodMedicamento, TotalRepartido
from (
    select r2.CodMedicamento, SUM(Cantidad) AS TotalRepartido
		from repartos r2
		group by r2.CodMedicamento
		) as subquery
	where TotalRepartido = (
		select MAX(TotalRepartido)
    	from (
        	select CodMedicamento, SUM(Cantidad) AS TotalRepartido
        	from Repartos
        	group by CodMedicamento	
	) as subquery
);

-- Paso 2: Aumentar en un 15% el precio del medicamento más repartido:

update medicamentos m
set Precio = m.Precio * 1.15
where CodMedicamento in (
	select CodMedicamento 
	from(
		select r2.CodMedicamento, SUM(Cantidad) AS TotalRepartido
		from repartos r2
		group by r2.CodMedicamento
		) as subquery
	where TotalRepartido = (
		select MAX(TotalRepartido)
    	from (
        	select CodMedicamento, SUM(Cantidad) AS TotalRepartido
        	from Repartos
        	group by CodMedicamento	
	) as subquery
);

select*from Medicamentos;

-- Otra manera más limpia y clara es hacerlo con vista
-- 1. Crear una vista para obtener el total de unidades repartidas por medicamento

CREATE VIEW V_MedicamentoMasRepartido AS
SELECT CodMedicamento, SUM(Cantidad) AS TotalRepartido
FROM Repartos
GROUP BY CodMedicamento;

-- 2. Actualizar el precio del medicamento más repartido

UPDATE Medicamentos 
SET Precio = Precio * 1.15
WHERE CodMedicamento IN (
    SELECT CodMedicamento
    FROM V_MedicamentoMasRepartido
    WHERE TotalRepartido = (
        SELECT MAX(TotalRepartido) 
        FROM V_MedicamentoMasRepartido
    )
);

select*from Medicamentos;

-- 6. Registrar el reparto de un pedido realizado por el repartidor con NIF “1A” a la farmacia con código 3 de 20 unidades del medicamento con código 3. 
-- El reparto se hace en la fecha de hoy. Se debe registrar de forma que la base de datos quede coherente

-- 1.Insertar el nuevo reparto
-- Como antes hemos eliminado las farmacias que no hacían reparto tenemos que volver a meterla
SELECT * FROM Farmacias WHERE CodFarmacia = 3;

INSERT INTO Farmacias (CodFarmacia, Nombre, Direccion, Provincia, AnioApertura) values
(3, 'LDO. VARGAS', 'Calle Falsa 123', 'Almeria', 1986);

INSERT INTO repartos (NIF_Repartidor, CodFarmacia, CodMedicamento, Fecha, Cantidad) values
('1A', 3, 3, CURDATE(), 20);

-- 2.  Actualizar el stock del medicamento

UPDATE Medicamentos  
SET Stock = Stock - 20  
WHERE CodMedicamento = 3;

select*from Medicamentos;


