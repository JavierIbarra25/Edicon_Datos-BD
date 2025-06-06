-- Crear la base de datos
DROP DATABASE IF EXISTS t5_employees;
CREATE DATABASE t5_employees CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci;
USE t5_employees;

-- Crear tabla DEPARTMENT
DROP TABLE IF EXISTS `Department`;
CREATE TABLE Department (
  Department_Code SMALLINT UNSIGNED NOT NULL,
  Department_Name VARCHAR(15) COLLATE utf8mb4_spanish2_ci NOT NULL,
  City VARCHAR(15) COLLATE utf8mb4_spanish2_ci NOT NULL,
  CONSTRAINT PK_DEPARTMENT PRIMARY KEY(Department_Code)
);

-- Crear tabla STAFF
DROP TABLE IF EXISTS `staff`;
CREATE TABLE staff (
  Employee_Code SMALLINT UNSIGNED NOT NULL,
  Name VARCHAR(25) COLLATE utf8mb4_spanish2_ci NOT NULL,
  Job VARCHAR(25) COLLATE utf8mb4_spanish2_ci NOT NULL,
  Salary SMALLINT UNSIGNED NOT NULL,
  Department_Code SMALLINT UNSIGNED DEFAULT NULL,
  Start_Date DATE NOT NULL,
  Superior_Officer SMALLINT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (Employee_Code),
  KEY FK_STAFF (Superior_Officer),
  KEY FK_DEPARTMENT (Department_Code),
  CONSTRAINT FK_STAFF FOREIGN KEY (Superior_Officer) REFERENCES staff (Employee_Code),
  CONSTRAINT FK_DEPARTMENT FOREIGN KEY (Department_Code) REFERENCES department (Department_Code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;


-- ---------------------------------------------------------------------------------------
-- Insertar datos en DEPARTMENT
-- ---------------------------------------------------------------------------------------
INSERT INTO Department VALUES(12, 'Direction', 'Palma' );
INSERT INTO Department VALUES(05, 'Analysis', 'Barcelona');
INSERT INTO Department VALUES(08, 'Programming', 'Maó' );
INSERT INTO Department VALUES(10, 'Control', 'Eivissa' );

select * from t5_employees.department d order by d.Department_Code asc;

-- ---------------------------------------------------------------------------------------
-- Insertar datos en STAFF
-- ---------------------------------------------------------------------------------------
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (0368, 'Almonacid', 'head', 9700, 12, STR_TO_DATE('20/12/2022', '%d/%m/%Y'), 0368);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (1008, 'Carpio', 'analyst', 7800, 10, STR_TO_DATE('15-05-2023', '%d-%m-%Y'), 0368);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (0413, 'Alonso', 'analyst', 6000, 05, STR_TO_DATE('01-06-2023', '%d-%m-%Y'), 1008);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (0545, 'Arnaiz', 'analyst', 5600, 05, STR_TO_DATE('01-11-2022', '%d-%m-%Y'), 1008);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (1190, 'Ciriano', 'Project Manager', 8000, 10, STR_TO_DATE('01-09-2022', '%d-%m-%Y'), 0368);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (0552, 'Balmaseda', 'analyst', 5500, 05, STR_TO_DATE('15-10-2023', '%d-%m-%Y'), 1190);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (0663, 'Barcelo', 'analyst', 6700, 05, STR_TO_DATE('02-01-2023', '%d-%m-%Y'), 1190);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (0765, 'Bauza', 'programmer', 3800, 08, STR_TO_DATE('01-06-2023', '%d-%m-%Y'), 0413);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (0998, 'Belando', 'programmer', 4300, 08, STR_TO_DATE('01-01-2023', '%d-%m-%Y'), 0413);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (1003, 'Busuioc', 'analyst', 6600, 05, STR_TO_DATE('12-01-2023', '%d-%m-%Y'), 1190);
 
INSERT INTO Staff (Employee_Code, Name , Job , Salary ,  Department_Code , Start_Date  , Superior_Officer) 
VALUES (1087, 'Catalan', 'programmer', 4000, 08, STR_TO_DATE('01-02-2023', '%d-%m-%Y'), 1003);      


select*from department d ;
select*from staff s  ;