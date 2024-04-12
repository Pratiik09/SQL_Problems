-- INPUT:
EmployeeID	StartDate	EndDate
1	        2023-01-01	2023-06-30
1	        2023-07-01	2023-12-31
2	        2023-04-15	2023-10-15
3	        2023-02-01	NULL
4	        2023-08-01	2024-01-31

-- OUTPUT:
EmployeeID	startdate	enddate
1	        2023-01-01	2023-12-31
2	        2023-04-15	2023-10-15
3	        2023-02-01	NULL
4	        2023-08-01	2024-01-31

-- For every employee, get the start date and end date. If end date is not available, mark as NULL

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
