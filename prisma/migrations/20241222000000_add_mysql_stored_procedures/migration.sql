-- MySQL Stored Procedures to replace PostgreSQL functions
-- These replicate the functionality of the original PostgreSQL stored procedures

DELIMITER //

-- Get dashboard metrics (equivalent to PostgreSQL get_dashboard_metrics)
CREATE PROCEDURE get_dashboard_metrics(
    IN p_user_id INT,
    IN p_running_avg VARCHAR(10)
)
BEGIN
    DECLARE days_count INT DEFAULT 0;
    DECLARE avg_hours DECIMAL(5,2) DEFAULT 0.0;
    DECLARE total_hours DECIMAL(10,2) DEFAULT 0.0;
    DECLARE total_entries INT DEFAULT 0;
    DECLARE neg_two_count INT DEFAULT 0;
    DECLARE neg_one_count INT DEFAULT 0;
    DECLARE zero_count INT DEFAULT 0;
    DECLARE plus_one_count INT DEFAULT 0;
    DECLARE plus_two_count INT DEFAULT 0;
    DECLARE start_date DATE;

    -- Calculate start date (p_running_avg days ago)
    SET start_date = DATE_SUB(CURDATE(), INTERVAL CAST(p_running_avg AS UNSIGNED) DAY);

    -- Get trackers for the user within the date range
    SELECT
        COUNT(DISTINCT DATE(created_at)) as days_of_use,
        COALESCE(AVG(number_creative_hours), 0) as avg_hours,
        COALESCE(SUM(number_creative_hours), 0) as total_hours,
        COUNT(*) as total_entries
    INTO days_count, avg_hours, total_hours, total_entries
    FROM wp_cracker_tracker
    WHERE user = p_user_id
    AND DATE(created_at) >= start_date;

    -- Count ratings
    SELECT
        COUNT(CASE WHEN rating = -2 THEN 1 END),
        COUNT(CASE WHEN rating = -1 THEN 1 END),
        COUNT(CASE WHEN rating = 0 THEN 1 END),
        COUNT(CASE WHEN rating = 1 THEN 1 END),
        COUNT(CASE WHEN rating = 2 THEN 1 END)
    INTO neg_two_count, neg_one_count, zero_count, plus_one_count, plus_two_count
    FROM wp_cracker_tracker
    WHERE user = p_user_id
    AND DATE(created_at) >= start_date;

    -- Return the results
    SELECT
        days_count as _days_of_use,
        ROUND(avg_hours, 2) as _avg_hours,
        neg_two_count as _count_neg_two,
        neg_one_count as _count_neg_one,
        zero_count as _count_zero,
        plus_one_count as _count_plus_one,
        plus_two_count as _count_plus_two;
END //

-- Get dashboard words (equivalent to PostgreSQL get_dashboard_words)
CREATE PROCEDURE get_dashboard_words(
    IN p_user_id INT,
    IN p_running_avg VARCHAR(10),
    IN p_rating_filter JSON,
    IN p_min_hours DECIMAL(3,1),
    IN p_max_hours DECIMAL(3,1),
    IN p_sort_column VARCHAR(50),
    IN p_sort_dir VARCHAR(4)
)
BEGIN
    DECLARE start_date DATE;
    DECLARE done INT DEFAULT FALSE;
    DECLARE word_text VARCHAR(50);
    DECLARE word_count INT;
    DECLARE days_used INT;
    DECLARE cur CURSOR FOR
        SELECT
            word,
            COUNT(*) as count,
            COUNT(DISTINCT DATE(t.created_at)) as days_used
        FROM wp_cracker_word w
        JOIN wp_cracker_tracker t ON w.tracker = t.id
        WHERE t.user = p_user_id
        AND DATE(t.created_at) >= start_date
        AND (p_rating_filter IS NULL OR JSON_CONTAINS(p_rating_filter, CAST(t.rating AS CHAR)))
        AND (p_min_hours IS NULL OR t.number_creative_hours >= p_min_hours)
        AND (p_max_hours IS NULL OR t.number_creative_hours <= p_max_hours)
        GROUP BY w.word
        HAVING COUNT(*) > 0;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET start_date = DATE_SUB(CURDATE(), INTERVAL CAST(p_running_avg AS UNSIGNED) DAY);

    -- Create temporary table for results
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_words (
        word VARCHAR(50),
        count INT,
        days_used INT
    );

    DELETE FROM temp_words;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO word_text, word_count, days_used;
        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO temp_words (word, count, days_used) VALUES (word_text, word_count, days_used);
    END LOOP;

    CLOSE cur;

    -- Apply sorting and return results
    SET @sql = CONCAT('SELECT * FROM temp_words ORDER BY ',
                     CASE
                         WHEN p_sort_column = 'word' THEN 'word'
                         WHEN p_sort_column = 'count' THEN 'count'
                         WHEN p_sort_column = 'mentions' THEN 'days_used'
                         ELSE 'count'
                     END,
                     ' ',
                     CASE
                         WHEN p_sort_dir = 'desc' THEN 'DESC'
                         ELSE 'ASC'
                     END);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    DROP TEMPORARY TABLE temp_words;
END //

-- Get dashboard sentences (equivalent to PostgreSQL get_dashboard_sentences)
CREATE PROCEDURE get_dashboard_sentences(
    IN p_user_id INT,
    IN p_running_avg VARCHAR(10),
    IN p_rating_filter JSON,
    IN p_min_hours DECIMAL(3,1),
    IN p_max_hours DECIMAL(3,1),
    IN p_sort_column VARCHAR(50),
    IN p_sort_dir VARCHAR(4)
)
BEGIN
    DECLARE start_date DATE;
    DECLARE done INT DEFAULT FALSE;
    DECLARE sentence_text TEXT;
    DECLARE tracker_rating INT;
    DECLARE creative_hours DECIMAL(3,1);
    DECLARE created_date DATE;
    DECLARE overview_text TEXT;
    DECLARE tracker_id INT;
    DECLARE cur CURSOR FOR
        SELECT
            t.id,
            t.rating,
            t.number_creative_hours,
            t.created_at,
            t.overview
        FROM wp_cracker_tracker t
        WHERE t.user = p_user_id
        AND DATE(t.created_at) >= start_date
        AND (p_rating_filter IS NULL OR JSON_CONTAINS(p_rating_filter, CAST(t.rating AS CHAR)))
        AND (p_min_hours IS NULL OR t.number_creative_hours >= p_min_hours)
        AND (p_max_hours IS NULL OR t.number_creative_hours <= p_max_hours)
        ORDER BY
            CASE
                WHEN p_sort_column = 'createdAt' AND p_sort_dir = 'desc' THEN t.created_at
                WHEN p_sort_column = 'createdAt' AND p_sort_dir = 'asc' THEN t.created_at
                WHEN p_sort_column = 'rating' AND p_sort_dir = 'desc' THEN t.rating
                WHEN p_sort_column = 'rating' AND p_sort_dir = 'asc' THEN t.rating
                WHEN p_sort_column = 'numberCreativeHours' AND p_sort_dir = 'desc' THEN t.number_creative_hours
                WHEN p_sort_column = 'numberCreativeHours' AND p_sort_dir = 'asc' THEN t.number_creative_hours
                ELSE t.created_at
            END DESC;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET start_date = DATE_SUB(CURDATE(), INTERVAL CAST(p_running_avg AS UNSIGNED) DAY);

    -- Create temporary table for results
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_sentences (
        sentence TEXT,
        rating INT,
        number_creative_hours DECIMAL(3,1),
        created_at DATE,
        overview TEXT,
        tracker_id INT
    );

    DELETE FROM temp_sentences;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO tracker_id, tracker_rating, creative_hours, created_date, overview_text;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Extract first sentence from overview (split by periods, questions, exclamations)
        SET sentence_text = SUBSTRING_INDEX(overview_text, '.', 1);

        -- If no sentence found or too short, use overview
        IF LENGTH(TRIM(sentence_text)) < 10 THEN
            SET sentence_text = overview_text;
        END IF;

        INSERT INTO temp_sentences (sentence, rating, number_creative_hours, created_at, overview, tracker_id)
        VALUES (sentence_text, tracker_rating, creative_hours, created_date, overview_text, tracker_id);
    END LOOP;

    CLOSE cur;

    -- Return results
    SELECT
        sentence,
        rating,
        number_creative_hours,
        created_at,
        overview,
        tracker_id as id
    FROM temp_sentences;

    DROP TEMPORARY TABLE temp_sentences;
END //

-- Get user info (equivalent to PostgreSQL get_user_info)
CREATE PROCEDURE get_user_info(IN p_user_id INT)
BEGIN
    SELECT
        u.id,
        u.username,
        u.email,
        u.role,
        t.id as last_post_id,
        t.overview as last_post_overview,
        t.number_creative_hours as last_post_hours,
        t.rating as last_post_rating,
        t.created_at as last_post_date
    FROM wp_cracker_user u
    LEFT JOIN wp_cracker_tracker t ON u.id = t.user
        AND t.created_at = (
            SELECT MAX(created_at)
            FROM wp_cracker_tracker
            WHERE user = u.id
        )
    WHERE u.id = p_user_id;
END //

DELIMITER ;
