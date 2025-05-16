-- FUNCTION: public.get_dashboard_sentences(integer, character varying, integer[], numeric, numeric, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.get_dashboard_sentences(integer, character varying, integer[], numeric, numeric, character varying, character varying);

CREATE OR REPLACE FUNCTION public.get_dashboard_sentences(
	user_id integer,
	running_avg character varying,
	p_rating integer[] DEFAULT NULL::integer[],
	min_hours numeric DEFAULT 0,
	max_hours numeric DEFAULT 24,
	sort_column character varying DEFAULT 'date'::character varying,
	sort_dir character varying DEFAULT 'desc'::character varying)
    RETURNS SETOF dashboard_sentences 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	select * from dashboard_sentences
	where "user" = user_id
	and created_at > now() - (running_avg || ' day')::interval
	and rating = ANY(COALESCE(p_rating, ARRAY [-2, -1, 0, 1, 2]))
	and number_creative_hours between min_hours and max_hours
	order by
		case when sort_column = 'sentence' and sort_dir = 'asc' then sentence end asc,
		case when sort_column = 'sentence' and sort_dir = 'desc' then sentence end desc,
		case when sort_column = 'hours' and sort_dir = 'asc' then number_creative_hours end asc,
		case when sort_column = 'hours' and sort_dir = 'desc' then number_creative_hours end desc,
		case when sort_column = 'rating' and sort_dir = 'asc' then rating end asc,
		case when sort_column = 'rating' and sort_dir = 'desc' then rating end desc,
		case when sort_column = 'date' and sort_dir = 'asc' then created_at end asc,
		case when sort_column = 'date' and sort_dir = 'desc' then created_at end desc;
$BODY$;

ALTER FUNCTION public.get_dashboard_sentences(integer, character varying, integer[], numeric, numeric, character varying, character varying)
    OWNER TO postgres;
