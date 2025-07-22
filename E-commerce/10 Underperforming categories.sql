SELECT 
    category,
    AVG(rating_count) AS avg_sales,
    AVG(rating) AS avg_rating,
    COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING AVG(rating_count) < (SELECT AVG(rating_count) FROM products)
ORDER BY avg_sales;
