--
-- PostgreSQL database dump
--

-- Dumped from database version 14.10 (Ubuntu 14.10-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.10 (Ubuntu 14.10-0ubuntu0.22.04.1)

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: brand; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.brand (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    deleted_at timestamp with time zone,
    file_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.brand OWNER TO node;

--
-- Name: callback_request; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.callback_request (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    phone character varying(255) NOT NULL,
    full_name character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status_id uuid,
    meta_data character varying(255)
);


ALTER TABLE public.callback_request OWNER TO node;

--
-- Name: category; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.category (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    parent_id uuid,
    deleted_at timestamp with time zone,
    description character varying(1000),
    priority integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.category OWNER TO node;

--
-- Name: category_priority_seq; Type: SEQUENCE; Schema: public; Owner: node
--

CREATE SEQUENCE public.category_priority_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_priority_seq OWNER TO node;

--
-- Name: category_priority_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: node
--

ALTER SEQUENCE public.category_priority_seq OWNED BY public.category.priority;


--
-- Name: configuration; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.configuration (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    value_type text,
    description character varying(1000),
    CONSTRAINT configuration_value_type_check CHECK ((value_type = ANY (ARRAY['string'::text, 'number'::text, 'boolean'::text, 'float'::text])))
);


ALTER TABLE public.configuration OWNER TO node;

--
-- Name: file; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.file (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    url character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.file OWNER TO node;

--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);


ALTER TABLE public.knex_migrations OWNER TO node;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: node
--

CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_id_seq OWNER TO node;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: node
--

ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;


--
-- Name: knex_migrations_lock; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer
);


ALTER TABLE public.knex_migrations_lock OWNER TO node;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: node
--

CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_lock_index_seq OWNER TO node;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: node
--

ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;


--
-- Name: order; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public."order" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    comment character varying(255) NOT NULL,
    full_name character varying(255),
    phone character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    street character varying(255) NOT NULL,
    building character varying(255) NOT NULL,
    apartment character varying(20) NOT NULL,
    client_type text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total_price integer,
    status_id uuid,
    CONSTRAINT order_client_type_check CHECK ((client_type = ANY (ARRAY['Физическое лицо'::text, 'Юридическое лицо'::text])))
);


ALTER TABLE public."order" OWNER TO node;

--
-- Name: order_product; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.order_product (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_id uuid,
    count integer NOT NULL,
    product_name character varying(255),
    category_name character varying(255),
    brand_name character varying(255),
    price integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.order_product OWNER TO node;

--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.order_promotion (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    promotion_type character varying(255) NOT NULL,
    promotion_condition character varying(255) NOT NULL,
    order_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    gift_name character varying(255)
);


ALTER TABLE public.order_promotion OWNER TO node;

--
-- Name: partner; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.partner (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.partner OWNER TO node;

--
-- Name: pricing; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.pricing (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    count_from integer NOT NULL,
    count_to integer NOT NULL,
    price integer NOT NULL,
    product_id uuid,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.pricing OWNER TO node;

--
-- Name: product; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.product (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    category_id uuid NOT NULL,
    brand_id uuid NOT NULL,
    deleted_at timestamp with time zone,
    description character varying(1000),
    file_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.product OWNER TO node;

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.promotion (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    condition character varying(1000) NOT NULL,
    promo_type text NOT NULL,
    product_id uuid NOT NULL,
    count integer NOT NULL,
    file_id uuid,
    brand_id uuid NOT NULL,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    gift_name character varying(255),
    CONSTRAINT promotion_promo_type_check CHECK ((promo_type = 'Количество товаров'::text))
);


ALTER TABLE public.promotion OWNER TO node;

--
-- Name: status; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public.status (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.status OWNER TO node;

--
-- Name: user; Type: TABLE; Schema: public; Owner: node
--

CREATE TABLE public."user" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    login character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    refresh_token character varying(1000),
    device_id uuid,
    role text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    phone character varying(255),
    CONSTRAINT user_phone_check CHECK (((phone)::text ~ '^(\+7)?[0-9]{3}[0-9]{3}[0-9]{2}?[0-9]{2}$'::text)),
    CONSTRAINT user_role_check CHECK ((role = ANY (ARRAY['Администратор'::text, 'Менеджер'::text])))
);


ALTER TABLE public."user" OWNER TO node;

--
-- Name: category priority; Type: DEFAULT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.category ALTER COLUMN priority SET DEFAULT nextval('public.category_priority_seq'::regclass);


--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Data for Name: brand; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.brand (id, name, deleted_at, file_id, created_at, updated_at) FROM stdin;
7c982e60-5c62-4910-a9fd-dff08fce7d2d	Пилигрим	\N	\N	2023-02-19 20:46:02.994859+03	2023-02-19 20:46:02.994859+03
5a77e2ed-99a4-4c03-a1a3-1df4f497b92d	Кубай	\N	\N	2023-02-21 22:29:39.590455+03	2023-02-21 22:29:39.590455+03
\.


--
-- Data for Name: callback_request; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.callback_request (id, phone, full_name, created_at, updated_at, status_id, meta_data) FROM stdin;
6b23aa8a-4291-497c-b9eb-5f1a6a4fabbe	+79252770509	Александр Тестов	2023-02-21 22:11:52.415348+03	2023-02-21 22:11:52.415348+03	918a5cc4-7df1-4a2a-9130-58d60f87bcde	{"source":"piligrim"}
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.category (id, name, parent_id, deleted_at, description, priority, created_at, updated_at) FROM stdin;
81857e29-e3d7-4f49-b419-1b4824c9fd38	Вода	\N	\N	Системная категория. Данная категория не отображается на лендингах	1	2023-02-20 00:45:01.588622+03	2023-02-20 00:45:01.588622+03
5ab86813-2dd4-49e5-a7ad-8dcdc47a0061	Большой объём (19Л)	81857e29-e3d7-4f49-b419-1b4824c9fd38	\N	Приобретая тару в 19 литров, Вы получаете следующие преимущества: дома всегда будет запас воды – хватит на 3-5 дней даже для большой семьи; в офисе кулеры будут долго наполнены.\nЭто экономно – цена такой бутыли меньше, чем продукции в мелкой упаковке, ведь снижаются траты на розлив и тару. Приобретая воду у компании "2 Литра", Вы используете сертифицированный продукт, в качестве которого можете быть уверены на 100%.	2	2023-02-20 00:45:50.57084+03	2023-02-20 00:45:50.57084+03
3e0d3794-b86f-482a-911e-31d030dd9d9a	Средний объём (5л, 1.5л, 0.5л)	81857e29-e3d7-4f49-b419-1b4824c9fd38	\N	Приобретая тару в 19 литров, Вы получаете следующие преимущества: дома всегда будет запас воды – хватит на 3-5 дней даже для большой семьи; в офисе кулеры будут долго наполнены.\nЭто экономно – цена такой бутыли меньше, чем продукции в мелкой упаковке, ведь снижаются траты на розлив и тару. Приобретая воду у компании "2 Литра", Вы используете сертифицированный продукт, в качестве которого можете быть уверены на 100%.	3	2023-02-21 22:09:03.526271+03	2023-02-21 22:09:03.526271+03
\.


--
-- Data for Name: configuration; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.configuration (id, key, value, value_type, description) FROM stdin;
94a85a2b-f58a-466a-bd15-9d2b32b9bbaf	PHONE_NUMBER_CONFIRMATION	false	boolean	Подтверждение номера телефона
479a70c0-e4c8-4640-94b0-51ef44ff8285	ORDER_MIN_AMOUNT	860	float	Минимальная стоимость заказа
\.


--
-- Data for Name: file; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.file (id, url, key, deleted_at, created_at, updated_at) FROM stdin;
b0b07d18-5985-47ef-9a72-6712fce3b056	https://ntl-cloud.storage.yandexcloud.net/logo/a24df38d-2f2d-449a-8053-402433cffe60.png	logo/a24df38d-2f2d-449a-8053-402433cffe60.png	\N	2023-02-20 00:46:39.088533+03	2023-02-20 00:46:39.088533+03
c6a42a00-65f3-47a2-a444-54bf29cf0393	https://ntl-cloud.storage.yandexcloud.net/logo/53060759-0539-43b5-a6f1-16ed7033fc12.png	logo/53060759-0539-43b5-a6f1-16ed7033fc12.png	\N	2023-02-21 22:34:05.404688+03	2023-02-21 22:34:05.404688+03
1aba2447-0c03-48a9-9f58-6f8ed020e9cc	https://ntl-cloud.storage.yandexcloud.net/logo/37ab33c1-dae1-4e38-a238-24693a4edd3c.png	logo/37ab33c1-dae1-4e38-a238-24693a4edd3c.png	\N	2023-03-08 20:51:21.978143+03	2023-03-08 20:51:21.978143+03
358d6224-8d39-4d65-a61d-e9388a3a378c	https://ntl-cloud.storage.yandexcloud.net/logo/bc29acfc-4131-49bc-94c5-063e48282a44.jpg	logo/bc29acfc-4131-49bc-94c5-063e48282a44.jpg	\N	2023-03-08 21:53:50.828455+03	2023-03-08 21:53:50.828455+03
a4064c08-96aa-4da4-9502-6883d4f6c108	https://ntl-cloud.storage.yandexcloud.net/logo/cf0e6f39-065f-428b-843f-f00a745f1462.jpg	logo/cf0e6f39-065f-428b-843f-f00a745f1462.jpg	\N	2023-03-08 22:00:20.925423+03	2023-03-08 22:00:20.925423+03
c15efa00-d0d3-42b4-a2d1-0b966a1c2c41	https://ntl-cloud.storage.yandexcloud.net/logo/0ff7a843-dc3b-49cf-85ae-7e0dc892b4cd.jpg	logo/0ff7a843-dc3b-49cf-85ae-7e0dc892b4cd.jpg	\N	2023-03-21 19:43:04.343287+03	2023-03-21 19:43:04.343287+03
165a22ca-f3f6-4d07-adfa-51e1c1f472e7	https://ntl-cloud.storage.yandexcloud.net/logo/af97fd58-d159-4fc1-91fd-e93f9d6ef7ba.png	logo/af97fd58-d159-4fc1-91fd-e93f9d6ef7ba.png	\N	2023-03-21 19:52:15.62643+03	2023-03-21 19:52:15.62643+03
58fd72d7-be80-4a4e-a3c1-9e12c622534c	https://ntl-cloud.storage.yandexcloud.net/logo/2715f160-6039-4fc1-9b99-5db950890b2c.jpg	logo/2715f160-6039-4fc1-9b99-5db950890b2c.jpg	\N	2023-03-21 19:56:14.999846+03	2023-03-21 19:56:14.999846+03
64168f45-bee2-4df4-936f-73f9e263dcef	https://ntl-cloud.storage.yandexcloud.net/logo/7eb99ac2-2598-4863-be3a-e52d3c62b9d1.png	logo/7eb99ac2-2598-4863-be3a-e52d3c62b9d1.png	\N	2023-03-21 19:57:00.874704+03	2023-03-21 19:57:00.874704+03
83582029-e5ca-458d-8dfe-934d032869d3	https://ntl-cloud.storage.yandexcloud.net/logo/fd33cf1f-37f3-4b54-be8b-3abec358609e.png	logo/fd33cf1f-37f3-4b54-be8b-3abec358609e.png	\N	2023-03-21 19:57:55.449189+03	2023-03-21 19:57:55.449189+03
7fa16289-427b-4699-9d3a-cb1b6188ccd1	https://ntl-cloud.storage.yandexcloud.net/logo/93c03e48-1717-4985-8d28-2bcf688f9446.png	logo/93c03e48-1717-4985-8d28-2bcf688f9446.png	\N	2023-03-21 20:00:28.95997+03	2023-03-21 20:00:28.95997+03
3006a1bd-a91f-4c26-8cea-ea4ede352dd0	https://ntl-cloud.storage.yandexcloud.net/logo/80a2055e-dab7-4aad-bbc9-fd805f94e078.jpg	logo/80a2055e-dab7-4aad-bbc9-fd805f94e078.jpg	\N	2023-03-21 21:22:51.438256+03	2023-03-21 21:22:51.438256+03
b0ec12d7-0077-457c-acec-d4165e710ce6	https://ntl-cloud.storage.yandexcloud.net/logo/3e4ba542-7a97-470c-b181-f2c8cfe9c36b.png	logo/3e4ba542-7a97-470c-b181-f2c8cfe9c36b.png	\N	2023-04-08 15:44:02.086484+03	2023-04-08 15:44:02.086484+03
407402de-10e5-4f0b-a956-76aaa60c7164	https://ntl-cloud.storage.yandexcloud.net/logo/d42db44f-20ad-47c5-821d-40cf4ab2b326.png	logo/d42db44f-20ad-47c5-821d-40cf4ab2b326.png	\N	2023-03-21 19:59:32.544595+03	2023-03-21 19:59:32.544595+03
5dc5e055-35a9-4fdc-b428-cb69cb20aa21	https://ntl-cloud.storage.yandexcloud.net/logo/135851d8-fdf5-48a9-b2d6-c087c6f46603.png	logo/135851d8-fdf5-48a9-b2d6-c087c6f46603.png	\N	2023-03-21 19:50:25.235409+03	2023-03-21 19:50:25.235409+03
\.


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.knex_migrations (id, name, batch, migration_time) FROM stdin;
1	20220816121446_add_knex_ext.ts	1	2023-02-19 19:08:39.643+03
2	20220816124231_add_category_table.ts	1	2023-02-19 19:08:39.65+03
3	20220816132808_add_brand_table.ts	1	2023-02-19 19:08:39.653+03
4	20220816133349_add_item_table.ts	1	2023-02-19 19:08:39.657+03
5	20220816134137_add_pricing_table.ts	1	2023-02-19 19:08:39.66+03
6	20220823110942_add_order_table.ts	1	2023-02-19 19:08:39.663+03
7	20220823111112_add_order_status_table.ts	1	2023-02-19 19:08:39.667+03
8	20220823111950_add_order_item_table.ts	1	2023-02-19 19:08:39.67+03
9	20220830100137_add_callback_request_table.ts	1	2023-02-19 19:08:39.673+03
10	20220830162611_add_callback_request_status_table.ts	1	2023-02-19 19:08:39.676+03
11	20221106163436_add_partner_table.ts	1	2023-02-19 19:08:39.678+03
12	20221109131646_add_dateled_at_column_in_category.ts	1	2023-02-19 19:08:39.679+03
13	20221109131851_add_deleted_at_column_in_item.ts	1	2023-02-19 19:08:39.68+03
14	20221109131932_add_deleted_at_column_in_brand.ts	1	2023-02-19 19:08:39.681+03
15	20221109132054_rename_category_id_column.ts	1	2023-02-19 19:08:39.684+03
16	20221111135228_add_file_table.ts	1	2023-02-19 19:08:39.686+03
17	20221111135824_add_file_id_column_in_brand_table.ts	1	2023-02-19 19:08:39.688+03
18	20221113175827_add_deleted_at_field_in_file.ts	1	2023-02-19 19:08:39.689+03
19	20221115101830_rename_item_table.ts	1	2023-02-19 19:08:39.69+03
20	20221115102317_rename_item_id_in_pricing.ts	1	2023-02-19 19:08:39.694+03
21	20221115104621_rename_order_item_table.ts	1	2023-02-19 19:08:39.696+03
22	20221115140442_add_file_id_and_description_fields_in_item.ts	1	2023-02-19 19:08:39.698+03
23	20221118190317_rename_order_product_constraints.ts	1	2023-02-19 19:08:39.701+03
24	20221118191249_add_info_about_products_in_order_product_table.ts	1	2023-02-19 19:08:39.703+03
25	20221118203128_add_total_price_field_in_order_table.ts	1	2023-02-19 19:08:39.704+03
26	20221119113045_add_description_field_in_category.ts	1	2023-02-19 19:08:39.706+03
27	20221125210807_delete_unique_constraint_in_category.ts	1	2023-02-19 19:08:39.707+03
28	20221128054220_refactor_description_in_category.ts	1	2023-02-19 19:08:39.708+03
29	20221128062136_refactor_description_in_product.ts	1	2023-02-19 19:08:39.709+03
30	20221129160259_add_deleted_at_field_in_pricing.ts	1	2023-02-19 19:08:39.71+03
31	20221129163544_drop_not_null_constr_in_pricing.ts	1	2023-02-19 19:08:39.711+03
32	20221130193635_add_priority_sequence.ts	1	2023-02-19 19:08:39.714+03
33	20221205135222_add_promo_table.ts	1	2023-02-19 19:08:39.719+03
34	20221205163316_add_gift_table.ts	1	2023-02-19 19:08:39.723+03
35	20221205183810_add_order_promo_table.ts	1	2023-02-19 19:08:39.726+03
36	20221205191303_add_order_gift_table.ts	1	2023-02-19 19:08:39.728+03
37	20221214211140_add_timestamps_in_models.ts	1	2023-02-19 19:08:39.735+03
38	20221217110119_delete_status_tables.ts	1	2023-02-19 19:08:39.737+03
39	20221217110226_add_global_status_table.ts	1	2023-02-19 19:08:39.739+03
40	20221217170539_add_status_id_fields_in_tables.ts	1	2023-02-19 19:08:39.741+03
41	20221217173121_delete_useless_date_field.ts	1	2023-02-19 19:08:39.742+03
42	20221223183818_add_user_table.ts	1	2023-02-19 19:08:39.746+03
43	20230127080629_delete_nullable_in_pricing.ts	1	2023-02-19 19:08:39.747+03
44	20230220190033_add_source_to_callback_request.ts	2	2023-02-21 22:10:45.405+03
45	20230306084626_add_config_table.ts	3	2023-03-29 11:52:20.048+03
46	20230323145102_promotion_refactor.ts	3	2023-03-29 11:52:20.06+03
47	20230327162302_add_phone_to_user.ts	4	2023-05-06 02:33:58.117+03
48	20230408210400_alter_config_value_type_column.ts	4	2023-05-06 02:33:58.125+03
49	20230414053534_add_records_to_config_table.ts	4	2023-05-06 02:33:58.129+03
\.


--
-- Data for Name: knex_migrations_lock; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.knex_migrations_lock (index, is_locked) FROM stdin;
1	0
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public."order" (id, comment, full_name, phone, email, city, street, building, apartment, client_type, created_at, updated_at, total_price, status_id) FROM stdin;
d8373b84-707e-4e05-b392-d392b756d40a	Побыстрее!	Тестов Тест	+79252770509	alexander.so@outlook.com	Санкт-Петербург	Ленина	10	11	Физическое лицо	2023-02-21 22:13:04.166234+03	2023-02-21 22:13:04.166234+03	4900	b1072840-a96a-4b34-9535-a06de4f4ca56
\.


--
-- Data for Name: order_product; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.order_product (id, order_id, count, product_name, category_name, brand_name, price, created_at, updated_at) FROM stdin;
83f06de5-18d6-424f-866a-72fe68c8f7cd	d8373b84-707e-4e05-b392-d392b756d40a	10	Пилигрим "Премиум"	Большой объём (19Л)	Пилигрим	4900	2023-02-21 22:13:04.166234+03	2023-02-21 22:13:04.166234+03
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.order_promotion (id, promotion_type, promotion_condition, order_id, created_at, updated_at, gift_name) FROM stdin;
\.


--
-- Data for Name: partner; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.partner (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: pricing; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.pricing (id, count_from, count_to, price, product_id, deleted_at, created_at, updated_at) FROM stdin;
a8069ed8-7769-44ae-93e9-dc9f96791749	1	2	545	9cbf8b03-061e-468f-a4d6-0361f1729bfd	\N	2023-02-20 00:47:13.318296+03	2023-02-20 00:47:13.318296+03
47f3d64a-d931-4f6f-a854-362603dc40d0	3	5	530	9cbf8b03-061e-468f-a4d6-0361f1729bfd	\N	2023-02-20 00:47:29.468142+03	2023-02-20 00:47:29.468142+03
9bd73a46-9326-4647-97f6-2e50cbaa104b	6	0	490	9cbf8b03-061e-468f-a4d6-0361f1729bfd	\N	2023-02-20 00:47:41.01483+03	2023-02-20 00:47:41.01483+03
96c46bd3-8df1-450d-b7da-6fe0fbb61ede	1	0	100	e832a913-354d-4e6e-9fb6-00d6fc2389e7	\N	2023-02-21 22:34:17.157592+03	2023-02-21 22:34:17.157592+03
98c61b93-31c3-4c73-8d35-f2cbaecb9ac0	1	20	100	d30ca210-1fdd-413e-9e61-629e0d3c44df	\N	2023-03-08 21:53:51.122552+03	2023-03-08 21:53:51.122552+03
b77a0512-1f3a-499c-979e-bfd748637ce0	21	0	90	d30ca210-1fdd-413e-9e61-629e0d3c44df	\N	2023-03-08 21:54:46.275262+03	2023-03-08 21:54:46.275262+03
19ed5c16-1c83-44e3-8998-2ff6b6768532	1	10	500	8cf086fc-f0a6-4f56-be00-20cd5d59a519	\N	2023-03-21 21:22:51.733996+03	2023-03-21 21:22:51.733996+03
2152b5f5-1922-494c-a226-7fecc9abf467	11	20	450	8cf086fc-f0a6-4f56-be00-20cd5d59a519	\N	2023-03-21 21:22:51.742477+03	2023-03-21 21:22:51.742477+03
3dc9dd82-bd6b-4bfa-9523-801edc3effd4	21	30	300	8cf086fc-f0a6-4f56-be00-20cd5d59a519	\N	2023-03-21 21:22:51.7487+03	2023-03-21 21:22:51.7487+03
8bdc678a-fccc-42ae-ad62-70235c848916	31	40	100	8cf086fc-f0a6-4f56-be00-20cd5d59a519	\N	2023-03-21 21:23:50.993943+03	2023-03-21 21:23:50.993943+03
0758ef80-20e0-4f81-bfd5-fab354eafa23	1	10	100	4a9b1142-00a4-48d5-95c6-5af7801f6731	2023-04-05 01:56:10.362+03	2023-04-05 02:25:45.710551+03	2023-04-05 02:25:45.710551+03
9d92c77d-c58f-4ee5-aa8f-b961a1c600cc	1	10	999	aca82c13-592f-452a-b04a-3af53cb1edbb	\N	2023-04-05 21:35:58.328333+03	2023-04-05 21:35:58.328333+03
421dfa4d-4d4e-48e8-b244-59e523e16486	1	0	10	9f4a8525-3765-494d-8cf8-79f83c072ef4	\N	2023-04-08 15:45:46.004014+03	2023-04-08 15:45:46.004014+03
05572347-43ba-4548-8a05-d62341b63209	1	2	1	9f4a8525-3765-494d-8cf8-79f83c072ef4	\N	2023-05-06 02:36:16.866268+03	2023-05-06 02:36:16.866268+03
fd8e71e1-40a3-496d-9d31-84c90b6ca3ae	3	5	11	9f4a8525-3765-494d-8cf8-79f83c072ef4	\N	2023-05-06 02:36:16.883547+03	2023-05-06 02:36:16.883547+03
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.product (id, name, category_id, brand_id, deleted_at, description, file_id, created_at, updated_at) FROM stdin;
d30ca210-1fdd-413e-9e61-629e0d3c44df	ПИЛИГРИМ 5 Л	3e0d3794-b86f-482a-911e-31d030dd9d9a	7c982e60-5c62-4910-a9fd-dff08fce7d2d	2023-03-12 14:35:59.832+03	2 бут. в упаковке	358d6224-8d39-4d65-a61d-e9388a3a378c	2023-03-08 21:53:50.943146+03	2023-03-08 21:53:50.943146+03
e832a913-354d-4e6e-9fb6-00d6fc2389e7	19 литров	5ab86813-2dd4-49e5-a7ad-8dcdc47a0061	5a77e2ed-99a4-4c03-a1a3-1df4f497b92d	2023-03-12 14:35:59.832+03	ГОРНАЯ ПИТЬЕВАЯ ВОДА БЕЗ ГАЗА	c6a42a00-65f3-47a2-a444-54bf29cf0393	2023-02-21 22:34:05.503221+03	2023-02-21 22:34:05.503221+03
9cbf8b03-061e-468f-a4d6-0361f1729bfd	Пилигрим "Премиум"	5ab86813-2dd4-49e5-a7ad-8dcdc47a0061	7c982e60-5c62-4910-a9fd-dff08fce7d2d	2023-03-12 14:35:59.832+03	Вода премиального качества\n	b0b07d18-5985-47ef-9a72-6712fce3b056	2023-02-20 00:46:39.185648+03	2023-02-20 00:46:39.185648+03
aca82c13-592f-452a-b04a-3af53cb1edbb	Пилигрим 19 литров	5ab86813-2dd4-49e5-a7ad-8dcdc47a0061	7c982e60-5c62-4910-a9fd-dff08fce7d2d	\N	Пилигрим, талая, минеральная, питьевая, столовая вода, добывается в Архызском ущелье Северного Кавказа.	c15efa00-d0d3-42b4-a2d1-0b966a1c2c41	2023-03-21 19:43:04.470738+03	2023-03-21 19:43:04.470738+03
1e87163c-8c92-4f83-aa14-987bba5a0a06	Кубай 5 литров	3e0d3794-b86f-482a-911e-31d030dd9d9a	5a77e2ed-99a4-4c03-a1a3-1df4f497b92d	\N	Горная, минеральная, питьевая, столовая вода добывается на территории Карачаево-Черкесской республики на Северном Кавказе	165a22ca-f3f6-4d07-adfa-51e1c1f472e7	2023-03-21 19:52:15.748901+03	2023-03-21 19:52:15.748901+03
07d59994-a810-4db0-99ae-1611a53ff41d	Пилигрим 5 литров	3e0d3794-b86f-482a-911e-31d030dd9d9a	7c982e60-5c62-4910-a9fd-dff08fce7d2d	\N	Пилигрим, талая, минеральная, питьевая, столовая вода, добывается в Архызском ущелье Северного Кавказа.	58fd72d7-be80-4a4e-a3c1-9e12c622534c	2023-03-21 19:56:15.148401+03	2023-03-21 19:56:15.148401+03
68583c41-610a-462c-83b8-455ae1611abd	Пилигрим 1.5 литра	3e0d3794-b86f-482a-911e-31d030dd9d9a	7c982e60-5c62-4910-a9fd-dff08fce7d2d	\N	Пилигрим, талая, минеральная, питьевая, столовая вода, добывается в Архызском ущелье Северного Кавказа.	64168f45-bee2-4df4-936f-73f9e263dcef	2023-03-21 19:57:00.99163+03	2023-03-21 19:57:00.99163+03
3d7f7383-aa23-48c7-b7ff-97b1c9f17eb2	Кубай 5 литров	3e0d3794-b86f-482a-911e-31d030dd9d9a	7c982e60-5c62-4910-a9fd-dff08fce7d2d	\N	Горная, минеральная, питьевая, столовая вода добывается на территории Карачаево-Черкесской республики на Северном Кавказе	7fa16289-427b-4699-9d3a-cb1b6188ccd1	2023-03-21 20:00:29.072061+03	2023-03-21 20:00:29.072061+03
4a9b1142-00a4-48d5-95c6-5af7801f6731	Пилигрим 0.5 литра 	3e0d3794-b86f-482a-911e-31d030dd9d9a	7c982e60-5c62-4910-a9fd-dff08fce7d2d	\N	Пилигрим, талая, минеральная, питьевая, столовая вода, добывается в Архызском ущелье Северного Кавказа.	83582029-e5ca-458d-8dfe-934d032869d3	2023-03-21 19:57:55.541175+03	2023-03-21 19:57:55.541175+03
8cf086fc-f0a6-4f56-be00-20cd5d59a519	100Л	81857e29-e3d7-4f49-b419-1b4824c9fd38	5a77e2ed-99a4-4c03-a1a3-1df4f497b92d	2023-03-12 14:35:59.832+03	Ляляля	3006a1bd-a91f-4c26-8cea-ea4ede352dd0	2023-03-21 21:22:51.548728+03	2023-03-21 21:22:51.548728+03
9f4a8525-3765-494d-8cf8-79f83c072ef4	10	5ab86813-2dd4-49e5-a7ad-8dcdc47a0061	5a77e2ed-99a4-4c03-a1a3-1df4f497b92d	\N	12	b0ec12d7-0077-457c-acec-d4165e710ce6	2023-04-08 15:44:02.131578+03	2023-04-08 15:44:02.131578+03
51d8429e-3509-4d44-ba5a-2c212dbd8300	Кубай 19 литров	5ab86813-2dd4-49e5-a7ad-8dcdc47a0061	7c982e60-5c62-4910-a9fd-dff08fce7d2d	\N	Горная, минеральная, питьевая, столовая вода добывается на территории Карачаево-Черкесской республики на Северном Кавказе	407402de-10e5-4f0b-a956-76aaa60c7164	2023-03-21 19:59:32.692293+03	2023-03-21 19:59:32.692293+03
7634f662-a400-41ef-a9cf-db1ee0e86614	Кубай 19 литров	5ab86813-2dd4-49e5-a7ad-8dcdc47a0061	5a77e2ed-99a4-4c03-a1a3-1df4f497b92d	\N	Горная, минеральная, питьевая, столовая вода добывается на территории Карачаево-Черкесской республики на Северном Кавказе	5dc5e055-35a9-4fdc-b428-cb69cb20aa21	2023-03-21 19:50:25.348561+03	2023-03-21 19:50:25.348561+03
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.promotion (id, condition, promo_type, product_id, count, file_id, brand_id, deleted_at, created_at, updated_at, gift_name) FROM stdin;
f17a5cf6-d775-4904-bab3-cae4c95150cf	При заказе 5-х бутылей "Пилигрим Премиум" 19 литров - помпа в подарок	Количество товаров	9cbf8b03-061e-468f-a4d6-0361f1729bfd	5	1aba2447-0c03-48a9-9f58-6f8ed020e9cc	7c982e60-5c62-4910-a9fd-dff08fce7d2d	2023-02-21 22:11:45.975+03	2023-03-08 20:51:22.092378+03	2023-03-08 20:51:22.092378+03	\N
1866fbfe-2d77-40c9-97b9-32bd0e79d029	При заказе 4-х бутылей "Пилигрим Премиум" 19 литров - помпа в подарок	Количество товаров	d30ca210-1fdd-413e-9e61-629e0d3c44df	14	a4064c08-96aa-4da4-9502-6883d4f6c108	7c982e60-5c62-4910-a9fd-dff08fce7d2d	\N	2023-03-08 22:00:21.048744+03	2023-03-08 22:00:21.048744+03	\N
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public.status (id, name, created_at, updated_at) FROM stdin;
918a5cc4-7df1-4a2a-9130-58d60f87bcde	Выполнена	2023-02-21 22:11:52.423145+03	2023-02-21 22:11:52.423145+03
b1072840-a96a-4b34-9535-a06de4f4ca56	Новый	2023-02-21 22:13:04.166234+03	2023-02-21 22:13:04.166234+03
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: node
--

COPY public."user" (id, login, password, refresh_token, device_id, role, created_at, updated_at, phone) FROM stdin;
497def3b-4626-4f35-a25c-16525a81c033	admin	$2a$12$iqf7PHmRGAR6MQ8sKRK8lemwYqer/UxZr5lb.LtO8yP6fMY7HITJm	$2b$10$IIYlOBFYLM3fp7Q167epC.It0fuA9Xt2FRVcWrXYhpE2ZUt1YZGl.	778086c0-d3d5-11ed-801c-cb1e9cf534fc	Администратор	2023-02-19 19:58:58.580421+03	2023-02-19 19:58:58.580421+03	\N
c6b17b47-2413-4c4c-a735-0b7361c0ae2d	slpv	$2a$12$gFkdVlYh25XXIO16dApV7OgyJNpO73qmY9ueX2lq48CQl.tC.BfXa	$2b$10$OkPUvgOVp8yLZl/RMG5OtOrEHaRJ5iE2qimwp0zBLiayis8jBOcJ2	2b8911b0-f306-11ed-a2b8-139277f36cf8	Администратор	2023-02-19 19:47:17.687466+03	2023-02-19 19:47:17.687466+03	\N
\.


--
-- Name: category_priority_seq; Type: SEQUENCE SET; Schema: public; Owner: node
--

SELECT pg_catalog.setval('public.category_priority_seq', 3, true);


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: node
--

SELECT pg_catalog.setval('public.knex_migrations_id_seq', 49, true);


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: node
--

SELECT pg_catalog.setval('public.knex_migrations_lock_index_seq', 1, true);


--
-- Name: brand brand_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.brand
    ADD CONSTRAINT brand_pkey PRIMARY KEY (id);


--
-- Name: callback_request callback_request_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.callback_request
    ADD CONSTRAINT callback_request_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: configuration configuration_key_unique; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.configuration
    ADD CONSTRAINT configuration_key_unique UNIQUE (key);


--
-- Name: configuration configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.configuration
    ADD CONSTRAINT configuration_pkey PRIMARY KEY (id);


--
-- Name: file file_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_pkey PRIMARY KEY (id);


--
-- Name: product item_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT item_pkey PRIMARY KEY (id);


--
-- Name: knex_migrations_lock knex_migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: knex_migrations knex_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);


--
-- Name: order_product order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.order_product
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (id);


--
-- Name: partner partner_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.partner
    ADD CONSTRAINT partner_pkey PRIMARY KEY (id);


--
-- Name: pricing pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.pricing
    ADD CONSTRAINT pricing_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id);


--
-- Name: user user_login_unique; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_login_unique UNIQUE (login);


--
-- Name: user user_phone_unique; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_phone_unique UNIQUE (phone);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: brand brand_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.brand
    ADD CONSTRAINT brand_file_id_foreign FOREIGN KEY (file_id) REFERENCES public.file(id);


--
-- Name: callback_request callbackrequest_status_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.callback_request
    ADD CONSTRAINT callbackrequest_status_id_foreign FOREIGN KEY (status_id) REFERENCES public.status(id);


--
-- Name: category category_parent_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_parent_id_foreign FOREIGN KEY (parent_id) REFERENCES public.category(id);


--
-- Name: product item_brand_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT item_brand_id_foreign FOREIGN KEY (brand_id) REFERENCES public.brand(id);


--
-- Name: product item_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT item_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- Name: order_product order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.order_product
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: order order_status_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_status_id_foreign FOREIGN KEY (status_id) REFERENCES public.status(id);


--
-- Name: order_promotion orderpromotion_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT orderpromotion_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: pricing pricing_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.pricing
    ADD CONSTRAINT pricing_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: product product_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_file_id_foreign FOREIGN KEY (file_id) REFERENCES public.file(id);


--
-- Name: promotion promotion_brand_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_brand_id_foreign FOREIGN KEY (brand_id) REFERENCES public.brand(id);


--
-- Name: promotion promotion_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_file_id_foreign FOREIGN KEY (file_id) REFERENCES public.file(id);


--
-- Name: promotion promotion_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: node
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- PostgreSQL database dump complete
--

