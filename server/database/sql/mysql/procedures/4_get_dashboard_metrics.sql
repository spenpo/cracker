DELIMITER //

CREATE PROCEDURE get_dashboard_metrics(
    IN p_user_id INT,
    IN p_running_avg VARCHAR(255),
    OUT p_days_of_use INT,
    OUT p_avg_hours DECIMAL(10,2),
    OUT p_count_neg_two INT,
    OUT p_count_neg_one INT,
    OUT p_count_zero INT,
    OUT p_count_plus_one INT,
    OUT p_count_plus_two INT
)
BEGIN
    -- Total days of use
    SELECT COUNT(*)
    INTO p_days_of_use
    FROM tracker
    WHERE `user` = p_user_id;

    -- Creative hours average
    SELECT AVG(number_creative_hours)
    INTO p_avg_hours
    FROM tracker
    WHERE `user` = p_user_id
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    -- Rating counts
    SELECT COUNT(*)
    INTO p_count_neg_two
    FROM tracker
    WHERE `user` = p_user_id
    AND rating = -2
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    SELECT COUNT(*)
    INTO p_count_neg_one
    FROM tracker
    WHERE `user` = p_user_id
    AND rating = -1
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    SELECT COUNT(*)
    INTO p_count_zero
    FROM tracker
    WHERE `user` = p_user_id
    AND rating = 0
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    SELECT COUNT(*)
    INTO p_count_plus_one
    FROM tracker
    WHERE `user` = p_user_id
    AND rating = 1
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    SELECT COUNT(*)
    INTO p_count_plus_two
    FROM tracker
    WHERE `user` = p_user_id
    AND rating = 2
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);
END//

DELIMITER ; 