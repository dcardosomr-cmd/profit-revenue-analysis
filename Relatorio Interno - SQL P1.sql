-- Panel Table -- Table used to study the profitability of the company.
SELECT	
		H.SalesOrderID,
		H.CustomerID,
		H.OrderDate,
		D.ProductID,
		H.SubTotal,
		D.LineTotal,
		D.OrderQty,
		D.UnitPrice,
		D.UnitPriceDiscount,
		P.StandardCost,
		P.ListPrice,
		P.[Name] AS ProductName,
		PC.[Name] AS ProductCategory,
		PS.[Name] AS ProductSubcategory
	
INTO PanelTableV1
FROM Sales.SalesOrderHeader AS H
	JOIN Sales.SalesOrderDetail AS D
		ON H.SalesOrderID = D.SalesOrderID
	LEFT JOIN Production.PRODUCT AS P
		on P.ProductID = D.ProductID
	JOIN Production.ProductSubcategory AS PS
		ON PS.ProductSubcategoryID = P.ProductSubcategoryID
	JOIN Production.ProductCategory AS PC
		ON PC.ProductCategoryID = PS.ProductCategoryID

/****************************************************** SUB-SECTIONS QUESTIONS, ANSWERS AND STUDY QUERIES ****************************************************/

						/* What is the total revenue/profit? */

-- Total Revenue, Cost and Profit by Year
SELECT	YEAR (OrderDate) AS Year,
		SUM (OrderQty * UnitPrice) AS TotalRevenue,
		SUM (StandardCost * OrderQty) AS TotalCost,
		SUM (OrderQty * (UnitPrice - StandardCost)) AS Profit
FROM PanelTableV1
GROUP BY YEAR (OrderDate)
ORDER BY Profit DESC


-- Revenue, Cost and Profit by Month and Year -- Charts 1, 2, 3 and 4 of External Report
SELECT	YEAR (OrderDate) AS Year,
		MONTH (OrderDate) AS Month,
		DATENAME (MONTH,OrderDate) AS NameMonth, 
		SUM (OrderQty * UnitPrice) AS TotalRevenue,
		SUM (StandardCost * OrderQty) AS TotalCost,
		SUM (OrderQty * (UnitPrice - StandardCost)) AS Profit, 
		AVG (OrderQty * (UnitPrice - StandardCost)) AS AvgProfit
FROM PanelTableV1
GROUP BY YEAR (OrderDate), MONTH (OrderDate), DATENAME (MONTH,OrderDate)
ORDER BY YEAR (OrderDate), MONTH (OrderDate)


---------------------------------------------------------------------------------------------------------------------------------------------------

						/* What is the average of the discounts on a single item? */

-- Average discount by item with number of times in discount
SELECT	ProductID,
		ProductName,
		ProductCategory,
		ProductSubcategory,
		AVG(UnitPriceDiscount) *100 AS AvgDiscount, 
		SUM(CASE WHEN UnitPriceDiscount > 0 THEN 1 ELSE 0 END) AS TimesDiscountApplied, 
		COUNT(*) AS TotalOrderLines,
		CAST(SUM(CASE WHEN UnitPriceDiscount > 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) *100 AS DiscountFrequency -- Times a discount was applied in the total sales of the product (%)
FROM PanelTableV1
GROUP BY ProductID, ProductName, ProductCategory, ProductSubcategory 
HAVING SUM(CASE WHEN UnitPriceDiscount > 0 THEN 1 ELSE 0 END) > 0 
ORDER BY DiscountFrequency DESC 

-- Average discount per item over the time
SELECT	ProductID,
		YEAR(OrderDate) AS OrderYear,
		MONTH(OrderDate) AS OrderMonth,
		AVG(UnitPriceDiscount) AS AvgDiscount,
		COUNT(*) AS TotalOrderLines
FROM PanelTableV1
WHERE UnitPriceDiscount > 0
GROUP BY ProductID, YEAR(OrderDate), MONTH(OrderDate)
ORDER BY ProductID, OrderYear, OrderMonth

-- Average discount by Product
SELECT	ProductName,
		AVG (UnitPriceDiscount) *100 AS AvgDiscount
FROM PanelTableV1 
WHERE UnitPriceDiscount > 0
GROUP BY ProductName

-- Average discount by Product Category
SELECT	ProductCategory,
		AVG (UnitPriceDiscount) *100 AS AvgDiscount
FROM PanelTableV1 
WHERE UnitPriceDiscount > 0
GROUP BY ProductCategory
ORDER BY AvgDiscount DESC

-- Average Discount and Total Orders over time, in top 3 items -- Chart 15, 16 and 17 of External Report
WITH Top3BestProducts AS(
						SELECT	TOP 3 ProductID,
								SUM(LineTotal) AS TotalItemSales
						FROM PanelTableV1
						GROUP BY ProductID
						ORDER BY TotalItemSales DESC 
						)
SELECT	p.ProductID,
		ProductName,
		ProductSubcategory,
		ProductCategory,
		YEAR(OrderDate) AS OrderYear,
		MONTH(OrderDate) AS OrderMonth,
		DATENAME (MONTH, OrderDate) AS MonthName,
		AVG(UnitPriceDiscount) *100 AS AvgDiscount,
		AVG (UnitPrice) as ItemPrice,
		SUM(OrderQty) AS TotalOrders
FROM PanelTableV1 AS p
JOIN Top3BestProducts AS t
    ON p.ProductID = t.ProductID
GROUP BY p.ProductID, ProductName, ProductSubcategory, ProductCategory, YEAR(OrderDate), MONTH(OrderDate), DATENAME (MONTH, OrderDate)
ORDER BY p.ProductID, OrderYear, OrderMonth



--------------------------------------------------------------------------------------------------------------------------------------

						/* What is the quantity of items purchased? */

-- Total of items purchased 
SELECT 
    SUM(OrderQty) AS TotalItemsPurchased
FROM PanelTableV1

-- Total of items purchased over the month/years
SELECT	Format (OrderDate, 'yyyy-MM') as 'Year-Month',
		COUNT (OrderQty) as UnitsSold
FROM PanelTableV1
GROUP BY Format (OrderDate, 'yyyy-MM')
ORDER BY Format (OrderDate, 'yyyy-MM')

-- Total items sold and the total items in discount -- Chart 6, 7, 8 and 9 of External Report
SELECT	YEAR (OrderDate) AS Year,
		MONTH (OrderDate) AS Month,
		DATENAME (MONTH,OrderDate) AS NameMonth,
		Count (OrderQty) as NoOfItemsSold,
		SUM (CASE WHEN UnitPriceDiscount > 0 THEN 1 ELSE 0 END) AS NoOfItemsDiscount,
		(CAST (SUM(CASE WHEN UnitPriceDiscount > 0 THEN 1 ELSE 0 END) AS FLOAT) / Count (OrderQty)) *100 AS RatioItemsInDiscount
FROM PanelTableV1
WHERE YEAR (OrderDate) = 2014 -- Select the year to analyze
GROUP BY YEAR (OrderDate), MONTH (OrderDate), DATENAME (MONTH,OrderDate)
ORDER BY YEAR (OrderDate), MONTH (OrderDate)

----------------------------------------------------------------------------------------------------------------------------------------------------

						/* How much is the margin (sale price less cost)? */

-- Profit margin per product
SELECT	ProductID,
		ProductName,
		SUM (OrderQty * UnitPrice) AS TotalRevenue,
		SUM (OrderQty * StandardCost) AS TotalCost,
		SUM (OrderQty * (UnitPrice - StandardCost)) AS TotalProfit,
		CAST (SUM (OrderQty * (UnitPrice - StandardCost)) AS FLOAT) / 
		NULLIF (SUM (OrderQty * UnitPrice), 0) * 100 AS ProfitMarginPercent
FROM PanelTableV1
GROUP BY ProductID, ProductName
ORDER BY ProfitMarginPercent DESC 

-- Total profit Margin for all Products
SELECT	SUM (OrderQty * UnitPrice) AS TotalRevenue,
		SUM (OrderQty * StandardCost) AS TotalCost,
		SUM (OrderQty * (UnitPrice - StandardCost)) AS TotalProfit,
		CAST (SUM(OrderQty * (UnitPrice - StandardCost)) AS FLOAT) / 
		NULLIF(SUM(OrderQty * UnitPrice), 0) * 100 AS OverallProfitMarginPercent
FROM PanelTableV1 

-- Profitability per product category (%)
SELECT 
    ProductCategory,
    SUM(LineTotal) AS TotalSales,
    SUM(OrderQty * StandardCost) AS TotalCost,
    (SUM(LineTotal) - SUM(OrderQty * StandardCost)) AS Profit,
    ((SUM(LineTotal) - SUM(OrderQty * StandardCost)) / SUM(LineTotal)) * 100 AS ProfitPct
FROM PanelTableV1
GROUP BY ProductCategory
ORDER BY ProfitPct DESC;
-------------------------------------------------------------------------------------------------------------------------

						/* What is the average margin (sale price less cost)? */

-- Average profit margin by product 
SELECT	ProductID,
		ProductName,
		AVG (UnitPrice) AS AvgUnitPrice,
		AVG (StandardCost) AS AvgStandardCost,
		AVG (UnitPrice - StandardCost) as AvgMargin,
		((AVG (UnitPrice - StandardCost)) / AVG (UnitPrice)) *100 as '%ItemProfit'
FROM PanelTableV1
GROUP BY ProductID, ProductName
ORDER BY '%ItemProfit' DESC

-- Average profit margin by product category (%) -- Chart 12 of External Report
WITH PCM AS (
			SELECT	ProductCategory,
					AVG (UnitPrice) AS AvgPrice,
					AVG (StandardCost) AS AvgCost,
					AVG (UnitPrice - StandardCost) AS AvgMargin
			FROM PanelTableV1
			GROUP BY ProductCategory
			)
SELECT	ProductCategory,
		AvgPrice,
		AvgCost,
		AvgMargin,
		AvgMargin / AvgPrice *100 AS PctMargin
FROM PCM
ORDER BY PctMargin DESC

-- Average profit margin by product Subcategory (TOP 5 BEST MARGIN) -- Chart 14 of External Report
SELECT	TOP 5 ProductCategory,
		ProductSubcategory,
		AVG (UnitPrice) AS AvgPrice,
		AVG (StandardCost) AS AvgCost,
		AVG (UnitPrice - StandardCost) AS AvgMargin
FROM PanelTableV1
GROUP BY ProductCategory, ProductSubcategory
ORDER BY AvgMargin DESC

-- Average profit margin by product Subcategory (TOP 4 WORST MARGIN) -- Chart 13 of External Report
SELECT	TOP 4 ProductCategory,
		ProductSubcategory,
		AVG (UnitPrice) AS AvgPrice,
		AVG (StandardCost) AS AvgCost,
		AVG (UnitPrice - StandardCost) AS AvgMargin
FROM PanelTableV1
GROUP BY ProductCategory, ProductSubcategory
ORDER BY AvgMargin 
-------------------------------------------------------------------------------------------------------------------------------------------------

				/*What are the monthly and quarterly rankings for the year according to the margin (sale less cost)? */

-- Rank of total Profit Margin per month / Year
WITH MonthlyMargins AS (
						SELECT	YEAR(OrderDate) AS OrderYear,
								MONTH(OrderDate) AS OrderMonth,
								SUM(OrderQty * UnitPrice) AS TotalRevenue,
								SUM(OrderQty * StandardCost) AS TotalCost,
								SUM(OrderQty * (UnitPrice - StandardCost)) AS TotalProfit,
								CAST(SUM(OrderQty * (UnitPrice - StandardCost)) AS FLOAT) / 
								NULLIF(SUM(OrderQty * UnitPrice),0) * 100 AS ProfitMarginPercent
						FROM PanelTableV1
						GROUP BY YEAR(OrderDate), MONTH(OrderDate)
						)
SELECT	OrderYear,
		OrderMonth,
		TotalRevenue,
		TotalCost,
		TotalProfit,
		ProfitMarginPercent,
		RANK() OVER (ORDER BY ProfitMarginPercent DESC) AS MarginRank
FROM MonthlyMargins
ORDER BY MarginRank 

-- Profit rank by quarter year -- Chart 5 of External Report
SELECT	YEAR (OrderDate) AS 'Year',
		DATEPART (QUARTER, OrderDate) AS 'Quarter',
		CONCAT ('Q', DATEPART (QUARTER, OrderDate),'_',YEAR (OrderDate)) AS YearQuarter,
		SUM (UnitPrice * OrderQty) AS Sales,
		SUM (StandardCost * OrderQty) AS Cost,
		SUM (OrderQty * (UnitPrice - StandardCost)) AS Profit,
		RANK() OVER (ORDER BY SUM(OrderQty * (UnitPrice - StandardCost)) DESC) AS QuarterRank
FROM PanelTableV1
GROUP BY YEAR (OrderDate), DATEPART(QUARTER, OrderDate)
ORDER BY Year, Quarter

-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- SubCategory with highest order quantity -- Chart 19 of External Report
SELECT	ProductCategory,
		SUM (OrderQty) AS TotalSalesCategory
FROM PanelTableV1
GROUP BY ProductCategory
ORDER BY TotalSalesCategory DESC

-- Number of sales by reasons -- Chart 10 of External Report
SELECT	HR.SalesReasonID,
		SR.Name as Reason,
		SUM (P.OrderQty) AS NoOfOrders
FROM PanelTableV1 AS P
	JOIN Sales.SalesOrderHeaderSalesReason AS HR
		ON P.SalesOrderID = HR.SalesOrderID
	JOIN Sales.SalesReason AS SR
		ON HR.SalesReasonID = SR.SalesReasonID
Where hr.SalesReasonID is not null
GROUP BY HR.SalesReasonID, SR.Name
ORDER BY NoOfOrders desc


-- Number of sales by reasons over the years -- Chart 11 of External Report
SELECT	YEAR(P.OrderDate) AS Year,
		sr.Name AS Reason,
		SUM (P.OrderQty) AS NoOfSales,
		RANK() OVER (PARTITION BY YEAR(P.OrderDate)
					ORDER BY COUNT(*)) AS ReasonRank
FROM PanelTableV1 AS P
	JOIN Sales.SalesOrderHeaderSalesReason AS HR
		ON P.SalesOrderID = HR.SalesOrderID
	JOIN Sales.SalesReason AS SR
		ON HR.SalesReasonID = SR.SalesReasonID
Where hr.SalesReasonID is not null
GROUP BY YEAR(P.OrderDate), SR.Name
ORDER BY Year, ReasonRank

-- Average product price per year -- Chart 18 of External Report
SELECT	YEAR (OrderDate) AS YEAR,
		AVG (UnitPrice) AS AvgPriceByYear
FROM PanelTableV1
GROUP BY YEAR (OrderDate)
ORDER BY YEAR 

-- High frequently pairs of products bought together
SELECT	TOP 10
		p1.Name AS Product1,
		ps1.Name AS SubcategoryProduct1,
		pc1.Name AS CategoryProduct1,
		p2.Name AS Product2,
		ps2.Name AS SubcategoryProduct2,
		pc2.Name AS CategoryProduct2,
		COUNT(*) AS TimesBoughtTogether
FROM Sales.SalesOrderDetail AS d1
	JOIN Sales.SalesOrderDetail AS d2
		ON d1.SalesOrderID = d2.SalesOrderID
	JOIN Production.Product AS p1
		ON d1.ProductID = p1.ProductID
	JOIN Production.Product AS p2
		ON d2.ProductID = p2.ProductID
	JOIN Production.ProductSubcategory AS ps1
		ON ps1.ProductSubcategoryID = p1.ProductSubcategoryID
	JOIN Production.ProductSubcategory AS ps2
		ON ps2.ProductSubcategoryID = p2.ProductSubcategoryID
	JOIN Production.ProductCategory AS pc1
		ON pc1.ProductCategoryID = ps1.ProductCategoryID
	JOIN Production.ProductCategory AS pc2
		ON pc2.ProductCategoryID = ps2.ProductCategoryID
WHERE d1.ProductID <> d2.ProductID and 
	d1.SalesOrderID = d2.SalesOrderID
GROUP BY p1.Name, p2.Name, ps1.Name, pc1.Name, ps2.Name, pc2.Name
ORDER BY TimesBoughtTogether DESC
 
-- Products category frequently bought together -- Table 2 of External Report
SELECT	pc1.Name AS CategoryProduct1,
		pc2.Name AS CategoryProduct2,
		COUNT(*) AS TimesBoughtTogether
FROM Sales.SalesOrderDetail AS d1
	JOIN Sales.SalesOrderDetail AS d2
		ON d1.SalesOrderID = d2.SalesOrderID
	JOIN Production.Product AS p1
		ON d1.ProductID = p1.ProductID
	JOIN Production.Product AS p2
		ON d2.ProductID = p2.ProductID
	JOIN Production.ProductSubcategory AS ps1
		ON ps1.ProductSubcategoryID = p1.ProductSubcategoryID
	JOIN Production.ProductSubcategory AS ps2
		ON ps2.ProductSubcategoryID = p2.ProductSubcategoryID
	JOIN Production.ProductCategory AS pc1
		ON pc1.ProductCategoryID = ps1.ProductCategoryID
	JOIN Production.ProductCategory AS pc2
		ON pc2.ProductCategoryID = ps2.ProductCategoryID
WHERE d1.ProductID <> d2.ProductID and 
		d1.SalesOrderID = d2.SalesOrderID
GROUP BY pc1.Name, pc2.Name
ORDER BY TimesBoughtTogether DESC
