--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7
-- Dumped by pg_dump version 13.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: nested; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.nested AS (
	json json,
	extra text
);


--
-- Name: populate_full_text_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.populate_full_text_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW._full_text IS NOT NULL THEN
            RETURN NEW;
        END IF;
        NEW._full_text := (
            SELECT to_tsvector(string_agg(value, ' '))
            FROM json_each_text(row_to_json(NEW.*))
            WHERE key NOT LIKE '\_%');
        RETURN NEW;
    END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: 3d3e45dd-2367-4699-a4a5-55abe3bb0afa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."3d3e45dd-2367-4699-a4a5-55abe3bb0afa" (
    _id integer NOT NULL,
    _full_text tsvector,
    "FECHA" text,
    "TIPO_REPORTE" text,
    "TIPO_DATO" text,
    "SUBTIPO_DATO" text,
    "VALOR" text,
    "FECHA_PROCESO" text,
    "ID_CARGA" text
);


--
-- Name: 3d3e45dd-2367-4699-a4a5-55abe3bb0afa__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."3d3e45dd-2367-4699-a4a5-55abe3bb0afa__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: 3d3e45dd-2367-4699-a4a5-55abe3bb0afa__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."3d3e45dd-2367-4699-a4a5-55abe3bb0afa__id_seq" OWNED BY public."3d3e45dd-2367-4699-a4a5-55abe3bb0afa"._id;


--
-- Name: _table_metadata; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public._table_metadata AS
 SELECT DISTINCT substr(md5(((dependee.relname)::text || (COALESCE(dependent.relname, ''::name))::text)), 0, 17) AS _id,
    dependee.relname AS name,
    dependee.oid,
    dependent.relname AS alias_of
   FROM (((pg_class dependee
     LEFT JOIN pg_rewrite r ON ((r.ev_class = dependee.oid)))
     LEFT JOIN pg_depend d ON ((d.objid = r.oid)))
     LEFT JOIN pg_class dependent ON ((d.refobjid = dependent.oid)))
  WHERE (((dependee.oid <> dependent.oid) OR (dependent.oid IS NULL)) AND ((dependee.relkind = 'r'::"char") OR (dependee.relkind = 'v'::"char")) AND (dependee.relnamespace = ( SELECT pg_namespace.oid
           FROM pg_namespace
          WHERE (pg_namespace.nspname = 'public'::name))))
  ORDER BY dependee.oid DESC;


--
-- Name: c7604eec-c599-4dbc-8c4d-472239533051; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."c7604eec-c599-4dbc-8c4d-472239533051" (
    _id integer NOT NULL,
    _full_text tsvector,
    "FECHA_MUESTRA" text,
    "TIPO" text,
    "DISPOSITIVO" text,
    "GENERO" text,
    "GRUPO_ETARIO" text,
    "N" text
);


--
-- Name: c7604eec-c599-4dbc-8c4d-472239533051__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."c7604eec-c599-4dbc-8c4d-472239533051__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: c7604eec-c599-4dbc-8c4d-472239533051__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."c7604eec-c599-4dbc-8c4d-472239533051__id_seq" OWNED BY public."c7604eec-c599-4dbc-8c4d-472239533051"._id;


--
-- Name: 3d3e45dd-2367-4699-a4a5-55abe3bb0afa _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."3d3e45dd-2367-4699-a4a5-55abe3bb0afa" ALTER COLUMN _id SET DEFAULT nextval('public."3d3e45dd-2367-4699-a4a5-55abe3bb0afa__id_seq"'::regclass);


--
-- Name: c7604eec-c599-4dbc-8c4d-472239533051 _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."c7604eec-c599-4dbc-8c4d-472239533051" ALTER COLUMN _id SET DEFAULT nextval('public."c7604eec-c599-4dbc-8c4d-472239533051__id_seq"'::regclass);


--
-- Data for Name: 3d3e45dd-2367-4699-a4a5-55abe3bb0afa; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."3d3e45dd-2367-4699-a4a5-55abe3bb0afa" (_id, _full_text, "FECHA", "TIPO_REPORTE", "TIPO_DATO", "SUBTIPO_DATO", "VALOR", "FECHA_PROCESO", "ID_CARGA") FROM stdin;
\.


--
-- Data for Name: c7604eec-c599-4dbc-8c4d-472239533051; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."c7604eec-c599-4dbc-8c4d-472239533051" (_id, _full_text, "FECHA_MUESTRA", "TIPO", "DISPOSITIVO", "GENERO", "GRUPO_ETARIO", "N") FROM stdin;
\.


--
-- Name: 3d3e45dd-2367-4699-a4a5-55abe3bb0afa__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."3d3e45dd-2367-4699-a4a5-55abe3bb0afa__id_seq"', 1, false);


--
-- Name: c7604eec-c599-4dbc-8c4d-472239533051__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."c7604eec-c599-4dbc-8c4d-472239533051__id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

