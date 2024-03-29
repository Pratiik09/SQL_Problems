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

-- 1667. Fix Names in a Table --
Example 1:

Input: 
Users table:
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | aLice |
| 2       | bOB   |
+---------+-------+
Output: 
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | Alice |
| 2       | Bob   |
+---------+-------+

-- My Approach --
SELECT user_id, CONCAT( UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2, LENGTH(name))) ) AS name
FROM Users
ORDER BY user_id

-- 1484. Group Sold Products By The Date --
Input: 
Activities table:
+------------+------------+
| sell_date  | product     |
+------------+------------+
| 2020-05-30 | Headphone  |
| 2020-06-01 | Pencil     |
| 2020-06-02 | Mask       |
| 2020-05-30 | Basketball |
| 2020-06-01 | Bible      |
| 2020-06-02 | Mask       |
| 2020-05-30 | T-Shirt    |
+------------+------------+
Output: 
+------------+----------+------------------------------+
| sell_date  | num_sold | products                     |
+------------+----------+------------------------------+
| 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |
+------------+----------+------------------------------+
Explanation: 
For 2020-05-30, Sold items were (Headphone, Basketball, T-shirt), we sort them lexicographically and separate them by a comma.
For 2020-06-01, Sold items were (Pencil, Bible), we sort them lexicographically and separate them by a comma.
For 2020-06-02, the Sold item is (Mask), we just return it.

-- My Approach after Help --
SELECT 
    sell_date, COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product ASC SEPARATOR ",") AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date ASC

--  1527. Patients With a Condition --
Input: 
Patients table:
+------------+--------------+--------------+
| patient_id | patient_name | conditions   |
+------------+--------------+--------------+
| 1          | Daniel       | YFEV COUGH   |
| 2          | Alice        |              |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |
| 5          | Alain        | DIAB201      |
+------------+--------------+--------------+
Output: 
+------------+--------------+--------------+
| patient_id | patient_name | conditions   |
+------------+--------------+--------------+
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 | 
+------------+--------------+--------------+
Explanation: Bob and George both have a condition that starts with DIAB1.

-- With REGEXP --
SELECT *
FROM Patients
WHERE conditions REGEXP '\\bDIAB1'


-- 1965. Employees With Missing Information --
Input: 
Employees table:
+-------------+----------+
| employee_id | name     |
+-------------+----------+
| 2           | Crew     |
| 4           | Haven    |
| 5           | Kristian |
+-------------+----------+
Salaries table:
+-------------+--------+
| employee_id | salary |
+-------------+--------+
| 5           | 76071  |
| 1           | 22517  |
| 4           | 63539  |
+-------------+--------+
Output: 
+-------------+
| employee_id |
+-------------+
| 1           |
| 2           |
+-------------+
Explanation: 
Employees 1, 2, 4, and 5 are working at this company.
The name of employee 1 is missing.
The salary of employee 2 is missing.

-- My Approach --
WITH INTERSECTT AS (
    SELECT employee_id
    FROM Employees
    WHERE employee_id IN (
        SELECT employee_id
        FROM Salaries )
), UNIONT AS (
    SELECT employee_id
    FROM Employees
    UNION
    SELECT employee_id
    FROM Salaries
)
SELECT employee_id
FROM UNIONT
WHERE employee_id NOT IN (
    SELECT employee_id
    FROM INTERSECTT
)
ORDER BY 1 


-- 1795. Rearrange Products Table --
Input: 
Products table:
+------------+--------+--------+--------+
| product_id | store1 | store2 | store3 |
+------------+--------+--------+--------+
| 0          | 95     | 100    | 105    |
| 1          | 70     | null   | 80     |
+------------+--------+--------+--------+
Output: 
+------------+--------+-------+
| product_id | store  | price |
+------------+--------+-------+
| 0          | store1 | 95    |
| 0          | store2 | 100   |
| 0          | store3 | 105   |
| 1          | store1 | 70    |
| 1          | store3 | 80    |
+------------+--------+-------+
Explanation: 
Product 0 is available in all three stores with prices 95, 100, and 105 respectively.
Product 1 is available in store1 with price 70 and store3 with price 80. The product is not available in store2.

-- My Approach after Help --
SELECT 
    product_id,
    'store1' AS store,
    store1 AS price
FROM Products
WHERE store1 IS NOT NULL

UNION 

SELECT 
    product_id,
    'store2' AS store,
    store2 AS price
FROM Products
WHERE store2 IS NOT NULL

UNION

SELECT 
    product_id,
    'store3' AS store,
    store3 AS price
FROM Products
WHERE store3 IS NOT NULL

-- 197. Rising Temperature --
Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).

-- My Approach -- (Efficient)
WITH LAGT AS (
    SELECT
        id, recordDate, temperature,
        LAG(temperature) OVER( ORDER BY recordDate ASC ) AS PrevDayTemp,
        LAG(recordDate) OVER( ORDER BY recordDate ASC ) AS PrevDate
    FROM Weather
)
SELECT id
FROM LAGT
WHERE temperature > PrevDayTemp AND
DATEDIFF(recordDate, PrevDate) = 1

-- Other Approach -- (Not Efficient)
SELECT CUR.id AS id
FROM Weather CUR, Weather PREV  -- , (comma) means Cross Join
WHERE DATEDIFF(CUR.recordDate, PREV.recordDate) = 1 AND
CUR.temperature > PREV.temperature


-- 607. Sales Person --
-- My Approach After Help --
SELECT name
FROM SalesPerson
WHERE sales_id NOT IN (
    SELECT
        sales_id
    FROM Orders O
    LEFT JOIN Company C
    ON O.com_id = C.com_id
    WHERE C.name = "RED"
)


-- 1141. User Activity for the Past 30 Days I --
-- My Approach --
SELECT
    activity_date AS day,
    -- GROUP_CONCAT(user_id ORDER BY user_id),
    COUNT(DISTINCT user_id) AS active_users 
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date
ORDER BY activity_date


-- 1407. Top Travellers --
Input: 
Users table:
+------+-----------+
| id   | name      |
+------+-----------+
| 1    | Alice     |
| 2    | Bob       |
| 3    | Alex      |
| 4    | Donald    |
| 7    | Lee       |
| 13   | Jonathan  |
| 19   | Elvis     |
+------+-----------+
Rides table:
+------+----------+----------+
| id   | user_id  | distance |
+------+----------+----------+
| 1    | 1        | 120      |
| 2    | 2        | 317      |
| 3    | 3        | 222      |
| 4    | 7        | 100      |
| 5    | 13       | 312      |
| 6    | 19       | 50       |
| 7    | 7        | 120      |
| 8    | 19       | 400      |
| 9    | 7        | 230      |
+------+----------+----------+
Output: 
+----------+--------------------+
| name     | travelled_distance |
+----------+--------------------+
| Elvis    | 450                |
| Lee      | 450                |
| Bob      | 317                |
| Jonathan | 312                |
| Alex     | 222                |
| Alice    | 120                |
| Donald   | 0                  |
+----------+--------------------+
Explanation: 
Elvis and Lee traveled 450 miles, Elvis is the top traveler as his name is alphabetically smaller than Lee.
Bob, Jonathan, Alex, and Alice have only one ride and we just order them by the total distances of the ride.
Donald did not have any rides, the distance traveled by him is 0.

-- My Approach --
SELECT
    U.name name,
    IFNULL( SUM(R.distance), 0) travelled_distance
FROM Users U
LEFT JOIN Rides R
ON R.user_id = U.id
GROUP BY U.id
ORDER BY travelled_distance DESC, U.name ASC


-- 1158. Market Analysis I --
-- Que: Find for each user, the join date and the number of orders they made as a buyer in 2019 --
-- My Approach --
SELECT
    U.user_id buyer_id,
    U.join_date join_date,
    COUNT(
        CASE
            WHEN EXTRACT(YEAR FROM order_date) = '2019' THEN 1
            ELSE NULL
        END
    ) orders_in_2019
FROM Users U
LEFT JOIN Orders O
ON U.user_id = O.buyer_id
GROUP BY 1, 2

-- 1.Other Approach --
SELECT
    U.user_id buyer_id,
    U.join_date join_date,
    COUNT(order_date) orders_in_2019
FROM Users U
LEFT JOIN Orders O
ON U.user_id = O.buyer_id
AND EXTRACT(YEAR FROM order_date) = '2019'
GROUP BY 1, 2


-- 2.Other Approach --
SELECT
    U.user_id buyer_id,
    U.join_date join_date,
    COUNT(order_date) orders_in_2019
FROM Users U
LEFT JOIN (
    SELECT *
    FROM Orders
    WHERE EXTRACT(YEAR FROM order_date) = '2019'
) O
ON U.user_id = O.buyer_id
GROUP BY 1, 2

### NOTE ###
-- WHERE: Filter happens after the join
-- ON with AND: Filter happens on specified table during the join, it is similar to using subquery to filter data before joining
### 1.Other Approach and 2.Other Approach are same, but 1.Other Approach is more efficient --