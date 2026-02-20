SELECT customer_id,
COUNT(*) AS TotalOrders,
SUM(sales) AS TotalSales,
AVG(sales) AS AvgSales,
MIN(sales) AS LowestSales,
MAX(sales) AS HighestSales
From orders
GROUP BY customer_id

/*
1	1	35	35	35	35
2	1	15	15	15	15
3	1	20	20	20	20
6	1	10	10	10	10
*/