-- Table: public.word

-- DROP TABLE IF EXISTS public.word;

CREATE TABLE IF NOT EXISTS public.word
(
    id serial,
    word character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tracker integer NOT NULL,
    CONSTRAINT word_pkey PRIMARY KEY (id),
    CONSTRAINT word_tracker_fkey FOREIGN KEY (tracker)
        REFERENCES public.tracker (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.word
    OWNER to postgres;