   select
   Prod.ProductKey,
   StockTxnDate,
   0 as SOHQty,					-- Stock Take is end of each month
   SUM(BackOrderQty) as BOQQty,
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
   BackOrderQty > 0
   AND StockTakeFlag = 'Y'
  group by
   Prod.ProductKey,
   StockTxnDate

   UNION ALL 

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

   UNION ALL

    SELECT
   ProductKey,
   StockTxnDate,									-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   StockStatus,
   count(StockStatus) as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
from
(
 select
	prod.ProductKey,
	StockTxnDate,
	case
		when StockOnHand>=prod.ReorderPoint then 'Stock Level OK'
		when StockOnHand=0 and BackOrderQty>0 then 'Out of Stock - Back Ordered'
		when (StockOnHand < prod.ReorderPoint) and BackOrderQty>0 then 'Low Stock - Back Ordered'
		when BackOrderQty=0 and (StockOnHand<= Prod.ReorderPoint) then 'Reorder Now'
	end as StockStatus
 from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
 where
  StockOnHand>0 and
  StockTakeFlag='Y' ) as dtStockStatus
 group by
   ProductKey,
   StockStatus,
   StockTxnDate

   UNION ALL

      SELECT
   ProductKey,
   StockTxnDate,									-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   BackorderStatus,
   count(BackorderStatus) as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
 FROM
 (
  select
	prod.ProductKey,
	StockTxnDate,
	case
		when BackOrderQty >0 and BackOrderQty <=10 then 'Up to 10 on order'
		when BackOrderQty >10 and BackOrderQty <=20 then 'Up to 20 on order'
		when BackOrderQty >20 and BackOrderQty <=40 then 'Up to 40 on order'
		when BackOrderQty >40 and BackOrderQty <=60 then 'Up to 60 on order'
	else
		'+ 60 on order'
	end as BackorderStatus
  from
	Product prod inner join
	ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
    ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where
	BackOrderQty > 0 and
    StockTakeFlag='Y'
	)as dtBackOrderStatus
	Group by 
	ProductKey,
	BackorderStatus,
	StockTxnDate

	UNION ALL

	select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   sum(StockOnHand*UnitCost) as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   StockOnHand>0 and
   StockTakeFlag='Y'
  group by
   prod.productkey,
   StockTxnDate

   UNION ALL

     select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   sum(BackOrderQty * ListPrice) as LostSalesValue,   --sales value 
   0 as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   BackOrderQty>0 and
   StockOnHand=0 and
   StockTakeFlag='Y'
  group by
   prod.ProductKey,
   StockTxnDate

   UNION ALL

     select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   sum(StockOnHand-MaxStockLevel) as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   StockOnHand>MaxStockLevel and
   StockTakeFlag ='Y'
  group by
   prod.ProductKey,
   StockTxnDate

   UNION ALL

     select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   sum((StockOnHand-MaxStockLevel) * UnitCost ) as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   StockOnHand>MaxStockLevel and
   StockTakeFlag='Y'
  group by
	prod.ProductKey,
	StockTxnDate