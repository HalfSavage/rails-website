--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


SET search_path = public, pg_catalog;

--
-- Name: discussions_active_friends(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION discussions_active_friends(member_id integer) RETURNS TABLE(name text, forum_id integer, id integer, member_id integer, body text, subject text, created_at timestamp without time zone, updated_at timestamp without time zone, username text, reply_count bigint, reply_created_at timestamp without time zone, reply_username text, usernames character varying[], score double precision)
    LANGUAGE sql
    AS $_$

    select
      d.name,
      d.forum_id,
      d.id,
      d.member_id,
      d.body,
      d.subject,
      d.created_at,
      d.updated_at,
      d.username,
      d.reply_count,
      d.reply_created_at,
      d.reply_username,
      daf.usernames,
      daf.score
    from
      discussions d
      inner join
      (
      select
        coalesce(p.parent_id, p.id) as id,
        sum(
            CASE
                WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) < (7200)::double precision) THEN (100.0)::double precision
                ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) / (7200.0)::double precision)))
            END) AS score,
        array_agg(m.username) as usernames
      from
        posts p
          inner join relationships r on
            p.member_id = r.related_member_id
            and r.member_id=$1
            and r.friend='t'
            and p.deleted='f'
            and p.private_moderator_voice='f'
            and p.created_at >= current_date - interval '7 days'
          inner join members m on
            p.member_id = m.id
      group by coalesce(p.parent_id, p.id)
      order by score desc
      limit 100
      ) daf on d.id=daf.id


    $_$;


--
-- Name: post_tags_replace(integer, character varying[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION post_tags_replace(post_id integer, newtags character varying[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE
	m varchar;
BEGIN
	-- loop through the tags and insert them if they don't exist
	FOREACH m IN ARRAY newtags
	LOOP
		raise NOTICE '%',m;
	END LOOP;
	-- delete all the tags that AREN'T in tags[]

END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE addresses (
    id integer NOT NULL,
    address_1 character varying(255),
    address_2 character varying(255),
    city character varying(255),
    region character varying(255),
    country character varying(2),
    latitude double precision,
    longitude double precision,
    member_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: discussion_views; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE discussion_views (
    id integer NOT NULL,
    post_id integer NOT NULL,
    member_id integer NOT NULL,
    tally integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: discussion_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE discussion_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discussion_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE discussion_views_id_seq OWNED BY discussion_views.id;


--
-- Name: forums; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE forums (
    id integer NOT NULL,
    name character varying(255),
    active boolean DEFAULT true,
    moderator_only boolean DEFAULT false,
    visible_to_public boolean DEFAULT true,
    paid_member_only boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    display_order integer,
    slug character varying(255),
    default_forum boolean,
    special boolean DEFAULT false
);


--
-- Name: forums_posts; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE forums_posts (
    id integer NOT NULL,
    forum_id integer NOT NULL,
    post_id integer NOT NULL
);


--
-- Name: members; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE members (
    id integer NOT NULL,
    username character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    referred_by_id integer,
    date_of_birth timestamp without time zone,
    active boolean DEFAULT true,
    moderator boolean DEFAULT false,
    supermoderator boolean DEFAULT false,
    banned boolean DEFAULT false,
    vip boolean DEFAULT false,
    true_successor_to_hokuto_no_ken boolean DEFAULT false,
    visible_to_non_members boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    gender_id integer
);


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE posts (
    id integer NOT NULL,
    member_id integer NOT NULL,
    parent_id integer,
    deleted boolean DEFAULT false NOT NULL,
    public_moderator_voice boolean DEFAULT false NOT NULL,
    private_moderator_voice boolean DEFAULT false NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    subject character varying(255),
    slug character varying(255)
    --discussion_id int not null
);

/*
CREATE OR REPLACE FUNCTION post_populate_discussion_id() RETURNS trigger AS $BODY$
 BEGIN
 NEW.discussion_id := coalesce(NEW.discussion_id, NEW.parent_id, NEW.id);
 return NEW;
 END;
$BODY$
LANGUAGE plpgsql VOLATILE;

create trigger post_insert_trigger BEFORE INSERT ON posts FOR EACH ROW EXECUTE PROCEDURE post_populate_discussion_id();
*/

CREATE OR REPLACE FUNCTION public.discussions_refresh() RETURNS trigger as $function$
 BEGIN
 refresh materialized view discussions;
 return NEW;
 END;
$function$
LANGUAGE plpgsql VOLATILE;

create trigger post_insert_trigger_discussions AFTER INSERT ON posts FOR EACH ROW EXECUTE PROCEDURE discussions_refresh();

--
-- Name: posts_last_replies_with_usernames; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW posts_last_replies_with_usernames AS
 SELECT p_last_replies.reply_number,
    p_last_replies.parent_id,
    p_last_replies.created_at,
    p_last_replies.member_id,
    m.username
   FROM (( SELECT row_number() OVER (PARTITION BY p.parent_id ORDER BY p.created_at DESC) AS reply_number,
            p.parent_id,
            p.created_at,
            p.member_id
           FROM posts p
          WHERE (((p.parent_id IS NOT NULL) AND (p.deleted = false)) AND (p.private_moderator_voice = false))) p_last_replies
   JOIN members m ON ((p_last_replies.member_id = m.id)))
  WHERE (p_last_replies.reply_number = 1);


--
-- Name: discussions; Type: VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW discussions AS
 SELECT f.name,
    fp.forum_id,
    p.id,
    p.member_id,
    p.body,
    p.subject,
    p.slug,
    p.created_at,
    p.updated_at,
    m.username,
    ( SELECT count(1) AS count
           FROM posts preply
          WHERE ((preply.parent_id = p.id) AND (preply.deleted = false))) AS reply_count,
    plr.created_at AS reply_created_at,
    plr.username AS reply_username,
    ''::text AS usernames,
    (0.0)::double precision AS score
   FROM ((((posts p
   JOIN forums_posts fp ON ((p.id = fp.post_id)))
   JOIN forums f ON ((fp.forum_id = f.id)))
   JOIN members m ON ((p.member_id = m.id)))
   LEFT JOIN posts_last_replies_with_usernames plr ON ((p.id = plr.parent_id)))
  WHERE ((p.parent_id IS NULL) AND (p.deleted = false));


--
-- Name: discussions_active; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW discussions_active AS
 SELECT COALESCE(p.parent_id, p.id) AS id,
    sum(
        CASE
            WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) < (7200)::double precision) THEN (100.0)::double precision
            ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) / (7200.0)::double precision)))
        END) AS score
   FROM posts p
  WHERE ((((p.created_at >= (('now'::text)::date - '7 days'::interval)) AND (p.deleted = false)) AND (p.public_moderator_voice = false)) AND (p.private_moderator_voice = false))
  GROUP BY COALESCE(p.parent_id, p.id);


--
-- Name: forum_moderators; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE forum_moderators (
    id integer NOT NULL,
    forum_moderators character varying(255),
    forum_id integer,
    member_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: forum_moderators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forum_moderators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forum_moderators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forum_moderators_id_seq OWNED BY forum_moderators.id;


--
-- Name: forums_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forums_id_seq OWNED BY forums.id;


--
-- Name: forums_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forums_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forums_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forums_posts_id_seq OWNED BY forums_posts.id;


--
-- Name: genders; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE genders (
    id integer NOT NULL,
    gender_description character varying(255),
    gender_abbreviation character varying(255)
);


--
-- Name: genders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE genders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: genders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE genders_id_seq OWNED BY genders.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE likes (
    id integer NOT NULL,
    member_id integer,
    post_id integer,
    attachment_id integer,
    event_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE likes_id_seq OWNED BY likes.id;


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE members_id_seq OWNED BY members.id;


--
-- Name: message_types; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE message_types (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: message_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE message_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: message_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE message_types_id_seq OWNED BY message_types.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE messages (
    id integer NOT NULL,
    member_to_id integer,
    member_from_id integer,
    message_type_id integer,
    body character varying(8000),
    seen timestamp without time zone,
    post_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_by_sender timestamp without time zone,
    deleted_by_recipient timestamp without time zone,
    moderator_voice boolean
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: post_action_types; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE post_action_types (
    id integer NOT NULL,
    name character varying(255),
    moderator_only boolean,
    active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    note_required boolean
);


--
-- Name: post_action_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_action_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_action_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_action_types_id_seq OWNED BY post_action_types.id;


--
-- Name: post_actions; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE post_actions (
    id integer NOT NULL,
    member_id integer,
    post_action_type_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    post_id integer,
    note character varying(255)
);


--
-- Name: post_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_actions_id_seq OWNED BY post_actions.id;


--
-- Name: post_tags; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE post_tags (
    post_id integer NOT NULL,
    tag_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: posts_last_replies; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW posts_last_replies AS
 SELECT p_last_replies.reply_number,
    p_last_replies.parent_id,
    p_last_replies.created_at,
    p_last_replies.member_id
   FROM ( SELECT row_number() OVER (PARTITION BY p.parent_id ORDER BY p.created_at DESC) AS reply_number,
            p.parent_id,
            p.created_at,
            p.member_id
           FROM posts p
          WHERE (((p.parent_id IS NOT NULL) AND (p.deleted = false)) AND (p.private_moderator_voice = false))) p_last_replies
  WHERE (p_last_replies.reply_number = 1);


--
-- Name: profile_views; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE profile_views (
    id integer NOT NULL,
    member_id integer,
    viewed_member_id integer NOT NULL,
    tally integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: profile_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profile_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profile_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profile_views_id_seq OWNED BY profile_views.id;


--
-- Name: relationships; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE relationships (
    id integer NOT NULL,
    member_id integer,
    related_member_id integer,
    friend boolean DEFAULT false,
    blocked boolean DEFAULT false,
    may_view_private_pictures boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE relationships_id_seq OWNED BY relationships.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE tags (
    id integer NOT NULL,
    tag_text character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: tags_trending; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tags_trending AS
 SELECT pt.tag_id,
    t.tag_text,
    count(pt.tag_id) AS count,
    sum(
        CASE
            WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < (7200)::double precision) THEN (100.0)::double precision
            ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / (7200.0)::double precision)))
        END) AS score
   FROM ((post_tags pt
   JOIN forums_posts fp ON ((pt.post_id = fp.post_id)))
   JOIN tags t ON ((pt.tag_id = t.id)))
  GROUP BY pt.tag_id, t.tag_text
  ORDER BY sum(
CASE
    WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < (7200)::double precision) THEN (100.0)::double precision
    ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / (7200.0)::double precision)))
END) DESC
 LIMIT 100;


--
-- Name: tags_trending_by_forum; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tags_trending_by_forum AS
 SELECT pt.tag_id,
    t.tag_text,
    count(pt.tag_id) AS count,
    fp.forum_id,
    sum(
        CASE
            WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < (7200)::double precision) THEN (100.0)::double precision
            ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / (7200.0)::double precision)))
        END) AS score
   FROM ((post_tags pt
   JOIN forums_posts fp ON ((pt.post_id = fp.post_id)))
   JOIN tags t ON ((pt.tag_id = t.id)))
  GROUP BY fp.forum_id, pt.tag_id, t.tag_text
  ORDER BY sum(
CASE
    WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < (7200)::double precision) THEN (100.0)::double precision
    ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / (7200.0)::double precision)))
END) DESC
 LIMIT 100;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY discussion_views ALTER COLUMN id SET DEFAULT nextval('discussion_views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forum_moderators ALTER COLUMN id SET DEFAULT nextval('forum_moderators_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forums ALTER COLUMN id SET DEFAULT nextval('forums_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forums_posts ALTER COLUMN id SET DEFAULT nextval('forums_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY genders ALTER COLUMN id SET DEFAULT nextval('genders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes ALTER COLUMN id SET DEFAULT nextval('likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY members ALTER COLUMN id SET DEFAULT nextval('members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY message_types ALTER COLUMN id SET DEFAULT nextval('message_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_action_types ALTER COLUMN id SET DEFAULT nextval('post_action_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_actions ALTER COLUMN id SET DEFAULT nextval('post_actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profile_views ALTER COLUMN id SET DEFAULT nextval('profile_views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY relationships ALTER COLUMN id SET DEFAULT nextval('relationships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: discussion_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY discussion_views
    ADD CONSTRAINT discussion_views_pkey PRIMARY KEY (id);


--
-- Name: forum_moderators_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY forum_moderators
    ADD CONSTRAINT forum_moderators_pkey PRIMARY KEY (id);


--
-- Name: forums_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY forums
    ADD CONSTRAINT forums_pkey PRIMARY KEY (id);


--
-- Name: forums_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY forums_posts
    ADD CONSTRAINT forums_posts_pkey PRIMARY KEY (id);


--
-- Name: genders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY genders
    ADD CONSTRAINT genders_pkey PRIMARY KEY (id);


--
-- Name: likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: members_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: message_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY message_types
    ADD CONSTRAINT message_types_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: post_action_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY post_action_types
    ADD CONSTRAINT post_action_types_pkey PRIMARY KEY (id);


--
-- Name: post_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY post_actions
    ADD CONSTRAINT post_actions_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: profile_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY profile_views
    ADD CONSTRAINT profile_views_pkey PRIMARY KEY (id);


--
-- Name: relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: by_forum_and_post; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX by_forum_and_post ON forums_posts USING btree (forum_id, post_id);


--
-- Name: discussion_views_idx_member_post; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX discussion_views_idx_member_post ON discussion_views USING btree (member_id, post_id);


--
-- Name: index_addresses_on_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_addresses_on_member_id ON addresses USING btree (member_id);


--
-- Name: index_discussion_views_on_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_discussion_views_on_member_id ON discussion_views USING btree (member_id);


--
-- Name: index_discussion_views_on_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_discussion_views_on_post_id ON discussion_views USING btree (post_id);


--
-- Name: index_likes_on_post_id_and_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_likes_on_post_id_and_member_id ON likes USING btree (post_id, member_id);


--
-- Name: index_members_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_members_on_email ON members USING btree (email);


--
-- Name: index_members_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_members_on_reset_password_token ON members USING btree (reset_password_token);


--
-- Name: index_members_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_members_on_username ON members USING btree (username);


--
-- Name: index_messages_on_member_to_id_and_message_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_messages_on_member_to_id_and_message_type_id ON messages USING btree (member_to_id, message_type_id);


--
-- Name: index_messages_on_member_to_id_and_seen_and_message_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_messages_on_member_to_id_and_seen_and_message_type_id ON messages USING btree (member_to_id, seen, message_type_id);


--
-- Name: index_posts_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_posts_on_slug ON posts USING btree (slug);


--
-- Name: index_profile_views_on_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_profile_views_on_member_id ON profile_views USING btree (member_id);


--
-- Name: index_profile_views_on_viewed_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_profile_views_on_viewed_member_id ON profile_views USING btree (viewed_member_id);


--
-- Name: index_relationships_on_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_relationships_on_member_id ON relationships USING btree (member_id);


--
-- Name: index_relationships_on_related_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_relationships_on_related_member_id ON relationships USING btree (related_member_id);


--
-- Name: ix_posts_discussions; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_posts_discussions ON posts USING btree (parent_id, deleted, member_id, created_at DESC, updated_at, subject, id);


--
-- Name: ix_posts_discussions_active; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_posts_discussions_active ON posts USING btree (created_at DESC, deleted, public_moderator_voice, private_moderator_voice, parent_id, id);


--
-- Name: post_actions_post_id_etc; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX post_actions_post_id_etc ON post_actions USING btree (post_id, post_action_type_id, created_at);


--
-- Name: posts_idx_for_last_replies; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

create index posts_idx_for_last_replies on posts(parent_id, created_at desc, member_id) where (parent_id IS NOT NULL AND deleted = false AND private_moderator_voice = false);

create index posts_idx_for_discussions on posts(id, member_id, left(body, 200), subject, slug, created_at, updated_at, deleted, private_moderator_voice) WHERE (parent_id IS NULL AND deleted is false);


--
-- Name: profile_views_idx_awesome; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX profile_views_idx_awesome ON profile_views USING btree (viewed_member_id, member_id, tally);


--
-- Name: relationships_idx_all; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX relationships_idx_all ON relationships USING btree (member_id, related_member_id, friend, blocked, may_view_private_pictures);


--
-- Name: relationships_idx_covering; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX relationships_idx_covering ON discussion_views USING btree (member_id, post_id, updated_at, tally);


--
-- Name: relationships_idx_friend; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX relationships_idx_friend ON relationships USING btree (member_id, related_member_id, friend);


--
-- Name: tag_idx_lower; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX tag_idx_lower ON tags USING btree (lower((tag_text)::text));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_addresses_member_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT fk_addresses_member_id FOREIGN KEY (member_id) REFERENCES members(id);


--
-- Name: fk_discussion_views_member_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY discussion_views
    ADD CONSTRAINT fk_discussion_views_member_id FOREIGN KEY (member_id) REFERENCES members(id);


--
-- Name: fk_discussion_views_post_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY discussion_views
    ADD CONSTRAINT fk_discussion_views_post_id FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: fk_profile_views_member_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profile_views
    ADD CONSTRAINT fk_profile_views_member_id FOREIGN KEY (member_id) REFERENCES members(id);


--
-- Name: fk_profile_views_viewed_member_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profile_views
    ADD CONSTRAINT fk_profile_views_viewed_member_id FOREIGN KEY (viewed_member_id) REFERENCES members(id);


--
-- Name: fk_relationships_member_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT fk_relationships_member_id FOREIGN KEY (member_id) REFERENCES members(id);


--
-- Name: fk_relationships_related_member_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT fk_relationships_related_member_id FOREIGN KEY (related_member_id) REFERENCES members(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131102232858');

INSERT INTO schema_migrations (version) VALUES ('20131102233230');

INSERT INTO schema_migrations (version) VALUES ('20131102233419');

INSERT INTO schema_migrations (version) VALUES ('20131102233455');

INSERT INTO schema_migrations (version) VALUES ('20131102233818');

INSERT INTO schema_migrations (version) VALUES ('20131102233856');

INSERT INTO schema_migrations (version) VALUES ('20131111204122');

INSERT INTO schema_migrations (version) VALUES ('20131124053709');

INSERT INTO schema_migrations (version) VALUES ('20131124054023');

INSERT INTO schema_migrations (version) VALUES ('20131124054038');

INSERT INTO schema_migrations (version) VALUES ('20131124054730');

INSERT INTO schema_migrations (version) VALUES ('20131209021838');

INSERT INTO schema_migrations (version) VALUES ('20131209222358');

INSERT INTO schema_migrations (version) VALUES ('20131210054447');

INSERT INTO schema_migrations (version) VALUES ('20131210054857');

INSERT INTO schema_migrations (version) VALUES ('20131211170329');

INSERT INTO schema_migrations (version) VALUES ('20131211174452');

INSERT INTO schema_migrations (version) VALUES ('20131211230740');

INSERT INTO schema_migrations (version) VALUES ('20131211231328');

INSERT INTO schema_migrations (version) VALUES ('20131212051253');

INSERT INTO schema_migrations (version) VALUES ('20131214212312');

INSERT INTO schema_migrations (version) VALUES ('20131216171426');

INSERT INTO schema_migrations (version) VALUES ('20131216195601');

INSERT INTO schema_migrations (version) VALUES ('20131216200332');

INSERT INTO schema_migrations (version) VALUES ('20131216201553');

INSERT INTO schema_migrations (version) VALUES ('20131216210315');

INSERT INTO schema_migrations (version) VALUES ('20131216211208');

INSERT INTO schema_migrations (version) VALUES ('20131216220041');

INSERT INTO schema_migrations (version) VALUES ('20131229221345');

INSERT INTO schema_migrations (version) VALUES ('20131229221413');

INSERT INTO schema_migrations (version) VALUES ('20131230035409');

INSERT INTO schema_migrations (version) VALUES ('20131231015232');

INSERT INTO schema_migrations (version) VALUES ('20140102172401');

INSERT INTO schema_migrations (version) VALUES ('20140108050143');

INSERT INTO schema_migrations (version) VALUES ('20140109023052');

INSERT INTO schema_migrations (version) VALUES ('20140124101150');

INSERT INTO schema_migrations (version) VALUES ('20140127001722');

INSERT INTO schema_migrations (version) VALUES ('20140127021025');

INSERT INTO schema_migrations (version) VALUES ('20140128013641');

INSERT INTO schema_migrations (version) VALUES ('20140202021442');

INSERT INTO schema_migrations (version) VALUES ('20140209154433');

INSERT INTO schema_migrations (version) VALUES ('20140216181631');

INSERT INTO schema_migrations (version) VALUES ('20140216233625');

INSERT INTO schema_migrations (version) VALUES ('20140217031504');

INSERT INTO schema_migrations (version) VALUES ('20140222154814');

INSERT INTO schema_migrations (version) VALUES ('20140305052056');

INSERT INTO schema_migrations (version) VALUES ('20140309073407');

INSERT INTO schema_migrations (version) VALUES ('20140309173009');

INSERT INTO schema_migrations (version) VALUES ('20140309220617');

INSERT INTO schema_migrations (version) VALUES ('20140309230923');

INSERT INTO schema_migrations (version) VALUES ('20140311025421');

INSERT INTO schema_migrations (version) VALUES ('20140311030031');

INSERT INTO schema_migrations (version) VALUES ('20140316025935');

INSERT INTO schema_migrations (version) VALUES ('20140320023302');

INSERT INTO schema_migrations (version) VALUES ('20140320023321');

INSERT INTO schema_migrations (version) VALUES ('20140320024338');

INSERT INTO schema_migrations (version) VALUES ('20140320024806');

INSERT INTO schema_migrations (version) VALUES ('20140320045856');

INSERT INTO schema_migrations (version) VALUES ('20140320170014');

