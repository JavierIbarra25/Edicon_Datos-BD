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
INSERT INTO Cursos VALUES (1, 'GESTIÓN DE BASES DE DATOS', 100, 'GESTIÓN DE BASES DE DATOS');
INSERT INTO Cursos VALUES (2, 'SISTEMAS OPERATIVOS', 200, 'IMPLANTACIÓN DE SISTEMAS OPERATIVOS');
INSERT INTO Cursos VALUES (3, 'ADMON DE BASES DE DATOS', 60, 'ABD');

-- Verificar las tuplas en la tabla Cursos
SELECT * FROM Cursos;

-- 10. Aumentar en 10 horas la duración de los cursos en cuyo título aparece “BASES DE DATOS”.

UPDATE Cursos
SET duracion = duracion + 10
WHERE titulo LIKE '%BASES DE DATOS%';

SELECT * FROM Cursos WHERE titulo LIKE '%BASES DE DATOS%';
