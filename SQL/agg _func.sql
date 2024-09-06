-- SELECT MIN(orderDate) as firstorder_,
-- MAX(orderDate) as Lastorder
-- FROM
-- orders
-- ;

-- SELECT SUM(quantityOrdered)
-- from
-- orderdetails
-- ;

-- SELECT count(distinct productCode)
-- FROM orderdetails;

-- SELECT count(orderNumber)
--  FROM orderdetails;

SELECT COUNT(DISTINCT orderNumber)
FROM orderdetails;