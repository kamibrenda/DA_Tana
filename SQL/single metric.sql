  select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   SUM(StockOnHand) as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   StockOnHand > 0
   AND StockTakeFlag = 'Y'
  group by
   Prod.ProductKey,
   inv.StockTxnDate
   ;