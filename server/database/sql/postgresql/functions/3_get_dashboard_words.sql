-- FUNCTION: public.get_dashboard_words(integer, character varying, integer[], numeric, numeric, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.get_dashboard_words(integer, character varying, integer[], numeric, numeric, character varying, character varying);

CREATE OR REPLACE FUNCTION public.get_dashboard_words(
	user_id integer,
	running_avg character varying,
	p_rating integer[] DEFAULT NULL::integer[],
	min_hours numeric DEFAULT 0,
	max_hours numeric DEFAULT 24,
	sort_column character varying DEFAULT 'count'::character varying,
	sort_dir character varying DEFAULT 'asc'::character varying)
    RETURNS TABLE(word character varying, count integer, days_used integer[]) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	select word, count(*) as "count", STRING_TO_ARRAY(STRING_AGG(distinct tracker::text, ','), ',')::integer[] as days_used
	from tracker join word on tracker.id = word.tracker
	and "user" = user_id
	and created_at > now() - (running_avg || ' day')::interval
	and rating = ANY(COALESCE(p_rating, ARRAY [-2, -1, 0, 1, 2]))
	and number_creative_hours between min_hours and max_hours
	group by word.word
	order by
		case when sort_dir = 'count' and sort_dir = 'asc' then count(*) end asc,
		case when sort_column = 'count' and sort_dir = 'desc' then count(*) end desc,
		case when sort_column = 'word' and sort_dir = 'asc' then word end asc,
		case when sort_column = 'word' and sort_dir = 'desc' then word end desc;
$BODY$;

ALTER FUNCTION public.get_dashboard_words(integer, character varying, integer[], numeric, numeric, character varying, character varying)
    OWNER TO postgres;