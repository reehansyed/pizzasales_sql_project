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
- ### 1. Retrieve the total number of orders placed.
  ~~~ sql
  SELECT COUNT(ORDER_ID) AS TOTAL_ORDERS FROM ORDERS;
  ~~~
- ### 2. Calculate the total revenue generated from pizza sales.
  ~~~ sql
SELECT ROUND(SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE),2) AS TOTAL_SALES
FROM ORDER_DETAILS JOIN PIZZAS
ON PIZZAS.PIZZA_ID = ORDER_DETAILS.PIZZA_ID;~~~
- ### 3. Identify the highest-priced pizza.
~~~ sql
SELECT TOP 1 PIZZA_TYPES.NAME,ROUND(PIZZAS.PRICE,2) as price
FROM PIZZA_TYPES
JOIN PIZZAS
ON PIZZAS.PIZZA_TYPE_ID=PIZZA_TYPES.PIZZA_TYPE_ID
ORDER BY PIZZAS.PRICE DESC; ~~~



Determine the most common pizza size ordered.
List the top 5 most ordered pizza types along with their quantities.

