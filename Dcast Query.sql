SELECT * FROM 
(SELECT II.*
       ,CONCAT(II.ISBN, '_',II.condition) AS [key]
 FROM (SELECT I.ItemCode AS ISBN
              ,CASE WHEN I.IsCommited < I.OnHand THEN (I.OnHand - I.IsCommited) ELSE 0 END AS sup_qty 
              ,I.WhsCode AS warehouse
	          ,CASE WHEN I.WhsCode IN ('AW', 'TB', 'TR') THEN 'NEW' ELSE 'USED' END AS condition
       FROM BookXCenterProduction.SAP.InventoryReportView I
       WHERE I.WhsCode IN ('AW', 'AWU', 'TB', 'TR', 'TB-2')
	   AND I.OnHand <> 0)II
UNION
SELECT SS.Isbn AS ISBN
      ,SUM(FBAT.Amz_FBA_Inventory) AS sup_qty
	  ,'FBA' AS warehouse
	  ,'NEW' AS condition
	  ,CONCAT(ISBN,'_','NEW') AS [key]
FROM 
(SELECT FBA.Sku,
	    SUM(FBA.AfnFulfillableQuantity) AS Amz_FBA_Inventory
FROM BookXCenterProduction.[Data].FbaManageInventories FBA
WHERE FBA.AfnTotalQuantity <> 0
 AND  FBA.Condition = 'New'
GROUP BY FBA.Sku) FBAT
LEFT JOIN
(SELECT  S.sku AS Sku, S.isbn AS Isbn FROM PROCUREMENTDB.Retail.SkuListCategory S) SS
ON FBAT.Sku = SS.sku 
GROUP BY SS.Isbn) PT
PIVOT(
    SUM(PT.sup_qty) 
    FOR PT.warehouse IN (
        [TB], 
        [TB-2], 
        [AW], 
        [AWU], 
        [FBA], 
        [TR])
) AS NEW_TT;
