-- Table: public.tracker

-- DROP TABLE IF EXISTS public.tracker;

CREATE TABLE IF NOT EXISTS public.tracker
(
    id serial,
    overview character varying(512) COLLATE pg_catalog."default" NOT NULL,
    number_creative_hours numeric(3,1) NOT NULL,
    rating smallint NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    "user" integer NOT NULL,
    CONSTRAINT tracker_pkey PRIMARY KEY (id),
    CONSTRAINT tracker_user_fkey FOREIGN KEY ("user")
        REFERENCES public."user" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tracker
    OWNER to postgres;
-- Index: day_uq

-- DROP INDEX IF EXISTS public.day_uq;

CREATE UNIQUE INDEX IF NOT EXISTS day_uq
    ON public.tracker USING btree
    (EXTRACT(day FROM created_at) ASC NULLS LAST, EXTRACT(month FROM created_at) ASC NULLS LAST, EXTRACT(year FROM created_at) ASC NULLS LAST, "user" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: delete_sentences_from_overview

-- DROP TRIGGER IF EXISTS delete_sentences_from_overview ON public.tracker;

CREATE TRIGGER delete_sentences_from_overview
    AFTER UPDATE 
    ON public.tracker
    FOR EACH ROW
    EXECUTE FUNCTION public.delete_sentences();

-- Trigger: delete_words_from_overview

-- DROP TRIGGER IF EXISTS delete_words_from_overview ON public.tracker;

CREATE TRIGGER delete_words_from_overview
    AFTER UPDATE 
    ON public.tracker
    FOR EACH ROW
    EXECUTE FUNCTION public.delete_words();

-- Trigger: insert_sentences_from_overview

-- DROP TRIGGER IF EXISTS insert_sentences_from_overview ON public.tracker;

CREATE TRIGGER insert_sentences_from_overview
    AFTER INSERT
    ON public.tracker
    FOR EACH ROW
    EXECUTE FUNCTION public.insert_sentences();

-- Trigger: insert_words_from_overview

-- DROP TRIGGER IF EXISTS insert_words_from_overview ON public.tracker;

CREATE TRIGGER insert_words_from_overview
    AFTER INSERT
    ON public.tracker
    FOR EACH ROW
    EXECUTE FUNCTION public.insert_words();

-- Trigger: update_sentences_from_overview

-- DROP TRIGGER IF EXISTS update_sentences_from_overview ON public.tracker;

CREATE TRIGGER update_sentences_from_overview
    AFTER UPDATE 
    ON public.tracker
    FOR EACH ROW
    EXECUTE FUNCTION public.insert_sentences();

-- Trigger: update_tracker

-- DROP TRIGGER IF EXISTS update_tracker ON public.tracker;

CREATE TRIGGER update_tracker
    BEFORE UPDATE 
    ON public.tracker
    FOR EACH ROW
    EXECUTE FUNCTION public.set_timestamp();

-- Trigger: update_words_from_overview

-- DROP TRIGGER IF EXISTS update_words_from_overview ON public.tracker;

CREATE TRIGGER update_words_from_overview
    AFTER UPDATE 
    ON public.tracker
    FOR EACH ROW
    EXECUTE FUNCTION public.insert_words();