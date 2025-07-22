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
