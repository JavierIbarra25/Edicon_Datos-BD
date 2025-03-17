-- 1.Crear una base de datos llamada “FORMACION_EMPLEADOS”.
DROP DATABASE IF EXISTS RRHH;

CREATE DATABASE RRHH 
	CHARSET utf8 COLLATE utf8_spanish_ci;

USE RRHH;

-- 2.Crear las tablas o relaciones anteriormente descritas.

-- Creación de la tabla CURSOS

CREATE TABLE Cursos(
	RefCurso	Numeric(6),
	Duracion	Numeric(4) NOT NULL,
	Descripcion	Varchar(200) NOT NULL,
	CONSTRAINT PK_Cursos PRIMARY KEY (RefCurso),
	CONSTRAINT CH_RefCurso CHECK (RefCurso >= 0),
	CONSTRAINT CH_Duracion CHECK (Duracion >= 1 AND Duracion <= 2000)
);

-- Creación de la tabla Empleados

CREATE TABLE Empleados(
	NIF 			Varchar(12),
	Nombre			Varchar(25) NOT NULL,
	Apellido1		Varchar(25) NOT NULL,
	Apellido2		Varchar(25),
	FecNacimiento	Date,
	Salario			Numeric(6,2) NOT NULL,
	Sexo			Varchar(6) NOT NULL,
	Nacion			Varchar(50) DEFAULT 'ESPAÑA',
	Firma			Varchar(200),	
	CONSTRAINT PK_Empleados PRIMARY KEY(NIF),
	CONSTRAINT CH_Salario CHECK(Salario >=100),
	CONSTRAINT CH_Sexo CHECK(Sexo='HOMBRE' OR Sexo='MUJER') 
);

-- Creación de la tabla CAPACITACIONES

CREATE TABLE Capacitaciones(
	RefCurso		Numeric(6),
	NIF_Empleado 	Varchar(12),
	CONSTRAINT PK_Capacitaciones PRIMARY KEY (RefCurso,NIF_Empleado),
	CONSTRAINT FK_CapaCursos FOREIGN KEY (RefCurso)
			REFERENCES Cursos (RefCurso)
			ON DELETE CASCADE,
	CONSTRAINT FK_CapacEmp FOREIGN KEY (NIF_Empleado)
			REFERENCES Empleados(NIF)
			ON DELETE CASCADE
);

-- Creación de la tabla EDICIONES

CREATE TABLE Ediciones (
	CodEdicion 	Numeric(6),
	RefCurso	Numeric(6) NOT NULL,
	Fecha		Date NOT NULL,
	Lugar		Varchar(100) NOT NULL,
	Coste		Numeric(7,2) NOT NULL,
	NIF_Docente	VARCHAR(12) NOT NULL,
	CONSTRAINT PK_Ediciones PRIMARY KEY (CodEdicion),
	CONSTRAINT FK_EdicCapact FOREIGN KEY (RefCurso,NIF_Docente)
			REFERENCES Capacitaciones(RefCurso,NIF_Empleado)
			ON DELETE CASCADE,
	CONSTRAINT CH_CodEdic CHECK (CodEdicion>=0),
	CONSTRAINT CH_EdicCoste CHECK (Coste>=0)
);

-- Creación de la tabla TELEFONOS

CREATE TABLE Telefonos(
	NIF_Empleado 	Varchar(12),
	Telefono		Varchar(11),
	CONSTRAINT PK_Telefonos PRIMARY KEY (NIF_Empleado,Telefono),
	CONSTRAINT FK_TelefEmp FOREIGN KEY (NIF_Empleado)
			REFERENCES Empleados(NIF)
			ON DELETE CASCADE
);


-- Creación de la tabla PRERREQUISITOS

CREATE TABLE Prerrequisitos(
	RefCursoARealizar	Numeric(6),
	RefCursoARequisito	Numeric(6),
	Tipo				Varchar(15) NOT NULL,
	CONSTRAINT PK_Prerreq PRIMARY KEY(RefCursoARealizar,RefCursoARequisito),
	CONSTRAINT FK_PrerrCursos1 FOREIGN KEY (RefCursoARealizar)
			REFERENCES Cursos (RefCurso)
			ON DELETE CASCADE,
	CONSTRAINT FK_PrerrCursos2 FOREIGN KEY (RefCursoARequisito)
			REFERENCES Cursos (RefCurso)
			ON DELETE CASCADE
);

-- Creación de la tabla MATRICULAS

CREATE TABLE Matriculas(
	NIF_Alumno 	Varchar(12),
	CodEdicion 	Numeric(6),
	CONSTRAINT PK_Matriculas PRIMARY KEY (NIF_Alumno,CodEdicion),
	CONSTRAINT FK_Matr_Emp FOREIGN KEY (NIF_Alumno)
			REFERENCES Empleados (NIF)
			ON DELETE CASCADE,
	CONSTRAINT FK_Matr_Edic FOREIGN KEY (CodEdicion)
			REFERENCES Ediciones (CodEdicion)
			ON DELETE CASCADE			
);

-- 3.En la relación CURSOS, después de RefCurso, añadir un nuevo atributo cuya descripción es la siguiente:

ALTER TABLE Cursos
ADD Titulo Varchar(25) AFTER RefCurso;

-- 4.En la relación MATRICULAS, cambiar su identificador (MATRICULAS) por MATRICULACIONES.

RENAME TABLE Matriculas TO Matriculaciones;

-- 5.En la relación PRERREQUISITOS cambiar el identificador del atributo RefCursoARequisito por RefCursoRequisito.

ALTER TABLE Prerrequisitos
CHANGE COLUMN RefCursoARequisito RefCursoRequisito Numeric(6);

-- 6.En la relación PRERREQUISITOS añadir una restricción para que el atributo tipo únicamente pueda tener los valores ACONSEJABLE y OBLIGATORIO.

ALTER TABLE Prerrequisitos
ADD CONSTRAINT CH_PrerrTipo CHECK (Tipo='ACONSEJABLE' OR Tipo='OBLIGATORIO');

-- 7.En la relación PRERREQUISITOS añadir una restricción para que un curso no pueda ser prerrequisito de él mismo.

ALTER TABLE Prerrequisitos
ADD CONSTRAINT CH_PrerrMismo CHECK (RefCursoARealizar <> RefCursoRequisito); 

-- 8.En la relación EMPLEADOS eliminar el atributo Nacion.

ALTER TABLE EMPLEADOS
DROP COLUMN Nacion

-- 9. Introducir, como mínimo, dos tuplas en cada tabla. Para la tabla Cursos, debes introducir también estas tupla.

-- Insertar cursos
INSERT INTO Cursos (RefCurso, Titulo, Duracion, Descripcion) VALUES
(1, 'GESTIÓN DE BASES DE DATOS', 100, 'GESTIÓN DE BASES DE DATOS'),
(2, 'SISTEMAS OPERATIVOS', 200, 'IMPLANTACIÓN DE SISTEMAS OPERATIVOS'),
(3, 'ADMON DE BASES DE DATOS', 60, 'ABD'),
(4, 'PROGRAMACIÓN EN PYTHON', 120, 'Curso de programación en Python'),
(5, 'INTELIGENCIA ARTIFICIAL', 150, 'Fundamentos de IA'),
(6, 'DESARROLLO WEB', 100, 'Desarrollo de aplicaciones web'),
(7, 'REDES NEURONALES', 80, 'Introducción a redes neuronales'),
(8, 'SEGURIDAD INFORMÁTICA', 90, 'Conceptos de seguridad informática'),
(9, 'CLOUD COMPUTING', 110, 'Introducción a la nube'),
(10, 'BIG DATA', 130, 'Manejo de grandes volúmenes de datos'),
(11, 'DEVOPS', 140, 'Prácticas de DevOps');

-- Insertar empleados
INSERT INTO Empleados (NIF, Nombre, Apellido1, Apellido2, FecNacimiento, Salario, Sexo, Firma) VALUES
('12345678A', 'Juan', 'García', 'López', '1985-05-15', 2500.00, 'HOMBRE', 'Firma1'),
('87654321B', 'María', 'Martínez', 'Sánchez', '1990-08-22', 3000.00, 'MUJER', 'Firma2'),
('98765432C', 'Carlos', 'Fernández', 'Gómez', '1988-03-10', 2800.00, 'HOMBRE', 'Firma3'),
('11223344D', 'Ana', 'Ruiz', 'García', '1987-04-12', 2700.00, 'MUJER', 'Firma4');

-- Insertar capacitaciones
INSERT INTO Capacitaciones (RefCurso, NIF_Empleado) VALUES
(1, '12345678A'),  -- Juan García
(1, '11223344D'),
(2, '87654321B'),  -- María Martínez
(2, '11223344D'),
(3, '98765432C'),  -- Carlos Fernández
(3, '11223344D'), 
(4, '11223344D'),  -- Ana Ruiz
(5, '11223344D'),  -- Ana Ruiz
(6, '11223344D'),  -- Ana Ruiz
(7, '11223344D'),  -- Ana Ruiz
(8, '11223344D'),  -- Ana Ruiz
(9, '11223344D'),  -- Ana Ruiz
(10, '11223344D'), -- Ana Ruiz
(11, '11223344D'); -- Ana Ruiz

-- Insertar ediciones (asegurando que Ana Ruiz imparta más de 10 cursos)

INSERT INTO Ediciones (CodEdicion, RefCurso, Fecha, Lugar, Coste, NIF_Docente) VALUES
(101, 1, '2023-10-01', 'Madrid', 500.00, '11223344D'),  -- Ana Ruiz
(102, 2, '2023-11-01', 'Barcelona', 600.00, '11223344D'), -- Ana Ruiz
(103, 3, '2023-12-01', 'Valencia', 450.00, '11223344D'), -- Ana Ruiz
(104, 4, '2023-10-05', 'Madrid', 550.00, '11223344D'),  -- Ana Ruiz
(105, 5, '2023-10-10', 'Barcelona', 650.00, '11223344D'), -- Ana Ruiz
(106, 6, '2023-10-15', 'Valencia', 500.00, '11223344D'), -- Ana Ruiz
(107, 7, '2023-10-20', 'Sevilla', 480.00, '11223344D'), -- Ana Ruiz
(108, 8, '2023-10-25', 'Zaragoza', 520.00, '11223344D'), -- Ana Ruiz
(109, 9, '2023-11-01', 'Málaga', 530.00, '11223344D'), -- Ana Ruiz
(110, 10, '2023-11-05', 'Bilbao', 540.00, '11223344D'), -- Ana Ruiz
(111, 11, '2023-11-10', 'Alicante', 560.00, '11223344D'), -- Ana Ruiz
(114, 1, '2023-11-25', 'Madrid', 590.00, '12345678A'), -- Juan García
(115, 2, '2023-12-01', 'Barcelona', 600.00, '87654321B'), -- María Martínez
(116, 3, '2023-12-05', 'Valencia', 610.00, '98765432C'); -- Carlos Fernández

-- Insertar teléfonos
INSERT INTO Telefonos (NIF_Empleado, Telefono) VALUES
('12345678A', '600123456'),
('87654321B', '600654321'),
('98765432C', '600987654');

-- Insertar prerrequisitos
INSERT INTO Prerrequisitos (RefCursoARealizar, RefCursoRequisito, Tipo) VALUES
(2, 1, 'OBLIGATORIO'),
(3, 1, 'ACONSEJABLE'),
(3, 2, 'OBLIGATORIO');

-- Insertar matriculaciones
INSERT INTO Matriculaciones (NIF_Alumno, CodEdicion) VALUES
('12345678A', 101),  -- Juan García en edición 101
('87654321B', 102),  -- María Martínez en edición 102
('98765432C', 103);  -- Carlos Fernández en edición 103

-- Verificar las tuplas en la tabla Cursos
SELECT * FROM Cursos;
SELECT * FROM Empleados;
SELECT * FROM Capacitaciones;
SELECT * FROM Ediciones;
SELECT * FROM Telefonos;
SELECT * FROM Prerrequisitos;
SELECT * FROM Matriculaciones;

-- 10. Aumentar en 10 horas la duración de los cursos en cuyo título aparece “BASES DE DATOS”.

UPDATE Cursos
SET duracion = duracion + 10
WHERE titulo LIKE '%BASES DE DATOS%';

SELECT * FROM Cursos WHERE titulo LIKE '%BASES DE DATOS%';

-- 11. Aumentar el sueldo en un 10% a los empleados que han impartido más de diez cursos (pueden ser de ediciones diferentes),utiliza GROUP BY en la tabla Ediciones para saber qué NIF_Docente ha 
-- impartido 2 o más cursos. Luego aplica el UPDATE con un sub SELECT de lo anterior.

-- Paso 1: Identificar los empleados que han impartido más de 10 cursos

SELECT e.NIF_Docente, COUNT(*) AS CursosImpartidos
FROM Ediciones e
GROUP BY e.NIF_Docente
HAVING COUNT(*) > 10;

-- Paso 2: Aumentar el salario en un 10% a esos empleados

UPDATE Empleados
SET Salario = Salario * 1.10
WHERE NIF IN (
    SELECT e.NIF_Docente
    FROM Ediciones e
    GROUP BY e.NIF_Docente
    HAVING COUNT(*) > 10
);

-- Verificar el resultado, Ana Ruiz con 11 cursos ha aumentado de 2.700 a 2.970

SELECT * FROM Empleados;

-- 12. Eliminar los cursos que no tienen ninguna edición (tiene que haber, al menos una eliminación) 

-- Insertar un curso sin edición (si no existe)
INSERT INTO Cursos (RefCurso, Titulo, Duracion, Descripcion) 
VALUES (12, 'CURSO SIN EDICIÓN', 50, 'Este curso no tiene ediciones asociadas');

-- Eliminar cursos sin ediciones
DELETE FROM Cursos
WHERE RefCurso NOT IN (SELECT RefCurso FROM Ediciones);

-- Verificar que el curso sin edición ha sido eliminado
SELECT * FROM Cursos;

-- 13. Aumentar el sueldo en un 15% a los empleados que han impartido cursos en cuyo título aparece “BASES DE DATOS”. (tiene que haber al menos una actualización) 

-- Paso 1: Identificar los NIF_Docente que han impartido este curso con un SELECT de dos tablas (Cursos y Ediciones) y un LIKE

SELECT NIF, Nombre, Salario
FROM Empleados
WHERE NIF IN (
    SELECT e.NIF_Docente
    FROM Ediciones e
    inner JOIN Cursos c ON e.RefCurso = c.RefCurso
    WHERE c.Titulo LIKE '%BASES DE DATOS%'
);


-- Paso 2: Aplicar UPDATE con un WHERE NIF IN (SELECT de lo anterior)
UPDATE Empleados
SET Salario = Salario * 1.15
WHERE NIF IN (
    SELECT e.NIF_Docente
    FROM Ediciones e
    INNER JOIN Cursos c ON e.RefCurso = c.RefCurso
    WHERE c.Titulo LIKE '%BASES DE DATOS%'
);

-- Verificar el resultado
SELECT NIF, Nombre, Salario
FROM Empleados
WHERE NIF IN (
    SELECT e.NIF_Docente
    FROM Ediciones e
    INNER JOIN Cursos c ON e.RefCurso = c.RefCurso
    WHERE c.Titulo LIKE '%BASES DE DATOS%'
);


-- 14. Eliminar los cursos que en estos 10 años (WHERE Fecha >='2023-03-01' AND Fecha <= '2024-03-01') no se han celebrado ninguna edición. (puede no haber ninguna eliminación) 

-- a. Identifica los cursos con ediciones en esas fechas

SELECT e.RefCurso
FROM Ediciones e
WHERE e.Fecha >= '2023-03-01' AND e.Fecha <= '2024-03-01';

-- b. Elimínalos con NOT IN (SELECT de lo anterior)

DELETE FROM Cursos
WHERE RefCurso NOT IN (
    SELECT e.RefCurso
    FROM Ediciones e
    WHERE e.Fecha >= '2023-03-01' AND e.Fecha <= '2024-03-01'
);

-- Como no teníamos ningún curso fuera de esos años la tabla no cambiará

SELECT * FROM Cursos;

-- 15. Aumentar un 10% la duración del curso en que más alumnos se han matriculado. (tiene que haber al menos una actualización). 

-- a. Crea una vista de la siguiente manera CREATE VIEW V_CursoMatriculados (RefCurso, numMatriculados) AS
-- SELECT RefCurso, Count(*)
-- FROM Matriculaciones M, Ediciones E
-- WHERE M.CodEdicion = E.CodEdicion
-- GROUP BY RefCurso;

CREATE VIEW V_CursoMatriculados (RefCurso, numMatriculados) AS 
SELECT RefCurso, Count(*)
FROM Matriculaciones M, Ediciones E
WHERE M.CodEdicion = E.CodEdicion
GROUP BY RefCurso;

SELECT * FROM V_CursoMatriculados;

-- b. Utiliza MAX(numMatriculados)

UPDATE Cursos 
SET Duracion = Duracion * 1.1
WHERE RefCurso IN (
    SELECT RefCurso 
    FROM V_CursoMatriculados
    WHERE numMatriculados = (
        SELECT MAX(numMatriculados) 
        FROM V_CursoMatriculados
    )
    AND RefCurso IN (SELECT DISTINCT RefCurso FROM Ediciones)
);
