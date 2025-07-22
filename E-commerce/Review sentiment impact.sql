SELECT 
    CASE
        WHEN review_content ~* 'excellent|great|awesome|perfect' THEN 'positive'
        WHEN review_content ~* 'poor|bad|terrible|disappointing' THEN 'negative'
        ELSE 'neutral'
    END AS sentiment,
    AVG(rating_count) AS avg_sales,
    AVG(rating) AS avg_rating
FROM products
WHERE review_content IS NOT NULL
GROUP BY sentiment;
