DELIMITER //

CREATE FUNCTION get_dashboard_words(
    p_user_id INT,
    p_running_avg VARCHAR(255),
    p_rating JSON,
    p_min_hours DECIMAL(10,2),
    p_max_hours DECIMAL(10,2),
    p_sort_column VARCHAR(50),
    p_sort_dir VARCHAR(4)
) 
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE v_ratings JSON;
    SET v_ratings = COALESCE(p_rating, JSON_ARRAY(-2, -1, 0, 1, 2));
    
    RETURN (
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'word', word,
                'count', word_count,
                'days_used', days_used
            )
        )
        FROM (
            SELECT 
                word,
                COUNT(*) as word_count,
                GROUP_CONCAT(DISTINCT tracker) as days_used
            FROM tracker 
            JOIN word ON tracker.id = word.tracker
            WHERE 
                `user` = p_user_id
                AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY)
                AND FIND_IN_SET(rating, JSON_UNQUOTE(v_ratings))
                AND number_creative_hours BETWEEN p_min_hours AND p_max_hours
            GROUP BY word.word
            ORDER BY
                CASE 
                    WHEN p_sort_column = 'count' AND p_sort_dir = 'asc' THEN COUNT(*)
                    WHEN p_sort_column = 'word' AND p_sort_dir = 'asc' THEN word
                END ASC,
                CASE 
                    WHEN p_sort_column = 'count' AND p_sort_dir = 'desc' THEN COUNT(*)
                    WHEN p_sort_column = 'word' AND p_sort_dir = 'desc' THEN word
                END DESC
        ) subquery
    );
END//

DELIMITER ; 