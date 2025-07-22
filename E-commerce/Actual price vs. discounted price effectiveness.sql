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

