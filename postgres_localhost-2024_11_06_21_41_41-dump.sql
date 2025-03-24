--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

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
-- Name: dryckesalskarens_odysse; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dryckesalskarens_odysse;


ALTER SCHEMA dryckesalskarens_odysse OWNER TO postgres;

--
-- Name: roll; Type: TYPE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TYPE dryckesalskarens_odysse.roll AS ENUM (
    'admin',
    'företag',
    'kund'
);


ALTER TYPE dryckesalskarens_odysse.roll OWNER TO postgres;

--
-- Name: stjärnor; Type: TYPE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TYPE dryckesalskarens_odysse."stjärnor" AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5'
);


ALTER TYPE dryckesalskarens_odysse."stjärnor" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: konto; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.konto (
    id integer NOT NULL,
    "lösenord" character varying(233) NOT NULL,
    "användarnamn" character varying(233) NOT NULL,
    profilbild character varying(1000),
    roll dryckesalskarens_odysse.roll NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.konto OWNER TO postgres;

--
-- Name: admin_inloggad_eller_inte; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.admin_inloggad_eller_inte AS
 SELECT
        CASE
            WHEN (('dryckesälskaren'::text = ("användarnamn")::text) AND ('ashude672s'::text = ("lösenord")::text)) THEN 'Välkommen Admin! Du är inloggad.'::text
            ELSE 'Något gick fel, kolla ditt användarnamn eller lösenord och prova igen!'::text
        END AS status
   FROM dryckesalskarens_odysse.konto
  WHERE (("användarnamn")::text = 'dryckesälskaren'::text);


ALTER VIEW dryckesalskarens_odysse.admin_inloggad_eller_inte OWNER TO postgres;

--
-- Name: personuppgifter; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.personuppgifter (
    id integer NOT NULL,
    "förnamn" character varying(255) NOT NULL,
    efternamn character varying(255) NOT NULL,
    personnummer character varying(32) NOT NULL,
    mail character varying(233) NOT NULL,
    adress_id integer NOT NULL,
    telefonnummer character varying(32),
    konto_id integer NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.personuppgifter OWNER TO postgres;

--
-- Name: admin_profilinformation; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.admin_profilinformation AS
 SELECT k.roll,
    k."användarnamn",
    personuppgifter."förnamn",
    personuppgifter.efternamn,
    personuppgifter.mail,
    k.profilbild
   FROM (dryckesalskarens_odysse.personuppgifter
     JOIN dryckesalskarens_odysse.konto k ON ((personuppgifter.konto_id = k.id)))
  WHERE (k.roll = 'admin'::dryckesalskarens_odysse.roll);


ALTER VIEW dryckesalskarens_odysse.admin_profilinformation OWNER TO postgres;

--
-- Name: adress; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.adress (
    id integer NOT NULL,
    gatunamn character varying(233) NOT NULL,
    gatunummer character varying(233),
    postnummer character varying(233) NOT NULL,
    ort character varying(233) NOT NULL,
    land character varying(255) NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.adress OWNER TO postgres;

--
-- Name: adress_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse.adress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse.adress_id_seq OWNER TO postgres;

--
-- Name: adress_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse.adress_id_seq OWNED BY dryckesalskarens_odysse.adress.id;


--
-- Name: aktivitet; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.aktivitet (
    id integer NOT NULL,
    aktivitet_namn character varying(255),
    beskrivning character varying(255),
    aktivitetspris numeric,
    antal_platser integer NOT NULL,
    aktivitetsdatum date,
    "barnvänligt" boolean,
    "företagsuppgifter_id" integer,
    alkoholfritt boolean,
    aktivitetstid time without time zone,
    lediga_platser integer NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.aktivitet OWNER TO postgres;

--
-- Name: aktivitet_x_adress; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.aktivitet_x_adress (
    aktiviteter_id integer,
    adress_id integer
);


ALTER TABLE dryckesalskarens_odysse.aktivitet_x_adress OWNER TO postgres;

--
-- Name: aktivitet_sökning; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."aktivitet_sökning" AS
 SELECT aktivitet.id,
    aktivitet.aktivitet_namn,
    aktivitet.beskrivning,
    aktivitet.aktivitetspris,
    aktivitet.aktivitetsdatum,
    adress.ort,
    adress.land
   FROM ((dryckesalskarens_odysse.aktivitet
     JOIN dryckesalskarens_odysse.aktivitet_x_adress ON ((aktivitet.id = aktivitet_x_adress.aktiviteter_id)))
     JOIN dryckesalskarens_odysse.adress ON ((aktivitet_x_adress.adress_id = adress.id)))
  WHERE ((aktivitet.aktivitet_namn)::text = 'arbogapaketet'::text);


ALTER VIEW dryckesalskarens_odysse."aktivitet_sökning" OWNER TO postgres;

--
-- Name: aktiviteter_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse.aktiviteter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse.aktiviteter_id_seq OWNER TO postgres;

--
-- Name: aktiviteter_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse.aktiviteter_id_seq OWNED BY dryckesalskarens_odysse.aktivitet.id;


--
-- Name: betyg; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.betyg (
    id integer NOT NULL,
    hotell integer,
    aktivitet integer,
    bokning integer,
    beskrivning character varying(255),
    konto_id integer
);


ALTER TABLE dryckesalskarens_odysse.betyg OWNER TO postgres;

--
-- Name: alla_recensioner; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.alla_recensioner AS
 SELECT b.beskrivning,
    p."förnamn",
    p.efternamn,
    b.hotell,
    b.bokning,
    b.aktivitet
   FROM (dryckesalskarens_odysse.betyg b
     JOIN dryckesalskarens_odysse.personuppgifter p ON ((b.konto_id = p.id)));


ALTER VIEW dryckesalskarens_odysse.alla_recensioner OWNER TO postgres;

--
-- Name: användare_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse."användare_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse."användare_id_seq" OWNER TO postgres;

--
-- Name: användare_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse."användare_id_seq" OWNED BY dryckesalskarens_odysse.personuppgifter.id;


--
-- Name: användare_inloggad_eller_inte; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."användare_inloggad_eller_inte" AS
 SELECT
        CASE
            WHEN (('annasvensson'::text = ("användarnamn")::text) AND ('säkertLösenord123'::text = ("lösenord")::text)) THEN 'Welcome! You are logged in.'::text
            ELSE 'Något gick fel, kolla ditt användarnamn eller lösenord och prova igen!'::text
        END AS status
   FROM dryckesalskarens_odysse.konto
  WHERE (("användarnamn")::text = 'annasvensson'::text);


ALTER VIEW dryckesalskarens_odysse."användare_inloggad_eller_inte" OWNER TO postgres;

--
-- Name: bokningsalternativ_x_hotell; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.bokningsalternativ_x_hotell (
    hotell_id integer,
    pool boolean NOT NULL,
    wifi boolean NOT NULL,
    flygplats_transfer boolean NOT NULL,
    aktivitet_transfer boolean NOT NULL,
    balkong boolean NOT NULL,
    hiss boolean NOT NULL,
    handikappanpassad boolean NOT NULL,
    spa boolean NOT NULL,
    "husdjurvänligt" boolean NOT NULL,
    barnklubb boolean NOT NULL,
    gym boolean NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.bokningsalternativ_x_hotell OWNER TO postgres;

--
-- Name: hotell; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.hotell (
    id integer NOT NULL,
    hotell_namn character varying(233) NOT NULL,
    beskrivning character varying(1000),
    incheckning time without time zone,
    utcheckning time without time zone,
    adress_id integer NOT NULL,
    "förtagsuppgifter_id" integer NOT NULL,
    antal_rum integer NOT NULL,
    lediga_rum integer NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.hotell OWNER TO postgres;

--
-- Name: användare_ser_detaljerad_info_bokningsalternativ; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."användare_ser_detaljerad_info_bokningsalternativ" AS
 SELECT h.id AS hotell_id,
    h.hotell_namn,
    h.beskrivning,
    b.pool,
    b.wifi,
    b.flygplats_transfer,
    b.aktivitet_transfer,
    b.balkong,
    b.hiss,
    b.handikappanpassad,
    b.spa,
    b."husdjurvänligt",
    b.barnklubb,
    b.gym
   FROM (dryckesalskarens_odysse.hotell h
     JOIN dryckesalskarens_odysse.bokningsalternativ_x_hotell b ON ((h.id = b.hotell_id)))
  WHERE (h.id = 7);


ALTER VIEW dryckesalskarens_odysse."användare_ser_detaljerad_info_bokningsalternativ" OWNER TO postgres;

--
-- Name: användare_sorterar_sökresultat_efter_pris; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."användare_sorterar_sökresultat_efter_pris" AS
 SELECT id,
    aktivitet_namn,
    beskrivning,
    aktivitetspris,
    antal_platser,
    aktivitetsdatum,
    "barnvänligt",
    "företagsuppgifter_id",
    alkoholfritt,
    aktivitetstid,
    lediga_platser
   FROM dryckesalskarens_odysse.aktivitet
  WHERE ((lediga_platser > 1) AND ((aktivitetspris >= (100)::numeric) AND (aktivitetspris <= (500)::numeric)))
  ORDER BY aktivitetspris;


ALTER VIEW dryckesalskarens_odysse."användare_sorterar_sökresultat_efter_pris" OWNER TO postgres;

--
-- Name: användare_söker_boende_på_olika_orter_med_specifika_krav; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."användare_söker_boende_på_olika_orter_med_specifika_krav" AS
 SELECT h.id,
    h.hotell_namn,
    h.beskrivning,
    a.ort,
    h.antal_rum,
    h.lediga_rum
   FROM (dryckesalskarens_odysse.hotell h
     JOIN dryckesalskarens_odysse.adress a ON ((h.adress_id = a.id)))
  WHERE (((a.land)::text = 'spanien'::text) AND (h.antal_rum > 10) AND (h.lediga_rum > 0));


ALTER VIEW dryckesalskarens_odysse."användare_söker_boende_på_olika_orter_med_specifika_krav" OWNER TO postgres;

--
-- Name: användare_söker_på_specifika_boende_och_faciliteteter; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."användare_söker_på_specifika_boende_och_faciliteteter" AS
 SELECT hotell.id,
    hotell.hotell_namn,
    hotell.beskrivning,
    bxh.pool,
    bxh.wifi,
    bxh.gym
   FROM (dryckesalskarens_odysse.hotell
     JOIN dryckesalskarens_odysse.bokningsalternativ_x_hotell bxh ON ((hotell.id = bxh.hotell_id)))
  WHERE ((bxh.pool = true) AND (bxh.wifi = true) AND (bxh.gym = true));


ALTER VIEW dryckesalskarens_odysse."användare_söker_på_specifika_boende_och_faciliteteter" OWNER TO postgres;

--
-- Name: avstånd; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse."avstånd" (
    id integer NOT NULL,
    aktivitet_id integer,
    destination_id integer,
    hotell_id integer,
    "avstånd(km)" character varying(233)
);


ALTER TABLE dryckesalskarens_odysse."avstånd" OWNER TO postgres;

--
-- Name: avstånd_aktivitet_hotell; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."avstånd_aktivitet_hotell" AS
 SELECT a.id,
    a.hotell_id,
    act.aktivitet_namn,
    h.hotell_namn AS hotellnamn,
    a."avstånd(km)"
   FROM ((dryckesalskarens_odysse."avstånd" a
     JOIN dryckesalskarens_odysse.aktivitet act ON ((a.aktivitet_id = act.id)))
     JOIN dryckesalskarens_odysse.hotell h ON ((a.hotell_id = h.id)))
  WHERE ((a."avstånd(km)")::integer = 2);


ALTER VIEW dryckesalskarens_odysse."avstånd_aktivitet_hotell" OWNER TO postgres;

--
-- Name: avstånd_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse."avstånd_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse."avstånd_id_seq" OWNER TO postgres;

--
-- Name: avstånd_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse."avstånd_id_seq" OWNED BY dryckesalskarens_odysse."avstånd".id;


--
-- Name: bokning; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.bokning (
    id integer NOT NULL,
    konto_id integer NOT NULL,
    antal_vuxna integer NOT NULL,
    antal_barn integer NOT NULL,
    bokningsdatum date NOT NULL,
    totalbelopp numeric,
    betalat boolean,
    allergi character varying(255),
    "funktionsnedsättning" character varying(255),
    husdjur character varying(255)
);


ALTER TABLE dryckesalskarens_odysse.bokning OWNER TO postgres;

--
-- Name: beskrivning_av_allergier; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.beskrivning_av_allergier AS
 SELECT bokning.allergi,
    k."användarnamn",
    bokning.konto_id
   FROM (dryckesalskarens_odysse.bokning
     JOIN dryckesalskarens_odysse.konto k ON ((k.id = bokning.konto_id)));


ALTER VIEW dryckesalskarens_odysse.beskrivning_av_allergier OWNER TO postgres;

--
-- Name: beskrivning_av_antal_personer; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.beskrivning_av_antal_personer AS
 SELECT (bokning.antal_vuxna + bokning.antal_barn) AS antal_personer,
    k."användarnamn",
    bokning.konto_id,
    bokning.bokningsdatum
   FROM (dryckesalskarens_odysse.bokning
     JOIN dryckesalskarens_odysse.konto k ON ((k.id = bokning.konto_id)));


ALTER VIEW dryckesalskarens_odysse.beskrivning_av_antal_personer OWNER TO postgres;

--
-- Name: beskrivning_av_funktionsnedsättning; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."beskrivning_av_funktionsnedsättning" AS
 SELECT bokning."funktionsnedsättning",
    k."användarnamn",
    bokning.konto_id
   FROM (dryckesalskarens_odysse.bokning
     JOIN dryckesalskarens_odysse.konto k ON ((k.id = bokning.konto_id)));


ALTER VIEW dryckesalskarens_odysse."beskrivning_av_funktionsnedsättning" OWNER TO postgres;

--
-- Name: beskrivning_av_sällskapet; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."beskrivning_av_sällskapet" AS
 SELECT (bokning.antal_vuxna + bokning.antal_barn) AS antal_personer,
    bokning."funktionsnedsättning",
    bokning.allergi,
    k."användarnamn",
    bokning.konto_id,
    bokning.bokningsdatum
   FROM (dryckesalskarens_odysse.bokning
     JOIN dryckesalskarens_odysse.konto k ON ((k.id = bokning.konto_id)));


ALTER VIEW dryckesalskarens_odysse."beskrivning_av_sällskapet" OWNER TO postgres;

--
-- Name: betyg_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse.betyg_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse.betyg_id_seq OWNER TO postgres;

--
-- Name: betyg_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse.betyg_id_seq OWNED BY dryckesalskarens_odysse.betyg.id;


--
-- Name: bilder; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.bilder (
    hotell_id integer,
    aktivitet_id integer,
    beskrivning character varying(233),
    bilder character varying(1000)
);


ALTER TABLE dryckesalskarens_odysse.bilder OWNER TO postgres;

--
-- Name: bokning_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse.bokning_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse.bokning_id_seq OWNER TO postgres;

--
-- Name: bokning_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse.bokning_id_seq OWNED BY dryckesalskarens_odysse.bokning.id;


--
-- Name: bokning_x_aktivitet; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.bokning_x_aktivitet (
    bokning_id integer NOT NULL,
    aktivitet_id integer NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.bokning_x_aktivitet OWNER TO postgres;

--
-- Name: bokning_x_destination; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.bokning_x_destination (
    bokning_id integer NOT NULL,
    destination_id integer NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.bokning_x_destination OWNER TO postgres;

--
-- Name: bokning_x_rum; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.bokning_x_rum (
    bokning_id integer NOT NULL,
    rum_id integer NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.bokning_x_rum OWNER TO postgres;

--
-- Name: destination; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.destination (
    id integer NOT NULL,
    "från" character varying(255) NOT NULL,
    adress_id integer,
    flyg_incheckning timestamp without time zone NOT NULL,
    restid time without time zone,
    till character varying(233) NOT NULL,
    pris numeric NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.destination OWNER TO postgres;

--
-- Name: bokningshistorik; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.bokningshistorik AS
 SELECT bokning.bokningsdatum,
    k."användarnamn",
    d.till,
    d."från",
    d.flyg_incheckning
   FROM (((dryckesalskarens_odysse.bokning
     JOIN dryckesalskarens_odysse.bokning_x_destination bxd ON ((bokning.id = bxd.bokning_id)))
     JOIN dryckesalskarens_odysse.destination d ON ((d.id = bxd.destination_id)))
     JOIN dryckesalskarens_odysse.konto k ON ((k.id = bokning.konto_id)))
  WHERE ((bokning.bokningsdatum < '2024-11-05'::date) AND ((k."användarnamn")::text = 'roffe'::text));


ALTER VIEW dryckesalskarens_odysse.bokningshistorik OWNER TO postgres;

--
-- Name: destination_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse.destination_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse.destination_id_seq OWNER TO postgres;

--
-- Name: destination_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse.destination_id_seq OWNED BY dryckesalskarens_odysse.destination.id;


--
-- Name: detaljerad_info_om_aktiviteter; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.detaljerad_info_om_aktiviteter AS
 SELECT aktivitet.aktivitet_namn,
    aktivitet.beskrivning AS aktivitetsbeskrivning,
    aktivitet.aktivitetspris,
    aktivitet.aktivitetsdatum,
    aktivitet.aktivitetstid,
    aktivitet.antal_platser,
    aktivitet.lediga_platser,
    aktivitet."barnvänligt",
    aktivitet.alkoholfritt,
    b.beskrivning AS bildbeskrivning,
    b.bilder,
    a.gatunamn,
    a.gatunummer,
    a.postnummer,
    a.ort,
    a.land
   FROM (((dryckesalskarens_odysse.aktivitet
     JOIN dryckesalskarens_odysse.bilder b ON ((aktivitet.id = b.aktivitet_id)))
     JOIN dryckesalskarens_odysse.aktivitet_x_adress axa ON ((aktivitet.id = axa.aktiviteter_id)))
     JOIN dryckesalskarens_odysse.adress a ON ((a.id = axa.adress_id)));


ALTER VIEW dryckesalskarens_odysse.detaljerad_info_om_aktiviteter OWNER TO postgres;

--
-- Name: detaljerad_info_om_användare; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."detaljerad_info_om_användare" AS
 SELECT personuppgifter."förnamn",
    personuppgifter.efternamn,
    personuppgifter.personnummer,
    personuppgifter.mail,
    personuppgifter.telefonnummer,
    a.gatunamn,
    a.gatunummer,
    a.postnummer,
    a.ort,
    a.land,
    k."användarnamn",
    k."lösenord",
    k.profilbild,
    k.roll
   FROM ((dryckesalskarens_odysse.personuppgifter
     JOIN dryckesalskarens_odysse.adress a ON ((a.id = personuppgifter.adress_id)))
     JOIN dryckesalskarens_odysse.konto k ON ((k.id = personuppgifter.konto_id)));


ALTER VIEW dryckesalskarens_odysse."detaljerad_info_om_användare" OWNER TO postgres;

--
-- Name: detaljerad_info_om_resor; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.detaljerad_info_om_resor AS
 SELECT destination."från",
    destination.till,
    destination.flyg_incheckning,
    destination.restid,
    destination.pris,
    a.gatunamn,
    a.gatunummer,
    a.postnummer,
    a.ort,
    a.land
   FROM (dryckesalskarens_odysse.destination
     JOIN dryckesalskarens_odysse.adress a ON ((a.id = destination.adress_id)));


ALTER VIEW dryckesalskarens_odysse.detaljerad_info_om_resor OWNER TO postgres;

--
-- Name: rum; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.rum (
    id integer NOT NULL,
    rumstyp character varying(233) NOT NULL,
    hotell_id integer NOT NULL,
    "rumspris " numeric NOT NULL,
    rumsnummer integer NOT NULL,
    rumsbeskrivning character varying(255)
);


ALTER TABLE dryckesalskarens_odysse.rum OWNER TO postgres;

--
-- Name: rumstyper_x_hotell; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.rumstyper_x_hotell (
    hotell_id integer NOT NULL,
    enkelrum boolean NOT NULL,
    dubbelrum boolean NOT NULL,
    "trebäddsrum" boolean NOT NULL,
    "fyrbäddsrum" boolean NOT NULL,
    sovsal boolean NOT NULL,
    lyxrum boolean NOT NULL,
    familjerum boolean NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.rumstyper_x_hotell OWNER TO postgres;

--
-- Name: detaljerade_info_om_boende; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.detaljerade_info_om_boende AS
 SELECT hotell.hotell_namn,
    hotell.beskrivning AS hotellbeskrivning,
    hotell.incheckning,
    hotell.utcheckning,
    hotell.antal_rum,
    hotell.lediga_rum,
    b.beskrivning AS bildbeskrivning,
    b.bilder,
    a2.gatunamn,
    a2.gatunummer,
    a2.postnummer,
    a2.ort,
    a2.land,
    hxh.enkelrum,
    hxh.dubbelrum,
    hxh."trebäddsrum",
    hxh."fyrbäddsrum",
    hxh.sovsal,
    hxh.lyxrum,
    hxh.familjerum,
    r.rumsnummer,
    r.rumstyp,
    r."rumspris ",
    bxh.pool,
    bxh.wifi,
    bxh.flygplats_transfer,
    bxh.aktivitet_transfer,
    bxh.balkong,
    bxh.hiss,
    bxh.handikappanpassad,
    bxh.spa,
    bxh."husdjurvänligt",
    bxh.barnklubb,
    bxh.gym
   FROM (((((dryckesalskarens_odysse.hotell
     JOIN dryckesalskarens_odysse.bilder b ON ((hotell.id = b.hotell_id)))
     JOIN dryckesalskarens_odysse.rumstyper_x_hotell hxh ON ((hotell.id = hxh.hotell_id)))
     JOIN dryckesalskarens_odysse.rum r ON ((hotell.id = r.hotell_id)))
     JOIN dryckesalskarens_odysse.bokningsalternativ_x_hotell bxh ON ((hotell.id = bxh.hotell_id)))
     JOIN dryckesalskarens_odysse.adress a2 ON ((a2.id = hotell.adress_id)));


ALTER VIEW dryckesalskarens_odysse.detaljerade_info_om_boende OWNER TO postgres;

--
-- Name: företagsuppgifter; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse."företagsuppgifter" (
    id integer NOT NULL,
    "företagsnamn" character varying(233) NOT NULL,
    organisationsnummer character varying(233) NOT NULL,
    mail character varying(233) NOT NULL,
    adress_id integer NOT NULL,
    konto_id integer NOT NULL
);


ALTER TABLE dryckesalskarens_odysse."företagsuppgifter" OWNER TO postgres;

--
-- Name: företagsuppgifter_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse."företagsuppgifter_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse."företagsuppgifter_id_seq" OWNER TO postgres;

--
-- Name: företagsuppgifter_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse."företagsuppgifter_id_seq" OWNED BY dryckesalskarens_odysse."företagsuppgifter".id;


--
-- Name: hantera_feedback_från_användare; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."hantera_feedback_från_användare" AS
 SELECT b.beskrivning,
    p."förnamn",
    p.efternamn,
    p.mail,
    b.hotell,
    b.bokning,
    b.aktivitet
   FROM (dryckesalskarens_odysse.betyg b
     JOIN dryckesalskarens_odysse.personuppgifter p ON ((b.konto_id = p.id)))
  WHERE (b.hotell = 3);


ALTER VIEW dryckesalskarens_odysse."hantera_feedback_från_användare" OWNER TO postgres;

--
-- Name: har_bokningen_blivit_betald; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.har_bokningen_blivit_betald AS
 SELECT bokning.konto_id,
    k."användarnamn",
    bokning.betalat,
    bokning.totalbelopp AS totalbelopp_i_kr
   FROM (dryckesalskarens_odysse.bokning
     JOIN dryckesalskarens_odysse.konto k ON ((bokning.konto_id = k.id)))
  WHERE ((bokning.betalat = true) AND ((k."användarnamn")::text = 'arbogamannen'::text));


ALTER VIEW dryckesalskarens_odysse.har_bokningen_blivit_betald OWNER TO postgres;

--
-- Name: hotell_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse.hotell_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse.hotell_id_seq OWNER TO postgres;

--
-- Name: hotell_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse.hotell_id_seq OWNED BY dryckesalskarens_odysse.hotell.id;


--
-- Name: hotell_uppgifter; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.hotell_uppgifter AS
 SELECT h.hotell_namn,
    f.mail,
    h."förtagsuppgifter_id"
   FROM (dryckesalskarens_odysse.hotell h
     JOIN dryckesalskarens_odysse."företagsuppgifter" f ON ((f.id = h."förtagsuppgifter_id")));


ALTER VIEW dryckesalskarens_odysse.hotell_uppgifter OWNER TO postgres;

--
-- Name: konto_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse.konto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse.konto_id_seq OWNER TO postgres;

--
-- Name: konto_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse.konto_id_seq OWNED BY dryckesalskarens_odysse.konto.id;


--
-- Name: recension; Type: TABLE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE TABLE dryckesalskarens_odysse.recension (
    id integer NOT NULL,
    "stjärnor" dryckesalskarens_odysse."stjärnor" NOT NULL
);


ALTER TABLE dryckesalskarens_odysse.recension OWNER TO postgres;

--
-- Name: recencion_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse.recencion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse.recencion_id_seq OWNER TO postgres;

--
-- Name: recencion_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse.recencion_id_seq OWNED BY dryckesalskarens_odysse.recension.id;


--
-- Name: rum_id_seq; Type: SEQUENCE; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE SEQUENCE dryckesalskarens_odysse.rum_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dryckesalskarens_odysse.rum_id_seq OWNER TO postgres;

--
-- Name: rum_id_seq; Type: SEQUENCE OWNED BY; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER SEQUENCE dryckesalskarens_odysse.rum_id_seq OWNED BY dryckesalskarens_odysse.rum.id;


--
-- Name: ta_emot_meddelanden_från_användare; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse."ta_emot_meddelanden_från_användare" AS
 SELECT k."användarnamn",
    personuppgifter."förnamn",
    personuppgifter.efternamn,
    personuppgifter.mail,
    personuppgifter.konto_id
   FROM (dryckesalskarens_odysse.personuppgifter
     JOIN dryckesalskarens_odysse.konto k ON ((personuppgifter.konto_id = k.id)));


ALTER VIEW dryckesalskarens_odysse."ta_emot_meddelanden_från_användare" OWNER TO postgres;

--
-- Name: transport_sokning; Type: VIEW; Schema: dryckesalskarens_odysse; Owner: postgres
--

CREATE VIEW dryckesalskarens_odysse.transport_sokning AS
 SELECT destination.id,
    destination."från",
    destination.till,
    destination.flyg_incheckning,
    destination.restid,
    destination.pris,
    adress.gatunamn,
    adress.gatunummer,
    adress.postnummer,
    adress.ort,
    adress.land,
    bxh.flygplats_transfer,
    bxh.aktivitet_transfer
   FROM (((dryckesalskarens_odysse.destination
     JOIN dryckesalskarens_odysse.adress ON ((destination.adress_id = adress.id)))
     JOIN dryckesalskarens_odysse.hotell h ON ((adress.id = h.adress_id)))
     JOIN dryckesalskarens_odysse.bokningsalternativ_x_hotell bxh ON ((h.id = bxh.hotell_id)));


ALTER VIEW dryckesalskarens_odysse.transport_sokning OWNER TO postgres;

--
-- Name: adress id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.adress ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse.adress_id_seq'::regclass);


--
-- Name: aktivitet id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.aktivitet ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse.aktiviteter_id_seq'::regclass);


--
-- Name: avstånd id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse."avstånd" ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse."avstånd_id_seq"'::regclass);


--
-- Name: betyg id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.betyg ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse.betyg_id_seq'::regclass);


--
-- Name: bokning id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokning ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse.bokning_id_seq'::regclass);


--
-- Name: destination id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.destination ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse.destination_id_seq'::regclass);


--
-- Name: företagsuppgifter id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse."företagsuppgifter" ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse."företagsuppgifter_id_seq"'::regclass);


--
-- Name: hotell id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.hotell ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse.hotell_id_seq'::regclass);


--
-- Name: konto id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.konto ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse.konto_id_seq'::regclass);


--
-- Name: personuppgifter id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.personuppgifter ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse."användare_id_seq"'::regclass);


--
-- Name: recension id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.recension ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse.recencion_id_seq'::regclass);


--
-- Name: rum id; Type: DEFAULT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.rum ALTER COLUMN id SET DEFAULT nextval('dryckesalskarens_odysse.rum_id_seq'::regclass);


--
-- Data for Name: adress; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (1, 'korsvägen', '34', '12356', 'stockholm', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (2, 'spårvägen', '4c', '345678', 'göteborg', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (3, 'stickgatan', '2', '12734', 'göteborg', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (4, 'norrlandsgata', '78a', '12673', 'göteborg', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (5, 'vinterbacken', '65', '65478', 'malmö', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (6, 'ölhallen', '1', '56734', 'stockholm', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (8, 'reims', '14', '12456', 'champange', 'frankrike');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (10, 'heumarkt', '47', '50667', 'köln', 'tyskland');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (11, 'london_road', '7', 'SE14 5QS', 'london', 'england');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (12, 'castelao', '22', '48860', 'Biscay', 'spanien');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (7, 'sorundavägen', '89', '34523', 'kyoto', 'japan');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (13, 'fetavägen', '45', '1234665', 'thessaloniki', 'grekland');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (14, 'arbogavägen', '10', '345678', 'malmö', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (15, 'reims', '20', '12456', 'champange', 'frankrike');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (16, 'sorundavägen', '12', '34523', 'kyoto', 'japan');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (9, 'conwell_street', '99', 'k78ctna', 'longford', 'irland');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (17, 'pub_street', '45', 'k78ctna', 'longford', 'irland');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (18, 'heumarkt', '67', '50667', 'köln', 'tyskland');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (20, 'castelao', '34', '48860', 'biscay', 'spanien');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (21, 'london_road', '23', 'se14 5qs', 'london', 'england');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (22, 'apelsingatan', '3', '24543', 'thessaloniki', 'grekland');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (24, 'rakgatan', '87', '45678', 'göteborg', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (25, 'korvgatan', '2', '34623', 'göteborg', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (26, 'usvängen', '2d', '45673', 'göteborg', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (27, 'utkanten', '53', '12345', 'göteborg', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (28, 'långgatan', '7', '12345', 'umeå', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (29, 'långburksvägen', '4', '14238', 'göteborg', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (30, 'sveavägen', '45', '14564', 'lidköping', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (31, 'drottninggatan', '34', '16453', 'tranås', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (32, 'prippshörnan', '6', '16458', 'jönköping', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (23, 'rörvägen', '32', '87345', 'göteborg', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (33, 'skandiagatan', '3', '73233', 'arboga', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (34, 'givemebeerstreet', '45', '145622', 'longford', 'irland');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (35, 'fallingstreet', '5', '2695', 'malaga', 'spanien');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (36, 'partey', '6', '125874', 'champange', 'frankrike');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (37, 'workingninetofive', '89', 'seq 5hb', 'london', 'england');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (38, 'arigatosteet', '44', '11123', 'kyoto', 'japan');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (39, 'falirakihill', '150', '42258', 'thessaloniki', 'grekland');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (40, 'diagonaly', '100', '45987', 'köln', 'tyskland');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (41, 'drakenbergsvägen', '5', '73456', 'arboga', 'sverige');
INSERT INTO dryckesalskarens_odysse.adress (id, gatunamn, gatunummer, postnummer, ort, land) VALUES (19, 'ölhallen', '54', '56734', 'arboga', 'sverige');


--
-- Data for Name: aktivitet; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.aktivitet (id, aktivitet_namn, beskrivning, aktivitetspris, antal_platser, aktivitetsdatum, "barnvänligt", "företagsuppgifter_id", alkoholfritt, aktivitetstid, lediga_platser) VALUES (4, 'whiskey', 'prova olika lokala whiskeysorter', 200, 17, '2024-11-23', false, 5, false, '20:00:00', 4);
INSERT INTO dryckesalskarens_odysse.aktivitet (id, aktivitet_namn, beskrivning, aktivitetspris, antal_platser, aktivitetsdatum, "barnvänligt", "företagsuppgifter_id", alkoholfritt, aktivitetstid, lediga_platser) VALUES (2, 'vinprovning', 'prova lokala viner tillsamans med ostar ', 1800, 20, '2024-11-28', false, 8, true, '17:00:00', 15);
INSERT INTO dryckesalskarens_odysse.aktivitet (id, aktivitet_namn, beskrivning, aktivitetspris, antal_platser, aktivitetsdatum, "barnvänligt", "företagsuppgifter_id", alkoholfritt, aktivitetstid, lediga_platser) VALUES (8, 'arbogapaketet', 'flest arboga vinner', 500, 1, '2024-11-29', false, 1, false, '19:00:00', 0);
INSERT INTO dryckesalskarens_odysse.aktivitet (id, aktivitet_namn, beskrivning, aktivitetspris, antal_platser, aktivitetsdatum, "barnvänligt", "företagsuppgifter_id", alkoholfritt, aktivitetstid, lediga_platser) VALUES (7, 'champagneprovning', 'besök distriktet och prova olika sorter', 2500, 35, '2024-12-27', false, 3, true, '13:30:00', 1);
INSERT INTO dryckesalskarens_odysse.aktivitet (id, aktivitet_namn, beskrivning, aktivitetspris, antal_platser, aktivitetsdatum, "barnvänligt", "företagsuppgifter_id", alkoholfritt, aktivitetstid, lediga_platser) VALUES (3, 'Saft', 'gör din egna saft', 800, 30, '2024-12-21', true, 9, true, '11:30:00', 10);
INSERT INTO dryckesalskarens_odysse.aktivitet (id, aktivitet_namn, beskrivning, aktivitetspris, antal_platser, aktivitetsdatum, "barnvänligt", "företagsuppgifter_id", alkoholfritt, aktivitetstid, lediga_platser) VALUES (5, 'the', 'smaksätt och gör ditt egna the', 500, 10, '2024-12-30', true, 7, true, '14:00:00', 4);
INSERT INTO dryckesalskarens_odysse.aktivitet (id, aktivitet_namn, beskrivning, aktivitetspris, antal_platser, aktivitetsdatum, "barnvänligt", "företagsuppgifter_id", alkoholfritt, aktivitetstid, lediga_platser) VALUES (1, 'ölprovning', 'prova lokala ölsorter', 1500, 15, '2025-01-02', false, 6, true, '19:30:00', 5);
INSERT INTO dryckesalskarens_odysse.aktivitet (id, aktivitet_namn, beskrivning, aktivitetspris, antal_platser, aktivitetsdatum, "barnvänligt", "företagsuppgifter_id", alkoholfritt, aktivitetstid, lediga_platser) VALUES (6, 'kombuchaprovning', 'föreläsning och provning av kombucha', 1000, 25, '2024-11-30', true, 2, true, '11:00:00', 2);


--
-- Data for Name: aktivitet_x_adress; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.aktivitet_x_adress (aktiviteter_id, adress_id) VALUES (8, 41);
INSERT INTO dryckesalskarens_odysse.aktivitet_x_adress (aktiviteter_id, adress_id) VALUES (4, 34);
INSERT INTO dryckesalskarens_odysse.aktivitet_x_adress (aktiviteter_id, adress_id) VALUES (6, 35);
INSERT INTO dryckesalskarens_odysse.aktivitet_x_adress (aktiviteter_id, adress_id) VALUES (1, 37);
INSERT INTO dryckesalskarens_odysse.aktivitet_x_adress (aktiviteter_id, adress_id) VALUES (5, 39);
INSERT INTO dryckesalskarens_odysse.aktivitet_x_adress (aktiviteter_id, adress_id) VALUES (7, 36);
INSERT INTO dryckesalskarens_odysse.aktivitet_x_adress (aktiviteter_id, adress_id) VALUES (2, 40);
INSERT INTO dryckesalskarens_odysse.aktivitet_x_adress (aktiviteter_id, adress_id) VALUES (3, 38);


--
-- Data for Name: avstånd; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (9, 8, NULL, 8, '1');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (18, NULL, 7, 10, '6');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (6, 5, NULL, 11, '3');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (15, NULL, 8, 5, '8');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (4, 1, NULL, 10, '5');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (16, NULL, 2, 11, '5');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (1, 4, NULL, 6, '2');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (13, NULL, 3, 9, '10');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (3, 6, NULL, 9, '4');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (12, NULL, 4, 4, '8');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (19, NULL, 14, 7, '7');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (17, NULL, 6, 7, '4');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (14, NULL, 1, 10, '9');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (5, 3, NULL, 5, '5');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (2, 7, NULL, 4, '3');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (11, NULL, 5, 6, '6');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (20, NULL, 15, 8, '1');
INSERT INTO dryckesalskarens_odysse."avstånd" (id, aktivitet_id, destination_id, hotell_id, "avstånd(km)") VALUES (7, 2, NULL, 7, '2');


--
-- Data for Name: betyg; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.betyg (id, hotell, aktivitet, bokning, beskrivning, konto_id) VALUES (9, 2, 2, 2, 'Jag måste påpeka att servicen inte riktigt nådde upp till förväntningarna. Jag hoppas att detta kan förbättras i framtiden för en ännu bättre upplevelse.', 15);
INSERT INTO dryckesalskarens_odysse.betyg (id, hotell, aktivitet, bokning, beskrivning, konto_id) VALUES (8, 1, 1, 1, 'Jag är besviken över servicenivån under min vistelse. Personalen var inte särskilt hjälpsam och upplevelsen levde inte upp till förväntningarna. Det finns stort utrymme för förbättringar när det gäller kundbemötande och effektivitet.', 14);
INSERT INTO dryckesalskarens_odysse.betyg (id, hotell, aktivitet, bokning, beskrivning, konto_id) VALUES (11, 4, 4, 4, 'Jag är nöjd med min vistelse. Hotellet var rent och bekvämt', 17);
INSERT INTO dryckesalskarens_odysse.betyg (id, hotell, aktivitet, bokning, beskrivning, konto_id) VALUES (10, 3, 3, 3, 'Min vistelse var helt okej, men det fanns vissa aspekter som kunde ha varit bättre. Servicen var stundtals långsam, men personalen var vänlig.', 16);
INSERT INTO dryckesalskarens_odysse.betyg (id, hotell, aktivitet, bokning, beskrivning, konto_id) VALUES (13, 6, 6, 6, 'En mycket bra upplevelse! Aktiviteterna var välorganiserade och rummen höll hög standard. ', 19);
INSERT INTO dryckesalskarens_odysse.betyg (id, hotell, aktivitet, bokning, beskrivning, konto_id) VALUES (12, 5, 5, 5, 'Helt fantastiskt! Jag hade en superbra upplevelse från början till slut. Hotellet var snyggt och bekvämt.', 18);
INSERT INTO dryckesalskarens_odysse.betyg (id, hotell, aktivitet, bokning, beskrivning, konto_id) VALUES (15, 8, 8, 8, 'Jag måste påpeka att servicen inte riktigt nådde upp till förväntningarna. Jag hoppas att detta kan förbättras i framtiden för en ännu bättre upplevelse.', 21);
INSERT INTO dryckesalskarens_odysse.betyg (id, hotell, aktivitet, bokning, beskrivning, konto_id) VALUES (14, 7, 7, 7, 'Hotellet och aktiviteterna var genomsnittliga. Rummen var rena och bekväma', 20);
INSERT INTO dryckesalskarens_odysse.betyg (id, hotell, aktivitet, bokning, beskrivning, konto_id) VALUES (16, 1, NULL, NULL, 'Mycket trevligt boende med bra service', 1);


--
-- Data for Name: bilder; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 7, 'champnage', 'https://www.finewines.se/attachments/20211030_154712-jpg.24620/');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 7, 'champange ', 'https://noorsslott.se/wp-content/uploads/2024/03/fotografianoorsslottwebb36-2-650x600.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 8, 'arbogapaketet', 'https://www.arbogabryggeri.se/wp-content/uploads/2017/05/Arboga-originalet-webb.png');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 8, 'arboga i naturen', 'https://www.johansmat.se/wp-content/uploads/2018/08/arboga-extra-stark-102-800x800.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 8, 'prova varmbåga', 'https://i.ytimg.com/vi/JTuYR2q7Nxs/maxresdefault.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 3, 'så ser det ut när vi gör saft', 'https://receptfavoriter.se/sites/default/files/styles/large_recipe/public/koka_saft_1060_2.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 3, 'det finns många olika smaker', 'https://image.elle.se/image-4860351?imageId=4860351&width=1200&height=675');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 2, 'vin och ost', 'https://www.wheninbarcelona.com/uploads/9/7/2/6/97269752/vivinos_4.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 2, 'vin och ost', 'https://vinstocken.se/wp-content/uploads/2015/11/vin-ost.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 1, 'prova olika sorters öl', 'https://www.forfest.se/wp-content/uploads/2024/04/tips-for-att-arrangera-en-lyckad-olprovning-hemma-1.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 1, 'drick öl', 'https://cis.greatdays.se/Image.svc/GetProductImage/2052/std1');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 6, 'föreläsning om kombucha', 'https://www.folkuniversitetet.se/contentassets/e6c39e8f56e24a1291b53246fcd55fe1/240564724.jpg?preset=article600');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 6, 'prova att göra egen kombucha ', 'https://images-bonnier.imgix.net/files/ifo/production/20210428214233/kombucha-DdciauockrlFcWxjDMPbjQ.jpg?auto=compress');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 6, 'drick kombucha ', 'https://clinicascres.com/wp-content/uploads/2024/06/shutterstock_2343569427-copia-scaled.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 4, 'smaka whiskey', 'https://www.whisky.nu/wp-content/uploads/4-glas-whiskyprovning.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 4, 'drick olika sorters whiskey', 'https://static.thatsup.co/content/img/article/18/dec/guide-till-stockholms-basta-whiskyprovningar.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 5, 'olika sorters the', 'https://tea101.teabox.com/wp-content/uploads/2017/04/Facevbook-post-banner-768x402.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 5, 'prova theer', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR79CQmznKj0RDpbbCpdyJqWL7M474eUPChOyOQ1lcKTUSVHMz2GdroH-pUJyJEt5E0Xk8&usqp=CAU');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (5, NULL, 'husdjursvänligt', 'https://i0.wp.com/www.travelnews.se/wp-content/uploads/2021/08/Husdjur-pa-hotellrum-Scandic.jpg?resize=1280%2C850&ssl=1');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (5, NULL, 'vacker vy över tokyo', 'https://www.boijapan.se/bilder/hotell.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (4, NULL, 'barnklubb', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/550731294.jpg?k=7cbebdfcae66b0765acb17d741cdb4c384504f5966a4b946f3b67c40414655a8&o=&hp=1');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (8, NULL, 'arboga sunk hotell', 'https://cdn.ntm.se/api/v1/images/rxzkve2j/smart/width/980/height/551/as/jpeg/redirect');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (8, NULL, 'vacker vy från arboga sunk hotell', 'https://static.bonniernews.se/ba/b47dd568-db0a-424b-a156-ed452b55e2d8.jpeg?crop=3127%2C1759%2Cx0%2Cy129&width=1400&format=pjpg&auto=webp');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (7, NULL, 'konferens', 'https://www.elite.se/globalassets/images/konferens/stockholm/elite-marina-tower-stockholm-konferens-gyllendesalen_01.jpg?mode=crop&scale=both&width=1200&height=630');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (4, NULL, 'lyx', 'https://swedavia.imagevault.media/publishedmedia/3hc8iu12pchv4po37tyz/radisson_arlanda.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (6, NULL, 'robot', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQaywn-5M0_M3gOeGP6qb0SxxGy04P3JTtjHw&s');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (9, NULL, 'hotell med pool', 'https://www.elite.se/globalassets/images/hotell/orebro/elite-stora-hotellet/orbeso_hotell_2.jpg?mode=crop&scale=both&width=375&height=391');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (11, NULL, 'hotellet', 'https://cdn.britannica.com/96/115096-050-5AFDAF5D/Bellagio-Hotel-Casino-Las-Vegas.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (11, NULL, 'vacker utsikt', 'https://countrysidehotels.b-cdn.net/wp-content/uploads/2017/11/hennickehammar-toppbild.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (10, NULL, 'stad', 'https://www.hotelhansson.se/wp-content/uploads/2021/09/hotel-hansson.jpg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (10, NULL, 'spa', 'https://media-magazine.trivago.com/wp-content/uploads/2018/03/12085454/spahotell-stockholm-grand-hotel-stockholm-spa.jpeg');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (5, NULL, 'hotellterassen', 'https://www.travelbeyond.se/media/34033823/jp_four_seasons_kyoto_terrace_web.jpg?rmode=crop&ranchor=center&width=1920&height=1080&quality=90&upscale=true&rnd=638308997098600000');
INSERT INTO dryckesalskarens_odysse.bilder (hotell_id, aktivitet_id, beskrivning, bilder) VALUES (NULL, 8, 'arboga beskrivning', 'https://static.wikia.nocookie.net/parkliv/images/b/b5/18448020_120332000703975787_1083106205_n.jpg/revision/latest/scale-to-width-down/340?cb=20170518140612&path-prefix=sv');


--
-- Data for Name: bokning; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (8, 5, 3, 0, '2024-10-31', 17400, true, 'gluten_x2', NULL, NULL);
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (10, 2, 1, 0, '2024-10-30', 7500, false, 'skaldjur', NULL, 'hund_x1');
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (1, 4, 2, 0, '2024-11-02', 9750, true, 'nötter_x1', NULL, NULL);
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (2, 14, 2, 0, '2024-11-15', 5695, false, NULL, NULL, NULL);
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (15, 22, 2, 0, '2024-11-15', 14650, true, 'laktos_x1, gluten_x1', 'döv_x2', 'hund_x1');
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (20, 2, 1, 0, '2024-10-25', 900, true, 'skaldjur', NULL, 'hund_x1');
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (13, 17, 2, 0, '2024-11-15', 8200, true, NULL, 'blind_x1', 'hund_x1');
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (4, 21, 1, 1, '2024-11-20', 9300, true, 'ägg', NULL, 'katt_x2');
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (22, 26, 3, 3, '2024-11-15', 25000, true, 'gluten', NULL, NULL);
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (18, 26, 4, 2, '2024-11-15', 22800, true, 'gluten', 'rullstol_x1', NULL);
INSERT INTO dryckesalskarens_odysse.bokning (id, konto_id, antal_vuxna, antal_barn, bokningsdatum, totalbelopp, betalat, allergi, "funktionsnedsättning", husdjur) VALUES (23, 24, 3, 8, '2024-12-26', 10000, true, 'almond', 'alkoholintolerans_x2', 'katt_x3');


--
-- Data for Name: bokning_x_aktivitet; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.bokning_x_aktivitet (bokning_id, aktivitet_id) VALUES (2, 4);
INSERT INTO dryckesalskarens_odysse.bokning_x_aktivitet (bokning_id, aktivitet_id) VALUES (15, 7);
INSERT INTO dryckesalskarens_odysse.bokning_x_aktivitet (bokning_id, aktivitet_id) VALUES (4, 6);
INSERT INTO dryckesalskarens_odysse.bokning_x_aktivitet (bokning_id, aktivitet_id) VALUES (1, 1);
INSERT INTO dryckesalskarens_odysse.bokning_x_aktivitet (bokning_id, aktivitet_id) VALUES (8, 3);
INSERT INTO dryckesalskarens_odysse.bokning_x_aktivitet (bokning_id, aktivitet_id) VALUES (18, 5);
INSERT INTO dryckesalskarens_odysse.bokning_x_aktivitet (bokning_id, aktivitet_id) VALUES (13, 2);
INSERT INTO dryckesalskarens_odysse.bokning_x_aktivitet (bokning_id, aktivitet_id) VALUES (10, 2);
INSERT INTO dryckesalskarens_odysse.bokning_x_aktivitet (bokning_id, aktivitet_id) VALUES (10, 8);


--
-- Data for Name: bokning_x_destination; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (2, 5);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (2, 9);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (15, 4);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (15, 10);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (4, 3);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (4, 11);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (1, 1);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (1, 12);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (8, 8);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (18, 2);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (18, 13);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (13, 6);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (10, 7);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (10, 14);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (10, 15);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (20, 17);
INSERT INTO dryckesalskarens_odysse.bokning_x_destination (bokning_id, destination_id) VALUES (20, 18);


--
-- Data for Name: bokning_x_rum; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (2, 1);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (15, 2);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (4, 3);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (1, 4);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (8, 5);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (18, 6);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (13, 7);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (10, 8);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (10, 9);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (10, 10);
INSERT INTO dryckesalskarens_odysse.bokning_x_rum (bokning_id, rum_id) VALUES (20, 11);


--
-- Data for Name: bokningsalternativ_x_hotell; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.bokningsalternativ_x_hotell (hotell_id, pool, wifi, flygplats_transfer, aktivitet_transfer, balkong, hiss, handikappanpassad, spa, "husdjurvänligt", barnklubb, gym) VALUES (4, true, true, true, true, true, true, true, true, true, true, true);
INSERT INTO dryckesalskarens_odysse.bokningsalternativ_x_hotell (hotell_id, pool, wifi, flygplats_transfer, aktivitet_transfer, balkong, hiss, handikappanpassad, spa, "husdjurvänligt", barnklubb, gym) VALUES (5, false, true, true, true, false, true, true, false, true, false, false);
INSERT INTO dryckesalskarens_odysse.bokningsalternativ_x_hotell (hotell_id, pool, wifi, flygplats_transfer, aktivitet_transfer, balkong, hiss, handikappanpassad, spa, "husdjurvänligt", barnklubb, gym) VALUES (6, false, true, true, true, false, false, false, false, false, true, false);
INSERT INTO dryckesalskarens_odysse.bokningsalternativ_x_hotell (hotell_id, pool, wifi, flygplats_transfer, aktivitet_transfer, balkong, hiss, handikappanpassad, spa, "husdjurvänligt", barnklubb, gym) VALUES (7, true, true, false, true, true, true, true, true, true, true, true);
INSERT INTO dryckesalskarens_odysse.bokningsalternativ_x_hotell (hotell_id, pool, wifi, flygplats_transfer, aktivitet_transfer, balkong, hiss, handikappanpassad, spa, "husdjurvänligt", barnklubb, gym) VALUES (8, false, false, false, false, true, false, true, false, true, false, false);
INSERT INTO dryckesalskarens_odysse.bokningsalternativ_x_hotell (hotell_id, pool, wifi, flygplats_transfer, aktivitet_transfer, balkong, hiss, handikappanpassad, spa, "husdjurvänligt", barnklubb, gym) VALUES (9, true, true, true, true, true, false, true, false, true, true, true);
INSERT INTO dryckesalskarens_odysse.bokningsalternativ_x_hotell (hotell_id, pool, wifi, flygplats_transfer, aktivitet_transfer, balkong, hiss, handikappanpassad, spa, "husdjurvänligt", barnklubb, gym) VALUES (10, false, true, true, true, false, false, true, true, true, true, false);
INSERT INTO dryckesalskarens_odysse.bokningsalternativ_x_hotell (hotell_id, pool, wifi, flygplats_transfer, aktivitet_transfer, balkong, hiss, handikappanpassad, spa, "husdjurvänligt", barnklubb, gym) VALUES (11, true, true, false, true, true, false, true, false, false, true, true);


--
-- Data for Name: destination; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (14, 'london', 10, '2024-11-24 14:32:00', '03:25:00', 'tyskland', 1800);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (7, 'sverige', 11, '2024-11-16 12:35:30', '02:03:00', 'london', 1200);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (10, 'frankrike', 31, '2025-01-04 14:35:00', '05:35:00', 'sverige', 1000);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (11, 'spanien', 23, '2024-12-10 16:35:00', '05:12:00', 'sverige', 1600);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (3, 'sverige', 20, '2024-11-29 13:15:00', '05:12:00', 'spanien', 1150);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (4, 'sverige', 15, '2024-12-26 08:30:00', '05:35:00', 'frankrike', 2000);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (5, 'sverige', 17, '2024-11-23 09:45:37', '03:55:00', 'irland', 500);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (9, 'irland', 14, '2024-11-26 10:00:00', '03:55:00', 'sverige', 300);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (8, 'sverige', 16, '2024-12-19 05:55:00', '12:12:00', 'japan', 2333.33);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (6, 'sverige', 18, '2024-11-28 07:20:00', '04:30:00', 'tyskland', 550);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (1, 'sverige', 21, '2024-12-31 10:17:21', '03:40:06', 'england', 1500);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (2, 'sverige', 22, '2024-12-29 12:20:41', '04:12:00', 'grekland', 300);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (12, 'england', 4, '2025-01-06 11:45:00', '03:40:06', 'sverige', 900);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (13, 'grekland', 2, '2025-01-28 10:02:00', '04:12:00', 'sverige', 833.33);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (15, 'tyskland', 33, '2024-11-28 23:58:59', '04:30:00', 'sverige', 800);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (17, 'sverige', 11, '2024-10-29 12:42:59', '03:40:00', 'england', 300);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (18, 'england', 3, '2024-10-30 21:44:13', '03:40:00', 'sverige', 300);
INSERT INTO dryckesalskarens_odysse.destination (id, "från", adress_id, flyg_incheckning, restid, till, pris) VALUES (19, 'sverige', 22, '2024-12-29 12:20:41', '04:12:00', 'grekland', 300);


--
-- Data for Name: företagsuppgifter; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse."företagsuppgifter" (id, "företagsnamn", organisationsnummer, mail, adress_id, konto_id) VALUES (1, 'mr.arboga', '857274-242355', 'arboga@dyngrak.se', 6, 6);
INSERT INTO dryckesalskarens_odysse."företagsuppgifter" (id, "företagsnamn", organisationsnummer, mail, adress_id, konto_id) VALUES (2, 'kombucha_kungen', '837474-122349', 'kombucha@kungen.se', 7, 7);
INSERT INTO dryckesalskarens_odysse."företagsuppgifter" (id, "företagsnamn", organisationsnummer, mail, adress_id, konto_id) VALUES (3, 'moet', '135565-645756', 'moet_chandon@champagne.com', 8, 8);
INSERT INTO dryckesalskarens_odysse."företagsuppgifter" (id, "företagsnamn", organisationsnummer, mail, adress_id, konto_id) VALUES (5, 'irish_spirits', '864456-35786a', 'irish_spirits@gmail.com', 9, 9);
INSERT INTO dryckesalskarens_odysse."företagsuppgifter" (id, "företagsnamn", organisationsnummer, mail, adress_id, konto_id) VALUES (6, 'kölsch_beer', 'f43245-894563', 'german_beer@gmail.com', 10, 10);
INSERT INTO dryckesalskarens_odysse."företagsuppgifter" (id, "företagsnamn", organisationsnummer, mail, adress_id, konto_id) VALUES (7, 'Lonon_the', '357644-085552', 'london_the@outlook.com', 11, 11);
INSERT INTO dryckesalskarens_odysse."företagsuppgifter" (id, "företagsnamn", organisationsnummer, mail, adress_id, konto_id) VALUES (8, 'castilla_la_mancha', '976466-452435', 'castilla@outlook.com', 12, 12);
INSERT INTO dryckesalskarens_odysse."företagsuppgifter" (id, "företagsnamn", organisationsnummer, mail, adress_id, konto_id) VALUES (9, 'greksaften_AB', '123456-090994', 'greken@outlook.com', 13, 13);


--
-- Data for Name: hotell; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.hotell (id, hotell_namn, beskrivning, incheckning, utcheckning, adress_id, "förtagsuppgifter_id", antal_rum, lediga_rum) VALUES (8, 'arboga_cityhotell', 'rustikt hotell i centrala arboga.', '10:00:00', '10:00:00', 19, 1, 1, 1);
INSERT INTO dryckesalskarens_odysse.hotell (id, hotell_namn, beskrivning, incheckning, utcheckning, adress_id, "förtagsuppgifter_id", antal_rum, lediga_rum) VALUES (11, 'harbor_view_hotel', 'hotell med vacker utsikt över hamnen i thessaloniki.', '11:00:00', '12:00:00', 22, 9, 400, 350);
INSERT INTO dryckesalskarens_odysse.hotell (id, hotell_namn, beskrivning, incheckning, utcheckning, adress_id, "förtagsuppgifter_id", antal_rum, lediga_rum) VALUES (5, 'greenway_hotell', 'eco-vänligt hotell i centrala Kyoto.', '14:00:00', '11:00:00', 16, 2, 200, 150);
INSERT INTO dryckesalskarens_odysse.hotell (id, hotell_namn, beskrivning, incheckning, utcheckning, adress_id, "förtagsuppgifter_id", antal_rum, lediga_rum) VALUES (4, 'design_boutique hotel', 'charmigt hotell med unik design och stil.', '12:00:00', '10:00:00', 15, 3, 20, 15);
INSERT INTO dryckesalskarens_odysse.hotell (id, hotell_namn, beskrivning, incheckning, utcheckning, adress_id, "förtagsuppgifter_id", antal_rum, lediga_rum) VALUES (6, 'industry_hotell', 'futuristiskt hotell med robotservice.', '12:00:00', '10:00:00', 17, 5, 45, 10);
INSERT INTO dryckesalskarens_odysse.hotell (id, hotell_namn, beskrivning, incheckning, utcheckning, adress_id, "förtagsuppgifter_id", antal_rum, lediga_rum) VALUES (9, 'Suntrip', 'soligt hotell med takterrass i spanien.', '11:00:00', '10:00:00', 20, 8, 50, 25);
INSERT INTO dryckesalskarens_odysse.hotell (id, hotell_namn, beskrivning, incheckning, utcheckning, adress_id, "förtagsuppgifter_id", antal_rum, lediga_rum) VALUES (10, 'star_suites', 'modernt hotell med bra läge i london', '14:00:00', '10:00:00', 21, 7, 750, 400);
INSERT INTO dryckesalskarens_odysse.hotell (id, hotell_namn, beskrivning, incheckning, utcheckning, adress_id, "förtagsuppgifter_id", antal_rum, lediga_rum) VALUES (7, 'Munchen_hotell', 'affärsinriktat hotell med konferensrum.', '11:00:00', '10:00:00', 18, 6, 150, 51);


--
-- Data for Name: konto; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (1, 'ashude672s', 'dryckesälskaren', 'https://cdn.pixabay.com/photo/2022/07/31/20/03/alcoholic-drinks-7356721_1280.png', 'admin');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (6, '865gtygf5', 'arboga', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnHeSzw5FfAFdg_PN6Ft9TMVBxlhjJtjuVKw&s', 'företag');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (7, '345njkdsfH', 'kombuchan', 'https://www.quna.nu/cdn/shop/products/thumbnail_HakunaMatilda_2048x.png?v=1670585357', 'företag');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (4, '7656GAdcd', 'arbogamannen', 'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/13/49/f1/1349f162-53ff-fa43-9c5f-3d355a023dcf/338f642b-93c9-415d-935c-7a5d82ce58cb.jpg/486x486bb.png', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (5, 'nfjef33bW', 'loffeloffe', 'https://images.bravo.de/profilbilder-lustig-obst-mit-klebeaugenjpg', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (3, 'ks666fds1', 'lisa123', 'https://image.spreadshirtmedia.net/image-server/v1/products/T1459A839PA4459PT28D192476768W8836H10000/views/1', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (2, 'bhokfhH299', 'roffe', 'https://cdn.pixabay.com/photo/2016/12/07/21/01/cartoon-1890438_640.jpg', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (8, 'rgg4357g2', 'moet_brut', 'https://champagnebolaget.se/wp-content/uploads/2022/02/Vardagschampagner.png', 'företag');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (9, 'ghj65743', 'the_irish', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLoyjHRX0SC-S6gQBRqpDf01DBHBb8vdtJNg&s', 'företag');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (10, '325rtgef', 'drunken_german', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_cAEjx-ZHKHbz0vuIXGAfDVP7kDf8RUrevw&s', 'företag');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (11, 'ggh9002S', 'the_the_guy', 'https://www.freakykitchen.se/bilder/artiklar/zoom/12653_4.jpg?m=1705671054', 'företag');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (12, 'fdbfgh54', 'the_wineguy', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpGl42sVyNKZjjr_z-K2UB5y1Mngn6yDlbvg&s', 'företag');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (13, 'kjfn483t', 'greken', 'https://www.partyhallen.se/cache/8a/270x270-b_grekisk-gud-zeus-toga-1.jpg', 'företag');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (26, 'säkertLösenord123', 'annasvensson', 'https://utbildare.studentum.se/hubfs/en_bild_sager_mer_940x420_c.jpg', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (19, 'h56ui5', 'giraffen', 'https://images.bravo.de/profilbilder-lustig-obst-mit-klebeaugenjpg,id=93ed05df,b=bravo,w=1200,rm=sk.jpeg', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (20, '54745yw5yy', 'pyroman_fille', 'https://cdn.pixabay.com/photo/2016/03/31/19/58/avatar-1295429_640.png', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (16, 'g45ygw', 'kalleballe', 'https://whatsapp-profilfotos.de/wp-content/uploads/sites/2/2017/11/herz-blumen-profilbild-uai-258x258.png', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (18, '54w54y5', 'lilla_björnen', 'https://wallpapers.com/images/featured/sota-estetiska-profilbilder-pjfl391j3q0f7rlz.jpg', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (24, 'f45645t', 'bäcknar_anders', 'https://i.pinimg.com/236x/23/7a/4a/237a4aa9ea28a4714202dc512f595319.jpg', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (23, 'h5i89', 'miljö_greta', 'https://wallpapers.com/images/hd/cool-tiktok-profile-pictures-v0fqph56wqqpygoi.jpg', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (22, 'y4y5hrty', 'karinkarin', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcw4BfnRvFSpUPTSafuq3fmkbl4NN5yjIVVw&s', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (21, '45ywyt', 'pizza_emil', 'https://www.imagella.com/cdn/shop/products/714b586e65517d9c231b7e8e663ee2c9.jpg?v=1707575269&width=300', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (15, 'fdger4r', 'ankan', 'https://www.imagella.com/cdn/shop/products/00153900664a99c1e458d1ca315d1fad_a3c96ce2-c510-45b7-a1d1-b0b2f3c582c8.jpg?v=1708122477&width=300', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (17, '45yw4g', 'åsnan', 'https://image.spreadshirtmedia.net/image-server/v1/products/T1459A839PA4459PT28D192476768W8836H10000/views/1,width=1200,height=630,appearanceId=839,backgroundColor=F2F2F2/klon-av-profilbild-klistermaerke.jpg', 'kund');
INSERT INTO dryckesalskarens_odysse.konto (id, "lösenord", "användarnamn", profilbild, roll) VALUES (14, 'benhox38', 'dryckesälskaren38', 'https://cbbh.pixabay.com/photo/2022/07/31/20/03/alcoholic-drinks-7356721_1280.png', 'kund');


--
-- Data for Name: personuppgifter; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (3, 'lisa', 'fredriksson', '910907-4321', 'lisa@outlook.com', 3, '0704123400', 3);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (4, 'kent', 'nilsson', '820520-5656', 'kent@gmail.com', 4, '0312978130', 4);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (8, 'kalle', 'olofsson', '751011-8777', 'kalleballe@gmail.com', 32, '0704122312', 16);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (16, 'anders', 'bäcklund', '830615-6534', 'bäcklund@gmail.com', 24, '0705788223', 24);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (6, 'alex', 'bergström', '900312-6733', 'alex_bergström@gmail.com', 14, '0739456745', 14);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (5, 'olof', 'söderberg', '840111-9835', 'olof@gmail.com', 5, '0311257890', 5);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (13, 'emil', 'salon', '850912-3412', 'emil_salon@pizzamail.com', 23, '0708556642', 21);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (14, 'karin', 'åhberg', '830909-1266', 'åhberg@dinmail.com', 31, '0705112216', 22);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (10, 'anna', 'cofre', '860718-3411', 'cofre@outlook.com', 29, '0704557766', 18);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (11, 'håkan', 'westberg', '851207-4388', 'westber@volvo.se', 28, '0739127765', 19);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (12, 'filip', 'svensson', '850511-1287', 'fille@outlook.com', 30, '0739004531', 20);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (1, 'jonas', 'larsson', '850220-1234', 'jonas.larsson@outlook.com', 1, '0704690283', 1);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (2, 'roffe', 'andersson', '830617-5678', 'roffe@gmail.com', 33, '0706362735', 2);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (7, 'tove', 'myrberg', '860220-3423', 'myrber@outlook.com', 26, '0704786855', 15);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (15, 'greta', 'axelsson', '840505-4523', 'bensin@outlook.com', 25, '0705872345', 23);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (9, 'sara', 'larsson', '740907-4432', 'puckot@gmail.com', 27, '0739567843', 17);
INSERT INTO dryckesalskarens_odysse.personuppgifter (id, "förnamn", efternamn, personnummer, mail, adress_id, telefonnummer, konto_id) VALUES (17, 'Anna', 'Svensson', '820904-1222', 'anna.svensson@example.com', 2, '0701234567', 26);


--
-- Data for Name: recension; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.recension (id, "stjärnor") VALUES (2, '2');
INSERT INTO dryckesalskarens_odysse.recension (id, "stjärnor") VALUES (6, '4');
INSERT INTO dryckesalskarens_odysse.recension (id, "stjärnor") VALUES (5, '5');
INSERT INTO dryckesalskarens_odysse.recension (id, "stjärnor") VALUES (3, '3');
INSERT INTO dryckesalskarens_odysse.recension (id, "stjärnor") VALUES (4, '4');
INSERT INTO dryckesalskarens_odysse.recension (id, "stjärnor") VALUES (1, '1');
INSERT INTO dryckesalskarens_odysse.recension (id, "stjärnor") VALUES (7, '3');
INSERT INTO dryckesalskarens_odysse.recension (id, "stjärnor") VALUES (8, '2');


--
-- Data for Name: rum; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (5, 'familjerum', 5, 8000, 501, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (8, 'enkelrum', 10, 750, 201, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (1, 'lyxrum', 6, 2895, 401, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (6, 'familjerum', 11, 10000, 801, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (9, 'enkelrum', 7, 750, 101, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (3, 'dubbelrum', 9, 2800, 601, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (7, 'dubbelrum', 7, 3500, 102, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (10, 'enkelrum', 8, 500, 301, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (4, 'lyxrum', 10, 1950, 202, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (11, 'enkelrum', 10, 300, 202, NULL);
INSERT INTO dryckesalskarens_odysse.rum (id, rumstyp, hotell_id, "rumspris ", rumsnummer, rumsbeskrivning) VALUES (2, 'trebäddsrum', 4, 3650, 701, 'ett rum med tre bäddar');


--
-- Data for Name: rumstyper_x_hotell; Type: TABLE DATA; Schema: dryckesalskarens_odysse; Owner: postgres
--

INSERT INTO dryckesalskarens_odysse.rumstyper_x_hotell (hotell_id, enkelrum, dubbelrum, "trebäddsrum", "fyrbäddsrum", sovsal, lyxrum, familjerum) VALUES (9, true, true, false, true, true, true, true);
INSERT INTO dryckesalskarens_odysse.rumstyper_x_hotell (hotell_id, enkelrum, dubbelrum, "trebäddsrum", "fyrbäddsrum", sovsal, lyxrum, familjerum) VALUES (4, true, true, true, true, false, false, true);
INSERT INTO dryckesalskarens_odysse.rumstyper_x_hotell (hotell_id, enkelrum, dubbelrum, "trebäddsrum", "fyrbäddsrum", sovsal, lyxrum, familjerum) VALUES (11, true, true, false, true, false, true, true);
INSERT INTO dryckesalskarens_odysse.rumstyper_x_hotell (hotell_id, enkelrum, dubbelrum, "trebäddsrum", "fyrbäddsrum", sovsal, lyxrum, familjerum) VALUES (6, true, true, true, false, false, false, false);
INSERT INTO dryckesalskarens_odysse.rumstyper_x_hotell (hotell_id, enkelrum, dubbelrum, "trebäddsrum", "fyrbäddsrum", sovsal, lyxrum, familjerum) VALUES (7, true, true, true, true, false, false, true);
INSERT INTO dryckesalskarens_odysse.rumstyper_x_hotell (hotell_id, enkelrum, dubbelrum, "trebäddsrum", "fyrbäddsrum", sovsal, lyxrum, familjerum) VALUES (8, true, true, false, true, true, true, true);
INSERT INTO dryckesalskarens_odysse.rumstyper_x_hotell (hotell_id, enkelrum, dubbelrum, "trebäddsrum", "fyrbäddsrum", sovsal, lyxrum, familjerum) VALUES (5, true, true, true, true, false, true, false);
INSERT INTO dryckesalskarens_odysse.rumstyper_x_hotell (hotell_id, enkelrum, dubbelrum, "trebäddsrum", "fyrbäddsrum", sovsal, lyxrum, familjerum) VALUES (10, true, true, true, true, true, true, true);


--
-- Name: adress_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse.adress_id_seq', 41, true);


--
-- Name: aktiviteter_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse.aktiviteter_id_seq', 8, true);


--
-- Name: användare_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse."användare_id_seq"', 20, true);


--
-- Name: avstånd_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse."avstånd_id_seq"', 20, true);


--
-- Name: betyg_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse.betyg_id_seq', 16, true);


--
-- Name: bokning_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse.bokning_id_seq', 23, true);


--
-- Name: destination_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse.destination_id_seq', 20, true);


--
-- Name: företagsuppgifter_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse."företagsuppgifter_id_seq"', 9, true);


--
-- Name: hotell_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse.hotell_id_seq', 11, true);


--
-- Name: konto_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse.konto_id_seq', 26, true);


--
-- Name: recencion_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse.recencion_id_seq', 19, true);


--
-- Name: rum_id_seq; Type: SEQUENCE SET; Schema: dryckesalskarens_odysse; Owner: postgres
--

SELECT pg_catalog.setval('dryckesalskarens_odysse.rum_id_seq', 11, true);


--
-- Name: adress adress_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.adress
    ADD CONSTRAINT adress_pk PRIMARY KEY (id);


--
-- Name: aktivitet aktivitet_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.aktivitet
    ADD CONSTRAINT aktivitet_pk PRIMARY KEY (id);


--
-- Name: avstånd avstånd_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse."avstånd"
    ADD CONSTRAINT "avstånd_pk" PRIMARY KEY (id);


--
-- Name: betyg betyg_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.betyg
    ADD CONSTRAINT betyg_pk PRIMARY KEY (id);


--
-- Name: bokning bokning_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokning
    ADD CONSTRAINT bokning_pk PRIMARY KEY (id);


--
-- Name: destination destination_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.destination
    ADD CONSTRAINT destination_pk PRIMARY KEY (id);


--
-- Name: företagsuppgifter företagsuppgifter_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse."företagsuppgifter"
    ADD CONSTRAINT "företagsuppgifter_pk" PRIMARY KEY (id);


--
-- Name: hotell hotell_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.hotell
    ADD CONSTRAINT hotell_pk PRIMARY KEY (id);


--
-- Name: konto konto_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.konto
    ADD CONSTRAINT konto_pk PRIMARY KEY (id);


--
-- Name: personuppgifter personuppgifter_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.personuppgifter
    ADD CONSTRAINT personuppgifter_pk PRIMARY KEY (id);


--
-- Name: recension recension_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.recension
    ADD CONSTRAINT recension_pk PRIMARY KEY (id);


--
-- Name: rum rum_pk; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.rum
    ADD CONSTRAINT rum_pk PRIMARY KEY (id);


--
-- Name: konto unik_användarnamn; Type: CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.konto
    ADD CONSTRAINT "unik_användarnamn" UNIQUE ("användarnamn");


--
-- Name: aktivitet aktivitet_företagsuppgifter_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.aktivitet
    ADD CONSTRAINT "aktivitet_företagsuppgifter_id_fk" FOREIGN KEY ("företagsuppgifter_id") REFERENCES dryckesalskarens_odysse."företagsuppgifter"(id);


--
-- Name: aktivitet_x_adress aktivitet_x_adress_adress_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.aktivitet_x_adress
    ADD CONSTRAINT aktivitet_x_adress_adress_id_fk FOREIGN KEY (adress_id) REFERENCES dryckesalskarens_odysse.adress(id);


--
-- Name: aktivitet_x_adress aktivitet_x_adress_aktivitet_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.aktivitet_x_adress
    ADD CONSTRAINT aktivitet_x_adress_aktivitet_id_fk FOREIGN KEY (aktiviteter_id) REFERENCES dryckesalskarens_odysse.aktivitet(id);


--
-- Name: avstånd avstånd_aktivitet_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse."avstånd"
    ADD CONSTRAINT "avstånd_aktivitet_id_fk" FOREIGN KEY (aktivitet_id) REFERENCES dryckesalskarens_odysse.aktivitet(id);


--
-- Name: avstånd avstånd_destination_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse."avstånd"
    ADD CONSTRAINT "avstånd_destination_id_fk" FOREIGN KEY (destination_id) REFERENCES dryckesalskarens_odysse.destination(id);


--
-- Name: avstånd avstånd_hotell_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse."avstånd"
    ADD CONSTRAINT "avstånd_hotell_id_fk" FOREIGN KEY (hotell_id) REFERENCES dryckesalskarens_odysse.hotell(id);


--
-- Name: betyg betyg_konto_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.betyg
    ADD CONSTRAINT betyg_konto_id_fk FOREIGN KEY (konto_id) REFERENCES dryckesalskarens_odysse.konto(id);


--
-- Name: betyg betyg_recension_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.betyg
    ADD CONSTRAINT betyg_recension_id_fk FOREIGN KEY (hotell) REFERENCES dryckesalskarens_odysse.recension(id);


--
-- Name: betyg betyg_recension_id_fk_2; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.betyg
    ADD CONSTRAINT betyg_recension_id_fk_2 FOREIGN KEY (aktivitet) REFERENCES dryckesalskarens_odysse.recension(id);


--
-- Name: betyg betyg_recension_id_fk_3; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.betyg
    ADD CONSTRAINT betyg_recension_id_fk_3 FOREIGN KEY (bokning) REFERENCES dryckesalskarens_odysse.recension(id);


--
-- Name: bilder bilder_aktivitet_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bilder
    ADD CONSTRAINT bilder_aktivitet_id_fk FOREIGN KEY (aktivitet_id) REFERENCES dryckesalskarens_odysse.aktivitet(id);


--
-- Name: bilder bilder_hotell_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bilder
    ADD CONSTRAINT bilder_hotell_id_fk FOREIGN KEY (hotell_id) REFERENCES dryckesalskarens_odysse.hotell(id);


--
-- Name: bokning bokning_konto_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokning
    ADD CONSTRAINT bokning_konto_id_fk FOREIGN KEY (konto_id) REFERENCES dryckesalskarens_odysse.konto(id);


--
-- Name: bokning_x_aktivitet bokning_x_aktivitet_aktivitet_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokning_x_aktivitet
    ADD CONSTRAINT bokning_x_aktivitet_aktivitet_id_fk FOREIGN KEY (aktivitet_id) REFERENCES dryckesalskarens_odysse.aktivitet(id);


--
-- Name: bokning_x_aktivitet bokning_x_aktivitet_bokning_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokning_x_aktivitet
    ADD CONSTRAINT bokning_x_aktivitet_bokning_id_fk FOREIGN KEY (bokning_id) REFERENCES dryckesalskarens_odysse.bokning(id);


--
-- Name: bokning_x_destination bokning_x_destination_bokning_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokning_x_destination
    ADD CONSTRAINT bokning_x_destination_bokning_id_fk FOREIGN KEY (bokning_id) REFERENCES dryckesalskarens_odysse.bokning(id);


--
-- Name: bokning_x_destination bokning_x_destination_destination_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokning_x_destination
    ADD CONSTRAINT bokning_x_destination_destination_id_fk FOREIGN KEY (destination_id) REFERENCES dryckesalskarens_odysse.destination(id);


--
-- Name: bokning_x_rum bokning_x_rum_bokning_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokning_x_rum
    ADD CONSTRAINT bokning_x_rum_bokning_id_fk FOREIGN KEY (bokning_id) REFERENCES dryckesalskarens_odysse.bokning(id);


--
-- Name: bokning_x_rum bokning_x_rum_rum_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokning_x_rum
    ADD CONSTRAINT bokning_x_rum_rum_id_fk FOREIGN KEY (rum_id) REFERENCES dryckesalskarens_odysse.rum(id);


--
-- Name: bokningsalternativ_x_hotell bokningsalternativ_x_hotell_hotell_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.bokningsalternativ_x_hotell
    ADD CONSTRAINT bokningsalternativ_x_hotell_hotell_id_fk FOREIGN KEY (hotell_id) REFERENCES dryckesalskarens_odysse.hotell(id);


--
-- Name: destination destination_adress_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.destination
    ADD CONSTRAINT destination_adress_id_fk FOREIGN KEY (adress_id) REFERENCES dryckesalskarens_odysse.adress(id);


--
-- Name: företagsuppgifter företagsuppgifter_adress_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse."företagsuppgifter"
    ADD CONSTRAINT "företagsuppgifter_adress_id_fk" FOREIGN KEY (adress_id) REFERENCES dryckesalskarens_odysse.adress(id);


--
-- Name: företagsuppgifter företagsuppgifter_konto_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse."företagsuppgifter"
    ADD CONSTRAINT "företagsuppgifter_konto_id_fk" FOREIGN KEY (konto_id) REFERENCES dryckesalskarens_odysse.konto(id);


--
-- Name: hotell hotell_adress_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.hotell
    ADD CONSTRAINT hotell_adress_id_fk FOREIGN KEY (adress_id) REFERENCES dryckesalskarens_odysse.adress(id);


--
-- Name: hotell hotell_företagsuppgifter_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.hotell
    ADD CONSTRAINT "hotell_företagsuppgifter_id_fk" FOREIGN KEY ("förtagsuppgifter_id") REFERENCES dryckesalskarens_odysse."företagsuppgifter"(id);


--
-- Name: personuppgifter personuppgifter_adress_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.personuppgifter
    ADD CONSTRAINT personuppgifter_adress_id_fk FOREIGN KEY (adress_id) REFERENCES dryckesalskarens_odysse.adress(id);


--
-- Name: personuppgifter personuppgifter_konto_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.personuppgifter
    ADD CONSTRAINT personuppgifter_konto_id_fk FOREIGN KEY (konto_id) REFERENCES dryckesalskarens_odysse.konto(id);


--
-- Name: rum rum_hotell_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.rum
    ADD CONSTRAINT rum_hotell_id_fk FOREIGN KEY (hotell_id) REFERENCES dryckesalskarens_odysse.hotell(id);


--
-- Name: rumstyper_x_hotell rumstyper_x_hotell_hotell_id_fk; Type: FK CONSTRAINT; Schema: dryckesalskarens_odysse; Owner: postgres
--

ALTER TABLE ONLY dryckesalskarens_odysse.rumstyper_x_hotell
    ADD CONSTRAINT rumstyper_x_hotell_hotell_id_fk FOREIGN KEY (hotell_id) REFERENCES dryckesalskarens_odysse.hotell(id);


--
-- PostgreSQL database dump complete
--

