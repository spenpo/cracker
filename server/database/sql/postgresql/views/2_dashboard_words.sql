-- View: public.dashboard_words

-- DROP VIEW public.dashboard_words;

CREATE OR REPLACE VIEW public.dashboard_words
 AS
 SELECT word.word,
    tracker.overview,
    tracker.number_creative_hours,
    tracker.rating,
    tracker.created_at,
    tracker."user"
   FROM tracker
     JOIN word ON tracker.id = word.tracker;

ALTER TABLE public.dashboard_words
    OWNER TO postgres;

