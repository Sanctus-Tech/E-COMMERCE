SELECT 
    user_id,
    user_name,
    COUNT(*) AS reviews_written,
    AVG(rating) AS avg_rating_given,
    AVG(LENGTH(review_content)) AS avg_review_length
FROM products
WHERE user_id IS NOT NULL
GROUP BY user_id, user_name
ORDER BY reviews_written DESC
LIMIT 10;
