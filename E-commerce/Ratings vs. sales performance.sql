SELECT 
    FLOOR(rating) AS rating_floor,
    AVG(rating_count) AS avg_sales,
    COUNT(*) AS product_count
FROM products
WHERE rating > 0
GROUP BY rating_floor
ORDER BY rating_floor DESC;
