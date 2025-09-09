-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

-- Insert test data
INSERT INTO employees (name, department, salary) VALUES
('Alice', 'IT', 60000),
('Bob', 'Finance', 55000),
('Charlie', 'HR', 50000),
('Diana', 'IT', 70000),
('Eve', 'Finance', 65000),
('Frank', 'HR', 48000),
('Grace', 'Finance', 72000),
('Heidi', 'IT', 82000);

