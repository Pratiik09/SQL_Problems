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