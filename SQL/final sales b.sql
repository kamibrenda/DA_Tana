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

union all 

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
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  lagSalesGrowthIn$,								 
  lagSalesGrowthInPercent,							
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
    MonthStartDate as OrderDate,											-- Dimension on Chart as Year/Month only hence use Calendar table to achieve this
	sum(SalesAmount) as SalesValue,
	lag(sum(SalesAmount),1) Over (Order By MonthStartDate)  as PreviousYearMonthSales,
	sum(SalesAmount) - lag(sum(SalesAmount),1) Over (Order By MonthStartDate) as lagSalesGrowthIn$,
	100 * (
			(sum(SalesAmount) - lag(sum(SalesAmount),1) Over (Order By MonthStartDate)) /
			lag(sum(SalesAmount),1) Over (Order By MonthStartDate)
		   )
		  as lagSalesGrowthInPercent
from 
	OnlineSales os inner join
	Calendar cal on os.OrderDate = cal.DisplayDate
where
	year(OrderDate) between 2017 and 2019
group by 
    MonthStartDate
) dt
union all
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
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  lagFreightGrowthIn$,								
  lagFreightGrowthInPercent,						
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
    WeekStartDate as OrderDate,											
	sum(Freight) as TransportValue,
	lag(sum(Freight),1) Over (Order By WeekStartDate)  as PreviousYearWeekFreight,
	sum(Freight) - lag(sum(Freight),1) Over (Order By WeekStartDate) as lagFreightGrowthIn$,
	100 * (
			(sum(Freight) - lag(sum(Freight),1) Over (Order By WeekStartDate)) /
			lag(sum(Freight),1) Over (Order By WeekStartDate)
		   )
		  as lagFreightGrowthInPercent
from 
	OnlineSales os inner join
	Calendar cal on os.OrderDate = cal.DisplayDate
where
	year(OrderDate) between 2017 and 2019
group by 
    WeekStartDate
) dt

union all
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
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  mvSalesValue,											 
  mvAvgSales,
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
	mvSalesValue,
	avg(mvSalesValue) over (Order By OrderDate rows between 30 preceding and current row ) as mvAvgSales
	from
(
select											
	OrderDate,
	sum(SalesAmount) as mvSalesValue
from
	OnlineSales  
where
	year(OrderDate) between 2017 and 2019
group by 
	OrderDate
) dt
) dtMvAvgSales

union all

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
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  mvOrderCount,
  mvAvgOrders,
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
	mvOrderCount,
	avg(mvOrderCount) Over (Order by OrderDate rows between 30 preceding and current row) as mvAvgOrders
from
(
select											
	OrderDate,
	count(distinct SalesOrderNumber) as mvOrderCount
from
	OnlineSales 
where
	year(OrderDate) between 2017 and 2019
group by 
	OrderDate
) dt
) dtMvAvagOrders

UNION ALL

Select
  ProductKey,											
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
  xjSaleTypeName,									 
  xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
(
   select
    prod.ProductKey,
	st.SaleTypeName as xjSaleTypeName,
	case
  	  when SalesValue > 0 then 'Had Sale(s)'
	  when SalesValue is null then 'No Sale'
	 end as xjSaleStatus,
	'2019-12-31' as OrderDate
   from
	SaleType st cross join
	Product prod left join
    (
	select
		SaleTypeKey,
		ProductKey,
		sum(SalesAmount) as SalesValue
	from
		OnlineSales
	where
		year(OrderDate) between 2017 and 2019 
	group by
		SaleTypeKey,
		ProductKey
    ) as SaleTypeSales on SaleTypeSales.SaleTypeKey = st.SaleTypeKey and
						  SaleTypeSales.ProductKey = prod.ProductKey

   Where
    prod.ProductKey>0
) dt

union all 

Select
  ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
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
  xjGeoSaleStatus,
  count(xjGeoSaleStatus) as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
   (
  	select
	  distinct(prod.ProductKey),
	  geo.CountryRegionName as Country,
	case
  	  when SalesValue > 0 then 'Had Sale(s)'
	  when SalesValue is null then 'No Sale'
	 end as xjGeoSaleStatus,
	 '2019-12-31' as OrderDate
	from
	  GeoLocation geo cross join					-- >> Card: 616
	  Product prod 	left join						-- >> Card: 606				: 616 X 606 = Cartesian Product 373,296 rows	
	(
	   select
			 cus.GeographyKey
			,ProductKey
			,sum(SalesAmount) as SalesValue	
		from
			OnlineSales os inner join
			Customer cus on os.CustomerKey = cus.CustomerKey
		where 
			year(OrderDate) between 2017 and 2019 
		group by
			 GeographyKey
			,ProductKey	
	) as geoSaleTypedSales ON geoSaleTypedSales.GeographyKey = geo.GeographyKey and
						      geoSaleTypedSales.ProductKey = prod.ProductKey
	where 
	  prod.ProductKey > 0
    ) dt
group by
	ProductKey,
	Country,
	xjGeoSaleStatus,
	OrderDate