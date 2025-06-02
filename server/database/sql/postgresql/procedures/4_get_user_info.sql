-- PROCEDURE: public.get_user_info(integer, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor)

-- DROP PROCEDURE IF EXISTS public.get_user_info(integer, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor);

CREATE OR REPLACE PROCEDURE public.get_user_info(
	IN user_id integer,
	INOUT _email refcursor DEFAULT ''::refcursor,
	INOUT _username refcursor DEFAULT ''::refcursor,
	INOUT _role refcursor DEFAULT ''::refcursor,
	INOUT _id refcursor DEFAULT ''::refcursor,
	INOUT _last_post_date refcursor DEFAULT ''::refcursor,
	INOUT _last_post_id refcursor DEFAULT ''::refcursor,
	INOUT _last_post_overview refcursor DEFAULT ''::refcursor,
	INOUT _last_post_hours refcursor DEFAULT ''::refcursor,
	INOUT _last_post_rating refcursor DEFAULT ''::refcursor)
LANGUAGE 'plpgsql'
AS $BODY$
declare
-- variable declaration
begin

	select id, email, role, username
	from "user"
	where id = user_id
	into _id, _email, _role, _username;

	select tracker.id, tracker.overview, tracker.number_creative_hours, tracker.rating, tracker.created_at
    from tracker
    inner join (
        select max(created_at) as created_at
        from tracker
        where "user" = user_id
    ) last_post
    on tracker.created_at = last_post.created_at
	into _last_post_id, _last_post_overview, _last_post_hours, _last_post_rating, _last_post_date;

end; 
$BODY$;
ALTER PROCEDURE public.get_user_info(integer, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor, refcursor)
    OWNER TO postgres;
