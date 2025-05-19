-- 1. Crear base de datos
DROP DATABASE IF EXISTS employees_test;
CREATE DATABASE employees_test;
USE employees_test;

-- Ejecutar esto para crear las tablas con la misma estructura que en `employees`
-- Puedes usar mysqldump o directamente:
-- En terminal:
-- mysqldump -d employees | mysql employees_test

-- 2. Crear estructura de tablas
CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE KEY (dept_name)
);

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_manager (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    PRIMARY KEY (emp_no, from_date)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    PRIMARY KEY (emp_no, title, from_date)
);

-- 3. Crear el procedimiento refrescar_employees_test()

DELIMITER //

CREATE PROCEDURE refrescar_employees_test()
BEGIN
    -- Limpiar las tablas
    DELETE FROM dept_emp;
    DELETE FROM dept_manager;
    DELETE FROM salaries;
    DELETE FROM titles;
    DELETE FROM employees;
    DELETE FROM departments;

    -- Insertar datos desde `employees`
    INSERT INTO departments
    SELECT * FROM employees.departments;

    INSERT INTO dept_emp
    SELECT * FROM employees.dept_emp
    WHERE to_date = '9999-01-01';

    INSERT INTO dept_manager
    SELECT * FROM employees.dept_manager
    WHERE to_date = '9999-01-01';

    INSERT INTO employees
    SELECT DISTINCT e.*
    FROM employees.employees e
    JOIN employees.dept_emp de ON e.emp_no = de.emp_no
    WHERE de.to_date = '9999-01-01';

    INSERT INTO salaries
    SELECT s.*
    FROM employees.salaries s
    JOIN employees_test.employees e ON s.emp_no = e.emp_no
    WHERE s.to_date = '9999-01-01';

    INSERT INTO titles
    SELECT t.*
    FROM employees.titles t
    JOIN employees_test.employees e ON t.emp_no = e.emp_no
    WHERE t.to_date = '9999-01-01';
END;
//

DELIMITER ;

-- 4. Crear el evento diario

-- Asegurar que el planificador de eventos está activado
SET GLOBAL event_scheduler = ON;

DELIMITER //

CREATE EVENT IF NOT EXISTS evt_refrescar_employees_test
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '05:00:00')
DO
BEGIN
    CALL refrescar_employees_test();
END;
//

DELIMITER ;

-- 5. Verificar ejecución
-- Probar manualmente con:

CALL refrescar_employees_test();

-- Verificar con:

SELECT * FROM employees_test.employees LIMIT 10;

