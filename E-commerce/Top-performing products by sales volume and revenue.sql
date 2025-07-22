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
