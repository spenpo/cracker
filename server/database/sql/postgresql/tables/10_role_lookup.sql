-- Table: public.role_lookup

-- DROP TABLE IF EXISTS public.role_lookup;

CREATE TABLE IF NOT EXISTS public.role_lookup
(
    id serial,
    name character varying(10) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT role_lookup_pkey PRIMARY KEY (id),
    CONSTRAINT role_lookup_name_key UNIQUE (name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.role_lookup
    OWNER to postgres;

/* INSERT ROLES */
insert into role_lookup ( name, description ) values ( 'member', 'default role. basic member. access to free features' );
insert into role_lookup ( name, description ) values ( 'premium', 'paid member. access to premium features' );
insert into role_lookup ( name, description ) values ( 'admin', 'administrator. access to admin only features' );
