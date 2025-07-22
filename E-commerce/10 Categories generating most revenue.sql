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
