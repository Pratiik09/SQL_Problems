### Only Challenging Ones are Listed ###

-- 1393. Capital Gain/Loss --
-- Initial Approach --
WITH BuyT AS (
    SELECT stock_name, SUM(price) AS BP
    FROM Stocks
    WHERE operation = 'Buy'
    GROUP BY stock_name
    ORDER BY 1 ASC
),
SellT AS (
    SELECT stock_name, SUM(price) AS SP
    FROM Stocks
    WHERE operation = 'Sell'
    GROUP BY stock_name
    ORDER BY 1 ASC    
)
SELECT B.stock_name, (SP-BP) AS capital_gain_loss
FROM BuyT B
JOIN SellT S
ON B.stock_name = S.stock_name

-- Optimzed Approach --
SELECT stock_name, SUM(
    CASE 
        WHEN operation = 'Buy' THEN -price
        ELSE price
    END
) AS capital_gain_loss
FROM Stocks
GROUP BY stock_name


-- 176. Second Highest Salary --

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+

-- My Approach --
WITH TempA AS (
    SELECT id, salary,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS DR_S
    FROM Employee
)
SELECT 
CASE
    WHEN MAX(DR_S) = 1 THEN null
    ELSE salary
END AS SecondHighestSalary
FROM TempA
WHERE DR_S = 2

-- Other Approach --
SELECT IFNULL( 
    (SELECT DISTINCT Salary
    FROM Employee
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 1), NULL
) AS SecondHighestSalary


-- 608. Tree Node --

Input: 
Tree table:
+----+------+
| id | p_id |
+----+------+
| 1  | null |
| 2  | 1    |
| 3  | 1    |
| 4  | 2    |
| 5  | 2    |
+----+------+
Output: 
+----+-------+
| id | type  |
+----+-------+
| 1  | Root  |
| 2  | Inner |
| 3  | Leaf  |
| 4  | Leaf  |
| 5  | Leaf  |
+----+-------+

-- My Approach --
SELECT id,
CASE
    WHEN p_id IS NULL THEN 'Root'
    WHEN id IN (SELECT p_id FROM Tree) THEN 'Inner'
    ELSE 'Leaf'
END AS type
FROM Tree

-- 1873. Calculate Special Bonus --
Example 1:

Input: 
Employees table:
+-------------+---------+--------+
| employee_id | name    | salary |
+-------------+---------+--------+
| 2           | Meir    | 3000   |
| 3           | Michael | 3800   |
| 7           | Addilyn | 7400   |
| 8           | Juan    | 6100   |
| 9           | Kannon  | 7700   |
+-------------+---------+--------+
Output: 
+-------------+-------+
| employee_id | bonus |
+-------------+-------+
| 2           | 0     |
| 3           | 0     |
| 7           | 7400  |
| 8           | 0     |
| 9           | 7700  |
+-------------+-------+
Explanation: 
The employees with IDs 2 and 8 get 0 bonus because they have an even employee_id.
The employee with ID 3 gets 0 bonus because their name starts with 'M'.
The rest of the employees get a 100% bonus.

-- Solution: --
-- My Approach --
SELECT employee_id,
CASE
WHEN employee_id % 2 != 0 AND name NOT LIKE 'M%' THEN salary
ELSE 0
END AS bonus
FROM Employees
ORDER BY employee_id

-- Other Approach --
SELECT  employee_id, 
    salary * ( employee_id % 2 ) * ( name NOT LIKE 'M%') AS bonus
FROM Employees
ORDER BY employee_id


-- 627. Swap Salary --
Swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa)

Example 1:

Input: 
Salary table:
+----+------+-----+--------+
| id | name | sex | salary |
+----+------+-----+--------+
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |
+----+------+-----+--------+
Output: 
+----+------+-----+--------+
| id | name | sex | salary |
+----+------+-----+--------+
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |
+----+------+-----+--------+
Explanation: 
(1, A) and (3, C) were changed from 'm' to 'f'.
(2, B) and (4, D) were changed from 'f' to 'm'.

-- My Approach --
UPDATE Salary
SET sex = CASE 
            WHEN sex = 'm' THEN 'f'
            ELSE 'm'
          END

-- Other Approach --
UPDATE Salary
SET sex = IF(sex='f','m','f')


-- 196. Delete Duplicate Emails --
Example 1:

Input: 
Person table:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Output: 
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.

-- My Approach --
DELETE FROM Person
WHERE id IN (
    SELECT id
    FROM (
        SELECT id, email,
            ROW_NUMBER() OVER(PARTITION BY email ORDER BY id) AS RN
        FROM Person
    ) AS TEMPA WHERE RN > 1
)

-- Other Approach --
-- Oracle, Didn't work on MySQL --
DELETE FROM Person
WHERE (email, id) NOT IN (
    SELECT email, MIN(id)
    FROM Person
    GROUP BY email
)

