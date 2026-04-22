CREATE DATABASE IF NOT EXISTS sales_db;
USE sales_db;

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- customers – khách hàng
-- employees – nhân viên
-- products – sản phẩm
-- orders – đơn hàng
-- order_details – chi tiết đơn hàng
-- departments – phòng ban

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary DECIMAL(10,2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO departments VALUES
(1, 'Sales'),
(2, 'IT'),
(3, 'HR');

INSERT INTO employees VALUES
(1, 'An', 1200, 1),
(2, 'Binh', 1500, 1),
(3, 'Cuong', 2000, 2),
(4, 'Dung', 1800, 2),
(5, 'Hanh', 1300, 3);

INSERT INTO customers VALUES
(1, 'Nguyen Van A', 'Ha Noi'),
(2, 'Tran Thi B', 'Da Nang'),
(3, 'Le Van C', 'Ho Chi Minh'),
(4, 'Pham Thi D', 'Ha Noi');

INSERT INTO products VALUES
(1, 'Laptop A', 'Laptop', 1000, 10),
(2, 'Mouse B', 'Accessory', 20, 100),
(3, 'Keyboard C', 'Accessory', 30, 80),
(4, 'Monitor D', 'Monitor', 200, 20),
(5, 'Laptop E', 'Laptop', 1500, 5);

INSERT INTO orders VALUES
(1, 1, 1, '2025-01-10', 1040),
(2, 2, 2, '2025-01-15', 220),
(3, 1, 2, '2025-02-01', 1500),
(4, 3, 3, '2025-02-05', 60),
(5, 4, 1, '2025-02-10', 200);

INSERT INTO order_details VALUES
(1, 1, 1, 1000),
(1, 2, 2, 20),
(2, 4, 1, 200),
(2, 2, 1, 20),
(3, 5, 1, 1500),
(4, 3, 2, 30),
(5, 4, 1, 200);

-- Sản phẩm giá lớn hơn trung bình
SELECT product_name, price FROM products
WHERE price > (
	SELECT AVG(price) FROM products
);
-- Khách hàng đã từng đặt hàng 
SELECT customer_id, customer_name FROM customers
WHERE customer_id IN (
	SELECT customer_id FROM orders
);
-- Nhân viên lương cao hơn trung bình công ty
SELECT employee_name, salary FROM employees
WHERE salary > (
	SELECT AVG(salary) FROM employees
); 
-- Nhân viên lương cao hơn trung bình phòng ban
SELECT e.employee_id, e.employee_name FROM employees AS e
WHERE e.salary > (
	SELECT AVG(e2.salary)
    FROM employees AS e2
    WHERE e2.department_id = e.department_id);
-- Khách hàng có chi tiêu trên mức trung bình (lồng 2 cấp)
SELECT customer_id, SUM(total_amount) AS total FROM orders AS o1
GROUP BY customer_id
HAVING total > (
	 SELECT AVG(customer_total) 
    FROM (
        SELECT SUM(total_amount) AS customer_total 
        FROM orders 
        GROUP BY customer_id
    ) AS subquery
);