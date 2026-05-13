--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

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
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: backend
--

--
-- Name: lawchunk; Type: TABLE; Schema: public; Owner: backend
--

CREATE TABLE public.lawchunk (
    document_number character varying(100) NOT NULL,
    year integer NOT NULL,
    fragment_id integer,
    depth integer,
    fragment_type character varying(50),
    clean_text text,
    embedding public.vector(768),
    id integer NOT NULL,
    source_kind character varying(20) NOT NULL,
    page_start integer,
    page_end integer,
    chunk_index integer,
    section_title character varying(255),
    source_filename character varying(255)
);


ALTER TABLE public.lawchunk OWNER TO backend;

--
-- Name: lawchunk_id_seq; Type: SEQUENCE; Schema: public; Owner: backend
--

CREATE SEQUENCE public.lawchunk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lawchunk_id_seq OWNER TO backend;

--
-- Name: lawchunk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: backend
--

ALTER SEQUENCE public.lawchunk_id_seq OWNED BY public.lawchunk.id;


--
-- Name: service_locations; Type: TABLE; Schema: public; Owner: backend
--

CREATE TABLE public.service_locations (
    service_id integer NOT NULL,
    provider_id integer NOT NULL,
    street character varying(255),
    number character varying(64),
    district character varying(255),
    municipality character varying(255),
    postal_code character varying(16),
    region character varying(255),
    service_name character varying(255),
    lat numeric(10,7),
    lon numeric(10,7),
    id integer NOT NULL
);


ALTER TABLE public.service_locations OWNER TO backend;

--
-- Name: service_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: backend
--

CREATE SEQUENCE public.service_locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_locations_id_seq OWNER TO backend;

--
-- Name: service_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: backend
--

ALTER SEQUENCE public.service_locations_id_seq OWNED BY public.service_locations.id;


--
-- Name: servicetargetgroup; Type: TABLE; Schema: public; Owner: backend
--

CREATE TABLE public.servicetargetgroup (
    service_id integer NOT NULL,
    source_group_id integer NOT NULL,
    description text,
    id integer NOT NULL
);


ALTER TABLE public.servicetargetgroup OWNER TO backend;

--
-- Name: servicetargetgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: backend
--

CREATE SEQUENCE public.servicetargetgroup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.servicetargetgroup_id_seq OWNER TO backend;

--
-- Name: servicetargetgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: backend
--

ALTER SEQUENCE public.servicetargetgroup_id_seq OWNED BY public.servicetargetgroup.id;


--
-- Name: socialservice; Type: TABLE; Schema: public; Owner: backend
--

CREATE TABLE public.socialservice (
    source_service_id integer NOT NULL,
    identifier character varying(32) NOT NULL,
    provider_id integer NOT NULL,
    provider_name character varying(255) NOT NULL,
    provider_ico character varying(32),
    service_type_id integer NOT NULL,
    active_from date NOT NULL,
    active_to date,
    region_scope_by_address boolean NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.socialservice OWNER TO backend;

--
-- Name: socialservice_id_seq; Type: SEQUENCE; Schema: public; Owner: backend
--

CREATE SEQUENCE public.socialservice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socialservice_id_seq OWNER TO backend;

--
-- Name: socialservice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: backend
--

ALTER SEQUENCE public.socialservice_id_seq OWNED BY public.socialservice.id;


--
-- Name: lawchunk id; Type: DEFAULT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.lawchunk ALTER COLUMN id SET DEFAULT nextval('public.lawchunk_id_seq'::regclass);


--
-- Name: service_locations id; Type: DEFAULT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.service_locations ALTER COLUMN id SET DEFAULT nextval('public.service_locations_id_seq'::regclass);


--
-- Name: servicetargetgroup id; Type: DEFAULT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.servicetargetgroup ALTER COLUMN id SET DEFAULT nextval('public.servicetargetgroup_id_seq'::regclass);


--
-- Name: socialservice id; Type: DEFAULT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.socialservice ALTER COLUMN id SET DEFAULT nextval('public.socialservice_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: backend
--

--
-- Data for Name: lawchunk; Type: TABLE DATA; Schema: public; Owner: backend
--

COPY public.lawchunk (document_number, year, fragment_id, depth, fragment_type, clean_text, embedding, id, source_kind, page_start, page_end, chunk_index, section_title, source_filename) FROM stdin;
\.


--
-- Data for Name: service_locations; Type: TABLE DATA; Schema: public; Owner: backend
--

COPY public.service_locations (service_id, provider_id, street, number, district, municipality, postal_code, region, service_name, lat, lon, id) FROM stdin;
7555	2606	Slovenského národního povstání	2742/10	Most	Most	43401	Ústecký kraj	Dobrodějna, z.ú.	50.5083986	13.6317230	1
7554	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Sociální rehabilitace pro sluchově postižené Ústí nad Labem	50.5066287	13.6604152	2
7553	193	Zahradnická	1534/5	Předměstí	Litoměřice	41201	Ústecký kraj	Charitní domov sv.Zdislava - odlehčovací služba	\N	\N	3
7527	391	Velká Hradební	13/47	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Centrum duševního zdraví pro adiktologické klienty	50.6603133	14.0372639	4
7524	2654	Dolní Maršov	415	Maršov	Krupka	41742	Ústecký kraj	Sociální aktivizace SK Teplice, z. s.	50.6790835	13.8899753	5
7523	2654	Dolní Maršov	415	Maršov	Krupka	41742	Ústecký kraj	Odborné poradenství SK Teplice, z.s.	50.6790835	13.8899753	6
7517	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	Denní stacionář Bílina	50.6335303	13.8287003	7
7480	2638	\N	85	Horní Podluží	Horní Podluží	40757	Ústecký kraj	PORADNA BAREVNÉ SOUŽITÍ,  z.s.	50.8818388	14.5486849	8
7432	2083	Na Poříčí	1041/12	Nové Město	Praha	11000	Hlavní město Praha	SOOD - pomoc sociálně ohroženým rodinám a dětem	50.0891798	14.4311979	9
7415	1583	Čelakovského	8/4	Pražské Předměstí	Písek	39701	Jihočeský kraj	Senevida Terezín	49.3097812	14.1397036	10
7413	1583	Čelakovského	8/4	Pražské Předměstí	Písek	39701	Jihočeský kraj	Senevida Terezín	49.3097812	14.1397036	11
7405	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Azylový dům Osek	50.4937747	13.6599037	12
7391	2627	Budějovická	778/3	Michle	Praha	14000	Hlavní město Praha	SESTŘIČKA.CZ - PEČOVATELKA z.ú. - Olomoucký kraj	50.0490324	14.4430812	13
7380	2622	Rudé armády	59	Droužkovice	Droužkovice	43144	Ústecký kraj	PARENT PROJECT, z. s. služba OSP	50.4292488	13.4318411	14
7377	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Centrum duševního zdraví pro děti a adolescenty Ústí nad Labem	50.6630615	14.0372032	15
7376	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Centrum duševního zdraví Litoměřice	50.6630615	14.0372032	16
7370	205	Petra Jilemnického	2457/1	Most	Most	43401	Ústecký kraj	Odlehčovací služba Mosťáček	50.5051147	13.6349047	17
7361	440	Hoření	3083/13	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	Centrum denních služeb KOSTKA	50.6750022	14.0363960	18
7357	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Sociální rehabilitace pro sluchově postižené Most	50.5066287	13.6604152	19
7356	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Sociální rehabilitace pro sluchově postižené Děčín	50.5066287	13.6604152	20
7349	205	Petra Jilemnického	2457/1	Most	Most	43401	Ústecký kraj	Poradna pro cizince	50.5051147	13.6349047	21
7341	1990	Vaníčkova	902/11	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Bateau - podpora duševního zdraví dětí a dospívajících	50.6604892	14.0337405	22
7338	2611	Školní	1054/28	Chomutov	Chomutov	43001	Ústecký kraj	Společně DOMA, z.ú.	50.4591930	13.4121355	23
7335	792	Rakovnická	2502	Louny	Louny	44001	Ústecký kraj	Sociální služby města Loun, příspěvková organizace	50.3480584	13.8071465	24
7334	792	Rakovnická	2502	Louny	Louny	44001	Ústecký kraj	Sociální služby města Loun, příspěvková organizace	50.3480584	13.8071465	25
7332	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Centrum duševního zdraví Louny, Žatec	50.6630615	14.0372032	26
7331	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Centrum duševního zdraví Chomutov	50.6630615	14.0372032	27
7330	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Centrum duševního zdraví Ústí nad Labem	50.6630615	14.0372032	28
7324	2606	Slovenského národního povstání	2742/10	Most	Most	43401	Ústecký kraj	Dobrodějna, z.ú.	50.5083986	13.6317230	29
7306	391	Velká Hradební	13/47	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Adiktologické centrum Varnsdorf	50.6603133	14.0372639	30
7305	435	Fügnerova	282/11	Trmice	Trmice	40004	Ústecký kraj	Klub Amaro Kheroro	50.6429157	13.9989999	31
7293	2597	Jana Zajíce	2877/7	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	INSTITUT AK, z. s.	50.6831497	14.0229281	32
7292	440	Hoření	3083/13	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	Odborná sociální poradna s centrem pro rodinné pečující	50.6750022	14.0363960	33
7271	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Odborné sociální poradenství pro osoby v nevyhovujícím a nejistém bydlení v Jirkově	50.5024682	13.7080234	34
7269	416	Věžní	958	Kadaň	Kadaň	43201	Ústecký kraj	Domov se zvláštním režimem	50.3761366	13.2759279	35
7247	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Třída Obránců míru	50.0481757	14.3111295	36
7246	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Domov sv. Anny	50.4937747	13.6599037	37
7205	864	Tyršova	350	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Komunitní dům sv. Dismase	50.8001475	14.4119825	38
7187	680	2. polské armády	1094/27	Rumburk 1	Rumburk	40801	Ústecký kraj	Agentura Pondělí - denní stacionář	50.9578602	14.5554399	39
7184	399	\N	71	Dolní Falknov	Kytlice	40745	Ústecký kraj	Domov pro osoby se zdravotním postižením Kytlice	50.8157110	14.5330443	40
7139	2565	Na dolinách	23/15	Podolí	Praha	14700	Hlavní město Praha	DS Střekov s.r.o.	50.0576012	14.4257159	41
7134	2563	Husitská	1683/2	Most	Most	43401	Ústecký kraj	Dětské centrum Ústeckého kraje, p.o.	50.5151755	13.6337908	42
7133	1913	Svatopluka Čecha	1541	Žatec	Žatec	43801	Ústecký kraj	Dluhová a sociální poradna v Žatci	50.3208044	13.5403026	43
7131	961	\N	11	Slatina	Slatina	41002	Ústecký kraj	Valdek, o.p.s.	50.4307114	14.0352046	44
7129	560	Na Výšině	494	Dubí	Dubí	41701	Ústecký kraj	DZR pro osoby s mentálním postižením v kombinaci s poruchami chování a diagnózou schizofrenie	50.6774965	13.7859498	45
7128	205	Petra Jilemnického	2457/1	Most	Most	43401	Ústecký kraj	Denní stacionář Mosťáček	50.5051147	13.6349047	46
7113	2557	Štefánikova	261/6	Klíše	Ústí nad Labem	40001	Ústecký kraj	Habition, z. s.	50.6732632	14.0155781	47
7110	2506	Ruská	292/2a	Pozorka	Dubí	41703	Ústecký kraj	Seniorcentrum Pohoda III.	50.6536388	13.8105564	48
7105	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Domov Teplice	50.6401921	14.0442611	49
7103	228	Lomená	47/2	Most	Most	43401	Ústecký kraj	Tým duševního zdraví pro děti a mladé lidi Most	50.5103141	13.6284795	50
7057	2543	\N	302	Dolní Chřibská	Chřibská	40744	Ústecký kraj	Domov Potoky (DZR10)	50.8586713	14.4405038	51
7056	2543	\N	302	Dolní Chřibská	Chřibská	40744	Ústecký kraj	Domov Potoky (DZR50)	50.8586713	14.4405038	52
7027	448	Mírové nám.	163	Štětí	Štětí	41108	Ústecký kraj	Sociálně aktivizační služba města Štětí pro rodiny s dětmi	50.4539625	14.3728533	53
6966	205	Petra Jilemnického	2457/1	Most	Most	43401	Ústecký kraj	SAS pro osoby s PAS	50.5051147	13.6349047	54
6955	2512	Škroupova	302/17	Děčín II-Nové Město	Děčín	40502	Ústecký kraj	Spolek Domácí péče Valerie	50.7792291	14.2322739	55
6945	2506	Ruská	292/2a	Pozorka	Dubí	41703	Ústecký kraj	Pečovatelská služba Pohoda	50.6536388	13.8105564	56
6944	2506	Ruská	292/2a	Pozorka	Dubí	41703	Ústecký kraj	Seniorcentrum Pohoda I.	50.6536388	13.8105564	57
6943	2506	Ruská	292/2a	Pozorka	Dubí	41703	Ústecký kraj	Seniorcentrum Pohoda II.	50.6536388	13.8105564	58
6942	2506	Ruská	292/2a	Pozorka	Dubí	41703	Ústecký kraj	Seniorcentrum Pohoda I.	50.6536388	13.8105564	59
6928	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Domov U Trati Litoměřice (DZR)	50.5205123	14.0453183	60
6925	142	Písečná	5030	Chomutov	Chomutov	43004	Ústecký kraj	Denní stacionář PAS Kamenná	50.4869592	13.4410344	61
6924	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Žatec	50.0481757	14.3111295	62
6923	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Chomutov	50.0481757	14.3111295	63
6920	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Azylový dům pro matky s dětmi	50.6732608	14.0160860	64
6885	2043	Revoluční	22/20	Chomutov	Chomutov	43001	Ústecký kraj	Poradna pro rodinu, manželství a mezilidské vztahy Chomutov	50.4608210	13.4201395	65
6884	71	Nám. E. Beneše	470	Varnsdorf	Varnsdorf	40747	Ústecký kraj	CSS města Varnsdorf - azylový dům	50.9120975	14.6197564	66
6882	1748	CHYBA: 'NoneType' object is not subscriptable	\N	\N	\N	\N	\N	Cesta do světa - denní stacionář	\N	\N	67
6868	2486	Lázeňská	21/3	Dubí	Dubí	41701	Ústecký kraj	Pečovatelská služba Dubí	50.6860306	13.7837063	68
6806	2472	nám. Svobody	700	Proboštov	Proboštov	41712	Ústecký kraj	Doubravka - komunitní domov Suché	50.6672543	13.8357527	69
6801	992	nám. ČSA	84	Terezín	Terezín	41155	Ústecký kraj	Chráněné bydlení Terezín	50.5100522	14.1490431	70
6785	864	Tyršova	350	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Nízkoprahové zařízení pro děti a mládež sv. Sofie	50.8001475	14.4119825	71
6772	2467	Náměstí Míru	219	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Terénní programy Města Česká Kamenice	50.7994313	14.4167372	72
6770	2466	\N	26	Církvice	Ústí nad Labem	40302	Ústecký kraj	Pečovatelská služba PAMPELIŠKA, z.ú.	50.5898845	14.0377082	73
6768	2371	Žernosecká	2280	Předměstí	Litoměřice	41201	Ústecký kraj	SOCIÁLNĚ PSYCHIATRICKÉ CENTRUM SLUNÍČKO z.ú.	50.5323329	14.1131508	74
6761	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	SAS Kotva	50.4937747	13.6599037	75
6760	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Terénní programy	50.4937747	13.6599037	76
6587	229	Šrámkova	3305/38a	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	Domov pro seniory Dobětice, příspěvková organizace	50.6757897	14.0596102	77
6585	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Klíč k samostatnému bydlení	50.5024682	13.7080234	78
6575	2039	CHYBA: 'NoneType' object is not subscriptable	\N	\N	\N	\N	\N	SAS Chanov	\N	\N	79
6574	2351	\N	168	Klučov	Klučov	28201	Středočeský kraj	ADP - Anna s.r.o.	50.0931698	14.9133455	80
6573	2351	\N	168	Klučov	Klučov	28201	Středočeský kraj	ADP - Anna s.r.o.	50.0931698	14.9133455	81
6572	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Klub NOra	50.3899214	13.2696234	82
6532	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Litoměřice - Mostecká	50.0481757	14.3111295	83
6522	716	K Chatám	22	Skorotice	Ústí nad Labem	40340	Ústecký kraj	TRIANGL - krizové centrum pro děti a nedospělé	50.6910115	14.0044033	84
6518	282	Nádražní	933	Podbořany	Podbořany	44101	Ústecký kraj	Pečovatelská slsužba	50.2244854	13.4068903	85
6486	2407	Pobřežní	665/21	Karlín	Praha	18600	Hlavní město Praha	Global Partner	50.0933918	14.4439287	86
6424	864	Tyršova	350	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Domov sv. Josefa	50.8001475	14.4119825	87
6380	1528	Rybná	716/24	Staré Město	Praha	11000	Hlavní město Praha	Odborné sociální poradenství - Romodrom pobočka Praha (Hlavní město Praha)	50.0902420	14.4260262	88
6371	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Prunéřov	50.0481757	14.3111295	89
6370	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Prunéřov	50.0481757	14.3111295	90
6361	1460	Čajkovského	1640/8	Žižkov	Praha	13000	Hlavní město Praha	Raná péče Diakonie - Středočeský kraj	50.0814318	14.4527932	91
6359	1836	Mírová	111	Obrnice	Obrnice	43521	Ústecký kraj	GALAXIE	50.5051318	13.6945284	92
6356	1631	Mírové náměstí	120	Kadaň	Kadaň	43201	Ústecký kraj	Sociální centrum - Sociálně aktivizační služby pro rodiny s dětmi Kadaň	50.3755757	13.2706260	93
6352	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Coolna	50.4937747	13.6599037	94
6345	2371	Žernosecká	2280	Předměstí	Litoměřice	41201	Ústecký kraj	SOCIÁLNĚ PSYCHIATRICKÉ CENTRUM SLUNÍČKO z.ú.	50.5323329	14.1131508	95
6316	1837	Antonína Dvořáka	2430/18	Most	Most	43401	Ústecký kraj	Sestřičky s. r. o.	50.5106254	13.6395840	96
6307	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Nízkoprahové denní centrum	50.5024682	13.7080234	97
6303	2364	Táboritů	2180/8	Most	Most	43401	Ústecký kraj	Domov Alzheimer Most	50.5106022	13.6374303	98
6266	2351	\N	168	Klučov	Klučov	28201	Středočeský kraj	ADP-ANNA s.r.o.	50.0931698	14.9133455	99
6264	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Terénní program Praha 6	50.5024682	13.7080234	100
6261	2349	Masarykova	1648/59	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociální bydlení Sever, z. s.	50.6641254	14.0331870	101
6145	2243	Riegrova	909/5	Děčín II-Nové Město	Děčín	40502	Ústecký kraj	Odborné sociální poradenství SDZP	50.7800741	14.2213806	102
6144	2243	Riegrova	909/5	Děčín II-Nové Město	Děčín	40502	Ústecký kraj	Odborné sociální poradenství SDZP	50.7800741	14.2213806	103
6116	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Domov důchodců Libochovice	50.5205123	14.0453183	104
6084	193	Zahradnická	1534/5	Předměstí	Litoměřice	41201	Ústecký kraj	Domov na Dómském pahorku - odlehčovací služba	\N	\N	105
6083	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Chráněné bydlení Chomutov	50.6630615	14.0372032	106
6080	93	Kubátova	269	Háj u Duchcova	Háj u Duchcova	41722	Ústecký kraj	Domov pro osoby se zdravotním postižením VITA	50.6315794	13.7133755	107
6077	611	Na Vypichu	180	Lahošť	Lahošť	41725	Ústecký kraj	Nízkoprahové denní centrum Květina	50.6214165	13.7566630	108
6075	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Domov Teplice	50.6401921	14.0442611	109
6073	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Terénní programy	50.4937747	13.6599037	110
6053	2222	28. října	475/7	Lovosice	Lovosice	41002	Ústecký kraj	Sociální služby města Lovosice, p.o. - Pečovatelská služba	50.5150470	14.0459084	111
6038	435	Fügnerova	282/11	Trmice	Trmice	40004	Ústecký kraj	Klub Amaro Avindo	50.6429157	13.9989999	112
6027	2152	Bílkova	855/19	Staré Město	Praha	11000	Hlavní město Praha	Terénní programy	50.0912881	14.4216877	113
5938	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Tým duševního zdraví Děčín	50.6630615	14.0372032	114
5937	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Tým duševního zdraví Teplice	50.6630615	14.0372032	115
5935	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Tým duševního zdraví Most	50.6630615	14.0372032	116
5934	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociální rehabilitace Chomutov	50.6630615	14.0372032	117
5917	2050	Dělnická	109	Meziboří	Meziboří	43513	Ústecký kraj	Pečovatelská služba SENMED	50.6207301	13.6013900	118
5904	1694	Masarykova	1094/4	Krásná Lípa	Krásná Lípa	40746	Ústecký kraj	Kostka Krásná Lípa, p.o.	50.9130726	14.5093900	119
5903	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	Krizová poradna	50.5044316	13.6355873	120
5901	1776	\N	1	Petrohrad	Petrohrad	43985	Ústecký kraj	Psychiatrická léčebna Petrohrad, příspěvková organizace	50.1263738	13.4428116	121
5899	231	\N	1	Tuchořice	Tuchořice	43969	Ústecký kraj	Chráněné bydlení - Domov "Bez zámků" Tuchořice	50.2844389	13.6609024	122
5892	340	Březinova	1093	Kadaň	Kadaň	43201	Ústecký kraj	Chráněné bydlení Kadaň	50.3768233	13.2651021	123
5825	2160	\N	100	Arnoltice	Arnoltice	40714	Ústecký kraj	Valerie-Homecare, s. r. o.	50.8392288	14.2612175	124
5787	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Azylový dům pro rodiny s dětmi v Mostě	50.5024682	13.7080234	125
5775	800	Fügnerova	355/16	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Klub pro mladé Prosapia	50.7778507	14.2171139	126
5774	1770	Sněžnická	94	Jílové	Jílové	40701	Ústecký kraj	Terénní program	50.7659663	14.1014024	127
5764	2148	Bílý kopec	432	Podbořany	Podbořany	44101	Ústecký kraj	Občanská poradna Podbořany	50.2287623	13.4158746	128
5755	1776	\N	1	Petrohrad	Petrohrad	43985	Ústecký kraj	Psychiatrická léčebna Petrohrad, příspěvková organizace	50.1263738	13.4428116	129
5754	2146	Šafaříkova	991	Horní Litvínov	Litvínov	43601	Ústecký kraj	Uzlík Litvínov, z. ú.	50.6015669	13.6077564	130
5753	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Sociálně aktivizační služby pro rodiny s dětmi Jirkov	50.4937747	13.6599037	131
5745	1397	Petržílkova	2565/23	Stodůlky	Praha	15800	Hlavní město Praha	Armáda spásy, Centrum sociálních služeb Jirkov	50.0505486	14.3425118	132
5744	1397	Petržílkova	2565/23	Stodůlky	Praha	15800	Hlavní město Praha	Armáda spásy, Centrum sociálních služeb Jirkov	50.0505486	14.3425118	133
5712	2136	Kochova	1185	Chomutov	Chomutov	43001	Ústecký kraj	Zdravotní sestry a pečovatelky s. r. o.	50.4551743	13.4112939	134
5708	391	Velká Hradební	13/47	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Krajská adiktologická ambulance a poradna pro děti a dorost	50.6603133	14.0372639	135
5707	391	Velká Hradební	13/47	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Terénní program Postoloprty	50.6603133	14.0372639	136
5697	954	Lužická	727/7	Děčín II-Nové Město	Děčín	40502	Ústecký kraj	Poradna - Agentura Osmý den, o. p. s.	50.7833953	14.2229428	137
5694	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Terénní programy Duchcov	50.4937747	13.6599037	138
5676	1897	Radniční	1/2	Most	Most	43401	Ústecký kraj	NZDM SVĚT	50.5028219	13.6404648	139
5661	1672	Mírové nám.	234/3	Děčín IV-Podmokly	Děčín	40502	Ústecký kraj	Domov se zvlÃ¡Å¡tnÃ­m reÅ¾imem	50.7735826	14.1963805	140
5643	1872	T. G. Masaryka	611	Šluknov	Šluknov	40777	Ústecký kraj	Bary Ambrela	51.0046163	14.4591850	141
5635	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	NÃ­zkoprahovÃ© dennÃ­ centrum v Praze 6	50.5024682	13.7080234	142
5591	71	Nám. E. Beneše	470	Varnsdorf	Varnsdorf	40747	Ústecký kraj	CSS mÄsta Varnsdorf - SociÃ¡lnÄ aktivizaÄnÃ­ sluÅ¾ba pro rodiny s dÄtmi	50.9120975	14.6197564	143
5590	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Klub NaNáměstí	50.3899214	13.2696234	144
5568	1047	Varšavská	688/40	Střekov	Ústí nad Labem	40003	Ústecký kraj	Sociální agentura, o. p. s.	50.6584598	14.0521560	145
5552	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Klášterec nad Ohří	50.0481757	14.3111295	146
5544	1050	K. Maličkého	382/16	Lovosice	Lovosice	41002	Ústecký kraj	Sociálně terapeutická dílna Šance Lovosice, z.s.	50.5158230	14.0452472	147
5543	93	Kubátova	269	Háj u Duchcova	Háj u Duchcova	41722	Ústecký kraj	Domovy sociálních služeb Háj u Duchcova	50.6315794	13.7133755	148
5542	864	Tyršova	350	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Odborné sociální poradenství	50.8001475	14.4119825	149
5539	1898	náměstí Dr. Beneše	1919/23	Chomutov	Chomutov	43001	Ústecký kraj	Sociální rehabilitace Esprit	50.4581221	13.4106518	150
5524	769	K. Maličkého	418/2	Lovosice	Lovosice	41002	Ústecký kraj	Dílny Panny Marie Pomocné	50.5158230	14.0452472	151
5437	183	Zátiší	177	Janov	Litvínov	43542	Ústecký kraj	Domovy sociálních služeb Litvínov, p. o.	50.5908620	13.5537590	152
5436	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	Poradna pro závislostní chování	50.5044316	13.6355873	153
5373	2051	Báňská	287	Most	Most	43401	Ústecký kraj	SAP - sociálně akitivzační poradna MOST	50.5011468	13.6329174	154
5372	2051	Báňská	287	Most	Most	43401	Ústecký kraj	SAS - sociálně aktivizační služba MOST	50.5011468	13.6329174	155
5365	2050	Dělnická	109	Meziboří	Meziboří	43513	Ústecký kraj	Domov pro seniory SENMED	50.6207301	13.6013900	156
5351	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Noclehárna v Chomutově	50.5024682	13.7080234	157
5340	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Štětí	50.0481757	14.3111295	158
5339	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Štětí	50.0481757	14.3111295	159
5319	1047	Varšavská	688/40	Střekov	Ústí nad Labem	40003	Ústecký kraj	Sociální agentura, o. p. s.	50.6584598	14.0521560	160
5318	611	Na Vypichu	180	Lahošť	Lahošť	41725	Ústecký kraj	Sociálně aktivizační služby pro rodiny s dětmi Květina	50.6214165	13.7566630	161
5303	2043	Revoluční	22/20	Chomutov	Chomutov	43001	Ústecký kraj	SAS pro osoby se zdravotním postižením	50.4608210	13.4201395	162
5293	2039	CHYBA: 'NoneType' object is not subscriptable	\N	\N	\N	\N	\N	Nízkoprahové zařízení pro děti a mládež	\N	\N	163
5262	1913	Svatopluka Čecha	1541	Žatec	Žatec	43801	Ústecký kraj	Azylový dům pro rodiny s dětmi	50.3208044	13.5403026	164
5258	445	Křečanská	630	Šluknov	Šluknov	40777	Ústecký kraj	Domov pro seniory Krásná Lípa	51.0010863	14.4538913	165
5179	183	Zátiší	177	Janov	Litvínov	43542	Ústecký kraj	Domovy sociálních služeb Litvínov, příspěvková organizace	50.5908620	13.5537590	166
5178	1813	Neklanova	2706	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Klíč - poradna pro rodiny	50.4215004	14.2421205	167
5119	1990	Vaníčkova	902/11	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Bateau	50.6604892	14.0337405	168
5118	1989	\N	431	Dolní Podluží	Dolní Podluží	40755	Ústecký kraj	Domov sv. Vincenta de Paul z.ú.	50.8829038	14.5785488	169
5117	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Sociálně aktivizační služby pro rodiny Ovečka	50.6732608	14.0160860	170
5093	1981	\N	730	Mikulášovice	Mikulášovice	40779	Ústecký kraj	Spolek Kolem dokola	50.9680201	14.3572238	171
5089	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Zastávka	50.4937747	13.6599037	172
5073	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	Chráněné bydlení - kontaktní místo služby	50.6335303	13.8287003	173
5048	475	\N	65	Filipov	Jiříkov	40753	Ústecký kraj	Osobní asistence	50.9801762	14.5975311	174
5047	193	Zahradnická	1534/5	Předměstí	Litoměřice	41201	Ústecký kraj	Středisko sociální prevence a humanitární pomoci - terénní program	\N	\N	175
5043	1350	Jateční	870/41	Klíše	Ústí nad Labem	40001	Ústecký kraj	Denní stacionář Helias	50.6628192	14.0092717	176
5025	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko NADĚJE Roudnice nad Labem - chráněné bydlení	50.0481757	14.3111295	177
5024	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Kadaň	50.0481757	14.3111295	178
5022	367	\N	131	Stará Oleška	Huntířov	40502	Ústecký kraj	Chráněné bydlení	50.8005075	14.3364938	179
4961	1422	U Kanálky	1559/5	Vinohrady	Praha	12000	Hlavní město Praha	Návrat dítěte do rodiny	50.0776061	14.4459008	180
4956	1952	\N	39	Vilémov	Vilémov	40780	Ústecký kraj	Osobní asistence Pastelky	50.9887563	14.3388200	181
4955	1952	\N	39	Vilémov	Vilémov	40780	Ústecký kraj	Chráněné bydlení Pastelky	50.9887563	14.3388200	182
4954	1952	\N	39	Vilémov	Vilémov	40780	Ústecký kraj	Podpora samostatného bydlení Pastelky	50.9887563	14.3388200	183
4953	1951	Jankovcova	1229/46	Trnovany	Teplice	41501	Ústecký kraj	SPZ Teplice - sociálně aktivizační služby	\N	\N	184
4918	964	Šafaříkova	635/24	Vinohrady	Praha	12000	Hlavní město Praha	Nízkoprahové centrum - Na předměstí	\N	\N	185
4908	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Klub Ostrov	50.3899214	13.2696234	186
4890	964	Šafaříkova	635/24	Vinohrady	Praha	12000	Hlavní město Praha	Člověk v tísni, o.p.s., Klub Mixér	\N	\N	187
4884	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Terénní program Jirkov	50.3899214	13.2696234	188
4883	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Terénní program Karlovarsko	50.3899214	13.2696234	189
4882	93	Kubátova	269	Háj u Duchcova	Háj u Duchcova	41722	Ústecký kraj	Domovy pro osoby se zdravotním postižením Nová Ves v Horách	50.6315794	13.7133755	190
4881	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Děčínské doléčovací centrum	50.7828894	14.2158740	191
4858	550	Okružní	104	Meziboří	Meziboří	43513	Ústecký kraj	Domov sociálních služeb Meziboří, příspěvková organizace	50.6221869	13.6026458	192
4857	1903	Varšavská	694/38	Střekov	Ústí nad Labem	40003	Ústecký kraj	Terénní program v Ústí nad Labem	50.6583941	14.0520687	193
4855	435	Fügnerova	282/11	Trmice	Trmice	40004	Ústecký kraj	Poradenské centrum Krupka	50.6429157	13.9989999	194
4853	435	Fügnerova	282/11	Trmice	Trmice	40004	Ústecký kraj	Poradenské centrum Louny	50.6429157	13.9989999	195
4851	974	Pražská	166/47	Vaňov	Ústí nad Labem	40001	Ústecký kraj	Centrum ambulantní léčby a poradenství WHITE LIGHT I	50.6253745	14.0588188	196
4850	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	CSP Litoměřice STD Cestou integrace	50.5205123	14.0453183	197
4842	183	Zátiší	177	Janov	Litvínov	43542	Ústecký kraj	Domovy sociálních služeb Litvínov, příspěvková organizace	50.5908620	13.5537590	198
4840	1898	náměstí Dr. Beneše	1919/23	Chomutov	Chomutov	43001	Ústecký kraj	Sociálně terapeutické dílny	50.4581221	13.4106518	199
4838	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Služby pro rodiny s dětmi - SC Kamínek	50.3899214	13.2696234	200
4837	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Klub Kámen - SC Kamínek	50.3899214	13.2696234	201
4830	1872	T. G. Masaryka	611	Šluknov	Šluknov	40777	Ústecký kraj	Ambrela pro rodinu	51.0046163	14.4591850	202
4810	1397	Petržílkova	2565/23	Stodůlky	Praha	15800	Hlavní město Praha	Armáda spásy, Centrum sociálních služeb Jirkov	50.0505486	14.3425118	203
4809	1397	Petržílkova	2565/23	Stodůlky	Praha	15800	Hlavní město Praha	Armáda spásy, Centrum sociálních služeb Jirkov	50.0505486	14.3425118	204
4808	1397	Petržílkova	2565/23	Stodůlky	Praha	15800	Hlavní město Praha	Armáda spásy, Centrum sociálních služeb Jirkov	50.0505486	14.3425118	205
4783	700	Pěší	9	Děčín XXXIII-Nebočady	Děčín	40502	Ústecký kraj	Jurta o.p.s.	50.7304755	14.1908622	206
4781	435	Fügnerova	282/11	Trmice	Trmice	40004	Ústecký kraj	Nízkoprahové zařízení pro mládež	50.6429157	13.9989999	207
4716	1872	T. G. Masaryka	611	Šluknov	Šluknov	40777	Ústecký kraj	Klub Ambrela	51.0046163	14.4591850	208
4704	864	Tyršova	350	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Sociálně terapeutické dílny	50.8001475	14.4119825	209
4703	864	Tyršova	350	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Podpora samostatného bydlení	50.8001475	14.4119825	210
4702	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Dům Naděje Klášterec nad Ohří	50.0481757	14.3111295	211
4701	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Lovosice	50.0481757	14.3111295	212
4693	93	Kubátova	269	Háj u Duchcova	Háj u Duchcova	41722	Ústecký kraj	Domovy sociálních služeb Háj u Duchcova	50.6315794	13.7133755	213
4692	1837	Antonína Dvořáka	2430/18	Most	Most	43401	Ústecký kraj	Sestřičky, s. r. o.	50.5106254	13.6395840	214
4688	926	U Dubu	1562	Jirkov	Jirkov	43111	Ústecký kraj	Městský ústav sociálních služeb, příspěvková organizace	50.5030828	13.4478877	215
4687	1832	Sídliště	1019	Šluknov	Šluknov	40777	Ústecký kraj	Centrum pečovatelské služby Harmonie	51.0007725	14.4617875	216
4681	282	Nádražní	933	Podbořany	Podbořany	44101	Ústecký kraj	Domov pro seniory Podbořany, příspěvková organizace	50.2244854	13.4068903	217
4680	282	Nádražní	933	Podbořany	Podbořany	44101	Ústecký kraj	Domov pro seniory Podbořany, příspěvková organizace	50.2244854	13.4068903	218
4678	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Poradna pro závislosti a ambulantní léčba	50.3899214	13.2696234	219
4673	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Kadaň	50.0481757	14.3111295	220
4665	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Sociálně aktivizační služby pro rodiny s dětmi	50.4937747	13.6599037	221
4649	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	NÃ­zkoprahovÃ© dennÃ­ centrum Most	50.4937747	13.6599037	222
4627	1050	K. Maličkého	382/16	Lovosice	Lovosice	41002	Ústecký kraj	DennÃ­ stacionÃ¡Å Å ance Lovosice, z.s.	50.5158230	14.0452472	223
4624	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	ChrÃ¡nÄnÃ© bydlenÃ­	50.7828894	14.2158740	224
4615	112	Šafaříkova	852	Žatec	Žatec	43801	Ústecký kraj	Domov pro seniory a pečovatelská služba v Žatci	50.3244303	13.5483010	225
4597	1497	Lázeňská	485/2	Malá Strana	Praha	11800	Hlavní město Praha	Maltézská pomoc, o.p.s. - Osobní asistence - Žatec	50.0862567	14.4059776	226
4594	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Dům Naděje Litoměřice	50.0481757	14.3111295	227
4587	769	K. Maličkého	418/2	Lovosice	Lovosice	41002	Ústecký kraj	Azylový dům pro ženy a matky s dětmi v Lovosicích	50.5158230	14.0452472	228
4574	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociální rehabilitace Litoměřice	50.6630615	14.0372032	229
4573	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociální rehabilitace Děčín	50.6630615	14.0372032	230
4572	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Lovosice	50.0481757	14.3111295	231
4555	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Tanvaldská Kotva	50.4937747	13.6599037	232
4554	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Nízkoprahové zařízení pro děti a mládež Drak	50.4937747	13.6599037	233
4553	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Nízkoprahová zařízení pro děti a mládež Zákupák	50.4937747	13.6599037	234
4541	1836	Mírová	111	Obrnice	Obrnice	43521	Ústecký kraj	SPOLU V ULICÍCH	50.5051318	13.6945284	235
4540	1836	Mírová	111	Obrnice	Obrnice	43521	Ústecký kraj	OLIVÍN	50.5051318	13.6945284	236
4539	1836	Mírová	111	Obrnice	Obrnice	43521	Ústecký kraj	VULKÁN	50.5051318	13.6945284	237
4529	700	Pěší	9	Děčín XXXIII-Nebočady	Děčín	40502	Ústecký kraj	Jurta o.p.s.	50.7304755	14.1908622	238
4527	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Sociální poradna Tanvald	50.4937747	13.6599037	239
4515	1422	U Kanálky	1559/5	Vinohrady	Praha	12000	Hlavní město Praha	Želváček	50.0776061	14.4459008	240
4509	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Dům Naděje Litoměřice	50.0481757	14.3111295	241
4504	256	\N	119	Brtníky	Staré Křečany	40760	Ústecký kraj	Domov pro osoby se zdravotním postižením Brtníky, příspěvková organizace	50.9475950	14.4415449	242
4484	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Sociálně aktivizační služby pro rodiny s dětmi Duchcov	50.4937747	13.6599037	243
4482	1836	Mírová	111	Obrnice	Obrnice	43521	Ústecký kraj	Obrnická sociální poradna	50.5051318	13.6945284	244
4478	1894	Sebuzínská	175	Brná	Ústí nad Labem	40321	Ústecký kraj	HEZKÉ DOMY s. r. o.	50.6240029	14.0759090	245
4475	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Dům Naděje Roudnice nad Labem	50.0481757	14.3111295	246
4474	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Roudnice nad Labem - T. G. Masaryka	50.0481757	14.3111295	247
4473	964	Šafaříkova	635/24	Vinohrady	Praha	12000	Hlavní město Praha	Člověk v tísni, o.p.s.	\N	\N	248
4470	1694	Masarykova	1094/4	Krásná Lípa	Krásná Lípa	40746	Ústecký kraj	Kostičky	50.9130726	14.5093900	249
4462	1874	Janáčkova	459	Děčín XXXII-Boletice nad Labem	Děčín	40711	Ústecký kraj	Centrum	50.7369699	14.1966274	250
4461	1897	Radniční	1/2	Most	Most	43401	Ústecký kraj	Nízkoprahové zařízení pro děti a mládež 14-26 let	50.5028219	13.6404648	251
4456	416	Věžní	958	Kadaň	Kadaň	43201	Ústecký kraj	Městská správa sociálních služeb Kadaň	50.3761366	13.2759279	252
4455	825	Zeyerova	859	Žatec	Žatec	43801	Ústecký kraj	Chráněné bydlení	50.3248542	13.5378363	253
4449	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	CSP - Chráněné bydlení Litoměřice	50.5205123	14.0453183	254
4412	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Litoměřice - Dvořákova	50.0481757	14.3111295	255
1681	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Domov pro seniory	50.5122999	13.6495154	456
4406	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Dům pokojného stáří sv. Ludmily	50.6732608	14.0160860	256
4375	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	K- Centrum Žatec	50.5044316	13.6355873	257
4366	864	Tyršova	350	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Chráněné bydlení	50.8001475	14.4119825	258
4364	955	Palackého	205/4	Rumburk 1	Rumburk	40801	Ústecký kraj	Agentura KROK, o.p.s.	50.9505535	14.5593938	259
4344	1794	Na Příkopě	130	Šluknov	Šluknov	40777	Ústecký kraj	Kormidlo Šluknov o.p.s.	51.0045850	14.4509125	260
4330	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Klub Přízemí	50.3899214	13.2696234	261
4323	1791	Okružní	943/4	Most	Most	43401	Ústecký kraj	KRUH pomoci, o. p. s.	50.4954928	13.6648002	262
4301	1512	Havlíčkova	276	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Humanitární sdružení PERSPEKTIVA	50.4272937	14.2548180	263
4300	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Dům na půl cesty v Mostě	50.5024682	13.7080234	264
4298	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	Dům na půl cesty Liberec	50.5044316	13.6355873	265
4284	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociálně aktivizační služby Litoměřice	50.6630615	14.0372032	266
4282	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociálně aktivizační služby Děčín	50.6630615	14.0372032	267
4265	1422	U Kanálky	1559/5	Vinohrady	Praha	12000	Hlavní město Praha	Návrat dítěte do rodiny	50.0776061	14.4459008	268
4263	1422	U Kanálky	1559/5	Vinohrady	Praha	12000	Hlavní město Praha	Návrat dítěte do rodiny	50.0776061	14.4459008	269
4262	1422	U Kanálky	1559/5	Vinohrady	Praha	12000	Hlavní město Praha	Návrat do společnosti	50.0776061	14.4459008	270
4238	475	\N	65	Filipov	Jiříkov	40753	Ústecký kraj	Domov se zvláštním režimem	50.9801762	14.5975311	271
4236	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Domov se zvláštním režimem	50.7828894	14.2158740	272
4235	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Azylový dům pro muže v Praze	50.5024682	13.7080234	273
4234	994	Přísečnická	456/6	Vejprty	Vejprty	43191	Ústecký kraj	Chráněné bydlení Vejprty	50.4932978	13.0319622	274
4220	227	Dlouhá	1058/19	Lovosice	Lovosice	41002	Ústecký kraj	KDP Sluníčko	50.5192286	14.0454268	275
4219	227	Dlouhá	1058/19	Lovosice	Lovosice	41002	Ústecký kraj	KDP Sluníčko	50.5192286	14.0454268	276
4217	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Noclehárna v Mostě	50.5024682	13.7080234	277
4209	1770	Sněžnická	94	Jílové	Jílové	40701	Ústecký kraj	Komunitní centrum dětí a mládeže Kamarád	50.7659663	14.1014024	278
4205	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Domov pro osoby se zdravotním postižením Severní Terasa	50.6401921	14.0442611	279
4195	144	V Klidu	3133/12	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	Domov pro seniory Severní Terasa, příspěvková organizace	50.6846794	14.0194151	280
4189	1694	Masarykova	1094/4	Krásná Lípa	Krásná Lípa	40746	Ústecký kraj	Poradna v kostce	50.9130726	14.5093900	281
4188	1694	Masarykova	1094/4	Krásná Lípa	Krásná Lípa	40746	Ústecký kraj	Kostka Krásná Lípa, p. o.	50.9130726	14.5093900	282
4178	1764	\N	5	Patokryje	Patokryje	43401	Ústecký kraj	Azylový dům pro muže v Mostě	50.5024682	13.7080234	283
4172	193	Zahradnická	1534/5	Předměstí	Litoměřice	41201	Ústecký kraj	Charitní domov sv. Zdislava - domov se zvláštním režimem	\N	\N	284
4160	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociálně terapeutická dílna Úsměv	50.6401921	14.0442611	285
4152	1758	Pod Břízami	5598	Chomutov	Chomutov	43004	Ústecký kraj	Domov harmonie a klidu	\N	\N	286
4148	1757	Kostelní	67	Jirkov	Jirkov	43111	Ústecký kraj	Důstojný život - centrum pomoci pro zdravotně postižené, o.p.s.	50.4982725	13.4478881	287
4133	340	Březinova	1093	Kadaň	Kadaň	43201	Ústecký kraj	Domov pro seniory a Domov pro osoby se zdravotním postižením Mašťov	50.3768233	13.2651021	288
4110	1748	CHYBA: 'NoneType' object is not subscriptable	\N	\N	\N	\N	\N	Cesta do světa - sociálně terapeutické dílny (TÚDP)	\N	\N	289
4109	1748	CHYBA: 'NoneType' object is not subscriptable	\N	\N	\N	\N	\N	Centrum Cesta do světa	\N	\N	290
4105	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Domov U Trati Litoměřice	50.5205123	14.0453183	291
4104	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Sociálně rehabilitační programy	50.4937747	13.6599037	292
4095	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	K - centrum Česká Lípa	50.5044316	13.6355873	293
4094	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	Odborné sociální poradenství	50.5044316	13.6355873	294
4091	481	Jiřího Wolkera	1248/2	Teplice	Teplice	41501	Ústecký kraj	Domov se zvláštním režimem	50.6445363	13.8326598	295
4064	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	Centrum pro rodinu a následnou péči	50.5044316	13.6355873	296
4060	1441	Opletalova	921/6	Nové Město	Praha	11000	Hlavní město Praha	PORADNA PRO INTEGRACI	50.0811171	14.4296172	297
4028	475	\N	65	Filipov	Jiříkov	40753	Ústecký kraj	Pečovatelská služba	50.9801762	14.5975311	298
4012	1733	Mírové náměstí	1	Louny	Louny	44001	Ústecký kraj	Sociálně terapeutická dílna Jeroným	50.3572998	13.7978518	299
4004	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Klášterec nad Ohří	50.0481757	14.3111295	300
3990	1727	náměstí Míru	11	Horní Litvínov	Litvínov	43601	Ústecký kraj	První krok Sociálně aktivizační služby pro rodiny s dětmi	50.5988055	13.6117055	301
3989	1727	náměstí Míru	11	Horní Litvínov	Litvínov	43601	Ústecký kraj	První krok Terénní programy	50.5988055	13.6117055	302
3969	1671	Křižíkova	918/32	Krásná Lípa	Krásná Lípa	40746	Ústecký kraj	Terénní programy	50.9024113	14.5063363	303
3936	1599	Kryrská	102	Vroutek	Vroutek	43982	Ústecký kraj	Domov pro seniory Vroutek, příspěvková organizace	50.1796435	13.3819306	304
3916	435	Fügnerova	282/11	Trmice	Trmice	40004	Ústecký kraj	Nízkoprahové zařízení pro děti M. C. Zefyríno	50.6429157	13.9989999	305
3915	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	Terénní programy sociální prevence	50.5044316	13.6355873	306
3905	367	\N	131	Stará Oleška	Huntířov	40502	Ústecký kraj	Domovy pro osoby se zdravotním postižením  Česká Kamenice	50.8005075	14.3364938	307
3902	611	Na Vypichu	180	Lahošť	Lahošť	41725	Ústecký kraj	Terénní programy Květina	50.6214165	13.7566630	308
3892	485	Rooseveltova	716/7	Předměstí	Litoměřice	41201	Ústecký kraj	Podpora samostatného bydlení	\N	\N	309
3880	962	Thámova	711/20	Trnovany	Teplice	41501	Ústecký kraj	Agapé II.	50.6501504	13.8422491	310
3841	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Dům Naděje Roudnice nad Labem	50.0481757	14.3111295	311
3840	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	Středisko Arkadie Krupka	50.6335303	13.8287003	312
3839	698	Riegrova	652	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Sociálně aktivizační služby pro rodiny s dětmi pri FCH Rce n. L.	50.4229534	14.2585936	313
3838	979	Hornická	106	Meziboří	Meziboří	43513	Ústecký kraj	Cráněné bydlení ENERGIE o. p. s.	50.6225958	13.6017541	314
3787	229	Šrámkova	3305/38a	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	Domov pro seniory Dobětice, příspěvková organizace	50.6757897	14.0596102	315
3784	926	U Dubu	1562	Jirkov	Jirkov	43111	Ústecký kraj	Městský ústav sociálních služeb Jirkov, příspěvková organizace	50.5030828	13.4478877	316
3783	1672	Mírové nám.	234/3	Děčín IV-Podmokly	Děčín	40502	Ústecký kraj	Pečovatelská služba	50.7735826	14.1963805	317
3780	1671	Křižíkova	918/32	Krásná Lípa	Krásná Lípa	40746	Ústecký kraj	Azylový dům	50.9024113	14.5063363	318
3758	448	Mírové nám.	163	Štětí	Štětí	41108	Ústecký kraj	Dům s chráněnými byty	50.4539625	14.3728533	319
3757	448	Mírové nám.	163	Štětí	Štětí	41108	Ústecký kraj	Dům s chráněnými byty	50.4539625	14.3728533	320
3751	1640	Hlávkova	1203	Trnovany	Teplice	41501	Ústecký kraj	Luna	50.6565775	13.8411367	321
3746	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Klub MOLO	50.3899214	13.2696234	322
3745	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Nízkoprahové zařízení pro děti a mládež Zahrada	50.4937747	13.6599037	323
3744	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Odborné sociální a dluhové poradenství Chomutov .i.	50.4937747	13.6599037	324
3731	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Litoměřice	50.0481757	14.3111295	325
3730	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Dům Naděje Klášterec nad Ohří	50.0481757	14.3111295	326
3729	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Dům Naděje Klášterec nad Ohří	50.0481757	14.3111295	327
3728	1303	\N	40	Horní Poustevna	Dolní Poustevna	40747	Ústecký kraj	Integrované centrum pro osoby se zdravotním postižením Horní Poustevna - Dílna u Markétky	50.9994763	14.2951738	328
3725	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Nízkoprahové zařízení pro děti a mládež Domino	50.4937747	13.6599037	329
3710	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Odborné sociální poradenství Duchcov	50.4937747	13.6599037	330
3693	964	Šafaříkova	635/24	Vinohrady	Praha	12000	Hlavní město Praha	Člověk v tísni, o.p.s.	\N	\N	331
3686	825	Zeyerova	859	Žatec	Žatec	43801	Ústecký kraj	Sociálně terapeutická dílna	50.3248542	13.5378363	332
3673	680	2. polské armády	1094/27	Rumburk 1	Rumburk	40801	Ústecký kraj	Agentura Pondělí - podpora samostatného bydlení	50.9578602	14.5554399	333
3638	973	Sládkova	344	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Domov pro seniory a pečovatelská služba Česká Kamenice, příspěvková organizace	50.8041713	14.4207812	334
3622	1486	Černokostelecká	2020/20	Strašnice	Praha	10000	Hlavní město Praha	HEWER - osobní asistence pro Ústecký kraj	50.0764821	14.4929180	335
3620	1640	Hlávkova	1203	Trnovany	Teplice	41501	Ústecký kraj	Podaná ruka	50.6565775	13.8411367	336
3602	1631	Mírové náměstí	120	Kadaň	Kadaň	43201	Ústecký kraj	Poradna pro rodinu a mezilidské vztahy Kadaň	50.3755757	13.2706260	337
3599	62	Lípová	545	Klášterec nad Ohří	Klášterec nad Ohří	43151	Ústecký kraj	Městský ústav sociálních služeb Klášterec nad Ohří, příspěvková organizace	50.3936499	13.1789011	338
3584	955	Palackého	205/4	Rumburk 1	Rumburk	40801	Ústecký kraj	Agentura KROK, o.p.s.	50.9505535	14.5593938	339
3567	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Domov pro osoby se zdravotním postižením Všebořice	50.6401921	14.0442611	340
3565	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Domov pro osoby se zdravotním postižením Všebořice	50.6401921	14.0442611	341
3564	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Domov pro osoby se zdravotním postižením Severní Terasa	50.6401921	14.0442611	342
3563	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Domov pro osoby se zdravotním postižením Severní Terasa	50.6401921	14.0442611	343
3562	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Domov pro osoby se zdravotním postižením Trmice	50.6401921	14.0442611	344
3561	1624	Čajkovského	1908/82	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Domov pro osoby se zdravotním postižením Trmice	50.6401921	14.0442611	345
3544	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Terénní programy Most	50.4937747	13.6599037	346
3534	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Domov Na Svobodě Čížkovice	50.5205123	14.0453183	347
3530	183	Zátiší	177	Janov	Litvínov	43542	Ústecký kraj	Domovy sociálních služeb Litívnov, příspěvková organizace	50.5908620	13.5537590	348
3529	183	Zátiší	177	Janov	Litvínov	43542	Ústecký kraj	Domovy sociálních služeb Litvínov, příspěvková organizace	50.5908620	13.5537590	349
3528	864	Tyršova	350	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Domov Panny Marie	50.8001475	14.4119825	350
3526	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	Středisko Arkadie Bratislavská	50.6335303	13.8287003	351
3522	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Nízkoprahové zařízení pro děti a mládež Tykadlo	50.6732608	14.0160860	352
3514	485	Rooseveltova	716/7	Předměstí	Litoměřice	41201	Ústecký kraj	Sociálně terapeutické dílny Terezín	\N	\N	353
3494	825	Zeyerova	859	Žatec	Žatec	43801	Ústecký kraj	Kamarád - LORM	50.3248542	13.5378363	354
3490	1619	5. května	163	Louny	Louny	44001	Ústecký kraj	Azylový dům pro muže	50.3523365	13.8142825	355
3489	1619	5. května	163	Louny	Louny	44001	Ústecký kraj	Azylový dům pro muže	50.3523365	13.8142825	356
3482	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociálně terapeutické dílny Teplice	50.6630615	14.0372032	357
3481	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociální rehabilitace Teplice	50.6630615	14.0372032	358
3456	766	Masarykova	1335	Žatec	Žatec	43801	Ústecký kraj	Centrum služeb pro zdravotně postižené Žatec - Odlehčovací služby	50.3257865	13.5443294	359
3441	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Tlumočnické služby Most a Ústecký kraj	50.5066287	13.6604152	360
3405	1591	\N	63	Velké Žernoseky	Velké Žernoseky	41201	Ústecký kraj	Pečovatelská služba Velké Žernoseky	50.5393735	14.0642306	361
3384	1585	Mírové náměstí	1	Kadaň	Kadaň	43201	Ústecký kraj	Centrum sociálních služeb Prunéřov	50.3765605	13.2701130	362
3379	1581	Husovo náměstí	42	Bohušovice nad Ohří	Bohušovice nad Ohří	41156	Ústecký kraj	Pečovatelská služba	50.4932800	14.1499770	363
3377	1579	nám. ČSA	179	Terezín	Terezín	41155	Ústecký kraj	Pečovatelská služba města Terezín	50.5114815	14.1492969	364
3370	1576	Jiráskova	143	Čížkovice	Čížkovice	41112	Ústecký kraj	Pečovatelská služba obce Čížkovice	50.4834930	14.0300210	365
3347	1563	Farní	36	Nové Sedlo	Nové Sedlo	43801	Ústecký kraj	Pečovatelská služba	50.3387776	13.4762276	366
3331	29	Žižkova	151	Horní Litvínov	Litvínov	43601	Ústecký kraj	Pečovatelská služba Krušnohorské polikliniky	50.6023318	13.6140069	367
3329	29	Žižkova	151	Horní Litvínov	Litvínov	43601	Ústecký kraj	Domov pro seniory Naděje	50.6023318	13.6140069	368
3325	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Děčínské doléčovací centrum	50.7828894	14.2158740	369
3322	1550	J. E. Purkyně	270/5	Most	Most	43401	Ústecký kraj	AMA-společnost onkologických pacientů, jejich rodinných příslušníků a přátel,z.s.	50.5076591	13.6273796	370
3276	1025	Jungmannova	1024	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Pečovatelská služba OPORA	50.4229920	14.2560580	371
3275	1025	Jungmannova	1024	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Pečovatelská služba OPORA	50.4229920	14.2560580	372
3267	1524	Partyzánská	1/7	Holešovice	Praha	17000	Hlavní město Praha	Poradna Národní rady osob se zdravotním postižením ČR	50.1074724	14.4362478	373
3262	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Domov pro osoby se zdravotním postižením	50.5122999	13.6495154	374
3260	296	Kosmonautů	2022	Předměstí	Litoměřice	41201	Ústecký kraj	Poradenské centrum Litoměřice	50.5380521	14.1234960	375
3181	1485	Krakovská	1695/21	Nové Město	Praha	11000	Hlavní město Praha	Sociální poradna SONS ČR - Praha	50.0793351	14.4282491	376
3173	1485	Krakovská	1695/21	Nové Město	Praha	11000	Hlavní město Praha	Sociálně aktivizační služby pro zrakově postižené občany SONS ČR	50.0793351	14.4282491	377
3155	864	Tyršova	350	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Nízkoprahové denní centrum	50.8001475	14.4119825	378
3121	1468	Krakovská	1695/21	Nové Město	Praha	11000	Hlavní město Praha	Tyfloservis, o.p.s. - Krajské ambulantní středisko Ústí n.L.	50.0793351	14.4282491	379
3039	1441	Opletalova	921/6	Nové Město	Praha	11000	Hlavní město Praha	PORADNA PRO INTEGRACI	50.0811171	14.4296172	380
2981	1431	Na strži	1683/40	Krč	Praha	14000	Hlavní město Praha	Tichý svět, o.p.s. - tlumočnické služby	50.0486332	14.4409212	381
2980	1431	Na strži	1683/40	Krč	Praha	14000	Hlavní město Praha	Tichý svět, o.p.s.- Poradna	50.0486332	14.4409212	382
2978	1431	Na strži	1683/40	Krč	Praha	14000	Hlavní město Praha	Tichý svět, o.p.s. - sociální rehabilitace	50.0486332	14.4409212	383
2972	1425	\N	112	Polepy	Polepy	41147	Ústecký kraj	Pečovatelská služba	50.5063165	14.2647697	384
2963	1422	U Kanálky	1559/5	Vinohrady	Praha	12000	Hlavní město Praha	Poradna pro občanství, občanská a lidská práva	50.0776061	14.4459008	385
2940	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Středisko Naděje Roudnice nad Labem - Jungmannova	50.0481757	14.3111295	386
2939	1409	K Brance	11/19e	Stodůlky	Praha	15500	Hlavní město Praha	Dům Naděje Litoměřice - Želetická	50.0481757	14.3111295	387
2855	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociálně aktivizační služby Teplice	50.6630615	14.0372032	388
2825	792	Rakovnická	2502	Louny	Louny	44001	Ústecký kraj	Sociální služby města Loun, příspěvková organizace	50.3480584	13.8071465	389
2811	743	Rakovnická	2502	Louny	Louny	44001	Ústecký kraj	Centrum služeb pro zdravotně postižené Louny o.p.s.	50.3480584	13.8071465	390
2809	743	Rakovnická	2502	Louny	Louny	44001	Ústecký kraj	Centrum služeb pro zdravotně postižené Louny o.p.s.	50.3480584	13.8071465	391
2777	926	U Dubu	1562	Jirkov	Jirkov	43111	Ústecký kraj	Městský ústav sociálních služeb, příspěvková organizace	50.5030828	13.4478877	392
2731	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Klub DOpatra	50.3899214	13.2696234	393
2689	228	Lomená	47/2	Most	Most	43401	Ústecký kraj	Sociální práce v ohrožených rodinách Most	50.5103141	13.6284795	394
2688	228	Lomená	47/2	Most	Most	43401	Ústecký kraj	Občanská poradna Litvínov	50.5103141	13.6284795	395
2673	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Odborné sociální  a dluhové poradenství Janov	50.4937747	13.6599037	396
2672	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Sociálně aktivizační služby pro rodiny s dětmi Janováček	50.4937747	13.6599037	397
2660	162	Svážná	1528	Most	Most	43401	Ústecký kraj	HOSPIC v MOSTĚ, o.p.s.	50.5088942	13.6228219	398
2636	24	Rybářské náměstí	662/4	Předměstí	Litoměřice	41201	Ústecký kraj	Hospic sv. Štěpána, z..s.	50.5326260	14.1256763	399
2611	1355	Dukelských hrdinů	969/6	Holešovice	Praha	17000	Hlavní město Praha	VIDA centrum Praha	50.0981913	14.4334454	400
2606	1350	Jateční	870/41	Klíše	Ústí nad Labem	40001	Ústecký kraj	Osobní asistence Helias	50.6628192	14.0092717	401
2525	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Oblastní charita Ústí nad Labem	50.6732608	14.0160860	402
2524	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Centrum služeb pro rodinu	50.6732608	14.0160860	403
2521	162	Svážná	1528	Most	Most	43401	Ústecký kraj	HOSPIC v MOSTĚ, o.p.s.	50.5088942	13.6228219	404
2484	24	Rybářské náměstí	662/4	Předměstí	Litoměřice	41201	Ústecký kraj	Hospic sv. Štěpána, z..s.	50.5326260	14.1256763	405
1679	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Domov pro seniory	50.5122999	13.6495154	457
2483	1303	\N	40	Horní Poustevna	Dolní Poustevna	40747	Ústecký kraj	Integrované centrum pro osoby se zdravotním postižením Horní Poustevna	50.9994763	14.2951738	406
2481	1303	\N	40	Horní Poustevna	Dolní Poustevna	40747	Ústecký kraj	Integrované centrum pro osoby se zdravotním postižením	50.9994763	14.2951738	407
2262	485	Rooseveltova	716/7	Předměstí	Litoměřice	41201	Ústecký kraj	Chráněné bydlení Kamýcká	\N	\N	408
2158	399	\N	71	Dolní Falknov	Kytlice	40745	Ústecký kraj	Domovy pro osoby se zdravotním postižením	50.8157110	14.5330443	409
2152	555	Čelakovského	40/13	Krásná Lípa	Krásná Lípa	40746	Ústecký kraj	Domov se zvláštním režimem Krásná Lípa (objekt P1)	50.9173676	14.4969475	410
1987	1083	Mírové nám.	342	Velký Šenov	Velký Šenov	40778	Ústecký kraj	Pečovatelská služba	50.9920025	14.3782625	411
1986	1082	Bezručova	87/2	Děčín IV-Podmokly	Děčín	40502	Ústecký kraj	Krizová poradna	50.7742334	14.1978684	412
1974	1078	Rakovnická	394/21a	Děčín III-Staré Město	Děčín	40502	Ústecký kraj	Nízkoprahové denní centrum	50.7717100	14.2186285	413
1953	1069	Na Popluží	821/11	Klíše	Ústí nad Labem	40001	Ústecký kraj	Centrum pro zdravotně postižené Ústeckého kraje, o. p. s.	50.6676585	14.0165999	414
1946	1064	Mírová	2820/2	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	Demosthenes, o.p.s.	50.6830922	14.0314481	415
1926	1050	K. Maličkého	382/16	Lovosice	Lovosice	41002	Ústecký kraj	PeÄovatelskÃ¡ sluÅ¾ba Å ance Lovosice, z.s.	50.5158230	14.0452472	416
1920	1047	Varšavská	688/40	Střekov	Ústí nad Labem	40003	Ústecký kraj	SociÃ¡lnÃ­ agentura, o. p. s.	50.6584598	14.0521560	417
1904	1041	Vaníčkova	835/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	NÃ­zkoprahovÃ½ klub Orion	50.6603102	14.0335739	418
1887	964	Šafaříkova	635/24	Vinohrady	Praha	12000	Hlavní město Praha	Člověk v tísni, o.p.s - eNCéčko	\N	\N	419
1884	964	Šafaříkova	635/24	Vinohrady	Praha	12000	Hlavní město Praha	Člověk v tísni o.p.s., Nový svět	\N	\N	420
1882	1025	Jungmannova	1024	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Pečovatelská služba OPORA	50.4229920	14.2560580	421
1881	1025	Jungmannova	1024	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Pečovatelská služba OPORA	50.4229920	14.2560580	422
1858	1013	Dukelská	28	Kovářská	Kovářská	43186	Ústecký kraj	Domov pro osoby se zdravotním postižením	50.4343735	13.0490042	423
1856	1009	Pod strání	170	Meziboří	Meziboří	43513	Ústecký kraj	SPOLEČNÝ ŽIVOT	50.6242574	13.5958816	424
1830	994	Přísečnická	456/6	Vejprty	Vejprty	43191	Ústecký kraj	Domovy se zvláštním režimem Vejprty	50.4932978	13.0319622	425
1829	994	Přísečnická	456/6	Vejprty	Vejprty	43191	Ústecký kraj	Domovy pro osoby se zdravotním postižením Vejprty	50.4932978	13.0319622	426
1828	994	Přísečnická	456/6	Vejprty	Vejprty	43191	Ústecký kraj	Domov pro seniory Vejprty	50.4932978	13.0319622	427
1826	992	nám. ČSA	84	Terezín	Terezín	41155	Ústecký kraj	Domov se zvláštním režimem Terezín	50.5100522	14.1490431	428
1816	964	Šafaříkova	635/24	Vinohrady	Praha	12000	Hlavní město Praha	Člověk v tísni, o.p.s.	\N	\N	429
1815	964	Šafaříkova	635/24	Vinohrady	Praha	12000	Hlavní město Praha	Člověk v tísni, o.p.s.	\N	\N	430
1810	979	Hornická	106	Meziboří	Meziboří	43513	Ústecký kraj	ENERGIE o.p.s.	50.6225958	13.6017541	431
1808	964	Šafaříkova	635/24	Vinohrady	Praha	12000	Hlavní město Praha	Člověk v tísni, o.p.s.	\N	\N	432
1806	977	\N	172	Vilémov	Vilémov	40780	Ústecký kraj	Dům s pečovatelskou službou	50.9921932	14.3307082	433
1805	976	Mírové náměstí	83	Úštěk-Vnitřní Město	Úštěk	41145	Ústecký kraj	Pečovatelská služba	50.5843328	14.3426956	434
1803	974	Pražská	166/47	Vaňov	Ústí nad Labem	40001	Ústecký kraj	Terapeutická komunita WHITE LIGHT I	50.6253745	14.0588188	435
1801	974	Pražská	166/47	Vaňov	Ústí nad Labem	40001	Ústecký kraj	Terénní program WHITE LIGHT I Teplicko	50.6253745	14.0588188	436
1800	974	Pražská	166/47	Vaňov	Ústí nad Labem	40001	Ústecký kraj	Kontaktní a poradenské centrum WHITE LIGHT I Teplice	50.6253745	14.0588188	437
1798	974	Pražská	166/47	Vaňov	Ústí nad Labem	40001	Ústecký kraj	Kontaktní a poradenské centrum WHITE LIGHT I Rumburk	50.6253745	14.0588188	438
1796	974	Pražská	166/47	Vaňov	Ústí nad Labem	40001	Ústecký kraj	Kontaktní a poradenské centrum WHITE LIGHT I Rumburk	50.6253745	14.0588188	439
1795	974	Pražská	166/47	Vaňov	Ústí nad Labem	40001	Ústecký kraj	Centrum následné péče WHITE LIGHT I	50.6253745	14.0588188	440
1792	973	Sládkova	344	Česká Kamenice	Česká Kamenice	40721	Ústecký kraj	Domov pro seniory a pečovatelská služba Česká Kamenice, příspěvková organizace	50.8041713	14.4207812	441
1776	962	Thámova	711/20	Trnovany	Teplice	41501	Ústecký kraj	Azylový dům pro matky s dětmi Agapé	50.6501504	13.8422491	442
1775	962	Thámova	711/20	Trnovany	Teplice	41501	Ústecký kraj	Dluhová a občanská poradna Teplice	50.6501504	13.8422491	443
1767	954	Lužická	727/7	Děčín II-Nové Město	Děčín	40502	Ústecký kraj	Sociální rehabilitace - Agentura Osmý den, o. p. s.	50.7833953	14.2229428	444
1749	946	nám. Svobody	2	Hoštka	Hoštka	41172	Ústecký kraj	Dům s pečovatelskou službou	50.4892724	14.3355123	445
1724	929	Revoluční	1421/4	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	TyfloCentrum Ústí nad Labem, o.p.s.	50.6598359	14.0392050	446
1721	929	Revoluční	1421/4	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	TyfloCentrum Ústí nad Labem, o.p.s.	50.6598359	14.0392050	447
1716	926	U Dubu	1562	Jirkov	Jirkov	43111	Ústecký kraj	Městský ústav sociálních služeb, příspěvková organizace	50.5030828	13.4478877	448
1715	926	U Dubu	1562	Jirkov	Jirkov	43111	Ústecký kraj	Městský ústav sociálních služeb, příspěvková organizace	50.5030828	13.4478877	449
1714	926	U Dubu	1562	Jirkov	Jirkov	43111	Ústecký kraj	Městský ústav sociálních služeb, příspěvková organizace	50.5030828	13.4478877	450
1687	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Domov se zvláštním režimem	50.5122999	13.6495154	451
1685	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Poradna pro rodinu, manželství a mezilidské vztahy	50.5122999	13.6495154	452
1684	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Pečovatelská služba	50.5122999	13.6495154	453
1683	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Denní dětský rehabilitační stacionář	50.5122999	13.6495154	454
1682	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Denní stacionář pro seniory	50.5122999	13.6495154	455
1677	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Denní stacionář pro mentálně postižené klienty, příp. kombinovaně handicapované občany s ukončenou školní docházkou	50.5122999	13.6495154	458
1676	911	Barvířská	495	Most	Most	43401	Ústecký kraj	Domov pro seniory	50.5122999	13.6495154	459
1642	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Sovička	50.4937747	13.6599037	460
1640	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Rozmarýnek	50.4937747	13.6599037	461
1639	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Sociální a dluhová poradna Most	50.4937747	13.6599037	462
1638	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Osobní asistence	50.4937747	13.6599037	463
1632	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Pečovatelská služba	50.4937747	13.6599037	464
1621	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Centrum "Rodina v tísni" - Dům na půl cesty	50.4937747	13.6599037	465
1620	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Centrum "Rodina v tísni" - Azylový dům pro matky s dětmi	50.4937747	13.6599037	466
1618	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Noclehárna Duchcov	50.4937747	13.6599037	467
1617	895	Františka Malíka	956/16a	Most	Most	43401	Ústecký kraj	Azylový dům Duchcov	50.4937747	13.6599037	468
1610	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	Terénní programy pro lidi ohrožené drogou	50.5044316	13.6355873	469
1609	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	Terénní protidrogový program pro okres Most, Teplice a Louny	50.5044316	13.6355873	470
1608	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	K-centrum Liberec a Jablonec nad Nisou	50.5044316	13.6355873	471
1607	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	K-centrum Most	50.5044316	13.6355873	472
1604	891	Petra Jilemnického	1929/9	Most	Most	43401	Ústecký kraj	Linka duševní tísně	50.5044316	13.6355873	473
1594	885	Tylova	1239/16	Předměstí	Litoměřice	41201	Ústecký kraj	Terénní program Litoměřicka	\N	\N	474
1593	885	Tylova	1239/16	Předměstí	Litoměřice	41201	Ústecký kraj	Kontaktní centrum Litoměřice	\N	\N	475
1571	69	Lípová	2881	Teplice	Teplice	41501	Ústecký kraj	Senior Teplice	50.6406195	13.8315646	476
1563	874	Prokopa Diviše	1605/5	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Poradna pro rodinu a mezilidské vztahy	50.6632936	14.0323478	477
1557	87	Sámova	2481	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Domov důchodců Roudnice nad Labem, příspěvková organizace	50.4186079	14.2455797	478
1556	87	Sámova	2481	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Domov důchodců Roudnice nad Labem, příspěvková organizace	50.4186079	14.2455797	479
1552	869	\N	6	České Kopisty	Terezín	41201	Ústecký kraj	Camphill na soutoku, z.s.	50.5245880	14.1665428	480
1515	835	Prokopa Diviše	1605/5	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Dobrovolnické centrum, z.s.	50.6632936	14.0323478	481
1512	825	Zeyerova	859	Žatec	Žatec	43801	Ústecký kraj	Kamarád - LORM	50.3248542	13.5378363	482
1509	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Sociálně aktivizační služby pro sluchově postižené Ústí nad Labem	50.5066287	13.6604152	483
1508	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Tlumočnické služby pro sluchově postižené Ústí nad Labem a Ústecký raj	50.5066287	13.6604152	484
1507	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Sociálně aktivizační služby pro sluchově postižené Louny	50.5066287	13.6604152	485
1506	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Tlumočnické služby Louny a Ústecký kraj	50.5066287	13.6604152	486
1505	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Sociálně aktivizační služby pro sluchově postižené Teplice	50.5066287	13.6604152	487
1504	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Tlumočnické služby pro sluchově postižené Teplice a Ústecký kraj	50.5066287	13.6604152	488
1503	831	K. H. Borovského	1853	Most	Most	43401	Ústecký kraj	Sociálně aktivizační služby pro sluchově postižené Most	50.5066287	13.6604152	489
1482	825	Zeyerova	859	Žatec	Žatec	43801	Ústecký kraj	Domov pro osoby se zdravotním postižením	50.3248542	13.5378363	490
1480	825	Zeyerova	859	Žatec	Žatec	43801	Ústecký kraj	Domov pro osoby se zdravotním postižením	50.3248542	13.5378363	491
1479	825	Zeyerova	859	Žatec	Žatec	43801	Ústecký kraj	Domov pro osoby se zdravotním postižením	50.3248542	13.5378363	492
1405	800	Fügnerova	355/16	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Poradna Prosapia	50.7778507	14.2171139	493
1393	792	Rakovnická	2502	Louny	Louny	44001	Ústecký kraj	Městská pečovatelská služba s denním stacionářem Louny	50.3480584	13.8071465	494
1370	780	Lípová	333/25	Teplice	Teplice	41501	Ústecký kraj	Odborné sociální poradenství	50.6412328	13.8343077	495
1368	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Terénní programy - Kadaňsko	50.3899214	13.2696234	496
1367	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	K-Centrum Kadaň	50.3899214	13.2696234	497
1365	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Terénní program Karlovy Vary a přilehlé obce	50.3899214	13.2696234	498
1364	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	K-centrum Karlovy Vary	50.3899214	13.2696234	499
1363	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	Terénní programy - Chomutovsko	50.3899214	13.2696234	500
1361	778	Husova	1325	Kadaň	Kadaň	43201	Ústecký kraj	K-Centrum Chomutov	50.3899214	13.2696234	501
1356	774	Stavební	415/3	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Občanská poradna Děčín	50.7787440	14.2183492	502
1354	774	Stavební	415/3	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Asistenční služba pro rodiny s dětmi	50.7787440	14.2183492	503
1347	769	K. Maličkého	418/2	Lovosice	Lovosice	41002	Ústecký kraj	Panna Marie Pomocná s dětmi a mládeží	50.5158230	14.0452472	504
1346	769	K. Maličkého	418/2	Lovosice	Lovosice	41002	Ústecký kraj	SAS FCHL	50.5158230	14.0452472	505
1345	769	K. Maličkého	418/2	Lovosice	Lovosice	41002	Ústecký kraj	Terénní služba pro osoby ohrožené sociálním vyloučením	50.5158230	14.0452472	506
1335	763	Josefa Suka	268/25	Most	Most	43401	Ústecký kraj	Centrum služeb pro zdravotně postižené o.p.s.	50.5022774	13.6572944	507
1333	763	Josefa Suka	268/25	Most	Most	43401	Ústecký kraj	Centrum služeb pro zdravotně postižené o.p.s.	50.5022774	13.6572944	508
1306	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	Středisko Arkadie Kollárova	50.6335303	13.8287003	509
1305	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	Středisko Arkadie Rovná	50.6335303	13.8287003	510
1303	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	Středisko Arkadie Novoveská, Teplice	50.6335303	13.8287003	511
1301	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	Středisko Arkadie Úpořiny	50.6335303	13.8287003	512
1300	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	denní stacionář Marka Petlana	50.6335303	13.8287003	513
1299	752	Purkyňova	2004/10	Teplice	Teplice	41501	Ústecký kraj	Středisko Arkadie Kollárova	50.6335303	13.8287003	514
1272	71	Nám. E. Beneše	470	Varnsdorf	Varnsdorf	40747	Ústecký kraj	CSS města Varnsdorf - Nízkoprahový klub Modrý kámen	50.9120975	14.6197564	515
1270	71	Nám. E. Beneše	470	Varnsdorf	Varnsdorf	40747	Ústecký kraj	CSS města Varnsdorf - Noclehárna	50.9120975	14.6197564	516
1268	71	Nám. E. Beneše	470	Varnsdorf	Varnsdorf	40747	Ústecký kraj	Centrum sociálních služeb  a ubytovna Varnsdorf	50.9120975	14.6197564	517
1252	725	Břežánská	50/4	Bílina	Bílina	41801	Ústecký kraj	Pečovatelská služba Bílina	50.5489169	13.7742885	518
1249	722	Náměstí Dobrovského	379/11	Rumburk 1	Rumburk	40801	Ústecký kraj	Zavináč	50.9518948	14.5559641	519
1245	716	K Chatám	22	Skorotice	Ústí nad Labem	40340	Ústecký kraj	Centrum krizové intervence	50.6910115	14.0044033	520
1244	716	K Chatám	22	Skorotice	Ústí nad Labem	40340	Ústecký kraj	Intervenční centrum, Ústecký kraj	50.6910115	14.0044033	521
1240	716	K Chatám	22	Skorotice	Ústí nad Labem	40340	Ústecký kraj	Centrum krizové intervence	50.6910115	14.0044033	522
1238	716	K Chatám	22	Skorotice	Ústí nad Labem	40340	Ústecký kraj	Centrum krizové intervence	50.6910115	14.0044033	523
1216	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Klub Lucerna	50.6732608	14.0160860	524
1213	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Centrum pomoci Samaritán	50.6732608	14.0160860	525
1212	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Noclehárna Samaritán	50.6732608	14.0160860	526
1211	701	Štefánikova	246/1	Klíše	Ústí nad Labem	40001	Ústecký kraj	Azylový dům Samaritán	50.6732608	14.0160860	527
1210	700	Pěší	9	Děčín XXXIII-Nebočady	Děčín	40502	Ústecký kraj	Jurta o.p.s.	50.7304755	14.1908622	528
1209	700	Pěší	9	Děčín XXXIII-Nebočady	Děčín	40502	Ústecký kraj	Jurta o.p.s.	50.7304755	14.1908622	529
1207	698	Riegrova	652	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Azylový dům pro matky s dětmi v Domově sv. Josefa	50.4229534	14.2585936	530
1206	698	Riegrova	652	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	Pečovatelská služba při FCH Rce n.L.	50.4229534	14.2585936	531
1205	698	Riegrova	652	Roudnice nad Labem	Roudnice nad Labem	41301	Ústecký kraj	NZDM Bota	50.4229534	14.2585936	532
1188	684	Hrnčířská	53/18	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Tlumočnické služby	50.6605460	14.0444103	533
1187	684	Hrnčířská	53/18	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Odborné sociální poradenství	50.6605460	14.0444103	534
1177	680	2. polské armády	1094/27	Rumburk 1	Rumburk	40801	Ústecký kraj	Agentura Pondělí - sociální rehabilitace (ambulantní forma)	50.9578602	14.5554399	535
1039	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Terénní programy	50.7828894	14.2158740	536
1038	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Kontaktní a poradenské centrum pro drogově závislé	50.7828894	14.2158740	537
1037	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Azylový dům pro muže a matky s dětmi	50.7828894	14.2158740	538
1036	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Azylový dům pro muže a matky s dětmi	50.7828894	14.2158740	539
1035	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Pečovatelská služba	50.7828894	14.2158740	540
1034	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Služby pro osoby se zdravotním postižením - úsek Boletice	50.7828894	14.2158740	541
1033	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Služby pro osoby se zdravotním postižením - úsek Denní stacionář DOMINO	50.7828894	14.2158740	542
1032	622	28. října	1155/2	Děčín I-Děčín	Děčín	40502	Ústecký kraj	Domov pro seniory	50.7828894	14.2158740	543
1011	611	Na Vypichu	180	Lahošť	Lahošť	41725	Ústecký kraj	Nízkoprahové zařízení pro děti a mládež Klub Květina	50.6214165	13.7566630	544
1005	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Manželská a předmanželská poradna Litoměřice	50.5205123	14.0453183	545
1003	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Manželská a předmanželská poradna Litoměřice, detašované pracoviště Louny	50.5205123	14.0453183	546
1001	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Domov sociální péče Skalice	50.5205123	14.0453183	547
1000	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Domov sociální péče Chotěšov	50.5205123	14.0453183	548
999	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Domov Na Pustaji Křešice	50.5205123	14.0453183	549
998	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Domov důchodců Čížkovice	50.5205123	14.0453183	550
994	605	Dlouhá	362/75	Lovosice	Lovosice	41002	Ústecký kraj	Domov důchodců Libochovice	50.5205123	14.0453183	551
985	601	Mírové nám.	280	Jílové	Jílové	40701	Ústecký kraj	Pečovatelská služba  Jílové	50.7611738	14.1045100	552
936	569	nám. 8. května	341	Meziboří	Meziboří	43513	Ústecký kraj	Pečovatelská služba Meziboří	50.6201572	13.6066273	553
935	568	\N	273	Lipová	Lipová	40781	Ústecký kraj	Domov důchodců Lipová	51.0174313	14.3657200	554
931	564	Sukova	1055/24	Rumburk 1	Rumburk	40801	Ústecký kraj	Asistenční služba pro rodiny s dětmi	50.9523820	14.5519373	555
929	564	Sukova	1055/24	Rumburk 1	Rumburk	40801	Ústecký kraj	Žijeme spolu - nízkoprahové zařízení pro děti a mládež	50.9523820	14.5519373	556
927	564	Sukova	1055/24	Rumburk 1	Rumburk	40801	Ústecký kraj	"Občanská poradna Rumburk"	50.9523820	14.5519373	557
923	560	Na Výšině	494	Dubí	Dubí	41701	Ústecký kraj	Podkrušnohorské domovy sociálních služeb Dubí - Teplice, příspěvková organizace	50.6774965	13.7859498	558
922	560	Na Výšině	494	Dubí	Dubí	41701	Ústecký kraj	Podkrušnohorské domovy sociálních služeb Dubí - Teplice, příspěvková organizace	50.6774965	13.7859498	559
920	559	Mariánské náměstí	32	Bohosudov	Krupka	41742	Ústecký kraj	Pečovatelská služba Krupka	50.6819141	13.8741227	560
914	553	Kochova	1185	Chomutov	Chomutov	43001	Ústecký kraj	Osobní asistence - CP ZPS	50.4551743	13.4112939	561
913	550	Okružní	104	Meziboří	Meziboří	43513	Ústecký kraj	Domov sociálních služeb Meziboří, příspěvková organizace	50.6221869	13.6026458	562
850	527	Teplická	26/25	Děčín IV-Podmokly	Děčín	40502	Ústecký kraj	Agentura osobní asistenční služby, z. ú.	50.7755046	14.1978871	563
817	508	\N	1	Snědovice	Snědovice	41174	Ústecký kraj	Ústav sociální péče pro tělesně postižené dospělé Snědovice, příspěvková organiz	50.5036932	14.3906291	564
781	485	Rooseveltova	716/7	Předměstí	Litoměřice	41201	Ústecký kraj	Sociální rehabilitace	\N	\N	565
780	485	Rooseveltova	716/7	Předměstí	Litoměřice	41201	Ústecký kraj	Domov  pro rodiče s dětmi	\N	\N	566
779	485	Rooseveltova	716/7	Předměstí	Litoměřice	41201	Ústecký kraj	Centrum denních služeb	\N	\N	567
766	475	\N	65	Filipov	Jiříkov	40753	Ústecký kraj	Domov pro seniory	50.9801762	14.5975311	568
747	469	Pod Horkou	85	Chlumec	Chlumec	40339	Ústecký kraj	Domov pro seniory Chlumec, příspěvková organizace	50.6999465	13.9433867	569
746	467	Filipovská	582/20	Starý Jiříkov	Jiříkov	40753	Ústecký kraj	Domov Severka Jiříkov, příspěvková organizace	50.9917928	14.5760743	570
718	448	Mírové nám.	163	Štětí	Štětí	41108	Ústecký kraj	Město Štětí	50.4539625	14.3728533	571
715	446	CHYBA: 'NoneType' object has no attribute 'get'	\N	\N	\N	\N	\N	Domov důchodců Bystřany	\N	\N	572
714	446	CHYBA: 'NoneType' object has no attribute 'get'	\N	\N	\N	\N	\N	Domov důchodců Bystřany	\N	\N	573
712	445	Křečanská	630	Šluknov	Šluknov	40777	Ústecký kraj	Domov pro seniory Šluknov	51.0010863	14.4538913	574
707	440	Hoření	3083/13	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	Pečovatelská služba Ústí nad Labem, příspěvková organizace (zázemí)	50.6750022	14.0363960	575
698	435	Fügnerova	282/11	Trmice	Trmice	40004	Ústecký kraj	Poradenské informační centrum	50.6429157	13.9989999	576
697	435	Fügnerova	282/11	Trmice	Trmice	40004	Ústecký kraj	Poradenské informační centrum	50.6429157	13.9989999	577
671	416	Věžní	958	Kadaň	Kadaň	43201	Ústecký kraj	Pečovatelská služba	50.3761366	13.2759279	578
668	416	Věžní	958	Kadaň	Kadaň	43201	Ústecký kraj	Domov pro seniory	50.3761366	13.2759279	579
648	398	\N	58	Rovné	Krabčice	41187	Ústecký kraj	Diakonie ČCE - středisko v Krabčicích	50.4018626	14.3041850	580
647	398	\N	58	Rovné	Krabčice	41187	Ústecký kraj	Diakonie ČCE - středisko v Krabčicích	50.4018626	14.3041850	581
633	391	Velká Hradební	13/47	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Kontaktní centrum pro drogově závislé	50.6603133	14.0372639	582
631	391	Velká Hradební	13/47	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Kontaktní centrum pro drogově závislé	50.6603133	14.0372639	583
623	389	Klášterní	2	Velké Březno	Velké Březno	40323	Ústecký kraj	Domov se zvláštním režimem	50.6663322	14.1398604	584
614	380	Revoluční	1845/30	Předměstí	Litoměřice	41201	Ústecký kraj	Centrum pro zdravotně postižené děti a mládež - SRDÍČKO	\N	\N	585
598	367	\N	131	Stará Oleška	Huntířov	40502	Ústecký kraj	Domovy pro osoby se zdravotním postižením Stará Oleška	50.8005075	14.3364938	586
559	340	Březinova	1093	Kadaň	Kadaň	43201	Ústecký kraj	Domov pro seniory a Domov pro osoby se zdravotním postižením Mašťov	50.3768233	13.2651021	587
558	340	Březinova	1093	Kadaň	Kadaň	43201	Ústecký kraj	Domov pro seniory a Domov pro osoby se zdravotním postižením Mašťov	50.3768233	13.2651021	588
556	340	Březinova	1093	Kadaň	Kadaň	43201	Ústecký kraj	Domov pro osoby se zdravotním postižením Kadaň	50.3768233	13.2651021	589
554	340	Březinova	1093	Kadaň	Kadaň	43201	Ústecký kraj	Domov pro osoby se zdravotním postižením Kadaň	50.3768233	13.2651021	590
506	315	Dvořákova	1331/20	Děčín II-Nové Město	Děčín	40502	Ústecký kraj	Centrum služeb a pomoci AVAZ	50.7827157	14.2330407	591
473	144	V Klidu	3133/12	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	Domov pro seniory Severní Terasa, příspěvková organizace	50.6846794	14.0194151	592
466	296	Kosmonautů	2022	Předměstí	Litoměřice	41201	Ústecký kraj	Domov svaté Máří Magdalény Jiřetín pod Jedlovou	50.5380521	14.1234960	593
465	296	Kosmonautů	2022	Předměstí	Litoměřice	41201	Ústecký kraj	Charitní pečovatelská služba	50.5380521	14.1234960	594
464	296	Kosmonautů	2022	Předměstí	Litoměřice	41201	Ústecký kraj	Charitní pečovatelská služba	50.5380521	14.1234960	595
463	296	Kosmonautů	2022	Předměstí	Litoměřice	41201	Ústecký kraj	Charitní pečovatelská služba	50.5380521	14.1234960	596
460	282	Nádražní	933	Podbořany	Podbořany	44101	Ústecký kraj	Domov pro seniory Podbořany, příspěvková organizace	50.2244854	13.4068903	597
415	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Chráněné bydlení Ústí nad Labem	50.6630615	14.0372032	598
414	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociální rehabilitace Ústí nad Labem	50.6630615	14.0372032	599
413	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Fokus Labe - Ústí nad Labem	50.6630615	14.0372032	600
412	270	Stroupežnického	1372/9	Ústí nad Labem-centrum	Ústí nad Labem	40001	Ústecký kraj	Sociálně aktivizační služby Ústí nad Labem	50.6630615	14.0372032	601
404	267	Na Florenci	2116/15	Nové Město	Praha	11000	Hlavní město Praha	Nemocnice Roudnice nad Labem s.r.o.	50.0888675	14.4351915	602
403	267	Na Florenci	2116/15	Nové Město	Praha	11000	Hlavní město Praha	Podřipská nemocnice s poliklinikou Roudnice n. L., s.r.o.	50.0888675	14.4351915	603
390	256	\N	119	Brtníky	Staré Křečany	40760	Ústecký kraj	Domov Brtníky, příspěvková organizace	50.9475950	14.4415449	604
348	231	\N	1	Tuchořice	Tuchořice	43969	Ústecký kraj	Domov "Bez zámků" Tuchořice, příspěvková organizace	50.2844389	13.6609024	605
346	229	Šrámkova	3305/38a	Severní Terasa	Ústí nad Labem	40011	Ústecký kraj	Domov pro seniory Dobětice, příspěvková organizace	50.6757897	14.0596102	606
344	228	Lomená	47/2	Most	Most	43401	Ústecký kraj	Azylový dům pro ženy a matky s dětmi v tísni Most	50.5103141	13.6284795	607
312	201	Za Vozovnou	783/1	Bukov	Ústí nad Labem	40001	Ústecký kraj	Domov pro seniory Bukov, příspěvková organizace	50.6785290	14.0114108	608
311	201	Za Vozovnou	783/1	Bukov	Ústí nad Labem	40001	Ústecký kraj	Domov pro seniory Bukov, příspěvková organizace	50.6785290	14.0114108	609
305	193	Zahradnická	1534/5	Předměstí	Litoměřice	41201	Ústecký kraj	Farní charita Litoměřice, Pečovatelská služba	\N	\N	610
302	193	Zahradnická	1534/5	Předměstí	Litoměřice	41201	Ústecký kraj	Domov na Dómském pahorku - domov pro seniory	\N	\N	611
301	193	Zahradnická	1534/5	Předměstí	Litoměřice	41201	Ústecký kraj	Středisko sociální prevence a humanitární pomoci - nízkoprahové denní centrum	\N	\N	612
300	193	Zahradnická	1534/5	Předměstí	Litoměřice	41201	Ústecký kraj	Středisko sociální prevence a humanitární pomoci - nízkoprahové denní centrum	\N	\N	613
299	193	Zahradnická	1534/5	Předměstí	Litoměřice	41201	Ústecký kraj	Středisko sociální prevence a humanitární pomoci - nízkoprahové denní centrum	\N	\N	614
276	183	Zátiší	177	Janov	Litvínov	43542	Ústecký kraj	Domovy sociálních služeb Litvínov, příspěvková organizace	50.5908620	13.5537590	615
244	165	nám. Míru	1	Šluknov	Šluknov	40777	Ústecký kraj	Dům s pečovatelskou službou	51.0032366	14.4516664	616
213	142	Písečná	5030	Chomutov	Chomutov	43004	Ústecký kraj	Centrum denních služeb Bezručova (CDS Bezručova)	50.4869592	13.4410344	617
212	142	Písečná	5030	Chomutov	Chomutov	43004	Ústecký kraj	Centrum pro osoby se zdravotním postižením Písečná (COZP Písečná)	50.4869592	13.4410344	618
210	142	Písečná	5030	Chomutov	Chomutov	43004	Ústecký kraj	Sociální centrum Kamenná	50.4869592	13.4410344	619
209	142	Písečná	5030	Chomutov	Chomutov	43004	Ústecký kraj	Sociální poradna Palackého	50.4869592	13.4410344	620
208	142	Písečná	5030	Chomutov	Chomutov	43004	Ústecký kraj	Centrum pro osoby se zdravotním postižením Písečná (COZP Písečná)	50.4869592	13.4410344	621
207	142	Písečná	5030	Chomutov	Chomutov	43004	Ústecký kraj	Domov pro seniory Písečná (DpS Písečná)	50.4869592	13.4410344	622
164	112	Šafaříkova	852	Žatec	Žatec	43801	Ústecký kraj	Domov pro seniory a pečovatelská služba v Žatci	50.3244303	13.5483010	623
163	112	Šafaříkova	852	Žatec	Žatec	43801	Ústecký kraj	Domov pro seniory a pečovatelská služba v Žatci	50.3244303	13.5483010	624
131	93	Kubátova	269	Háj u Duchcova	Háj u Duchcova	41722	Ústecký kraj	Domovy sociálních služeb Háj u Duchcova	50.6315794	13.7133755	625
130	93	Kubátova	269	Háj u Duchcova	Háj u Duchcova	41722	Ústecký kraj	Domovy sociálních služeb Háj u Duchcova	50.6315794	13.7133755	626
100	71	Nám. E. Beneše	470	Varnsdorf	Varnsdorf	40747	Ústecký kraj	CSS města Varnsdorf - Pečovatelská služba	50.9120975	14.6197564	627
98	69	Lípová	2881	Teplice	Teplice	41501	Ústecký kraj	Senior Teplice	50.6406195	13.8315646	628
97	69	Lípová	2881	Teplice	Teplice	41501	Ústecký kraj	Senior Teplice	50.6406195	13.8315646	629
96	69	Lípová	2881	Teplice	Teplice	41501	Ústecký kraj	Senior Teplice	50.6406195	13.8315646	630
85	62	Lípová	545	Klášterec nad Ohří	Klášterec nad Ohří	43151	Ústecký kraj	Městský ústav sociálních služeb Klášterec nad Ohří, příspěvková organizace	50.3936499	13.1789011	631
84	62	Lípová	545	Klášterec nad Ohří	Klášterec nad Ohří	43151	Ústecký kraj	Městský ústav sociálních služeb Klášterec nad Ohří, příspěvková organizace	50.3936499	13.1789011	632
26	23	Rozcestí	798/9	Krásné Březno	Ústí nad Labem	40007	Ústecký kraj	Domov pro seniory Krásné Březno, p.o.	50.6696682	14.0935244	633
\.


--
-- Data for Name: servicetargetgroup; Type: TABLE DATA; Schema: public; Owner: backend
--

COPY public.servicetargetgroup (service_id, source_group_id, description, id) FROM stdin;
7555	3754	\N	1
7555	3755	Pro osoby s poruchou autistického spektra a s lehkým a středním mentálním postižením.	2
7555	3756	\N	3
7554	3757	Terénní služba poskytována dle potřeb uživatelů v Ústí nad Labem a jeho spádových obcích.	4
7553	3751	\N	5
7527	3751	Jedná se o osoby s poruchou chování a osobám s prokazatelným rizikem rozvoje poruchy chování, které se nacházejí v nepříznivé sociální situaci, a jejich osobám blízkým.	6
7524	3764	\N	7
7523	3760	\N	8
7517	3753	\N	9
7517	3754	\N	10
7480	3764	\N	11
7432	3764	\N	12
7415	3765	\N	13
7413	3751	Osoby s Alzheimerovou chorobou a ostatními typy demence	14
7405	3747	\N	15
7391	3752	\N	16
7391	3758	\N	17
7391	3764	\N	18
7391	3765	\N	19
7380	3756	Terénní forma sociální služby poskytována na území Hlavního města Prahy, Karlovarského kraje, Libereckého kraje, Plzeňského kraje, Středočeského kraje a Ústeckého kraje.	20
7380	11079	Terénní forma sociální služby poskytována na území Hlavního města Prahy, Karlovarského kraje, Libereckého kraje, Plzeňského kraje, Středočeského kraje a Ústeckého kraje.	21
7377	3751	Sociální služba je poskytována dětem a mladým lidem s duševním onemocněním či s rizikem rozvoje duševního onemocnění a jejich rodinám (vyjma osob s poruchou autistického spektra). Terénní forma je poskytována dle potřeb uživatelů ve městě Ústí nad Labem a jeho spádových obcí.	22
7376	3751	Sociální služba je poskytována osobám s chronickým duševním onemocněním převážně z okruhu psychóz, jako jsou například schizofrenie, bipolární porucha a hraniční stavy a osobám s duální diagnózou (duševní onemocnění a závislost). Jedná se o osoby s duševní poruchou či osoby s prokazatelným rizikem rozvoje duševní poruchy a osoby jim blízké. Terénní forma je poskytována dle potřeb uživatelů ve městech Litoměřice, Lovosice a Roudnice nad Labem, včetně jejich spádových obcí.	23
7370	3753	Osoby s poruchou autistického spektra.	24
7361	3756	\N	25
7361	3758	Služba je určena také osobám s neurodegenerativními onemocněním, např. demence, Parkinsonova choroba.	26
7361	3765	\N	27
7357	3757	Terénní služba poskytována dle potřeb uživatelů v Mostě a jeho spádových obcích.	28
7356	3757	Terénní služba poskytována dle potřeb uživatelů v Děčíně a jeho spádových obcích.	29
7349	3743	\N	30
7349	3766	\N	31
7341	3760	Jedná se o děti a dospívající ve věku 11-18 let ohrožené rozvojem duševního onemocnění a nebo v kriti a jejich rodiny.	32
7338	3751	Terénní forma sociální služby je poskytována dle potřeb uživatelů na území obcí ve správním obvodu obce s rozšířenou působností Chomutov a Jirkov.	33
7338	3752	Terénní forma sociální služby je poskytována dle potřeb uživatelů na území obcí ve správním obvodu obce s rozšířenou působností Chomutov a Jirkov.	34
7338	3758	Terénní forma sociální služby je poskytována dle potřeb uživatelů na území obcí ve správním obvodu obce s rozšířenou působností Chomutov a Jirkov.	35
7338	3764	Terénní forma sociální služby je poskytována dle potřeb uživatelů na území obcí ve správním obvodu obce s rozšířenou působností Chomutov a Jirkov.	36
7338	3765	Terénní forma sociální služby je poskytována dle potřeb uživatelů na území obcí ve správním obvodu obce s rozšířenou působností Chomutov a Jirkov.	37
7335	3751	Senioři od 65 let věku s demencí nebo Alzheimerovou chorobou.	38
7334	3765	Senioři se sníženou soběstačností ve věku od 65 let, jejichž situace vyžaduje pravidelnou pomoc jiné fyzické osoby.	39
7332	3751	Sociální služba je poskytována osobám s duševním onemocněním převážně z okruhu psychóz, jako jsou například schizofrenie, bipolární porucha a hraniční stavy, a osobám s duální diagnózou (duševní onemocnění a závislost). Terénní forma je poskytována dle potřeb uživatelů ve městech Louny, Žatec a Podbořany, včetně jejich spádových obcí.	40
7331	3751	Sociální služba je poskytována osobám s duševním onemocněním z okruhu psychóz, jako jsou například schizofrenie, bipolární porucha a hraniční stavy, a osobám s duální diagnózou (duševní onemocnění a závislost). Terénní forma je poskytována dle potřeb uživatelů ve městě Chomutov, včetně jeho spádových obcí.	41
7330	3751	Sociální služba je poskytována osobám s duševním onemocněním převážně z okruhu psychóz, jako jsou například schizofrenie, bipolární porucha a hraniční stavy, a osobám s duální diagnózou (duševní onemocnění a závislost).\nTerénní forma je poskytována ve městě Ústí nad Labem, včetně jeho spádových obcí.	42
7324	3753	Služba je poskytována osobám s poruchou autistického spektra.	43
7324	3754	Služba je poskytována osobám s kombinovaným postižením, konkrétně s diagnózou poruchy autistického spektra v kombinaci s lehkým až středně těžkým mentálním postižením nebo s tělesným postižením.	44
7324	3755	\N	45
7324	3756	\N	46
7306	3750	\N	47
7306	3760	Osobami v krizi se s ohledem na poskytované adiktologické služby rozumí rodinní příslušníci nebo osoby blízké osobám ohrožených závislostí.	48
7305	3742	\N	49
7293	3760	\N	50
7292	3751	Služba je určena osobám s Alzheimerovou chorobou nebo jiným druhem demence.	51
7292	3752	\N	52
7292	3756	\N	53
7292	3758	\N	54
7292	3765	\N	55
7292	11079	\N	56
7271	3760	\N	57
7269	3751	Sociální služba je poskytována seniorům se stařeckou demencí, osobám s Alzheimerovou nemocí a ostatními typy demence, kteří mají sníženou soběstačnost z důvodu těchto onemocnění, a jejichž situace vyžaduje pravidelnou pomoc jiné osoby.	58
7247	3764	Terénní forma je poskytována v Žatci a jeho spádových obcích.	59
7246	3751	Služba je poskytována osobám s duševním onemocněním, zejména osobám se závažnými chronickými diagnózami, jako jsou lidé se schizofrenií, etylickou demencí a duálními diagnózami.	60
7246	3754	\N	61
7205	3763	Služba je určena mužům od 19 do 80 let po propuštění z výkonu trestu.	62
7187	3751	Osoby s poruchou autistického spektra.	63
7184	3753	Z okruhu osob „osoby s jiným zdravotním postižením“ je sociální služba určena osobám, u nichž je deficit intelektu po CMP, autohaváriích nebo způsoben jinými okolnostmi, které nastaly v průběhu jejich života.	64
7184	3754	Z okruhu osob „osoby s jiným zdravotním postižením“ je sociální služba určena osobám, u nichž je deficit intelektu po CMP, autohaváriích nebo způsoben jinými okolnostmi, které nastaly v průběhu jejich života.	65
7184	3755	Z okruhu osob „osoby s jiným zdravotním postižením“ je sociální služba určena osobám, u nichž je deficit intelektu po CMP, autohaváriích nebo způsoben jinými okolnostmi, které nastaly v průběhu jejich života.	66
7139	3758	\N	67
7139	3765	Osoby zejména starší 65 let, které mají o poskytování služby zájem a ocitly se v nepříznivé sociální situaci, mají sníženou soběstačnost a zároveň nevyžadují celodenní lékařskou péči. Pomoc jim nelze zajistit rodinnými příslušníky nebo terénní službou a hrozí jim riziko sociální izolace.	68
7134	3754	\N	69
7134	3758	\N	70
7133	3760	Terénní forma je poskytována dle potřeb uživatelů na území města Žatec a jeho spádových obcích.	71
7131	3751	\N	72
7131	3754	\N	73
7131	3758	\N	74
7129	3754	\N	75
7129	3755	v kombinaci s poruchami chování	76
7129	3751	Osoby s diagnózou schizofrenie.	77
7128	3753	Osoby s poruchou autistického spektra.	78
7113	3747	\N	79
7113	3760	\N	80
7113	3762	Služba je určena osobám bez přístřeší, nebo žijícím v nejistém nebo nevyhovujícím bydlení.	81
7110	3765	\N	82
7105	3754	\N	83
7105	3755	\N	84
7103	3751	Sociální služba je poskytována osobám, kteří mají diagnostikováno psychiatrické onemocnění, nebo jsou tímto onemocněním ohroženi.	85
7057	3751	Služba je určena pro osoby, které mají sníženou soběstačnost v důsledku onemocnění Huntingtonovou chorobou a jsou plně odkázány na pomoc jiné osoby.	86
7056	3751	Služba je určena osobám, které mají sníženou soběstačnost z důvodu onemocnění stařeckou demencí, Alzheimerovou demencí a ostatními typy demencí, u kterých dochází ke změnám v oblasti poznávacích a rozumových schopností, a osobám s Huntingtonovou chorobou.	87
7027	3764	terénní forma je poskytována na území města Štětí	88
6966	3764	Rodina má člena s poruchou atutistického spektra.	89
6955	3752	\N	90
6955	3758	\N	91
6955	3765	Terénní forma služby je poskytována na území měst a obcí Děčín, Dobrná, Huntířov, Stará Oleška, Nová Oleška, Srbská Kamenice, Růžová, Arnoltice, Labská Stráň, Býnovec, Kámen, Ludvíkovice, Markvartice, Česká Kamenice, Jánská, Benešov nad Ploučnicí a v okolí obce Verneřice.	92
6955	3754	\N	93
6945	3751	\N	94
6945	3752	\N	95
6945	3753	\N	96
6945	3764	\N	97
6945	3765	\N	98
6944	3751	Služba je poskytována osobám se stařeckou, Alzheimerovou demencí a ostatními typy demence.	99
6943	3765	Senioři ve věku nad 65 let, kteří mají sníženou soběstačnost z důvodu věku a zdravotního stavu a jejichž situace vyžaduje pravidelnou pomoc jiné fyzické osoby.	100
6942	3765	Senioři ve věku nad 65 let, kteří mají sníženou soběstačnost z důvodu věku a zdravotního stavu a jejichž situace vyžaduje pravidelnou pomoc jiné fyzické osoby.	101
6928	3751	Sociální služba je poskytována osobám se stařeckou, Alzheimerovou demencí a ostatními typy demence. Služba je vzhledem k technickým možnostem budovy určena pouze pro mobilní a částečně mobilní osoby (netýká se stávajících klientů).	102
6925	3753	osoby s poruchou autistického spektra	103
6924	3742	Cílovou skupinou jsou děti a mladí lidé s duševním onemocněním a děti a mladí lidé s rizikem rozvoje duševního onemocnění a jejich rodiny - vyjma dětí s poruchou autistického spektra a mentálního postižení.	104
6924	3751	Cílovou skupinou jsou děti a mladí lidé s duševním onemocněním a děti a mladí lidé s rizikem rozvoje duševního onemocnění a jejich rodiny - vyjma dětí s poruchou autistického spektra a mentálního postižení.	105
6924	3764	Cílovou skupinou jsou děti a mladí lidé s duševním onemocněním a děti a mladí lidé s rizikem rozvoje duševního onemocnění a jejich rodiny - vyjma dětí s poruchou autistického spektra a mentálního postižení.	106
6923	3742	Cílovou skupinou jsou děti a mladí lidé s duševním onemocněním a děti a mladí lidé s rizikem rozvoje duševního onemocnění a jejich rodiny - vyjma dětí s poruchou autistického spektra a mentálního postižení.	107
6923	3751	Cílovou skupinou jsou děti a mladí lidé s duševním onemocněním a děti a mladí lidé s rizikem rozvoje duševního onemocnění a jejich rodiny - vyjma dětí s poruchou autistického spektra a mentálního postižení.	108
6923	3764	Cílovou skupinou jsou děti a mladí lidé s duševním onemocněním a děti a mladí lidé s rizikem rozvoje duševního onemocnění a jejich rodiny - vyjma dětí s poruchou autistického spektra a mentálního postižení.	109
6920	3747	Služba je určena ženám s dětmi, těhotným ženám a ženám, které mají dítě svěřeno do péče, a jejich situace je spojena se ztrátou bydlení. Ve výjimečných případech i mužům, kteří mají do péče svěřeno dítě a jejichž problém je spojen se ztrátou bydlení. Dítětem se rozumí nezaopatřené dítě do 15, výjimečně do 18 let. Službu lze poskytnout dospělé osobě s maximálně 4 dětmi.	110
6885	3744	\N	111
6885	3751	\N	112
6885	3760	\N	113
6885	3764	\N	114
6884	3747	Služba je určena ženám s dětmi, těhotným ženám a ženám, které mají dítě svěřené do péče, jejichž situace je spojena se ztrátou bydlení. Ve vyjímečných případech i mužům, kteří mají do péče svěřené dítě a jejichž situace je spojena se ztátou bydlení. Dítětem se rozumí nezaopatřené dítě do 15 let, vyjímečně do 18 let.	115
6882	3754	\N	116
6882	3755	\N	117
6868	3751	\N	118
6868	3752	\N	119
6868	3753	\N	120
6868	3754	\N	121
6868	3756	\N	122
6868	3758	\N	123
6868	3765	\N	124
6868	3755	\N	125
6806	3753	osoby s poruchou autistického spektra ( PAS)	126
6801	3750	\N	127
6801	3751	\N	128
6801	3754	\N	129
6785	3742	Terénní forma je poskytována dle potřeb uživatelů na území města Česká Kamenice.	130
6772	3747	\N	131
6772	3760	\N	132
6772	3761	\N	133
6772	3762	Služba je poskytována dle potřeb klientů na území města Česká Kamenice.	134
6772	3766	\N	135
6770	3758	\N	136
6770	3764	jedná se o rodiny, ve kterých se narodily současně 3 nebo více dětí, a to do 4 let věku těchto dětí	137
6770	3765	\N	138
6770	3752	\N	139
6768	3751	sociální služba je poskytována na úžemí města Litoměřice a jeho spádových obcí, města Sokolova a jeho spádových obcí a města Cheb a jeho spádových obcí.	140
6768	3765	sociální služba je poskytována na úžemí města Litoměřice a jeho spádových obcí, města Sokolova a jeho spádových obcí a města Cheb a jeho spádových obcí.	141
6761	3764	terénní forma služby je poskytována na území města Tanvald a Smržovka	142
6760	3747	Terénní služba poskytována dle potřeb uživatelů  na území města Chomutova  a Jirkova.	143
6760	3750	Terénní služba poskytována dle potřeb uživatelů  na území města Chomutova  a Jirkova.	144
6760	3760	Terénní služba poskytována dle potřeb uživatelů  na území města Chomutova  a Jirkova.	145
6760	3761	Terénní služba poskytována dle potřeb uživatelů  na území města Chomutova  a Jirkova.	146
6760	3762	Terénní služba poskytována dle potřeb uživatelů  na území města Chomutova  a Jirkova.	147
6760	3766	Terénní služba poskytována dle potřeb uživatelů  na území města Chomutova  a Jirkova.	148
6587	3765	\N	149
6585	3760	Služba je poskytována dle potřeb klientů na území hlavního města Prahy.	150
6585	3747	Služba je poskytována dle potřeb klientů na území hlavního města Prahy.	151
6575	3764	\N	152
6574	3752	\N	153
6574	3754	\N	154
6574	3756	\N	155
6574	3758	\N	156
6574	3765	\N	157
6573	3752	\N	158
6573	3754	\N	159
6573	3755	\N	160
6573	3756	\N	161
6573	3758	\N	162
6573	3764	\N	163
6573	3765	\N	164
6572	3742	Terénní forma služby je poskytována na území města Cheb.	165
6532	3742	Cílovou skupinou jsou děti a mladí lidé s duševním onemocněním a děti a mladí lidé s rizikem rozvoje duševního onemocnění a jejich rodiny - vyjma dětí s poruchou autistického spektra a mentálního postižení.	166
6532	3751	Cílovou skupinou jsou děti a mladí lidé s duševním onemocněním a děti a mladí lidé s rizikem rozvoje duševního onemocnění a jejich rodiny - vyjma dětí s poruchou autistického spektra a mentálního postižení.	167
6532	3764	Cílovou skupinou jsou děti a mladí lidé s duševním onemocněním a děti a mladí lidé s rizikem rozvoje duševního onemocnění a jejich rodiny - vyjma dětí s poruchou autistického spektra a mentálního postižení.	168
6522	3746	\N	169
6522	3760	\N	170
6518	3752	Terénní služba je poskytována na území měst a obcí Podbořany,  Nepomyšl, Krásný Dvůr, Lubenec, Vroutek, Blšany, Očihov, Podbořanský Rohozec, Blatno, Petrohrad a Kryry, včetně \nmístních částí.                          \n.	171
6518	3758	Terénní služba je poskytována na území měst a obcí Podbořany,  Nepomyšl, Krásný Dvůr, Lubenec, Vroutek, Blšany, Očihov, Podbořanský Rohozec, Blatno, Petrohrad a Kryry, včetně \nmístních částí.	172
6518	3764	Terénní služba je poskytována na území měst a obcí Podbořany,  Nepomyšl, Krásný Dvůr, Lubenec, Vroutek, Blšany, Očihov, Podbořanský Rohozec, Blatno, Petrohrad a Kryry, včetně \nmístních částí.	173
6518	3765	Terénní služba je poskytována na území měst a obcí Podbořany,  Nepomyšl, Krásný Dvůr, Lubenec, Vroutek, Blšany, Očihov, Podbořanský Rohozec, Blatno, Petrohrad a Kryry, včetně \nmístních částí.	174
6486	3758	\N	175
6486	3765	\N	176
6486	3752	\N	177
6486	3754	\N	178
6486	3755	\N	179
6486	3751	\N	180
6424	3750	Služba je poskytována zcela či částečně mobilním osobám z důvodu bariérovosti zařízení.	181
6424	3751	Služba je poskytována zcela či částečně mobilním osobám z důvodu bariérovosti zařízení.	182
6380	3761	\N	183
6380	3762	\N	184
6380	3766	\N	185
6380	3743	\N	186
6371	3747	\N	187
6370	3747	\N	188
6361	3754	Služba je určena celé rodině s dítětem s mentálním/pohybovým/kombinovaným postižením.	189
6361	3755	Služba je určena celé rodině s dítětem s mentálním/pohybovým/kombinovaným postižením.	190
6361	3756	Služba je určena celé rodině s dítětem s mentálním/pohybovým/kombinovaným postižením.	191
6361	3764	Služba je určena celé rodině s dítětem s mentálním/pohybovým/kombinovaným postižením, s opožděným psychomotorickým vývojem a s poruchami autistického spektra.	192
6359	3742	Děti a mládež od 6 - 12 let žijící na katastrálním území obce Obrnice.\nPřímá práce je poskytována dle individuálních potřeb uživatele i nad rámec pracovní doby, a to po předchozí domluvě v případě akutní krize.	193
6356	3764	Sociální služba se poskytuje rodinám s dětmi do věku od 3 do 18 let       z obcí Kadaň, Klášterec nad Ohří, Hradec u Kadaně, Pernštejn, Vejprty a jejich spádových obcí.	194
6352	3742	terénní forma služby je poskytována na území města Žatec	195
6345	3751	Sociální služba je poskytována osobám s demencí a dalšími poruchami kognitivních funkcí, deliriem, depresemi, úzkostnými poruchami, pro osoby trpící psychózou.	196
6345	3765	\N	197
6316	3765	osobám,, jejichž fyzický stav stav vyžaduje pomoc druhé osoby	198
6307	3747	\N	199
6303	3751	Služba je poskytována osobám s chronickým duševním   onemocněním, u kterých byla stanovena diagnóza Alzheimerova  nemoc nebo ostatní typy demencí a jejichž situace vyžaduje  pravidelnou pomoc jiné fyzické osoby.	200
6266	3756	\N	201
6266	3758	\N	202
6266	3765	\N	203
6264	3747	Služba je poskytována na území městské části Prahy 6.	204
6261	3760	Terénní forma je poskytována dle potřeb uživatelů na území  města Ústí nad Labem a města Most a dojezdové vzdálenosti 25 km od těchto měst.	205
6145	3754	Terénní služba poskytována dle potřeb uživatelů na území měst Děčín, Ústí nad Labem, Česká Lípa a Česká Kamenice, včetně spádových obcí.	206
6145	3756	Terénní služba poskytována dle potřeb uživatelů na území měst Děčín, Ústí nad Labem, Česká Lípa a Česká Kamenice, včetně spádových obcí..	207
6145	3758	Terénní služba poskytována dle potřeb uživatelů na území měst Děčín, Ústí nad Labem, Česká Lípa a Česká Kamenice, včetně spádových obcí..	208
6144	3754	Terénní služba poskytována dle potřeb uživatelů na území měst Děčín, Ústí nad Labem, Česká Lípa a Česká Kamenice, včetně spádových obcí.	209
6144	3756	Terénní služba poskytována dle potřeb uživatelů na území měst Děčín, Ústí nad Labem, Česká Lípa a Česká Kamenice, včetně spádových obcí.	210
6144	3758	Terénní služba poskytována dle potřeb uživatelů na území měst Děčín, Ústí nad Labem, Česká Lípa a Česká Kamenice.	211
6144	3761	Terénní služba poskytována dle potřeb uživatelů na území měst Děčín, Ústí nad Labem, Česká Lípa a Česká Kamenice, včetně spádových obcí.	212
6116	3751	Sociální služba je poskytována pouze osobám se stařeckou, Alzheimerovou demecí a ostatními typy demece.	213
6084	3765	Senioři ve věku od 65 let, kteří jsou plně nebo částečně mobilní.	214
6083	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako například schizofrenie, bipolární porucha.	215
6080	3755	Osoby s mentálním postižením s poruchami chování vyžadující pozornost, které v důsledku snížené soběstačnosti potřebují pomoc jiné fyzické osoby, a to do stupně středně těžkého mentálního postižení.Zařízení není bezbariérové.	216
6077	3747	\N	217
6077	3761	\N	218
6075	3754	\N	219
6075	3755	\N	220
6073	3760	Služba je poskytována na území města Litvínova	221
6073	3761	Služba je poskytována na území města Litvínova	222
6073	3762	Služba je poskytována na území města Litvínova	223
6053	3752	Terénní pečovatelská služba je poskytována na území města Lovosice a v obcích Třebenice, Libochovice, Chodovlice, Chotiměř, Chotěšov, Čížkovice, Černiv, Dlažkovice, Dubany, Evaň (Horká), Keblice, Klapý, Košťálov, Kocourov, Křesín (Levousy), Lhotka nad Labem, Lipá, Lhota, Lkáň, Lukavec, Malé Žernoseky, Medvědice, Mrsklesy, Podsedice, Poplze, Prackovice nad Labem (Litochovice n. L.), Radostice, Radovesice, Sedlec, Skalice, Slatina, Sutom, Siřejovice, Sulejovice, Třebívlice (Blešno, Dřemčice, Dřevce, Leská, Šepetely, Skalice, Staré), Teplá, Úpohlavy, Vchynice, Vlastislav, Vrbičany, Velemín (Bílinka, Bílý újezd, Boreč, Březno, Dobkovičky, Hrušovka, Kletečná, Milešov, Oparno, Režný Újezd), Děčany (Solany, Semeč, Lukohořany).	224
6053	3754	Terénní pečovatelská služba je poskytována na území města Lovosice a v obcích Třebenice, Libochovice, Chodovlice, Chotiměř, Chotěšov, Čížkovice, Černiv, Dlažkovice, Dubany, Evaň (Horká), Keblice, Klapý, Košťálov, Kocourov, Křesín (Levousy), Lhotka nad Labem, Lipá, Lhota, Lkáň, Lukavec, Malé Žernoseky, Medvědice, Mrsklesy, Podsedice, Poplze, Prackovice nad Labem (Litochovice n. L.), Radostice, Radovesice, Sedlec, Skalice, Slatina, Sutom, Siřejovice, Sulejovice, Třebívlice (Blešno, Dřemčice, Dřevce, Leská, Šepetely, Skalice, Staré), Teplá, Úpohlavy, Vchynice, Vlastislav, Vrbičany, Velemín (Bílinka, Bílý újezd, Boreč, Březno, Dobkovičky, Hrušovka, Kletečná, Milešov, Oparno, Režný Újezd), Děčany (Solany, Semeč, Lukohořany).	225
6053	3756	Terénní pečovatelská služba je poskytována na území města Lovosice a v obcích Třebenice, Libochovice, Chodovlice, Chotiměř, Chotěšov, Čížkovice, Černiv, Dlažkovice, Dubany, Evaň (Horká), Keblice, Klapý, Košťálov, Kocourov, Křesín (Levousy), Lhotka nad Labem, Lipá, Lhota, Lkáň, Lukavec, Malé Žernoseky, Medvědice, Mrsklesy, Podsedice, Poplze, Prackovice nad Labem (Litochovice n. L.), Radostice, Radovesice, Sedlec, Skalice, Slatina, Sutom, Siřejovice, Sulejovice, Třebívlice (Blešno, Dřemčice, Dřevce, Leská, Šepetely, Skalice, Staré), Teplá, Úpohlavy, Vchynice, Vlastislav, Vrbičany, Velemín (Bílinka, Bílý újezd, Boreč, Březno, Dobkovičky, Hrušovka, Kletečná, Milešov, Oparno, Režný Újezd), Děčany (Solany, Semeč, Lukohořany).	226
6053	3758	Terénní pečovatelská služba je poskytována na území města Lovosice a v obcích Třebenice, Libochovice, Chodovlice, Chotiměř, Chotěšov, Čížkovice, Černiv, Dlažkovice, Dubany, Evaň (Horká), Keblice, Klapý, Košťálov, Kocourov, Křesín (Levousy), Lhotka nad Labem, Lipá, Lhota, Lkáň, Lukavec, Malé Žernoseky, Medvědice, Mrsklesy, Podsedice, Poplze, Prackovice nad Labem (Litochovice n. L.), Radostice, Radovesice, Sedlec, Skalice, Slatina, Sutom, Siřejovice, Sulejovice, Třebívlice (Blešno, Dřemčice, Dřevce, Leská, Šepetely, Skalice, Staré), Teplá, Úpohlavy, Vchynice, Vlastislav, Vrbičany, Velemín (Bílinka, Bílý újezd, Boreč, Březno, Dobkovičky, Hrušovka, Kletečná, Milešov, Oparno, Režný Újezd), Děčany (Solany, Semeč, Lukohořany).	227
6053	3764	Pečovatelská služba je poskytována rodinám s dětmi, kde se narodily tři a více dětí současně.\nTerénní pečovatelská služba je poskytována na území města Lovosice a v obcích Třebenice, Libochovice, Chodovlice, Chotiměř, Chotěšov, Čížkovice, Černiv, Dlažkovice, Dubany, Evaň (Horká), Keblice, Klapý, Košťálov, Kocourov, Křesín (Levousy), Lhotka nad Labem, Lipá, Lhota, Lkáň, Lukavec, Malé Žernoseky, Medvědice, Mrsklesy, Podsedice, Poplze, Prackovice nad Labem (Litochovice n. L.), Radostice, Radovesice, Sedlec, Skalice, Slatina, Sutom, Siřejovice, Sulejovice, Třebívlice (Blešno, Dřemčice, Dřevce, Leská, Šepetely, Skalice, Staré), Teplá, Úpohlavy, Vchynice, Vlastislav, Vrbičany, Velemín (Bílinka, Bílý újezd, Boreč, Březno, Dobkovičky, Hrušovka, Kletečná, Milešov, Oparno, Režný Újezd), Děčany (Solany, Semeč, Lukohořany).	228
5318	3764	Služba je poskytována dle potřeb uživatelů v těchto obcích: Dubí, Teplice, Hrob, Košťany, Novosedlice,  Proboštov a Krupka.\nOd 01.01.2024 je terénní služba určena rodinám s ditětem/dětmi nacházející se v obtížné životní situaci vyžadující pomoc a podporu v oblasti duševního zdraví je poskytována na území města Teplice, Bílina a jejich spádových obcí.	352
5303	3758	\N	353
5293	3742	\N	354
5262	3747	zletilé matky s dětmi, zletilí otcové s dětmi, zletilé těhotné ženy	355
6053	3765	Terénní pečovatelská služba je poskytována na území města Lovosice a v obcích Třebenice, Libochovice, Chodovlice, Chotiměř, Chotěšov, Čížkovice, Černiv, Dlažkovice, Dubany, Evaň (Horká), Keblice, Klapý, Košťálov, Kocourov, Křesín (Levousy), Lhotka nad Labem, Lipá, Lhota, Lkáň, Lukavec, Malé Žernoseky, Medvědice, Mrsklesy, Podsedice, Poplze, Prackovice nad Labem (Litochovice n. L.), Radostice, Radovesice, Sedlec, Skalice, Slatina, Sutom, Siřejovice, Sulejovice, Třebívlice (Blešno, Dřemčice, Dřevce, Leská, Šepetely, Skalice, Staré), Teplá, Úpohlavy, Vchynice, Vlastislav, Vrbičany, Velemín (Bílinka, Bílý újezd, Boreč, Březno, Dobkovičky, Hrušovka, Kletečná, Milešov, Oparno, Režný Újezd), Děčany (Solany, Semeč, Lukohořany).	229
6038	3742	\N	230
6027	3744	\N	231
6027	3746	\N	232
6027	3747	\N	233
6027	3749	\N	234
6027	3750	\N	235
6027	3761	Terénní práce s osobami žijícími zejména ve vyloučených lokalitách v Žatci a jeho okolí (viz www.scfcr.cz/mapa/int_CR.html) - centrum Žatce, nové sídliště na jihu Žatce,  Podměstí v Žatci a ulice v Žatci - Lučanská, Třebízského, B. Němcové a Hájkova	236
6027	3766	\N	237
5938	3751	osoby s duševním onemocněním převážně z okruhu psychóz, jako jsou například schizofrenie, bipolární porucha a hraniční stavy.	238
5937	3751	jedná se o osoby s duševním onemocněním z okruhu psychóz, jako například schizofrenie, bipolární porucha a hraniční stavy.	239
5935	3751	jedná se o osoby s duševním onemocněním z okruhu psychóz, jako jjsou například schizofrenie, bipolární porucha a hraniční stavy.	240
5934	3751	jedná se o osoby s duševním onemocněním z okruhu psychóz, jako např. schizofrenie, bipolární porucha, hraniční stavy a těžké depresivní poruchy.	241
5917	3752	\N	242
5917	3758	\N	243
5917	3765	\N	244
5904	3751	Osoby postižené Alzheimerovou chorobou a jinými druhy stařecké demence.\nTerénní služba poskytovaná na území obcí Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov, Jiříkov.	245
5904	3752	Terénní služba poskytovaná na území obcí Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov, Jiříkov.	246
5904	3753	Osoby s postižením po úrazu, nemoci.\nTerénní služba poskytovaná na území obcí Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov, Jiříkov.	247
5904	3754	Terénní služba poskytovaná na území obcí Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov, Jiříkov.	248
5904	3755	Terénní služba poskytovaná na území obcí Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov, Jiříkov.	249
5904	3756	Terénní služba poskytovaná na území obcí Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov, Jiříkov.	250
5904	3758	Terénní služba poskytovaná na území obcí Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov, Jiříkov.	251
5904	3765	Terénní služba poskytovaná na území obcí Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov, Jiříkov.	252
5903	3760	\N	253
5901	3751	psychické duševní onemocnění z okruhu psychóz např. schizofrenie, bipolární porucha.	254
5899	3754	Služba není určena pro osoby imobilní z důvodu bariérovosti objektu.	255
5899	3755	Služba není určena pro osoby imobilní z důvodu bariérovosti objektu.	256
5892	3754	Zařízení není bezbariérové.	257
5892	3755	Zařízení není bezbariérové.	258
5825	3765	\N	259
5787	3747	Sociální služba je poskytována rodinám s nezaopatřenými dětmi do 26 let věku. Sociální služba není poskytována imobilním osobám.	260
5775	3742	\N	261
5774	3761	Osoby žijící v sociálně vyloučené lokalitě Boletice nad Labem ohrožené sociální exkluzí.	262
5774	3766	\N	263
5764	3760	terénní forma sociální služby bude poskytována na území města Podbořany a jeho spádových obcí	264
5755	3751	Jedná se o osoby s poruchami osobnosti, s organickou duševní poruchou, s duální diagnózou, poruchami nálad a neurózami.\nTerénní forma poskytována dle potřeb klietnů na území okresu Chomutov, Louny a spádových obcí.	265
5755	3750	\N	266
5754	3753	osoby s poruchou autistického spektra	267
5754	3754	\N	268
5754	3755	\N	269
5753	3764	Terénní služba poskytována dle potřeb uživatelů na území města Chomutova a Jirkova.	270
5745	3747	\N	271
5744	3747	\N	272
5712	3752	terénní služba je poskytována dle potřeb klientů na území \n                                        měst Chomutov a Jirkov, dále ve vybraných obcích Kalek, \n                                        Jindřichova Ves, Křimov, Načetín, Libědice, Málkov, Místo, \n                                        Nezabylice, Otvice, Pesvice, Spořice, Strupčice, Údlice, \n                                        Všestudy, Vrskmaň, Vysoká Pec, Výsluní, Hrušovany, \n                                        Droužkovice, Březno, Černovice, Zelená, Vysoká Hora \n                                        sv. Šebestiána, Blatno, Boleboř, Hořenec, Přečaply, Škrle, \n                                        Nebovazy, Srážky, Krásná Lípa, Březenec, Hrádečná, Vinařice, \n                                        Červený Hrádek a Zaječice.	273
4703	3751	Služba je poskytována na území města Česká Kamenice, Děčína, Ústí nad Labem.	449
5712	3758	terénní služba je poskytována dle potřeb klientů na území \n                                        měst Chomutov a Jirkov, dále ve vybraných obcích Kalek, \n                                        Jindřichova Ves, Křimov, Načetín, Libědice, Málkov, Místo, \n                                        Nezabylice, Otvice, Pesvice, Spořice, Strupčice, Údlice, \n                                        Všestudy, Vrskmaň, Vysoká Pec, Výsluní, Hrušovany, \n                                        Droužkovice, Březno, Černovice, Zelená, Vysoká Hora \n                                        sv. Šebestiána, Blatno, Boleboř, Hořenec, Přečaply, Škrle, \n                                        Nebovazy, Srážky, Krásná Lípa, Březenec, Hrádečná, Vinařice, \n                                        Červený Hrádek a Zaječice.	274
5712	3765	terénní služba je poskytována dle potřeb klientů na území \n                                        měst Chomutov a Jirkov, dále ve vybraných obcích Kalek, \n                                        Jindřichova Ves, Křimov, Načetín, Libědice, Málkov, Místo, \n                                        Nezabylice, Otvice, Pesvice, Spořice, Strupčice, Údlice, \n                                        Všestudy, Vrskmaň, Vysoká Pec, Výsluní, Hrušovany, \n                                        Droužkovice, Březno, Černovice, Zelená, Vysoká Hora \n                                        sv. Šebestiána, Blatno, Boleboř, Hořenec, Přečaply, Škrle, \n                                        Nebovazy, Srážky, Krásná Lípa, Březenec, Hrádečná, Vinařice, \n                                        Červený Hrádek a Zaječice.	275
5712	3764	\N	276
5708	3750	\N	277
5708	3760	Osobami v krizi se s ohledem na adiktologické služby rozumí rodinní příslušníci nebo osoby blízké osobám závislým.	278
5707	3742	\N	279
5707	3750	\N	280
5707	3761	\N	281
5707	3762	Služba je poskytována na území města Postoloprty (včetně částí: Březno, Skupice a Rvenice) a obcí Lišany, Výškov a Bitozeves.	282
5707	3766	\N	283
5697	3748	\N	284
5697	3751	\N	285
5697	3754	\N	286
5697	3755	\N	287
5697	3756	\N	288
5697	3758	\N	289
5697	3760	\N	290
5697	3764	\N	291
5694	3747	Služba je poskytována na území města Duchcova a v sociálně vyloučených lokalitách Gizela a Viktorina.	292
5694	3760	Služba je poskytována na území města Duchcova a v sociálně vyloučených lokalitách Gizela a Viktorina.	293
5694	3761	Služba je poskytována na území města Duchcova a v sociálně vyloučených lokalitách Gizela a Viktorina.	294
5694	3762	Služba je poskytována na území města Duchcova a v sociálně vyloučených lokalitách Gizela a Viktorina.	295
5676	3742	SluÅ¾ba je poskytovÃ¡na dÄtem a mlÃ¡deÅ¾i z Mostu a jeho spÃ¡dovÃ½ch obcÃ­.	296
5661	3751	SluÅ¾ba je poskytovÃ¡na osobÃ¡m trpÃ­cÃ­m Alzheimerovou demencÃ­ a staÅeckou demencÃ­.	297
5643	3742	SluÅ¾ba je poskytovÃ¡na osobÃ¡m od 11 do 26 let.	298
5635	3747	ZaÅÃ­zenÃ­ nenÃ­ bezbariÃ©rovÃ©.	299
5591	3764	Služba rodinám s nezaopatřenými dětmi do 26 let. Terénní forma je poskytována na území města Varnsdorf.	300
5590	3742	Terénní forma služby je poskytována na území obcí Radonice a Mašťov.	301
5568	3751	\N	302
5568	3752	\N	303
5568	3754	\N	304
5568	3755	\N	305
5568	3756	\N	306
5568	3757	\N	307
5568	3758	\N	308
5568	3759	\N	309
5552	3742	\N	310
5544	3752	\N	311
5544	3754	\N	312
5544	3755	\N	313
5544	3756	\N	314
5544	3758	\N	315
5543	3754	\N	316
5543	3755	\N	317
5542	3762	Terénní forma služby je poskytována ve vazebních věznicích, věznicích a ústavech pro výkon zabezpečovací detence pro muže a dále dle potřeb těchto osob na území celé ČR.	318
5542	3763	Terénní forma služby je poskytována ve vazebních věznicích, věznicích a ústavech pro výkon zabezpečovací detence pro muže a dále dle potřeb těchto osob na území celé ČR.	319
5539	3751	\N	320
5539	3758	\N	321
5524	3754	Služba není poskytována imobilním osobám z důvodu bariérovosti budovy.	322
5524	3755	\N	323
5437	3754	Sociální služba je poskytována osobám s různým stupněm mentálního postižení, osobám s mentálním postižením v kombinaci s tělesným nebo smyslovým postižením a osobám s mchronickým duševním onemocněním a s etylickou demencí od 19ti let věku.	324
5437	3755	Sociální služba je poskytována osobám s různým stupněm mentálního postižení, osobám s mentálním postižením v kombinaci s tělesným nebo smyslovým postižením a osobám s mchronickým duševním onemocněním a s etylickou demencí od 19ti let věku.	325
5437	3751	Sociální služba je poskytována osobám s různým stupněm mentálního postižení, osobám s mentálním postižením v kombinaci s tělesným nebo smyslovým postižením a osobám s mchronickým duševním onemocněním a s etylickou demencí od 19ti let věku.	326
5436	3750	\N	327
5436	3760	\N	328
5436	3761	\N	329
5436	3762	\N	330
5373	3760	Terénní forma poskytována dle potřeb klientů na území okresu Most.	331
5373	3761	Terénní forma poskytována dle potřeb klientů na území okresu Most.	332
5373	3762	Terénní forma poskytována dle potřeb klientů na území okresu Most.	333
5372	3764	Terénní forma poskytována dle potřeb rodin s dětmi do 18 let na území okresu Most.	334
5365	3765	\N	335
5351	3747	Služba je určena pro muže (10 lůžek) i ženy (2 lůžka). Není určena osobám vyžadujícím bezbariérovost.	336
5340	3762	\N	337
5340	3760	\N	338
5340	3761	\N	339
5339	3747	\N	340
5339	3761	\N	341
5339	3762	\N	342
5339	3760	\N	343
5319	3751	\N	344
5319	3752	\N	345
5319	3754	\N	346
5319	3755	\N	347
5319	3756	\N	348
5319	3757	\N	349
5319	3758	\N	350
5319	3759	\N	351
5258	3751	Sociální služba je poskytována osobám trpícím stařeckou demencí, Alzheimerovou chorobou, vaskulární demencí, demencí s Lewyho tělísky, frontotemporální demencí, Parkinsonovou demencí a smíšenou demencí, kteří pro svůj věk a zdravotní stav mají omezené schopnosti vést samostatný život ve svém domově, potřebují pravidelnou pomoc a zároveň péči o ně nelze zajistit dostupnými terénními či ambulantními službami nebo za pomoci rodiny či blízkých osob.	356
5179	3754	Sociální služba je poskytována osobám s různým stupněm mentálního postižení a osobám s mentálním postižením v kombinaci s tělesným nebo smyslovým postižením a osobám s duševním onemocněním od 18 do 64 let věku.	357
5179	3755	\N	358
5179	3751	\N	359
5178	3764	\N	360
5178	11079	\N	361
5119	3764	\N	362
5118	3747	\N	363
5117	3764	Terénní forma je poskytována dle potřeb uživatelů na území města Ústí nad Labem, včetně spádových obcí.	364
5093	3758	\N	365
5093	3765	\N	366
5089	3742	Terénní forma je poskytována na území města Duchcov.	367
5073	3754	\N	368
5073	3755	\N	369
5048	3754	Terénní služba je poskytována v celém Šluknovském výběžku, především v obcích: Jiříkov, Rumburk, Šluknov, Krásná Lípa, Varnsdorf , Dolní Podluží, Dolní Poustevna, Doubice, Horní Podluží, Chřibská, Jiřetín pod Jedlovou, Lipová, Lobendava, Mikulášovice, Rybniště, Staré Křečany, Velký Šenov a Vilémov\nDO 31. 12. 2021	370
5048	3755	Terénní služba je poskytována v celém Šluknovském výběžku, především v obcích: Jiříkov, Rumburk, Šluknov, Krásná Lípa, Varnsdorf , Dolní Podluží, Dolní Poustevna, Doubice, Horní Podluží, Chřibská, Jiřetín pod Jedlovou, Lipová, Lobendava, Mikulášovice, Rybniště, Staré Křečany, Velký Šenov a Vilémov.\nDO 31. 12. 2021	371
5048	3756	Terénní služba je poskytována v celém Šluknovském výběžku, především v obcích: Jiříkov, Rumburk, Šluknov, Krásná Lípa, Varnsdorf , Dolní Podluží, Dolní Poustevna, Doubice, Horní Podluží, Chřibská, Jiřetín pod Jedlovou, Lipová, Lobendava, Mikulášovice, Rybniště, Staré Křečany, Velký Šenov a Vilémov.\nDO 31. 12. 2021	372
5048	3758	Do 31. 12. 2021: Terénní služba je poskytována v celém Šluknovském výběžku, především v obcích: Jiříkov, Rumburk, Šluknov, Krásná Lípa, Varnsdorf , Dolní Podluží, Dolní Poustevna, Doubice, Horní Podluží, Chřibská, Jiřetín pod Jedlovou, Lipová, Lobendava, Mikulášovice, Rybniště, Staré Křečany, Velký Šenov a Vilémov.\nOd 01. 01. 2022: Terénní služba je poskytována ve východní části Šluknovského výběžku, především v obcích a městech: Jiříkov, Rumburk, Staré Křečany, Šluknov, Krásná Lípa a Varnsdorf.	373
5048	3765	Do 31. 12. 2021: Terénní služba je poskytována v celém Šluknovském výběžku, především v obcích: Jiříkov, Rumburk, Šluknov, Krásná Lípa, Varnsdorf , Dolní Podluží, Dolní Poustevna, Doubice, Horní Podluží, Chřibská, Jiřetín pod Jedlovou, Lipová, Lobendava, Mikulášovice, Rybniště, Staré Křečany, Velký Šenov a Vilémov.\n\nOd 01. 01. 2022: Terénní služba je poskytována ve východní části Šluknovského výběžku, především v obcích a městech: Jiříkov, Rumburk, Staré Křečany, Šluknov, Krásná Lípa a Varnsdorf.	374
5048	3752	OD 01.01.2022\nTerénní služba je poskytována ve východní části Šluknovského výběžku, především v obcích a městech: Jiříkov, Rumburk, Staré Křečany, Šluknov, Krásná Lípa a Varnsdorf.	375
5047	3747	\N	376
5043	3755	\N	377
5043	3756	\N	378
5025	3751	\N	379
5025	3754	\N	380
5025	3755	\N	381
5025	3756	\N	382
5024	3751	\N	383
5024	3754	\N	384
5024	3755	\N	385
5022	3754	Zařízení není vhodné pro osoby imobilní, nevidomé a neslyšící.	386
5022	3755	Zařízení není vhodné pro osoby imobilní, nevidomé a neslyšící.	387
4961	3761	\N	388
4961	3764	\N	389
4961	3766	\N	390
4956	3754	Služba je poskytoávna dle potřeb uživatelů na území města Rumburk a spádových obcí a na území města Šluknov a spádových obcí.	391
4956	3755	Služba je poskytoávna dle potřeb uživatelů na území města Rumburk a spádových obcí a na území města Šluknov a spádových obcí.	392
4956	3758	Služba je poskytoávna dle potřeb uživatelů na území města Rumburk a spádových obcí a na území města Šluknov a spádových obcí.	393
4956	3765	Služba je poskytoávna dle potřeb uživatelů na území města Rumburk a spádových obcí a na území města Šluknov a spádových obcí.	394
4956	3752	Služba je poskytoávna dle potřeb uživatelů na území města Rumburk a spádových obcí a na území města Šluknov a spádových obcí.	395
4955	3754	Zařízení není bezbariérové.	396
4955	3755	Zařízení není bezbariérové.	397
4954	3754	\N	398
4954	3755	\N	399
4953	3764	\N	400
4918	3742	\N	401
4918	3761	nebo osoby sociálním vyloučením ohrožené	402
4908	3742	Terénní forma služby je poskytována na území města Ostrov.	403
4890	3742	\N	404
4890	3761	dále osoby sociálním vyloučením ohrožené	405
4890	3762	\N	406
4884	3747	Služba je poskytována na území města Jirkov a Chomutov	407
4884	3760	Služba je poskytována na území města Jirkov a Chomutov	408
4884	3761	Služba je poskytována na území města Jirkov a Chomutov	409
4884	3762	Služba je poskytována na území města Jirkov a Chomutov	410
4884	3766	Služba je poskytována na území města Jirkov a Chomutov	411
4883	3743	Terénní služba poskytovaná dle potřeb uživatelů v obcích Abertamy, Albeřice, Bochov, Bražec, Březová, Dalovice, Hájek, Horní Blatná, Bohatice, Horní Slavkov, Hradiště, Hroznětín, Cheb, Chodov, Chyše, Jáchymov, Karlovy Vary, Kosmová, Kozlov, Lažany, Merklín, Nejdek, Nové Sedlo, Ostrov, Otovice, Radošov, Sadov, Sedlec, Stará Role, Stráž nad Ohří, Štědrá, Tašovice, Toužim, Teplá, Údrč, Valeč, Vrbice, Verušičky, Žlutice.	412
4703	3753	Služba  je poskytována pouze osobám s poruchou autistického spektra.\nSlužba je poskytována na území města Česká Kamenice, Děčína, Ústí nad Labem.	450
4702	3747	\N	451
4701	3747	\N	452
4701	3760	\N	453
4701	3762	\N	454
4883	3744	Terénní služba poskytovaná dle potřeb uživatelů v obcích Abertamy, Albeřice, Bochov, Bražec, Březová, Dalovice, Hájek, Horní Blatná, Bohatice, Horní Slavkov, Hradiště, Hroznětín, Cheb, Chodov, Chyše, Jáchymov, Karlovy Vary, Kosmová, Kozlov, Lažany, Merklín, Nejdek, Nové Sedlo, Ostrov, Otovice, Radošov, Sadov, Sedlec, Stará Role, Stráž nad Ohří, Štědrá, Tašovice, Toužim, Teplá, Údrč, Valeč, Vrbice, Verušičky, Žlutice.	413
4883	3747	Terénní služba poskytovaná dle potřeb uživatelů v obcích Abertamy, Albeřice, Bochov, Bražec, Březová, Dalovice, Hájek, Horní Blatná, Bohatice, Horní Slavkov, Hradiště, Hroznětín, Cheb, Chodov, Chyše, Jáchymov, Karlovy Vary, Kosmová, Kozlov, Lažany, Merklín, Nejdek, Nové Sedlo, Ostrov, Otovice, Radošov, Sadov, Sedlec, Stará Role, Stráž nad Ohří, Štědrá, Tašovice, Toužim, Teplá, Údrč, Valeč, Vrbice, Verušičky, Žlutice.	414
4883	3748	Terénní služba poskytovaná dle potřeb uživatelů v obcích Abertamy, Albeřice, Bochov, Bražec, Březová, Dalovice, Hájek, Horní Blatná, Bohatice, Horní Slavkov, Hradiště, Hroznětín, Cheb, Chodov, Chyše, Jáchymov, Karlovy Vary, Kosmová, Kozlov, Lažany, Merklín, Nejdek, Nové Sedlo, Ostrov, Otovice, Radošov, Sadov, Sedlec, Stará Role, Stráž nad Ohří, Štědrá, Tašovice, Toužim, Teplá, Údrč, Valeč, Vrbice, Verušičky, Žlutice.	415
4883	3760	Terénní služba poskytovaná dle potřeb uživatelů v obcích Abertamy, Albeřice, Bochov, Bražec, Březová, Dalovice, Hájek, Horní Blatná, Bohatice, Horní Slavkov, Hradiště, Hroznětín, Cheb, Chodov, Chyše, Jáchymov, Karlovy Vary, Kosmová, Kozlov, Lažany, Merklín, Nejdek, Nové Sedlo, Ostrov, Otovice, Radošov, Sadov, Sedlec, Stará Role, Stráž nad Ohří, Štědrá, Tašovice, Toužim, Teplá, Údrč, Valeč, Vrbice, Verušičky, Žlutice.	416
4883	3761	Terénní služba poskytovaná dle potřeb uživatelů v obcích Abertamy, Albeřice, Bochov, Bražec, Březová, Dalovice, Hájek, Horní Blatná, Bohatice, Horní Slavkov, Hradiště, Hroznětín, Cheb, Chodov, Chyše, Jáchymov, Karlovy Vary, Kosmová, Kozlov, Lažany, Merklín, Nejdek, Nové Sedlo, Ostrov, Otovice, Radošov, Sadov, Sedlec, Stará Role, Stráž nad Ohří, Štědrá, Tašovice, Toužim, Teplá, Údrč, Valeč, Vrbice, Verušičky, Žlutice.	417
4883	3762	Terénní služba poskytovaná dle potřeb uživatelů v obcích Abertamy, Albeřice, Bochov, Bražec, Březová, Dalovice, Hájek, Horní Blatná, Bohatice, Horní Slavkov, Hradiště, Hroznětín, Cheb, Chodov, Chyše, Jáchymov, Karlovy Vary, Kosmová, Kozlov, Lažany, Merklín, Nejdek, Nové Sedlo, Ostrov, Otovice, Radošov, Sadov, Sedlec, Stará Role, Stráž nad Ohří, Štědrá, Tašovice, Toužim, Teplá, Údrč, Valeč, Vrbice, Verušičky, Žlutice.	418
4883	3766	Terénní služba poskytovaná dle potřeb uživatelů v obcích Abertamy, Albeřice, Bochov, Bražec, Březová, Dalovice, Hájek, Horní Blatná, Bohatice, Horní Slavkov, Hradiště, Hroznětín, Cheb, Chodov, Chyše, Jáchymov, Karlovy Vary, Kosmová, Kozlov, Lažany, Merklín, Nejdek, Nové Sedlo, Ostrov, Otovice, Radošov, Sadov, Sedlec, Stará Role, Stráž nad Ohří, Štědrá, Tašovice, Toužim, Teplá, Údrč, Valeč, Vrbice, Verušičky, Žlutice.	419
4882	3754	Služba je poskytována osobám od 27 do 64 let věku, závislým na pomoci jiné fyzické osoby. Věková hranice se netýká stávajících uživatelů.Do zařízení nejsou v současné době přijímáni noví klenti, a to z důvodu plánovaných oprav. Uvedené omezení se netýká stávajících klientů.	420
4882	3755	Služba je poskytována osobám od 27 do 64 let věku, závislým na pomoci jiné fyzické osoby. Věková hranice se netýká stávajících uživatelů.\nDo zařízení nejsou v současné době přijímáni noví klenti, a to z důvodu plánovaných oprav. Uvedené omezení se netýká stávajících klientů.	421
4881	3750	Služba je poskytována osobám ohroženým závislostí na návykových látkách a osobám ohroženým patologickým hráčstvím, jejich rodinným příslušníkům a blízkým.	422
4858	3751	Služba je poskytována osobám s chronickým duševním onemocněním, u kterých byla stanovena diagnóza stařecká, Alzheimerova nebo ostatní typy demencí (75 lůžek) – do 31.12.2025.\n\nSlužba je s účinností od 01. 01. 2020 poskytována osobám, které trpí poruchami kognitivních funkcí a opouštějí psychiatrickou nemocnici/léčebnu prostřednictvím CDZ a potřebují nepřetržitou pomoc druhé osoby (2 lůžka) – do 31.12.2025.\n\nSlužba je poskytována osobám s chronickým duševním onemocněním, u kterých byla stanovena diagnóza stařecká, Alzheimerova nebo ostatní typy demencí. (od 01.01.2026)	423
4857	3761	Osoby žijící v sociálně vyloučených lokalitách v Ústí nad Labem (s důrazem na sociálně vyloučené lokality Krásné Březno, Neštěmice - Mojžíř a Střekov.	424
4857	3766	Osoby žijící v sociálně vyloučených lokalitách v Ústí nad Labem (s důrazem na sociálně vyloučené lokality Krásné Březno, Neštěmice - Mojžíř a Střekov.	425
4855	3764	Cílovou skupinou je rodina žijící žijí v sociálně vyloučených lokalitách, sociálně vyloučená nebo sociálním vyloučením ohrožená. Vpřípadě dospělých se jedná o osoby, které mají v péči alespoň jedno nezaopatřené dítě. Terénní forma je poskytována na území měst Krupka a Teplice, včetně jejich spádových obcí.	426
4853	3764	Cílovou skupinou jsou rodiny s nezaopatřenými dětmi z Loun a Postoloprt, včetně jejich spádových obcí, které žijí v sociálně vyloučených lokalitách, jsou sociálně vyloučené nebo sociálním vyloučením ohrožené.	427
4851	3750	\N	428
4850	3755	\N	429
4842	3751	Osoby s Alzheimerovou nemocí nebo jiným typem demence.	430
4840	3751	\N	431
4840	3755	\N	432
4840	3758	\N	433
4838	3764	od 18 let (mladší děti součástí rodiny)\n\nTerénní forma služby je poskytována uživatelům žijícím na území správního obvodu obce s rozšířenou působností Chomutov.	434
4837	3742	Terénní forma služby je poskytována na území města Chomutov.	435
4830	3764	Služba je poskytována na území města Šluknov a přilehlých obcí (Velký Šenov, Lipová, Dolní Poustevna, Vilémov, Mikulášovice, Lobendava).	436
4810	3747	\N	437
4809	3764	\N	438
4808	3742	\N	439
4783	3751	Zařízení není bezbariérové	440
4783	3754	Zařízení není bezbariérové	441
4783	3755	Zařízení není bezbariérové	442
4783	3758	Zařízení není bezbariérové	443
4781	3742	Terénní forma služby je poskytována dle potřeb uživatelů na území města Trmice.	444
4716	3742	\N	445
4704	3751	\N	446
4704	3753	služba je určena pouze osobám s poruchou autistického spektra.	447
4703	3750	Služba je poskytována na území města Česká Kamenice, Děčína, Ústí nad Labem.	448
3562	3755	Zařízení není bezbariérové.	769
4693	3755	Služba je poskytována od 18 do 64 let věku osobám do stupně středního mentálního postižení.	455
4692	3752	Pečovatelská služba je poskytována na celém území správního obvodu obce s rozšířenou působností Most.	456
4692	3758	Pečovatelská služba je poskytována na celém území správního obvodu obce s rozšířenou působností Most.	457
4692	3765	Pečovatelská služba je poskytována na celém území správního obvodu obce s rozšířenou působností Most.	458
4692	3764	Pečovatelská služba je poskytována na celém území správního obvodu obce s rozšířenou působností Most.	459
4688	3751	Osoby, které mají sníženou soběstačnost z důvodu stařecké demence, Alzheimerovy demence a jiných typů demence, které jsou plně odkázáni na pomoc druhé osoby. Dále i osoby částečně či plně zbaveni způsobilosti k právním úkonům.	460
4687	3751	Terénní služba je poskytována dle potřeb uživatelů na území města Šluknov.	461
4687	3752	Terénní služba je poskytována dle potřeb uživatelů na území města Šluknov.	462
4687	3758	Terénní služba je poskytována dle potřeb uživatelů na území města Šluknov.	463
4687	3764	Terénní služba je poskytována dle potřeb uživatelů na území města Šluknov.	464
4687	3765	Terénní služba je poskytována dle potřeb uživatelů na území města Šluknov.	465
4681	3765	Služba je poskytována seniorům od 60 let v nepříznivé sociální situaci, kteří žijí se svými rodinami, ale ty jsou soustavnou péčí o ně vyčerpány a potřebují určitou dobu k odpočinku, regeneraci sil či k vyřešení různých záležitostí nebo seniorům, kteří žijí osaměle a po přechodnou dobu potřebují péči jiné osoby.	466
4680	3751	\N	467
4678	3750	Terénní forma služby je poskytována na území města Chomutov a jeho spádových obcí.	468
4673	3760	\N	469
4673	3761	\N	470
4673	3762	\N	471
4665	3764	TsluÅ¾ba je poskytovÃ¡na ve mÄstech Å½atec, PodboÅany a okolnÃ­ch obcÃ­ch v dojezdovÃ© vzdÃ¡lenosti do 15 km od tÄchto mÄst.	472
4649	3747	terÃ©nnÃ­ forma je poskytovÃ¡na na ÃºzemÃ­ mÄsta Mostu	473
4627	3752	\N	474
4627	3755	\N	475
4627	3756	\N	476
4627	3758	\N	477
4627	3753	osoby s poruchou autistickÃ©ho spektra od 17 let vÄku	478
4624	3754	\N	479
4624	3755	\N	480
4624	3758	\N	481
4615	3751	\N	482
4597	3752	\N	483
4597	3758	\N	484
4597	3765	\N	485
4597	3755	\N	486
4594	3754	\N	487
4594	3755	\N	488
4587	3747	\N	489
4587	3744	\N	490
4574	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy.	491
4573	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy. Zařízení není bezbariérové.	492
4572	3747	\N	493
4572	3760	\N	494
4572	3762	\N	495
4555	3742	Služba je určena obyvatelům z obce Tanvald, Velkých Hamrů, Dolní Smržovky a Železného Brodu.	496
4554	3742	služba je poskytována v obci Náhlov	497
4553	3742	terénní forma probíhá ve městě Zákupy	498
4541	3760	Terénní služba je poskytována dle potřeb uživatelů žijících na katastrálním území obcí Obrnice, Patokryje a Želenice.\nPřímá práce je poskytována dle individuálních potřeb uživatele i nad rámec pracovní doby, a to po předchozí domluvě nebo v případě akutní krize.	499
4541	3761	Terénní služba je poskytována dle potřeb uživatelů žijících na katastrálním území obcí Obrnice, Patokryje a Želenice.\nPřímá práce je poskytována dle individuálních potřeb uživatele i nad rámec pracovní doby, a to po předchozí domluvě nebo v případě akutní krize.	500
4541	3762	Terénní služba je poskytována dle potřeb uživatelů žijících na katastrálním území obcí Obrnice, Patokryje a Želenice.\nPřímá práce je poskytována dle individuálních potřeb uživatele i nad rámec pracovní doby, a to po předchozí domluvě nebo v případě akutní krize.	501
4540	3764	Obyvatelům, žijícím na katastrálním území obce Obrnice, rodinám s dítětem/dětmi (včetně prarodičů).\nPřímá práce je poskytována dle individuálních potřeb uživatele i nad rámec pracovní doby, a to po předchozí domluvě nebo v případě akutní krize.	502
4539	3742	Sociální služba určena pro děti a mládež od 13 - 26 let , ohroženým společensky nežádoucími jevy, žijící na katastrálním území obcí Obrnice a Patokryje.\nPřímá práce je poskytována dle individuálních potřeb uživatele i nad rámec pracovní doby, a to po předchozí domluvě nebo v případě akutní krize.	503
4529	3751	\N	504
4529	3754	\N	505
4529	3755	\N	506
4529	3758	\N	507
4527	3747	\N	508
4527	3760	\N	509
4527	3761	\N	510
4527	3762	\N	511
4527	3766	\N	512
4515	3742	\N	513
4509	3754	\N	514
4509	3755	\N	515
4504	3754	\N	516
4504	3755	\N	517
4484	3764	Terénní forma je poskytována na území města Duchcov a jeho spádových obcí Háj u Duchcova, Hrob, Jeníkov, Košťany, Lahošť, Mikulov, Moldava, Osek, Zabrušany a přilehlých obcí do 10 km.	518
4482	3760	Služba bude poskytována přednostně pro obyvatele žijící na katastrálním území obcí Obrnice, Patokryje a Želenice.\nPřímá práce je poskytována dle individuálních potřeb uživatele i nad rámec pracovní doby, a to po předchozí domluvě nebo v případě akutní krize.	519
4482	3761	Služba bude poskytována přednostně pro obyvatele žijící na katastrálním území obcí Obrnice, Patokryje a Želenice.\nPřímá práce je poskytována dle individuálních potřeb uživatele i nad rámec pracovní doby, a to po předchozí domluvě nebo v případě akutní krize.	520
4482	3762	Služba bude poskytována přednostně pro obyvatele žijící na katastrálním území obcí Obrnice, Patokryje a Želenice.\nPřímá práce je poskytována dle individuálních potřeb uživatele i nad rámec pracovní doby, a to po předchozí domluvě nebo v případě akutní krize.	521
3561	3754	\N	770
3561	3755	\N	771
4478	3751	Z okruhu osob s chronickým duševním onemocněním je služba poskytována osobám s Alzheimerovou nemocí či jinými druhy demence.	522
4478	3752	\N	523
4478	3756	\N	524
4478	3759	\N	525
4478	3765	\N	526
4478	3753	Služba je určena i osobám s poruchou autistického spektra, pro které jsou z celkové kapacity vyčleněna 2 lůžka (1 lůžko Sutom, 1 lůžko Lovosice)	527
4478	3754	\N	528
4478	3755	\N	529
4475	3760	Služba je určena pouze pro muže.	530
4474	3751	\N	531
4474	3754	Služba není poskytována imobilním klientům, prostory sociálně terapeutické dílny nejsou bezbariérové.	532
4474	3755	Služba není poskytována imobilním klientům, prostory sociálně terapeutické dílny nejsou bezbariérové.	533
4474	3756	Služba není poskytována imobilním klientům, prostory sociálně terapeutické dílny nejsou bezbariérové.	534
4473	3764	\N	535
4470	3742	Terénní forma sociální služby je poskytována na území města Krásná Lípa.	536
4462	3742	Služba je určena dětem a mládeži bez rozdílu pohlaví a etnika, které vyrůstají v nepodnětném nebo nefunkčním prostředí, mají problematické vztahy s rodiči nebo jinými autoritami a vrstevníky, mají problémy ve škole nebo s hledáním zaměstnání, jsou ohroženi sociálně patologickými jevy.	537
4461	3742	terénní forma je poskytována na území města Mostu	538
4456	3756	\N	539
4456	3758	\N	540
4456	3765	\N	541
4455	3754	Službu nelze poskytnout osobám se zrakovým postižením a osobám na vozíku. Objekt není bezbariérový.	542
4455	3755	Službu nelze poskytnout osobám, které potřebují celodenní ošetřovatelskou péči.	543
4449	3754	\N	544
4449	3755	\N	545
4412	3742	\N	546
4406	3751	Sociální služba se poskytuje osobám ve věku od 55 let, které trpí Alzheimerovou, stařeckou a ostatními typy demencí, kteří mají sníženou soběstačnost z důvodu těchto onemocnění a jejichž situace vyžaduje pravidelnou pomoc jiné fyzické osoby.	547
4375	3750	\N	548
4366	3750	\N	549
4366	3751	\N	550
4366	3753	Služba je určena pouze osobám s poruchou autistického spektra.	551
4364	3751	Terénní služba poskytovaná dle potřeb uživatelů na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	552
4364	3754	Terénní služba poskytovaná dle potřeb uživatelů na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	553
4364	3755	Terénní služba poskytovaná dle potřeb uživatelů na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	554
4364	3756	Terénní služba poskytovaná dle potřeb uživatelů na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	555
4364	3758	Terénní služba poskytovaná dle potřeb uživatelů na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	556
4364	3765	Terénní služba poskytovaná dle potřeb uživatelů na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	557
4344	3754	\N	558
4344	3755	\N	559
4330	3742	Terénní forma služby je poskytována v Prunéřově a Hradci u Kadaně.	560
4323	3758	Terénní forma služby poskytována dle potřeb uživatelů na území okresu Most.	561
4301	3751	Terénní forma služby je poskytována na území města Roudnice nad Labem a jeho okolí v dojezdové vzdálenosti do 20 km.	562
4301	3752	Terénní forma služby je poskytována na území města Roudnice nad Labem a jeho okolí v dojezdové vzdálenosti do 20 km.	563
4301	3754	Terénní forma služby je poskytována na území města Roudnice nad Labem a jeho okolí v dojezdové vzdálenosti do 20 km.	564
4301	3755	Terénní forma služby je poskytována na území města Roudnice nad Labem a jeho okolí v dojezdové vzdálenosti do 20 km.	565
4301	3756	Terénní forma služby je poskytována na území města Roudnice nad Labem a jeho okolí v dojezdové vzdálenosti do 20 km.	566
4301	3758	\N	567
4300	3748	\N	568
4298	3748	\N	569
4284	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy. Zařízení není bezbariérové.	570
4282	3751	Sociální služba je poskytována osobám s duševním onemocněním z okruhu psychóz, jako například schizofrenie, bipolární porucha a hraniční stavy. Zařízení není bezbariérové.	571
4265	3764	\N	572
4263	3764	\N	573
4262	3747	\N	574
4262	3761	\N	575
4262	3764	\N	576
4262	3766	\N	577
4238	3751	Služba je určena osobám, které mají sníženou soběstačnost z důvodu chronického duševního onemocnění a osobám se stařeckou, Alzheimerovou a ostatními typy demencí, jejichž situace vyžaduje pomoc jiné fyzické osoby.	578
4236	3751	Služba je určena pro osoby s Alzheimerovou demencí a jinými typy stařeckých demencí (středně těžké, těžké i lehké  s poruchami chování).	579
4235	3747	Sociální služba je poskytována mužům. Sociální služba není poskytována imobilním osobám.	580
4234	3751	Služba je určena pouze mobilním osobám z důvodu bariérovosti budov.\nPředevším pro osoby s kompenzovanou schizofrenií.	581
4234	3755	Služba je určena pouze mobilním osobám z důvodu bariérovosti budov.	582
4234	3758	\N	583
4220	3751	U okruhu osob s chronickým duševním onemocněním  se služba poskytuje osobám trpícím Alzheimerovou chorobou a jinými formami demence.\n\nSociální služba je poskytována na území města Lovosice a jeho spádových obcí a na území města Litoměřice a jeho spádových obcí.	584
4220	3752	Sociální služba je poskytována na území Lovosic a jeho spádových obcí.	585
4220	3754	Sociální služba je poskytována na území Lovosic a jeho spádových obcí.	586
4220	3755	Sociální služba je poskytována na území Lovosic a jeho spádových obcí.	587
4220	3756	Sociální služba je poskytována na území Lovosic a jeho spádových obcí.	588
4220	3757	Sociální služba je poskytována na území Lovosic a jeho spádových obcí.	589
4220	3758	Sociální služba je poskytována na území Lovosic a jeho spádových obcí.	590
4220	3759	Sociální služba je poskytována na území Lovosic a jeho spádových obcí.	591
4220	3765	Sociální služba je poskytována na území Lovosic a jeho spádových obcí.	592
4219	3752	Sociální služba je poskytována na území Nového Boru a jeho spádových obcí a na území České Lípy a jejích spádových obcí.	593
4219	3754	Sociální služba je poskytována na území Nového Boru a jeho spádových obcí a na území České Lípy a jejích spádových obcí.	594
4219	3755	Sociální služba je poskytována na území Nového Boru a jeho spádových obcí a na území České Lípy a jejích spádových obcí.	595
4219	3756	Sociální služba je poskytována na území Nového Boru a jeho spádových obcí a na území České Lípy a jejích spádových obcí.	596
4219	3758	Sociální služba je poskytována na území Nového Boru a jeho spádových obcí a na území České Lípy a jejích spádových obcí.	597
4219	3765	Sociální služba je poskytována na území Nového Boru a jeho spádových obcí a na území České Lípy a jejích spádových obcí.	598
4217	3747	Sociální služba poskytována mužům (10 lůžek) i ženám (2 lůžka).\nBezbariérový přístup ke službě umožňuje přijímat i osoby s omezenou hybností i vozíčkáře schopné sebeobsluhy.	599
4209	3742	\N	600
4205	3754	\N	601
4205	3755	\N	602
4195	3751	Cílovou skupinou jsou osoby starší 45 let, se stařeckou, Alzheimerovou demencí a ostatními typy demencí, které mají sníženou soběstačnost z důvodu těchto onemocnění, jejichž situace vyžaduje pravidelnou pomoc jiné fyzické osoby. Do domova nemohou být přijaty osoby závislé nebo léčící se ze závislosti na návykových látkách a/nebo osoby trpící psychózami.	603
4189	3746	\N	604
4189	3760	\N	605
4189	3761	Terénní forma služby je poskytována dle potřeb klientů na území měst a obcí Šluknovského výběžku, a to: Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov a Jiříkov.	606
4189	3766	\N	607
4188	3764	Terénní služba poskytovaná dle potřeb uživatelů na území obcí Varnsdorf, Horní Podluží, Dolní Podluží, Jiřetín pod Jedlovou, Jiříkov, Chřibská, Rybniště, Rumburk, Krásná Lípa, Doubice, Staré Křečany, Brtníky, Šluknov, Mikulášovice, Dolní Poustevna, Lobendava, Lipová, Vilémov, Velký Šenov.	608
4178	3747	Sociální služba je poskytována mužům. \nSociální služba je poskytována imobilním osobám v maximální kapacitě 4 lůžek na adrese Ludovíta Štúra 2504/4, Most.	609
4172	3751	Cílovou skupinou jsou osoby ve věku nad 50 let, které mají sníženou soběstačnost z důvodu stařecké a Alzheimerovy demence. Zařízení není bezbariérové.	610
4160	3754	\N	611
4160	3755	\N	612
4152	3751	Sociální služba je poskytována osobám s Alzheimerovou demencí, stařeckou demencí, ostatními typy demencí. Služba není poskytována osobám závislým na návykových látkách.Sociální služba není poskytována osobám se schizofrenií.	613
4148	3752	Sociální služba je poskytována na území města Chomutova, Jirkova a jejich spádových obcí.	614
4148	3754	Sociální služba je poskytována na území města Chomutova, Jirkova a jejich spádových obcí.	615
4148	3755	Sociální služba je poskytována na území města Chomutova, Jirkova a jejich spádových obcí.	616
4148	3756	Sociální služba je poskytována na území města Chomutova, Jirkova a jejich spádových obcí.	617
4148	3757	Sociální služba je poskytována na území města Chomutova, Jirkova a jejich spádových obcí.	618
4148	3758	Sociální služba je poskytována na území města Chomutova, Jirkova a jejich spádových obcí.	619
4148	3759	Sociální služba je poskytována na území města Chomutova, Jirkova a jejich spádových obcí.	620
4148	3765	Sociální služba je poskytována na území města Chomutova, Jirkova a jejich spádových obcí.	621
4133	3751	Do 31.12.2025: Služba je určena osobám s Alzheimerovou, stařeckou či jiným typem demence (18lůžek).\nSlužba je určena osobám s neurotickým onemocněním, s organickou poruchou osobnosti, s obsedantně kompulzivní poruchou nebo mánio-depresivní poruchou opouštějící psychiatrickou nemocnici/léčebnu prostřednictvím CDZ a potřebují nepřetržitou pomoc druhé osoby (2 lůžka).\nOd 01.01.2026: Služba je určena osobám s Alzheimerovou chorobou nebo jiným typem demence - tj. Parkinsonova a Huntingtonova choroba a stařecká demence.	622
4110	3754	Služba není z důvodu bariérovosti poskytována osobám imobilním, které používají ke svému pohybu vozík či chodítko. Zařízení dílen není bezbariérové.	623
4110	3755	Služba není z důvodu bariérovosti poskytována osobám imobilním, které používají ke svému pohybu vozík či chodítko. Zařízení dílen není bezbariérové.	624
4110	3756	Služba není z důvodu bariérovosti poskytována osobám imobilním, které používají ke svému pohybu vozík či chodítko. Zařízení dílen není bezbariérové.	625
4109	3754	Terénní sociální rehabilitace bude poskytována na území města Děčína a v dojezdové vzdálenosti do 20 km.	626
4109	3755	Terénní sociální rehabilitace bude poskytována na území města Děčína a v dojezdové vzdálenosti do 20 km.	627
4109	3756	Terénní sociální rehabilitace bude poskytována na území města Děčína a v dojezdové vzdálenosti do 20 km.	628
4105	3765	Služba je vzhledem k technickým možnostem budovy určena pouze pro mobilní a částečně mobilní osoby (netýká se stávajících klientů).	629
4104	3758	Služba je poskytována dle potřeb uživatelů ve věku od 18 let na území měst Litvínov , Meziboří, Lom  a  Horní Jiřetín.\nKonkrétě je poskytována osobám v 1 - 3 stupni invalidity, komunikujícím, mobilním.	630
4104	3760	Služba je poskytována dle potřeb uživatelů ve věku od 18 let na území měst Litvínov , Meziboří, Lom  a  Horní Jiřetín.\nKonkrétně je poskytována osobám dlouhodobě nezaměstnaným, osobám s nízkým stupněm vzdělání.	631
4095	3750	\N	632
4094	3763	Terénní forma je poskytována dle potřeb klientů v zařízeních pro výkon trestu odnětí svobody v Bělušicích, Novém Sedle, Všehrdech, Drahonicích, Stráži pod Ralskem, Ostrově, Kynšperku nad Ohří, Horním Slavkově a ve vazební věznici v Liberci a v Litoměřicích.	633
1405	3765	\N	1123
4091	3752	Služba je určena osobám s Alzheimerovou chorobou a ostatními typy demencí.	634
4064	3750	\N	635
4060	3743	\N	636
4060	3764	\N	637
4060	3742	\N	638
4060	3748	\N	639
4060	3760	\N	640
4060	3762	\N	641
4028	3752	Terénní služba je poskytována ve východní části Šluknovského výběžku, především v obcích a městech: Jiříkov, Rumburk, Staré Křečany, Šluknov, Krásná Lípa a Varnsdorf.	642
4028	3758	Od 01. 01. 2022: Terénní služba je poskytována ve východní části Šluknovského výběžku, především v obcích a městech: Jiříkov, Rumburk, Staré Křečany, Šluknov, Krásná Lípa a Varnsdorf.	643
4028	3764	Od 01. 01. 2022: Od 01. 01. 2022: Terénní služba je poskytována ve východní části Šluknovského výběžku, především v obcích a městech: Jiříkov, Rumburk, Staré Křečany, Šluknov, Krásná Lípa a Varnsdorf.	644
4028	3765	Od 01. 01. 2022: Terénní služba je poskytována ve východní části Šluknovského výběžku, především v obcích a městech: Jiříkov, Rumburk, Staré Křečany, Šluknov, Krásná Lípa a Varnsdorf.	645
4028	3754	OD 01. 01. 2022\nTerénní služba je poskytována ve východní části Šluknovského výběžku, především v obcích a městech: Jiříkov, Rumburk, Staré Křečany, Šluknov, Krásná Lípa a Varnsdorf.	646
4012	3754	Jedná se o osoby s mentálním postižením, v kombinaci se zdravotním postižením, vyjma osob imobilních a s těžkými smyslovými vadami (např. hluchoslepých).	647
4012	3755	\N	648
4004	3747	\N	649
4004	3760	\N	650
4004	3761	\N	651
4004	3762	\N	652
4004	3764	\N	653
3990	3764	Sociální služba je poskytována na území města Litvínov.	654
3989	3747	Sociální služba je poskytována na území města Litvínov.	655
3989	3748	Sociální služba je poskytována na území města Litvínov.	656
3989	3760	Sociální služba je poskytována na území města Litvínov.	657
3989	3761	Sociální služba je poskytována na území města Litvínov.	658
3989	3762	Sociální služba je poskytována na území města Litvínov.	659
3989	3766	Sociální služba je poskytována na území města Litvínov.	660
3969	3761	\N	661
3969	3762	\N	662
3969	3764	\N	663
3969	3766	\N	664
3936	3751	Služba je poskytována osobám s Alzheimerovou chorobou a ostatními typy stařeckých demencí.	665
3916	3742	Terénní forma služby je poskytována dle potřeb uživatelů na území města Trmice.	666
3915	3761	Sociální služba  poskytována dle potřeb uživatelů na území Liberce a všech obcích v jeho rožířené působnosti.	667
3915	3762	Sociální služba  poskytována dle potřeb uživatelů na území Liberce a všech obcích v jeho rožířené působnosti.	668
3905	3754	Služba je poskytována osobám s mentálním nebo kombinovaným postižením, se středně těžkou až těžkou závislostí na pomoci jiné fyzické osoby, mobilním  a částečně imobilním osobám, které z důvodu snížené soběstačnosti nemohou  žít ve svém přirozeném sociálním prostředí.   Zařízení není vhodné pro osoby trvale upoutané na lůžko, nevidomé a neslyšící.	669
3905	3755	Služba je poskytována osobám s mentálním nebo kombinovaným postižením, se středně těžkou až těžkou závislostí na pomoci jiné fyzické osoby, mobilním  a částečně imobilním osobám, které z důvodu snížené soběstačnosti nemohou  žít ve svém přirozeném sociálním prostředí.   Zařízení není vhodné pro osoby trvale upoutané na lůžko, nevidomé a neslyšící.	670
3902	3747	Služba je poskytována na území obcí s rozšířenou působností v katastrálním území obvodu Teplice.	671
3902	3761	Služba je poskytována na území obcí s rozšířenou působností v katastrálním území obvodu Teplice.	672
3892	3751	Sociální služba je poskytována od 18 let věku.\nSociální služba je určena pro osoby s lehkým a středně těžkým mentálním postižením, které jsou schopny základní sebeobsluhy. Sociální služba je poskytována na území města Litoměřice a v přilehlých městech a obcích v dojezdové vzdálenosti do 20 km od města Litoměřice.	673
3892	3755	Sociální služba je poskytována od 18 let věku.\nSociální služba je určena pro osoby s lehkým a středně těžkým mentálním postižením, které jsou schopny základní sebeobsluhy. Sociální služba je poskytována na území města Litoměřice a v přilehlých městech a obcích v dojezdové vzdálenosti do 20 km od města Litoměřice.	674
3892	3758	Sociální služba je poskytována od 18 let věku.\nSociální služba je určena pro osoby s lehkým a středně těžkým mentálním postižením, které jsou schopny základní sebeobsluhy. Sociální služba je poskytována na území města Litoměřice a v přilehlých městech a obcích v dojezdové vzdálenosti do 20 km od města Litoměřice.	675
3880	3764	\N	676
3841	3744	\N	677
3841	3747	\N	678
3841	3764	\N	679
3840	3754	Terénní forma služby je poskytována na území měst Teplice a Krupka a v dojezdové vzdálenosti maximálně  20 km od Teplic a Krupky.	680
3840	3755	Terénní forma služby je poskytována na území měst Teplice a Krupka a v dojezdové vzdálenosti maximálně  20 km od Teplic a Krupky.	681
3840	3756	Terénní forma služby je poskytována na území měst Teplice a Krupka a v dojezdové vzdálenosti maximálně  20 km od Teplic a Krupky.	682
3840	3753	služba je poskytována osobám s jiným zdravotním postižením- poruchou autistického spektra.\n\nTerénní forma služby je poskytována na území měst Teplice a Krupka a v dojezdové vzdálenosti maximálně  20 km od Teplic a Krupky.	683
3839	3764	Sociální služba je poskytována rodinám s dětmi do 18 let věku dětí žijícím na území Roudnice nad Labem a obcích ve spádové oblasti působnosti Sociálního odboru MěÚ Roudnice nad Labem. Je poskytována rodinám, kde je ohrožen správný vývoj dítěte z důvodu nepříznivé sociální situace, rodinám, jejichž děti mají problémy s docházkou a prospěchem ve škole a rodinám, které usilují o svěření dítěte.	684
3838	3751	\N	685
3838	3755	\N	686
3787	3751	Sociální služba je určena osobám s Alzheimerovou, stařeckou a ostatními typy demencí. Služba není poskytována osobám s jinými typy chronického duševního onemocnění a osobám závislým na návykových látkách.	687
936	3765	Služba je poskytována na území města Meziboří.	1266
3784	3749	Terénní forma poskytována na území Jirkova a v přilehlých obcích.	688
3784	3758	Terénní forma poskytována na území Jirkova a v přilehlých obcích.	689
3784	3760	\N	690
3784	3761	Terénní forma poskytována na území Jirkova a v přilehlých obcích.	691
3784	3762	Terénní forma poskytována na území Jirkova a v přilehlých obcích.	692
3784	3765	Terénní forma poskytována na území Jirkova a v přilehlých obcích.	693
3783	3752	Služba je poskytována na území města Děčín a ve spádových obcích.	694
3783	3765	Terénní služba je poskytovaná na území měst Děčín a Jílové.	695
3783	3758	Terénní služba je poskytovaná na území měst Děčín a Jílové.	696
3783	3764	Terénní služba je poskytovaná na území měst Děčín a Jílové.	697
3780	3747	Služba je určena pro muže, ženy, rodiče s dětmi nacházející se v nepříznivé sociální situaci spojené se ztrátou bydlení. Zařízení není bezbariérové.	698
3758	3758	\N	699
3758	3765	\N	700
3757	3752	\N	701
3757	3758	\N	702
3757	3765	\N	703
3751	3742	u ambulantní formy děti a mládež ve věku od 13 do 26 let ohroženým sociálním vyloučením.\n\nu terénní formy děti a mládež ve věku od 6 do  26 let.\n\nTerénní forma služby je poskytována na území města Teplice, Sobědruhy a Proboštov.	704
3746	3742	terénní forma služby je poskytována na území města Chomutov	705
3745	3742	služba je poskytována ve městě Chomutov	706
3744	3747	Terénní forma poskytována na území města Chomutova a Jirkova.	707
3744	3760	Terénní forma poskytována na území města Chomutova a Jirkova.	708
3744	3761	Terénní forma poskytována na území města Chomutova a Jirkova.	709
3744	3762	Terénní forma poskytována na území města Chomutova a Jirkova.	710
3744	3766	Terénní forma poskytována na území města Chomutova a Jirkova	711
3731	3764	\N	712
3731	3744	osoby ohrožené domácím násilím	713
3730	3747	\N	714
3729	3744	\N	715
3729	3747	\N	716
3729	3760	\N	717
3729	3764	\N	718
3728	3754	Služba je přednostně určena občanům hlavního města Prahy.\nObě pracoviště jsou částečně bezbariérová.	719
3728	3755	Služba je přednostně určena občanům hlavního města Prahy.\nObě pracoviště jsou částečně bezbariérová.	720
3728	3756	Služba je přednostně určena občanům hlavního města Prahy.\nObě pracoviště jsou částečně bezbariérová.	721
3725	3742	služba je poskytována na území města Litvínov	722
3710	3760	\N	723
3710	3761	\N	724
3710	3762	\N	725
3693	3764	\N	726
3686	3754	Zařízení je bezbariérové.\nosoby po dokončení povinné školní docházky s lehkým a středně těžkým mentálním a kombinovaným postižením.	727
3686	3755	Zařízení je bezbariérové.\nosoby po dokončení povinné školní docházky s lehkým a středně těžkým mentálním a kombinovaným postižením.	728
3673	3751	\N	729
3673	3754	\N	730
3673	3755	Podpora samostatného bydlení je určena lidem se zdravotním a sociálním znevýhodněním, kteří přicházejí z domovů pro osoby se zdravotním postižením, z dětských domovů, z rodinné péče či z psychiatrických léčeben.	731
3673	3758	\N	732
3638	3752	\N	733
3638	3758	Služba je poskytována na území města Česká Kamenice a ve spádové oblasti.	734
3638	3765	Terénní služba je poskytovaná na území města Česká Kamenice a v obcích v dojezdové vzdálenosti 15 km v Ústeckém kraji.	735
3638	3751	\N	736
3638	3764	\N	737
3622	3754	\N	738
3622	3755	\N	739
3622	3756	\N	740
3622	3757	\N	741
3622	3758	\N	742
3622	3759	\N	743
3622	3765	\N	744
3622	3751	\N	745
3622	3752	\N	746
3620	3764	terénní forma služby je poskytována na území správního obvodu obce s rozšířenou působností Teplice.	747
3602	3744	\N	748
3602	3760	\N	749
3602	3762	\N	750
3602	3764	\N	751
3599	3758	\N	752
3599	3765	\N	753
3584	3751	Služba je poskytována na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	754
3584	3754	Služba je poskytována na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	755
3584	3755	Služba je poskytována na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	756
3584	3756	Služba je poskytována na území obcí Rumburk, Varnsdorf a spádových obcí.	757
3584	3758	Služba je poskytována na území obcí Rumburk, Varnsdorf, Šluknov, Krásná Lípa a jejich spádových obcí.	758
3584	3743	\N	759
3567	3754	\N	760
3567	3755	\N	761
3565	3754	\N	762
3565	3755	\N	763
3564	3754	Služba je poskytována pouze stávajícím uživatelům. Poskytovatel postupně ukončuje poskytování tohoto druhu sociální služby.	764
3564	3755	Služba je poskytována pouze stávajícím uživatelům. Poskytovatel postupně ukončuje poskytování tohoto druhu sociální služby.	765
3563	3754	Cílovou skupinou jsou osoby, které mají sníženou soběstačnost z důvodu mentálního postižení nebo mentálního postižení s přidruženým kombinovaným postižením, jejichž situace vyžaduje pravidelnou pomoc jiné fyzické osoby a jimž není možné zajistit tuto pomoc prostřednictvím rodiny nebo terénních služeb. Poskytovat tuto službu nelze osobám s kontraindikacemi, které jsou vypracovány vnitřní směrnicí.	766
3563	3755	Cílovou skupinou jsou osoby, které mají sníženou soběstačnost z důvodu mentálního postižení nebo mentálního postižení s přidruženým kombinovaným postižením, jejichž situace vyžaduje pravidelnou pomoc jiné fyzické osoby a jimž není možné zajistit tuto pomoc prostřednictvím rodiny nebo terénních služeb. Poskytovat tuto službu nelze osobám s kontraindikacemi, které jsou vypracovány vnitřní směrnicí.	767
3562	3754	Zařízení není bezbariérové.	768
3544	3760	Služba je určena obyvatelům města Mostu a jeho spádových obcí.	772
3544	3761	Služba je určena obyvatelům města Mostu a jeho spádových obcí.	773
3544	3762	Služba je určena obyvatelům města Mostu a jeho spádových obcí.	774
3544	3766	Služba je určena obyvatelům města Mostu a jeho spádových obcí.	775
3534	3754	\N	776
3534	3755	\N	777
3534	3758	.	778
3530	3751	Sociální služba je poskytována mužům s chronickým duševním onemocněním a s etylickou demencí.S účinností od 01. 01. 2021 jsou 2 lůžka vyčleněna pro osoby opouštějící psychiatrickou nemocnici/léčebnu prostřednictvím CDZ a jsou závislé na pomoci druhé osoby.	779
3529	3765	Dolní věková hranice se netýká stávajících uživatelů.	780
3528	3750	\N	781
3528	3751	\N	782
3526	3754	\N	783
3526	3755	\N	784
3526	3756	\N	785
3526	3758	\N	786
3522	3742	\N	787
3514	3755	\N	788
3514	3758	Sociální služba není poskytována imobilním osobám.	789
3494	3754	Terénní služba poskytovaná dle potřeb uživatelů v Žatci a obcích vzdálených max. 20 km od Žatce.	790
3494	3755	Terénní služba poskytovaná dle potřeb uživatelů v Žatci a obcích vzdálených max. 20 km od Žatce.	791
3490	3747	Sociální služba je poskytována pouze mužům. Sociální služba není  poskytována osobám pod vlivem návykových látek.	792
3489	3747	Sociální služba je poskytována  pouze mužům. Sociální služba  není poskytována osobám pod vlivem návykových látek.	793
3482	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy. Zařízení není bezbariérové.	794
3482	3753	Služba je určena osobám s jiným zdravotním postižením, jako např. s civilizačním, interním nebo smyslovým onemocněním. Zařízení není bezbariérové.	795
3481	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy. Zařízení není bezbariérové.	796
3456	3751	Sociální služba s cílovou skupinou osoby s chronickým duševním onemocněním je určena pro osoby se stařeckou demencí nebo Alzheimerovou chorobou	797
3456	3752	\N	798
3456	3754	\N	799
3456	3756	\N	800
3456	3758	\N	801
3456	3765	\N	802
3441	3757	Jedná se převážně o osoby neslyšící, které ke komunikaci používají hlavně znakový jazyk a znakovanou češtinu, případně osoby nedoslýchavé komunikující odezíráním a artikulací.	803
3405	3752	\N	804
3405	3756	\N	805
3405	3765	\N	806
3384	3761	Služba je určena pro jednotlivce i rodiny ohrožené sociálním vyloučením, žijící v lokalitách Prunéřov u Kadaně,Kadaň a Tušimice.	807
3384	3762	Služba je určena pro jednotlivce i rodiny ohrožené sociálním vyloučením, žijící v lokalitách Prunéřov u Kadaně,Kadaň a Tušimice.	808
3384	3766	Služba je určena pro jednotlivce i rodiny ohrožené sociálním vyloučením, žijící v lokalitách Prunéřov u Kadaně,Kadaň a Tušimice.	809
3379	3758	\N	810
3379	3765	Sociální služba je poskytována na území města Bohušovice nad Ohří a obce Hrdly.	811
3377	3752	Terénní služba je poskytována dle potřeb uživatelů na území města Terezín a jeho spádových obcí.	812
3377	3764	Terénní služba je poskytována dle potřeb uživatelů na území města Terezín a jeho spádových obcí.	813
3377	3765	Terénní služba je poskytována dle potřeb uživatelů na území města Terezín a jeho spádových obcí.	814
3377	3758	Terénní služba je poskytována dle potřeb uživatelů na území města Terezín a jeho spádových obcí.	815
3370	3758	Pečovatelská služba obce Čížkovice je poskytována na území obce Čížkovice a Želechovice.	816
3370	3765	Sociální služba je poskytována na území obce Čížkovice , Želechovice.	817
3347	3758	Sociální služba je poskytována na území obce Nové Sedlo, včetně místních částí Břežany, Cíňov, Chudeřín, Sedčice, Žabokliky.	818
3347	3765	Sociální služba je poskytována na území obce Nové Sedlo, včetně místních částí Břežany, Cíňov, Chudeřín, Sedčice, Žabokliky.	819
3331	3752	Služba je poskytována na spádovém území města Litvínov.	820
3331	3758	Služba je poskytována na spádovém území města Litvínov.	821
3331	3765	Služba je poskytována na spádovém území města Litvínov.	822
3331	3764	\N	823
3329	3765	Služba je poskytována osobám, Které mají sníženou soběstačnost zejména z důvodu věku, jejichž situace vyžaduje pravidelnou pomoc jiné fyzické osoby.	824
3325	3750	Služba je určena osobám ohroženým závislostí na návykových látkách a osobám ohroženým patologickým hráčstvím, jejich rodinným příslušníkům a blízkým.	825
3322	3758	Sociální služba je poskytována osobám s nádorovým onemocněním a postonkologickým pacientům.	826
3276	3751	\N	827
3276	3752	\N	828
3276	3758	\N	829
3276	3765	\N	830
3275	3751	Služba je poskytována v době dle dohody s uživatelem na území města Roudnice nad Labem a okolních obcích v dojezdové vzdálenosti 20 km od hranice města.	831
3275	3752	Služba je poskytována v době dle dohody s uživatelem na území města Roudnice nad Labem a okolních obcích v dojezdové vzdálenosti 20 km od hranice města.	832
3275	3758	Služba je poskytována v době dle dohody s uživatelem na území města Roudnice nad Labem a okolních obcích v dojezdové vzdálenosti 20 km od hranice města.	833
3275	3765	Služba je poskytována v době dle dohody s uživatelem na území města Roudnice nad Labem a okolních obcích v dojezdové vzdálenosti 20 km od hranice města.	834
3267	3758	\N	835
3267	3765	\N	836
3267	11079	\N	837
3262	3756	Služba je poskytována osobám s tělesným postižením od věku 40 let.	838
3262	3758	Služba je poskytována osobám se zdravotním postižením od věku 40 let.	839
3260	3760	Terénní forma je poskytována na území města Litoměřice a spádových obcí.	840
3260	3764	Terénní forma je poskytována na území města Litoměřice a spádových obcí.	841
3181	3759	\N	842
3173	3759	\N	843
3155	3747	\N	844
3121	3754	\N	845
3121	3759	\N	846
3039	3742	\N	847
3039	3743	\N	848
3039	3764	\N	849
3039	3748	\N	850
3039	3760	\N	851
3039	3762	\N	852
3039	3765	\N	853
2981	3754	\N	854
2981	3757	\N	855
2980	3754	\N	856
2980	3757	\N	857
2978	3754	\N	858
2978	3757	\N	859
2972	3758	Služba je poskytována na území obce Polepy, Hrušovany, Libínky, Encovany, Třebutičky a Okna.	860
2972	3765	Služba je poskytována na území obce Polepy, Hrušovany, Libínky, Encovany, Třebutičky a Okna.	861
2963	3743	\N	862
2963	3760	\N	863
2963	3763	\N	864
2963	3765	\N	865
2963	3766	\N	866
2963	3751	\N	867
2940	3747	\N	868
2940	3761	\N	869
2940	3762	\N	870
2940	3760	\N	871
2939	3760	\N	872
2939	3762	\N	873
2939	3747	\N	874
2855	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy.Zařízení není bezbariérové.	875
2855	3753	Služba je určena osobám s jiným zdravotním postižením, např. civilizačním , interním nebo smyslovým onemocněním. Zařízení není bezbariérové.	876
2825	3754	od 15 let s ukončenou školní docházkou	877
2825	3755	od 15 let s ukončenou školní docházkou. Zařízení není bezbariérové.	878
2825	3765	\N	879
2811	3758	Služba je určena osobám se zdravotním postižením, případně osobám pečujícím o osoby s postižením z Loun, Postoloprt a spádových obcí Lounska.	880
2811	3760	Služba je určena osobám, které se ocitly v krizové situaci z důvodu zadlužení nebo jsou zadlužením vážně ohrožení z Loun, Postoloprt a spádových obcí Lounska.	881
2811	3765	Služba je určena seniorům, případně osobám pečujícím o seniory z Loun, Postoloprt a spádových obcí Lounska.	882
2809	3752	Do 31.12.2024: Služba je poskytována na území měst Louny a Postoloprty a spádových obcí Lounska.\n\nOd 01.01.2025: Služba je poskytována dle potřeb uživatelů na území správního obvodu obce s rozšířenou působností Louny a v obcích Blažim, Vidovle, Lišany, Lipno a Lipenec.	883
2809	3765	Do 31.12.2024: Služba je poskytována na území měst Louny a Postoloprty a spádových obcí Lounska.\n\nOd 01.01.2025: Služba je poskytována dle potřeb uživatelů na území správního obvodu obce s rozšířenou působností Louny a v obcích Blažim, Vidovle, Lišany, Lipno a Lipenec.	884
2809	3758	Do 31.12.2024: Služba je poskytována na území měst Louny a Postoloprty a spádových obcí Lounska.\n\nOd 01.01.2025: Služba je poskytována dle potřeb uživatelů na území správního obvodu obce s rozšířenou působností Louny a v obcích Blažim, Vidovle, Lišany, Lipno a Lipenec.	885
2809	3764	Do 31.12.2024: Služba je poskytována na území měst Louny a Postoloprty a spádových obcí Lounska.\n\nOd 01.01.2025: Služba je poskytována dle potřeb uživatelů na území správního obvodu obce s rozšířenou působností Louny a v obcích Blažim, Vidovle, Lišany, Lipno a Lipenec.	886
2777	3751	Chronickým duševbním onemocněním jsou myšleny vaskulární demence a demence při Pakinsonově chorobě.	887
2777	3752	\N	888
2777	3758	\N	889
2777	3765	Služba je poskytována uživatelům, kteří mají sníženou soběstačnost v úkonech, které provází běžnou denní činnost. Cílem služby je návrat klienta do původního prostředí, tak, aby byl schopen žít v domácím prostředí a mohl čerpat sociální službu.	890
2731	3742	Terénní forma služby je poskytována na území města Kadaň.	891
2689	3764	Terénní služba poskytována dle potřeb uživatelů  z oblasti Mostu a Litvínova.\nSociální služba je poskytována úplným nebo neúplným rodinám s dítětem, u kterého je ohrožen jeho vývoj, které žijí v prostředí nevyhovujícím nebo ohrožujícím jeho život a zdraví. Smlouva může být uzavřena pouze s plnoletým klientem.	892
2688	3760	\N	893
2673	3760	Terénní forma služby poskytována dle potřeb klietnů na území města Litvínov ( Janov) a Horní Jiřetín.	894
2672	3764	terénní forma služby je poskytována na území města Litvínov, Horní Jiřetín, Meziboří a Lom	895
2660	3758	půjčovna kompenzačních pomůcek pro domácí péči, pomoc při jednání s úřady	896
2660	3765	půjčovna kompenzačních pomůcek pro domácí péči, pomoc při jednání s úřady	897
2636	3760	\N	898
2636	11079	\N	899
2636	11102	\N	900
2611	3751	\N	901
2606	3755	Služba je poskytována i osobám s poruchami autistického spektra. Služba je poskytována na území města Ústí nad Labem a v přilehlých obcích v dojezdové vzdálenosti 25 km od hranice města.	902
2606	3756	Služba je poskytována na území města Ústí nad Labem a v přilehlých obcích v dojezdové vzdálenosti 25 km od hranice města.	903
2606	3752	\N	904
2606	3758	\N	905
2606	3765	Sociální služba je přednostně poskytována osobám s poruchou autistického spektra a osobám s mentálním postižením.	906
2525	3762	Sociální služba je poskytována na území města Ústí nad Labem.	907
2524	3764	Terénní forma je poskytována dle potřeb uživatelů na území města Ústí nad Labem, včetně spádových obcí.	908
2521	3758	Služba je poskytována ve formě trvalé pobytové služby osobám v terminálním stadiu života (zdravotní paliativní péče) a dále jako dočasná pobytová služba osobám, kterým jsou jinak služby poskytovány v přirozeném domácím prostředí (resp. na přechodnou dobu).	909
2521	3765	Služba je poskytována ve formě trvalé pobytové služby osobám v terminálním stadiu života (zdravotní paliativní péče) a dále jako dočasná pobytová služba osobám, kterým jsou jinak služby poskytovány v přirozeném domácím prostředí (resp. na přechodnou dobu).	910
2484	3752	\N	911
2484	3754	\N	912
2484	3755	\N	913
2484	3758	\N	914
2483	3754	Služba je přednostně určena občanům hlavního města Prahy.	915
2483	3755	Služba je přednostně určena občanům hlavního města Prahy.	916
2483	3756	Služba je přednostně určena občanům hlavního města Prahy.	917
2481	3754	Služba je přednostně určena občanům hlavního města Prahy.	918
2481	3755	Služba je přednostně určena občanům hlavního města Prahy.	919
2481	3756	Služba je přednostně určena občanům hlavního města Prahy.	920
2262	3755	Služba je určena klientům s lehkým a středně těžkým mentálním postižením, kteří jsou schopni základní sebeobsluhy.	921
2158	3754	Sociální služba je určena přednostně pro občany hlavního města Prahy.	922
2158	3755	Sociální služba je určena přednostně pro občany hlavního města Prahy.	923
2158	3753	Z okruhu osob „osoby s jiným zdravotním postižením“ je sociální služba určena osobám, u nichž je deficit intelektu po CMP, autohaváriích nebo způsoben jinými okolnostmi, které nastaly v průběhu jejich života.	924
2152	3751	Přednostně jsou přijímáni žadatelé s trvalým pobytem na území hlavního města Prahy.	925
1987	3758	Služba je poskytována pouze na katastrálním území Velký Šenov.	926
1987	3765	Služba je poskytována pouze na katastrálním území Velký Šenov.	927
1986	3744	\N	928
1986	3746	\N	929
1986	3760	\N	930
1986	3764	\N	931
1974	3747	\N	932
1953	3752	Služba je poskytována na území celého Ústeckého kraje.	933
1953	3758	\N	934
1953	3765	\N	935
1946	3752	\N	936
1946	3753	\N	937
1946	3754	\N	938
1946	3755	\N	939
1946	3756	\N	940
1946	3764	\N	941
1926	3752	TerÃ©nnÃ­ sociÃ¡lnÃ­ sluÅ¾ba je poskytovÃ¡na dle potÅeb uÅ¾ivatelÅ¯ na ÃºzemÃ­ mÄsta Lovosice a pÅilehlÃ½ch obchÃ­ch a na ÃºzemÃ­ mÄsta LitomÄÅice a pÅilehlÃ½ch obcÃ­.	942
1926	3754	TerÃ©nnÃ­ sociÃ¡lnÃ­ sluÅ¾ba je poskytovÃ¡na dle potÅeb uÅ¾ivatelÅ¯ na ÃºzemÃ­ mÄsta Lovosice a pÅilehlÃ½ch obchÃ­ch a na ÃºzemÃ­ mÄsta LitomÄÅice a pÅilehlÃ½ch obcÃ­.	943
1926	3758	TerÃ©nnÃ­ sociÃ¡lnÃ­ sluÅ¾ba je poskytovÃ¡na dle potÅeb uÅ¾ivatelÅ¯ na ÃºzemÃ­ mÄsta Lovosice a pÅilehlÃ½ch obchÃ­ch a na ÃºzemÃ­ mÄsta LitomÄÅice a pÅilehlÃ½ch obcÃ­.	944
1926	3765	TerÃ©nnÃ­ sociÃ¡lnÃ­ sluÅ¾ba je poskytovÃ¡na dle potÅeb uÅ¾ivatelÅ¯ na ÃºzemÃ­ mÄsta Lovosice a pÅilehlÃ½ch obchÃ­ch a na ÃºzemÃ­ mÄsta LitomÄÅice a pÅilehlÃ½ch obcÃ­.	945
1926	3764	Od 01.12.2021\nTerÃ©nnÃ­ sociÃ¡lnÃ­ sluÅ¾ba je poskytovÃ¡na dle potÅeb uÅ¾ivatelÅ¯ na ÃºzemÃ­ mÄsta Lovosice a pÅilehlÃ½ch obchÃ­ch a na ÃºzemÃ­ mÄsta LitomÄÅice a pÅilehlÃ½ch obcÃ­.	946
1920	3751	\N	947
1920	3752	\N	948
1920	3754	\N	949
1920	3755	\N	950
1920	3756	\N	951
1920	3757	\N	952
1920	3758	\N	953
1920	3759	\N	954
1904	3742	CÃ­lovou skupinou jsou dÄti a mlÃ¡deÅ¾ od 12 do 18 let.	955
1887	3742	Služba je poskytována dětem ve věku 6 - 11 let.	956
1887	3761	nebo osoby sociálním vyloučením ohrožené	957
1884	3742	\N	958
1884	3761	dále osoby sociálním vyloučením ohrožené	959
1884	3762	\N	960
1882	3751	Služba je poskytována na území města Ústí nad Labem a v přilehlých obcích v dojezdové vzdálenosti do 20 km.	961
1882	3752	Služba je poskytována na území města Ústí nad Labem a v přilehlých obcích v dojezdové vzdálenosti do 20 km.	962
1882	3758	Služba je poskytována na území města Ústí nad Labem a v přilehlých obcích v dojezdové vzdálenosti do 20 km.	963
1882	3765	Služba je poskytována na území města Ústí nad Labem a v přilehlých obcích v dojezdové vzdálenosti do 20 km.	964
1882	3764	Sociální služba je  poskytována na území města Ústí nad Labem a v přilehlých obcích v dojezdové vzdálenosti do 20 km.	965
1881	3751	Služba je poskytována na území města Roudnice nad Labem a v přilehlých obcích v dojezdové vzdálenosti do 20 km.	966
1881	3752	Služba je poskytována na území města Roudnice nad Labem a v přilehlých obcích v dojezdové vzdálenosti do 20 km.	967
1881	3758	\N	968
1881	3765	Služba je poskytována na území města Roudnice nad Labem a přilehlých obcí v dojezdové vzdálenosti do 20 km.	969
1881	3764	OD 01. 01. 2021.	970
1858	3755	Sociální služba se poskytuje osobám postiženým vedle mentálního postižení též v kombinaci s tělesným postižením a osobám, které nejsou postižené úplnou hluchotou. Sociální služba se neposkytuje imobilním osobám	971
1858	3756	Sociální služba se poskytuje osobám postiženým vedle mentálního postižení též v kombinaci s tělesným postižením a osobám, které nejsou postižené úplnou hluchotou. Sociální služba se neposkytuje imobilním osobám.	972
1858	3757	Sociální služba se poskytuje osobám postiženým vedle mentálního postižení též v kombinaci s tělesným postižením a osobám, které nejsou postižené úplnou hluchotou. Sociální služba se neposkytuje imobilním osobám.	973
1856	3747	Služba je poskytována dle potřeb uživatelů na území Meziboří, Litvínova - Janova, Mostu a Lomu.	974
1856	3761	Služba je poskytována dle potřeb uživatelů na území Meziboří, Litvínova - Janova, Mostu a Lomu.	975
1856	3762	Služba je poskytována dle potřeb uživatelů na území Meziboří, Litvínova - Janova, Mostu a Lomu.	976
1856	3766	Služba je poskytována dle potřeb uživatelů na území Meziboří, Litvínova - Janova, Mostu a Lomu.	977
1830	3751	Služba je určena především osobám se schizofreni a různými typy demencí..\n\nadresa:\nS.K.Neumanna 842/2, Vejprty- služba je určena imobilním osobám\nNerudova 1121/14, Vejprty a Vysoká 936/11, Vejprty je určena pouze mobilním osobám z důvodu bariérovosti budov.	978
1829	3754	u adres:\nHusova 1168/55, Vejprty- služba je určena i imobilním osobám\nHusova 1093/56,  Vejprty, 1. Máje 852/12, Vysoká 735/9 a Moskevská 144/17, Vejprty- služba je určena pouze mobilním osobám z důvodu bariérovosti budov .	979
936	3764	Služba je poskytována na území města Meziboří.	1267
1829	3755	u adres:\nHusova 1168/55, Vejprty- služba je určena i imobilním osobám\nHusova 1093/56,  Vejprty, 1. Máje 852/12, Vysoká 735/9 a Moskevská 144/17, Vejprty- služba je určena pouze mobilním osobám z důvodu bariérovosti budov .	980
1829	3758	u adres:\nHusova 1168/55, Vejprty- služba je určena i imobilním osobám\nHusova 1093/56,  Vejprty, 1. Máje 852/12, Vysoká 735/9 a Moskevská 144/17, Vejprty- služba je určena pouze mobilním osobám z důvodu bariérovosti budov .y).	981
1828	3765	\N	982
1826	3750	Sociální služba je určena především pro občany hlavního města Prahy	983
1826	3751	Sociální služba je určena především pro občany hlavního města Prahy	984
1826	3754	Sociální služba je určena především pro občany hlavního města Prahy.	985
1816	3761	Cílovou skupinou jsou osoby starší 15 let, které se ocitají v situaci sociálního vyloučení nebo jím jsou ohroženy.	986
1815	3761	nebo osoby sociálním vyloučením ohrožené	987
1810	3751	Služba je poskytována osobám s chronickým duševním onemocněním, které jsou trvale v péči rodiny.	988
1810	3755	Služba je poskytována osobám s lehkým a středním mentálním postižením, které jsou trvale v péči rodiny.	989
1808	3761	Službu lze poskytovat jak v domácnostech klientů, tak v konzultačních místnostech v zázemí v centru města Ústí nad Labem,  Předlicích, Krásném Březně a Mojžíři.\nCílovou skupinou jsou osoby starší 15 let, které se ocitají v situaci sociálního vyloučení nebo jsou sociálním vyloučením ohrožené.	990
1806	3756	Služba je poskytována pouze na území obce Vilémov.	991
1806	3758	Služba je poskytována pouze na území obce Vilémov.	992
1806	3765	Služba je poskytována pouze na území obce Vilémov.	993
1805	3752	\N	994
1805	3758	\N	995
1805	3764	\N	996
1805	3765	\N	997
1803	3750	Služba je určena osobám od 15 let, které jsou závislé na návykových látkách a těm, jimž dlouhodobé užívání činí vážné problémy.	998
1801	3750	Sociální služba je poskytována na území měst a obcí Teplice, Krupka, Dubí, Košťany, Hostomice, Proboštov, Novosedlice, Světec, Ledvice, Jeníkov a Kostomlaty pod Milešovkou.	999
1801	3762	Sociální služba je poskytována na území měst a obcí Teplice, Krupka, Dubí, Košťany, Hostomice, Proboštov, Novosedlice, Světec, Ledvice, Jeníkov a Kostomlaty pod Milešovkou.	1000
1800	3750	\N	1001
1798	3750	Služba je poskytována na území měst Varnsdorf, Rumburk, Šluknov a jejich spádových obcí Krásná Lípa, Jiříkov, Mikulášovice a Velký Šenov.	1002
1798	3762	Služba je poskytována na území měst Varnsdorf, Rumburk, Šluknov a jejich spádových obcí Krásná Lípa, Jiříkov, Mikulášovice a Velký Šenov.	1003
1796	3750	\N	1004
1795	3750	\N	1005
1792	3765	\N	1006
1776	3747	Služba je poskytována matkám s nezletilými dětmi a těhotným ženám bez přístřeší.	1007
1775	3744	Terénní forma služby je poskytována na území města Teplice	1008
1775	3746	Terénní forma služby je poskytována na území města Teplice	1009
1775	3749	Terénní forma služby je poskytována na území města Teplice	1010
1775	3758	Terénní forma služby je poskytována na území města Teplice	1011
1775	3760	Terénní forma služby je poskytována na území města Teplice	1012
1775	3766	Terénní forma služby je poskytována na území města Teplice	1013
1767	3748	\N	1014
1767	3751	\N	1015
1767	3754	\N	1016
1767	3755	\N	1017
1767	3758	\N	1018
1749	3756	Terénní služba je poskytována dle potřeb uživatelů na území města Hoštky a přilehlých měststkých částí (Malešov, Velešice, Kochovice a Hoštka).	1019
1749	3765	Terénní služba je poskytována dle potřeb uživatelů na území města Hoštky a přilehlých měststkých částí (Malešov, Velešice, Kochovice a Hoštka).	1020
1724	3759	\N	1021
1721	3759	\N	1022
1716	3752	Služba je poskytována v domácnostech na území města Jirkova a v přilehlých obcích Otvice, Zaječice, Vrskmaň, Drmaly, Pesvice, Vysoká Pec, Březenec, Strupčice.	1023
1716	3755	Služba je poskytována v domácnostech na území města Jirkova a v přilehlých obcích Otvice, Zaječice, Vrskmaň, Drmaly, Pesvice, Vysoká Pec, Březenec, Strupčice.	1024
1716	3758	Služba je poskytována v domácnostech na území města Jirkova a v přilehlých obcích Otvice, Zaječice, Vrskmaň, Drmaly, Pesvice, Vysoká Pec, Březenec, Strupčice.	1025
1716	3765	Služba je poskytována v domácnostech na území města Jirkova a v přilehlých obcích Otvice, Zaječice, Vrskmaň, Drmaly, Pesvice, Vysoká Pec, Březenec, Strupčice.	1026
1716	3764	\N	1027
1715	3765	\N	1028
1714	3752	\N	1029
1714	3758	\N	1030
1687	3751	Sociální služba je určena osobám se stařeckou  demencí a demencí  typu  Alzheimerovy choroby.	1031
1685	3744	\N	1032
1685	3746	\N	1033
1685	3750	\N	1034
1685	3760	\N	1035
1685	3762	\N	1036
1685	3763	\N	1037
1685	3764	\N	1038
1685	3765	\N	1039
1684	3752	Služba je poskytována na území města Most a městských částí Souš, Čepirohy, Vtelno, Rudolice a Chánov.	1040
1684	3765	Služba je poskytována na území města Most a městských částí Souš, Čepirohy, Vtelno, Rudolice a Chánov.	1041
1684	3764	\N	1042
1684	3758	Služba je poskytována na území města Most a městských částí Souš, Čepirohy, Vtelno, Rudolice a Chánov.	1043
1683	3754	\N	1044
1682	3754	\N	1045
1682	3755	\N	1046
1682	3756	\N	1047
1682	3765	Služba je poskytována seniorům od 55 let, kteří vyžadují pravidelnou pomoc jiné fyzické osoby.	1048
1681	3765	\N	1049
1679	3765	\N	1050
1677	3754	Služba je poskytována klientům s ukončenou školní docházkou.	1051
1677	3755	Služba je poskytována klientům s ukončenou školní docházkou.	1052
1677	3756	Služba je poskytována klientům s ukončenou školní docházkou.	1053
1676	3765	\N	1054
1642	3742	Sekundární skupina - děti od 5 let, kteří jsou doprovodem klientů.\n\nterénní forma probíhá na území města Most	1055
1640	3764	Terénní služba poskytována dle potřeb uživatelů na území města Mostu a jeho spádových obcí.	1056
1639	3760	\N	1057
1638	3752	Terénní služba  poskytována na území města Mostu,  Duchcova, Oseku a a jejich spádových obcích.	1058
1638	3758	Terénní služba  poskytována na území města Mostu,  Duchcova, Oseku a a jejich spádových obcích.	1059
1638	3765	Terénní služba  poskytována na území města Mostu,  Duchcova, Oseku a a jejich spádových obcích.	1060
1632	3752	\N	1061
1632	3758	\N	1062
1632	3765	\N	1063
1632	3764	Sociální služba je poskytována rodinám s dětmi, jejichž situace vyžaduje pomoc jiné fyzické osoby. V případě rodin s vícerčaty do 4 let věku dětí.	1064
1632	3751	\N	1065
1632	3753	služba je určena pro osoby, např. s morbidní obezitou, onkologickým onemocněním, ALS atp.	1066
1632	3754	\N	1067
1632	3756	\N	1068
1632	3757	\N	1069
1632	3759	\N	1070
1621	3748	Sociální služba je poskytována dívkám a ženám.	1071
1620	3747	Sociální služba je poskytována matkám s dětmi, těhotným ženám a 3. osobám ženského pohlaví (ženám, dívkám), pečujícím o nezaopatřené dítě	1072
1620	3760	Sociální služba je poskytována matkám s dětmi.	1073
1618	3747	Služba je poskytována mužům i ženám.	1074
1617	3747	\N	1075
1610	3750	Terénní služba poskytovaná dle potřeb uživatelů na území Liberce, Jablonce nad Nisou, Turnova, České Lípy, Železného Brodu, Doks, Jablonného v Podještědí, Nového Boru, Stráže pod Ralskem, Ralska, Frýdlantu, Hrádku nad Nisou, Jilemnici, Semil, Tanvaldu a jejich spádových obcí.	1076
1610	3763	Terénní služba poskytovaná dle potřeb uživatelů na území Liberce, Jablonce nad Nisou, Turnova, České Lípy, Železného Brodu, Doks, Jablonného v Podještědí, Nového Boru, Stráže pod Ralskem, Ralska, Frýdlantu, Hrádku nad Nisou, Jilemnici, Semil, Tanvaldu a jejich spádových obcí.	1077
1609	3750	Sociální služba je poskytována na území měst Most, Bílina, Duchcov, Osek, Litvínov,  Žatec, Louny a jejich spádových obcí.	1078
1608	3750	\N	1079
1607	3750	Osoby experimentující s návykovými látkami, problémoví uživatelé návykových látek, závislí na návykových látkách při prvním kontaktu s odbornou institucí, závislí na návykových látkách, kteří nejsou motivovaní k abstinenci, popř. neakceptují jinou účinnější formu léčebné péče, rodinní příslušníci, partneři a jiné důležité osoby.	1080
1604	3760	\N	1081
1594	3750	Služba je poskytována experimentátorům s návykovými látkami, osobám závislým na návykových látkách, uživatelům drog s rizikem získání infekce HIV/AIDS a hepatid a lidem, jejichž chování se vyznačuje sociálně patologickými rysy.	1082
1594	3762	\N	1083
1593	3750	Služba je určena osobám experimentujícím s návykovými látkami, lidem závislým na návykových látkách, uživatelům drog s motivací k léčbě, abstinujícím uživatelům drog a rodinným příslušníkům, patrnerům a blízkým uživatelům drog.	1084
1571	3751	Služba je poskytována osobám s Alzheimerovou chorobou a jinými typy stařeckých demencí.	1085
1571	3752	\N	1086
1571	3755	\N	1087
1571	3756	\N	1088
1571	3758	\N	1089
1571	3765	\N	1090
1563	3744	\N	1091
1563	3746	\N	1092
1563	3760	Služba je poskytována rovněž manželským a partnerským párům, snoubencům a jednotlivcům, kteří prožívají obtížné životní období.	1093
1563	3764	\N	1094
1563	3765	\N	1095
1557	3751	\N	1096
1556	3765	\N	1097
1552	3755	Sociální služba se poskytuje osobám závislým na pomoci jiné fyzické osoby. Sociální služba se neposkytuje imobilním osobám.	1098
1515	3764	Sociální služba je poskytována rodinám s dítětem/dětmi do 18 let věku. Ambulantní forma je poskytována na adrese zařízení, terénní forma je poskytována ve městě Ústí nad Labem a v dojezdové vzdálenosti do 30 km od hranice města.	1099
1512	3754	Služba je určena uživatelům s mentálním postižením v kombinaci s tělesným či smyslovým postižením. Zařízení není bezbariérové.	1100
1512	3755	\N	1101
1509	3757	\N	1102
1508	3757	Jedná se převážně o osoby neslyšící, které ke komunikaci používají hlavně znakový jazyk a znakovanou češtinu, případně osoby nedoslýchavé komunikující odezíráním a artikulací.	1103
1507	3757	\N	1104
1506	3757	Jedná se převážně o osoby neslyšící, které ke komunikaci používají hlavně znakový jazyk a znakovanou češtinu, případně osoby nedoslýchavé komunikující odezíráním a artikulací.	1105
1505	3757	\N	1106
1504	3757	Jedná se převážně o osoby neslyšící, které ke komunikaci používají hlavně znakový jazyk a znakovanou češtinu, případně osoby nedoslýchavé komunikující odezíráním a artikulací.	1107
1503	3757	jedná se především o osoby neslyšící, které ke komunikaci používají hlavně znakový jazyk a znakovanou češtinu	1108
1482	3754	Služba je určena uživatelům s mentálním postižením v kombinaci s tělesným či smyslovým postižením. Zařízení není bezbariérové.	1109
1482	3755	\N	1110
1480	3754	Služba je určena uživatelům s mentálním postižením v kombinaci s tělesným či smyslovým postižením. Zařízení není bezbariérové.	1111
1480	3755	\N	1112
1479	3754	Služba je určena uživatelům s mentálním postižením v kombinaci s tělesným či smyslovým postižením. Zařízení není bezbariérové.	1113
1479	3755	\N	1114
1479	3758	\N	1115
1405	3744	Pro tuto cílovou skupinu platí, že jde o starší děti ve věku od 11 let.	1116
1405	3746	Pro tuto cílovou skupinu platí, že jde o starší děti ve věku od 11 let.	1117
1405	3748	\N	1118
1405	3751	Pro tuto cílovou skupinu platí, že služba je poskytována osobám s poruchou kognitivních funkcí - Alzheimerovou chorobou a jinou formou demence.	1119
1405	3760	\N	1120
1405	3761	Pro tuto cílovou skupinu platí, že jde o starší děti ve věku od 11 let.	1121
1405	3764	\N	1122
1393	3752	Terénní forma služby poskytovaná dle potřeb uživatelů ve správním obvodu města Louny s rozšířenou působností.	1124
1393	3758	Terénní forma služby poskytovaná dle potřeb uživatelů ve správním obvodu města Louny s rozšířenou působností.	1125
1393	3764	Terénní forma služby poskytovaná dle potřeb uživatelů ve správním obvodu města Louny s rozšířenou působností.	1126
1393	3765	Terénní forma služby poskytovaná dle potřeb uživatelů ve správním obvodu města Louny s rozšířenou působností.	1127
1370	3765	Služba je zaměřena na potřeby osaměle žijících a se zvláštním zřetelem k potřebám přeživších obětí holocaustu, jejichž osobní cíle vycházejí ze židovských tradic a kořenů. Služba je poskytována na území Teplic, Mostu, Žatce, Ústí nad Labem, Kadaně, Meziboří, Litoměřic, Dubí a Krupky.	1128
1368	3750	Služba je poskytovaná dle potřeb uživatelů v obci Podbořany a v obcích ve správním obvodu obce s rozšířenou působností Kadaň.	1129
1367	3750	\N	1130
1365	3750	Služba poskytována na území města  Karlovy Vary a Ostrov a jejich spádových obcí.	1131
1364	3750	\N	1132
1363	3750	Služba je poskytována na území města  Chomutov, Jirkov a spádových obcí.	1133
1361	3750	\N	1134
1356	3760	\N	1135
1356	3761	\N	1136
1354	3764	Terénní služba poskytovaná dle potřeb uživatelů v Děčíně a okolních obcích v dojezdové vzdálenosti do 1 hodiny HD.	1137
1347	3742	\N	1138
1346	3764	Služba je poskytována rodinám s dětmi žijícím na území města Lovosice a jeho spádových obcí.	1139
1345	3747	\N	1140
1345	3762	\N	1141
1335	3752	\N	1142
1335	3754	\N	1143
1335	3755	\N	1144
1335	3756	\N	1145
1335	3757	\N	1146
1335	3758	\N	1147
1335	3759	\N	1148
1335	3765	\N	1149
1333	3752	\N	1150
1333	3754	\N	1151
1333	3755	\N	1152
1333	3756	\N	1153
1333	3758	\N	1154
1333	3759	\N	1155
1333	3765	\N	1156
1306	3754	Terénní forma služby je poskytována na území města Teplice v dojezdové vzdálenosti max. 20 km od Teplic.	1157
1306	3755	Terénní forma služby je poskytována na území města Teplice v dojezdové vzdálenosti max. 20 km od Teplic.	1158
1306	3756	Terénní forma služby je poskytována na území města Teplice v dojezdové vzdálenosti max. 20 km od Teplic.	1159
1306	3758	Terénní forma služby je poskytována na území města Teplice v dojezdové vzdálenosti max. 20 km od Teplic.	1160
1306	3753	osoby s poruchou autistického spektra\nterénní forma je poskytována na území města Teplice a dojezdové vzdálenosti max. 20 km od Teplic	1161
1305	3754	Terénní forma služby je poskytována v okruhu max. 20 km od Teplic.	1162
1305	3755	Terénní forma služby je poskytována v okruhu max. 20 km od Teplic.	1163
1305	3756	Terénní forma služby je poskytována v okruhu max. 20 km od Teplic.	1164
1305	3758	Terénní forma služby je poskytována v okruhu max. 20 km od Teplic.	1165
1303	3754	\N	1166
1303	3755	\N	1167
1303	3756	\N	1168
1303	3753	\N	1169
1301	3754	Terénní forma služby je poskytována maximálně 20 km od města Krupky.	1170
1301	3755	Terénní forma služby je poskytována maximálně 20 km od města Krupky.	1171
1301	3753	Služba je poskytována osobám  s poruchou autistického spektra.	1172
1300	3754	\N	1173
1300	3755	\N	1174
1300	3753	Služba je poskytována osobám s poruchou autistického spektra.	1175
1299	3754	\N	1176
1299	3755	\N	1177
1299	3756	\N	1178
1272	3742	\N	1179
1270	3747	Služba je poskytována mužům od 18 let věku.	1180
1268	3760	Sociální služba je poskytována dle potřeb uživatelů na území města Varnsdrof.	1181
1268	3761	Sociální služba je poskytována dle potřeb uživatelů na území města Varnsdrof.	1182
1268	3762	Sociální služba je poskytována dle potřeb uživatelů na území města Varnsdrof.	1183
1252	3756	Služba poskytována dle potřeb uživatelů na správním území  \nměsta Bíliny, včetně spádových obcí Hostomice, Měrunice, Žichov, Hrobčice, Razice, Mrzlice, Červený Újezd, Mukov,   Kučlín, Mirošovice, Chouč, Tvrdín, Ledvice,  Ohníč, Němečky,              Křemýž, Pňovičky, Dolánky,  Světec,  Chotějovice,  Štrbice,  Úpoř, Lukov a Štěpánov.	1184
1252	3758	Služba poskytována dle potřeb uživatelů na správním území  \nměsta Bíliny, včetně spádových obcí Hostomice, Měrunice, Žichov, Hrobčice, Razice, Mrzlice, Červený Újezd, Mukov,   Kučlín, Mirošovice, Chouč, Tvrdín, Ledvice,  Ohníč, Němečky,              Křemýž, Pňovičky, Dolánky,  Světec,  Chotějovice,  Štrbice,  Úpoř, Lukov a Štěpánov.	1185
1252	3759	Služba poskytována dle potřeb uživatelů na správním území  \nměsta Bíliny, včetně spádových obcí Hostomice, Měrunice, Žichov, Hrobčice, Razice, Mrzlice, Červený Újezd, Mukov,   Kučlín, Mirošovice, Chouč, Tvrdín, Ledvice,  Ohníč, Němečky,              Křemýž, Pňovičky, Dolánky,  Světec,  Chotějovice,  Štrbice,  Úpoř, Lukov a Štěpánov.	1186
1252	3765	Služba poskytována dle potřeb uživatelů na správním území  \nměsta Bíliny, včetně spádových obcí Hostomice, Měrunice, Žichov, Hrobčice, Razice, Mrzlice, Červený Újezd, Mukov,   Kučlín, Mirošovice, Chouč, Tvrdín, Ledvice,  Ohníč, Němečky,              Křemýž, Pňovičky, Dolánky,  Světec,  Chotějovice,  Štrbice,  Úpoř, Lukov a Štěpánov.	1187
1252	3751	Služba poskytována dle potřeb uživatelů na správním území  \nměsta Bíliny, včetně spádových obcí Hostomice, Měrunice, Žichov, Hrobčice, Razice, Mrzlice, Červený Újezd, Mukov,   Kučlín, Mirošovice, Chouč, Tvrdín, Ledvice,  Ohníč, Němečky,              Křemýž, Pňovičky, Dolánky,  Světec,  Chotějovice,  Štrbice,  Úpoř, Lukov a Štěpánov.	1188
1252	3752	Služba poskytována dle potřeb uživatelů na správním území  \nměsta Bíliny, včetně spádových obcí Hostomice, Měrunice, Žichov, Hrobčice, Razice, Mrzlice, Červený Újezd, Mukov,   Kučlín, Mirošovice, Chouč, Tvrdín, Ledvice,  Ohníč, Němečky,              Křemýž, Pňovičky, Dolánky,  Světec,  Chotějovice,  Štrbice,  Úpoř, Lukov a Štěpánov.	1189
1252	3757	Služba poskytována dle potřeb uživatelů na správním území  \nměsta Bíliny, včetně spádových obcí Hostomice, Měrunice, Žichov, Hrobčice, Razice, Mrzlice, Červený Újezd, Mukov,   Kučlín, Mirošovice, Chouč, Tvrdín, Ledvice,  Ohníč, Němečky,              Křemýž, Pňovičky, Dolánky,  Světec,  Chotějovice,  Štrbice,  Úpoř, Lukov a Štěpánov.	1190
1252	3764	Služba poskytována dle potřeb uživatelů na správním území  \nměsta Bíliny, včetně spádových obcí Hostomice, Měrunice, Žichov, Hrobčice, Razice, Mrzlice, Červený Újezd, Mukov,   Kučlín, Mirošovice, Chouč, Tvrdín, Ledvice,  Ohníč, Němečky,              Křemýž, Pňovičky, Dolánky,  Světec,  Chotějovice,  Štrbice,  Úpoř, Lukov a Štěpánov.	1191
1249	3742	\N	1192
1245	3742	Služba je určena dětem, které jsou ohroženy násilím na dětech nebo mezi dětmi, mládeži, která má poruchy chování, přišla do kontaktu s negativními společenskými jevy, páchala trestnou činnost a vede rizikový způsob života.	1193
1245	3745	\N	1194
1245	3746	\N	1195
1245	3748	\N	1196
1245	3749	\N	1197
1245	3751	\N	1198
1245	3760	\N	1199
1245	3761	\N	1200
1245	3762	\N	1201
1245	3763	\N	1202
1245	3764	\N	1203
1244	3744	\N	1204
1244	3746	Oběti trestné činnosti jsou okruhem osob, kterému je sociální služba určena, pouze v těch případech, kdy jsou tyto osoby ohroženy domácím násilím (např. stalking jako pokračování domácího násilí).	1205
1240	3746	\N	1206
1240	3760	Služba je poskytována osobám bez rozdílu věku, pohlaví, národnosti, rasy, barvy pleti, politického přesvědčení, náboženského vyznání, zdravotního stavu, sexuální orientace a socioekonomického postavení.	1207
1238	3746	\N	1208
1238	3760	\N	1209
1216	3742	\N	1210
1213	3747	\N	1211
1212	3747	\N	1212
1211	3747	\N	1213
1210	3748	\N	1214
1210	3751	\N	1215
1210	3754	\N	1216
1210	3755	\N	1217
1210	3758	\N	1218
1209	3751	\N	1219
1209	3754	\N	1220
1209	3755	\N	1221
1209	3758	\N	1222
1207	3747	Od 01. 01. 2020:\nSociální služba je určena ženám/matkám starším ve věku 18 - 64 let s maximálně 4 dětmi mladšími 18 let věku a těhotným ženám a matkách od 17 let věku, které jsou umístěny na základě doporučení OSPOD.	1223
1206	3758	Sociální služba je poskytována dle potřeb uživatelů na území s maximální dojezdovou vzdáleností do 20 km od Roudnice nad Labem.(do 31. 10. 2021)\n\nSociální služba je poskytována v Roudnici nad Labem a v okolních obcích do maximální vzdálenosti 15 km od Roudnice nad Labem. (od 01. 11. 2021)	1224
1206	3765	Sociální služba je poskytována dle potřeb uživatelů na území s maximální dojezdovou vzdáleností do 20 km od Roudnice nad Labem.(do 31. 10. 2021)\n\nSociální služba je poskytována v Roudnici nad Labem a v okolních obcích do maximální vzdálenosti 15 km od Roudnice nad Labem. (od 01. 11. 2021)	1225
1206	3752	Sociální služba je poskytována dle potřeb uživatelů na území s maximální dojezdovou vzdáleností do 20 km od Roudnice nad Labem.(do 31. 10. 2021)\n\nSociální služba je poskytována v Roudnici nad Labem a v okolních obcích do maximální vzdálenosti 15 km od Roudnice nad Labem. (od 01. 11. 2021)	1226
1206	3764	Sociální služba je poskytována dle potřeb uživatelů na území s maximální dojezdovou vzdáleností do 20 km od Roudnice nad Labem.(do 31. 10. 2021)\n\nSociální služba je poskytována v Roudnici nad Labem a v okolních obcích do maximální vzdálenosti 15 km od Roudnice nad Labem. (od 01. 11. 2021)	1227
1205	3742	Terénní forma sociální služby je poskytována dle potřeb uživatelů na území města Roudnice nad Labem.	1228
1188	3757	Služba je poskytována v dojezdové vzdálenosti do 30 km od Ústí nad Labem.	1229
1187	3757	Služba je poskytována v dojezdové vzdálenosti do 30 km od Ústí nad Labem.	1230
1177	3751	včetně dětí a mladistvých ohrožených rozvojem duševního onemocnění a těch, kteří duševní onemocnění mají již diagnostikované	1231
1177	3753	\N	1232
1039	3750	\N	1233
1038	3750	Služba je určena také pro rodiče, partnery, příbuzné uživatelů (nebo experimentátorů s drogami).	1234
1037	3747	Služba je poskytována dospělým mužům bez přístřeší.	1235
1036	3747	Služba je poskytována matkám, otcům nebo těhotným ženám s nezletilými dětmi a dále samostatným dospělým mužům od 18 do 66 let věku (27 lůžek).\nDále je služba určena těhotným ženám a matkám od 17 let věku, které jsou umístěny na základě doporučení OSPOD (2 lůžka).	1236
1035	3752	Služba je poskytována na území města Děčín.	1237
1035	3758	Služba je poskytovaná i osobám s poruchou autistického spektra. \nSlužba je poskytována na území města Děčín.	1238
1035	3765	Služba je poskytována na území města Děčín.	1239
1035	3764	Od 01. 01. 2021.	1240
1034	3754	\N	1241
1034	3755	\N	1242
1033	3758	služba je přednostně určena osobám s poruchou autistického spektra s možností dalšího přidruženého postižení	1243
1032	3765	Služba je určena klientům od 62 let věku.	1244
1011	3742	Terénní forma služby poskytována dle potřeb uživatelů na území obce Dubí a Teplice.	1245
1005	3760	\N	1246
1005	3764	\N	1247
1005	3765	\N	1248
1003	3760	\N	1249
1003	3764	\N	1250
1003	3765	\N	1251
1001	3754	\N	1252
1001	3755	\N	1253
1000	3754	\N	1254
1000	3755	\N	1255
999	3754	Služba je vzhledem k technickým možnostem budovy určena pouze pro mobilní osoby.	1256
999	3755	Služba je vzhledem k technickým možnostem budovy určena pouze pro mobilní osoby.	1257
998	3751	Služba je poskytována osobám se stařeckou, Alzheimerovou demencí a ostatními typy demencí.	1258
994	3765	\N	1259
985	3765	Služba je poskytována na území města Jílové.	1260
985	3752	\N	1261
985	3758	\N	1262
985	3764	\N	1263
936	3752	Služba je poskytována na území města Meziboří.	1264
936	3758	Služba je poskytována na území města Meziboří.	1265
935	3751	Služba je poskytována pouze ženám s chronickým duševním onemocněním od 50 let věku. Služba není poskytována osobám závislým na návykových látkách.	1268
931	3764	Rodina, která žije v ORP Rumburk (Rumburk, Jiříkov, Krásná Lípa, Šluknov, Velký Šenov, Dolní Poustevna, Doubice, Lipová, Lobendava, Mikulášovice, Staré Křečany, Vilémov) a v ORP Varnsdorf (Varnsdorf, Jiřetín pod Jedlovou, Dolní Podluží, Horní Podluží, Rybniště, Chřibská).	1269
929	3742	\N	1270
927	3760	\N	1271
923	3751	Služba je poskytována osobám, které mají sníženou soběstačnost vlivem onemocnění typu stařecké demence, Alzheimerovy demence a ostatních typů demencí. Předpokladem je, aby tyto osoby měly sníženou soběstačnost a z důvodu tohoto onemocnění jejich situace vyžadovala pravidelnou pomoc jiné fyzické osoby (193 lůžek).\nDále je služba poskytována osobám, které trpí poruchami kognitivních funkcí a opouštějí psychiatrickou nemocnici/léčebnu prostřednictvím CDZ a potřebují nepřetržitou pomoc druhé osoby (počet lůžek 2).	1272
922	3765	\N	1273
920	3752	Služba je poskytována na území města Krupka, vyjma území Fojtovice, Horní Krupka, Habartice a Mohelnice.	1274
920	3758	Služba je poskytována na území města Krupka, vyjma území Fojtovice, Horní Krupka, Habartice a Mohelnice.	1275
920	3764	Služba je poskytována na území města Krupka, vyjma území Fojtovice, Horní Krupka, Habartice a Mohelnice.	1276
920	3765	Služba je poskytována na území města Krupka, vyjma území Fojtovice, Horní Krupka, Habartice a Mohelnice.	1277
914	3752	Terénní služba je poskytovaná dle potřeb uživatelů na území  měst  Chomutov  a Jirkov, včetně jejich spádových obcí.	1278
914	3754	Terénní služba je poskytovaná dle potřeb uživatelů na území  měst  Chomutov  a Jirkov, včetně jejich spádových obcí.	1279
914	3755	Terénní služba je poskytovaná dle potřeb uživatelů na území  měst  Chomutov  a Jirkov, včetně jejich spádových obcí.	1280
914	3756	Terénní služba je poskytovaná dle potřeb uživatelů na území  měst  Chomutov  a Jirkov, včetně jejich spádových obcí.	1281
914	3757	TTerénní služba je poskytovaná dle potřeb uživatelů na území  měst  Chomutov  a Jirkov, včetně jejich spádových obcí.	1282
914	3758	Terénní služba je poskytovaná dle potřeb uživatelů na území  měst  Chomutov  a Jirkov, včetně jejich spádových obcí.	1283
914	3759	Terénní služba je poskytovaná dle potřeb uživatelů na území  měst  Chomutov  a Jirkov, včetně jejich spádových obcí.	1284
914	3765	Terénní služba je poskytovaná dle potřeb uživatelů na území  měst  Chomutov  a Jirkov, včetně jejich spádových obcí.	1285
913	3765	\N	1286
850	3751	Jedná se o osoby s Alzheimerovou chorobou a demencí. \nSlužba je poskytována dle potřeb uživatelů ve města Děčín, na území části obce Jílové u Děčína, na území části obce Modrá - Jílové, na území části Malá Veleň - Jedlka u Benešova nad Ploučnicí, části obce Benešov nad Ploučnicí - Základní škola speciální Benešov nad Ploučnicí.	1287
850	3754	Služba je poskytována dle potřeb uživatelů ve města Děčín, na území části obce Jílové u Děčína, na území části obce Modrá - Jílové, na území části Malá Veleň - Jedlka u Benešova nad Ploučnicí, části obce Benešov nad Ploučnicí - Základní škola speciální Benešov nad Ploučnicí.	1288
850	3755	Služba je poskytována dle potřeb uživatelů ve města Děčín, na území části obce Jílové u Děčína, na území části obce Modrá - Jílové, na území části Malá Veleň - Jedlka u Benešova nad Ploučnicí, části obce Benešov nad Ploučnicí - Základní škola speciální Benešov nad Ploučnicí.	1289
850	3758	Služba je poskytována dle potřeb uživatelů ve města Děčín, na území části obce Jílové u Děčína, na území části obce Modrá - Jílové, na území části Malá Veleň - Jedlka u Benešova nad Ploučnicí, části obce Benešov nad Ploučnicí - Základní škola speciální Benešov nad Ploučnicí.	1290
850	3765	Služba je poskytována dle potřeb uživatelů ve města Děčín, na území části obce Jílové u Děčína, na území části obce Modrá - Jílové, na území části Malá Veleň - Jedlka u Benešova nad Ploučnicí, části obce Benešov nad Ploučnicí - Základní škola speciální Benešov nad Ploučnicí.	1291
817	3754	\N	1292
817	3756	\N	1293
781	3751	\N	1294
781	3754	\N	1295
781	3755	\N	1296
781	3756	\N	1297
781	3758	\N	1298
780	3747	Služba je určena pouze ženám s nezletilými dětmi.\nSlužba je poskytována pro maximální počet 8 matek s maximálním počtem 24 nezaopatřených dětí (pro všechny matky).	1299
779	3754	Služba není určena pro osoby s těžkou a úplnou závislostí na pomoci jiné fyzické osoby	1300
779	3755	\N	1301
779	3756	\N	1302
779	3758	\N	1303
766	3765	\N	1304
747	3765	Služba je poskytována osobám nad 60 let věku, které vzhledem ke své situaci potřebují pravidelnou pomoc jiné fyzické osoby.	1305
746	3751	Sociální služba je poskytována osobám s chronickým duševním onemocněním – s Huntigtonovou nemocí, schizofrenií, psychotickým onemocněním a etylickou demencí, které jsou závislé na pomoci jiné fyzické osoby. Toto se netýká stávajících uživatelů služby. Sociální služba se neposkytuje osobám závislým na návykových látkách, a osobám, které nezvládají komunikaci v českém jazyce.	1306
718	3752	Služba je poskytována na území města Štětí a integrovaných částí - Brocno, Čakovice, Hněvice, Chcebuz, Počeplice, Radouň, Stračí, Újezd a Veselí.	1307
718	3758	Služba je poskytována na území města Štětí a integrovaných částí - Brocno, Čakovice, Hněvice, Chcebuz, Počeplice, Radouň, Stračí, Újezd a Veselí.	1308
718	3764	\N	1309
718	3765	Služba je poskytována na území města Štětí včetně integrovaných částí - Brocno, Čakovice, Hněvice,Chcebuz, Počeplice, Radouň, Stračí, Újezd a Veselí.	1310
715	3751	Služba je poskytována seniorům se sníženou soběstačností z důvodu věku s chronickým duševním onemocněním (Alzheimerovou nemocí a jinými druhy demencí). Služba je poskytována i osobám mladším 65 let, které do zařízení nastoupily před účinností zákona o sociálních službách. Osoby mladší 65 let nejsou cílovou skupinou poskytovatele.	1311
346	3765	Sociální služba je určena seniorům od 60 let věku, kteří potřebují dopomoc v běžných denních činnostech.	1397
714	3765	Služba je poskytována i osobám mladším 65 let, které do zařízení nastoupily před účinností zákona o sociálních službách. Osoby mladší 65 let nejsou cílovou skupinou uživatele.  Zařízení je bezbariérové.	1312
712	3765	Sociální služba je poskytována seniorům, kteří jsou závislí na pomoci jiné fyzické osoby.	1313
707	3751	Terénní služba je poskytována dle potřeb uživatelů na území městských obvodů statutárního města Ústí nad Labem, ve městech Chlumec, Chabařovice a Trmice, a v obcích Ryjice, Libouchec, Petrovice, Velké Chvojno, Telnice, Tisá, Přestanov a Stebno.	1314
707	3752	Terénní služba je poskytována dle potřeb uživatelů na území městských obvodů statutárního města Ústí nad Labem, ve městech Chlumec, Chabařovice a Trmice, a v obcích Ryjice, Libouchec, Petrovice, Velké Chvojno, Telnice, Tisá, Přestanov a Stebno.	1315
707	3753	Terénní služba je poskytována dle potřeb uživatelů na území městských obvodů statutárního města Ústí nad Labem, ve městech Chlumec, Chabařovice a Trmice, a v obcích Ryjice, Libouchec, Petrovice, Velké Chvojno, Telnice, Tisá, Přestanov a Stebno.	1316
707	3754	Terénní služba je poskytována dle potřeb uživatelů na území městských obvodů statutárního města Ústí nad Labem, ve městech Chlumec, Chabařovice a Trmice, a v obcích Ryjice, Libouchec, Petrovice, Velké Chvojno, Telnice, Tisá, Přestanov a Stebno.	1317
707	3755	Služba je poskytována na území městských obvodů statutárního města Ústí nad Labem, ve městech Chlumec a Chabařovice, a v obcích Ryjice, Libouchec, Petrovice, Velké Chvojno a Telnice.Od 1.1.2024 i Tisá, Přestanov a Stebno.	1318
707	3756	Terénní služba je poskytována dle potřeb uživatelů na území městských obvodů statutárního města Ústí nad Labem, ve městech Chlumec, Chabařovice a Trmice, a v obcích Ryjice, Libouchec, Petrovice, Velké Chvojno, Telnice, Tisá, Přestanov a Stebno.	1319
707	3759	Terénní služba je poskytována dle potřeb uživatelů na území městských obvodů statutárního města Ústí nad Labem, ve městech Chlumec, Chabařovice a Trmice, a v obcích Ryjice, Libouchec, Petrovice, Velké Chvojno, Telnice, Tisá, Přestanov a Stebno.	1320
707	3764	Terénní služba je poskytována dle potřeb uživatelů na území městských obvodů statutárního města Ústí nad Labem, ve městech Chlumec, Chabařovice a Trmice, a v obcích Ryjice, Libouchec, Petrovice, Velké Chvojno, Telnice, Tisá, Přestanov a Stebno.	1321
707	3765	Terénní služba je poskytována dle potřeb uživatelů na území městských obvodů statutárního města Ústí nad Labem, ve městech Chlumec, Chabařovice a Trmice, a v obcích Ryjice, Libouchec, Petrovice, Velké Chvojno, Telnice, Tisá, Přestanov a Stebno.	1322
698	3761	(služba je určena osobám z uvedených cílových skupin, které jsou v nepříznivé sociální situaci, ohrožené sociálním vyloučením nebo sociálně vyloučené, žijícím ve městě Trmice)	1323
698	3762	(služba je určena osobám z uvedených cílových skupin, které jsou v nepříznivé sociální situaci, ohrožené sociálním vyloučením nebo sociálně vyloučené, žijícím ve městě Trmice)	1324
698	3766	(služba je určena osobám z uvedených cílových skupin, které jsou v nepříznivé sociální situaci, ohrožené sociálním vyloučením nebo sociálně vyloučené, žijícím ve městě Trmice)	1325
697	3742	\N	1326
697	3761	\N	1327
697	3762	\N	1328
697	3766	\N	1329
671	3756	\N	1330
671	3758	\N	1331
671	3764	Služba je poskytována rodinám, kterým se narodily současně3 a více dětí, a to do věku 4 let těchto dětí.	1332
671	3765	\N	1333
671	3752	\N	1334
668	3765	Sociální služba je poskytována osobám, které jsou závislé na pomoci jiné fyzické osoby.	1335
648	3751	Sociální služba je poskytována osobám, které již nedokážou vlastními silami zvládnout základní činnosti a potřebují v těchto základních činnostech pravidelnou pomoc druhého člověka. Podmínkou přijetí do služby je diagnostikovaná Alzheimerova nemoc či jiný typ demence.	1336
648	3765	Sociální služba je poskytována osobám, které již nedokážou vlastními silami zvládnout základní činnosti a potřebují v těchto základních činnostech pravidelnou pomoc druhého člověka. Podmínkou přijetí do služby je diagnostikovaná Alzheimerova nemoc či jiný typ demence.	1337
647	3765	Sociální služba je určena osobám od 65 let věku, které již nedokážou vlastními silami zvládnout základní činnosti, které jsou nezbytnou součástí běžného života a potřebují v těchto základních činnostech pravidelnou pomoc jiného člověka.	1338
633	3742	Služba je poskytována na území města Ústí nad Labem a Trmice. Od 1.1.2017 dále i město Chlumec a Chabařovice.	1339
633	3750	Služba je poskytována na území města Ústí nad Labem a Trmice. Od 1.1.2017 dále i město Chlumec a Chabařovice.	1340
633	3761	Služba je poskytována na území města Ústí nad Labem a Trmice. Od 1.1.2017 dále i město Chlumec a Chabařovice.	1341
633	3762	Služba je poskytována na území města Ústí nad Labem a Trmice. Od 1.1.2017 dále i město Chlumec a Chabařovice.	1342
633	3766	Služba je poskytována na území města Ústí nad Labem a Trmice. Od 1.1.2017 dále i město Chlumec a Chabařovice.	1343
631	3750	Služba je poskytována uživatelům drog, osobám ohroženým drogou a drogovou závislostí od 15 let a jejich rodinným příslušníkům.	1344
623	3751	Služba je určena osobám s Alzheimerovou, stařeckou a ostatními typy demencí. Služba není poskytována osobám s jinými typy chronického duševního onemocnění a osobám závislým na návykových látkách.	1345
614	3754	\N	1346
614	3755	\N	1347
614	3758	\N	1348
598	3754	Služba je poskytována osobám s mentálním nebo kombinovaným postižením, se středně těžkou až těžkou závislostí na pomoci jiné fyzické osoby, mobilním  a částečně imobilním osobám, které z důvodu snížené soběstačnosti nemohou  žít ve svém přirozeném sociálním prostředí.   Zařízení není vhodné pro osoby trvale upoutané na lůžko, nevidomé a neslyšící.	1349
598	3755	Služba je poskytována osobám s mentálním nebo kombinovaným postižením, se středně těžkou až těžkou závislostí na pomoci jiné fyzické osoby, mobilním  a částečně imobilním osobám, které z důvodu snížené soběstačnosti nemohou  žít ve svém přirozeném sociálním prostředí.   Zařízení není vhodné pro osoby trvale upoutané na lůžko, nevidomé a neslyšící.	1350
559	3765	\N	1351
558	3758	\N	1352
556	3753	Služba poskytována osobám s jiným zdravotním postižením - s poruchou autistického spektra od 3 do 18 let věku. Horní věková hranice se netýká stávajícíh klientů (kapacita 6 lůžek) - účinnost od 01. 09. 2020	1353
556	3754	Služba je poskytována osobám s kombinovaným a mentálním postižením od 3 - 43 let věku. Horní věková hranice se netýká stávajících klientů (25 lůžek).	1354
556	3755	Služba je poskytována osobám s kombinovaným a mentálním postižením od 3 - 43 let věku. Horní věková hranice se netýká stávajících klientů (25 lůžek).	1355
554	3754	\N	1356
554	3755	\N	1357
506	3755	\N	1358
506	3756	\N	1359
473	3765	Služba je poskytována osobám, které pro jsou pro trvalé změny zdravotního stavu závislé na pomoci jiné fyzické osoby. Vymezení věkové struktury se netýká osob, které měly ke dni 31. 12. 2018 uzavřenu smlouvu o poskytování sociální služby domovy pro osoby se zdravotním postižením (identifikátor 4860158) a ke dni 01. 01. 2019 podepsaly smlouvu o poskytování sociální služby domovy pro seniory (identifikátor 2744287).	1360
466	3747	Služba nemůže být poskytována osobám imobilním.\nSlužba je určena ženám s dětmi, těhotným ženám a ženám, které mají dítě svěřené do péče, nebo pečují o dítě v přímé linii, nebo o sourozence, jejichž situace je spojena se ztrátou bydlení.	1361
465	3752	Terénní sociální služba je poskytována dle potřeb uživatelů na území města Chomutov, jeho spádových obcí, města Jirkov a jeho spádových obcí.	1362
465	3755	Terénní sociální služba je poskytována dle potřeb uživatelů na území města Chomutov, jeho spádových obcí, města Jirkov a jeho spádových obcí.	1363
465	3758	Terénní sociální služba je poskytována dle potřeb uživatelů na území města Chomutov, jeho spádových obcí, města Jirkov a jeho spádových obcí.	1364
465	3765	Terénní sociální služba je poskytována dle potřeb uživatelů na území města Chomutov, jeho spádových obcí, města Jirkov a jeho spádových obcí.	1365
465	3764	Terénní sociální služba je poskytována dle potřeb uživatelů na území města Chomutov, jeho spádových obcí, města Jirkov a jeho spádových obcí.	1366
465	3753	Terénní sociální služba je poskytována dle potřeb uživatelů na území města Chomutov, jeho spádových obcí, města Jirkov a jeho spádových obcí.	1367
465	3754	Terénní sociální služba je poskytována dle potřeb uživatelů na území města Chomutov, jeho spádových obcí, města Jirkov a jeho spádových obcí.	1368
464	3752	Služba je poskytována osobám na území města Liberec, Frýdlant a jeho spádových obcí a na území města Nové město pod Smrkem a jeho spádových obcí..	1369
464	3758	Služba je poskytována osobám na území města Liberec, Frýdlant a jeho spádových obcí a na území města Nové město pod Smrkem a jeho spádových obcí..	1370
464	3765	Služba je poskytována osobám na území města Liberec, Frýdlant a jeho spádových obcí a na území města Nové město pod Smrkem a jeho spádových obcí..	1371
464	3755	Služba je poskytována osobám na území města Liberec, Frýdlant a jeho spádových obcí a na území města Nové město pod Smrkem a jeho spádových obcí..	1372
464	3764	Služba je poskytována osobám na území města Liberec, Frýdlant a jeho spádových obcí a na území města Nové město pod Smrkem a jeho spádových obcí..	1373
463	3752	Terénní služba je poskytovaná dle potřeb uživatelů na území města Mnichovo Hradiště a jeho spádových obcí, města Bakov nad Jizerou a jeho spádových obcí, města Mladá Boleslav a jeho spádových obcí.	1374
463	3758	Terénní služba je poskytovaná dle potřeb uživatelů na území města Mnichovo Hradiště a jeho spádových obcí, města Bakov nad Jizerou a jeho spádových obcí, města Mladá Boleslav a jeho spádových obcí.	1375
463	3765	Terénní služba je poskytovaná dle potřeb uživatelů na území města Mnichovo Hradiště a jeho spádových obcí, města Bakov nad Jizerou a jeho spádových obcí, města Mladá Boleslav a jeho spádových obcí.	1376
463	3764	Terénní služba je poskytovaná dle potřeb uživatelů na území města Mnichovo Hradiště a jeho spádových obcí, města Bakov nad Jizerou a jeho spádových obcí, města Mladá Boleslav a jeho spádových obcí.	1377
460	3765	Sociální služba je poskytována osobám mladším 65 let věku výjimečně pouze u stávajících uživatelů služby. Další osoby mladší 65 let věku již nebudou do služby přijímány.	1378
415	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy. Zařízení nejsou bezbariérová.	1379
414	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy. Zařízení nejsou bezbariérová.	1380
413	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy. Zařízení není bezbariérové.	1381
413	3753	Služba je poskytována osobám s jiným zdravotním postižením, jako např. s civilizačním, interním nebo smyslovým onemocněním. Zařízení není bezbariérové.	1382
412	3751	Služba je určena osobám s duševním onemocněním z okruhu psychóz, jako jsou např. schizofrenie, bipolární porucha a hraniční stavy. Zařízení nejsou bezbariérová.	1383
412	3753	Služba je určena osobám s jiným zdravotním postižením, jako např. s civilizačním, interním nebo smyslovým onemocněním. Zařízení není bezbariérové.	1384
404	3751	\N	1385
404	3758	Osoby se zdravotním postižením mimo osob hluchoslepých.	1386
404	3765	\N	1387
403	3758	Osoby se zdravotním postižením mimo osob hluchoslepých.\nSociální služba je poskytována osobám na území města Roudnice nad Labem a jejího spádového území.	1388
403	3765	\N	1389
403	3752	\N	1390
403	3764	\N	1391
390	3754	\N	1392
390	3755	\N	1393
390	3753	Z okruhu osob: osoby s jiným zdravotním postižením je služba poskytována pouze osobám s poruchou autistického spektra (celkem 4 lůžka z celkové kapacity služby).	1394
348	3754	Služba je poskytována osobám s tělesným či smyslovým postižením v kombinaci s mentálním postižením.	1395
348	3755	Služba je poskytována osobám s tělesným či smyslovým postižením v kombinaci s mentálním postižením.	1396
344	3744	Sociální služba je poskytována ženám a matkám od 18 let s nezaopatřenými dětmi z Ústeckého kraje zejména z oblasti Mostu a jeho okolí.(52 lůžek). Dále je služba určena těhotným ženám od 17 let věku, které jsou umístěny na základě doporučení OSPOD (2 lůžka).	1398
344	3747	Sociální služba je poskytována ženám a matkám od 18 let s nezaopatřenými dětmi z Ústeckého kraje zejména z oblasti Mostu a jeho okolí.(52 lůžek). Dále je služba určena těhotným ženám od 17 let věku, které jsou umístěny na základě doporučení OSPOD (2 lůžka).	1399
312	3756	\N	1400
312	3758	\N	1401
311	3765	\N	1402
305	3758	Sociální služba je poskytována dle potřeb uživatelů na území města Litoměřice a v okruhu do 15 km od města Litoměřice.	1403
305	3764	Sociální služba je poskytována dle potřeb uživatelů na území města Litoměřice a v okruhu do 15 km od města Litoměřice.	1404
305	3765	Sociální služba je poskytována dle potřeb uživatelů na území města Litoměřice a v okruhu do 15 km od města Litoměřice.	1405
305	3751	Sociální služba je poskytována dle potřeb uživatelů na území města Litoměřice a v okruhu do 15 km od města Litoměřice.	1406
305	3752	Sociální služba je poskytována dle potřeb uživatelů na území města Litoměřice a v okruhu do 15 km od města Litoměřice.	1407
305	3756	Sociální služba je poskytována dle potřeb uživatelů na území města Litoměřice a v okruhu do 15 km od města Litoměřice.	1408
305	3757	Sociální služba je poskytována dle potřeb uživatelů na území města Litoměřice a v okruhu do 15 km od města Litoměřice.	1409
305	3759	Sociální služba je poskytována dle potřeb uživatelů na území města Litoměřice a v okruhu do 15 km od města Litoměřice.	1410
302	3765	Sociální služba je poskytována osobám mladším 65 let věku vyjímečně, pouze u stávajících uživatelů služby. Další osoby mladší 65 let věku již nebudou do služby přijímány.	1411
301	3747	Sociální služba je poskytována fyzicky soběstačným mužům. Sociální službu nelze poskytovat osobám, jejichž zdravotní stav vyžaduje bezbariérový vstup do zařízení.	1412
300	3747	Sociální služba je poskytována fyzicky soběstačným mužům. Sociální službu nelze poskytovat osobám, jejichž zdravotní stav vyžaduje bezbariérový vstup do zařízení.	1413
299	3747	Sociální služba se neposkytuje osobám, jejichž zdravotní stav vyžaduje bezbariérový vstup do zařízení a pohyb v něm. Sociální služba se poskytuje osobám na území města Litoměřice. Terénní služba se poskytuje max. 50 hod./měsíčně, dle potřeb užvatelů.	1414
276	3754	Sociální služba je poskytována osobám s různým stupněm mentálního postižení a osobám s mentálním postižením v  kombinaci s  tělesným nebo smyslovým postižením.	1415
276	3755	Sociální služba je poskytována osobám s různým stupněm mentálního postižení a osobám s mentálním postižením v  kombinaci s  tělesným nebo smyslovým postižením.	1416
276	3758	Sociální služba je poskytována osobám s různým stupněm mentálního postižení a osobám s mentálním postižením v  kombinaci s  tělesným nebo smyslovým postižením.	1417
244	3756	Služba je poskytována na území města Šluknov.	1418
244	3765	Služba je poskytována na území města Šluknov	1419
213	3758	Terénní služba poskytovaná dle potřeb uživatelů na území města Chomutova a jeho spádových obcí.	1420
213	3765	Terénní služba poskytovaná dle potřeb uživatelů na území města Chomutova a jeho spádových obcí.	1421
213	3752	Terénní služba poskytovaná dle potřeb uživatelů na území města Chomutova a jeho spádových obcí.	1422
213	3764	Terénní služba poskytovaná dle potřeb uživatelů na území města Chomutova a jeho spádových obcí.	1423
212	3754	Služba je určena osobám s mentálním postižením, u nichž se může vyskytovat i jiné zdravotní postižení.	1424
212	3755	Služba je určena osobám s mentálním postižením, u nichž se může vyskytovat i jiné zdravotní postižení.	1425
210	3747	Sociální služba je určena pro muže, ženy, matky a ženy s dětmi.	1426
210	3760	Sociální služba je určena osobám v krizi spojené se ztrátou bydlení, pro muže, ženy, matky a ženy s dětmi, rodiny s dětmi.	1427
209	3760	terénní forma služby je poskytována na území města Chomutov a jeho spádových obcí	1428
208	3754	\N	1429
208	3755	\N	1430
207	3765	Sociální služba je určena seniorům od 60 let věku.	1431
164	3765	Služba je určena pro seniory od 63 let věku.	1432
163	3758	Terénní služba poskytovaná dle potřeb uživatelů na území města Žatce v dojezdové vzdálenosti 12 km od hranice města.	1433
163	3765	Terénní služba poskytovaná dle potřeb uživatelů na území města Žatce v dojezdové vzdálenosti 12 km od hranice města.	1434
163	3752	Terénní služba poskytovaná dle potřeb uživatelů na území města Žatce v dojezdové vzdálenosti 12 km od hranice města.	1435
163	3764	Terénní služba poskytovaná dle potřeb uživatelů na území města Žatce v dojezdové vzdálenosti 12 km od hranice města.	1436
131	3754	\N	1437
131	3755	\N	1438
130	3754	\N	1439
130	3755	\N	1440
100	3758	Služba je poskytována na území města Varnsdorf.	1441
100	3765	Služba je poskytována na území města Varnsdorf.	1442
100	3752	\N	1443
100	3754	\N	1444
100	3764	\N	1445
98	3752	\N	1446
98	3753	\N	1447
98	3755	\N	1448
98	3756	\N	1449
98	3765	\N	1450
97	3751	Služba je poskytována osobám s Alzheimerovou chorobou a jinými typy stařeckých demencí.	1451
97	3752	\N	1452
97	3755	\N	1453
97	3756	\N	1454
97	3758	\N	1455
97	3765	\N	1456
96	3758	Služba je poskytována na území města Teplice, Dubí, Proboštov, Novosedlice.	1457
96	3765	Služba je poskytována na území města Teplice, Dubí, Proboštov, Novosedlice.	1458
96	3752	Služba je poskytována na území města Teplice, Dubí, Proboštov, Novosedlice.	1459
96	3764	Služba je poskytována na území města Teplice, Dubí, Proboštov, Novosedlice.	1460
85	3756	Terénní služba je poskytována dle potřeb uživatelů v Klášterci nad Ohří a jeho obecních částech Miřetice u Klášterce nad Ohří, Ciboušov, Klášterecká Jeseň, Suchý Důl, Hradiště, \nLestkov, Mikulovice, Rašovice, Útočiště, Šumná, Vernéřov).	1461
85	3758	Terénní služba je poskytována dle potřeb uživatelů v Klášterci nad Ohří a jeho obecních částech Miřetice u Klášterce nad Ohří, Ciboušov, Klášterecká Jeseň, Suchý Důl, Hradiště, \nLestkov, Mikulovice, Rašovice, Útočiště, Šumná, Vernéřov).	1462
85	3764	Terénní služba je poskytována dle potřeb uživatelů v Klášterci nad Ohří a jeho obecních částech Miřetice u Klášterce nad Ohří, Ciboušov, Klášterecká Jeseň, Suchý Důl, Hradiště, \nLestkov, Mikulovice, Rašovice, Útočiště, Šumná, Vernéřov).	1463
85	3765	Terénní služba je poskytována dle potřeb uživatelů v Klášterci nad Ohří a jeho obecních částech Miřetice u Klášterce nad Ohří, Ciboušov, Klášterecká Jeseň, Suchý Důl, Hradiště, \nLestkov, Mikulovice, Rašovice, Útočiště, Šumná, Vernéřov).	1464
85	3751	Terénní služba je poskytována dle potřeb uživatelů v Klášterci nad Ohří a jeho obecních částech Miřetice u Klášterce nad Ohří, Ciboušov, Klášterecká Jeseň, Suchý Důl, Hradiště, \nLestkov, Mikulovice, Rašovice, Útočiště, Šumná, Vernéřov).	1465
84	3765	\N	1466
26	3765	Služba je poskytována osobám závislým na pomoci jiné fyzické osoby ve věku od 60 let.	1467
\.


--
-- Data for Name: socialservice; Type: TABLE DATA; Schema: public; Owner: backend
--

COPY public.socialservice (source_service_id, identifier, provider_id, provider_name, provider_ico, service_type_id, active_from, active_to, region_scope_by_address, id) FROM stdin;
7555	6463210	2606	Dobrodějna, z.ú.	21125571	3864	2026-01-01	\N	f	1
7554	1723384	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3867	2026-01-01	\N	f	2
7553	1110760	193	Charita Litoměřice	46769382	3842	2026-01-01	\N	f	3
7527	9116588	391	DRUG-OUT Klub, z.s.	44554559	11078	2026-01-01	\N	f	4
7524	8480411	2654	SK Teplice, zapsaný spolek	26645939	3862	2026-02-16	\N	f	5
7523	4969657	2654	SK Teplice, zapsaný spolek	26645939	3836	2026-02-16	\N	f	6
7517	6257673	752	Arkadie, o. p. s.	00556203	3844	2025-07-01	\N	f	7
7480	9122682	2638	PORADNA BAREVNÉ SOUŽITÍ, z.s.	01363662	3862	2026-01-01	\N	f	8
7432	6170781	2083	Sdružení na ochranu ohrožených dětí, z.s.	04648293	3862	2025-11-01	\N	t	9
7415	5955053	1583	Senevida Delta s.r.o.	26104822	3847	2026-01-01	\N	f	10
7413	8203436	1583	Senevida Delta s.r.o.	26104822	3848	2026-01-01	\N	f	11
7405	5476963	895	Charita Most	70828920	3854	2007-01-01	\N	f	12
7391	1523294	2627	SESTŘIČKA.CZ - PEČOVATELKA z.ú.	07590369	3842	2026-03-01	\N	t	13
7380	9400292	2622	PARENT PROJECT, z. s.	26540401	3836	2026-02-01	\N	t	14
7377	8756402	270	Fokus Labe, z.ú.	44226586	11078	2026-01-01	\N	f	15
7376	9897021	270	Fokus Labe, z.ú.	44226586	11078	2026-01-01	\N	f	16
7370	3617098	205	MOSŤÁČEK.CZ, z. s.	26595575	3842	2026-04-01	\N	f	17
7361	8099754	440	Pečovatelská služba Ústí nad Labem, příspěvková organizace	44555385	3843	2026-01-01	\N	f	18
7357	6527105	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3867	2026-01-01	\N	f	19
7356	4824949	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3867	2026-01-01	\N	f	20
7349	7262751	205	MOSŤÁČEK.CZ, z. s.	26595575	3836	2026-07-01	\N	f	21
7341	3785810	1990	Bateau	01507311	3867	2026-05-01	\N	f	22
7338	3050585	2611	Společně DOMA, z.ú.	23185163	3838	2026-07-01	\N	f	23
7335	6566294	792	Sociální služby města Loun, příspěvková organizace	60275847	3848	2026-01-01	\N	f	24
7334	7789120	792	Sociální služby města Loun, příspěvková organizace	60275847	3847	2026-01-01	\N	f	25
7332	9692271	270	Fokus Labe, z.ú.	44226586	11078	2025-09-01	\N	f	26
7331	4789208	270	Fokus Labe, z.ú.	44226586	11078	2025-11-01	\N	f	27
7330	9742723	270	Fokus Labe, z.ú.	44226586	11078	2025-09-01	\N	f	28
7324	3895032	2606	Dobrodějna, z.ú.	21125571	3864	2027-01-01	\N	f	29
7306	5469361	391	DRUG-OUT Klub, z.s.	44554559	3836	2023-07-01	\N	f	30
7305	7863499	435	Romano jasnica, spolek	68974922	3859	2025-01-01	\N	f	31
7293	1276747	2597	INSTITUT AK, z. s.	22176951	3836	2025-04-01	\N	f	32
7292	3148305	440	Pečovatelská služba Ústí nad Labem, příspěvková organizace	44555385	3836	2022-12-01	\N	f	33
7271	9436491	1764	K srdci klíč, o. p. s.	27000222	3836	2025-07-01	2028-06-30	f	34
7269	7103322	416	Městská správa sociálních služeb Kadaň	65642481	3848	2025-11-01	\N	f	35
7247	9046618	1409	NADĚJE	00570931	3862	2025-01-01	\N	f	36
7246	1460119	895	Charita Most	70828920	3848	2026-04-01	\N	f	37
7205	9027334	864	Charita Česká Kamenice	70818134	3867	2025-01-01	\N	f	38
7187	5511886	680	Agentura Pondělí, z.s.	26537788	3844	2025-01-01	\N	f	39
7184	9697878	399	Domov pro osoby se zdravotním postižením Kytlice	70872708	3849	2025-01-01	\N	t	40
7139	7566486	2565	DS Střekov s.r.o.	09578285	3847	2024-09-01	\N	f	41
7134	9978089	2563	Dětské centrum Ústeckého kraje, příspěvková organizace	00830577	3846	2025-01-01	\N	f	42
7133	2996141	1913	Vavřinec z. s.	01539353	3836	2025-06-01	\N	f	43
7131	9295584	961	VALDEK, o.p.s.	25444972	3864	2025-01-01	\N	f	44
7129	6786081	560	Podkrušnohorské domovy sociálních služeb Dubí - Teplice, příspěvková organizace	63787849	3848	2025-01-01	\N	f	45
7128	8391115	205	MOSŤÁČEK.CZ, z. s.	26595575	3844	2025-09-01	\N	f	46
7113	7597550	2557	Habition, z. s.	19113749	3867	2025-07-01	\N	f	47
7110	1387360	2506	HZ Pohoda s.r.o.	17440173	3847	2024-08-01	\N	f	48
7105	9327852	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3846	2025-01-01	\N	f	49
7103	3629082	228	Diakonie ČCE - Středisko sociální pomoci v Mostě	70863601	3867	2025-01-01	\N	f	50
7057	3774283	2543	Domov Potoky, z.ú.	19495056	3848	2024-01-01	\N	t	51
7056	8394608	2543	Domov Potoky, z.ú.	19495056	3848	2024-01-01	\N	f	52
7027	4461324	448	Město Štětí	00264466	3862	2024-02-01	\N	f	53
6966	7830493	205	MOSŤÁČEK.CZ, z. s.	26595575	3862	2024-01-01	\N	f	54
6955	3796317	2512	Spolek Domácí péče Valerie	11766891	3842	2024-01-01	\N	f	55
6945	3749548	2506	HZ Pohoda s.r.o.	17440173	3838	2024-01-01	\N	f	56
6944	3213634	2506	HZ Pohoda s.r.o.	17440173	3848	2024-01-01	\N	f	57
6943	1178898	2506	HZ Pohoda s.r.o.	17440173	3847	2024-01-01	\N	f	58
6942	1802108	2506	HZ Pohoda s.r.o.	17440173	3847	2024-01-01	\N	f	59
6928	4008583	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3848	2024-01-01	\N	f	60
6925	4066440	142	Sociální služby Chomutov, příspěvková organizace	46789944	3844	2024-01-01	\N	f	61
6924	9548965	1409	NADĚJE	00570931	3867	2024-01-01	\N	f	62
6923	4526320	1409	NADĚJE	00570931	3867	2024-01-01	\N	f	63
6920	3824401	701	Charita Ústí nad Labem	44225512	3854	2024-01-01	\N	f	64
6885	9911998	2043	Asociace pracovní rehabilitace, z. ú.	26569558	3836	2023-07-01	\N	f	65
6884	1754696	71	Město Varnsdorf	00261718	3854	2024-01-01	\N	f	66
6882	6507914	1748	Cesta do světa, pobočný spolek Slunečnice, z.s.	72068396	3844	2023-01-01	\N	f	67
6868	5261039	2486	INSTITUT DUŠEVNÍHO ZDRAVÍ a FINANČNÍ POMOCI SOCIÁLNĚ SLABÝM RODINÁM, z. s.	05380260	3838	2023-03-09	\N	f	68
6806	8441162	2472	Sociální a zdravotní služby Teplice, z. s.	06575030	3846	2023-02-01	\N	f	69
6801	9337152	992	Domov Terezín	70875308	3849	2023-01-01	\N	t	70
6785	2835341	864	Charita Česká Kamenice	70818134	3859	2022-07-01	\N	f	71
5590	6268396	778	Světlo Kadaň z. s.	65650701	3859	2017-01-01	\N	f	144
6772	8026019	2467	Město Česká Kamenice	00261220	3866	2023-01-01	\N	f	72
6770	2344278	2466	Pečovatelská služba PAMPELIŠKA, z. ú.	17100488	3838	2022-07-01	\N	f	73
6768	7265619	2371	SOCIÁLNĚ PSYCHIATRICKÉ CENTRUM SLUNÍČKO z.ú.	08929815	3842	2023-01-01	\N	f	74
6761	8394620	895	Charita Most	70828920	3862	2022-08-05	\N	f	75
6760	9253322	895	Charita Most	70828920	3866	2007-01-01	\N	f	76
6587	5891759	229	Domov pro seniory Dobětice, příspěvková organizace	44555407	3842	2022-01-01	\N	f	77
6585	9322835	1764	K srdci klíč, o. p. s.	27000222	3867	2022-01-01	\N	f	78
6575	1480537	2039	Dům romské kultury o. p. s.	25441892	3862	2022-01-01	\N	f	79
6574	6744733	2351	ADP-ANNA s.r.o.	05744342	3842	2022-01-01	\N	t	80
6573	6598554	2351	ADP-ANNA s.r.o.	05744342	3838	2022-01-01	\N	f	81
6572	4515038	778	Světlo Kadaň z. s.	65650701	3859	2022-01-01	\N	f	82
6532	4238324	1409	NADĚJE	00570931	3867	2022-01-01	\N	f	83
6522	9886524	716	Spirála, Ústecký kraj, z. s.	68954221	3857	2021-08-01	\N	f	84
6518	5634705	282	Domov pro seniory Podbořany, příspěvková organizace	65650964	3838	2022-01-01	\N	f	85
6486	7961531	2407	Global Partner Péče, z.ú.	09903046	3842	2021-06-01	\N	f	86
6424	9869440	864	Charita Česká Kamenice	70818134	3848	2020-12-09	\N	f	87
6380	4640372	1528	Romodrom, o.p.s.	26537036	3836	2020-11-30	\N	t	88
6371	8149563	1409	NADĚJE	00570931	3860	2021-01-01	\N	f	89
6370	7116825	1409	NADĚJE	00570931	3858	2021-01-01	\N	f	90
6361	9548170	1460	Diakonie ČCE - Středisko celostátních programů a služeb	48136093	3851	2021-01-01	\N	t	91
6359	6782959	1836	Obrnické centrum sociálních služeb, příspěvková organizace	21551413	3859	2021-01-01	\N	f	92
6356	6958943	1631	TILIA Kadaň z.s.	22723030	3862	2021-01-01	\N	f	93
6352	8364418	895	Charita Most	70828920	3859	2020-08-01	\N	f	94
6345	2799038	2371	SOCIÁLNĚ PSYCHIATRICKÉ CENTRUM SLUNÍČKO z.ú.	08929815	3844	2020-06-18	\N	f	95
6316	7152294	1837	Sestřičky, s.r.o.	28736133	3847	2020-04-01	\N	f	96
6307	7712870	1764	K srdci klíč, o. p. s.	27000222	3858	2020-01-01	\N	f	97
6303	2628518	2364	Domov Alzheimer Most z. ú.	04654374	3848	2020-02-24	\N	f	98
6266	1510155	2351	ADP-ANNA s.r.o.	05744342	3847	2020-01-01	\N	f	99
6264	7700198	1764	K srdci klíč, o. p. s.	27000222	3866	2020-01-01	\N	f	100
6261	4596497	2349	Sociální bydlení Sever, z.s.	05522439	3836	2019-11-20	\N	f	101
6145	9994728	2243	SDZP družstvo	25476092	3867	2019-10-31	\N	t	102
6144	8380362	2243	SDZP družstvo	25476092	3836	2019-10-31	\N	t	103
6116	8059446	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3848	2020-01-01	\N	f	104
6084	2417772	193	Charita Litoměřice	46769382	3842	2020-01-01	\N	f	105
6083	6780298	270	Fokus Labe, z.ú.	44226586	3849	2020-01-01	\N	f	106
6080	7717165	93	Domovy sociálních služeb Háj a Nová Ves, příspěvková organizace	63787911	3846	2020-01-01	\N	f	107
6077	5464128	611	Květina z. s.	27038645	3858	2020-01-01	\N	f	108
6075	2547969	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3849	2020-01-01	\N	f	109
6073	5872914	895	Charita Most	70828920	3866	2020-01-01	\N	f	110
6053	9512421	2222	Sociální služby města Lovosice, příspěvková organizace	08183571	3838	2019-07-01	\N	f	111
6038	2274212	435	Romano jasnica, spolek	68974922	3859	2019-07-01	\N	f	112
6027	9225752	2152	Spolek pro integraci menšin	04268351	3866	2019-02-13	\N	f	113
5938	9317585	270	Fokus Labe, z.ú.	44226586	3867	2019-01-01	\N	f	114
5937	6105987	270	Fokus Labe, z.ú.	44226586	3867	2019-01-01	\N	f	115
5935	4103239	270	Fokus Labe, z.ú.	44226586	3867	2019-01-01	\N	f	116
5934	2882507	270	Fokus Labe, z.ú.	44226586	3867	2019-01-01	\N	f	117
5917	8610809	2050	AHC Senior centrum Meziboří s. r. o.	47310189	3838	2018-09-01	\N	f	118
5904	5321665	1694	Kostka Krásná Lípa, p.o.	75139090	3837	2019-01-01	\N	t	119
5903	9936300	891	Most k naději, z. s.	63125137	3857	2019-01-01	\N	f	120
5901	2322456	1776	Psychiatrická léčebna Petrohrad, příspěvková organizace	00829137	3849	2019-01-01	\N	f	121
5899	3225275	231	Domov Bez zámků Tuchořice, příspěvková organizace	00830381	3849	2019-01-01	\N	f	122
5892	5323100	340	Domovy sociálních služeb Kadaň a Mašťov, příspěvková organizace	46789910	3849	2019-01-01	\N	f	123
5825	9489149	2160	Valerie-Homecare, s. r. o.	06479600	3847	2018-01-09	\N	f	124
5787	9422230	1764	K srdci klíč, o. p. s.	27000222	3854	2018-01-01	\N	f	125
5775	9399765	800	Prosapia, z.ú., společnost pro rodinu	69411239	3859	2018-01-01	\N	f	126
5774	9308341	1770	Indigo Děčín, z.s.	68975244	3866	2018-01-01	\N	t	127
5764	4632012	2148	Centrum Chůvička, z. s.	01588982	3836	2018-01-01	\N	f	128
5755	6143976	1776	Psychiatrická léčebna Petrohrad, příspěvková organizace	00829137	3867	2018-01-01	\N	f	129
5754	3514586	2146	Uzlík Litvínov, z. ú.	06081673	3864	2018-01-01	\N	f	130
5753	2450357	895	Charita Most	70828920	3862	2018-01-01	\N	f	131
5745	6778323	1397	Armáda spásy v České republice, z.s.	40613411	3854	2018-01-01	\N	f	132
5744	1410545	1397	Armáda spásy v České republice, z.s.	40613411	3860	2018-01-01	\N	f	133
5712	1819216	2136	Zdravotní sestry a pečovatelky s. r. o.	28716736	3838	2017-04-01	\N	f	134
5708	9258026	391	DRUG-OUT Klub, z.s.	44554559	3836	2017-05-01	\N	f	135
5707	1953437	391	DRUG-OUT Klub, z.s.	44554559	3866	2017-07-01	\N	t	136
5697	6514992	954	Agentura Osmý den, o. p. s.	26667649	3836	2017-07-01	\N	f	137
5694	7544686	895	Charita Most	70828920	3866	2017-07-01	\N	f	138
5676	2898140	1897	STATUTÃRNÃ MÄSTO MOST	00266094	3859	2017-01-01	\N	f	139
5661	2794196	1672	OblastnÃ­ spolek ÄeskÃ©ho ÄervenÃ©ho kÅÃ­Å¾e DÄÄÃ­n	00426067	3848	2016-12-01	\N	f	140
5643	6661939	1872	Charita Å luknov	73635502	3859	2017-01-01	\N	f	141
5635	2827230	1764	K srdci klÃ­Ä, o. p. s.	27000222	3858	2017-01-01	\N	f	142
5591	1187850	71	Město Varnsdorf	00261718	3862	2017-01-01	\N	f	143
5568	4452113	1047	Sociální agentura, o. p. s.	26540495	3867	2017-01-01	\N	f	145
5552	1673951	1409	NADĚJE	00570931	3859	2017-01-01	\N	f	146
5544	7363041	1050	Šance Lovosice, z.s.	70809828	3864	2016-08-10	\N	f	147
5543	4121413	93	Domovy sociálních služeb Háj a Nová Ves, příspěvková organizace	63787911	3864	2017-01-01	\N	f	148
5542	9215872	864	Charita Česká Kamenice	70818134	3836	2016-08-01	\N	t	149
5539	1989766	1898	Masopust, z. s.	26604205	3867	2017-01-01	\N	f	150
5524	8464374	769	Charita Lovosice	46770321	3864	2017-01-01	\N	f	151
5437	2577955	183	Domovy sociálních služeb Litvínov, příspěvková organizace	49872541	3849	2016-02-01	\N	f	152
5436	7660838	891	Most k naději, z. s.	63125137	3836	2016-02-03	\N	f	153
5373	7964176	2051	Rekvalifikační a informační centrum s. r. o.	25438352	3836	2016-01-01	2026-06-30	f	154
5372	1474897	2051	Rekvalifikační a informační centrum s. r. o.	25438352	3862	2016-01-01	\N	f	155
5365	3132557	2050	AHC Senior centrum Meziboří s. r. o.	47310189	3847	2015-10-20	\N	f	156
5351	1499845	1764	K srdci klíč, o. p. s.	27000222	3860	2016-01-01	\N	f	157
5340	6772756	1409	NADĚJE	00570931	3836	2016-01-01	\N	f	158
5339	4534118	1409	NADĚJE	00570931	3866	2016-01-01	\N	f	159
5319	6288509	1047	Sociální agentura, o. p. s.	26540495	3836	2016-03-01	\N	f	160
5318	6251794	611	Květina z. s.	27038645	3862	2016-01-01	\N	f	161
5303	8611761	2043	Asociace pracovní rehabilitace, z. ú.	26569558	3863	2016-01-01	\N	f	162
5293	5153749	2039	Dům romské kultury o. p. s.	25441892	3859	2016-01-01	\N	f	163
5262	1351398	1913	Vavřinec z. s.	01539353	3854	2015-09-01	\N	f	164
5258	2197911	445	Domovy pro seniory Šluknov - Krásná Lípa, příspěvková organizace	47274573	3848	2016-01-01	\N	f	165
5179	2761662	183	Domovy sociálních služeb Litvínov, příspěvková organizace	49872541	3864	2015-05-01	\N	f	166
5178	3478916	1813	Centrum D8, o.p.s.	26681471	3836	2015-06-01	\N	f	167
5119	6765091	1990	Bateau	01507311	3836	2015-03-02	\N	t	168
5118	5322668	1989	Domov sv. Vincenta de Paul z.ú.	03385655	3854	2014-12-01	\N	f	169
5117	6631017	701	Charita Ústí nad Labem	44225512	3862	2015-01-01	\N	f	170
5093	3598308	1981	Spolek Kolem dokola	03070280	3863	2015-01-01	\N	f	171
5089	5370162	895	Charita Most	70828920	3859	2015-01-01	\N	f	172
5073	8349589	752	Arkadie, o. p. s.	00556203	3849	2015-01-01	\N	f	173
5048	5168000	475	Sociální služby Jiříkov, příspěvková organizace	47274581	3837	2014-02-06	\N	f	174
5047	9011520	193	Charita Litoměřice	46769382	3866	2014-08-18	\N	f	175
5043	7646043	1350	Helias Ústí nad Labem, o.p.s.	27324001	3844	2014-09-01	\N	f	176
5025	3072534	1409	NADĚJE	00570931	3849	2015-01-01	\N	f	177
5024	7055199	1409	NADĚJE	00570931	3849	2015-01-01	\N	f	178
5022	7256389	367	Domovy pro osoby se zdravotním postižením Oleška-Kamenice, příspěvková organizace	47274522	3849	2014-08-01	\N	f	179
4961	7212518	1422	Poradna pro občanství Občanská a lidská práva, z.s.	70100691	3862	2014-04-01	\N	f	180
4956	4181497	1952	Chráněné bydlení Pastelky o.p.s.	22772511	3837	2012-10-05	\N	f	181
4955	2732328	1952	Chráněné bydlení Pastelky o.p.s.	22772511	3849	2012-11-02	\N	f	182
4954	3532163	1952	Chráněné bydlení Pastelky o.p.s.	22772511	3841	2012-05-04	\N	f	183
4953	3687948	1951	SPZ Teplice z. s.	26671921	3862	2014-01-01	\N	f	184
4918	6102115	964	Člověk v tísni, o.p.s.	25755277	3859	2014-03-01	\N	f	185
4908	2711883	778	Světlo Kadaň z. s.	65650701	3859	2014-04-01	\N	t	186
4890	3230075	964	Člověk v tísni, o.p.s.	25755277	3859	2014-02-01	\N	f	187
4884	4830342	778	Světlo Kadaň z. s.	65650701	3866	2014-01-01	\N	f	188
4883	8557743	778	Světlo Kadaň z. s.	65650701	3866	2014-01-01	\N	t	189
4882	6172133	93	Domovy sociálních služeb Háj a Nová Ves, příspěvková organizace	63787911	3846	2014-01-01	\N	f	190
4881	7392909	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3836	2014-01-01	\N	f	191
4858	4100257	550	Domov sociálních služeb Meziboří, příspěvková organizace	49872516	3848	2014-01-01	\N	f	192
4857	9338405	1903	Kleja, z.s.	01181491	3866	2013-10-01	\N	f	193
4855	9817183	435	Romano jasnica, spolek	68974922	3862	2013-10-01	\N	f	194
4853	2714387	435	Romano jasnica, spolek	68974922	3862	2013-10-01	\N	f	195
4851	7975725	974	WHITE LIGHT I, z.ú.	64676803	3836	2014-01-01	\N	f	196
4850	5581231	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3864	2014-01-01	\N	f	197
4842	3793014	183	Domovy sociálních služeb Litvínov, příspěvková organizace	49872541	3848	2014-01-01	\N	f	198
4840	6538434	1898	Masopust, z. s.	26604205	3864	2014-01-01	\N	f	199
4838	9813289	778	Světlo Kadaň z. s.	65650701	3862	2013-09-16	\N	f	200
4837	4903149	778	Světlo Kadaň z. s.	65650701	3859	2013-09-13	\N	f	201
4830	3112502	1872	Charita Šluknov	73635502	3862	2013-09-16	\N	f	202
4810	6883390	1397	Armáda spásy v České republice, z.s.	40613411	3854	2014-01-01	\N	f	203
4809	9766509	1397	Armáda spásy v České republice, z.s.	40613411	3862	2014-01-01	\N	f	204
4808	2374792	1397	Armáda spásy v České republice, z.s.	40613411	3859	2014-01-01	\N	f	205
4783	5807228	700	JURTA, o.p.s.	63778718	3849	2014-01-01	\N	f	206
4781	1014491	435	Romano jasnica, spolek	68974922	3859	2013-10-08	\N	f	207
4716	8168410	1872	Charita Šluknov	73635502	3859	2013-01-01	\N	f	208
4704	5735295	864	Charita Česká Kamenice	70818134	3864	2013-01-01	\N	f	209
4703	2527440	864	Charita Česká Kamenice	70818134	3841	2013-01-01	\N	t	210
4702	6562208	1409	NADĚJE	00570931	3858	2013-01-01	\N	f	211
4701	5625611	1409	NADĚJE	00570931	3858	2013-01-01	\N	f	212
4693	7293077	93	Domovy sociálních služeb Háj a Nová Ves, příspěvková organizace	63787911	3849	2012-09-01	\N	f	213
4692	2026889	1837	Sestřičky, s.r.o.	28736133	3838	2012-08-24	\N	f	214
4688	7032621	926	Městský ústav sociálních služeb Jirkov, příspěvková organizace	46787682	3848	2013-01-01	\N	f	215
4687	9585709	1832	Vaše Harmonie, o.p.s.	22794581	3838	2012-09-01	\N	f	216
4681	9714246	282	Domov pro seniory Podbořany, příspěvková organizace	65650964	3842	2014-01-01	\N	f	217
4680	7285141	282	Domov pro seniory Podbořany, příspěvková organizace	65650964	3848	2014-01-01	\N	f	218
4678	6964061	778	Světlo Kadaň z. s.	65650701	3836	2013-08-01	\N	t	219
4673	9057704	1409	NADĚJE	00570931	3836	2013-09-02	\N	f	220
4665	3383589	895	Charita Most	70828920	3862	2013-09-01	\N	f	221
4649	8190994	895	Charita Most	70828920	3858	2013-04-08	\N	f	222
4627	5093498	1050	Å ance Lovosice, z.s.	70809828	3844	2013-04-01	\N	f	223
4624	5463800	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3849	2012-05-15	\N	f	224
4615	8541500	112	Domov pro seniory a pečovatelská služba v Žatci	00830411	3848	2012-06-01	\N	t	225
4597	9905305	1497	Maltézská pomoc, o.p.s.	26708451	3837	2012-05-01	\N	f	226
4594	2503341	1409	NADĚJE	00570931	3864	2013-03-01	\N	f	227
4587	6081367	769	Charita Lovosice	46770321	3854	2013-03-01	\N	f	228
4574	1657475	270	Fokus Labe, z.ú.	44226586	3867	2013-01-17	\N	f	229
4573	6303516	270	Fokus Labe, z.ú.	44226586	3867	2013-01-17	\N	f	230
4572	2925439	1409	NADĚJE	00570931	3860	2013-06-01	\N	t	231
4555	8696715	895	Charita Most	70828920	3859	2012-04-01	\N	t	232
4554	1807508	895	Charita Most	70828920	3859	2012-04-01	\N	t	233
4553	8501960	895	Charita Most	70828920	3859	2012-04-01	\N	f	234
4541	8897392	1836	Obrnické centrum sociálních služeb, příspěvková organizace	21551413	3866	2013-02-01	\N	f	235
4540	2868960	1836	Obrnické centrum sociálních služeb, příspěvková organizace	21551413	3862	2013-02-01	\N	f	236
4539	1991853	1836	Obrnické centrum sociálních služeb, příspěvková organizace	21551413	3859	2013-02-01	\N	f	237
4529	4715430	700	JURTA, o.p.s.	63778718	3864	2013-01-01	\N	f	238
4527	5070480	895	Charita Most	70828920	3836	2012-12-01	\N	f	239
4515	7406243	1422	Poradna pro občanství Občanská a lidská práva, z.s.	70100691	3859	2012-10-15	\N	f	240
4509	6087352	1409	NADĚJE	00570931	3849	2013-01-01	\N	t	241
4504	3395152	256	Domov Brtníky, příspěvková organizace	47274484	3849	2013-01-01	\N	f	242
4484	1158642	895	Charita Most	70828920	3862	2013-07-01	\N	f	243
4482	2597207	1836	Obrnické centrum sociálních služeb, příspěvková organizace	21551413	3836	2013-06-01	\N	f	244
4478	5336459	1894	HEZKÉ DOMY s.r.o.	24273449	3842	2013-05-28	\N	f	245
4475	5924567	1409	NADĚJE	00570931	3857	2013-07-01	\N	f	246
4474	4166865	1409	NADĚJE	00570931	3864	2013-06-01	\N	f	247
4473	2793191	964	Člověk v tísni, o.p.s.	25755277	3862	2014-03-01	\N	f	248
4470	6363165	1694	Kostka Krásná Lípa, p.o.	75139090	3859	2013-08-01	\N	f	249
4462	6343251	1874	Cinka, z.s.	22856838	3859	2012-07-01	\N	f	250
4461	1508034	1897	STATUTÁRNÍ MĚSTO MOST	00266094	3859	2012-07-02	\N	f	251
4456	8756058	416	Městská správa sociálních služeb Kadaň	65642481	3842	2012-07-01	\N	t	252
4455	1165395	825	Kamarád - LORM	00830437	3849	2012-07-11	\N	f	253
4449	3466024	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3849	2012-06-01	\N	f	254
4412	1256783	1409	NADĚJE	00570931	3859	2012-01-03	\N	f	255
4406	2179469	701	Charita Ústí nad Labem	44225512	3848	2012-01-01	\N	f	256
4375	4417327	891	Most k naději, z. s.	63125137	3856	2012-01-01	\N	f	257
4366	9806102	864	Charita Česká Kamenice	70818134	3849	2012-01-01	\N	f	258
4364	3593109	955	Agentura KROK, o.p.s.	27323498	3837	2012-01-01	\N	f	259
4344	4978879	1794	Kormidlo Šluknov o.p.s.	22881476	3864	2012-01-01	\N	f	260
4330	6987486	778	Světlo Kadaň z. s.	65650701	3859	2011-10-01	\N	f	261
4323	3492950	1791	KRUH pomoci, o.p.s.	28747330	3867	2012-04-01	\N	f	262
4301	9245039	1512	Humanitární sdružení PERSPEKTIVA, z.s.	62768841	3867	2012-01-01	\N	f	263
4300	9763724	1764	K srdci klíč, o. p. s.	27000222	3855	2012-01-01	\N	f	264
4298	1220799	891	Most k naději, z. s.	63125137	3855	2011-10-01	\N	f	265
4284	4265731	270	Fokus Labe, z.ú.	44226586	3863	2012-01-01	\N	f	266
4282	3097184	270	Fokus Labe, z.ú.	44226586	3863	2012-01-01	\N	f	267
4265	3190373	1422	Poradna pro občanství Občanská a lidská práva, z.s.	70100691	3862	2010-03-01	\N	f	268
4263	7160480	1422	Poradna pro občanství Občanská a lidská práva, z.s.	70100691	3862	2011-03-01	\N	f	269
4262	2230344	1422	Poradna pro občanství Občanská a lidská práva, z.s.	70100691	3866	2011-03-01	\N	f	270
4238	7051562	475	Sociální služby Jiříkov, příspěvková organizace	47274581	3848	2011-05-20	\N	f	271
4236	9923023	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3848	2011-06-01	\N	f	272
4235	5748930	1764	K srdci klíč, o. p. s.	27000222	3854	2011-06-01	\N	f	273
4234	9925245	994	Městská správa sociálních služeb Vejprty, příspěvková organizace	46789863	3849	2011-07-01	\N	f	274
4220	5222616	227	Mgr. Lucie Jursíková Brožková	75100967	3842	2011-04-28	\N	f	275
4219	5957695	227	Mgr. Lucie Jursíková Brožková	75100967	3838	2011-04-28	\N	f	276
4217	6455949	1764	K srdci klíč, o. p. s.	27000222	3860	2011-05-01	\N	f	277
4209	9082399	1770	Indigo Děčín, z.s.	68975244	3859	2011-04-01	\N	f	278
4205	7734108	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3849	2011-04-01	\N	f	279
4195	2501932	144	Domov pro seniory Severní Terasa, příspěvková organizace	44555326	3848	2011-02-01	\N	f	280
4189	3827499	1694	Kostka Krásná Lípa, p.o.	75139090	3836	2011-02-01	\N	f	281
4188	3153600	1694	Kostka Krásná Lípa, p.o.	75139090	3862	2011-02-01	\N	f	282
4178	8836274	1764	K srdci klíč, o. p. s.	27000222	3854	2011-01-04	\N	f	283
4172	5624320	193	Charita Litoměřice	46769382	3848	2011-01-01	\N	f	284
4160	2550019	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3864	2011-01-01	\N	f	285
4152	4605047	1758	Domov harmonie a klidu s. r. o.	24713589	3848	2010-11-01	\N	f	286
4148	4047865	1757	Důstojný život - centrum pro zdravotně postižené, o.p.s.	28722043	3837	2011-02-01	\N	f	287
4133	7012291	340	Domovy sociálních služeb Kadaň a Mašťov, příspěvková organizace	46789910	3848	2011-01-01	\N	f	288
4110	3356067	1748	Cesta do světa, pobočný spolek Slunečnice, z.s.	72068396	3864	2011-01-01	\N	t	289
4109	2282970	1748	Cesta do světa, pobočný spolek Slunečnice, z.s.	72068396	3867	2011-01-01	\N	f	290
4105	6223146	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3847	2011-01-01	\N	f	291
4104	8522670	895	Charita Most	70828920	3867	2010-10-02	\N	f	292
4095	3801846	891	Most k naději, z. s.	63125137	3856	2010-10-01	\N	f	293
4094	6384214	891	Most k naději, z. s.	63125137	3836	2011-02-01	\N	f	294
4091	6580078	481	Oblastní spolek Českého červeného kříže Teplice	00426130	3848	2010-09-13	\N	f	295
4064	1916764	891	Most k naději, z. s.	63125137	3861	2011-01-01	\N	f	296
4060	6917580	1441	Poradna pro integraci, z.ú.	67362621	3862	2010-09-01	\N	t	297
4028	5350551	475	Sociální služby Jiříkov, příspěvková organizace	47274581	3838	2010-07-01	\N	f	298
4012	6963367	1733	Městská knihovna Louny, příspěvková organizace	65108477	3864	2010-08-01	\N	f	299
4004	1074769	1409	NADĚJE	00570931	3866	2010-06-01	\N	f	300
3990	5124068	1727	Město Litvínov	00266027	3862	2010-06-01	\N	f	301
3989	1901050	1727	Město Litvínov	00266027	3866	2010-06-01	\N	f	302
3969	6572053	1671	CEDR - komunitní spolek	26590735	3866	2010-04-01	\N	f	303
3936	2862640	1599	Domov pro seniory Vroutek, příspěvková organizace	68454864	3848	2010-04-01	\N	f	304
3916	6394439	435	Romano jasnica, spolek	68974922	3859	2010-01-01	\N	f	305
3915	3775974	891	Most k naději, z. s.	63125137	3866	2010-01-06	\N	t	306
3905	8791049	367	Domovy pro osoby se zdravotním postižením Oleška-Kamenice, příspěvková organizace	47274522	3846	2010-01-01	\N	f	307
3902	5829590	611	Květina z. s.	27038645	3866	2010-01-01	\N	f	308
3892	2987242	485	Diakonie ČCE - Středisko křesťanské pomoci v Litoměřicích	46768041	3841	2010-01-01	\N	f	309
3880	5945195	962	Charita Teplice	70806837	3862	2009-11-01	\N	f	310
3841	4257675	1409	NADĚJE	00570931	3854	2010-01-01	\N	t	311
3840	1294772	752	Arkadie, o. p. s.	00556203	3842	2010-01-01	\N	f	312
3839	6392422	698	Charita Roudnice nad Labem	62769111	3862	2009-10-01	\N	t	313
3838	1534371	979	ENERGIE o.p.s.	25034545	3849	2009-10-01	\N	f	314
3787	5238851	229	Domov pro seniory Dobětice, příspěvková organizace	44555407	3848	2010-01-01	\N	f	315
3784	6395067	926	Městský ústav sociálních služeb Jirkov, příspěvková organizace	46787682	3836	2010-01-01	\N	f	316
3783	2740854	1672	Oblastní spolek Českého červeného kříže Děčín	00426067	3838	2009-08-01	\N	t	317
3780	5108266	1671	CEDR - komunitní spolek	26590735	3854	2009-08-01	\N	f	318
3758	8322579	448	Město Štětí	00264466	3844	2009-07-01	\N	f	319
3757	6774569	448	Město Štětí	00264466	3842	2009-07-01	\N	f	320
3751	9772872	1640	Salesiánské středisko volného času Teplice	65607368	3859	2009-07-01	\N	f	321
3746	5486070	778	Světlo Kadaň z. s.	65650701	3859	2009-07-01	\N	f	322
3745	2570590	895	Charita Most	70828920	3859	2009-07-01	\N	f	323
3744	5361940	895	Charita Most	70828920	3836	2009-07-01	\N	f	324
3731	9593299	1409	NADĚJE	00570931	3862	2009-07-01	\N	t	325
3730	8090360	1409	NADĚJE	00570931	3860	2009-07-01	\N	f	326
3729	3778962	1409	NADĚJE	00570931	3854	2009-07-01	\N	t	327
3728	9980976	1303	Integrované centrum pro osoby se zdravotním postižením Horní Poustevna	70872686	3864	2009-06-01	\N	t	328
3725	1012725	895	Charita Most	70828920	3859	2009-07-01	\N	f	329
3710	8583484	895	Charita Most	70828920	3836	2009-04-04	\N	f	330
3693	6027304	964	Člověk v tísni, o.p.s.	25755277	3862	2009-03-01	\N	t	331
3686	7334865	825	Kamarád - LORM	00830437	3864	2009-02-23	\N	f	332
3673	3306857	680	Agentura Pondělí, z.s.	26537788	3841	2009-02-01	\N	f	333
3638	9873560	973	Domov pro seniory a pečovatelská služba Česká Kamenice, příspěvková organizace	47274565	3838	2009-01-01	\N	f	334
3622	4076320	1486	HEWER, z.s.	66000653	3837	2008-10-01	\N	t	335
3620	7425112	1640	Salesiánské středisko volného času Teplice	65607368	3862	2009-01-01	\N	f	336
3602	1066993	1631	TILIA Kadaň z.s.	22723030	3836	2009-04-01	\N	f	337
3599	8647982	62	Městský ústav sociálních služeb Klášterec nad Ohří, příspěvková organizace	65082125	3842	2008-11-01	\N	f	338
3584	9702329	955	Agentura KROK, o.p.s.	27323498	3867	2009-01-01	\N	f	339
3567	8907909	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3849	2009-01-01	\N	f	340
3565	5171989	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3846	2009-01-01	\N	f	341
3564	1201084	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3844	2009-01-01	\N	f	342
3563	9553549	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3846	2009-01-01	\N	f	343
3562	5666980	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3846	2009-01-01	\N	f	344
3561	8643214	1624	Domovy pro osoby se zdravotním postižením Ústí nad Labem, příspěvková organizace	75149541	3841	2009-01-01	\N	f	345
3544	8389381	895	Charita Most	70828920	3866	2009-01-01	\N	f	346
3534	9361032	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3846	2009-01-01	\N	f	347
3530	8888297	183	Domovy sociálních služeb Litvínov, příspěvková organizace	49872541	3848	2009-01-01	\N	f	348
3529	4410973	183	Domovy sociálních služeb Litvínov, příspěvková organizace	49872541	3847	2009-01-01	\N	f	349
3528	7629312	864	Charita Česká Kamenice	70818134	3848	2009-01-01	\N	f	350
3526	6522122	752	Arkadie, o. p. s.	00556203	3841	2009-01-01	\N	f	351
3522	9288131	701	Charita Ústí nad Labem	44225512	3859	2008-10-01	\N	f	352
3514	9407680	485	Diakonie ČCE - Středisko křesťanské pomoci v Litoměřicích	46768041	3864	2009-01-01	\N	f	353
3494	2803757	825	Kamarád - LORM	00830437	3841	2009-01-01	\N	f	354
3490	5658772	1619	Oblastní spolek ČČK Louny	00426113	3854	2009-01-01	\N	f	355
3489	1427288	1619	Oblastní spolek ČČK Louny	00426113	3854	2009-01-01	\N	f	356
3482	2046626	270	Fokus Labe, z.ú.	44226586	3864	2009-01-01	\N	f	357
3481	1214275	270	Fokus Labe, z.ú.	44226586	3867	2009-01-01	\N	f	358
3456	9267613	766	Centrum služeb pro zdravotně postižené Žatec, z. s.	27040143	3842	2008-08-01	\N	f	359
3441	1475555	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3853	2008-08-01	\N	f	360
3405	7646731	1591	Obec Velké Žernoseky	00264610	3838	2007-01-01	\N	f	361
3384	5578580	1585	Město Kadaň	00261912	3866	2008-03-01	\N	f	362
3379	6406334	1581	Město Bohušovice nad Ohří	00263362	3838	2008-03-18	\N	f	363
3377	1795576	1579	Město Terezín	00264474	3838	2008-03-07	\N	f	364
3370	5179369	1576	Obec Čížkovice	00263486	3838	2008-03-05	\N	f	365
3347	4973681	1563	Obec Nové Sedlo	00265292	3838	2007-01-01	\N	f	366
3331	6426990	29	Krušnohorská poliklinika s.r.o.	25030302	3838	2008-01-01	\N	f	367
3329	6373201	29	Krušnohorská poliklinika s.r.o.	25030302	3847	2008-01-01	\N	f	368
3325	6849315	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3861	2008-01-01	\N	f	369
3322	4586391	1550	AMA - Společnost onkologických pacientů, jejich rodinných příslušníků a přátel, z.s.	47326875	3836	2008-01-01	\N	f	370
3276	3964750	1025	OPORA	63154935	3842	2008-01-01	\N	f	371
3275	8743040	1025	OPORA	63154935	3842	2008-01-01	\N	f	372
3267	2888527	1524	Národní rada osob se zdravotním postižením ČR, z.s.	70856478	3836	2006-11-01	\N	t	373
3262	1486803	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3846	2008-01-02	\N	f	374
3260	7429073	296	Diecézní charita Litoměřice	40229939	3836	2008-01-01	\N	f	375
3181	2500401	1485	Sjednocená organizace nevidomých a slabozrakých ČR, zapsaný spolek	65399447	3836	2007-07-01	\N	t	376
3173	2026800	1485	Sjednocená organizace nevidomých a slabozrakých ČR, zapsaný spolek	65399447	3863	2007-07-01	\N	t	377
3155	2472265	864	Charita Česká Kamenice	70818134	3858	2008-01-01	\N	f	378
3121	8215787	1468	Tyfloservis, o.p.s.	26200481	3867	2001-01-01	\N	t	379
3039	5373127	1441	Poradna pro integraci, z.ú.	67362621	3836	1999-01-01	\N	f	380
2981	8477576	1431	Tichý svět, o.p.s.	26611716	3853	2006-07-02	\N	t	381
2980	1679799	1431	Tichý svět, o.p.s.	26611716	3836	2006-07-02	\N	t	382
2978	4385424	1431	Tichý svět, o.p.s.	26611716	3867	2006-07-02	\N	t	383
2972	6338750	1425	Obec Polepy	00264202	3838	2007-01-01	\N	f	384
2963	4963723	1422	Poradna pro občanství Občanská a lidská práva, z.s.	70100691	3836	2000-01-01	\N	t	385
2940	4528359	1409	NADĚJE	00570931	3866	2006-04-01	\N	t	386
2939	8870904	1409	NADĚJE	00570931	3866	2003-10-01	\N	t	387
2855	9462377	270	Fokus Labe, z.ú.	44226586	3863	2008-01-01	\N	f	388
2825	6128832	792	Sociální služby města Loun, příspěvková organizace	60275847	3844	2008-01-01	\N	f	389
2811	3272817	743	Centrum služeb pro zdravotně postižené Louny o.p.s.	27043797	3836	2008-01-01	\N	t	390
2809	7328567	743	Centrum služeb pro zdravotně postižené Louny o.p.s.	27043797	3838	2008-01-01	\N	f	391
2777	1590533	926	Městský ústav sociálních služeb Jirkov, příspěvková organizace	46787682	3842	2008-01-01	\N	f	392
2731	4617622	778	Světlo Kadaň z. s.	65650701	3859	2007-11-01	\N	f	393
2689	2013307	228	Diakonie ČCE - Středisko sociální pomoci v Mostě	70863601	3862	2007-01-01	\N	f	394
2688	1988848	228	Diakonie ČCE - Středisko sociální pomoci v Mostě	70863601	3836	2007-01-01	\N	f	395
2673	5778636	895	Charita Most	70828920	3836	2008-01-01	\N	f	396
2672	3043143	895	Charita Most	70828920	3862	2008-01-01	\N	f	397
2660	3441974	162	HOSPIC v MOSTĚ, o.p.s.	25419561	3836	2007-10-01	\N	f	398
2636	1451339	24	Hospic sv. Štěpána, z. s.	65081374	3836	2007-10-01	\N	f	399
2611	3550580	1355	VIDA z.s.	26636654	3836	2001-09-01	\N	t	400
2606	3591222	1350	Helias Ústí nad Labem, o.p.s.	27324001	3837	2008-01-02	\N	f	401
2525	9832613	701	Charita Ústí nad Labem	44225512	3866	2008-01-01	\N	f	402
2524	3255982	701	Charita Ústí nad Labem	44225512	3862	2008-01-01	\N	f	403
2521	4743378	162	HOSPIC v MOSTĚ, o.p.s.	25419561	3842	2007-01-01	\N	f	404
2484	6770385	24	Hospic sv. Štěpána, z. s.	65081374	3842	2007-01-01	\N	f	405
2483	6556217	1303	Integrované centrum pro osoby se zdravotním postižením Horní Poustevna	70872686	3849	2007-01-01	\N	t	406
2481	5307483	1303	Integrované centrum pro osoby se zdravotním postižením Horní Poustevna	70872686	3846	2007-01-01	\N	t	407
2262	2027319	485	Diakonie ČCE - Středisko křesťanské pomoci v Litoměřicích	46768041	3849	2008-01-01	\N	f	408
2158	2833408	399	Domov pro osoby se zdravotním postižením Kytlice	70872708	3846	2007-01-01	\N	t	409
2152	5220610	555	Domov se zvláštním režimem Krásná Lípa	70872741	3848	2007-01-01	\N	t	410
1987	4363293	1083	Město Velký Šenov	00261734	3838	2007-01-01	\N	f	411
1986	2702489	1082	Programy občanské pomoci a sociální intervence, z.s.	69898588	3836	2007-01-01	\N	f	412
1974	8061366	1078	Křesťanské společenství Jonáš, z. s.	26648661	3858	2007-01-01	\N	f	413
1953	7909036	1069	CENTRUM PRO ZDRAVOTNĚ POSTIŽENÉ ÚSTECKÉHO KRAJE, o. p. s.	26593661	3837	2007-01-01	\N	t	414
1946	5330519	1064	Demosthenes, o.p.s.	25421018	3851	2007-01-01	\N	t	415
1926	1806649	1050	Å ance Lovosice, z.s.	70809828	3838	2007-01-01	\N	f	416
1920	8052393	1047	SociÃ¡lnÃ­ agentura, o. p. s.	26540495	3836	2007-01-01	\N	f	417
1904	7155895	1041	YMCA ÃstÃ­ nad Labem	26533839	3859	2007-01-01	\N	f	418
1887	6651167	964	Člověk v tísni, o.p.s.	25755277	3859	2006-06-01	\N	f	419
1884	9100570	964	Člověk v tísni, o.p.s.	25755277	3859	2006-04-01	\N	f	420
1882	4302274	1025	OPORA	63154935	3838	2007-01-01	\N	f	421
1881	9223369	1025	OPORA	63154935	3838	2007-01-01	\N	f	422
1858	4541453	1013	Domov pro osoby se zdravotním postižením	46789847	3846	2007-01-01	\N	f	423
1856	1348497	1009	SPOLEČNÝ ŽIVOT	26613468	3866	2007-01-01	\N	f	424
1830	9493656	994	Městská správa sociálních služeb Vejprty, příspěvková organizace	46789863	3848	2007-01-01	\N	f	425
1829	7891821	994	Městská správa sociálních služeb Vejprty, příspěvková organizace	46789863	3846	2007-01-01	\N	f	426
1828	6278016	994	Městská správa sociálních služeb Vejprty, příspěvková organizace	46789863	3847	2007-01-01	\N	f	427
1826	7455379	992	Domov Terezín	70875308	3848	2007-01-01	\N	t	428
1816	6435327	964	Člověk v tísni, o.p.s.	25755277	3866	1999-01-01	\N	t	429
1815	7624072	964	Člověk v tísni, o.p.s.	25755277	3866	2007-01-01	\N	f	430
1810	8221160	979	ENERGIE o.p.s.	25034545	3842	2007-01-01	\N	f	431
1808	4941547	964	Člověk v tísni, o.p.s.	25755277	3866	2007-01-01	\N	f	432
1806	9879751	977	Obec Vilémov	00261769	3838	2007-01-01	\N	f	433
1805	8820534	976	Město Úštěk	00264571	3838	2007-01-01	\N	f	434
1803	7968327	974	WHITE LIGHT I, z.ú.	64676803	3865	2007-01-01	\N	t	435
1801	9535462	974	WHITE LIGHT I, z.ú.	64676803	3866	2007-01-01	\N	t	436
1800	6427324	974	WHITE LIGHT I, z.ú.	64676803	3856	2007-01-01	\N	f	437
1798	9684988	974	WHITE LIGHT I, z.ú.	64676803	3866	2007-01-01	\N	f	438
1796	9185704	974	WHITE LIGHT I, z.ú.	64676803	3856	2007-01-01	\N	f	439
1795	5291489	974	WHITE LIGHT I, z.ú.	64676803	3861	2007-01-01	\N	t	440
1792	4578763	973	Domov pro seniory a pečovatelská služba Česká Kamenice, příspěvková organizace	47274565	3847	2007-01-01	\N	f	441
1776	8489399	962	Charita Teplice	70806837	3854	2007-01-01	\N	f	442
1775	7058897	962	Charita Teplice	70806837	3836	2007-01-01	\N	f	443
1767	5981003	954	Agentura Osmý den, o. p. s.	26667649	3867	2007-01-01	\N	f	444
1749	6933014	946	Město Hoštka	00263648	3838	2007-01-01	\N	f	445
1724	7124970	929	TyfloCentrum Ústí nad Labem o.p.s.	25453629	3840	2007-01-01	\N	f	446
1721	5180350	929	TyfloCentrum Ústí nad Labem o.p.s.	25453629	3867	2007-01-01	\N	f	447
1716	1592324	926	Městský ústav sociálních služeb Jirkov, příspěvková organizace	46787682	3838	2007-01-01	\N	f	448
1715	3890327	926	Městský ústav sociálních služeb Jirkov, příspěvková organizace	46787682	3847	2007-01-01	\N	f	449
1714	5655847	926	Městský ústav sociálních služeb Jirkov, příspěvková organizace	46787682	3846	2008-01-01	\N	f	450
1687	9300938	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3848	2007-01-01	\N	f	451
1685	6305505	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3836	2007-01-01	\N	f	452
1684	1853582	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3838	2007-01-01	\N	f	453
1683	7945267	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3844	2007-01-01	\N	f	454
1682	5884351	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3844	2007-01-01	\N	f	455
1681	1944936	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3847	2007-01-01	\N	f	456
1679	9884915	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3847	2007-01-01	\N	f	457
1677	4525297	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3844	2007-01-01	\N	f	458
1676	6712020	911	Městská správa sociálních služeb v Mostě - příspěvková organizace	00831212	3847	2007-01-01	\N	f	459
1642	4704201	895	Charita Most	70828920	3859	2007-01-01	\N	f	460
1640	6776446	895	Charita Most	70828920	3862	2007-01-01	\N	f	461
1639	3475445	895	Charita Most	70828920	3836	2007-01-01	\N	f	462
1638	7323829	895	Charita Most	70828920	3837	2007-01-01	\N	f	463
1632	5798742	895	Charita Most	70828920	3838	2007-01-01	\N	f	464
1621	8217675	895	Charita Most	70828920	3855	2007-01-01	\N	f	465
1620	6239239	895	Charita Most	70828920	3854	2007-01-01	\N	f	466
1618	1826142	895	Charita Most	70828920	3860	2007-01-01	\N	f	467
1617	5690901	895	Charita Most	70828920	3854	2007-01-01	\N	f	468
1610	8306216	891	Most k naději, z. s.	63125137	3866	2007-01-01	\N	t	469
1609	4741952	891	Most k naději, z. s.	63125137	3866	2007-01-01	\N	f	470
1608	1229581	891	Most k naději, z. s.	63125137	3856	2007-01-01	\N	f	471
1607	8582685	891	Most k naději, z. s.	63125137	3856	2007-01-01	\N	f	472
1604	4876605	891	Most k naději, z. s.	63125137	3852	2007-01-01	\N	t	473
1594	2997661	885	Oblastní spolek Českého červeného kříže Litoměřice	00426105	3866	2007-01-01	\N	f	474
1593	2467540	885	Oblastní spolek Českého červeného kříže Litoměřice	00426105	3856	2007-01-01	\N	f	475
1571	1142741	69	Senior Teplice z. s.	26598442	3845	2007-08-01	\N	f	476
1563	4095789	874	Poradna pro rodinu a mezilidské vztahy, o. p. s.	26670763	3836	2007-01-01	\N	f	477
1557	8731012	87	Domov důchodců Roudnice nad Labem, příspěvková organizace	00828998	3848	2007-07-01	\N	f	478
1556	7001404	87	Domov důchodců Roudnice nad Labem, příspěvková organizace	00828998	3847	2007-01-01	\N	f	479
1552	6570110	869	Camphill na soutoku, z.s.	68923147	3849	2007-01-01	\N	f	480
1515	1510111	835	Dobrovolnické centrum, z.s.	70225842	3862	2007-01-01	\N	t	481
1512	8570486	825	Kamarád - LORM	00830437	3842	2007-01-01	\N	f	482
1509	1179103	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3863	2007-01-01	\N	f	483
1508	7896718	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3853	2007-01-01	\N	f	484
1507	7902701	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3863	2007-01-01	\N	f	485
1506	7160060	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3853	2007-01-01	\N	f	486
1505	9118818	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3863	2007-01-01	\N	f	487
1504	8443953	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3853	2007-01-01	\N	f	488
1503	5922648	831	Svaz neslyšících a nedoslýchavých osob v ČR, z. s. Krajská organizace Ústeckého kraje, p. s.	70942412	3863	2007-01-01	\N	f	489
1482	3210011	825	Kamarád - LORM	00830437	3846	2007-01-01	\N	f	490
1480	2207393	825	Kamarád - LORM	00830437	3845	2007-01-01	\N	f	491
1479	1372355	825	Kamarád - LORM	00830437	3844	2007-01-01	\N	f	492
1405	5509784	800	Prosapia, z.ú., společnost pro rodinu	69411239	3836	2007-01-01	\N	f	493
1393	4012067	792	Sociální služby města Loun, příspěvková organizace	60275847	3838	2007-01-01	\N	f	494
1370	5999482	780	Židovská obec Teplice	61515434	3836	2007-01-01	\N	f	495
1368	5425697	778	Světlo Kadaň z. s.	65650701	3866	2007-01-01	\N	f	496
1367	9046179	778	Světlo Kadaň z. s.	65650701	3856	2007-01-01	\N	f	497
1365	2449753	778	Světlo Kadaň z. s.	65650701	3866	2007-01-01	\N	f	498
1364	8680556	778	Světlo Kadaň z. s.	65650701	3856	2007-01-01	\N	f	499
1363	6042330	778	Světlo Kadaň z. s.	65650701	3866	2007-01-01	\N	f	500
1361	1348958	778	Světlo Kadaň z. s.	65650701	3856	2007-01-01	\N	f	501
1356	6511261	774	Charitní sdružení Děčín, z.s.	26590719	3836	2007-01-01	\N	f	502
1354	7674174	774	Charitní sdružení Děčín, z.s.	26590719	3862	2007-01-01	\N	f	503
1347	6540812	769	Charita Lovosice	46770321	3859	2007-01-01	\N	f	504
1346	3209417	769	Charita Lovosice	46770321	3862	2007-01-01	\N	f	505
1345	3189832	769	Charita Lovosice	46770321	3866	2007-01-01	\N	f	506
1335	3991178	763	Centrum služeb pro zdravotně postižené o.p.s.	27297128	3836	2007-01-01	\N	f	507
1333	1532609	763	Centrum služeb pro zdravotně postižené o.p.s.	27297128	3837	2007-01-01	\N	f	508
1306	7942332	752	Arkadie, o. p. s.	00556203	3836	2007-01-01	\N	f	509
1305	4415138	752	Arkadie, o. p. s.	00556203	3867	2007-01-01	\N	f	510
1303	1268119	752	Arkadie, o. p. s.	00556203	3844	2007-01-01	\N	f	511
1301	1816143	752	Arkadie, o. p. s.	00556203	3867	2007-01-01	\N	f	512
1300	4012625	752	Arkadie, o. p. s.	00556203	3844	2007-01-01	\N	f	513
1299	2981921	752	Arkadie, o. p. s.	00556203	3864	2007-01-01	\N	f	514
1272	9055829	71	Město Varnsdorf	00261718	3859	2007-01-01	\N	f	515
1270	2244389	71	Město Varnsdorf	00261718	3860	2007-01-01	\N	f	516
1268	3064434	71	Město Varnsdorf	00261718	3866	2007-01-01	\N	f	517
1252	2680198	725	Město Bílina	00266230	3838	2007-01-01	\N	f	518
1249	3861378	722	Salesiánský klub mládeže, z.s. Rumburk - Jiříkov	62231294	3859	2007-01-01	\N	f	519
1245	9736016	716	Spirála, Ústecký kraj, z. s.	68954221	3836	2007-01-01	\N	f	520
1244	9031562	716	Spirála, Ústecký kraj, z. s.	68954221	3868	2007-01-01	\N	t	521
1240	9381472	716	Spirála, Ústecký kraj, z. s.	68954221	3857	2007-01-01	\N	t	522
1238	1901964	716	Spirála, Ústecký kraj, z. s.	68954221	3852	2007-01-01	\N	f	523
1216	3125201	701	Charita Ústí nad Labem	44225512	3859	2007-01-01	\N	f	524
1213	2145028	701	Charita Ústí nad Labem	44225512	3858	2007-01-01	\N	f	525
1212	3831791	701	Charita Ústí nad Labem	44225512	3860	2007-01-01	\N	f	526
1211	1001488	701	Charita Ústí nad Labem	44225512	3854	2007-01-01	\N	f	527
1210	1066948	700	JURTA, o.p.s.	63778718	3867	2007-01-01	\N	f	528
1209	9100031	700	JURTA, o.p.s.	63778718	3841	2007-01-01	\N	f	529
1207	8281324	698	Charita Roudnice nad Labem	62769111	3854	2007-01-01	\N	f	530
1206	1761469	698	Charita Roudnice nad Labem	62769111	3838	2007-01-01	\N	t	531
1205	4335678	698	Charita Roudnice nad Labem	62769111	3859	2007-01-01	\N	f	532
1188	9382099	684	CESPO, o. p. s.	70819882	3853	2007-01-01	\N	t	533
1187	8532431	684	CESPO, o. p. s.	70819882	3836	2007-01-01	\N	t	534
1177	5598414	680	Agentura Pondělí, z.s.	26537788	3867	2007-01-01	\N	f	535
1039	9695946	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3866	2007-01-01	\N	f	536
1038	7461655	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3856	2007-01-01	\N	f	537
1037	5093964	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3860	2007-01-01	\N	f	538
1036	3811243	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3854	2007-01-01	\N	f	539
1035	1073186	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3838	2007-01-01	\N	f	540
1034	1542857	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3846	2007-01-01	\N	t	541
1033	5387786	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3844	2007-01-01	\N	f	542
1032	2682796	622	Centrum sociálních služeb Děčín, příspěvková organizace	71235868	3847	2007-01-01	\N	f	543
1011	3536223	611	Květina z. s.	27038645	3859	2007-01-01	\N	f	544
1005	1243707	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3836	2007-01-01	\N	f	545
1003	1045259	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3836	2007-01-01	\N	f	546
1001	9751707	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3846	2007-01-01	\N	f	547
1000	9374052	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3846	2007-01-01	\N	f	548
999	1997112	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3846	2007-01-01	\N	f	549
998	8648413	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3848	2007-01-01	\N	f	550
994	7102460	605	Centrum sociální pomoci Litoměřice, příspěvková organizace	00080195	3847	2007-01-01	\N	f	551
985	2069270	601	Město Jílové	00261408	3838	2007-01-01	\N	f	552
936	4771324	569	Město Meziboří	00266086	3838	2007-01-01	\N	f	553
935	8543206	568	Domov důchodců Lipová	47274492	3848	2007-01-01	\N	f	554
931	6349343	564	Charita Rumburk	46797572	3862	2007-01-01	\N	f	555
929	7222807	564	Charita Rumburk	46797572	3859	2007-01-01	\N	f	556
927	4291907	564	Charita Rumburk	46797572	3836	2007-01-01	\N	f	557
923	2269939	560	Podkrušnohorské domovy sociálních služeb Dubí - Teplice, příspěvková organizace	63787849	3848	2007-01-01	\N	f	558
922	6621591	560	Podkrušnohorské domovy sociálních služeb Dubí - Teplice, příspěvková organizace	63787849	3847	2007-01-01	\N	f	559
920	8895811	559	Město Krupka	00266418	3838	2007-01-01	\N	f	560
914	1292895	553	Centrum pomoci pro zdravotně postižené a seniory o.p.s.	27270955	3837	2007-01-01	\N	f	561
913	2068891	550	Domov sociálních služeb Meziboří, příspěvková organizace	49872516	3847	2007-01-01	\N	f	562
850	7938610	527	Agentura osobní asistenční služby z. ú.	26638452	3837	2007-01-01	\N	f	563
817	3856868	508	Ústav sociální péče pro tělesně postižené dospělé Snědovice, příspěvková organizac	70948062	3846	2007-01-01	\N	t	564
781	4894760	485	Diakonie ČCE - Středisko křesťanské pomoci v Litoměřicích	46768041	3867	2007-01-01	\N	f	565
780	4731306	485	Diakonie ČCE - Středisko křesťanské pomoci v Litoměřicích	46768041	3854	2007-01-01	\N	f	566
779	7041080	485	Diakonie ČCE - Středisko křesťanské pomoci v Litoměřicích	46768041	3843	2007-01-01	\N	f	567
766	2135966	475	Sociální služby Jiříkov, příspěvková organizace	47274581	3847	2007-01-01	\N	f	568
747	9595541	469	Domov pro seniory Chlumec, příspěvková organizace	44555296	3847	2007-01-01	\N	f	569
746	9712191	467	Domov Severka Jiříkov, příspěvková organizace	47274468	3848	2007-01-01	\N	f	570
718	2561765	448	Město Štětí	00264466	3838	2007-01-01	\N	f	571
715	9313776	446	Domov důchodců Bystřany	63787725	3848	2007-01-01	\N	f	572
714	6986535	446	Domov důchodců Bystřany	63787725	3847	2007-01-01	\N	f	573
712	4403315	445	Domovy pro seniory Šluknov - Krásná Lípa, příspěvková organizace	47274573	3847	2007-01-01	\N	f	574
707	5458864	440	Pečovatelská služba Ústí nad Labem, příspěvková organizace	44555385	3838	2007-01-01	\N	f	575
698	1280221	435	Romano jasnica, spolek	68974922	3866	2007-01-01	\N	f	576
697	9250152	435	Romano jasnica, spolek	68974922	3836	2007-01-01	\N	f	577
671	9009774	416	Městská správa sociálních služeb Kadaň	65642481	3838	2007-01-01	\N	f	578
668	8021779	416	Městská správa sociálních služeb Kadaň	65642481	3847	2007-01-01	\N	f	579
648	2185972	398	Diakonie ČCE - středisko v Krabčicích	41328523	3848	2007-01-01	\N	f	580
647	9753639	398	Diakonie ČCE - středisko v Krabčicích	41328523	3847	2007-01-01	\N	f	581
633	7108907	391	DRUG-OUT Klub, z.s.	44554559	3866	2007-01-01	\N	t	582
631	4677905	391	DRUG-OUT Klub, z.s.	44554559	3856	2007-01-01	\N	f	583
623	1408517	389	Domov Velké Březno, příspěvková organizace	44555288	3848	2007-01-01	\N	f	584
614	6455886	380	Centrum pro zdravotně postižené děti a mládež - SRDÍČKO	70854165	3844	2007-01-01	\N	f	585
598	3899971	367	Domovy pro osoby se zdravotním postižením Oleška-Kamenice, příspěvková organizace	47274522	3846	2007-01-01	\N	f	586
559	6916747	340	Domovy sociálních služeb Kadaň a Mašťov, příspěvková organizace	46789910	3847	2007-01-01	\N	f	587
558	6075842	340	Domovy sociálních služeb Kadaň a Mašťov, příspěvková organizace	46789910	3846	2007-01-01	\N	f	588
556	5935431	340	Domovy sociálních služeb Kadaň a Mašťov, příspěvková organizace	46789910	3846	2007-01-01	\N	f	589
554	7255944	340	Domovy sociálních služeb Kadaň a Mašťov, příspěvková organizace	46789910	3846	2007-01-01	\N	f	590
506	2234056	315	Asociace vozíčkářů a zdravotně i mentálně postižených v ČR	14866391	3836	2007-01-01	\N	f	591
473	2744287	144	Domov pro seniory Severní Terasa, příspěvková organizace	44555326	3847	2007-01-01	\N	f	592
466	4013275	296	Diecézní charita Litoměřice	40229939	3854	2007-01-01	\N	f	593
465	9801549	296	Diecézní charita Litoměřice	40229939	3838	2007-01-01	\N	f	594
464	3632154	296	Diecézní charita Litoměřice	40229939	3838	2007-01-01	\N	f	595
463	4396664	296	Diecézní charita Litoměřice	40229939	3838	2007-01-01	\N	f	596
460	4159038	282	Domov pro seniory Podbořany, příspěvková organizace	65650964	3847	2007-01-01	\N	f	597
415	3935206	270	Fokus Labe, z.ú.	44226586	3849	2007-01-01	\N	f	598
414	8981594	270	Fokus Labe, z.ú.	44226586	3867	2007-01-01	\N	f	599
413	2365503	270	Fokus Labe, z.ú.	44226586	3864	2007-01-01	\N	f	600
412	5844827	270	Fokus Labe, z.ú.	44226586	3863	2007-01-01	\N	f	601
404	5496002	267	Nemocnice Roudnice nad Labem s.r.o.	25443801	3844	2007-01-01	\N	f	602
403	8917425	267	Nemocnice Roudnice nad Labem s.r.o.	25443801	3838	2007-01-01	\N	f	603
390	2434997	256	Domov Brtníky, příspěvková organizace	47274484	3846	2007-01-01	\N	f	604
348	9567874	231	Domov Bez zámků Tuchořice, příspěvková organizace	00830381	3846	2007-01-01	\N	t	605
346	6890540	229	Domov pro seniory Dobětice, příspěvková organizace	44555407	3847	2007-01-01	\N	f	606
344	1760842	228	Diakonie ČCE - Středisko sociální pomoci v Mostě	70863601	3854	2007-01-01	\N	f	607
312	2758028	201	Domov pro seniory Bukov, příspěvková organizace	44555661	3846	2007-01-01	\N	f	608
311	9714807	201	Domov pro seniory Bukov, příspěvková organizace	44555661	3847	2007-01-01	\N	f	609
305	3403190	193	Charita Litoměřice	46769382	3838	2007-01-01	\N	f	610
302	6566711	193	Charita Litoměřice	46769382	3847	2007-01-01	\N	f	611
301	2548478	193	Charita Litoměřice	46769382	3860	2007-01-01	\N	f	612
300	2241142	193	Charita Litoměřice	46769382	3854	2007-01-01	\N	f	613
299	5964684	193	Charita Litoměřice	46769382	3858	2007-01-01	\N	f	614
276	8538718	183	Domovy sociálních služeb Litvínov, příspěvková organizace	49872541	3846	2007-01-01	\N	f	615
244	1088856	165	Město Šluknov	00261688	3838	2007-01-01	\N	f	616
213	7359147	142	Sociální služby Chomutov, příspěvková organizace	46789944	3838	2007-01-01	\N	f	617
212	8986384	142	Sociální služby Chomutov, příspěvková organizace	46789944	3846	2007-01-01	\N	f	618
210	8611619	142	Sociální služby Chomutov, příspěvková organizace	46789944	3854	2007-01-01	\N	f	619
209	6315827	142	Sociální služby Chomutov, příspěvková organizace	46789944	3836	2007-01-01	\N	f	620
208	4810034	142	Sociální služby Chomutov, příspěvková organizace	46789944	3844	2007-01-01	\N	f	621
207	1049767	142	Sociální služby Chomutov, příspěvková organizace	46789944	3847	2007-01-01	\N	f	622
164	9823316	112	Domov pro seniory a pečovatelská služba v Žatci	00830411	3847	2007-01-01	\N	f	623
163	5153567	112	Domov pro seniory a pečovatelská služba v Žatci	00830411	3838	2007-01-01	\N	f	624
131	7806966	93	Domovy sociálních služeb Háj a Nová Ves, příspěvková organizace	63787911	3845	2007-01-01	\N	f	625
130	1351633	93	Domovy sociálních služeb Háj a Nová Ves, příspěvková organizace	63787911	3846	2007-01-01	\N	f	626
100	9957516	71	Město Varnsdorf	00261718	3838	2007-01-01	\N	f	627
98	8951412	69	Senior Teplice z. s.	26598442	3844	2007-01-01	\N	f	628
97	4868271	69	Senior Teplice z. s.	26598442	3842	2007-01-01	\N	f	629
96	7907052	69	Senior Teplice z. s.	26598442	3838	2007-01-01	\N	f	630
85	3369883	62	Městský ústav sociálních služeb Klášterec nad Ohří, příspěvková organizace	65082125	3838	2007-01-01	\N	f	631
84	2848286	62	Městský ústav sociálních služeb Klášterec nad Ohří, příspěvková organizace	65082125	3847	2007-01-01	\N	f	632
26	6172420	23	Domov pro seniory Krásné Březno, p.o.	44555334	3847	2007-01-01	\N	f	633
\.


--
-- Name: lawchunk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: backend
--

SELECT pg_catalog.setval('public.lawchunk_id_seq', 1, false);


--
-- Name: service_locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: backend
--

SELECT pg_catalog.setval('public.service_locations_id_seq', 633, true);


--
-- Name: servicetargetgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: backend
--

SELECT pg_catalog.setval('public.servicetargetgroup_id_seq', 1467, true);


--
-- Name: socialservice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: backend
--

SELECT pg_catalog.setval('public.socialservice_id_seq', 633, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: backend
--

--
-- Name: lawchunk lawchunk_pkey; Type: CONSTRAINT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.lawchunk
    ADD CONSTRAINT lawchunk_pkey PRIMARY KEY (id);


--
-- Name: service_locations service_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.service_locations
    ADD CONSTRAINT service_locations_pkey PRIMARY KEY (id);


--
-- Name: servicetargetgroup servicetargetgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.servicetargetgroup
    ADD CONSTRAINT servicetargetgroup_pkey PRIMARY KEY (id);


--
-- Name: socialservice socialservice_pkey; Type: CONSTRAINT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.socialservice
    ADD CONSTRAINT socialservice_pkey PRIMARY KEY (id);


--
-- Name: ix_lawchunk_chunk_index; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_lawchunk_chunk_index ON public.lawchunk USING btree (chunk_index);


--
-- Name: ix_lawchunk_document_number; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_lawchunk_document_number ON public.lawchunk USING btree (document_number);


--
-- Name: ix_lawchunk_fragment_id; Type: INDEX; Schema: public; Owner: backend
--

CREATE UNIQUE INDEX ix_lawchunk_fragment_id ON public.lawchunk USING btree (fragment_id);


--
-- Name: ix_lawchunk_source_kind; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_lawchunk_source_kind ON public.lawchunk USING btree (source_kind);


--
-- Name: ix_service_locations_municipality; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_service_locations_municipality ON public.service_locations USING btree (municipality);


--
-- Name: ix_service_locations_provider_id; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_service_locations_provider_id ON public.service_locations USING btree (provider_id);


--
-- Name: ix_service_locations_region; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_service_locations_region ON public.service_locations USING btree (region);


--
-- Name: ix_service_locations_service_name; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_service_locations_service_name ON public.service_locations USING btree (service_name);


--
-- Name: ix_service_target_groups_service_id; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_service_target_groups_service_id ON public.servicetargetgroup USING btree (service_id);


--
-- Name: ix_service_target_groups_source_group_id; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_service_target_groups_source_group_id ON public.servicetargetgroup USING btree (source_group_id);


--
-- Name: ix_socialservice_identifier; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_socialservice_identifier ON public.socialservice USING btree (identifier);


--
-- Name: ix_socialservice_provider_id; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_socialservice_provider_id ON public.socialservice USING btree (provider_id);


--
-- Name: ix_socialservice_service_type_id; Type: INDEX; Schema: public; Owner: backend
--

CREATE INDEX ix_socialservice_service_type_id ON public.socialservice USING btree (service_type_id);


--
-- Name: ix_socialservice_source_service_id; Type: INDEX; Schema: public; Owner: backend
--

CREATE UNIQUE INDEX ix_socialservice_source_service_id ON public.socialservice USING btree (source_service_id);


--
-- Name: service_locations service_locations_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.service_locations
    ADD CONSTRAINT service_locations_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.socialservice(source_service_id) ON DELETE CASCADE;


--
-- Name: servicetargetgroup servicetargetgroup_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: backend
--

ALTER TABLE ONLY public.servicetargetgroup
    ADD CONSTRAINT servicetargetgroup_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.socialservice(source_service_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--
