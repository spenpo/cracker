-- View: dashboard_sentences

CREATE OR REPLACE VIEW dashboard_sentences AS
SELECT 
    sentence.sentence,
    tracker.overview,
    tracker.number_creative_hours,
    tracker.rating,
    tracker.created_at,
    tracker.user
FROM tracker
JOIN sentence ON tracker.id = sentence.tracker; 