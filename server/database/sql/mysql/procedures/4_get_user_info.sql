DELIMITER //

CREATE PROCEDURE get_user_info(
    IN p_user_id INT,
    OUT p_email VARCHAR(255),
    OUT p_username VARCHAR(255),
    OUT p_role VARCHAR(50),
    OUT p_id INT,
    OUT p_last_post_date DATETIME,
    OUT p_last_post_id INT,
    OUT p_last_post_overview TEXT,
    OUT p_last_post_hours DECIMAL(10,2),
    OUT p_last_post_rating INT
)
BEGIN
    -- Get user info
    SELECT id, email, role, username
    INTO p_id, p_email, p_role, p_username
    FROM `user`
    WHERE id = p_user_id;

    -- Get last post info
    SELECT 
        tracker.id,
        tracker.overview,
        tracker.number_creative_hours,
        tracker.rating,
        tracker.created_at
    INTO 
        p_last_post_id,
        p_last_post_overview,
        p_last_post_hours,
        p_last_post_rating,
        p_last_post_date
    FROM tracker
    INNER JOIN (
        SELECT MAX(created_at) as created_at
        FROM tracker
        WHERE `user` = p_user_id
    ) last_post ON tracker.created_at = last_post.created_at;
END//

DELIMITER ; 