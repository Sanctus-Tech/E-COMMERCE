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
