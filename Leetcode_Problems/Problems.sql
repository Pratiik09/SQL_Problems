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