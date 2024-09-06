   SELECT
   ProductKey,
   StockTxnDate,									-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   count(StockStatus) as StockStatusCount,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
 FROM
(Select
   prod.ProductKey,
   StockTxnDate,
   case 
   when StockOnHand >= prod.ReorderPoint then 'Stock level Ok'
   when StockOnHand = 0 AND BackOrderQty > 0 then 'Out of Stock - Back Ordered'
   when (StockOnHand < prod.ReorderPoint) AND BackOrderQty > 0 then 'Low Stock - Back Ordered'
   when BackOrderQty = 0 AND (StockOnHand <= prod.ReorderPoint) then 'Reorder Now'
   end as StockStatus
from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
where 
StockOnHand > 0 
and StockTakeFlag = 'Y'
) as dtStockStatus
Group by 
   ProductKey,
   StockStatus,
   StockTxnDate   

