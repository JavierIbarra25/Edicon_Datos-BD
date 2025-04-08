DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
; 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
;

-- Insert into departments
INSERT INTO departments (dept_no, dept_name) VALUES
('d001', 'Marketing'),
('d002', 'Finance'),
('d003', 'Human Resources'),
('d004', 'Production'),
('d005', 'Development'),
('d006', 'Quality Management'),
('d007', 'Sales'),
('d008', 'Research'),
('d009', 'Customer Service');

-- Insert into employees
INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date) VALUES
(10001, '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26'),
(10002, '1964-06-02', 'Bezalel', 'Simmel', 'F', '1985-11-21'),
(10003, '1959-12-03', 'Parto', 'Bamford', 'M', '1986-08-28'),
(10004, '1954-05-01', 'Chirstian', 'Koblick', 'M', '1986-12-01'),
(10005, '1955-01-21', 'Kyoichi', 'Maliniak', 'M', '1989-09-12'),
(10006, '1953-04-20', 'Anneke', 'Preusig', 'F', '1989-06-02'),
(10007, '1957-05-23', 'Tzvetan', 'Zielinski', 'F', '1989-02-10'),
(10008, '1958-02-19', 'Saniya', 'Kalloufi', 'M', '1994-09-15'),
(10009, '1952-04-19', 'Sumant', 'Peac', 'F', '1985-02-18'),
(10010, '1963-06-01', 'Duangkaew', 'Piveteau', 'F', '1989-08-24');

-- Insert into dept_emp (current employees)
INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date) VALUES
(10001, 'd005', '1986-06-26', '9999-01-01'),
(10002, 'd007', '1985-11-21', '9999-01-01'),
(10003, 'd004', '1986-08-28', '9999-01-01'),
(10004, 'd004', '1986-12-01', '9999-01-01'),
(10005, 'd003', '1989-09-12', '9999-01-01'),
(10006, 'd005', '1989-06-02', '9999-01-01'),
(10007, 'd008', '1989-02-10', '9999-01-01'),
(10008, 'd005', '1994-09-15', '9999-01-01'),
(10009, 'd006', '1985-02-18', '9999-01-01'),
(10010, 'd004', '1989-08-24', '9999-01-01');

-- Insert into dept_manager (current managers)
INSERT INTO dept_manager (emp_no, dept_no, from_date, to_date) VALUES
(10001, 'd005', '1991-09-08', '9999-01-01'),  -- Georgi Facello manages Development
(10002, 'd007', '1991-01-03', '9999-01-01'), -- Bezalel Simmel manages Sales
(10005, 'd003', '1992-02-05', '9999-01-01'); -- Kyoichi Maliniak manages HR

-- Insert into titles
INSERT INTO titles (emp_no, title, from_date, to_date) VALUES
(10001, 'Senior Engineer', '1986-06-26', '1995-06-26'),
(10001, 'Manager', '1995-06-26', '9999-01-01'),
(10002, 'Staff', '1985-11-21', '1990-11-21'),
(10002, 'Senior Staff', '1990-11-21', '9999-01-01'),
(10003, 'Senior Engineer', '1986-08-28', '9999-01-01'),
(10004, 'Engineer', '1986-12-01', '1995-12-01'),
(10004, 'Senior Engineer', '1995-12-01', '9999-01-01'),
(10005, 'Senior Staff', '1989-09-12', '1996-09-11'),
(10005, 'Manager', '1996-09-11', '9999-01-01'),
(10006, 'Senior Engineer', '1989-06-02', '9999-01-01'),
(10007, 'Senior Staff', '1989-02-10', '9999-01-01'),
(10008, 'Assistant Engineer', '1994-09-15', '2000-09-14'),
(10008, 'Engineer', '2000-09-14', '9999-01-01'),
(10009, 'Assistant Engineer', '1985-02-18', '1990-02-18'),
(10009, 'Engineer', '1990-02-18', '1995-02-18'),
(10009, 'Senior Engineer', '1995-02-18', '9999-01-01'),
(10010, 'Engineer', '1989-08-24', '1994-08-24'),
(10010, 'Senior Engineer', '1994-08-24', '9999-01-01');

-- Insert into salaries (current salaries)
INSERT INTO salaries (emp_no, salary, from_date, to_date) VALUES
(10001, 80000, '1995-06-26', '9999-01-01'),  -- Manager salary
(10002, 75000, '2000-11-21', '9999-01-01'),  -- Senior Staff
(10003, 82000, '2005-08-28', '9999-01-01'),  -- Senior Engineer
(10004, 78000, '2000-12-01', '9999-01-01'),  -- Senior Engineer
(10005, 85000, '1996-09-11', '9999-01-01'),  -- Manager salary
(10006, 72000, '2005-06-02', '9999-01-01'),  -- Senior Engineer
(10007, 68000, '2005-02-10', '9999-01-01'),  -- Senior Staff
(10008, 65000, '2005-09-15', '9999-01-01'),  -- Engineer
(10009, 71000, '2000-02-18', '9999-01-01'),  -- Senior Engineer
(10010, 69000, '2000-08-24', '9999-01-01'); -- Senior Engineer
