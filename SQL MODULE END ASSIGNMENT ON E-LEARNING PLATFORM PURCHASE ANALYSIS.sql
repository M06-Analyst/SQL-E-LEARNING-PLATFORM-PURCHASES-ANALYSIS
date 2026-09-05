CREATE database Elearning_platformDB;
USE Elearning_platformDB

table creation learners

CREATE TABLE learners(
learner_id INT PRIMARY KEY AUTO_INCREMENT,
full_name VARCHAR(100) NOT NULL,
country VARCHAR(50) NOT NULL
);

table creation courses

CREATE TABLE courses(
course_id INT PRIMARY KEY AUTO_INCREMENT,
course_name VARCHAR(100) NOT NULL,
category VARCHAR(50) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL
);

table creation purchases

CREATE TABLE purchases(
purchase_id INT PRIMARY KEY AUTO_INCREMENT,
learner_id INT NOT NULL,
course_id INT NOT NULL,
quantity INT NOT NULL CHECK(quantity>0),
purchase_date DATE NOT NULL,
FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
Table data insertion

INSERT INTO learners (full_name,country)
VALUES('john smith','USA'),
('priya sharma','India'),
('Ahmed khan','UAE'),
('Maria Gracia','Spain'),
('David Lee','Singapore');

INSERT INTO courses (course_name,category,unit_price)
VALUES('SQL for Begineers','Database',199.99),
('Python Programming','Programming',299.99),
('Power BI Dashboarding','Data Analytics',249.99),
('Digital Marketing Basics','Marketing',149.99),
('Advance Excel','Productivity',179.99);

INSERT INTO purchases (learner_id,course_id,quantity,purchase_date)
VALUES (1,1,1,'2026-01-10'),
(2,2,1,'2026-01-15'),
(3,3,2,'2026-02-01'),
(1,5,1,'2026-02-10'),
(4,4,3,'2026-03-05'),
(5,2,1,'2026-03-15'),
(2,3,1,'2026-04-08'),
(3,1,2,'2026-04-20')

joins inner

SELECT
 l.full_name AS Learner_Name,
c.course_name AS Course_Name,
c.category,
p.quantity,
(p.quantity * c.unit_price) AS Total_Amount,
p.purchase_date
FROM purchases p
INNER JOIN learners l
ON p.learner_id = l.learner_id
INNER JOIN courses c
ON p.course_id = c.course_id;

joins left

SELECT
l.full_name AS Learner_Name,
c.course_name AS Course_Name,
c.category,
p.quantity,
(p.quantity * c.unit_price) AS Total_Amount,
p.purchase_date
FROM learners l
LEFT JOIN purchases p
ON l.learner_id = p.learner_id
LEFT JOIN courses c
ON p.course_id = c.course_id;

joins right

SELECT
l.full_name AS Learner_Name,
c.course_name AS Course_Name,
c.category,
p.quantity,
(p.quantity * c.unit_price) AS Total_Amount,
p.purchase_date
FROM purchases p
RIGHT JOIN courses c
ON p.course_id = c.course_id
RIGHT JOIN learners l
ON p.learner_id = l.learner_id;

Format currency values to 2 decimal places.
Use aliases for column names (e.g., AS total_revenue).
Sort results appropriately (e.g., highest total_spent first).


SELECT
l.full_name AS Learner_Name,
c.course_name AS Course_Name,
c.category AS Category,
p.quantity AS Quantity,
FORMAT(p.quantity * c.unit_price,2) AS Total_Amount,
p.purchase_date AS Purchase_Date
FROM purchases p
INNER JOIN learners l
ON p.learner_id = l.learner_id
INNER JOIN courses c
ON p.course_id = c.course_id
ORDER BY (p.quantity * c.unit_price) DESC;

Q1.Display each learner’s total spending (quantity × unit_price) along with their country.

SELECT
l.full_name AS Learners_Name,
l.country AS Counrty,
ROUND(SUM(P.quantity * c.unit_price),2) AS Total_Spending
FROM learners l
INNER JOIN purchases p
ON l.learner_id = p.learner_id
INNER JOIN courses c
ON P.course_id = c.course_id
GROUP BY 
l.learner_id,
l.full_name,
l.country
ORDER BY 
Total_spending DESC;

 Q2.Find the top 3 most purchased courses based on total quantity sold.
 
SELECT
c.course_name AS Course_Name,
c.category AS Category,
SUM(p.quantity) AS Total_Quantity_Purchased
FROM courses c
INNER JOIN purchases p
ON c.course_id = p.course_id
GROUP BY 
c.course_id,
c.course_name,
c.category
ORDER BY
Total_Quantity_Purchased DESC LIMIT 3;

Q3.Show each course category’s total revenue and the number of unique learners who purchased from that category.

SELECT
c.category AS Category,
ROUND(SUM(p.quantity * c.unit_price),2) AS Total_Revenue,
COUNT(DISTINCT p.learner_id) AS Unique_Learners
FROM courses c
INNER JOIN purchases p
ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY Total_Revenue DESC;

Q4.List all learners who have purchased courses from more than one category.

SELECT
l.full_name AS Learner_Name,
l.country AS Country,
COUNT(DISTINCT c.category) AS Categories_Purchased
FROM learners l
INNER JOIN purchases p
ON l.learner_id = p.learner_id
INNER JOIN courses c
ON p.course_id = c.course_id
GROUP BY 
l.learner_id,
l.full_name,
l.country
HAVING COUNT(DISTINCT C.category)>1
ORDER BY categories_purchased DESC;

Q5. Identify courses that have not been purchased at all.
SELECT
c.course_id AS Course_id,
c.course_name AS Course_Name,
c.category AS Category,
c.unit_price AS Unit_Price
FROM courses c
LEFT JOIN purchases p
ON c.course_id = p.course_id
WHERE P.purchase_id IS NULL;