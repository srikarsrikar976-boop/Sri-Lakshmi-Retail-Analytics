SELECT 'dim_date'        AS TableName, COUNT(*) AS Rows FROM dim_date
UNION ALL
SELECT 'dim_product'     AS TableName, COUNT(*) AS Rows FROM dim_product
UNION ALL
SELECT 'dim_transaction' AS TableName, COUNT(*) AS Rows FROM dim_transaction
UNION ALL
SELECT 'rfm_segments'    AS TableName, COUNT(*) AS Rows FROM rfm_segments
UNION ALL
SELECT 'fact_sales'      AS TableName, COUNT(*) AS Rows FROM fact_sales;

-- ── INDEX 1: FactSales — Date ─────────────────────────
CREATE INDEX IX_FactSales_Date
ON fact_sales (Date);
GO

-- ── INDEX 2: FactSales — Category ────────────────────
CREATE INDEX IX_FactSales_Category
ON fact_sales (Category);
GO

-- ── INDEX 3: FactSales — BillNo ──────────────────────
CREATE INDEX IX_FactSales_BillNo
ON fact_sales (BillNo);
GO

-- ── INDEX 4: FactSales — ProductName ─────────────────
CREATE INDEX IX_FactSales_ProductName
ON fact_sales (ProductName);
GO

-- ── INDEX 5: FactSales — HasDiscount ─────────────────
CREATE INDEX IX_FactSales_HasDiscount
ON fact_sales (HasDiscount);
GO

-- ── INDEX 6: FactSales — MonthName ───────────────────
CREATE INDEX IX_FactSales_MonthName
ON fact_sales (MonthName);
GO

-- ── INDEX 7: DimTransaction — Date ───────────────────
CREATE INDEX IX_DimTransaction_Date
ON dim_transaction (Date);
GO

-- ── INDEX 8: RFMSegments — Segment ───────────────────
CREATE INDEX IX_RFMSegments_Segment
ON rfm_segments (Segment);
GO

--  Index 9: DimTransaction — CustomerType
CREATE INDEX IX_DimTransaction_CustomerType
ON dim_transaction (CustomerType);
GO

--  Index 10: dim_product — Category
CREATE INDEX IX_DimProduct_Category
ON dim_product (Category);
GO

PRINT '✅ All 10 indexes created successfully!';

-- ── Verify All Indexes ────────────────────────────────
USE LakshmiStore;
GO

SELECT 
    t.name  AS TableName,
    i.name  AS IndexName,
    i.type_desc AS IndexType
FROM 
    sys.indexes i
    INNER JOIN sys.tables t 
        ON i.object_id = t.object_id
WHERE 
    i.name IS NOT NULL
ORDER BY 
    t.name, i.name;



-- ═══════════════════════════════════════════════════════
-- QUERY 1: Monthly Revenue & Profit Summary
-- Business Question: How did sales perform each month?
-- ═══════════════════════════════════════════════════════
SELECT
    f.MonthName,
    COUNT(DISTINCT f.BillNo)        AS TotalBills,
    COUNT(f.RecordNo)               AS TotalTransactions,
    ROUND(SUM(f.SalesValue), 2)     AS TotalRevenue,
    ROUND(SUM(f.ProfitAmt), 2)      AS TotalProfit,
    ROUND(AVG(t.NetVal), 2)         AS AvgBillValue,
    ROUND(SUM(f.ProfitAmt) /
          SUM(f.SalesValue) * 100, 2) AS ProfitMarginPct
FROM fact_sales f
INNER JOIN dim_transaction t ON f.BillNo = t.BillNo
GROUP BY f.MonthName
ORDER BY
    CASE f.MonthName
        WHEN 'Sep 2025' THEN 1
        WHEN 'Oct 2025' THEN 2
        WHEN 'Nov 2025' THEN 3
        WHEN 'Dec 2025' THEN 4
        WHEN 'Jan 2026' THEN 5
        WHEN 'Feb 2026' THEN 6
        WHEN 'Mar 2026' THEN 7
    END;
 
-- ═══════════════════════════════════════════════════════
-- QUERY 2: Category-wise Sales Performance
-- Business Question: Which category generates most revenue?
-- ═══════════════════════════════════════════════════════
SELECT
    f.Category,
    COUNT(f.RecordNo)                AS Transactions,
    ROUND(SUM(f.SalesValue), 2)      AS TotalRevenue,
    ROUND(SUM(f.ProfitAmt), 2)       AS TotalProfit,
    ROUND(AVG(f.SellingPrice), 2)    AS AvgPrice,
    ROUND(AVG(f.ProfitMarginPct), 2) AS AvgMargin,
    ROUND(SUM(f.SalesValue) /
         (SELECT SUM(SalesValue)
          FROM fact_sales) * 100, 2) AS RevenueShare
FROM fact_sales f
GROUP BY f.Category
ORDER BY TotalRevenue DESC; 

-- ═══════════════════════════════════════════════════════
-- QUERY 3: Top 10 Products by Revenue
-- Business Question: Which products drive most revenue?
-- ═══════════════════════════════════════════════════════
SELECT TOP 10
    f.ProductName,
    f.Category,
    COUNT(f.RecordNo)             AS TimesSold,
    ROUND(SUM(f.Quantity), 0)     AS TotalQty,
    ROUND(SUM(f.SalesValue), 2)   AS TotalRevenue,
    ROUND(SUM(f.ProfitAmt), 2)    AS TotalProfit,
    ROUND(AVG(f.SellingPrice), 2) AS AvgPrice
FROM fact_sales f
GROUP BY f.ProductName, f.Category
ORDER BY TotalRevenue DESC;

-- ═══════════════════════════════════════════════════════
-- QUERY 4: Payment Type Analysis
-- Business Question: How do customers pay?
-- ═══════════════════════════════════════════════════════
SELECT
    t.CustomerType                   AS PaymentType,
    COUNT(t.BillNo)                  AS TotalBills,
    ROUND(SUM(t.NetVal), 2)          AS TotalRevenue,
    ROUND(AVG(t.NetVal), 2)          AS AvgBillValue,
    ROUND(COUNT(t.BillNo) * 100.0 /
         (SELECT COUNT(*) FROM dim_transaction), 2) AS BillSharePct
FROM dim_transaction t
GROUP BY t.CustomerType
ORDER BY TotalBills DESC;

-- ═══════════════════════════════════════════════════════
-- QUERY 5: Day-wise Buying Pattern
-- Business Question: Which day has highest sales?
-- ═══════════════════════════════════════════════════════
SELECT
    f.DayOfWeek,
    COUNT(DISTINCT f.BillNo)         AS TotalBills,
    COUNT(f.RecordNo)                AS Transactions,
    ROUND(SUM(f.SalesValue), 2)      AS TotalRevenue,
    ROUND(AVG(t.NetVal), 2)          AS AvgBillValue,
    ROUND(SUM(f.SalesValue) * 100.0 /
         (SELECT SUM(SalesValue)
          FROM fact_sales), 2)       AS RevenueSharePct
FROM fact_sales f
INNER JOIN dim_transaction t ON f.BillNo = t.BillNo
GROUP BY f.DayOfWeek
ORDER BY TotalRevenue DESC;

-- QUERY 6: Discount Impact Analysis
-- Business Question: How does discount affect sales?
-- ═══════════════════════════════════════════════════════
SELECT
    CASE
        WHEN DiscountPct = 0          THEN 'No Discount'
        WHEN DiscountPct <= 10        THEN '1-10%'
        WHEN DiscountPct <= 25        THEN '10-25%'
        WHEN DiscountPct <= 50        THEN '25-50%'
        ELSE '50%+'
    END                              AS DiscountBracket,
    COUNT(RecordNo)                  AS Transactions,
    ROUND(AVG(Quantity), 2)          AS AvgQuantity,
    ROUND(AVG(SalesValue), 2)        AS AvgSalesValue,
    ROUND(AVG(ProfitAmt), 2)         AS AvgProfit,
    ROUND(AVG(ProfitMarginPct), 2)   AS AvgMarginPct
FROM fact_sales
GROUP BY
    CASE
        WHEN DiscountPct = 0          THEN 'No Discount'
        WHEN DiscountPct <= 10        THEN '1-10%'
        WHEN DiscountPct <= 25        THEN '10-25%'
        WHEN DiscountPct <= 50        THEN '25-50%'
        ELSE '50%+'
    END
ORDER BY
    CASE
        CASE
            WHEN DiscountPct = 0      THEN 'No Discount'
            WHEN DiscountPct <= 10    THEN '1-10%'
            WHEN DiscountPct <= 25    THEN '10-25%'
            WHEN DiscountPct <= 50    THEN '25-50%'
            ELSE '50%+'
        END
        WHEN 'No Discount' THEN 1
        WHEN '1-10%'       THEN 2
        WHEN '10-25%'      THEN 3
        WHEN '25-50%'      THEN 4
        WHEN '50%+'        THEN 5
    END;

-- ═══════════════════════════════════════════════════════
-- QUERY 7: RFM Segment Summary
-- Business Question: What are customer behaviour segments?
-- ═══════════════════════════════════════════════════════
SELECT
    r.Segment,
    COUNT(r.BillNo)                  AS TotalBills,
    ROUND(AVG(r.Recency), 1)         AS AvgRecency,
    ROUND(AVG(r.Frequency), 1)       AS AvgFrequency,
    ROUND(AVG(r.Monetary), 2)        AS AvgMonetary,
    ROUND(COUNT(r.BillNo) * 100.0 /
         (SELECT COUNT(*) FROM rfm_segments), 2) AS SegmentPct
FROM rfm_segments r
GROUP BY r.Segment
ORDER BY AvgMonetary DESC;

-- ═══════════════════════════════════════════════════════
-- QUERY 8: Profit Margin by Category
-- Business Question: Which category is most profitable?
-- ═══════════════════════════════════════════════════════
SELECT
    Category,
    ROUND(MIN(ProfitMarginPct), 2)   AS MinMargin,
    ROUND(AVG(ProfitMarginPct), 2)   AS AvgMargin,
    ROUND(MAX(ProfitMarginPct), 2)   AS MaxMargin,
    ROUND(STDEV(ProfitMarginPct), 2) AS StdDevMargin,
    COUNT(RecordNo)                  AS Transactions
FROM fact_sales
GROUP BY Category
ORDER BY AvgMargin DESC;

-- ═══════════════════════════════════════════════════════
-- QUERY 9: Bill Value Segmentation
-- Business Question: How much do customers spend per visit?
-- ═══════════════════════════════════════════════════════
SELECT
    CASE
        WHEN NetVal < 100             THEN 'Small (< 100)'
        WHEN NetVal BETWEEN 100 AND 300 THEN 'Medium (100-300)'
        WHEN NetVal BETWEEN 301 AND 500 THEN 'Large (301-500)'
        WHEN NetVal BETWEEN 501 AND 1000 THEN 'High (501-1000)'
        ELSE 'Premium (> 1000)'
    END                              AS BillSegment,
    COUNT(BillNo)                    AS TotalBills,
    ROUND(AVG(NetVal), 2)            AS AvgBillValue,
    ROUND(SUM(NetVal), 2)            AS TotalRevenue,
    ROUND(COUNT(BillNo) * 100.0 /
         (SELECT COUNT(*) FROM dim_transaction), 2) AS BillSharePct
FROM dim_transaction
GROUP BY
    CASE
        WHEN NetVal < 100             THEN 'Small (< 100)'
        WHEN NetVal BETWEEN 100 AND 300 THEN 'Medium (100-300)'
        WHEN NetVal BETWEEN 301 AND 500 THEN 'Large (301-500)'
        WHEN NetVal BETWEEN 501 AND 1000 THEN 'High (501-1000)'
        ELSE 'Premium (> 1000)'
    END
ORDER BY AvgBillValue;

-- ═══════════════════════════════════════════════════════
-- QUERY 10: Executive KPI Summary
-- Business Question: What are the key store metrics?
-- ═══════════════════════════════════════════════════════
SELECT
    COUNT(DISTINCT f.BillNo)           AS TotalBills,
    COUNT(f.RecordNo)                  AS TotalTransactions,
    COUNT(DISTINCT f.ProductName)      AS UniqueProducts,
    COUNT(DISTINCT f.Category)         AS Categories,
    ROUND(SUM(f.SalesValue), 2)        AS TotalRevenue,
    ROUND(SUM(f.ProfitAmt), 2)         AS TotalProfit,
    ROUND(AVG(f.ProfitMarginPct), 2)   AS AvgProfitMargin,
    ROUND(AVG(t.NetVal), 2)            AS AvgBillValue,
    ROUND(MAX(t.NetVal), 2)            AS MaxBillValue,
    ROUND(MIN(t.NetVal), 2)            AS MinBillValue,
    SUM(f.HasDiscount)                 AS DiscountedTxns,
    ROUND(SUM(f.HasDiscount) * 100.0 /
          COUNT(f.RecordNo), 2)        AS DiscountedPct
FROM fact_sales f
INNER JOIN dim_transaction t ON f.BillNo = t.BillNo;

-- ═══════════════════════════════════════════════════════
-- VIEW 1: Executive Summary KPIs
-- Power BI Page: Executive Dashboard
-- ═══════════════════════════════════════════════════════
CREATE VIEW vw_ExecutiveSummary AS
SELECT
    COUNT(DISTINCT f.BillNo)             AS TotalBills,
    COUNT(f.RecordNo)                    AS TotalTransactions,
    COUNT(DISTINCT f.ProductName)        AS UniqueProducts,
    COUNT(DISTINCT f.Category)           AS Categories,
    ROUND(SUM(f.SalesValue), 2)          AS TotalRevenue,
    ROUND(SUM(f.ProfitAmt), 2)           AS TotalProfit,
    ROUND(AVG(f.ProfitMarginPct), 2)     AS AvgProfitMargin,
    ROUND(AVG(t.NetVal), 2)              AS AvgBillValue,
    ROUND(MAX(t.NetVal), 2)              AS MaxBillValue,
    SUM(f.HasDiscount)                   AS DiscountedTxns,
    ROUND(SUM(f.HasDiscount) * 100.0 /
          COUNT(f.RecordNo), 2)          AS DiscountedPct
FROM fact_sales f
INNER JOIN dim_transaction t
    ON f.BillNo = t.BillNo;

-- ═══════════════════════════════════════════════════════
-- VIEW 2: Monthly Sales Trend
-- Power BI Page: Sales Analysis
-- ═══════════════════════════════════════════════════════
CREATE VIEW vw_MonthlySales AS
SELECT
    f.MonthName,
    COUNT(DISTINCT f.BillNo)             AS TotalBills,
    COUNT(f.RecordNo)                    AS TotalTransactions,
    ROUND(SUM(f.SalesValue), 2)          AS TotalRevenue,
    ROUND(SUM(f.ProfitAmt), 2)           AS TotalProfit,
    ROUND(AVG(t.NetVal), 2)              AS AvgBillValue,
    ROUND(SUM(f.ProfitAmt) /
          SUM(f.SalesValue) * 100, 2)    AS ProfitMarginPct,
    CASE f.MonthName
        WHEN 'Sep 2025' THEN 1
        WHEN 'Oct 2025' THEN 2
        WHEN 'Nov 2025' THEN 3
        WHEN 'Dec 2025' THEN 4
        WHEN 'Jan 2026' THEN 5
        WHEN 'Feb 2026' THEN 6
        WHEN 'Mar 2026' THEN 7
    END                                  AS MonthOrder
FROM fact_sales f
INNER JOIN dim_transaction t
    ON f.BillNo = t.BillNo
GROUP BY f.MonthName;

-- ═══════════════════════════════════════════════════════
-- VIEW 3: Category Sales Performance
-- Power BI Page: Product Analysis
-- ═══════════════════════════════════════════════════════
CREATE VIEW vw_CategorySales AS
SELECT
    f.Category,
    COUNT(f.RecordNo)                    AS Transactions,
    ROUND(SUM(f.SalesValue), 2)          AS TotalRevenue,
    ROUND(SUM(f.ProfitAmt), 2)           AS TotalProfit,
    ROUND(AVG(f.SellingPrice), 2)        AS AvgPrice,
    ROUND(AVG(f.ProfitMarginPct), 2)     AS AvgMargin,
    ROUND(AVG(f.DiscountPct), 2)         AS AvgDiscount,
    ROUND(SUM(f.SalesValue) * 100.0 /
         (SELECT SUM(SalesValue)
          FROM fact_sales), 2)           AS RevenueSharePct
FROM fact_sales f
GROUP BY f.Category;

-- ═══════════════════════════════════════════════════════
-- VIEW 4: Top Products
-- Power BI Page: Product Analysis
-- ═══════════════════════════════════════════════════════
CREATE VIEW vw_TopProducts AS
SELECT
    f.ProductName,
    f.Category,
    COUNT(f.RecordNo)                    AS TimesSold,
    ROUND(SUM(f.Quantity), 0)            AS TotalQuantity,
    ROUND(SUM(f.SalesValue), 2)          AS TotalRevenue,
    ROUND(SUM(f.ProfitAmt), 2)           AS TotalProfit,
    ROUND(AVG(f.SellingPrice), 2)        AS AvgPrice,
    ROUND(AVG(f.ProfitMarginPct), 2)     AS AvgMargin,
    COUNT(DISTINCT f.BillNo)             AS UniqueBills
FROM fact_sales f
GROUP BY f.ProductName, f.Category;

-- ═══════════════════════════════════════════════════════
-- VIEW 5: Payment Type Analysis
-- Power BI Page: Customer Behaviour
-- ═══════════════════════════════════════════════════════
CREATE VIEW vw_PaymentAnalysis AS
SELECT
    t.CustomerType                       AS PaymentType,
    COUNT(t.BillNo)                      AS TotalBills,
    ROUND(SUM(t.NetVal), 2)              AS TotalRevenue,
    ROUND(AVG(t.NetVal), 2)              AS AvgBillValue,
    ROUND(MAX(t.NetVal), 2)              AS MaxBillValue,
    ROUND(MIN(t.NetVal), 2)              AS MinBillValue,
    ROUND(COUNT(t.BillNo) * 100.0 /
         (SELECT COUNT(*)
          FROM dim_transaction), 2)      AS BillSharePct
FROM dim_transaction t
GROUP BY t.CustomerType;

-- ═══════════════════════════════════════════════════════
-- VIEW 6: Day-wise Buying Pattern
-- Power BI Page: Customer Behaviour
-- ═══════════════════════════════════════════════════════
CREATE VIEW vw_DayWiseSales AS
SELECT
    f.DayOfWeek,
    CASE f.DayOfWeek
        WHEN 'Monday'    THEN 1
        WHEN 'Tuesday'   THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday'  THEN 4
        WHEN 'Friday'    THEN 5
        WHEN 'Saturday'  THEN 6
        WHEN 'Sunday'    THEN 7
    END                                  AS DayOrder,
    COUNT(DISTINCT f.BillNo)             AS TotalBills,
    COUNT(f.RecordNo)                    AS Transactions,
    ROUND(SUM(f.SalesValue), 2)          AS TotalRevenue,
    ROUND(AVG(t.NetVal), 2)              AS AvgBillValue,
    ROUND(SUM(f.SalesValue) * 100.0 /
         (SELECT SUM(SalesValue)
          FROM fact_sales), 2)           AS RevenueSharePct
FROM fact_sales f
INNER JOIN dim_transaction t
    ON f.BillNo = t.BillNo
GROUP BY f.DayOfWeek;

-- ═══════════════════════════════════════════════════════
-- VIEW 7: Discount Analysis
-- Power BI Page: Sales Analysis
-- ═══════════════════════════════════════════════════════
CREATE VIEW vw_DiscountAnalysis AS
SELECT
    f.ProductName,
    f.Category,
    f.SellingPrice,
    f.MRP,
    f.Discount,
    f.DiscountPct,
    f.HasDiscount,
    f.SalesValue,
    f.ProfitAmt,
    f.ProfitMarginPct,
    f.Quantity,
    f.MonthName,
    f.DayOfWeek
FROM fact_sales f;


-- ═══════════════════════════════════════════════════════
-- VIEW 8: RFM Customer Segments
-- Power BI Page: Customer Behaviour
-- ═══════════════════════════════════════════════════════
CREATE VIEW vw_RFMSummary AS
SELECT
    r.Segment,
    COUNT(r.BillNo)                      AS TotalBills,
    ROUND(AVG(r.Recency), 1)             AS AvgRecency,
    ROUND(AVG(CAST(r.Frequency AS FLOAT)), 1) AS AvgFrequency,
    ROUND(AVG(r.Monetary), 2)            AS AvgMonetary,
    ROUND(SUM(r.Monetary), 2)            AS TotalMonetary,
    ROUND(COUNT(r.BillNo) * 100.0 /
         (SELECT COUNT(*)
          FROM rfm_segments), 2)         AS SegmentPct
FROM rfm_segments r
GROUP BY r.Segment;

-- ═══════════════════════════════════════════════════════
-- VIEW 9: Full Sales Detail
-- Power BI Page: All pages (main data source)
-- ═══════════════════════════════════════════════════════
CREATE VIEW vw_FullSalesDetail AS
SELECT
    f.RecordNo,
    f.BillNo,
    f.Date,
    f.ProductName,
    f.Category,
    f.MRP,
    f.SellingPrice,
    f.Discount,
    f.DiscountPct,
    f.Quantity,
    f.SalesValue,
    f.ProfitAmt,
    f.ProfitMarginPct,
    f.HasDiscount,
    f.MonthName,
    f.DayOfWeek,
    t.CustomerType                       AS PaymentType,
    t.NetVal                             AS BillNetValue,
    t.GrossVal                           AS BillGrossValue,
    d.Quarter,
    d.IsWeekend,
    r.Segment                            AS RFMSegment,
    r.RFM_Score,
    r.Recency,
    r.Monetary                           AS BillMonetary
FROM fact_sales f
INNER JOIN dim_transaction t ON f.BillNo    = t.BillNo
INNER JOIN dim_date d        ON f.Date      = d.Date
LEFT  JOIN rfm_segments r    ON f.BillNo    = r.BillNo;

-- ── Verify All Views Created ──────────────────────────
SELECT
    name        AS ViewName,
    create_date AS CreatedOn
FROM sys.views
ORDER BY name;






