-- 1. Creación de la base de datos
CREATE DATABASE Gabinete_Psicologia CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;

USE Gabinete_Psicologia;

-- 2. Creación de las tablas

-- Creación de la tabla PSICOLOGOS

CREATE TABLE PSICOLOGOS (
    NIF VARCHAR(13),
    Nombre VARCHAR(25) NOT NULL,
    Apellido1 VARCHAR(25) NOT NULL,
    Apellido2 VARCHAR(25),
    Especialidad VARCHAR(20) NOT NULL,
    Direccion VARCHAR(100),
    
    CONSTRAINT PK_PSICOLOGOS PRIMARY KEY (NIF)
);

-- Creación de la tabla PACIENTES

CREATE TABLE PACIENTES (
    NIF VARCHAR(13) ,
    Nombre VARCHAR(25) NOT NULL,
    Apellido1 VARCHAR(25) NOT NULL,
    Apellido2 VARCHAR(25),
    Fec_Nacimiento DATE NOT NULL,
    Telefono VARCHAR(11) NOT null,
    
    CONSTRAINT PK_PACIENTES PRIMARY KEY (NIF)
);

-- Creación de la tabla TRASTORNOS

CREATE TABLE TRASTORNOS (
    Cod_Trastorno INT,
    Nombre VARCHAR(25) NOT NULL,
    Sintomas VARCHAR(200),
    
    CONSTRAINT PK_TRASTORNOS PRIMARY KEY (Cod_Trastorno),
    CONSTRAINT CH_Cod_Tras  CHECK (Cod_Trastorno > 0)
);

-- Creación de la tabla TERAPIAS

CREATE TABLE TERAPIAS (
    Cod_Terapia INT,
    Nombre VARCHAR(25) NOT NULL,
    Observaciones VARCHAR(200),
    
    CONSTRAINT PK_Cod_Ter PRIMARY KEY (Cod_Terapia)
);

-- Creación de la tabla SESIONES

CREATE TABLE SESIONES (
    NIF_PS VARCHAR(13),
    NIF_PA VARCHAR(13),
    Cod_Trastorno INT,
    Cod_Terapia INT,
    Fecha DATETIME,
    Precio INT DEFAULT 60,
    
    CONSTRAINT PK_SESIONES PRIMARY KEY (NIF_PS, NIF_PA, Cod_Trastorno, Cod_Terapia, Fecha),
    CONSTRAINT FK_SESIONES_NIF_PS FOREIGN KEY (NIF_PS) REFERENCES PSICOLOGOS(NIF) ON DELETE CASCADE,
    CONSTRAINT FK_SESIONES_NIF_PA FOREIGN KEY (NIF_PA) REFERENCES PACIENTES(NIF) ON DELETE CASCADE,
    CONSTRAINT FK_SESIONES_Cod_Tras FOREIGN KEY (Cod_Trastorno) REFERENCES TRASTORNOS(Cod_Trastorno) ON DELETE CASCADE,
    CONSTRAINT FK_SESIONES_Cod_Ter FOREIGN KEY (Cod_Terapia) REFERENCES TERAPIAS(Cod_Terapia) ON DELETE CASCADE,
    CONSTRAINT CH_SESIONES_Precio CHECK (Precio BETWEEN 30 AND 200) 
);


-- 3. Añadir a la tabla sesiones el atributo pagada, que admita valores numéricos (0 pendiente de pago, distinto de 0 pagada), por defecto tome el valor 0 y no admita 
-- valores nulos.

ALTER TABLE SESIONES
ADD COLUMN Pagada INT NOT NULL DEFAULT 0 AFTER Precio;

-- 4. Insertar las tuplas necesarias para comprobar los apartados siguientes.

INSERT INTO PSICOLOGOS (NIF, Nombre, Apellido1, Apellido2, Especialidad, Direccion) VALUES 
('777777777P', 'MANUEL', 'RODRÍGUEZ', 'LÓPEZ', 'CLÍNICA', 'MI CALLE, 5'),
('666666666C', 'VICTORIA', 'LÓPEZ', 'MARTÍNEZ', 'CLÍNICA', 'DIRECCION 1'),
('555555555R', 'LUISA', 'GONZÁLEZ', 'RUIZ', 'INDUSTRIAL', 'DIRECCIÓN 2'),
('444444444X', 'DOLORES', 'PÉREZ', 'GONZÁLEZ', 'EDUCACIÓN', 'DIRECCIÓN 3'),
('333333333C', 'SERGIO', 'ALONSO', 'ALONSO', 'CLÍNICA', 'DIRECCIÓN 4');

INSERT INTO PACIENTES (NIF, Nombre, Apellido1, Apellido2, Fec_Nacimiento, Telefono) VALUES 
('1A', 'LUIS', 'GONZÁLEZ', 'LÓPEZ', '2001-02-02', '11111111'),
('2B', 'MARÍA', 'LÓPEZ', 'CARREÑO', '2002-02-10', '22222222'),
('3C', 'JUAN', 'RUIZ', 'DORREGO', '1975-03-12', '33333333'),
('4D', 'LORENZO', 'LÓPEZ', 'GONZÁLEZ', '1995-04-15', '44444444');

INSERT INTO TRASTORNOS (Cod_Trastorno, Nombre, Sintomas) VALUES 
(1, 'ANSIEDAD', 'Síntomas de la ansiedad'),
(2, 'DEPRESIÓN', 'Síntomas de la depresión'),
(3, 'INSOMNIO', 'Síntomas del insomnio'),
(4, 'HIPERACTIVIDAD', 'Síntomas de la hiperactividad');

INSERT INTO TERAPIAS (Cod_Terapia, Nombre, Observaciones) VALUES 
(1, 'RELAJACIÓN', 'Se debe aplicar en silencio'),
(2, 'HIPNOSIS', 'No funciona con todos los pacientes'),
(3, 'PSICOTERAPIA', NULL);

INSERT INTO SESIONES (NIF_PS, NIF_PA, Cod_Trastorno, Cod_Terapia, Fecha, Precio, Pagada) VALUES 
('777777777P', '1A', 1, 1, '2018-10-20 00:00:00', 60, 1),
('666666666C', '2B', 4, 3, '2018-10-22 00:00:00', 60, 1),
('777777777P', '3C', 1, 2, '2018-12-24 00:00:00', 60, 1),
('555555555R', '4D', 3, 1, '2018-12-24 00:00:00', 60, 1),
('666666666C', '1A', 1, 1, '2018-12-31 00:00:00', 60, 1),
('777777777P', '3C', 1, 3, '2019-01-02 00:00:00', 60, 1),
('555555555R', '4D', 3, 2, '2019-02-02 00:00:00', 60, 1);

-- 5. Hallar el nombre y apellidos de todos los psicólogos.

select p.Nombre, p.Apellido1, p.Apellido2  from psicologos p;

-- 6. Hallar el nombre y apellidos de los pacientes nacidos después del año 2000.

select p.Nombre, p.Apellido1, p.Apellido2  
from pacientes p
where YEAR(P.Fec_Nacimiento) > 2000;

-- 7. Hallar el nombre y apellidos de los psicólogos que han realizado sesiones con algún paciente nacido después del año 2000

select distinct p.Nombre, p.Apellido1, p.Apellido2  
from psicologos p
inner join sesiones s on p.NIF = s.NIF_PS
inner join pacientes p2 on s.NIF_PA = p2.NIF
where YEAR(P2.Fec_Nacimiento) > 2000;

-- 8. Hallar el nombre y apellidos de los psicólogos que han dado sesiones el día de noche buena o el día de noche vieja del año 2018.

select distinct p.Nombre, p.Apellido1, p.Apellido2  
from psicologos p
inner join sesiones s on p.NIF = s.NIF_PS
where s.Fecha in ('2018-12-24', '2018-12-31');

-- 9. Hallar el nombre de todos los trastornos.

select t.Nombre from trastornos t; 

-- 10.Eliminar las terapias que nunca se han utilizado.

delete from terapias t
where t.Cod_Terapia not in (select s.Cod_Terapia from sesiones s );

-- 11.Hallar el nombre y apellidos de los pacientes a los que se les ha aplicado la “RELAJACIÓN” como terapia

select distinct p.Nombre, p.Apellido1, p.Apellido2  
from pacientes p
inner join sesiones s on p.NIF = s.NIF_PA
inner join terapias t on s.Cod_Terapia = t.Cod_Terapia 
where t.Nombre = 'RELAJACIÓN' ;

-- 12.Hallar el nombre y apellidos de los psicólogos que no han utilizado nunca la “RELAJACIÓN” como terapia.

select p.Nombre, p.Apellido1, p.Apellido2
from psicologos p
where p.NIF not in(
    select s.NIF_PS
    from sesiones s
    inner join terapias t on s.Cod_Terapia = t.Cod_Terapia
    where t.Nombre = 'RELAJACIÓN'
);

-- 13.Hallar el nombre y apellidos de los pacientes a los que sólo se les ha aplicado la “RELAJACIÓN” como terapia.

select p.Nombre, p.Apellido1, p.Apellido2
from psicologos p
where p.NIF in(
    select s.NIF_PS
    from sesiones s
    inner join terapias t on s.Cod_Terapia = t.Cod_Terapia
    where t.Nombre = 'RELAJACIÓN'
)
and p.NIF not in(
    select s.NIF_PA
    from sesiones s
    inner join terapias t on s.Cod_Terapia = t.Cod_Terapia
    where t.Nombre != 'RELAJACIÓN'
);

-- 14.Hallar el nombre y apellidos de los pacientes menores de edad a los que les ha tratado todos los psicólogos de especialidad clínica.

select p.Nombre, p.Apellido1, p.Apellido2
from pacientes p
inner join sesiones s on p.NIF = s.NIF_PA
inner join psicologos ps on s.NIF_PS = ps.NIF
where YEAR(p.Fec_Nacimiento) > 2000
and ps.Especialidad = 'CLÍNICA'
group by p.NIF
having COUNT(distinct ps.NIF) = (
	select COUNT(*) 
	from PSICOLOGOS 
	where Especialidad = 'CLÍNICA'
);

-- 15.Hallar el nombre y apellidos de los psicologos que han dado sesiones a pacientes cuyo primer apellido es GONZÁLEZ o LÓPEZ.

select distinct p.Nombre, p.Apellido1, p.Apellido2
from psicologos p
inner join sesiones s on p.NIF = s.NIF_PS
inner join pacientes p2 on s.NIF_PA = p2.NIF
where p2.Apellido1 in ('GONZÁLEZ', 'LÓPEZ');

-- 16.Hallar el nombre y apellidos de los psicólogos clínicos que han aplicado todas las terapias.

select distinct p.Nombre, p.Apellido1, p.Apellido2
from psicologos p
inner join sesiones s on p.NIF = s.NIF_PS
group by p.NIF 
having COUNT(distinct s.Cod_Terapia) = (select COUNT(*) from terapias t);

-- 17.Disminuir en un 10% el precio de las sesiones del psicólogo cuyo NIF es “777777777P”

update sesiones s 
set Precio = Precio * 0.9
where s.NIF_PS = '777777777P';

-- 18.Disminuir en un 10% el precio de las sesiones realizadas en febrero de 2019.

update sesiones s 
set Precio = Precio * 0.9
where YEAR(Fecha) = 2019 and MONTH(Fecha) = 2;

SELECT * FROM SESIONES;

-- 19.Eliminar todas las relaciones de forma que no se produzcan errores.

DROP TABLE IF EXISTS SESIONES;
DROP TABLE IF EXISTS PSICOLOGOS;
DROP TABLE IF EXISTS PACIENTES;
DROP TABLE IF EXISTS TRASTORNOS;
DROP TABLE IF EXISTS TERAPIAS;


-- 20.Eliminar la base de datos.

DROP DATABASE IF EXISTS Gabinete_Psicologia;

