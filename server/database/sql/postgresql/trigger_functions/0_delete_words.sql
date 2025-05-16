-- FUNCTION: public.delete_words()

-- DROP FUNCTION IF EXISTS public.delete_words();

CREATE OR REPLACE FUNCTION public.delete_words()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
    delete from word where tracker = new.id;
return NEW;
end;
$BODY$;

ALTER FUNCTION public.delete_words()
    OWNER TO postgres;
