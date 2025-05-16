DELIMITER //

CREATE TRIGGER insert_sentences
AFTER INSERT ON tracker
FOR EACH ROW
BEGIN
    INSERT INTO sentence (sentence, tracker)
    SELECT 
        sentence,
        NEW.id as tracker
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
END//

DELIMITER ; 