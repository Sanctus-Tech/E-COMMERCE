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
