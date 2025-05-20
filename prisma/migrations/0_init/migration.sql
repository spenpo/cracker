-- Cracker Baseline Migration 2025-05-20
-- CreateTable
CREATE TABLE `wp_cracker_feature_flag` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `is_enabled` BOOLEAN NOT NULL DEFAULT false,
    `required_role` INTEGER NULL,

    UNIQUE INDEX `wp_cracker_feature_flag_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wp_cracker_role_lookup` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL,
    `description` VARCHAR(255) NOT NULL,

    UNIQUE INDEX `wp_cracker_role_lookup_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wp_cracker_sentence` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `sentence` VARCHAR(512) NOT NULL,
    `tracker` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wp_cracker_tracker` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `overview` VARCHAR(512) NOT NULL,
    `number_creative_hours` DECIMAL(3, 1) NOT NULL,
    `rating` SMALLINT NOT NULL,
    `created_at` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `user` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wp_cracker_user` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `created_at` TIMESTAMP(6) NULL DEFAULT CURRENT_TIMESTAMP(6),
    `updated_at` TIMESTAMP(6) NULL DEFAULT CURRENT_TIMESTAMP(6),
    `role` INTEGER NULL DEFAULT 1,

    UNIQUE INDEX `wp_cracker_user_username_key`(`username`),
    UNIQUE INDEX `wp_cracker_user_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wp_cracker_word` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `word` VARCHAR(50) NOT NULL,
    `tracker` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `wp_cracker_feature_flag` ADD CONSTRAINT `wp_cracker_feature_flag_required_role_fkey` FOREIGN KEY (`required_role`) REFERENCES `wp_cracker_role_lookup`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `wp_cracker_sentence` ADD CONSTRAINT `wp_cracker_sentence_tracker_fkey` FOREIGN KEY (`tracker`) REFERENCES `wp_cracker_tracker`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `wp_cracker_tracker` ADD CONSTRAINT `wp_cracker_tracker_user_fkey` FOREIGN KEY (`user`) REFERENCES `wp_cracker_user`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `wp_cracker_user` ADD CONSTRAINT `wp_cracker_user_role_fkey` FOREIGN KEY (`role`) REFERENCES `wp_cracker_role_lookup`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `wp_cracker_word` ADD CONSTRAINT `wp_cracker_word_tracker_fkey` FOREIGN KEY (`tracker`) REFERENCES `wp_cracker_tracker`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

INSERT INTO `wp_cracker_role_lookup` (`id`, `name`, `description`) VALUES
(1, 'member', 'default role. basic member. access to free features'),
(2, 'premium', 'paid member. access to premium features'),
(3, 'admin', 'administrator. access to admin only features');

INSERT INTO `wp_cracker_feature_flag` (`id`, `name`, `description`, `is_enabled`, `required_role`) VALUES
(1, 'premiumDashboardSwitch', 'a switch that changes state from basic to premium dashboard. brings up upgrade popup for basic members', 0, NULL),
(2, 'adminDashboardMenuItem', 'option in user menu that navigates to admin dashboard', 1, 3);

CREATE TRIGGER delete_sentences
AFTER INSERT ON wp_cracker_tracker
FOR EACH ROW
BEGIN
    DELETE FROM sentence WHERE tracker = NEW.id;
END;

CREATE TRIGGER delete_words 
AFTER INSERT ON wp_cracker_tracker 
FOR EACH ROW 
BEGIN 
    DELETE FROM word WHERE tracker = NEW.id; 
END;

CREATE TRIGGER insert_sentences 
AFTER INSERT ON wp_cracker_tracker 
FOR EACH ROW 
BEGIN 
    INSERT INTO wp_cracker_sentence (sentence, tracker) 
    SELECT sentence, NEW.id as tracker 
    FROM (
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.overview, '.', numbers.n), '.', -1)) as sentence 
        FROM (
            SELECT a.N + b.N * 10 + 1 n 
            FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a 
            CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b 
            ORDER BY n
        ) numbers 
        WHERE numbers.n <= 1 + (LENGTH(NEW.overview) - LENGTH(REPLACE(NEW.overview, '.', '')))
    ) sentences 
    WHERE sentence != '';
END;

CREATE TRIGGER insert_words 
AFTER INSERT ON wp_cracker_tracker 
FOR EACH ROW 
BEGIN 
    INSERT INTO wp_cracker_word (word, tracker) 
    SELECT word, NEW.id as tracker 
    FROM (
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.overview, ' ', numbers.n), ' ', -1)) as word 
        FROM (
            SELECT a.N + b.N * 10 + 1 n 
            FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a 
            CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b 
            ORDER BY n
        ) numbers 
        WHERE numbers.n <= 1 + (LENGTH(NEW.overview) - LENGTH(REPLACE(NEW.overview, ' ', '')))
    ) words 
    WHERE word != '';
END;

CREATE TRIGGER set_timestamp 
BEFORE UPDATE ON wp_cracker_tracker 
FOR EACH ROW 
BEGIN 
    SET NEW.updated_at = NOW(); 
END;

CREATE OR REPLACE VIEW dashboard_sentences AS SELECT sentence.sentence, tracker.overview, tracker.number_creative_hours, tracker.rating, tracker.created_at, tracker.user FROM wp_cracker_tracker tracker JOIN wp_cracker_sentence sentence ON tracker.id = sentence.tracker;
CREATE OR REPLACE VIEW dashboard_words AS SELECT word.word, tracker.overview, tracker.number_creative_hours, tracker.rating, tracker.created_at, tracker.user FROM wp_cracker_tracker tracker JOIN wp_cracker_word word ON tracker.id = word.tracker;

CREATE FUNCTION get_dashboard_sentences(
    p_user_id INT,
    p_running_avg VARCHAR(255),
    p_rating JSON,
    p_min_hours DECIMAL(10,2),
    p_max_hours DECIMAL(10,2),
    p_sort_column VARCHAR(50),
    p_sort_dir VARCHAR(4)
) RETURNS TEXT DETERMINISTIC
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
            WHERE `user` = p_user_id
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
END;

CREATE FUNCTION get_dashboard_words(
    p_user_id INT,
    p_running_avg VARCHAR(255),
    p_rating JSON,
    p_min_hours DECIMAL(10,2),
    p_max_hours DECIMAL(10,2),
    p_sort_column VARCHAR(50),
    p_sort_dir VARCHAR(4)
) RETURNS TEXT DETERMINISTIC
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
            SELECT word, COUNT(*) as word_count, GROUP_CONCAT(DISTINCT tracker) as days_used
            FROM wp_cracker_tracker tracker
            JOIN wp_cracker_word word ON tracker.id = word.tracker
            WHERE `user` = p_user_id
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
END;

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
    SELECT COUNT(*) INTO p_days_of_use
    FROM wp_cracker_tracker
    WHERE `user` = p_user_id;

    -- Creative hours average
    SELECT AVG(number_creative_hours) INTO p_avg_hours
    FROM wp_cracker_tracker
    WHERE `user` = p_user_id
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    -- Rating counts
    SELECT COUNT(*) INTO p_count_neg_two
    FROM wp_cracker_tracker
    WHERE `user` = p_user_id
    AND rating = -2
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    SELECT COUNT(*) INTO p_count_neg_one
    FROM wp_cracker_tracker
    WHERE `user` = p_user_id
    AND rating = -1
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    SELECT COUNT(*) INTO p_count_zero
    FROM wp_cracker_tracker
    WHERE `user` = p_user_id
    AND rating = 0
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    SELECT COUNT(*) INTO p_count_plus_one
    FROM wp_cracker_tracker
    WHERE `user` = p_user_id
    AND rating = 1
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);

    SELECT COUNT(*) INTO p_count_plus_two
    FROM wp_cracker_tracker
    WHERE `user` = p_user_id
    AND rating = 2
    AND created_at > DATE_SUB(NOW(), INTERVAL p_running_avg DAY);
END;

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
    FROM wp_cracker_user
    WHERE id = p_user_id;

    -- Get last post info
    SELECT tracker.id, tracker.overview, tracker.number_creative_hours,
           tracker.rating, tracker.created_at
    INTO p_last_post_id, p_last_post_overview, p_last_post_hours,
         p_last_post_rating, p_last_post_date
    FROM wp_cracker_tracker tracker
    INNER JOIN (
        SELECT MAX(created_at) as created_at
        FROM wp_cracker_tracker
        WHERE `user` = p_user_id
    ) last_post ON tracker.created_at = last_post.created_at;
END;
