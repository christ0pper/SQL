DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employee_Project;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    hire_date DATE,
    salary DECIMAL(10,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE
);

CREATE TABLE Employee_Project (
    emp_id INT,
    project_id INT,
    role VARCHAR(50),
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

INSERT INTO Departments VALUES
(1, 'HR', 'New York'),
(2, 'Finance', 'London'),
(3, 'IT', 'Bangalore'),
(4, 'Marketing', 'Toronto');

INSERT INTO Employees VALUES
(101, 'Alice Johnson', 'F', '2020-03-12', 65000, 3),
(102, 'Bob Smith', 'M', '2019-07-01', 72000, 2),
(103, 'Catherine Green', 'F', '2021-11-15', 54000, 1),
(104, 'Daniel Lee', 'M', '2018-05-23', 89000, 3),
(105, 'Ethan Brown', 'M', '2022-09-09', 50000, 4);

INSERT INTO Projects VALUES
(201, 'AI Chatbot Development', '2023-01-01', '2023-09-30'),
(202, 'Payroll Automation', '2023-03-15', '2023-10-15'),
(203, 'Cloud Migration', '2022-06-10', '2023-03-10');

INSERT INTO Employee_Project VALUES
(101, 201, 'Developer'),
(104, 201, 'Project Lead'),
(102, 202, 'Analyst'),
(103, 202, 'HR Coordinator'),
(105, 203, 'Marketing Assistant');

SELECT e.emp_name, d.dept_name, e.salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

SELECT e.emp_name, p.project_name, ep.role
FROM Employees e
JOIN Employee_Project ep ON e.emp_id = ep.emp_id
JOIN Projects p ON ep.project_id = p.project_id
WHERE ep.role IN ('Developer', 'Project Lead');

SELECT emp_name, salary
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

SELECT dept_name
FROM Departments
WHERE dept_id = (
    SELECT dept_id FROM Employees
    GROUP BY dept_id
    ORDER BY AVG(salary) DESC
    LIMIT 1
);

CREATE VIEW EmployeeSummary AS
SELECT e.emp_name, d.dept_name, e.salary, p.project_name, ep.role
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
JOIN Employee_Project ep ON e.emp_id = ep.emp_id
JOIN Projects p ON ep.project_id = p.project_id;

SELECT * FROM EmployeeSummary;
