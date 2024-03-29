--- All Listing table has been refreshed daily 
USE PROCUREMENTDB 
GO
CREATE VIEW Retail.SkuCategoryPriceView AS 
SELECT CASE WHEN SellerSku IS NULL THEN SKU ELSE SellerSku END AS Sku
      ,CASE WHEN ISBN IS NULL AND SellerSku LIKE '978%' THEN SUBSTRING(SellerSku, 1, 13) ELSE ISBN END AS Isbn
	  ,CASE WHEN SellerSku LIKE '%MFN%' AND SellerSku LIKE '978%' THEN 'Trade Books'
	        WHEN SellerSku LIKE '%FBATRNEW%' AND SellerSku LIKE '978%' THEN 'Trade Books'
			WHEN SKU LIKE '103%' AND AsinNum NOT LIKE 'B%' THEN 'Trade Books' 
			WHEN SellerSku LIKE '978%' AND SellerSku LIKE '%TB2%' OR SellerSku LIKE '%TBU%'THEN 'Trouble Books Used'
	        WHEN SellerSku LIKE '978%' AND SellerSku LIKE '%TB%' THEN 'Trouble Books New'
			WHEN SellerSku LIKE '%FBMPRIME%' THEN 'Prime Dealers'
			WHEN SellerSku LIKE '%AWU%' THEN 'Textbooks Used'
			WHEN AsinNum LIKE 'B%' AND ISBN NOT LIKE '978%' THEN 'PPE' 
			WHEN AsinNum LIKE 'B%' AND SellerSku NOT LIKE '978%' THEN 'PPE' ELSE 'Textbooks New' END AS Category
	  ,CASE WHEN Price IS NULL THEN 0 ELSE Price END AS Price
FROM 
(SELECT CAST(SellerSku AS NVARCHAR(50)) AS SellerSku
       ,CAST(Asin1 AS NVARCHAR(50)) AS AsinNum
	   ,Price
  FROM [BookXCenterProduction].[Data].AllListings) Amazon
FULL JOIN 
 (SELECT CAST([AMAZON SKU] AS NVARCHAR(50)) AS SKU
        ,CAST(ISBN AS NVARCHAR(50)) AS ISBN
   FROM PROCUREMENTDB.Retail.SkuListOrg) Org_List
ON Amazon.SellerSku = Org_List.SKU;
GO

USE PROCUREMENTDB 
GO
CREATE VIEW Retail.SkuWarehousePriceView AS 
SELECT CASE WHEN SellerSku IS NULL THEN SKU ELSE SellerSku END AS Sku
      ,CASE WHEN ISBN IS NULL AND SellerSku LIKE '978%' THEN SUBSTRING(SellerSku, 1, 13) ELSE ISBN END AS Isbn
	  ,CASE WHEN SellerSku LIKE '%MFN%' AND SellerSku LIKE '978%' THEN 'TR'
	        WHEN SellerSku LIKE '%FBATRNEW%' AND SellerSku LIKE '978%' THEN 'FBA_TR'
			WHEN SKU LIKE '103%' AND AsinNum NOT LIKE 'B%' THEN 'TR' 
			WHEN SellerSku LIKE '978%' AND SellerSku LIKE '%TB2%' OR SellerSku LIKE '%TBU%'THEN 'TB-2'
	        WHEN SellerSku LIKE '978%' AND SellerSku LIKE '%TB%' THEN 'TB'
			WHEN SellerSku LIKE '%FBMPRIME%' THEN 'FBM_PD'
			WHEN SellerSku LIKE '%FBMNEW%' THEN 'FBM'
			WHEN SellerSku LIKE '%AWU%' THEN 'AWU'
			WHEN SellerSku LIKE '%AW%' THEN 'AW'
			WHEN AsinNum LIKE 'B%' AND ISBN NOT LIKE '978%' THEN 'PPE' 
			WHEN AsinNum LIKE 'B%' AND SellerSku NOT LIKE '978%' THEN 'PPE' ELSE 'FBA_AW' END AS Warehouse
	  ,CASE WHEN Price IS NULL THEN 0 ELSE Price END AS Price
FROM 
(SELECT CAST(SellerSku AS NVARCHAR(50)) AS SellerSku
       ,CAST(Asin1 AS NVARCHAR(50)) AS AsinNum
	   ,Price
  FROM [BookXCenterProduction].[Data].AllListings) Amazon
FULL JOIN 
 (SELECT CAST([AMAZON SKU] AS NVARCHAR(50)) AS SKU
        ,CAST(ISBN AS NVARCHAR(50)) AS ISBN
   FROM PROCUREMENTDB.Retail.SkuListOrg) Org_List
ON Amazon.SellerSku = Org_List.SKU;
GO