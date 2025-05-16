-- Table: public.user

-- DROP TABLE IF EXISTS public."user";

CREATE TABLE IF NOT EXISTS public."user"
(
    id serial,
    username character varying(50) COLLATE pg_catalog."default" NOT NULL,
    password character varying(100) COLLATE pg_catalog."default" NOT NULL,
    email character varying(100) COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    role integer DEFAULT 1,
    CONSTRAINT user_pkey PRIMARY KEY (id),
    CONSTRAINT user_email_key UNIQUE (email),
    CONSTRAINT user_username_key UNIQUE (username),
    CONSTRAINT user_role_fkey FOREIGN KEY (role)
        REFERENCES public.role_lookup (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."user"
    OWNER to postgres;

-- Trigger: update_user

-- DROP TRIGGER IF EXISTS update_user ON public."user";

CREATE TRIGGER update_user
    BEFORE UPDATE 
    ON public."user"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_timestamp();