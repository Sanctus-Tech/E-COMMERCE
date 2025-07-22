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
