-- FUNCTION: public.delete_sentences()

-- DROP FUNCTION IF EXISTS public.delete_sentences();

CREATE OR REPLACE FUNCTION public.delete_sentences()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
    delete from sentence where tracker = new.id;
return NEW;
end;
$BODY$;

ALTER FUNCTION public.delete_sentences()
    OWNER TO postgres;
