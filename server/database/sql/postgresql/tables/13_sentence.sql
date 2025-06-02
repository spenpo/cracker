-- Table: public.sentence

-- DROP TABLE IF EXISTS public.sentence;

CREATE TABLE IF NOT EXISTS public.sentence
(
    id serial,
    sentence character varying(512) COLLATE pg_catalog."default" NOT NULL,
    tracker integer NOT NULL,
    CONSTRAINT sentence_pkey PRIMARY KEY (id),
    CONSTRAINT sentence_tracker_fkey FOREIGN KEY (tracker)
        REFERENCES public.tracker (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.sentence
    OWNER to postgres;