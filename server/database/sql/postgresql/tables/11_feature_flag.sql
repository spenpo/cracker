-- Table: public.feature_flag

-- DROP TABLE IF EXISTS public.feature_flag;

CREATE TABLE IF NOT EXISTS public.feature_flag
(
    id serial,
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default" NOT NULL,
    is_enabled bit(1) NOT NULL,
    required_role integer,
    CONSTRAINT feature_flag_pkey PRIMARY KEY (id),
    CONSTRAINT feature_flag_name_key UNIQUE (name),
    CONSTRAINT feature_flag_required_role_fkey FOREIGN KEY (required_role)
        REFERENCES public.role_lookup (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.feature_flag
    OWNER to postgres;

/* INSERT FEATURE FLAGS */
insert into feature_flag ( name, description, is_enabled ) values ( 'premiumDashboardSwitch', 'a switch that changes state from basic to premium dashboard. brings up upgrade popup for basic members', CAST(0 as BIT) );
insert into feature_flag ( name, description, is_enabled, required_role ) values ( 'adminDashboardMenuItem', 'option in user menu that navigates to admin dashboard', CAST(1 as BIT), 3 );
