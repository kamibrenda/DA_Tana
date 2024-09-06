SELECT *
FROM 
netflix_titles
LEFT JOIN 	show_director
ON netflix_titles.show_id = show_director.show_id
LEFT JOIN directors
ON directors.Director_ID = show_director.Director_Id

SELECT *
FROM classicmodels.customers cust
LEFT JOIN orders ord
ON cust.customerNumber = ord.customerNumber
WHERE ord.orderNumber IS NULL

SELECT *
FROM classicmodels.customers cust
LEFT JOIN orders ord
ON cust.customerNumber = ord.customerNumber
WHERE ord.orderNumber IS NOT NULL 