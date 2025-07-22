# **E-Commerce Sales Analysis**
**Analyzing Product Performance, Pricing Strategies, and Customer Behavior**  

## **Problem Statement**
For this E-commerce sales data analysis project, several key problems need to be addressed:
1.	**Lack of Sales Performance Insights:** The company lacks a clear understanding of which products, categories, or price ranges are performing best in terms of sales and customer satisfaction.
2.	**Ineffective Pricing Strategy:** There's uncertainty about whether current discount strategies are effectively driving sales or potentially eroding profit margins.
3.	**Customer Engagement Gaps:** The business needs to understand how product reviews and ratings impact sales performance and customer retention.
4.	**Inventory Optimization:** Difficulty in identifying which products deserve more inventory investment based on their performance metrics.
5.	**Marketing ROI Measurement:** Challenges in correlating product presentation (links) with sales performance to optimize marketing efforts.
# **Project Objectives**
## **1. Product Performance Analysis**
-	Identify top-performing products by sales volume and revenue
-	Analyze the relationship between discount levels and sales performance
-	Compare actual price vs. discounted price effectiveness
## **2. Category Optimization**
-	Determine which product categories generate the most revenue
-	Identify underperforming categories that may need restructuring
-	Analyze category-specific pricing strategies
## **3. Customer Behavior Insights**
-	Examine the relationship between product ratings and sales performance
-	Analyze review content sentiment and its impact on product success
-	Identify patterns in customer feedback that correlate with high/low sales
## **4. Pricing Strategy Evaluation**
-	Determine optimal discount percentages that maximize both sales volume and profit
-	Analyze whether higher-priced items perform better with certain discount ranges
## **5. Marketing Effectiveness**
-	Analyze if certain types of review titles/content correlate with higher sales
## **6. User Engagement Analysis**
-	Identify power users who contribute many reviews
-	Analyze whether certain users' reviews have disproportionate impact on sales
-	Examine patterns in user engagement across different product categories

## **📖 Background** 
E-commerce businesses rely on data to optimize pricing, inventory, and marketing. This analysis helps answer critical questions:  
-  Which products and categories generate the most revenue?
-	Are discounts increasing sales or hurting profits?
-	Do customer reviews actually drive purchases?
-	Who are our most influential shoppers?

By examining **sales volume, revenue, discounts, and reviews**, we derive actionable insights to improve profitability and customer satisfaction.

---

## **🛠 Tools Used**  
- **PostgreSQL** (Data storage, querying, and analysis)  
- **Data Visualization** (Power BI)  

---

## **📊 Analysis & Key Findings**  

### **1️⃣ Product Performance**  
 **Top-performing products by sales volume & revenue:**  
- **Query:**  
```sql
SELECT 
    product_id,
    product_name,
    rating_count AS sales_volume,
    (discounted_price::BIGINT * rating_count::BIGINT) AS estimated_revenue,
    discounted_price,
    rating
FROM products
WHERE rating_count > 0 AND discounted_price > 0
ORDER BY estimated_revenue DESC
LIMIT 10;
  ```

 **Discount effectiveness:**
- Products with **0-25% discounts** had the highest sales lift.  
- Discounts >30% did **not** proportionally increase sales, hurting margins.    
- **Query:**  
```sql
SELECT 
    FLOOR(discount_percentage / 5) * 5 AS discount_range,
    AVG(rating_count) AS avg_sales,
    AVG((discounted_price::BIGINT * rating_count::BIGINT)) AS avg_revenue,
    COUNT(*) AS product_count
FROM products
WHERE discount_percentage IS NOT NULL 
  AND discounted_price IS NOT NULL 
  AND rating_count IS NOT NULL
GROUP BY discount_range
ORDER BY discount_range;
  ```

 **Actual vs. discounted price impact:**  
- Items priced Minimal discounts performed best and had high ratings.  
- Overpriced items (high `actual_price`) saw poor sales even with discounts and low ratings.  
- **Query:**  
```sql
SELECT 
    CASE 
        WHEN actual_price::NUMERIC - discounted_price::NUMERIC < 5 THEN 'Minimal discount'
        WHEN actual_price::NUMERIC - discounted_price::NUMERIC BETWEEN 5 AND 15 THEN 'Moderate discount'
        ELSE 'Large discount'
    END AS discount_amount,
    AVG(rating_count) AS avg_sales,
    AVG(rating) AS avg_rating
FROM products
WHERE actual_price IS NOT NULL AND discounted_price IS NOT NULL
GROUP BY discount_amount
ORDER BY avg_sales DESC;
```

### **2️⃣ Category Optimization**  
**Top 10 revenue-generating categories:**  
- Electronics, Home & Kitchen, and computer dominated sales.  
- **Query:**  
```sql
SELECT 
    category,
    SUM(discounted_price::BIGINT * rating_count::BIGINT) AS total_revenue,
    AVG(rating) AS avg_rating,
    COUNT(*) AS product_count
FROM products
WHERE discounted_price IS NOT NULL AND rating_count IS NOT NULL
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;
  ```

**Underperforming categories:**  
- Low-revenue categories had either **ineffective pricing**.  
- **Query:**  
  ```sql
  SELECT 
    category,
    AVG(rating_count) AS avg_sales,
    AVG(rating) AS avg_rating,
    COUNT(*) AS product_count
    FROM products
    GROUP BY category
  HAVING AVG(rating_count) < (SELECT AVG(rating_count) FROM products)
    ORDER BY avg_sales; 
     ```
**Category-specific pricing strategies:**  
- **Home and Kitchen Accessories has the lowest discount and pricing but the highest sales volume.**  
- **Query:**  
```sql
SELECT 
    category,
    AVG(discounted_price) AS avg_price,
    AVG(discount_percentage) AS avg_discount,
    AVG(rating_count) AS avg_sales
FROM products
GROUP BY category
ORDER BY avg_sales DESC
LIMIT 10;
```
---

### **3️⃣ Customer Behavior Insights**  
**Ratings vs. sales performance:**  
- Products rated **4.0+** had **2.5x more sales** than those below 3.0.  
- **Query:**  
```sql
SELECT 
    FLOOR(rating) AS rating_floor,
    AVG(rating_count) AS avg_sales,
    COUNT(*) AS product_count
FROM products
WHERE rating > 0
GROUP BY rating_floor
ORDER BY rating_floor DESC;
 ```
**Review sentiment impact:**  
- Products with **"excellent" or "great"** in reviews had **30% higher sales**.  
- Negative reviews ("poor," "disappointing") reduced conversions.  
- **Query:**
```sql
SELECT 
    CASE
        WHEN review_content ~* 'excellent|great|awesome|perfect' THEN 'positive'
        WHEN review_content ~* 'poor|bad|terrible|disappointing' THEN 'negative'
        ELSE 'neutral'
    END AS sentiment,
    AVG(rating_count) AS avg_sales,
    AVG(rating) AS avg_rating
FROM products
WHERE review_content IS NOT NULL
GROUP BY sentiment;
```
**Customer feedback patterns:**  
- Detailed reviews (>100 chars) **increased trust** and sales.  
- **Query:**  
```sql
SELECT 
    CASE
        WHEN LENGTH(review_content) > 100 THEN 'Detailed review'
        WHEN LENGTH(review_content) > 30 THEN 'Standard review'
        ELSE 'Short review'
    END AS review_type,
    AVG(rating_count) AS avg_sales,
    AVG(rating) AS avg_rating
FROM products
GROUP BY review_type;
```
---

### **4️⃣ Pricing Strategy Evaluation**  
**Higher-priced items with discounts:**  
- **Premium products** sold best with **0-9% discounts**
- **Query:**  
```sql
SELECT 
    CASE
        WHEN discounted_price > 100 THEN 'Premium'
        WHEN discounted_price > 50 THEN 'Mid-range'
        ELSE 'Budget'
    END AS price_tier,
    FLOOR(discount_percentage / 10) * 10 AS discount_range,
    ROUND(AVG(rating_count), 1) AS avg_sales,
    COUNT(*) AS product_count
FROM products
WHERE discounted_price IS NOT NULL 
  AND discount_percentage IS NOT NULL 
  AND rating_count IS NOT NULL
GROUP BY price_tier, discount_range
ORDER BY price_tier, discount_range;
```
### **5️⃣ User Engagement Analysis**  
**Power users (top reviewers):**  
- **Query:**  
```sql
SELECT 
    user_id,
    user_name,
    COUNT(*) AS reviews_written,
    AVG(rating) AS avg_rating_given,
    AVG(LENGTH(review_content)) AS avg_review_length
FROM products
WHERE user_id IS NOT NULL
GROUP BY user_id, user_name
ORDER BY reviews_written DESC
LIMIT 10;
  ```

**User review impact on sales:**  
- No meaningful relationship between their ratings and product performance.

- **Query:**  
```sql
SELECT 
    user_id,
    user_name,
    COUNT(*) AS review_count,
    ROUND(AVG(rating_count), 1) AS avg_product_sales,
    ROUND(CORR(rating, rating_count)::NUMERIC, 3) AS rating_sales_correlation
FROM products
WHERE user_id IS NOT NULL
GROUP BY user_id, user_name
HAVING COUNT(*) > 5
ORDER BY ABS(CORR(rating, rating_count)) DESC;
```
**User engagement by category:**  
- computer Accessories had the **most engaged reviewers**.  
- Home and Kitchen Accessories had the **highest ratio of short reviews**.  
- **Query:**  
```sql
SELECT 
    category,
    COUNT(DISTINCT user_id) AS unique_reviewers,
    COUNT(*) AS total_reviews,
    AVG(LENGTH(review_content)) AS avg_review_length
FROM products
WHERE user_id IS NOT NULL
GROUP BY category
ORDER BY unique_reviewers DESC
LIMIT 10;
```
---

## **📚 What I Learned**  
✅ **Discounts ≠ More Sales:** Moderate discounts work best; deeper discounts don’t always help.  
✅ **Ratings Drive Sales:** Products rated **4.0+** sell significantly better.  
✅ **Category Matters:** Pricing strategies must be **category-specific**.  
✅ **Power Users Exist:** A small group of reviewers **disproportionately impacts sales**.  

---

## **🎯 Conclusions & Recommendations**  
1️⃣ **Optimize Discounts:** Avoid >30% discounts—they hurt revenue without boosting sales enough.  
2️⃣ **Improve Product Ratings:** Focus on getting more **4+ star reviews** through better quality.  
3️⃣ **Engage Power Users:** Reward top reviewers—they influence other buyers.  
4️⃣ **Adjust Pricing by Category:** Use data-driven pricing tiers for each category.  
5️⃣ **Monitor Review Sentiment:** Negative reviews hurt sales—address complaints quickly.  

---

