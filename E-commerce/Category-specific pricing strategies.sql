SELECT 
    category,
    AVG(discounted_price) AS avg_price,
    AVG(discount_percentage) AS avg_discount,
    AVG(rating_count) AS avg_sales
FROM products
GROUP BY category
ORDER BY avg_sales DESC
LIMIT 10;
