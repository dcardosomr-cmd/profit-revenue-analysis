# Profit & Revenue Analysis
## Project Overview
This project provides a comprehensive SQL-based analysis of company profitability, revenue trends, and product performance. Using a sales database from a manufacturing company, this analysis explores various business metrics including profit margins, discount strategies, sales patterns, and product category performance to identify actionable business insights.

## Objectives
The primary objectives of this analysis are to:

1. **Analyze Revenue and Profitability**: Calculate total revenue, costs, and profit margins across different time periods
2. **Evaluate Product Performance**: Identify top-performing products and categories based on sales and profitability
3. **Study Discount Impact**: Examine how discount strategies affect sales volume and profit margins
4. **Identify Sales Patterns**: Discover seasonal trends, quarterly performance, and monthly variations
5. **Product Association Analysis**: Find frequently purchased product combinations for cross-selling opportunities
6. **Sales Drivers**: Understand customer buying reasons and motivations

## Key Analysis Areas
### 1. Revenue & Profit Analysis
- Total revenue, cost, and profit by year, quarter, and month
- Profit margin calculations at product and category levels
- Average profit margins across different product subcategories
- Monthly and quarterly rankings based on profitability

### 2. Discount Strategy Analysis
- Average discount percentages by product and category
- Frequency of discounts applied to each product
- Discount trends over time for top-selling products
- Impact of discounts on sales volume

### 3. Product Performance
- Total quantity of items sold over time
- Top-performing products by revenue and profit
- Best and worst profit margin subcategories
- Product category sales rankings

### 4. Sales Pattern Analysis
- Sales volume by month and year
- Ratio of discounted items to total items sold
- Average product prices by year
- Number of sales by purchase reason

### 5. Market Basket Analysis
- Frequently purchased product pairs
- Product category associations
- Cross-selling opportunities

## Repository Structure
```
profit-revenue-analysis/
├── sql/
│   └── Relatorio-Interno-SQL-P1.sql    # Main SQL queries for analysis
├── README.md                            # Project documentation
└── .gitignore                          # Git ignore file
```

## 🛠️ Technologies Used

- **SQL Server**: Database management and query execution
- **T-SQL**: Query language for data analysis
- **Window Functions**: For ranking and comparative analysis
- **Common Table Expressions (CTEs)**: For complex query organization
- **Aggregate Functions**: For statistical calculations

## 📈 Key Findings

### Profitability Insights
- Identified profit margin variations across product categories
- Discovered top 5 product subcategories with highest margins
- Found bottom 4 subcategories requiring attention
- Calculated overall company profit margin percentage

### Discount Strategy Insights
- Measured discount frequency and average discount rates
- Analyzed correlation between discount application and sales volume
- Identified products most sensitive to discounting

### Sales Trends
- Tracked revenue growth/decline across years
- Identified seasonal patterns and peak sales periods
- Ranked quarters by profitability
- Analyzed sales by purchase motivation (promotions, reviews, etc.)

### Product Associations
- Discovered top 10 frequently co-purchased product pairs
- Identified cross-category buying patterns
- Uncovered opportunities for product bundling

## 🚀 How to Use

1. **Database Setup**: Ensure you have access to a SQL Server database with the AdventureWorks schema or similar sales data structure
2. **Run Queries**: Execute the SQL queries in `Relatorio-Interno-SQL-P1.sql` sequentially
3. **Panel Table Creation**: Start by creating the PanelTableV1, which serves as the foundation for all subsequent analyses
4. **Generate Insights**: Run specific query sections based on your analysis needs

## 📊 Query Categories

The SQL file is organized into the following sections:

1. **Panel Table Creation**: Creates a consolidated view joining sales orders, products, and categories
2. **Revenue/Profit Queries**: Total and time-based profitability analysis
3. **Discount Analysis**: Queries focused on discount patterns and effectiveness
4. **Sales Volume**: Item quantity and sales count analysis
5. **Margin Analysis**: Profit margin calculations at various levels
6. **Ranking Queries**: Monthly and quarterly performance rankings
7. **Additional Insights**: Sales reasons, price trends, and product associations

## 💡 Business Applications

These analyses can be used to:

- **Optimize Pricing Strategies**: Adjust prices based on margin analysis and discount effectiveness
- **Improve Inventory Management**: Focus on high-margin, high-volume products
- **Design Promotions**: Create targeted discount campaigns based on historical effectiveness
- **Product Bundling**: Leverage product association insights for bundle offers
- **Resource Allocation**: Invest in categories and subcategories with best performance
- **Sales Forecasting**: Use historical trends to predict future performance

## Conclusions
This comprehensive profit and revenue analysis provides actionable insights into:

- **Product profitability** varies significantly by category and subcategory, with some products generating substantially higher margins
- **Discount strategies** show mixed results - while increasing sales volume, they can significantly impact profit margins
- **Seasonal patterns** exist in sales data, allowing for better inventory and staffing planning
- **Product associations** reveal cross-selling opportunities that can increase average order value
- **Sales motivations** like promotions and reviews drive significant portions of revenue

The analysis enables data-driven decision-making for pricing, inventory, marketing, and product strategy, ultimately supporting improved profitability and revenue growth.

## License
This project is available for educational and analytical purposes.

## Author
**dcardosomr-cmd**

For questions or collaboration opportunities, please reach out through GitHub.

---

*Last Updated: January 2026*
