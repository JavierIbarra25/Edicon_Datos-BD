-- ----------------------------------------------------------------------------------------------------------------------------------
-- CESUR BASES DE DATOS 2023/24 2024/25
-- TEMA 4: REALIZACION DE CONSULTAS (JOIN)

SELECT * FROM abc;  --  This sentence prevents the execution of all the script by mistake

-- ----------------------------------------------------------------------------------------------------------------------------------
/*
0484 Bases de Datos\Material Educativo 0484 Bases de Datos\Tema04 Realización de Consultas\Entregas\Entregas2425\0484 Bases de Datos Entrega Tema4 Realización de Consultas  - Vistas.sql
*/

/*
 * SELECT [DISTINCT] select_expresion, [select_expresion] ...
 * [FROM referenced_tables] --> Here is when we've the possibility to add more than one table
 * [WHERE filter]
 * [GROUP BY expresion [,expresion] ...]
 * [HAVING filter_group]
 * [ORDER BY {column | expresion | position} [ASC | DESC], ...] 
 * 
 * referenced_tables :
 * referenced_table[, referenced_table] ... --> This is SQL 1 (SQL-86/87) 
 * | referenced_table  [INNER | CROSS] JOIN referenced_table [ON condition] --> From here is SQL 2 (SQL-92 and SQL-2003)
 * | referenced_table LEFT [OUTER] JOIN referenced_table ON condition
 * | referenced_table RIGHT [OUTER] JOIN referenced_table ON condition 
 * referenced_table:
 * table_name [[AS] alias]
 */

/*
 * 
 * CARTESIAN PRODUCT: 
 * 		CROSS JOIN: Returns all records from both tables, Cartesian Product.
  *
 * JOIN INTERNA: 
 * 		INNER JOIN: Returns records that have matching values in both tables / 
 * 					tuplas que tienen valores coincidentes en ambas tablas. 
 * 		NATURAL JOIN: Similar to INNER JOIN, automatically identifies fields with same name
 * 
 * JOIN EXTERNA:  
 * 		LEFT (OUTER) JOIN: Returns all records from the left table, and the matched records from the right table / 
 * 					todas la tuplas de la tabla de la izquierda y las tuplas coincidentes de la tabla de la derecha
 * 		RIGHT (OUTER) JOIN: Returns all records from the right table, and the matched records from the left table /
 * 					todas la tuplas de la tabla de la derecha y las tuplas coincidentes de la tabla de la izquierda
 * 		FULL (OUTER) JOIN: Retorna todos las tuplas con una conincidencia en alguna de las tablas
 *  
*/

/* Points to note
 * 
 * Database used for all the examples is from : https://github.com/datacharmer/test_db
 * Please, note that some SELECT can be refactorized, selects here shown are to teach novel users
 * The intention is to show some SELECT examples and sometimes we're not using the best SELECT possible
 * 
 */


-- *******************************************************************************
-- SELECT involving more than one table SQL 1 (SQL-86/87 version)
-- It is recommended this version for novel users
-- *****************************************************************************

use employees; 

-- When we put more than one table in the FROM , the result is the Cartesian Product "Producto Cartesiano"
-- SQL automatically combine all the rows, for exemple, in case of two tables only, the SQL automatically 
-- will combine all the rows from the first table with all the rows of the second table; Table_1 X Table_2

-- Exaples of Cartesian Product

select * from salaries s, titles t; -- result is the combination of both tables

select count(*) from salaries; -- 2.844.047
select count(*) from titles; -- 443.308

select count(*) 
from salaries s, titles t; -- 1.260.788.787.476 +1 Billion 

select * 
from salaries s, titles t; -- 1.260.788.787.476 +1 Billion

select count(*) from dept_emp; -- 331.603
select count(*) from dept_manager; -- 24

select * 
from dept_emp de, dept_manager dm; 

select count(*)
from dept_emp de, dept_manager dm; -- 7.958.472

-- Previous selects could be useless
-- Of course, we're looking for useful result
-- For useful results we will be applying a JOIN 
-- JOIN = CARTESIAN PRODUCT + FILTER 

-- Let's go with some examples of JOIN using SQL-86 ONLY
-- It's recommended to rewrite all the examples using SQL'92


-- The name of the managers:
-- To show this information we have the 'employees' table and the 'dept_managers' table
-- The dept_manager table contains the relation between departments and employees for the managers
-- Therefore, if an employee exists in this table, then he/she is a manager
-- We need information from both tables

-- Proces is always as follows:
-- 1. Tables involved in the process: table1, table2, table3, ... 
-- 2. Information from each table: table1.column1, table1.column2, ... table2.column1, table2.column2, ... table3.column1, table3.column2,... 
-- 3. How tho link the information (Using FKs is key here): table1.column = table2.column AND table2.column = table3.columng AND ...

select e.*, dm.* -- We'll show all the info from each table
from employees e, dept_manager dm -- both tables in the from 
where e.emp_no = dm.emp_no -- How to link the information (a path from first table to last table)
order by dm.dept_no asc; 

-- Previous select is showing too much information, let's try a beautify process

select e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date, dm.to_date 
from employees e, dept_manager dm 
where e.emp_no = dm.emp_no 
order by dm.dept_no asc; -- I'm able to show the name of the managers, I'm not able to identify the dept name

-- and rewrite using SQL'92
select e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date, dm.to_date 
from employees e
inner join dept_manager dm 
on e.emp_no = dm.emp_no 
order by dm.dept_no asc; 

-- let's filter to shown active managers only 
select e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date, dm.to_date 
from employees e
inner join dept_manager dm 
on e.emp_no = dm.emp_no 
where dm.to_date = '9999-01-01' 
order by dm.dept_no asc; -- order by dept_no the double check the query is fine


-- We have a little problem, we do not have the department's name.
-- I've the name of the departments in a third table
-- Let's try to get the department name using the departments table

-- Check for the departments first
select distinct d.dept_name 
from departments d 
order by 1; -- 9 Departments. 

select dm.*, d.*
from dept_manager dm, departments d 
where dm.dept_no = d.dept_no 
order by d.dept_name asc; 

-- All togheter, The department and who is the manager
-- 1. Tables involved in the process: departments d, dept_manager, employees e
-- 2. Information from each table: d.dept_name, e.first_name, e.last_name 
-- 3. How tho link the information (Using FKs is key here): d.dept_no = dm.dept_no, dm.emp_no = e.emp_no 

-- SQL '86
select d.dept_name, e.first_name, e.last_name 
from departments d, dept_manager dm, employees e 
where d.dept_no = dm.dept_no 
and dm.emp_no = e.emp_no 
and dm.to_date = '9999-01-01'
order by d.dept_name asc; -- order by Department's name

-- Using Inner Join 
select d.dept_name, e.first_name, e.last_name 
from departments d
inner join dept_manager dm
	on d.dept_no = dm.dept_no
inner join employees e 
	on e.emp_no = dm.emp_no
and dm.to_date = '9999-01-01'
order by d.dept_name asc;

-- In this case, we can aplly a Natural Join 
select d.dept_name, e.first_name, e.last_name 
from departments d
natural join dept_manager dm
natural join employees e 
where dm.to_date = '9999-01-01'
order by d.dept_name asc;

-- Lets try to show the range of dates for each manager
-- To the previous select we will add more fields
-- This is the way to identify, for each department, their managers during the time 
select d.dept_name, e.first_name, e.last_name, dm.from_date, dm.to_date  
from departments d, dept_manager dm, employees e 
where d.dept_no = dm.dept_no 
and dm.emp_no = e.emp_no 
order by d.dept_name asc, dm.from_date asc; -- all the different managers during the time

-- Using Inner Join
select d.dept_name, e.first_name, e.last_name, dm.from_date, dm.to_date  
from dept_manager dm
inner join employees e 
	on dm.emp_no = e.emp_no
inner join departments d 
	on dm.dept_no = d.dept_no
order by d.dept_name asc, dm.from_date asc; -- all the different managers during the time

-- Same SELECT in a beautiful mode.
-- Current manager only
select d.dept_name as Departamento, concat(e.last_name , ", ", e.first_name) as Manager, dm.from_date as "Desde"
from departments d, dept_manager dm, employees e 
where d.dept_no = dm.dept_no 
and dm.emp_no = e.emp_no 
and dm.to_date = '9999-01-01'
order by 1 asc; -- all the current managers from date

-- Using SQL '92
select d.dept_name as Departamento, concat(e.last_name , ", ", e.first_name) as Manager, dm.from_date as "Desde"
from departments d 
inner join dept_manager dm
	on d.dept_no = dm.dept_no
inner join employees e 
 	on dm.emp_no = e.emp_no 
where dm.to_date = '9999-01-01'
order by 1 asc; -- all the current managers from date


-- Remember the process, it's always the same
-- 1. Tables involved in the process: departments, dpt_emp, employees, etc. 
-- 2. How tho link the information (FKs): departments dept_no, dept_emp dept_no, dept_emp emp_no, employees empt_no, etc.
-- 3. Information from each table: departments: dept_name.dept_emp: from_date.employees: first_name, last_name, etc.


-- Let's try something similar with employees (not managers)
-- I would like to show the employees by department
-- Step-by-step

-- Having a look at dept_emp
select * from dept_emp de; -- emp_no and dept_no

-- Applying the process
-- 1.- Tables involved: employees, dept_emp, departments
-- 2.- How to link the information: employees.emp_no = dept_manager.emp_no, dept_manager.dept_no = departments.dept_no
-- 3.- Information from each table: employees(emp_no, name), dept_manager (from_date), departments(dept_name)

-- SQL'86
select e.emp_no, e.last_name, e.first_name, de.from_date, d.dept_name 
from employees e, dept_emp de, departments d 
where e.emp_no = de.emp_no 
and de.dept_no = d.dept_no 
and de.to_date = '9999-01-01'
order by d.dept_name, e.last_name asc, e.first_name asc;

-- SQL'92 Applying some beautifying process
select concat(e.last_name, ", ", e.first_name), de.from_date, d.dept_name 
from employees e
inner join dept_emp de
	on e.emp_no = de.emp_no 
inner join departments d 
	on de.dept_no = d.dept_no 
where de.to_date = '9999-01-01'
order by d.dept_name, e.last_name asc, e.first_name asc;


-- How many employees for each department?
-- Remembering the "Group By" clause, we can count the employees 
-- We don't aks for the employees name, 
--	therefore we will be using dept_emp and departments tables only

-- First, make the body of the query we will be using later
select d.*, de.* 
from departments d 
natural join dept_emp de
where de.to_date = '9999-01-01'
order by d.dept_name asc; 

-- Second, apply the group by clause
select dept_name, count(*)
from departments d 
natural join dept_emp de
where de.to_date = '9999-01-01' -- active employees only 
group by d.dept_name 
order by d.dept_name asc; 

-- Removing the "where" we can count for the total number of employees 
select dept_name, count(*)
from departments d 
natural join dept_emp de
group by d.dept_name 
order by d.dept_name asc; 

-- Let's play with the DDBB

-- Salaries for each employee
select e.*, s.*
from employees e
natural join salaries s 
order by e.emp_no asc; 

-- The previous query does not consider active employees only.  
-- We want the current salary for each 'active' employee 
-- if the DDBB is coherent, 'active' employees should have a salary to_date = '9999-01-01'

select e.*, s.*
from employees e
natural join salaries s 
where s.to_date = '9999-01-01'
order by e.emp_no asc; 

-- Let's beautify the previous select
select concat(e.last_name, ", ", e.first_name) as Nombre, s.salary  as Salario
from employees e
natural join salaries s 
where s.to_date = '9999-01-01'
order by Salario desc; 

-- Let's play with employees and their salary history

select e.*, s.*
from employees e 
natural join salaries s
order by e.emp_no asc; 

-- We can use the Group By clause
-- we can average out their salaries, max, min, etc. 

select e.emp_no as Empleado, count(*) as Número, max(s.salary) as Máximo, min(s.salary) as Mínimo, avg(s.salary) as Media
from employees e 
natural join salaries s
group by e.emp_no
order by e.emp_no asc; 

-- Same for active employees only?
select e.emp_no as Empleado, count(*) as Número, max(s.salary) as Máximo, min(s.salary) as Mínimo, avg(s.salary) as Media
from employees e 
natural join salaries s
where s.to_date = '9999-01-01'
group by e.emp_no
order by e.emp_no asc; 

-- Employees with salaries above the average of salaries (active employees only)

-- Step by Step

 -- 1.- Calculate the avg of salaries for active employees
select avg(s.salary)  
from salaries s 
where s.to_date = '9999-01-01';

-- 2.- Calculate the avg(salary) for active employees
select e.emp_no as Empleado, avg(s.salary) as Media
from employees e 
natural join salaries s
where s.to_date = '9999-01-01'
group by e.emp_no
order by e.emp_no asc; 

-- 3.- Previous queries combined
select e.emp_no as Empleado, avg(s.salary) as Media
from employees e 
natural join salaries s
where s.to_date = '9999-01-01'
group by e.emp_no
having Media > (select avg(s.salary)  
	from salaries s 
	where s.to_date = '9999-01-01')
order by Media asc; 


-- Let's play with Departments and salaries

-- For each Department, the employees and their salaries (active employees only)
-- Natural Join rejected due to the "from_date" field

-- Step by Step
-- departments, employees and salaries

select d.dept_name, e.first_name, e.last_name, s.salary
from departments d 
inner join dept_emp de 
	on d.dept_no = de.dept_no
inner join employees e 
	on de.emp_no = e.emp_no
inner join salaries s 
	on e.emp_no = s.emp_no
order by e.last_name asc; 

-- Let's try some refinement; active employees only
-- demp_emp has "to-date" field

select d.dept_name as Departamento, concat(e.last_name,", ",e.first_name) as Nombre, s.salary as Salario
from departments d 
inner join dept_emp de 
	on d.dept_no = de.dept_no
inner join employees e 
	on de.emp_no = e.emp_no
inner join salaries s 
	on e.emp_no = s.emp_no
where de.to_date ='9999-01-01'
order by e.last_name asc; 

-- We've duplicates because, for each employee, we have their salary history. 
-- Points to note: the current filter is for active employees only.
-- 	we can refilter for active salaries only, this also means active employees only 

select d.dept_name as Departamento, concat(e.last_name,", ",e.first_name) as Nombre, s.salary as Salario
from departments d 
inner join dept_emp de 
	on d.dept_no = de.dept_no
inner join employees e 
	on de.emp_no = e.emp_no
inner join salaries s 
	on e.emp_no = s.emp_no
where s.to_date ='9999-01-01'
order by e.last_name asc; 

-- We can add some extra fiels to get more information
select d.dept_no, d.dept_name, e.emp_no, concat(e.last_name,", ",e.first_name) as Nombre, e.gender, s.from_date, s.to_date, s.salary
from departments d 
inner join dept_emp de 
	on d.dept_no = de.dept_no
inner join employees e 
	on de.emp_no = e.emp_no
inner join salaries s 
	on e.emp_no = s.emp_no
where s.to_date ='9999-01-01'
order by e.emp_no asc; 

-- And is not working fine, we need to apply the 'active' employees only
select * from dept_emp de where de.emp_no = 10010;

-- previous select is showing two registers, then the final result is two registers
-- Let's fix

select d.dept_no, d.dept_name, e.emp_no, concat(e.last_name,", ",e.first_name) as Nombre, e.gender, s.from_date, s.to_date, s.salary
from departments d 
inner join dept_emp de 
	on d.dept_no = de.dept_no
inner join employees e 
	on de.emp_no = e.emp_no
inner join salaries s 
	on e.emp_no = s.emp_no
where de.to_date = '9999-01-01' -- Active employees only
and s.to_date ='9999-01-01' -- current salary only
order by e.emp_no asc; -- 240124

-- Double check
select count(*)
from dept_emp de 
where de.to_date = '9999-01-01'; -- 240124

--- Now, we've for each department, the employees and their current salaries
-- We can create a View (Virtual table) to apply BI 

create or replace
view employees.current_salary_emp as

select d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name, e.gender, s.from_date, s.to_date, s.salary 
from departments d 
	inner join dept_emp de 
		on d.dept_no = de.dept_no
	inner join employees e 
		on de.emp_no = e.emp_no
	inner join salaries s 
		on e.emp_no = s.emp_no
where de.to_date = '9999-01-01' -- Active employees only
	and s.to_date ='9999-01-01' -- current salary only
order by e.emp_no asc;

-- Checking the view

select * from current_salary_emp cse ; 

-- Some exercises (use the employees.current_salary_emp view)
-- 	Employee with max/min salary 
--	Calculate the total payroll (anual payroll)
--	Calculate the payroll for each department (anual payroll)
--	Most costly department
--  Least costly department

select cse.dept_no, cse.dept_name, sum(cse.salary), avg(cse.salary), max(cse.salary), min(cse.salary)
from current_salary_emp cse 
group by cse.dept_no
order by cse.dept_no asc; 

select cse.gender , sum(cse.salary)
from current_salary_emp cse 
group by cse.gender; 


-- How you already knwo, the employees.current_salary_emp view is about employees only, managers are excluded
-- Some exercises:
--	Create a new view for managers only
-- 	Manager with max/min salary 
--	Calculate the total payroll (anual payroll) for managers
--	Calculate the payroll for each department (anual payroll) for managers
--	Most costly department for managers
--  Least costly department for managers

-- Create a new view with ALL employees (employees + managers)
--	Calculate the total payroll (anual payroll) for all employees
--	Calculate the payroll for each department (anual payroll) for all employees
--	Most costly department for all employees
--  Least costly department for all employees

-- View for current managers with their salaries
create view employees.current_salary_manager as
select d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name, e.gender, s.from_date, s.to_date, s.salary 
from departments d 
    inner join dept_manager dm 
        on d.dept_no = dm.dept_no
    inner join employees e 
        on dm.emp_no = e.emp_no
    inner join salaries s 
        on e.emp_no = s.emp_no
where dm.to_date = '9999-01-01' -- Active managers only
    and s.to_date = '9999-01-01' -- Current salary only
order by e.emp_no asc;


-- Manager with max/min salary
select * from employees.current_salary_manager 
where salary = (select MAX(salary) from employees.current_salary_manager);

select * from employees.current_salary_manager 
where salary = (select MIN(salary) from employees.current_salary_manager);

-- Total payroll for managers (annual)
select SUM(salary) as total_manager_payroll from employees.current_salary_manager;

-- Calculate the payroll for each department (anual payroll) for managers

select dept_no, dept_name, SUM(salary) as dept_manager_payroll
from employees.current_salary_manager
group by dept_no, dept_name 
order by dept_manager_payroll;

-- Most costly department for managers

select dept_no, dept_name, SUM(salary) as dept_manager_payroll
from employees.current_salary_manager
group by dept_no, dept_name 
order by dept_manager_payroll desc
LIMIT 1;

-- Least costly department for managers

select dept_no, dept_name, SUM(salary) as dept_manager_payroll
from employees.current_salary_manager
group by dept_no, dept_name 
order by dept_manager_payroll asc
LIMIT 1;

-- Create a new view with ALL employees (employees + managers)

create or replace view employees.current_salary_all_employees as
select * from employees.current_salary_emp
union
select * from employees.current_salary_manager;

-- Calculate the total payroll (anual payroll) for all employees

select sum(salary) as total_annual_payroll
from employees.current_salary_all_employees;

-- Calculate the payroll for each department (anual payroll) for all employees

select dept_no, dept_name, sum(salary) as dept_annual_payroll
from employees.current_salary_all_employees
group by dept_no, dept_name
order by dept_annual_payroll desc;

-- Most costly department for all employees

select dept_no, dept_name, sum(salary) as dept_annual_payroll
from employees.current_salary_all_employees
group by dept_no, dept_name
order by dept_annual_payroll desc
limit 1;

-- Least costly department for all employees

select dept_no, dept_name, sum(salary) as dept_annual_payroll
from employees.current_salary_all_employees
group by dept_no, dept_name
order by dept_annual_payroll asc
limit 1;



