Select
  ProductKey,											
  OrderDate,
  City as City,
  StateProvinceName as State,
  CountryRegionName as Country,
  SUM(SalesAmount) as tcSalesValue,									
  SUM(TotalProductCost) as tcProductCost,									
  SUM(TaxAmt)	as tcSalesTax,										
  SUM(Freight)as tcTransportCost,									
  COUNT(DISTINCT(SalesOrderNumber)) as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
  OnlineSales os
  INNER JOIN Customer cus
  ON os.CustomerKey = cus.CustomerKey
  left join
 GeoLocation geo on cus.GeographyKey = geo.GeographyKey
where	
  YEAR(OrderDate) between 2017 AND 2019
group by
    ProductKey,											
  OrderDate, geo.City, geo.StateProvinceName, geo.CountryRegionName
  UNION  ALL
  Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  ovOrderCount,									
  ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
 (
 select
	OrderDate,
	count(distinct [SalesOrderNumber]) as ovOrderCount,
	sum(count(distinct SalesOrderNumber)) over (Order By OrderDate) as ovRunningOrderCount
 from
	OnlineSales
 where
	year(OrderDate) between 2017 and 2019
 group by
	OrderDate
 ) dt
 UNION ALL
Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  ovSalesValue,									
  ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
(
select																						
  OrderDate,
  sum(SalesAmount) as ovSalesValue,
  sum(sum(SalesAmount)) over (Order By OrderDate) as ovRunningSalesTotal
from
  OnlineSales
where
  year(OrderDate) between 2017 and 2019
group by
  OrderDate
) dt