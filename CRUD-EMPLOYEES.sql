-- =============================================
-- PROCEDIMIENTOS ALMACENADOS PARA TABLA staff
-- =============================================

DELIMITER $$

-- =============================================
-- PROCEDIMIENTO 1: INSERTAR STAFF
-- =============================================
CREATE PROCEDURE insertar_staff (
    IN p_employee_code SMALLINT UNSIGNED,
    IN p_name VARCHAR(25),
    IN p_job VARCHAR(25),
    IN p_salary SMALLINT UNSIGNED,
    IN p_department_code SMALLINT UNSIGNED,
    IN p_start_date DATE,
    IN p_superior_officer SMALLINT UNSIGNED,
    OUT o_employee_code SMALLINT UNSIGNED,
    OUT o_name VARCHAR(25),
    OUT o_job VARCHAR(25),
    OUT o_salary SMALLINT UNSIGNED,
    OUT o_department_code SMALLINT UNSIGNED,
    OUT o_start_date DATE,
    OUT o_superior_officer SMALLINT UNSIGNED,
    OUT o_status INT,
    OUT o_error_message VARCHAR(255)
)
proc_insert:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET o_status = 5;
        SET o_error_message = 'Error: Excepción durante la inserción';
        ROLLBACK;
    END;

    -- Validaciones iniciales
    IF p_employee_code IS NULL OR p_name IS NULL OR p_job IS NULL THEN
        SET o_status = 2;
        SET o_error_message = 'Error: Falta algún dato obligatorio';
        LEAVE proc_insert;
    END IF;

    -- Fecha de inicio
    IF p_start_date IS NULL THEN
        SET p_start_date = CURDATE();
    END IF;

    -- Transacción con aislamiento REPEATABLE READ para consistencia en lectura
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

     -- Ajuste de salario
    IF p_salary IS NULL THEN
        SET p_salary = (SELECT AVG(Salary) FROM staff);
    END IF;
    IF p_salary > (SELECT MAX(Salary) FROM staff) THEN
        SET p_salary = (SELECT MAX(Salary) FROM staff);
    ELSEIF p_salary < (SELECT MIN(Salary) FROM staff) THEN
        SET p_salary = (SELECT MIN(Salary) FROM staff);
    END IF;

    -- Insercción duplicada
    IF EXISTS (SELECT 1 FROM staff WHERE Employee_Code = p_employee_code) THEN
        SET o_status = 1;
        SET o_error_message = 'Error: Inserción duplicada';
        ROLLBACK; -- fin transacción
        LEAVE proc_insert;
    END IF;

    -- Validar Department_Code
    IF p_department_code IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM department WHERE Department_Code = p_department_code) THEN
        SET o_status = 4;
        SET o_error_message = 'Error: Departamento no existe';
        ROLLBACK; -- fin transacción
        LEAVE proc_insert;
    END IF;

    -- Validar Superior_Officer
    IF p_superior_officer IS NULL THEN
        SET p_superior_officer = p_employee_code;
    ELSEIF NOT EXISTS (SELECT 1 FROM staff WHERE Employee_Code = p_superior_officer) THEN
        SET o_status = 3;
        SET o_error_message = 'Error: Superior Officer no existe';
        ROLLBACK; -- fin transacción
        LEAVE proc_insert;
    END IF;

        INSERT INTO staff (Employee_Code, Name, Job, Salary, Department_Code, Start_Date, Superior_Officer)
        VALUES (p_employee_code, p_name, p_job, p_salary, p_department_code, p_start_date, p_superior_officer);

        -- Recuperar los datos recién insertados (incluyendo posibles cambios por triggers)
        SELECT s* INTO o_employee_code, o_name, o_job, o_salary, o_department_code, o_start_date, o_superior_officer
        FROM staff 
        WHERE s.Employee_Code = p_employee_code;
    
    COMMIT;

    -- Éxito
    SET o_status = 0;
    SET o_error_message = 'Info: Inserción exitosa';

END$$

    -- Insercción exitosa
    CALL insertar_staff(2000, 'Nuevo Empleado', 'developer', 5000, 5, NULL, 1008, @o_status, @o_error_message);
    SELECT @o_status AS status, @o_error_message AS message;

    SELECT * FROM staff WHERE Employee_Code = 2000;

    -- Falta dato obligatorio (name es NULL)
    CALL insertar_staff(2001, NULL, 'developer', 2000, 5, NULL, 1008,  @o_status, @o_error_message);
    SELECT @o_status AS status, @o_error_message AS message;

    -- Employee_Code duplicado
    CALL insertar_staff(368,'Nombre','job',5000,5,NULL,1008, @o_status, @o_error_message);
    SELECT @o_status AS status, @o_msg AS message;

-- =============================================
-- PROCEDIMIENTO 2: ACTUALIZAR STAFF
-- =============================================
CREATE PROCEDURE actualizar_staff (
    IN p_employee_code SMALLINT UNSIGNED,
    IN p_name VARCHAR(25),
    IN p_job VARCHAR(25),
    IN p_salary SMALLINT UNSIGNED,
    IN p_department_code SMALLINT UNSIGNED,
    IN p_start_date DATE,
    IN p_superior_officer SMALLINT UNSIGNED,
    OUT o_employee_code SMALLINT UNSIGNED,
    OUT o_name VARCHAR(25),
    OUT o_job VARCHAR(25),
    OUT o_salary SMALLINT UNSIGNED,
    OUT o_department_code SMALLINT UNSIGNED,
    OUT o_start_date DATE,
    OUT o_superior_officer SMALLINT UNSIGNED,
    OUT o_status INT,
    OUT o_error_message VARCHAR(255)
)
proc_update:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET o_status = 5;
        SET o_error_message = 'Error: Excepción durante la actualización';
    END;

    -- Validaciones iniciales
    IF p_employee_code IS NULL OR p_name IS NULL OR p_job IS NULL THEN
        SET o_status = 2;
        SET o_error_message = 'Error: Falta algún dato obligatorio';
        LEAVE proc_update;
    END IF;

    -- Comprobar existencia
    IF NOT EXISTS (SELECT 1 FROM staff WHERE Employee_Code = p_employee_code) THEN
        SET o_status = 1;
        SET o_error_message = 'Error: Staff no encontrado';
        LEAVE proc_update;
    END IF;

    -- Ajuste de salario
    IF p_salary IS NULL THEN
        SET p_salary = (SELECT AVG(Salary) FROM staff);
    END IF;
    IF p_salary > (SELECT MAX(Salary) FROM staff) THEN
        SET p_salary = (SELECT MAX(Salary) FROM staff);
    ELSEIF p_salary < (SELECT MIN(Salary) FROM staff) THEN
        SET p_salary = (SELECT MIN(Salary) FROM staff);
    END IF;

    -- Validar Department_Code
    IF p_department_code IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM department WHERE Department_Code = p_department_code) THEN
        SET o_status = 4;
        SET o_error_message = 'Error: Department_Code no es válido';
        LEAVE proc_update;
    END IF;

    -- Validar Superior_Officer
    IF p_superior_officer IS NULL THEN
        SET p_superior_officer = p_employee_code;
    ELSEIF NOT EXISTS (SELECT 1 FROM staff WHERE Employee_Code = p_superior_officer) THEN
        SET o_status = 3;
        SET o_error_message = 'Error: Superior_Officer no es válido';
        LEAVE proc_update;
    END IF;

    -- Fecha de inicio
    IF p_start_date IS NULL THEN
        SET p_start_date = CURDATE();
    END IF;

    -- Transacción con aislamiento READ COMMITTED para evitar lecturas sucias
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;
        UPDATE staff
        SET Name = p_name,
            Job = p_job,
            Salary = p_salary,
            Department_Code = p_department_code,
            Start_Date = p_start_date,
            Superior_Officer = p_superior_officer
        WHERE Employee_Code = p_employee_code;
    COMMIT;

    -- Devolver datos actualizados
    SET o_employee_code = p_employee_code;
    SET o_name = p_name;
    SET o_job = p_job;
    SET o_salary = p_salary;
    SET o_department_code = p_department_code;
    SET o_start_date = p_start_date;
    SET o_superior_officer = p_superior_officer;
    SET o_status = 0;
    SET o_error_message = 'Info: Se ha modificado la tupla';
END$$

-- =============================================
-- PROCEDIMIENTO 3: ELIMINAR STAFF
-- =============================================
CREATE PROCEDURE eliminar_staff (
    IN p_employee_code SMALLINT UNSIGNED,
    OUT o_employee_code SMALLINT UNSIGNED,
    OUT o_name VARCHAR(25),
    OUT o_job VARCHAR(25),
    OUT o_salary SMALLINT UNSIGNED,
    OUT o_department_code SMALLINT UNSIGNED,
    OUT o_start_date DATE,
    OUT o_superior_officer SMALLINT UNSIGNED,
    OUT o_status INT,
    OUT o_error_message VARCHAR(255)
)
proc_delete:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET o_status = 5;
        SET o_error_message = 'Error: Excepción durante la eliminación';
    END;

    -- Validación de parámetro
    IF p_employee_code IS NULL THEN
        SET o_status = 2;
        SET o_error_message = 'Error: Falta algún dato obligatorio, no se aporta employee_code';
        LEAVE proc_delete;
    END IF;

    -- Comprobar existencia
    IF NOT EXISTS (SELECT 1 FROM staff WHERE Employee_Code = p_employee_code) THEN
        SET o_status = 1;
        SET o_error_message = 'Error: Staff no existe';
        LEAVE proc_delete;
    END IF;

    -- Obtener datos antes de eliminar
    SELECT Employee_Code, Name, Job, Salary, Department_Code, Start_Date, Superior_Officer
    INTO o_employee_code, o_name, o_job, o_salary, o_department_code, o_start_date, o_superior_officer
    FROM staff
    WHERE Employee_Code = p_employee_code;

    -- Transacción con aislamiento SERIALIZABLE para evitar condiciones de carrera
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    START TRANSACTION;
        DELETE FROM staff WHERE Employee_Code = p_employee_code;
    COMMIT;

    SET o_status = 0;
    SET o_error_message = 'Info: Staff eliminado, se devuelve la tupla eliminada';
END$$

DELIMITER ;
