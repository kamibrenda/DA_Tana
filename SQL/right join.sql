SELECT *
FROM orders ord
RIGHT JOIN classicmodels.customers cust
ON ord.customerNumber = cust.customerNumber
-- WHERE ord.orderNumber IS NULL