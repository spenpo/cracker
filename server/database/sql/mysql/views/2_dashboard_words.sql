CREATE OR REPLACE VIEW dashboard_words AS
SELECT 
    word.word,
    tracker.overview,
    tracker.number_creative_hours,
    tracker.rating,
    tracker.created_at,
    tracker.user
FROM tracker
JOIN word ON tracker.id = word.tracker; 