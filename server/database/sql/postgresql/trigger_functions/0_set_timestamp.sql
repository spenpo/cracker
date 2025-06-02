-- FUNCTION: public.set_timestamp()

-- DROP FUNCTION IF EXISTS public.set_timestamp();

CREATE OR REPLACE FUNCTION public.set_timestamp()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
    NEW.updated_at = now();
return NEW;
end;
$BODY$;

ALTER FUNCTION public.set_timestamp()
    OWNER TO postgres;
