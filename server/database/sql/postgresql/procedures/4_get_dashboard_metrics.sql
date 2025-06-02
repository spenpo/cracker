-- PROCEDURE: public.get_dashboard_metrics(integer, character varying, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor)

-- DROP PROCEDURE IF EXISTS public.get_dashboard_metrics(integer, character varying, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor);

CREATE OR REPLACE PROCEDURE public.get_dashboard_metrics(
	IN user_id integer,
	IN running_avg character varying,
	INOUT _days_of_use refcursor DEFAULT 'total numbers of times user has tracked data'::refcursor,
	INOUT _avg_hours refcursor DEFAULT 'creative hours average'::refcursor,
	INOUT _count_neg_two refcursor DEFAULT '# of -2 ratings in past year'::refcursor,
	INOUT _count_neg_one refcursor DEFAULT '# of -1 ratings in past year'::refcursor,
	INOUT _count_zero refcursor DEFAULT '# of 0 ratings in past year'::refcursor,
	INOUT _count_plus_one refcursor DEFAULT '# of +1 ratings in past year'::refcursor,
	INOUT _count_plus_two refcursor DEFAULT '# of +2 ratings in past year'::refcursor)
LANGUAGE 'plpgsql'
AS $BODY$
declare
-- variable declaration
begin
	select count(*)
	from tracker
	where "user" = user_id
	into _days_of_use;

	-- CREATIVE HOURS AVERAGES
	select avg(number_creative_hours) 
	from tracker 
	where "user" = user_id
	and created_at > now() - (running_avg || ' day')::interval
	into _avg_hours;
	
	-- RATINGS COUNTS 1 YEAR
	select count(*)
	from tracker
	where "user" = user_id
	and rating = -2
	and created_at > now() - (running_avg || ' day')::interval
	into _count_neg_two;
	
	select count(*)
	from tracker
	where "user" = user_id
	and rating = -1
	and created_at > now() - (running_avg || ' day')::interval
	into _count_neg_one;
	
	select count(*)
	from tracker
	where "user" = user_id
	and rating = 0
	and created_at > now() - (running_avg || ' day')::interval
	into _count_zero;
	
	select count(*)
	from tracker
	where "user" = user_id
	and rating = 1
	and created_at > now() - (running_avg || ' day')::interval
	into _count_plus_one;
	
	select count(*)
	from tracker
	where "user" = user_id
	and rating = 2
	and created_at > now() - (running_avg || ' day')::interval
	into _count_plus_two;

end; 
$BODY$;
ALTER PROCEDURE public.get_dashboard_metrics(integer, character varying, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor)
    OWNER TO postgres;
