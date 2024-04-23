-- Question 1
-- For every employee, get the start date and end date. If end date is not available, mark as NULL
-- INPUT:
EmployeeID	StartDate	EndDate
1	        2023-01-01	2023-06-30
1	        2023-07-01	2023-12-31
2	        2023-04-15	2023-10-15
3	        2023-02-01	NULL
4	        2023-08-01	2024-01-31

-- Create Input
CREATE TABLE EmployeeRecords (
EmployeeID INT, StartDate DATE, EndDate DATE
);

INSERT INTO EmployeeRecords (EmployeeID, StartDate, EndDate)
VALUES
(1, '2023-01-01', '2023-06-30'),
(1, '2023-07-01', '2023-12-31'),
(2, '2023-04-15', '2023-10-15'),
(3, '2023-02-01', NULL),
(4, '2023-08-01', '2024-01-31');

-- OUTPUT:
EmployeeID	startdate	enddate
1	        2023-01-01	2023-12-31
2	        2023-04-15	2023-10-15
3	        2023-02-01	NULL
4	        2023-08-01	2024-01-31

-- Solution:
-- Using Window Function
SELECT DISTINCT EmployeeID,
	FIRST_VALUE(StartDate) OVER(PARTITION BY EmployeeID ORDER BY StartDate) AS StartDate,
	FIRST_VALUE(EndDate) OVER(PARTITION BY EmployeeID ORDER BY EndDate DESC) AS EndDate
FROM EmployeeRecords

-- Using Group By and Aggregations
SELECT 
	EmployeeID,
	MIN(StartDate) AS StartDate,
	MAX(EndDate) AS EndDate
FROM EmployeeRecords
GROUP BY EmployeeID


-- Question 2
-- Rolling Average of Last 3 Months
-- INPUT
user_id | purchase_amount | purchase_date
------- | ---------------- | --------------
1       | 10.00            | 2024-01-10
2       | 20.00            | 2024-02-05
3       | 30.00            | 2024-02-15
1       | 5.00             | 2024-03-01
2       | 15.00            | 2024-03-10

-- OUTPUT
year	month	rolling_avg
2024	1		10.000000
2024	2		30.000000
2024	3		26.666667

-- Create Input
CREATE TABLE purchases (
  user_id INT,
  purchase_amount DECIMAL(10,2),
  purchase_date DATE
);

INSERT INTO purchases (user_id, purchase_amount, purchase_date)
VALUES (1, 10.00, '2024-01-10'),
       (2, 20.00, '2024-02-05'),
       (3, 30.00, '2024-02-15'),
       (1, 5.00, '2024-03-01'),
       (2, 15.00, '2024-03-10');

-- Solution
WITH monthly_revenue AS (
	SELECT
		YEAR(purchase_date) AS year,
        MONTH(purchase_date) AS month,
        SUM(purchase_amount) AS total_revenue
	FROM purchases
    GROUP BY YEAR(purchase_date), MONTH(purchase_date)
)
SELECT
	year,
    month,
    AVG(total_revenue) OVER(
    ORDER BY year, month
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_avg
FROM monthly_revenue
ORDER BY year, month

-- Output
year,   month,  rolling_avg
2024,   1,      10.000000
2024,   2,      30.000000
2024,   3,      26.666667


-- Question 3 (Asked in Dr.Reddy's Staff Augmentation Interview)
-- Find Student with 2nd Highest Mark in each Class
CREATE TABLE School (
    Class VARCHAR(25),
    Student VARCHAR(25),
    Subject VARCHAR(25),
    Marks INT
);

INSERT INTO School (Class, Student, Subject, Marks)
VALUES (1, 'Pratik', 'Maths', 25),
       (1, 'Pratik', 'English', 30),
       (2, 'Pratik', 'Maths', 30),
       (2, 'Pratik', 'Marathi', 40),
       (2, 'Ishika', 'Maths', 45),
       (2, 'Ishika', 'History', 15),
       (1, 'Mansi', 'Maths', 15),
       (1, 'Mansi', 'English', 55),
       (2, 'Mansi', 'Marathi', 10),
       (2, 'Mansi', 'Maths', 30),
       (2, 'Nitin', 'Maths', 20),
       (2, 'Nitin', 'English', 40),
       (1, 'Nitin', 'Maths', 24),
       (1, 'Nitin', 'Hindi', 36);
       
-- Solution
WITH TotalMarks AS (
SELECT
	Class,
	Student,
	SUM(Marks) AS TotalMrks
FROM School
GROUP BY Class, Student
), Ranked AS (
SELECT
	Class,
	Student,
	TotalMrks,
	DENSE_RANK() OVER(PARTITION BY Class ORDER BY TotalMrks DESC) AS RNo
FROM TotalMarks
)
SELECT
	Class,
	Student
FROM Ranked
WHERE RNo = 2

-- Output
Class,  Student
1,      Nitin
2,      Ishika
2,      Nitin


-- Question 3 (Asked in Panasonic Aviations Round 1)
-- Find the number of calls made by Active Users in April 2024
-- Input
CREATE TABLE Users (
  user_id INT,
  date DATE,
  call_id INT
);

CREATE TABLE Subscription (
  user_id INT PRIMARY KEY,
  status VARCHAR(255),
  company VARCHAR(255)
);

INSERT INTO Users (user_id, date, call_id)
VALUES (1, '2024-04-20', 100),
       (1, '2024-04-21', 101),
       (2, '2024-04-22', 102),
       (3, '2024-04-23', 103),
       (4, '2024-04-20', 104),
       (4, '2024-04-22', 105);
       
INSERT INTO Subscription (user_id, status, company)
VALUES (1, 'Active', 'Acme Corp.'),
       (2, 'Free', 'None'),
       (3, 'Inactive', 'Beta Ltd.'),
       (4, 'Active', 'ZZZ Inc.');

-- Output
User_ID,No_Calls
1,      2
4,      2

-- Solution
SELECT
	U.user_id AS User_ID,
    COUNT(U.call_id) AS No_Calls
FROM Users U
INNER JOIN Subscription S
ON U.user_id = S.user_id
WHERE S.status = "Active" AND U.date BETWEEN '2024-04-01' AND '2024-04-30'
GROUP BY U.user_id;