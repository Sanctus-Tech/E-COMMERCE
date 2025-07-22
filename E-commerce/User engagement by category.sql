SELECT 
    category,
    COUNT(DISTINCT user_id) AS unique_reviewers,
    COUNT(*) AS total_reviews,
    AVG(LENGTH(review_content)) AS avg_review_length
FROM products
WHERE user_id IS NOT NULL
GROUP BY category
ORDER BY unique_reviewers DESC
LIMIT 10;
