--PIZZA SALES ANALYSIS PROJECT

CREATE DATABASE PIZZAHUT;
USE PIZZAHUT;
SELECT * FROM PIZZAS;
SELECT * FROM pizza_types;
SELECT * FROM ORDERS;
SELECT * FROM ORDER_DETAILS;

---13 BUSINESS PROBLEMS


--1.Retrieve the total number of orders placed.
SELECT COUNT(ORDER_ID) AS TOTAL_ORDERS FROM ORDERS;

--2.Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE),2) AS TOTAL_SALES
FROM ORDER_DETAILS JOIN PIZZAS
ON PIZZAS.PIZZA_ID = ORDER_DETAILS.PIZZA_ID;

--3.Identify the highest-priced pizza.
SELECT TOP 1 PIZZA_TYPES.NAME,ROUND(PIZZAS.PRICE,2) as price
FROM PIZZA_TYPES
JOIN PIZZAS
ON PIZZAS.PIZZA_TYPE_ID=PIZZA_TYPES.PIZZA_TYPE_ID
ORDER BY PIZZAS.PRICE DESC; 

--4.Identify the most common pizza size ordered.
SELECT TOP 1 PIZZAS.SIZE,COUNT(ORDER_DETAILS.ORDER_DETAILS_ID) AS ORDER_COUNT
FROM PIZZAS
JOIN ORDER_DETAILS
ON PIZZAS.PIZZA_ID=ORDER_DETAILS.PIZZA_ID
GROUP BY PIZZAS.SIZE 
ORDER BY ORDER_COUNT DESC;

--5.List the top 5 most ordered pizza types along with their quantities.
SELECT pizza_types.name,sum(order_details.quantity) as quantity
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name 
order by quantity desc ;

--6.Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category,sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category order by quantity desc;

--7.Determine the distribution of orders by hour of the day.
SELECT DATEPART(HOUR,time) AS hour, 
COUNT(order_id) AS order_count
FROM orders
GROUP BY DATEPART(HOUR,time)
ORDER BY hour;

--8.Join relevant tables to find the category-wise distribution of pizzas.
SELECT CATEGORY, COUNT(NAME) FROM PIZZA_TYPES
GROUP BY CATEGORY;

--9.Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(QUANTITY),0) FROM
(SELECT ORDERS.DATE,SUM(ORDER_DETAILS.QUANTITY) AS QUANTITY
FROM ORDERS JOIN ORDER_DETAILS
ON ORDERS.ORDER_ID=ORDER_DETAILS.ORDER_ID
GROUP BY ORDERS.DATE) AS ORDER_QUANTITY;

--10.Determine the top 3 most ordered pizza types based on revenue.
SELECT TOP 3 PIZZA_TYPES.NAME,SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE
FROM PIZZA_TYPES
JOIN
PIZZAS
ON PIZZAS.PIZZA_TYPE_ID=PIZZA_TYPES.PIZZA_TYPE_ID
JOIN ORDER_DETAILS
ON ORDER_DETAILS.PIZZA_ID=PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.NAME 
ORDER BY REVENUE DESC;

--11.Calculate the percentage contribution of each pizza type to total revenue.
SELECT PIZZA_TYPES.CATEGORY,ROUND(SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) /(SELECT 
ROUND(SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE),2) AS TOTAL_SALES
FROM ORDER_DETAILS
JOIN
PIZZAS
ON PIZZAS.PIZZA_ID=ORDER_DETAILS.PIZZA_ID) * 100,2) AS REVENUE
FROM PIZZA_TYPES JOIN PIZZAS
ON PIZZA_TYPES.PIZZA_TYPE_ID=PIZZAS.PIZZA_TYPE_ID
JOIN ORDER_DETAILS
ON ORDER_DETAILS.PIZZA_ID=PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.CATEGORY
ORDER BY REVENUE DESC;

--12.Analyze the cumulative revenue generated over time.
 SELECT SALES.DATE,
       SUM(SALES.REVENUE) OVER (ORDER BY SALES.DATE) AS CUM_REVENUE
FROM (
    SELECT ORDERS.DATE AS DATE,
           SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE
    FROM ORDER_DETAILS
    JOIN PIZZAS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
    JOIN ORDERS ON ORDERS.ORDER_ID = ORDER_DETAILS.ORDER_ID
    GROUP BY ORDERS.DATE
) AS SALES;


--13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT TOP 3 NAME,REVENUE FROM
(SELECT CATEGORY,NAME,REVENUE,
RANK() OVER(PARTITION BY CATEGORY ORDER BY REVENUE DESC) AS RN
FROM
(SELECT PIZZA_TYPES.CATEGORY, PIZZA_TYPES.NAME,
SUM((ORDER_DETAILS.QUANTITY) * PIZZAS.PRICE) AS REVENUE
FROM PIZZA_TYPES JOIN PIZZAS
ON PIZZA_TYPES.PIZZA_TYPE_ID= PIZZAS.PIZZA_TYPE_ID
JOIN ORDER_DETAILS
ON ORDER_DETAILS.PIZZA_ID=PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.CATEGORY,PIZZA_TYPES.NAME) AS A) AS B
WHERE RN <= 3;

SELECT * FROM PIZZAS;
SELECT * FROM pizza_types;
SELECT * FROM ORDERS;
SELECT * FROM ORDER_DETAILS;