-- SELECT paymentDate, 
-- sum(amount)
-- FROM payments
-- group By paymentDate
-- order by paymentDate
-- ;

-- select cus.customerName,
-- MIN(ord.orderDate) AS first_order_date,
-- MAX(ord.orderDate) AS last_order_date
-- from
-- orders ord
-- inner join customers cus
-- ON ord.customerNumber = cus.customerNumber
-- group by cus.customerName

select cus.customerName,
COUNT(DISTINCT orderNumber) as orders_placed
from
orders ord
inner join customers cus
ON ord.customerNumber = cus.customerNumber
group by cus.customerName
ORDER BY orders_placed DESC