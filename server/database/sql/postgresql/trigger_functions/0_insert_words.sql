-- FUNCTION: public.insert_words()

-- DROP FUNCTION IF EXISTS public.insert_words();

CREATE OR REPLACE FUNCTION public.insert_words()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
    insert into word(word, tracker) select
		unnest(
			array_remove(
				regexp_split_to_array(
					NEW.overview,
					'(?!'')[[:punct:]\s*]'
				),
				''
			)
		) as word,
		new.id as tracker;
return NEW;
end;
$BODY$;

ALTER FUNCTION public.insert_words()
    OWNER TO postgres;
