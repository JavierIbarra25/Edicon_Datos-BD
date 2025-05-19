-- =============================================
-- CREAR TABLA DE HISTORIAL DE SALARIOS
-- =============================================
DROP TABLE IF EXISTS salary_history;
CREATE TABLE salary_history (
    employee_code SMALLINT UNSIGNED NOT NULL,
    date_new_salary DATE NOT NULL,
    salary DECIMAL(7,2) NOT NULL,
    PRIMARY KEY (employee_code, date_new_salary),
    FOREIGN KEY (employee_code) REFERENCES employees(emp_no) ON DELETE CASCADE
);

-- =============================================
-- TRIGGERS PARA MANTENER Salary_History
-- =============================================

-- Trigger tras insertar nuevo empleado

DELIMITER //
DROP TRIGGER IF EXISTS trg_insert_salary_history
CREATE TRIGGER trg_insert_salary_history
AFTER INSERT ON salaries
FOR EACH ROW
BEGIN
    INSERT INTO salary_history (employee_code, date_new_salary, salary)
    VALUES (NEW.emp_no, NEW.from_date, NEW.salary);
END;
//
DELIMITER ;

-- Trigger tras actualización de salario

DELIMITER //
DROP TRIGGER IF EXISTS trg_update_salary_history
CREATE TRIGGER trg_update_salary_history
AFTER UPDATE ON salaries
FOR EACH ROW
BEGIN
    -- Inserta el nuevo salario como una nueva entrada en el historial
    INSERT INTO salary_history (employee_code, date_new_salary, salary)
    VALUES (NEW.emp_no, NEW.from_date, NEW.salary);
END;
//
DELIMITER ;

-- Trigger tras eliminación de empleado → sin trigger
-- No hace falta un trigger aquí porque la clave foránea con ON DELETE CASCADE ya elimina automáticamente los sueldos del historial cuando se elimina el empleado.

-- Para varios triggers sobre la misma tabla, MySQL permite definir más de un trigger del mismo tipo (AFTER/BEFORE) solo si se especifica su orden de ejecución usando FOLLOWS o PRECEDES, pero en este caso no es necesario.

-- Inserta un nuevo empleado

INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
VALUES (10001, '1990-01-01', 'Ana', 'Gómez', 'F', '2024-01-01');

-- Inserta un salario en salaries (esto debe activar el trigger)

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 35000, '2024-01-01', '9999-01-01');

-- Consulta la tabla salary_history

SELECT * FROM salary_history WHERE employee_code = 10001;


