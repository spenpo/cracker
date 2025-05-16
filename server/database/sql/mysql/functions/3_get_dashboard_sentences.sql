DELIMITER //

CREATE FUNCTION get_dashboard_sentences(
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
                'sentence', sentence,
                'created_at', created_at,
                'number_creative_hours', number_creative_hours,
                'rating', rating,
                'user', `user`
            )
        )
        FROM (
            SELECT *
            FROM dashboard_sentences
            WHERE 
                `user` = p_user_id
                AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY)
                AND FIND_IN_SET(rating, JSON_UNQUOTE(v_ratings))
                AND number_creative_hours BETWEEN p_min_hours AND p_max_hours
            ORDER BY
                CASE 
                    WHEN p_sort_column = 'sentence' AND p_sort_dir = 'asc' THEN sentence
                    WHEN p_sort_column = 'hours' AND p_sort_dir = 'asc' THEN number_creative_hours
                    WHEN p_sort_column = 'rating' AND p_sort_dir = 'asc' THEN rating
                    WHEN p_sort_column = 'date' AND p_sort_dir = 'asc' THEN created_at
                END ASC,
                CASE 
                    WHEN p_sort_column = 'sentence' AND p_sort_dir = 'desc' THEN sentence
                    WHEN p_sort_column = 'hours' AND p_sort_dir = 'desc' THEN number_creative_hours
                    WHEN p_sort_column = 'rating' AND p_sort_dir = 'desc' THEN rating
                    WHEN p_sort_column = 'date' AND p_sort_dir = 'desc' THEN created_at
                END DESC
        ) subquery
    );
END//

DELIMITER ; 