-- select AVG(total_payments_to_date)
-- FROM 
-- (SELECT paymentDate, 
-- sum(amount) as total_payments_to_date
-- FROM payments
-- group By paymentDate)A
-- ;

SELECT *
FROM customers cu
INNER JOIN
(SELECT
customerNumber, sum(amount) as total_payments_to_date
FROM
payments
GROUP BY customerNumber)pay
ON cu.customerNumber = pay.customerNumber
;