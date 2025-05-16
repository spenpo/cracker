-- FUNCTION: public.insert_sentences()

-- DROP FUNCTION IF EXISTS public.insert_sentences();

CREATE OR REPLACE FUNCTION public.insert_sentences()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
    insert into sentence(sentence, tracker) select
		unnest(
				array_remove(
					regexp_split_to_array(
						NEW.overview,
						'[.?!]\s*'
					),
					''
				)
			) as sentence,
		new.id as tracker;
return NEW;
end;
$BODY$;

ALTER FUNCTION public.insert_sentences()
    OWNER TO postgres;
