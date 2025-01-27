create database pizzaSales;

CREATE TABLE orders (
    orderID INT NOT NULL PRIMARY KEY,
    orderDate DATE NOT NULL,
    orderTime TIME NOT NULL
);

CREATE TABLE orderDetails (
    orderDetailsId INT NOT NULL,
    orderId INT NOT NULL,
    pizzaId TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (orderDetailsId)
);

-- -----------------------------------------------------------BASIC TASK--------------------------------------------------------------------
-- Retrieve the total number of orders placed.

select count(orderID) from orders;  

-- Calculate the total revenue generated from pizza sales.

SELECT 
    (SUM(quantity * price))
FROM
    orderdetails AS oD
        JOIN
    pizzas AS pZ ON oD.pizzaId = pZ.pizza_id; 

-- Identify the highest-priced pizza.

SELECT 
    MAX(price)
FROM
    pizzas; 
        -- ----OR---- 
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC;
    
-- Identify the most common pizza size ordered.


select P.size , count(OD.orderDetailsId) as orderCount
from orderdetails as OD
join
pizzas as P
on OD.pizzaId = p.pizza_id
group by P.size
order by orderCount desc;

--  List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name,
    SUM(orderdetails.quantity) AS totalQuantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orderdetails ON orderdetails.pizzaId = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY totalQuantity DESC;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

 
SELECT 
    pizza_types.category,
    SUM(orderdetails.quantity) AS totalQuantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orderdetails ON orderdetails.pizzaId = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY totalQuantity DESC;

-- Determine the distribution of orders by hour of the day.

select hour(orderTime) , count(orderID) from orders
group by hour(orderTime); 

-- Join relevant tables to find the category-wise distribution of pizzas.	

select pizza_types.category,count(name) from pizza_types
group by pizza_types.category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(quantity)) as Average  from 
(select orders.orderDate , count(orderdetails.quantity) as quantity 
from orders join orderdetails
on orders.orderId = orderdetails.orderId
group by orderDate) as orderQuantity;
 

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name , sum(orderdetails.quantity * pizzas.price) as Revenu
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orderdetails
on orderDetails.pizzaId = pizzas.pizza_id
group by pizza_types.name
order by Revenu desc limit 3;
 


