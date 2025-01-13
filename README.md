# Pizza sales Data Analysis using SQL
![pizza_image](https://cdn.mavenanalytics.io/public/profile/c861d330-0041-701c-3520-ca1989a3cbcc/projects/1.jpg)
## Project Overview
This project focuses on analyzing pizza sales data using SQL to uncover insights into sales trends, customer preferences, and performance metrics. The analysis addresses specific questions at basic, intermediate, and advanced levels of complexity. The data was imported into SQL Server for querying and analysis.
## objectives
- Analyze pizza sales data to calculate total orders and revenue generated.  
- Identify popular pizza types, sizes, and their contribution to total sales.  
- Examine order patterns by time of day and date to understand customer behavior.  
- Perform category-wise analysis of pizza sales and revenue distribution.  
- Derive advanced insights, such as top revenue-generating pizza types and cumulative revenue trends, to support strategic decision-making.  
## Datasets Used
The project utilizes the following datasets:
- **`order_details.csv`**: Contains detailed information about each order, including pizza type and quantity.  
- **`orders.csv`**: Includes metadata about orders, such as order ID, date, and time.  
- **`pizza_types.csv`**: Provides details about different pizza types, including their categories and descriptions.  
- **`pizzas.csv`**: Contains information about pizza sizes and prices.
- ## Business Problems and Solutions
### 1. Retrieve the total number of orders placed.
~~~ sql
SELECT COUNT(ORDER_ID) AS TOTAL_ORDERS FROM ORDERS;
~~~

### 2. Calculate the total revenue generated from pizza sales.
~~~ sql
SELECT ROUND(SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE),2) AS TOTAL_SALES
FROM ORDER_DETAILS JOIN PIZZAS
ON PIZZAS.PIZZA_ID = ORDER_DETAILS.PIZZA_ID;
~~~

### 3. Identify the highest-priced pizza.
~~~ sql
SELECT TOP 1 PIZZA_TYPES.NAME,ROUND(PIZZAS.PRICE,2) as price
FROM PIZZA_TYPES
JOIN PIZZAS
ON PIZZAS.PIZZA_TYPE_ID=PIZZA_TYPES.PIZZA_TYPE_ID
ORDER BY PIZZAS.PRICE DESC;
~~~

### 4. Identify the most common pizza size ordered.
~~~ sql
SELECT TOP 1 PIZZAS.SIZE,COUNT(ORDER_DETAILS.ORDER_DETAILS_ID) AS ORDER_COUNT
FROM PIZZAS
JOIN ORDER_DETAILS
ON PIZZAS.PIZZA_ID=ORDER_DETAILS.PIZZA_ID
GROUP BY PIZZAS.SIZE 
ORDER BY ORDER_COUNT DESC;
~~~

### 5. List the top 5 most ordered pizza types along with their quantities.
~~~ sql
SELECT pizza_types.name,sum(order_details.quantity) as quantity
FROM pizza_types
JOIN pizzas
ON pizza_types.pizza_type_id=pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name 
ORDER BY quantity desc;
~~~

### 6. Join the necessary tables to find the total quantity of each pizza category ordered.
~~~ sql
SELECT pizza_types.category,sum(order_details.quantity) as quantity
FROM pizza_types 
JOIN pizzas
ON pizza_types.pizza_type_id=pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id=pizzas.pizza_id
GROUP BY pizza_types.category 
ORDER BY quantity desc;
~~~

### 7. Determine the distribution of orders by hour of the day.
~~~ sql
SELECT DATEPART(HOUR,time) AS hour, 
COUNT(order_id) AS order_count
FROM orders
GROUP BY DATEPART(HOUR,time)
ORDER BY hour;
~~~

### 8. Join relevant tables to find the category-wise distribution of pizzas.
~~~ sql
SELECT CATEGORY, COUNT(NAME) 
FROM PIZZA_TYPES
GROUP BY CATEGORY;
~~~

### 9. Group the orders by date and calculate the average number of pizzas ordered per day.
~~~ sql
SELECT ROUND(AVG(QUANTITY),0) 
FROM
(SELECT ORDERS.DATE,SUM(ORDER_DETAILS.QUANTITY) AS QUANTITY
FROM ORDERS JOIN ORDER_DETAILS
ON ORDERS.ORDER_ID=ORDER_DETAILS.ORDER_ID
GROUP BY ORDERS.DATE) AS ORDER_QUANTITY;
~~~

### 10. Determine the top 3 most ordered pizza types based on revenue.
~~~ sql
SELECT TOP 3 PIZZA_TYPES.NAME,SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE
FROM PIZZA_TYPES
JOIN PIZZAS
ON PIZZAS.PIZZA_TYPE_ID=PIZZA_TYPES.PIZZA_TYPE_ID
JOIN ORDER_DETAILS
ON ORDER_DETAILS.PIZZA_ID=PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.NAME 
ORDER BY REVENUE DESC;
~~~

### 11. Calculate the percentage contribution of each pizza type to total revenue.
~~~ sql
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
~~~

### 12. Analyze the cumulative revenue generated over time.
~~~ sql
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
~~~

### 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
~~~ sql
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
~~~




