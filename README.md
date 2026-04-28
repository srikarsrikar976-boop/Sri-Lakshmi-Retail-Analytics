# 🏪 Consumer Buying Behaviour Analysis — Sri Lakshmi Supermarket, Salem

<div align="center">

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)
![Excel](https://img.shields.io/badge/Microsoft%20Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)

**MBA Capstone Project | Sona School of Business and Management, Salem**
**Academic Year: 2025 – 2026**

</div>

---

## 📌 Project Overview

This capstone project presents a **full-stack business analytics study** on consumer buying behaviour at **Sri Lakshmi Supermarket, Salem, Tamil Nadu**. Using real POS transaction data and primary survey data, the study applies an integrated analytics pipeline — **Python → SQL Server → Power BI** — to transform raw retail data into actionable business insights.

> 🎓 *A Study on Consumer Buying Behaviour Analysis of Sri Lakshmi Supermarket, Salem*
> Submitted by **Srikar S** | Sona School of Business and Management

---

## 🗃️ Dataset Summary

| Metric | Value |
|--------|-------|
| 📦 Total Transactions | 43,341 product-level records |
| 🧾 Total Customer Bills | 8,345 bills |
| 🛍️ Unique Products | 2,543 |
| 🏷️ Product Categories | 17 |
| 📅 Study Period | September 2025 – March 2026 |
| 💰 Total Revenue | ₹21,80,958 |
| 📈 Total Profit | ₹2,49,731 |
| 📊 Overall Profit Margin | 12.66% |
| 👥 Survey Respondents | 109 |

---

## 🛠️ Tech Stack

```
Raw POS Data (Excel)
       ↓
Python (Jupyter Notebook)   ──► EDA + Statistical Analysis + Charts
       ↓
Microsoft SQL Server         ──► Star Schema + Views + Business Queries
       ↓
Power BI Desktop             ──► 5-Page Interactive Dashboard
       +
Google Forms                 ──► Primary Survey (109 respondents)
```

| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.11 (Anaconda) | Data cleaning, EDA, statistical analysis |
| Jupyter Notebook | Latest | Interactive analysis environment |
| pandas | 2.3.3 | Data manipulation |
| matplotlib / scipy | Latest | Visualisation + statistics |
| Microsoft SQL Server | 2022 | Star schema database + queries |
| SSMS | 2022 | SQL query execution |
| Power BI Desktop | Feb 2026 | Interactive dashboard (5 pages) |
| Google Forms | Online | Primary survey data collection |

---

## 📊 Power BI Dashboard — 5 Pages

> 🔗 **[View Live Dashboard on Power BI](#)** *(Link coming soon)*

### Dashboard Pages

| Page | Description | Key Visuals |
|------|-------------|-------------|
| 🏠 **Home** | Executive summary with KPI cards | Revenue, Profit, Bills, Products KPIs |
| 📊 **Sales** | Monthly revenue trend analysis | Line + Bar charts, Monthly comparisons |
| 📦 **Products** | Category & product performance | Top 10 bars, Category pie, Margin chart |
| 👥 **Customer** | Customer behaviour & RFM segments | Payment donut, RFM bar, Day-wise chart |
| 💰 **Discount** | Discount impact analysis | Scatter plots, Bracket analysis |

### Dashboard Preview

> *Screenshots from Power BI Dashboard*

![Dashboard Preview](assets/dashboard_home.png)

---

## 🔬 Statistical Analysis Summary

### Hypothesis Testing Results

| Test | Variables | Result | Key Statistic |
|------|-----------|--------|---------------|
| Simple Linear Regression | Discount % → Quantity | ❌ Not Significant | R²=0.000, p=0.785 |
| Simple Linear Regression | Selling Price → Sales | ✅ Significant | R²=0.917, p<0.001 |
| Multiple Linear Regression | Price + Discount + Qty → Sales | ✅ Significant | R²=0.929, F=187,746 |
| One-Way ANOVA | Category → Profit Margin | ✅ Significant | F=1709.78, p<0.001 |
| Chi-Square Test | Discount → Buying Volume | ✅ Significant | χ²=465.62, p<0.001 |

### Key Regression Equation

```
Sales Value = 0.43 + (1.033 × Selling Price) − (0.025 × Discount%) + (3.611 × Quantity)
```

---

## 👥 RFM Customer Segmentation

Bill-level RFM segmentation across 8,345 customer bills:

| Segment | Bills | Share | Avg Bill Value |
|---------|-------|-------|----------------|
| 🟢 Champions | 1,247 | 14.9% | ₹690 |
| 🔵 Loyal | 2,523 | 30.2% | ₹341 |
| 🟡 Potential | 2,557 | 30.6% | ₹138 |
| 🟠 At Risk | 1,326 | 15.9% | ₹61 |
| 🔴 Lost | 692 | 8.3% | ₹37 |

> Champions spend **18.6× more** than Lost segment customers

---

## 📈 Key Business Insights

```
💡 January 2026 — Peak Revenue Month (₹4,02,798) — Pongal season
💡 Sunday — Busiest shopping day (19.3% of weekly revenue)
💡 TVS OIL 1 LIT — Top product by revenue (₹65,376)
💡 EGG — Most purchased item (5,415 units | 641 bills)
💡 Pooja Items — Highest profit margin category (17.64%)
💡 Oils & Ghee — Highest revenue (14.9%) but lowest margin (6.89%)
💡 Cash: 60% | UPI: 40% — Strong digital payment adoption
💡 Discounts do NOT increase purchase quantity (R²=0.000)
💡 58% customers want discounts — only 25.7% transactions have them
```

---

## 📁 Repository Structure

```
📦 lakshmi-supermarket-analytics/
│
├── 📂 data/
│   ├── pd_sales_data.xlsx          # Product-level POS data (43,341 rows)
│   ├── TS_sales_data.xlsx          # Bill-level POS data (8,345 rows)
│   └── survey_responses.csv        # Primary survey data (109 respondents)
│
├── 📂 notebooks/
│   ├── capstone.ipynb              # Main EDA + Statistical Analysis notebook
│   └── survey_analysis.ipynb       # Survey data analysis notebook
│
├── 📂 sql/
│   ├── create_tables.sql           # Star schema table creation scripts
│   ├── create_indexes.sql          # Index creation scripts
│   ├── create_views.sql            # 9 Power BI views
│   └── business_queries.sql        # 10 business insight queries
│
├── 📂 charts/
│   ├── stat_01_correlation_matrix.png
│   ├── stat_02a_scatter_discount_qty.png
│   ├── stat_03_price_vs_margin.png
│   ├── stat_04_*_regression_*.png  # 5 regression charts
│   ├── stat_05_multiple_regression.png
│   ├── stat_06_anova.png
│   ├── stat_07_chi_square.png
│   ├── stat_08_rfm.png
│   └── survey_full_analysis.png
│
├── 📂 dashboard/
│   └── lakshmistore.pbix           # Power BI Dashboard file
│
├── 📂 report/
│   └── Capstone_Report.docx        # Full project report (5 chapters)
│
├── 📂 assets/
│   └── dashboard_*.png             # Dashboard screenshots
│
└── README.md
```

---

## 🗄️ SQL Star Schema Design

```
                    ┌─────────────┐
                    │  DimDate    │
                    │  (Date PK)  │
                    └──────┬──────┘
                           │
┌─────────────┐    ┌──────▼──────┐    ┌─────────────────┐
│ DimProduct  │    │  FactSales  │    │  DimTransaction  │
│(ProductID PK)├───┤(RecordNo PK)├────┤  (BillNo PK)     │
└─────────────┘    └──────┬──────┘    └─────────────────┘
                           │
                    ┌──────▼──────┐
                    │ RFMSegments │
                    │(BillNo PK)  │
                    └─────────────┘
```

**9 Views created for Power BI:**
`vw_ExecutiveSummary` | `vw_MonthlySales` | `vw_CategorySales` | `vw_TopProducts` |
`vw_PaymentAnalysis` | `vw_DayWiseSales` | `vw_DiscountAnalysis` | `vw_RFMSummary` | `vw_FullSalesDetail`

---

## 🚀 How to Run This Project

### Step 1 — Python Analysis
```bash
# Clone the repository
git clone https://github.com/yourusername/lakshmi-supermarket-analytics.git
cd lakshmi-supermarket-analytics

# Install required libraries
pip install pandas numpy matplotlib scipy openpyxl

# Open Jupyter Notebook
jupyter notebook notebooks/capstone.ipynb
```

### Step 2 — SQL Server Setup
```sql
-- Run in SSMS
-- 1. Create database
CREATE DATABASE LakshmiStore;

-- 2. Run table creation script
-- File: sql/create_tables.sql

-- 3. Import CSV files using SSMS Import Flat File
-- Files in: data/sql_import/

-- 4. Create indexes and views
-- Files: sql/create_indexes.sql, sql/create_views.sql
```

### Step 3 — Power BI Dashboard
```
1. Open dashboard/lakshmistore.pbix in Power BI Desktop
2. Update data source connection to your SQL Server:
   Server: YOUR_SERVER_NAME\SQLEXPRESS
   Database: LakshmiStore
3. Click Refresh
4. All 5 dashboard pages load automatically
```

---

## 📋 Survey Methodology

| Parameter | Details |
|-----------|---------|
| Survey Tool | Google Forms (25 questions) |
| Sample Size | 109 respondents |
| Sampling Method | Convenience sampling |
| Group 1 | Sri Lakshmi Supermarket customers (~65%) |
| Group 2 | General grocery consumers in Salem (~35%) |
| Sections | Demographics, Shopping Behaviour, Product Preferences, Discount Behaviour, Satisfaction |

---

## 📚 Project Report

The complete capstone report follows **Sona School of Business and Management** guidelines:

| Chapter | Title | Key Content |
|---------|-------|-------------|
| I | Introduction | Industry overview, company profile, problem statement |
| II | Concepts & Reviews | 6 concepts, 15 literature studies, research gap |
| III | Research Methodology | 2 primary + 3 secondary objectives, 5 hypotheses |
| IV | Analysis & Discussion | Univariate → Bivariate → Multivariate + Survey + Power BI |
| V | Findings & Conclusion | 20 findings, 9 suggestions, conclusion |

---

## 🏆 Findings Highlights

1. **Selling price** is the strongest predictor of sales (R²=0.917)
2. **Discounts have no significant effect** on quantity purchased
3. **January 2026** = peak month driven by Pongal festival demand
4. **Champions segment** (14.9%) generates average bill of ₹690
5. **Pricing** received lowest satisfaction score (3.40/5) — improvement needed
6. **Sunday** consistently highest revenue day across all 7 months
7. **40% UPI adoption** reflects strong digital payment penetration in Salem
8. **Pooja Items** — highest margin (17.64%) despite moderate revenue share

---

## 👤 Author

**Srikar S**
MBA Student | Sona School of Business and Management, Salem

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/your-profile)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/yourusername)

---

## 🙏 Acknowledgement

This project was completed under the guidance of **[Guide Name]**, [Designation], Department of Management Studies, Sona School of Business and Management, Salem.

---

## 📄 License

This project is submitted as part of academic requirements for the MBA programme at Sona School of Business and Management. All data belongs to Sri Lakshmi Supermarket, Salem.

---

<div align="center">

⭐ **If you found this project helpful, please give it a star!** ⭐

*Made with ❤️ using Python, SQL Server, and Power BI*

</div>
