--
-- PostgreSQL database dump
--

\restrict 9yJmHPVvIF6TMmp7rqKW0bjegk37v3xbjEF9wAWdAAUdw8a9TWoRR0JHOgmglWC

-- Dumped from database version 14.19 (Homebrew)
-- Dumped by pg_dump version 14.19 (Homebrew)

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
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


--
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


--
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_holder; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_holder (
    id text NOT NULL,
    provider_id text NOT NULL,
    external_id text NOT NULL,
    email text,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: api_key; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);


--
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


--
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: capture; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


--
-- Name: cart; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone
);


--
-- Name: cart_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    product_type_id text,
    is_custom_price boolean DEFAULT false NOT NULL,
    is_giftcard boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


--
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


--
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);


--
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


--
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


--
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


--
-- Name: credit_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credit_line (
    id text NOT NULL,
    cart_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: currency; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: customer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


--
-- Name: customer_account_holder; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_account_holder (
    customer_id character varying(255) NOT NULL,
    account_holder_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


--
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


--
-- Name: image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer DEFAULT 0 NOT NULL,
    product_id text NOT NULL
);


--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


--
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


--
-- Name: invite; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


--
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone
);


--
-- Name: order_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_cart; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_change; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


--
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- Name: order_claim; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_credit_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_credit_line (
    id text NOT NULL,
    order_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    version integer DEFAULT 1 NOT NULL
);


--
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


--
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL,
    product_type_id text,
    is_giftcard boolean DEFAULT false NOT NULL
);


--
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone,
    is_tax_inclusive boolean DEFAULT false NOT NULL
);


--
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


--
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


--
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_summary; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


--
-- Name: payment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


--
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text, 'failed'::text, 'partially_captured'::text, 'completed'::text])))
);


--
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: payment_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text])))
);


--
-- Name: price; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity integer,
    max_quantity integer
);


--
-- Name: price_list; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


--
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


--
-- Name: price_preference; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: price_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL,
    operator text DEFAULT 'eq'::text NOT NULL,
    CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text])))
);


--
-- Name: price_set; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


--
-- Name: product_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb
);


--
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product_option; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product_shipping_profile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_shipping_profile (
    product_id character varying(255) NOT NULL,
    shipping_profile_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product_tag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


--
-- Name: product_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    thumbnail text
);


--
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


--
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: product_variant_product_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variant_product_image (
    id text NOT NULL,
    variant_id text NOT NULL,
    image_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: promotion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'draft'::text NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT promotion_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'inactive'::text]))),
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


--
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity integer,
    apply_to_quantity integer,
    buy_rules_min_quantity integer,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text, 'once'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


--
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    attribute text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text, 'use_by_attribute'::text, 'spend_by_attribute'::text])))
);


--
-- Name: promotion_campaign_budget_usage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_campaign_budget_usage (
    id text NOT NULL,
    attribute_value text NOT NULL,
    used numeric DEFAULT 0 NOT NULL,
    budget_id text NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


--
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


--
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: refund; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


--
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    code text NOT NULL
);


--
-- Name: region; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


--
-- Name: region_country; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


--
-- Name: return; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


--
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: return_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb NOT NULL
);


--
-- Name: return_reason; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.return_reason (
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL,
    description character varying,
    metadata jsonb,
    parent_return_reason_id character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: script_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.script_migrations (
    id integer NOT NULL,
    script_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone
);


--
-- Name: script_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.script_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: script_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.script_migrations_id_seq OWNED BY public.script_migrations.id;


--
-- Name: service_zone; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


--
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


--
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


--
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


--
-- Name: store; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: store_currency; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


--
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


--
-- Name: tax_region; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: user_preference; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_preference (
    id text NOT NULL,
    user_id text NOT NULL,
    key text NOT NULL,
    value jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: view_configuration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.view_configuration (
    id text NOT NULL,
    entity text NOT NULL,
    name text,
    user_id text,
    is_system_default boolean DEFAULT false NOT NULL,
    configuration jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflow_execution (
    id character varying NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    retention_time integer,
    run_id text DEFAULT '01K9FZ7R28FFCDE2RQG33K9H4D'::text NOT NULL
);


--
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- Name: script_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.script_migrations ALTER COLUMN id SET DEFAULT nextval('public.script_migrations_id_seq'::regclass);


--
-- Data for Name: account_holder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.account_holder (id, provider_id, external_id, email, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at, deleted_at) FROM stdin;
apk_01K9FZ96ZVNY23NP4XVKAM23PS	pk_f1e1f52b9d9a06b31c0a0d75e188818220ea0bc3aaae1df27e2e8720ec56cc9b		pk_f1e***c9b	Webshop	publishable	\N		2025-11-07 17:14:17.595-03	\N	\N	2025-11-07 17:14:17.595-03	\N
\.


--
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at, deleted_at) FROM stdin;
authid_01K9FZ84PR5NN9AZ8WRYZP87GS	{"user_id": "user_01K9FZ84MEBHSJNASQJ9P3XR5D"}	2025-11-07 17:13:42.488-03	2025-11-07 17:13:42.494-03	\N
\.


--
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
\.


--
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, product_type_id, is_custom_price, is_giftcard) FROM stdin;
\.


--
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: credit_line; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.credit_line (id, cart_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2025-11-07 17:13:30.83-03	2025-11-07 17:13:30.83-03	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2025-11-07 17:13:30.83-03	2025-11-07 17:13:30.83-03	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2025-11-07 17:13:30.831-03	2025-11-07 17:13:30.831-03	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mwk	K	K	2	0	{"value": "0", "precision": 20}	Malawian Kwacha	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
tjs	TJS	с.	2	0	{"value": "0", "precision": 20}	Tajikistani Somoni	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
try	₺	₺	2	0	{"value": "0", "precision": 20}	Turkish Lira	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
xpf	₣	₣	0	0	{"value": "0", "precision": 20}	CFP Franc	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2025-11-07 17:13:30.832-03	2025-11-07 17:13:30.832-03	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
\.


--
-- Data for Name: customer_account_holder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer_account_holder (customer_id, account_holder_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
cgrp_f2a3d9b931e712a048ddbb3620	MercadoLibre	{"channel": "mercadolibre"}	\N	2025-11-08 00:37:26.027194-03	2025-11-08 00:37:26.027194-03	\N
cgrp_f0e8cad857cdc25272d8940147	Público General	{"channel": "web"}	\N	2025-11-08 00:37:26.030289-03	2025-11-08 00:37:26.030289-03	\N
cgrp_79f40ca34a961773cec3f2ace8	Mayorista	{"channel": "direct"}	\N	2025-11-08 00:37:26.030744-03	2025-11-08 00:37:26.030744-03	\N
\.


--
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fulfillment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
manual_manual	t	2025-11-07 17:13:30.867-03	2025-11-07 17:13:30.867-03	\N
\.


--
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01K9FZ96X4Q0137FGQX26XCACZ	European Warehouse delivery	shipping	\N	2025-11-07 17:14:17.508-03	2025-11-07 17:14:17.508-03	\N
\.


--
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
fgz_01K9FZ96X3GK1YGY12KSQ8KG74	country	gb	\N	\N	serzo_01K9FZ96X41VSMYTYDMT6K3NGK	\N	\N	2025-11-07 17:14:17.508-03	2025-11-07 17:14:17.508-03	\N
fgz_01K9FZ96X310RMZAARGEX7802K	country	de	\N	\N	serzo_01K9FZ96X41VSMYTYDMT6K3NGK	\N	\N	2025-11-07 17:14:17.508-03	2025-11-07 17:14:17.508-03	\N
fgz_01K9FZ96X3VY18T5SHBVJBQEJN	country	dk	\N	\N	serzo_01K9FZ96X41VSMYTYDMT6K3NGK	\N	\N	2025-11-07 17:14:17.508-03	2025-11-07 17:14:17.508-03	\N
fgz_01K9FZ96X3VK0HJTRBXYF7ES11	country	se	\N	\N	serzo_01K9FZ96X41VSMYTYDMT6K3NGK	\N	\N	2025-11-07 17:14:17.508-03	2025-11-07 17:14:17.508-03	\N
fgz_01K9FZ96X3ZPMD7X771725ZYCP	country	fr	\N	\N	serzo_01K9FZ96X41VSMYTYDMT6K3NGK	\N	\N	2025-11-07 17:14:17.508-03	2025-11-07 17:14:17.508-03	\N
fgz_01K9FZ96X3YYJCC1H2CDRTJRH6	country	es	\N	\N	serzo_01K9FZ96X41VSMYTYDMT6K3NGK	\N	\N	2025-11-07 17:14:17.508-03	2025-11-07 17:14:17.508-03	\N
fgz_01K9FZ96X4F2WCPZGVE7JFKCN8	country	it	\N	\N	serzo_01K9FZ96X41VSMYTYDMT6K3NGK	\N	\N	2025-11-07 17:14:17.508-03	2025-11-07 17:14:17.508-03	\N
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at, rank, product_id) FROM stdin;
img_01K9FZ970T7ZXA353R3E01BSXF	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	0	prod_01K9FZ970RSD7N0DMX4FEQRVN9
img_01K9FZ970T4Y4D2Z8PWFYYHAZG	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-back.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	1	prod_01K9FZ970RSD7N0DMX4FEQRVN9
img_01K9FZ970TRA8KQWKYPPNVF9RC	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-front.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	2	prod_01K9FZ970RSD7N0DMX4FEQRVN9
img_01K9FZ970TGQ8187Z2YYXJHP47	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-back.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	3	prod_01K9FZ970RSD7N0DMX4FEQRVN9
img_01K9FZ970TN8TR040Z6ZKJNFR7	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	0	prod_01K9FZ970RCZ4H4TH9K29KFQC9
img_01K9FZ970TB1EKRG9YZVJGPM3C	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-back.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	1	prod_01K9FZ970RCZ4H4TH9K29KFQC9
img_01K9FZ970V4NGFNBKXE1VG2QTA	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	0	prod_01K9FZ970RS631Y32XVXC9RM35
img_01K9FZ970VBGQD0GMHF1R5MJY5	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-back.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	1	prod_01K9FZ970RS631Y32XVXC9RM35
img_01K9FZ970V983SZ1GYF6ZET39A	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	0	prod_01K9FZ970RSVV1Z5ZFSJQZ98CK
img_01K9FZ970V5Z7PX88TR4PKR7ZD	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-back.png	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	1	prod_01K9FZ970RSVV1Z5ZFSJQZ98CK
yjeyjb	http://localhost:9000/static/1762564698064-cs200a_page2_img10.png	\N	2025-11-07 22:18:18.344-03	2025-11-07 22:18:18.344-03	\N	5	prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0
rk70tg	http://localhost:9000/static/1762564698069-cs200a_page2_img11.jpeg	\N	2025-11-07 22:18:18.344-03	2025-11-07 22:18:18.344-03	\N	6	prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0
x7ccwk	http://localhost:9000/static/1762564697957-cs200a_full_page_1.png	\N	2025-11-07 22:18:18.344-03	2025-11-07 22:19:40.154-03	\N	1	prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0
qka0t8	http://localhost:9000/static/1762564698071-cs200a_full_page_2.png	\N	2025-11-07 22:18:18.344-03	2025-11-07 22:19:40.154-03	\N	2	prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0
e7ezg	http://localhost:9000/static/1762564698083-cs200a_page1_img3.png	\N	2025-11-07 22:18:18.344-03	2025-11-07 22:19:40.154-03	\N	3	prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0
0clcm7	http://localhost:9000/static/1762564697981-cs200a_page2_img3.png	\N	2025-11-07 22:18:18.344-03	2025-11-07 22:19:40.154-03	\N	0	prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0
zu1yo8	http://localhost:9000/static/1762564698000-cs200a_page2_img7.png	\N	2025-11-07 22:18:18.344-03	2025-11-07 22:19:40.154-03	\N	7	prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0
ocve9h	http://localhost:9000/static/1762564698070-cs200a_page2_img12.png	\N	2025-11-07 22:18:18.344-03	2025-11-07 22:19:40.154-03	\N	4	prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
iitem_01K9FZ973611A8P5WGG02DAG23	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SHIRT-S-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	S / Black	S / Black	\N	\N
iitem_01K9FZ9736F9JC8G3G04N1QSBK	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SHIRT-S-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	S / White	S / White	\N	\N
iitem_01K9FZ9736CCPSMM7XZWS5927P	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SHIRT-M-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	M / Black	M / Black	\N	\N
iitem_01K9FZ9736ETN9NTBKHZ5VAH1Y	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SHIRT-M-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	M / White	M / White	\N	\N
iitem_01K9FZ9736PPXB6RVYKJN3CQ94	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SHIRT-L-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	L / Black	L / Black	\N	\N
iitem_01K9FZ9736WNDW19QYYPSCPD1M	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SHIRT-L-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	L / White	L / White	\N	\N
iitem_01K9FZ97362R9DFHCFGCWA60C0	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SHIRT-XL-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / Black	XL / Black	\N	\N
iitem_01K9FZ9736PE137JZ4J9J8EJAG	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SHIRT-XL-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / White	XL / White	\N	\N
iitem_01K9FZ97374Q5G5R8M1H6SSASB	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SWEATSHIRT-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K9FZ9737AZHA5QD1BTPEN09V	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SWEATSHIRT-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K9FZ97373XHF2FEGGNH5A7KE	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SWEATSHIRT-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K9FZ97371Q4HPQBGXH7Z5R55	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SWEATSHIRT-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K9FZ97373JRQG6JC3NW8WPBT	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SWEATPANTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K9FZ97379W73VZRT9ZRKXS4D	2025-11-07 17:14:17.703-03	2025-11-07 17:14:17.703-03	\N	SWEATPANTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K9FZ9737KSSDM5V1W8VBGMC9	2025-11-07 17:14:17.704-03	2025-11-07 17:14:17.704-03	\N	SWEATPANTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K9FZ9737GZAPCXBHFB7QCTFV	2025-11-07 17:14:17.704-03	2025-11-07 17:14:17.704-03	\N	SWEATPANTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K9FZ97375DA2GPVH1TPDTZ66	2025-11-07 17:14:17.704-03	2025-11-07 17:14:17.704-03	\N	SHORTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K9FZ9737ZYKJSJ1KXMNSQNGP	2025-11-07 17:14:17.704-03	2025-11-07 17:14:17.704-03	\N	SHORTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K9FZ973712P49XBRW8G7VNPA	2025-11-07 17:14:17.704-03	2025-11-07 17:14:17.704-03	\N	SHORTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K9FZ973705T6YAQS7A4FBN3C	2025-11-07 17:14:17.704-03	2025-11-07 17:14:17.704-03	\N	SHORTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
\.


--
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
ilev_01K9FZ975B3BY0VQXTN47RSVQK	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ973611A8P5WGG02DAG23	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975BKCCG43E4CX24D633	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ97362R9DFHCFGCWA60C0	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B1NVFPR3DMYJ49TW4	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9736CCPSMM7XZWS5927P	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B5YTCYK1174FNNMNW	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9736ETN9NTBKHZ5VAH1Y	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B214RTFMDY2BT1RCP	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9736F9JC8G3G04N1QSBK	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B1T1296Y3J4XSMZK9	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9736PE137JZ4J9J8EJAG	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975BY075KE1CA6CD1GCE	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9736PPXB6RVYKJN3CQ94	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975BEW1WG0FQ3SQS37DE	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9736WNDW19QYYPSCPD1M	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975BAVXEPJD1RRQKMNMC	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ973705T6YAQS7A4FBN3C	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B2PJ5FRDNJCK6W6WA	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ973712P49XBRW8G7VNPA	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975BYYD3VW6ZA378Y1PY	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ97371Q4HPQBGXH7Z5R55	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B1WNZWCP6P6JM5FV0	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ97373JRQG6JC3NW8WPBT	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975BWN2FDEMXK12CCNC8	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ97373XHF2FEGGNH5A7KE	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975BC725X4BZP4SK9PCD	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ97374Q5G5R8M1H6SSASB	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B0ZTDG04C6KJXM1HR	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ97375DA2GPVH1TPDTZ66	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975BST4296YEN0E0EBH0	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ97379W73VZRT9ZRKXS4D	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B26HC1J5CSJW6VESR	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9737AZHA5QD1BTPEN09V	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975BG5SQFQ0DDHY53ESX	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9737GZAPCXBHFB7QCTFV	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B2W96QD9BTVYTWNCB	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9737KSSDM5V1W8VBGMC9	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K9FZ975B7PAZTYW77D2K6AF0	2025-11-07 17:14:17.772-03	2025-11-07 17:14:17.772-03	\N	iitem_01K9FZ9737ZYKJSJ1KXMNSQNGP	sloc_01K9FZ96WA8AZB10YV6GRWBM87	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
\.


--
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2025-11-07 17:13:29.768345
3	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-11-07 17:13:29.768532
2	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-11-07 17:13:29.768498
4	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2025-11-07 17:13:29.769798
5	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2025-11-07 17:13:29.770093
6	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2025-11-07 17:13:29.77151
7	order_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2025-11-07 17:13:29.771668
8	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2025-11-07 17:13:29.772682
9	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2025-11-07 17:13:29.772741
10	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2025-11-07 17:13:29.772586
11	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2025-11-07 17:13:29.777447
12	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2025-11-07 17:13:29.778115
13	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2025-11-07 17:13:29.77833
14	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2025-11-07 17:13:29.778419
15	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2025-11-07 17:13:29.778591
16	product_shipping_profile	{"toModel": "shipping_profile", "toModule": "fulfillment", "fromModel": "product", "fromModule": "product"}	2025-11-07 17:13:29.778633
17	customer_account_holder	{"toModel": "account_holder", "toModule": "payment", "fromModel": "customer", "fromModule": "customer"}	2025-11-07 17:13:29.778664
18	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2025-11-07 17:13:29.778769
\.


--
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K9FZ96WA8AZB10YV6GRWBM87	manual_manual	locfp_01K9FZ96WSB6N1MA4R45WZNZGQ	2025-11-07 17:14:17.496981-03	2025-11-07 17:14:17.496981-03	\N
\.


--
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K9FZ96WA8AZB10YV6GRWBM87	fuset_01K9FZ96X4Q0137FGQX26XCACZ	locfs_01K9FZ96XMX9BY6G3A4N71THC4	2025-11-07 17:14:17.524113-03	2025-11-07 17:14:17.524113-03	\N
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20240307161216	2025-11-07 17:13:28.482827-03
2	Migration20241210073813	2025-11-07 17:13:28.482827-03
3	Migration20250106142624	2025-11-07 17:13:28.482827-03
4	Migration20250120110820	2025-11-07 17:13:28.482827-03
5	Migration20240307132720	2025-11-07 17:13:28.54886-03
6	Migration20240719123015	2025-11-07 17:13:28.54886-03
7	Migration20241213063611	2025-11-07 17:13:28.54886-03
8	Migration20251010131115	2025-11-07 17:13:28.54886-03
9	InitialSetup20240401153642	2025-11-07 17:13:28.623757-03
10	Migration20240601111544	2025-11-07 17:13:28.623757-03
11	Migration202408271511	2025-11-07 17:13:28.623757-03
12	Migration20241122120331	2025-11-07 17:13:28.623757-03
13	Migration20241125090957	2025-11-07 17:13:28.623757-03
14	Migration20250411073236	2025-11-07 17:13:28.623757-03
15	Migration20250516081326	2025-11-07 17:13:28.623757-03
16	Migration20250910154539	2025-11-07 17:13:28.623757-03
17	Migration20250911092221	2025-11-07 17:13:28.623757-03
18	Migration20250929204438	2025-11-07 17:13:28.623757-03
19	Migration20251008132218	2025-11-07 17:13:28.623757-03
20	Migration20251011090511	2025-11-07 17:13:28.623757-03
21	Migration20230929122253	2025-11-07 17:13:28.712082-03
22	Migration20240322094407	2025-11-07 17:13:28.712082-03
23	Migration20240322113359	2025-11-07 17:13:28.712082-03
24	Migration20240322120125	2025-11-07 17:13:28.712082-03
25	Migration20240626133555	2025-11-07 17:13:28.712082-03
26	Migration20240704094505	2025-11-07 17:13:28.712082-03
27	Migration20241127114534	2025-11-07 17:13:28.712082-03
28	Migration20241127223829	2025-11-07 17:13:28.712082-03
29	Migration20241128055359	2025-11-07 17:13:28.712082-03
30	Migration20241212190401	2025-11-07 17:13:28.712082-03
31	Migration20250408145122	2025-11-07 17:13:28.712082-03
32	Migration20250409122219	2025-11-07 17:13:28.712082-03
33	Migration20251009110625	2025-11-07 17:13:28.712082-03
34	Migration20240227120221	2025-11-07 17:13:28.78924-03
35	Migration20240617102917	2025-11-07 17:13:28.78924-03
36	Migration20240624153824	2025-11-07 17:13:28.78924-03
37	Migration20241211061114	2025-11-07 17:13:28.78924-03
38	Migration20250113094144	2025-11-07 17:13:28.78924-03
39	Migration20250120110700	2025-11-07 17:13:28.78924-03
40	Migration20250226130616	2025-11-07 17:13:28.78924-03
41	Migration20250508081510	2025-11-07 17:13:28.78924-03
42	Migration20250828075407	2025-11-07 17:13:28.78924-03
43	Migration20250909083125	2025-11-07 17:13:28.78924-03
44	Migration20250916120552	2025-11-07 17:13:28.78924-03
45	Migration20250917143818	2025-11-07 17:13:28.78924-03
46	Migration20250919122137	2025-11-07 17:13:28.78924-03
47	Migration20251006000000	2025-11-07 17:13:28.78924-03
48	Migration20240124154000	2025-11-07 17:13:28.860709-03
49	Migration20240524123112	2025-11-07 17:13:28.860709-03
50	Migration20240602110946	2025-11-07 17:13:28.860709-03
51	Migration20241211074630	2025-11-07 17:13:28.860709-03
52	Migration20251010130829	2025-11-07 17:13:28.860709-03
53	Migration20240115152146	2025-11-07 17:13:28.893183-03
54	Migration20240222170223	2025-11-07 17:13:28.907384-03
55	Migration20240831125857	2025-11-07 17:13:28.907384-03
56	Migration20241106085918	2025-11-07 17:13:28.907384-03
57	Migration20241205095237	2025-11-07 17:13:28.907384-03
58	Migration20241216183049	2025-11-07 17:13:28.907384-03
59	Migration20241218091938	2025-11-07 17:13:28.907384-03
60	Migration20250120115059	2025-11-07 17:13:28.907384-03
61	Migration20250212131240	2025-11-07 17:13:28.907384-03
62	Migration20250326151602	2025-11-07 17:13:28.907384-03
63	Migration20250508081553	2025-11-07 17:13:28.907384-03
64	Migration20251017153909	2025-11-07 17:13:28.907384-03
65	Migration20240205173216	2025-11-07 17:13:28.965735-03
66	Migration20240624200006	2025-11-07 17:13:28.965735-03
67	Migration20250120110744	2025-11-07 17:13:28.965735-03
68	InitialSetup20240221144943	2025-11-07 17:13:29.024159-03
69	Migration20240604080145	2025-11-07 17:13:29.024159-03
70	Migration20241205122700	2025-11-07 17:13:29.024159-03
71	Migration20251015123842	2025-11-07 17:13:29.024159-03
72	InitialSetup20240227075933	2025-11-07 17:13:29.043897-03
73	Migration20240621145944	2025-11-07 17:13:29.043897-03
74	Migration20241206083313	2025-11-07 17:13:29.043897-03
75	Migration20240227090331	2025-11-07 17:13:29.063587-03
76	Migration20240710135844	2025-11-07 17:13:29.063587-03
77	Migration20240924114005	2025-11-07 17:13:29.063587-03
78	Migration20241212052837	2025-11-07 17:13:29.063587-03
79	InitialSetup20240228133303	2025-11-07 17:13:29.097762-03
80	Migration20240624082354	2025-11-07 17:13:29.097762-03
81	Migration20240225134525	2025-11-07 17:13:29.111261-03
82	Migration20240806072619	2025-11-07 17:13:29.111261-03
83	Migration20241211151053	2025-11-07 17:13:29.111261-03
84	Migration20250115160517	2025-11-07 17:13:29.111261-03
85	Migration20250120110552	2025-11-07 17:13:29.111261-03
86	Migration20250123122334	2025-11-07 17:13:29.111261-03
87	Migration20250206105639	2025-11-07 17:13:29.111261-03
88	Migration20250207132723	2025-11-07 17:13:29.111261-03
89	Migration20250625084134	2025-11-07 17:13:29.111261-03
90	Migration20250924135437	2025-11-07 17:13:29.111261-03
91	Migration20250929124701	2025-11-07 17:13:29.111261-03
92	Migration20240219102530	2025-11-07 17:13:29.16535-03
93	Migration20240604100512	2025-11-07 17:13:29.16535-03
94	Migration20240715102100	2025-11-07 17:13:29.16535-03
95	Migration20240715174100	2025-11-07 17:13:29.16535-03
96	Migration20240716081800	2025-11-07 17:13:29.16535-03
97	Migration20240801085921	2025-11-07 17:13:29.16535-03
98	Migration20240821164505	2025-11-07 17:13:29.16535-03
99	Migration20240821170920	2025-11-07 17:13:29.16535-03
100	Migration20240827133639	2025-11-07 17:13:29.16535-03
101	Migration20240902195921	2025-11-07 17:13:29.16535-03
102	Migration20240913092514	2025-11-07 17:13:29.16535-03
103	Migration20240930122627	2025-11-07 17:13:29.16535-03
104	Migration20241014142943	2025-11-07 17:13:29.16535-03
105	Migration20241106085223	2025-11-07 17:13:29.16535-03
106	Migration20241129124827	2025-11-07 17:13:29.16535-03
107	Migration20241217162224	2025-11-07 17:13:29.16535-03
108	Migration20250326151554	2025-11-07 17:13:29.16535-03
109	Migration20250522181137	2025-11-07 17:13:29.16535-03
110	Migration20250702095353	2025-11-07 17:13:29.16535-03
111	Migration20250704120229	2025-11-07 17:13:29.16535-03
112	Migration20250910130000	2025-11-07 17:13:29.16535-03
113	Migration20251016182939	2025-11-07 17:13:29.16535-03
114	Migration20251017155709	2025-11-07 17:13:29.16535-03
115	Migration20250717162007	2025-11-07 17:13:29.309268-03
116	Migration20240205025928	2025-11-07 17:13:29.327072-03
117	Migration20240529080336	2025-11-07 17:13:29.327072-03
118	Migration20241202100304	2025-11-07 17:13:29.327072-03
119	Migration20240214033943	2025-11-07 17:13:29.365992-03
120	Migration20240703095850	2025-11-07 17:13:29.365992-03
121	Migration20241202103352	2025-11-07 17:13:29.365992-03
122	Migration20240311145700_InitialSetupMigration	2025-11-07 17:13:29.393407-03
123	Migration20240821170957	2025-11-07 17:13:29.393407-03
124	Migration20240917161003	2025-11-07 17:13:29.393407-03
125	Migration20241217110416	2025-11-07 17:13:29.393407-03
126	Migration20250113122235	2025-11-07 17:13:29.393407-03
127	Migration20250120115002	2025-11-07 17:13:29.393407-03
128	Migration20250822130931	2025-11-07 17:13:29.393407-03
129	Migration20250825132614	2025-11-07 17:13:29.393407-03
130	Migration20240509083918_InitialSetupMigration	2025-11-07 17:13:29.470576-03
131	Migration20240628075401	2025-11-07 17:13:29.470576-03
132	Migration20240830094712	2025-11-07 17:13:29.470576-03
133	Migration20250120110514	2025-11-07 17:13:29.470576-03
134	Migration20251028172715	2025-11-07 17:13:29.470576-03
135	Migration20231228143900	2025-11-07 17:13:29.532392-03
136	Migration20241206101446	2025-11-07 17:13:29.532392-03
137	Migration20250128174331	2025-11-07 17:13:29.532392-03
138	Migration20250505092459	2025-11-07 17:13:29.532392-03
139	Migration20250819104213	2025-11-07 17:13:29.532392-03
140	Migration20250819110924	2025-11-07 17:13:29.532392-03
141	Migration20250908080305	2025-11-07 17:13:29.532392-03
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2025-11-07 17:13:30.852-03	2025-11-07 17:13:30.852-03	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_credit_line; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_credit_line (id, order_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at, version) FROM stdin;
\.


--
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
\.


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price, product_type_id, is_giftcard) FROM stdin;
\.


--
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
pp_system_default	t	2025-11-07 17:13:30.851-03	2025-11-07 17:13:30.851-03	\N
\.


--
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity) FROM stdin;
price_01K9FZ96YSM13VTWVC1VE4Q6N3	\N	pset_01K9FZ96YSMGE9BESK0MMP4R1Q	usd	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N	\N	10	\N	\N
price_01K9FZ96YSSHFQR8JZNS5G5F64	\N	pset_01K9FZ96YSMGE9BESK0MMP4R1Q	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N	\N	10	\N	\N
price_01K9FZ96YSME51ZTP1YCXDTJMR	\N	pset_01K9FZ96YSMGE9BESK0MMP4R1Q	eur	{"value": "10", "precision": 20}	1	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N	\N	10	\N	\N
price_01K9FZ96YSKZ0FM96G6D2SVYMM	\N	pset_01K9FZ96YSG4A29EKE1TGMP73X	usd	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N	\N	10	\N	\N
price_01K9FZ96YS3KZVXS8J3X217A9A	\N	pset_01K9FZ96YSG4A29EKE1TGMP73X	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N	\N	10	\N	\N
price_01K9FZ96YSZTZS0B6JA61SSTZH	\N	pset_01K9FZ96YSG4A29EKE1TGMP73X	eur	{"value": "10", "precision": 20}	1	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N	\N	10	\N	\N
price_01K9FZ973WKH10S5HDVDPP1ZW0	\N	pset_01K9FZ973W7H2SZ3JW3PVFJGA4	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973WHBFW9MMF9YSDVCNV	\N	pset_01K9FZ973W7H2SZ3JW3PVFJGA4	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973WT9AMDKTEJD16ZTXF	\N	pset_01K9FZ973WEEMCREH4XV39KN8Z	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973WEZH83N6XZBPCDRVM	\N	pset_01K9FZ973WEEMCREH4XV39KN8Z	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973WB4ZYZBZA1PZ6X65V	\N	pset_01K9FZ973WE8V486M94HTA3XWZ	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973WPJE9BYGA17Z63JJY	\N	pset_01K9FZ973WE8V486M94HTA3XWZ	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973WDRXSHXH38W81SQ53	\N	pset_01K9FZ973X7Y16QZC1GNN955R9	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973XQTGC22RE7R28GAPG	\N	pset_01K9FZ973X7Y16QZC1GNN955R9	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973XYVZ32D2C9R7HKZAX	\N	pset_01K9FZ973XRRW49YKSJY321ZQP	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973XJB5R6ZAKVVJNXS2W	\N	pset_01K9FZ973XRRW49YKSJY321ZQP	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973XAAZVY0AY3DGQ1792	\N	pset_01K9FZ973XJWF9YVXRMAMWR2GT	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973X9EX27DC070Z6EMPG	\N	pset_01K9FZ973XJWF9YVXRMAMWR2GT	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973XM5SYAHPED8F3YG4Y	\N	pset_01K9FZ973X2CDXF4A5YP421XK9	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973XYDMFSD0FRWAPCRJH	\N	pset_01K9FZ973X2CDXF4A5YP421XK9	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973X3EM2B97TJE3HRFWX	\N	pset_01K9FZ973X10YFF4GXNWF2GXGT	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973XA5Z2C3NX7JT3EC0W	\N	pset_01K9FZ973X10YFF4GXNWF2GXGT	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973XNSBVGGZY2KDWGC7R	\N	pset_01K9FZ973X58JC159DCEAJN7ZA	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973XE12XBFEQMXPB3FSJ	\N	pset_01K9FZ973X58JC159DCEAJN7ZA	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973X4A5DVX6JF32XC3V8	\N	pset_01K9FZ973YSCAHYD5FR1J996SG	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973X86748B4TSCSN5MYN	\N	pset_01K9FZ973YSCAHYD5FR1J996SG	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973YJ4BZHS7JW1DTFJ2C	\N	pset_01K9FZ973YCF7B0V7YDN59P2Y2	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973Y2D6Z1FG1EPY4T1N1	\N	pset_01K9FZ973YCF7B0V7YDN59P2Y2	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973Y88E0XN7APYYQYMR2	\N	pset_01K9FZ973YHHNMVWH0HR8ZX7P9	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973YYNGG1M0GTN42VNGC	\N	pset_01K9FZ973YHHNMVWH0HR8ZX7P9	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973Y24Y9QK3E46WMZR2N	\N	pset_01K9FZ973YSJG4RRYNHQFCPW9V	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973Y2Y95GHVFDV5XN1GP	\N	pset_01K9FZ973YSJG4RRYNHQFCPW9V	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	15	\N	\N
price_01K9FZ973YMV1ASXFEE2EV0G14	\N	pset_01K9FZ973Y4PE3D5WDH3G49KXJ	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N	\N	10	\N	\N
price_01K9FZ973YC7X3FP48M1KXFS8P	\N	pset_01K9FZ973Y4PE3D5WDH3G49KXJ	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	15	\N	\N
price_01K9FZ973Y39W1T7T5QSSTTX1Y	\N	pset_01K9FZ973YQBYWN9A60F1WDE1E	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	10	\N	\N
price_01K9FZ973YEFS6V1B0G8556AMV	\N	pset_01K9FZ973YQBYWN9A60F1WDE1E	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	15	\N	\N
price_01K9FZ973YZCZATF11YWQ50F2E	\N	pset_01K9FZ973Y4A7SNSD9JW0H5X4S	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	10	\N	\N
price_01K9FZ973YW3J80V6TBAA516RJ	\N	pset_01K9FZ973Y4A7SNSD9JW0H5X4S	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	15	\N	\N
price_01K9FZ973YNXYTCX4CGBA3QKEZ	\N	pset_01K9FZ973Y8H1ZN425W4CSN643	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	10	\N	\N
price_01K9FZ973Y6J8PF90T2Q2TDANS	\N	pset_01K9FZ973Y8H1ZN425W4CSN643	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	15	\N	\N
price_01K9FZ973ZQBNZ46F66WTCAVD0	\N	pset_01K9FZ973ZA1NFKQP3CF1ZY925	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	10	\N	\N
price_01K9FZ973ZMEKJQYH7YC3EJJ51	\N	pset_01K9FZ973ZA1NFKQP3CF1ZY925	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	15	\N	\N
price_01K9FZ973ZJ4EHES17C9JAQXP6	\N	pset_01K9FZ973ZW2F24Z6598S2VWDZ	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	10	\N	\N
price_01K9FZ973Z7V1T2P648ZSMG03R	\N	pset_01K9FZ973ZW2F24Z6598S2VWDZ	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	15	\N	\N
price_01K9FZ973Z7EYYP3TN19Q302XN	\N	pset_01K9FZ973ZENQ8ST243CF8MSZX	eur	{"value": "10", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	10	\N	\N
price_01K9FZ973Z9FJWD69BMVJ6TQAT	\N	pset_01K9FZ973ZENQ8ST243CF8MSZX	usd	{"value": "15", "precision": 20}	0	2025-11-07 17:14:17.728-03	2025-11-07 17:14:17.728-03	\N	\N	15	\N	\N
price_cs200a_f34a47e6f4c164f819b1231b	\N	pset_cs200a_9f4d1e1bbdfba6e2ada836a0	usd	{"value": "2500000"}	1	2025-11-07 22:38:42.849175-03	2025-11-08 00:38:15.694267-03	\N	\N	2641100	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01K9FZ84MARE1EB4Y0MJ0CW16X	currency_code	eur	f	2025-11-07 17:13:42.411-03	2025-11-07 17:13:42.411-03	\N
prpref_01K9FZ96VNZBRE4M4016KESR6C	region_id	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	f	2025-11-07 17:14:17.461-03	2025-11-07 17:14:17.461-03	\N
\.


--
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute, operator) FROM stdin;
prule_01K9FZ96YSK11ER5J864G30GDG	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	0	price_01K9FZ96YSME51ZTP1YCXDTJMR	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N	region_id	eq
prule_01K9FZ96YSE2Q7BDBWXG32KXFR	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	0	price_01K9FZ96YSZTZS0B6JA61SSTZH	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N	region_id	eq
prule_cs200a_1fbd4136a0d9cc4cfd3f8945	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	0	price_cs200a_f34a47e6f4c164f819b1231b	2025-11-07 22:47:10.82553-03	2025-11-07 22:47:10.82553-03	\N	region_id	eq
\.


--
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01K9FZ96YSMGE9BESK0MMP4R1Q	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N
pset_01K9FZ96YSG4A29EKE1TGMP73X	2025-11-07 17:14:17.562-03	2025-11-07 17:14:17.562-03	\N
pset_01K9FZ973W7H2SZ3JW3PVFJGA4	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973WEEMCREH4XV39KN8Z	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973WE8V486M94HTA3XWZ	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973X7Y16QZC1GNN955R9	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973XRRW49YKSJY321ZQP	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973XJWF9YVXRMAMWR2GT	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973X2CDXF4A5YP421XK9	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973X10YFF4GXNWF2GXGT	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973X58JC159DCEAJN7ZA	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973YSCAHYD5FR1J996SG	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973YCF7B0V7YDN59P2Y2	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973YHHNMVWH0HR8ZX7P9	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973YSJG4RRYNHQFCPW9V	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973Y4PE3D5WDH3G49KXJ	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973YQBYWN9A60F1WDE1E	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973Y4A7SNSD9JW0H5X4S	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973Y8H1ZN425W4CSN643	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973ZA1NFKQP3CF1ZY925	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973ZW2F24Z6598S2VWDZ	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_01K9FZ973ZENQ8ST243CF8MSZX	2025-11-07 17:14:17.727-03	2025-11-07 17:14:17.727-03	\N
pset_cs200a_9f4d1e1bbdfba6e2ada836a0	2025-11-07 22:38:36.47783-03	2025-11-07 22:38:36.47783-03	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01K9FZ970RSD7N0DMX4FEQRVN9	Medusa T-Shirt	t-shirt	\N	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-11-07 17:14:17.627-03	2025-11-07 17:14:17.627-03	\N	\N
prod_01K9FZ970RCZ4H4TH9K29KFQC9	Medusa Sweatshirt	sweatshirt	\N	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	\N
prod_01K9FZ970RS631Y32XVXC9RM35	Medusa Sweatpants	sweatpants	\N	Reimagine the feeling of classic sweatpants. With our cotton sweatpants, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	\N
prod_01K9FZ970RSVV1Z5ZFSJQZ98CK	Medusa Shorts	shorts	\N	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N	\N
prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0	Generador Diesel Cummins CS200A - 200 KVA Stand-By / 180 KVA Prime	cummins-cs200a	Motor Cummins 6BTAA5.9-G2 + Alternador Stamford HCI434F - Uso Industrial	Generador industrial diesel Cummins CS200A de 200 KVA Stand-By / 180 KVA Prime.\n\nEquipado con motor Cummins 6BTAA5.9-G2 de 1500 RPM y alternador Stamford HCI434F.\n\nIdeal para uso continuo 24/7 en aplicaciones industriales, comerciales y residenciales de alta potencia.\n\nPanel de control Comap MRS16 con función auto-start. Refrigeración líquida.\n\nDiseñado para máxima confiabilidad y bajo costo operativo.\n\nCARACTERÍSTICAS PRINCIPALES:\n• Motor Cummins 6BTAA5.9-G2 - 1500 RPM\n• Alternador Stamford HCI434F\n• 200 KVA Stand-By / 180 KVA Prime\n• Panel Comap MRS16 con auto-start\n• Refrigeración líquida\n• Tanque de combustible: 200 litros\n• Consumo a 75% carga: 38 L/h\n• Uso continuo 24/7\n\nAPLICACIONES:\n• Industrias\n• Comercios de alta potencia\n• Edificios residenciales\n• Hospitales y clínicas\n• Data centers\n• Zonas sin red eléctrica	f	published	http://localhost:9000/static/1762564697981-cs200a_page2_img3.png	2850	3200	1900	1400	China	850211	GEN-CS200A	Acero industrial	\N	\N	t	\N	2025-11-07 19:06:14.270728-03	2025-11-07 22:18:34.825-03	\N	{"fases": "Trifásico", "voltaje": "220/380V", "categoria": "Generadores Diesel", "motor_rpm": "1800", "tiene_tta": "opcional", "documentos": [], "frecuencia": "50/60Hz", "motor_ciclo": "4 tiempos", "motor_marca": "Cummins", "motor_modelo": "6CTAA8.3-G2", "tiene_cabina": false, "total_ventas": 0, "tipo_arranque": "Eléctrico", "total_reviews": 0, "vendor_nombre": "KOR", "vendor_rating": "5.0", "es_mas_vendido": false, "nivel_ruido_db": "68", "pricing_config": {"familia": "Generadores Cummins - Línea CS", "currency_type": "usd_bna", "iva_percentage": 10.5, "precio_lista_usd": 26411, "bonificacion_percentage": 11, "contado_descuento_percentage": 9}, "stock_cantidad": 1, "ubicacion_pais": "Argentina", "voltaje_salida": "220/380V", "estado_producto": "Nuevo", "factor_potencia": "0.8", "motor_cilindros": "6", "precio_anterior": null, "rating_promedio": 0, "ubicacion_envio": {"ciudad": "Florida", "provincia": "Buenos Aires", "texto_completo": "Florida, Buenos Aires"}, "alternador_marca": "Stamford", "combustible_tipo": "Diesel", "motor_aspiracion": "Turboalimentado con aftercooler", "stock_disponible": true, "ubicacion_ciudad": "Florida", "alternador_modelo": "HCI544D", "potencia_prime_kw": "144", "trust_envio_texto": "Envío gratis", "potencia_prime_kva": "180", "tipo_refrigeracion": "Agua", "trust_envio_gratis": true, "vendor_descripcion": "Especialistas en generación de energía eléctrica y grupos electrógenos industriales. Venta, alquiler y servicio técnico multimarca.", "insonorizacion_tipo": "Estándar", "motor_refrigeracion": "Agua", "panel_control_marca": "Deep Sea", "planes_financiacion": [{"cuotas": 3, "interes": 0.08, "costoPorCuota": 14740000}, {"cuotas": 6, "interes": 0.08, "costoPorCuota": 7570000}, {"cuotas": 12, "interes": 0.12, "costoPorCuota": 4180000}], "potencia_standby_kw": "160", "ubicacion_provincia": "Buenos Aires", "vendor_total_ventas": 0, "descuento_porcentaje": 0, "motor_tipo_cilindros": "En línea", "panel_control_modelo": "DSE7320", "potencia_standby_kva": "200", "trust_garantia_texto": "Garantía oficial", "motor_capacidad_aceite": "28", "motor_consumo_75_carga": "35.5", "vendor_nombre_completo": "KOR - Soluciones Energéticas Profesionales", "financiacion_disponible": true, "trust_envio_descripcion": "En el ámbito de Buenos Aires", "trust_garantia_incluida": true, "vendor_anos_experiencia": "15", "vendor_tiempo_respuesta": "Dentro de 24hs", "autonomia_horas_75_carga": "11.3", "aplicaciones_industriales": [{"icon": "🏥", "title": "Hospitales y Clínicas", "description": "Respaldo crítico para equipos médicos y quirófanos"}, {"icon": "💻", "title": "Centros de Datos", "description": "Energía ininterrumpida para infraestructura TI crítica"}, {"icon": "🏭", "title": "Industria Manufacturera", "description": "Continuidad operacional para líneas de producción"}, {"icon": "🏢", "title": "Edificios Comerciales", "description": "Respaldo para sistemas críticos y elevadores"}, {"icon": "🌾", "title": "Instalaciones Agrícolas", "description": "Energía confiable para sistemas de riego y refrigeración"}, {"icon": "📡", "title": "Telecomunicaciones", "description": "Respaldo para antenas y centros de switching"}], "trust_acepta_devoluciones": false, "trust_garantia_descripcion": "Respaldado por el fabricante", "combustible_capacidad_tanque": "400"}
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01K9FZ970FZ5XDPEA9K2SACB17	Shirts		shirts	pcat_01K9FZ970FZ5XDPEA9K2SACB17	t	f	0	\N	2025-11-07 17:14:17.616-03	2025-11-07 17:14:17.616-03	\N	\N
pcat_01K9FZ970F2EZCTHPEJ822A432	Sweatshirts		sweatshirts	pcat_01K9FZ970F2EZCTHPEJ822A432	t	f	1	\N	2025-11-07 17:14:17.616-03	2025-11-07 17:14:17.616-03	\N	\N
pcat_01K9FZ970GM5QZY44QDY0A1H15	Pants		pants	pcat_01K9FZ970GM5QZY44QDY0A1H15	t	f	2	\N	2025-11-07 17:14:17.616-03	2025-11-07 17:14:17.616-03	\N	\N
pcat_01K9FZ970GDCQFP5J3EEMG6PC4	Merch		merch	pcat_01K9FZ970GDCQFP5J3EEMG6PC4	t	f	3	\N	2025-11-07 17:14:17.616-03	2025-11-07 17:14:17.616-03	\N	\N
pcat_equipos_industriales	Equipos Industriales	Equipos y maquinaria para uso industrial	equipos-industriales	pcat_equipos_industriales.	t	f	0	\N	2025-11-08 17:17:57.561061-03	2025-11-08 17:17:57.561061-03	\N	\N
pcat_generadores	Generadores Eléctricos	Generadores y grupos electrógenos de todas las potencias	generadores-electricos	pcat_equipos_industriales.pcat_generadores.	t	f	0	pcat_equipos_industriales	2025-11-08 17:17:57.562325-03	2025-11-08 17:17:57.562325-03	\N	\N
pcat_gen_diesel	Generadores Diesel	Generadores diesel de 10 a 2000+ KVA	generadores-diesel	pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.	t	f	0	pcat_generadores	2025-11-08 17:17:57.564124-03	2025-11-08 17:17:57.564124-03	\N	\N
pcat_gen_nafta	Generadores Nafta	Generadores a nafta de 1 a 30 KVA	generadores-nafta	pcat_equipos_industriales.pcat_generadores.pcat_gen_nafta.	t	f	1	pcat_generadores	2025-11-08 17:17:57.564124-03	2025-11-08 17:17:57.564124-03	\N	\N
pcat_gen_gas	Generadores Gas	Generadores a gas natural/envasado	generadores-gas	pcat_equipos_industriales.pcat_generadores.pcat_gen_gas.	t	f	2	pcat_generadores	2025-11-08 17:17:57.564124-03	2025-11-08 17:17:57.564124-03	\N	\N
pcat_gen_diesel_10_100	10 a 100 KVA	Generadores diesel de 10 a 100 KVA	generadores-diesel-10-100kva	pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.pcat_gen_diesel_10_100.	t	f	0	pcat_gen_diesel	2025-11-08 17:17:57.56508-03	2025-11-08 17:17:57.56508-03	\N	\N
pcat_gen_diesel_100_200	100 a 200 KVA	Generadores diesel de 100 a 200 KVA	generadores-diesel-100-200kva	pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.pcat_gen_diesel_100_200.	t	f	1	pcat_gen_diesel	2025-11-08 17:17:57.56508-03	2025-11-08 17:17:57.56508-03	\N	\N
pcat_gen_diesel_200_500	200 a 500 KVA	Generadores diesel de 200 a 500 KVA	generadores-diesel-200-500kva	pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.pcat_gen_diesel_200_500.	t	f	2	pcat_gen_diesel	2025-11-08 17:17:57.56508-03	2025-11-08 17:17:57.56508-03	\N	\N
pcat_gen_diesel_500	Más de 500 KVA	Generadores diesel de más de 500 KVA	generadores-diesel-mas-500kva	pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.pcat_gen_diesel_500.	t	f	3	pcat_gen_diesel	2025-11-08 17:17:57.56508-03	2025-11-08 17:17:57.56508-03	\N	\N
pcat_compresores	Compresores de Aire	Compresores de aire industriales y profesionales	compresores-de-aire	pcat_equipos_industriales.pcat_compresores.	t	f	1	pcat_equipos_industriales	2025-11-08 17:17:57.565923-03	2025-11-08 17:17:57.565923-03	\N	\N
pcat_comp_piston	Compresores a Pistón	Compresores de pistón para uso intermitente	compresores-piston	pcat_equipos_industriales.pcat_compresores.pcat_comp_piston.	t	f	0	pcat_compresores	2025-11-08 17:17:57.566276-03	2025-11-08 17:17:57.566276-03	\N	\N
pcat_comp_tornillo	Compresores a Tornillo	Compresores de tornillo para uso continuo	compresores-tornillo	pcat_equipos_industriales.pcat_compresores.pcat_comp_tornillo.	t	f	1	pcat_compresores	2025-11-08 17:17:57.566276-03	2025-11-08 17:17:57.566276-03	\N	\N
pcat_hidrolavadoras	Hidrolavadoras	Hidrolavadoras de agua fría y caliente	hidrolavadoras	pcat_equipos_industriales.pcat_hidrolavadoras.	t	f	2	pcat_equipos_industriales	2025-11-08 17:17:57.566734-03	2025-11-08 17:17:57.566734-03	\N	\N
pcat_hidro_domestica	Uso Doméstico	Hidrolavadoras para uso doméstico y ocasional	hidrolavadoras-domesticas	pcat_equipos_industriales.pcat_hidrolavadoras.pcat_hidro_domestica.	t	f	0	pcat_hidrolavadoras	2025-11-08 17:17:57.567036-03	2025-11-08 17:17:57.567036-03	\N	\N
pcat_hidro_industrial	Uso Industrial	Hidrolavadoras profesionales e industriales	hidrolavadoras-industriales	pcat_equipos_industriales.pcat_hidrolavadoras.pcat_hidro_industrial.	t	f	1	pcat_hidrolavadoras	2025-11-08 17:17:57.567036-03	2025-11-08 17:17:57.567036-03	\N	\N
pcat_motores	Motores Diesel y Nafta	Motores estacionarios para equipos industriales	motores	pcat_equipos_industriales.pcat_motores.	t	f	3	pcat_equipos_industriales	2025-11-08 17:17:57.56744-03	2025-11-08 17:17:57.56744-03	\N	\N
\.


--
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01K9FZ970RSD7N0DMX4FEQRVN9	pcat_01K9FZ970FZ5XDPEA9K2SACB17
prod_01K9FZ970RCZ4H4TH9K29KFQC9	pcat_01K9FZ970F2EZCTHPEJ822A432
prod_01K9FZ970RS631Y32XVXC9RM35	pcat_01K9FZ970GM5QZY44QDY0A1H15
prod_01K9FZ970RSVV1Z5ZFSJQZ98CK	pcat_01K9FZ970GDCQFP5J3EEMG6PC4
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
pcoll_cummins_cs	Generadores Cummins - Línea CS	generadores-cummins-linea-cs	\N	2025-11-08 17:17:57.558214-03	2025-11-08 17:17:57.558214-03	\N
pcoll_cummins_ck	Generadores Cummins - Línea CK	generadores-cummins-linea-ck	\N	2025-11-08 17:17:57.558214-03	2025-11-08 17:17:57.558214-03	\N
pcoll_cummins_onan	Generadores Cummins - Serie ONAN	generadores-cummins-serie-onan	\N	2025-11-08 17:17:57.558214-03	2025-11-08 17:17:57.558214-03	\N
pcoll_perkins_1000	Generadores Perkins - Serie 1000	generadores-perkins-serie-1000	\N	2025-11-08 17:17:57.559945-03	2025-11-08 17:17:57.559945-03	\N
pcoll_perkins_2000	Generadores Perkins - Serie 2000	generadores-perkins-serie-2000	\N	2025-11-08 17:17:57.559945-03	2025-11-08 17:17:57.559945-03	\N
pcoll_atlas_copco_tornillo	Compresores Atlas Copco - Tornillo	compresores-atlas-copco-tornillo	\N	2025-11-08 17:17:57.560223-03	2025-11-08 17:17:57.560223-03	\N
pcoll_atlas_copco_piston	Compresores Atlas Copco - Pistón	compresores-atlas-copco-piston	\N	2025-11-08 17:17:57.560223-03	2025-11-08 17:17:57.560223-03	\N
pcoll_karcher_k	Hidrolavadoras Karcher - Serie K	hidrolavadoras-karcher-serie-k	\N	2025-11-08 17:17:57.560488-03	2025-11-08 17:17:57.560488-03	\N
pcoll_karcher_hd	Hidrolavadoras Karcher - Serie HD Industrial	hidrolavadoras-karcher-serie-hd	\N	2025-11-08 17:17:57.560488-03	2025-11-08 17:17:57.560488-03	\N
pcoll_promocion	En Promoción	en-promocion	\N	2025-11-08 17:17:57.560741-03	2025-11-08 17:17:57.560741-03	\N
pcoll_nuevos	Nuevos Ingresos	nuevos-ingresos	\N	2025-11-08 17:17:57.560741-03	2025-11-08 17:17:57.560741-03	\N
pcoll_outlet	Outlet - Equipos Usados	outlet-equipos-usados	\N	2025-11-08 17:17:57.560741-03	2025-11-08 17:17:57.560741-03	\N
pcoll_mas_vendidos	Más Vendidos	mas-vendidos	\N	2025-11-08 17:17:57.560741-03	2025-11-08 17:17:57.560741-03	\N
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01K9FZ970S51F7K5DF89VD9111	Size	prod_01K9FZ970RSD7N0DMX4FEQRVN9	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
opt_01K9FZ970S6XSEH3AQSADZZ9JR	Color	prod_01K9FZ970RSD7N0DMX4FEQRVN9	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
opt_01K9FZ970TVGVGP6582ZQRPBTM	Size	prod_01K9FZ970RCZ4H4TH9K29KFQC9	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
opt_01K9FZ970VJJAG0N29BHVY2QMS	Size	prod_01K9FZ970RS631Y32XVXC9RM35	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
opt_01K9FZ970VTKGEVNWJRVRFXVJV	Size	prod_01K9FZ970RSVV1Z5ZFSJQZ98CK	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
\.


--
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01K9FZ970SBJQGJN1XBC54X4MK	S	opt_01K9FZ970S51F7K5DF89VD9111	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970SXDWR307G1Y310QTY	M	opt_01K9FZ970S51F7K5DF89VD9111	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970SX89G6PMQYJA4DEWD	L	opt_01K9FZ970S51F7K5DF89VD9111	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970S1YBY2H3QFN17BMAX	XL	opt_01K9FZ970S51F7K5DF89VD9111	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970SACT0RK3YA8M6PE86	Black	opt_01K9FZ970S6XSEH3AQSADZZ9JR	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970SZDAJCAW640HH2V0Y	White	opt_01K9FZ970S6XSEH3AQSADZZ9JR	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970T3VJB83JXK89P1ZK4	S	opt_01K9FZ970TVGVGP6582ZQRPBTM	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970TJJHDDWDQZ4KR0JEH	M	opt_01K9FZ970TVGVGP6582ZQRPBTM	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970TJ4ANV6AYXH1SCQDN	L	opt_01K9FZ970TVGVGP6582ZQRPBTM	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970TV6HWV75TGQQ5F25Y	XL	opt_01K9FZ970TVGVGP6582ZQRPBTM	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970TFNFQACD6SRF8EH87	S	opt_01K9FZ970VJJAG0N29BHVY2QMS	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970T6H35NWD1K01DG0FZ	M	opt_01K9FZ970VJJAG0N29BHVY2QMS	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970TMRG0BV0X1ZNAZM3T	L	opt_01K9FZ970VJJAG0N29BHVY2QMS	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970TWBA5K50S682HYE86	XL	opt_01K9FZ970VJJAG0N29BHVY2QMS	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970VST4WK16XW4XNDC7Z	S	opt_01K9FZ970VTKGEVNWJRVRFXVJV	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970V51QSTSCB6QXXWYX5	M	opt_01K9FZ970VTKGEVNWJRVRFXVJV	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970VE1YAXS773MQZ5YKP	L	opt_01K9FZ970VTKGEVNWJRVRFXVJV	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
optval_01K9FZ970VX3EBYQTXX2E4CPM0	XL	opt_01K9FZ970VTKGEVNWJRVRFXVJV	\N	2025-11-07 17:14:17.628-03	2025-11-07 17:14:17.628-03	\N
\.


--
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K9FZ970RSD7N0DMX4FEQRVN9	sc_01K9FZ84KQM1PG94Q6YT6248EW	prodsc_01K9FZ971P6D75E35SQA2XCYEZ	2025-11-07 17:14:17.65468-03	2025-11-07 17:14:17.65468-03	\N
prod_01K9FZ970RCZ4H4TH9K29KFQC9	sc_01K9FZ84KQM1PG94Q6YT6248EW	prodsc_01K9FZ971QM212Y08PVDTEP717	2025-11-07 17:14:17.65468-03	2025-11-07 17:14:17.65468-03	\N
prod_01K9FZ970RS631Y32XVXC9RM35	sc_01K9FZ84KQM1PG94Q6YT6248EW	prodsc_01K9FZ971Q90C6RWC5ABMEC25N	2025-11-07 17:14:17.65468-03	2025-11-07 17:14:17.65468-03	\N
prod_01K9FZ970RSVV1Z5ZFSJQZ98CK	sc_01K9FZ84KQM1PG94Q6YT6248EW	prodsc_01K9FZ971Q1R5D296FDHMXSXT8	2025-11-07 17:14:17.65468-03	2025-11-07 17:14:17.65468-03	\N
prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0	sc_01K9FZ84KQM1PG94Q6YT6248EW	prodsc_183b164b7c52737369b61ac4	2025-11-07 19:07:19.413312-03	2025-11-07 19:07:19.413312-03	\N
\.


--
-- Data for Name: product_shipping_profile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_shipping_profile (product_id, shipping_profile_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K9FZ970RSD7N0DMX4FEQRVN9	sp_01K9FZ7ST5YJX8DKJ2WQZ5ZJ6F	prodsp_01K9FZ97222TG1N9PQ01WJ64JD	2025-11-07 17:14:17.664512-03	2025-11-07 17:14:17.664512-03	\N
prod_01K9FZ970RCZ4H4TH9K29KFQC9	sp_01K9FZ7ST5YJX8DKJ2WQZ5ZJ6F	prodsp_01K9FZ9722PK3JK1A7Y9HZTPVV	2025-11-07 17:14:17.664512-03	2025-11-07 17:14:17.664512-03	\N
prod_01K9FZ970RS631Y32XVXC9RM35	sp_01K9FZ7ST5YJX8DKJ2WQZ5ZJ6F	prodsp_01K9FZ97225GN5WE61S590K3T7	2025-11-07 17:14:17.664512-03	2025-11-07 17:14:17.664512-03	\N
prod_01K9FZ970RSVV1Z5ZFSJQZ98CK	sp_01K9FZ7ST5YJX8DKJ2WQZ5ZJ6F	prodsp_01K9FZ9722RCJMW2HNYCJED936	2025-11-07 17:14:17.664512-03	2025-11-07 17:14:17.664512-03	\N
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
ptag_diesel	diesel	\N	2025-11-08 17:17:57.552563-03	2025-11-08 17:17:57.552563-03	\N
ptag_nafta	nafta	\N	2025-11-08 17:17:57.552563-03	2025-11-08 17:17:57.552563-03	\N
ptag_gas	gas	\N	2025-11-08 17:17:57.552563-03	2025-11-08 17:17:57.552563-03	\N
ptag_electrico	eléctrico	\N	2025-11-08 17:17:57.552563-03	2025-11-08 17:17:57.552563-03	\N
ptag_industrial	industrial	\N	2025-11-08 17:17:57.554415-03	2025-11-08 17:17:57.554415-03	\N
ptag_domestico	doméstico	\N	2025-11-08 17:17:57.554415-03	2025-11-08 17:17:57.554415-03	\N
ptag_comercial	comercial	\N	2025-11-08 17:17:57.554415-03	2025-11-08 17:17:57.554415-03	\N
ptag_construccion	construcción	\N	2025-11-08 17:17:57.554415-03	2025-11-08 17:17:57.554415-03	\N
ptag_insonorizado	insonorizado	\N	2025-11-08 17:17:57.554767-03	2025-11-08 17:17:57.554767-03	\N
ptag_cabina	cabina	\N	2025-11-08 17:17:57.554767-03	2025-11-08 17:17:57.554767-03	\N
ptag_tta	tta	\N	2025-11-08 17:17:57.554767-03	2025-11-08 17:17:57.554767-03	\N
ptag_automatico	automático	\N	2025-11-08 17:17:57.554767-03	2025-11-08 17:17:57.554767-03	\N
ptag_manual	manual	\N	2025-11-08 17:17:57.554767-03	2025-11-08 17:17:57.554767-03	\N
ptag_portatil	portátil	\N	2025-11-08 17:17:57.554767-03	2025-11-08 17:17:57.554767-03	\N
ptag_estacionario	estacionario	\N	2025-11-08 17:17:57.554767-03	2025-11-08 17:17:57.554767-03	\N
ptag_trifasico	trifásico	\N	2025-11-08 17:17:57.555127-03	2025-11-08 17:17:57.555127-03	\N
ptag_monofasico	monofásico	\N	2025-11-08 17:17:57.555127-03	2025-11-08 17:17:57.555127-03	\N
ptag_bifasico	bifásico	\N	2025-11-08 17:17:57.555127-03	2025-11-08 17:17:57.555127-03	\N
ptag_standby	standby	\N	2025-11-08 17:17:57.556397-03	2025-11-08 17:17:57.556397-03	\N
ptag_prime	prime	\N	2025-11-08 17:17:57.556397-03	2025-11-08 17:17:57.556397-03	\N
ptag_continuo	continuo	\N	2025-11-08 17:17:57.556397-03	2025-11-08 17:17:57.556397-03	\N
ptag_cummins	cummins	\N	2025-11-08 17:17:57.556799-03	2025-11-08 17:17:57.556799-03	\N
ptag_perkins	perkins	\N	2025-11-08 17:17:57.556799-03	2025-11-08 17:17:57.556799-03	\N
ptag_volvo	volvo	\N	2025-11-08 17:17:57.556799-03	2025-11-08 17:17:57.556799-03	\N
ptag_caterpillar	caterpillar	\N	2025-11-08 17:17:57.556799-03	2025-11-08 17:17:57.556799-03	\N
ptag_deutz	deutz	\N	2025-11-08 17:17:57.556799-03	2025-11-08 17:17:57.556799-03	\N
ptag_stamford	stamford	\N	2025-11-08 17:17:57.557288-03	2025-11-08 17:17:57.557288-03	\N
ptag_leroy_somer	leroy-somer	\N	2025-11-08 17:17:57.557288-03	2025-11-08 17:17:57.557288-03	\N
ptag_mecc_alte	mecc-alte	\N	2025-11-08 17:17:57.557288-03	2025-11-08 17:17:57.557288-03	\N
ptag_10kva	1-10kva	\N	2025-11-08 17:17:57.557709-03	2025-11-08 17:17:57.557709-03	\N
ptag_1030kva	10-30kva	\N	2025-11-08 17:17:57.557709-03	2025-11-08 17:17:57.557709-03	\N
ptag_30100kva	30-100kva	\N	2025-11-08 17:17:57.557709-03	2025-11-08 17:17:57.557709-03	\N
ptag_100200kva	100-200kva	\N	2025-11-08 17:17:57.557709-03	2025-11-08 17:17:57.557709-03	\N
ptag_200500kva	200-500kva	\N	2025-11-08 17:17:57.557709-03	2025-11-08 17:17:57.557709-03	\N
ptag_500kva	+500kva	\N	2025-11-08 17:17:57.557709-03	2025-11-08 17:17:57.557709-03	\N
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
ptype_generador_diesel	Generador Diesel	\N	2025-11-08 17:17:57.547213-03	2025-11-08 17:17:57.547213-03	\N
ptype_generador_nafta	Generador Nafta	\N	2025-11-08 17:17:57.547213-03	2025-11-08 17:17:57.547213-03	\N
ptype_generador_gas	Generador Gas	\N	2025-11-08 17:17:57.547213-03	2025-11-08 17:17:57.547213-03	\N
ptype_compresor_piston	Compresor a Pistón	\N	2025-11-08 17:17:57.551563-03	2025-11-08 17:17:57.551563-03	\N
ptype_compresor_tornillo	Compresor a Tornillo	\N	2025-11-08 17:17:57.551563-03	2025-11-08 17:17:57.551563-03	\N
ptype_hidrolavadora_domestica	Hidrolavadora Doméstica	\N	2025-11-08 17:17:57.551887-03	2025-11-08 17:17:57.551887-03	\N
ptype_hidrolavadora_industrial	Hidrolavadora Industrial	\N	2025-11-08 17:17:57.551887-03	2025-11-08 17:17:57.551887-03	\N
ptype_motor_diesel	Motor Diesel	\N	2025-11-08 17:17:57.552133-03	2025-11-08 17:17:57.552133-03	\N
ptype_motor_nafta	Motor Nafta	\N	2025-11-08 17:17:57.552133-03	2025-11-08 17:17:57.552133-03	\N
ptype_bomba_agua	Bomba de Agua	\N	2025-11-08 17:17:57.552344-03	2025-11-08 17:17:57.552344-03	\N
ptype_soldadora	Soldadora	\N	2025-11-08 17:17:57.552344-03	2025-11-08 17:17:57.552344-03	\N
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at, thumbnail) FROM stdin;
variant_01K9FZ972MV93J0RDM0SZ2HMX2	S / Black	SHIRT-S-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSD7N0DMX4FEQRVN9	2025-11-07 17:14:17.685-03	2025-11-07 17:14:17.685-03	\N	\N
variant_01K9FZ972MEPVJDVK598VTNF70	S / White	SHIRT-S-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSD7N0DMX4FEQRVN9	2025-11-07 17:14:17.685-03	2025-11-07 17:14:17.685-03	\N	\N
variant_01K9FZ972MBBXEDSNZAP2KS02F	M / Black	SHIRT-M-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSD7N0DMX4FEQRVN9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972MYNFJ43NMXN7NJAW3	M / White	SHIRT-M-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSD7N0DMX4FEQRVN9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972MN57MWNM1KF1BVWFM	L / Black	SHIRT-L-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSD7N0DMX4FEQRVN9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972MMJZ3DZKNS9EJ2JRF	L / White	SHIRT-L-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSD7N0DMX4FEQRVN9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972M019PG9P12H4J2YH1	XL / Black	SHIRT-XL-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSD7N0DMX4FEQRVN9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972MDMZM6WMYX7A3NEBS	XL / White	SHIRT-XL-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSD7N0DMX4FEQRVN9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972MXZ72D22AYKRM3KHB	S	SWEATSHIRT-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RCZ4H4TH9K29KFQC9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972M8VNJD7RRH0Z11RBE	M	SWEATSHIRT-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RCZ4H4TH9K29KFQC9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972N3SNEA1JP3DT7QH1T	L	SWEATSHIRT-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RCZ4H4TH9K29KFQC9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972NTN62J8REDQ9B33KE	XL	SWEATSHIRT-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RCZ4H4TH9K29KFQC9	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972N7BSECTN0Y5YTGPYZ	S	SWEATPANTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RS631Y32XVXC9RM35	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972N8K89VX7NXFQYD2NE	M	SWEATPANTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RS631Y32XVXC9RM35	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972N24YVRWS9TTGDF5VN	L	SWEATPANTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RS631Y32XVXC9RM35	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972NS2F17J286RG37RJF	XL	SWEATPANTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RS631Y32XVXC9RM35	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972NXDZPQ1GBNJX33E58	S	SHORTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSVV1Z5ZFSJQZ98CK	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972N211TDNYYY21VX2AJ	M	SHORTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSVV1Z5ZFSJQZ98CK	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972NKCCGZDMKDRCKJ99C	L	SHORTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSVV1Z5ZFSJQZ98CK	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_01K9FZ972NCQR7JFFZYC1W3JSQ	XL	SHORTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K9FZ970RSVV1Z5ZFSJQZ98CK	2025-11-07 17:14:17.686-03	2025-11-07 17:14:17.686-03	\N	\N
variant_9173cb95160e3448	Generador CS200A - Estándar	GEN-CS200A-STD	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0	2025-11-07 19:06:32.543371-03	2025-11-07 19:06:32.543371-03	\N	\N
\.


--
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
variant_01K9FZ972MV93J0RDM0SZ2HMX2	iitem_01K9FZ973611A8P5WGG02DAG23	pvitem_01K9FZ973MYW1V6G46PJQE3KCE	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972MEPVJDVK598VTNF70	iitem_01K9FZ9736F9JC8G3G04N1QSBK	pvitem_01K9FZ973MDEBY2SNMKRZZCR7R	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972MBBXEDSNZAP2KS02F	iitem_01K9FZ9736CCPSMM7XZWS5927P	pvitem_01K9FZ973ME9TBV8HHJF6G8HAP	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972MYNFJ43NMXN7NJAW3	iitem_01K9FZ9736ETN9NTBKHZ5VAH1Y	pvitem_01K9FZ973M6G4ZK00DE1CJ2TZ0	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972MN57MWNM1KF1BVWFM	iitem_01K9FZ9736PPXB6RVYKJN3CQ94	pvitem_01K9FZ973MFKQHMHT966YKW93A	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972MMJZ3DZKNS9EJ2JRF	iitem_01K9FZ9736WNDW19QYYPSCPD1M	pvitem_01K9FZ973MNDBXM5BYGJ0V716E	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972M019PG9P12H4J2YH1	iitem_01K9FZ97362R9DFHCFGCWA60C0	pvitem_01K9FZ973MKND8X4E0V80D7VN4	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972MDMZM6WMYX7A3NEBS	iitem_01K9FZ9736PE137JZ4J9J8EJAG	pvitem_01K9FZ973MXS09BA8S0T78KSFK	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972MXZ72D22AYKRM3KHB	iitem_01K9FZ97374Q5G5R8M1H6SSASB	pvitem_01K9FZ973MCEV66989QTKCNQS2	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972M8VNJD7RRH0Z11RBE	iitem_01K9FZ9737AZHA5QD1BTPEN09V	pvitem_01K9FZ973MZ5AEZCJV34GKDPTT	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972N3SNEA1JP3DT7QH1T	iitem_01K9FZ97373XHF2FEGGNH5A7KE	pvitem_01K9FZ973M90KRCVE6STCDRSCP	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972NTN62J8REDQ9B33KE	iitem_01K9FZ97371Q4HPQBGXH7Z5R55	pvitem_01K9FZ973MK802NPQ5YVQDZ760	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972N7BSECTN0Y5YTGPYZ	iitem_01K9FZ97373JRQG6JC3NW8WPBT	pvitem_01K9FZ973M2SAGN65BT6XY2RXV	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972N8K89VX7NXFQYD2NE	iitem_01K9FZ97379W73VZRT9ZRKXS4D	pvitem_01K9FZ973MW31CV1CXB2Z410AH	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972N24YVRWS9TTGDF5VN	iitem_01K9FZ9737KSSDM5V1W8VBGMC9	pvitem_01K9FZ973N551TZBT36ZNDCGPN	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972NS2F17J286RG37RJF	iitem_01K9FZ9737GZAPCXBHFB7QCTFV	pvitem_01K9FZ973NN8CGEW3DM2HSM69J	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972NXDZPQ1GBNJX33E58	iitem_01K9FZ97375DA2GPVH1TPDTZ66	pvitem_01K9FZ973NHJTX7DN60PDABNS7	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972N211TDNYYY21VX2AJ	iitem_01K9FZ9737ZYKJSJ1KXMNSQNGP	pvitem_01K9FZ973NYK4YJ8XZWDNH3AG5	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972NKCCGZDMKDRCKJ99C	iitem_01K9FZ973712P49XBRW8G7VNPA	pvitem_01K9FZ973NNE1HJX4DY76S0PH4	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
variant_01K9FZ972NCQR7JFFZYC1W3JSQ	iitem_01K9FZ973705T6YAQS7A4FBN3C	pvitem_01K9FZ973NNWKHQPYT66A8MVC6	1	2025-11-07 17:14:17.715848-03	2025-11-07 17:14:17.715848-03	\N
\.


--
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01K9FZ972MV93J0RDM0SZ2HMX2	optval_01K9FZ970SBJQGJN1XBC54X4MK
variant_01K9FZ972MV93J0RDM0SZ2HMX2	optval_01K9FZ970SACT0RK3YA8M6PE86
variant_01K9FZ972MEPVJDVK598VTNF70	optval_01K9FZ970SBJQGJN1XBC54X4MK
variant_01K9FZ972MEPVJDVK598VTNF70	optval_01K9FZ970SZDAJCAW640HH2V0Y
variant_01K9FZ972MBBXEDSNZAP2KS02F	optval_01K9FZ970SXDWR307G1Y310QTY
variant_01K9FZ972MBBXEDSNZAP2KS02F	optval_01K9FZ970SACT0RK3YA8M6PE86
variant_01K9FZ972MYNFJ43NMXN7NJAW3	optval_01K9FZ970SXDWR307G1Y310QTY
variant_01K9FZ972MYNFJ43NMXN7NJAW3	optval_01K9FZ970SZDAJCAW640HH2V0Y
variant_01K9FZ972MN57MWNM1KF1BVWFM	optval_01K9FZ970SX89G6PMQYJA4DEWD
variant_01K9FZ972MN57MWNM1KF1BVWFM	optval_01K9FZ970SACT0RK3YA8M6PE86
variant_01K9FZ972MMJZ3DZKNS9EJ2JRF	optval_01K9FZ970SX89G6PMQYJA4DEWD
variant_01K9FZ972MMJZ3DZKNS9EJ2JRF	optval_01K9FZ970SZDAJCAW640HH2V0Y
variant_01K9FZ972M019PG9P12H4J2YH1	optval_01K9FZ970S1YBY2H3QFN17BMAX
variant_01K9FZ972M019PG9P12H4J2YH1	optval_01K9FZ970SACT0RK3YA8M6PE86
variant_01K9FZ972MDMZM6WMYX7A3NEBS	optval_01K9FZ970S1YBY2H3QFN17BMAX
variant_01K9FZ972MDMZM6WMYX7A3NEBS	optval_01K9FZ970SZDAJCAW640HH2V0Y
variant_01K9FZ972MXZ72D22AYKRM3KHB	optval_01K9FZ970T3VJB83JXK89P1ZK4
variant_01K9FZ972M8VNJD7RRH0Z11RBE	optval_01K9FZ970TJJHDDWDQZ4KR0JEH
variant_01K9FZ972N3SNEA1JP3DT7QH1T	optval_01K9FZ970TJ4ANV6AYXH1SCQDN
variant_01K9FZ972NTN62J8REDQ9B33KE	optval_01K9FZ970TV6HWV75TGQQ5F25Y
variant_01K9FZ972N7BSECTN0Y5YTGPYZ	optval_01K9FZ970TFNFQACD6SRF8EH87
variant_01K9FZ972N8K89VX7NXFQYD2NE	optval_01K9FZ970T6H35NWD1K01DG0FZ
variant_01K9FZ972N24YVRWS9TTGDF5VN	optval_01K9FZ970TMRG0BV0X1ZNAZM3T
variant_01K9FZ972NS2F17J286RG37RJF	optval_01K9FZ970TWBA5K50S682HYE86
variant_01K9FZ972NXDZPQ1GBNJX33E58	optval_01K9FZ970VST4WK16XW4XNDC7Z
variant_01K9FZ972N211TDNYYY21VX2AJ	optval_01K9FZ970V51QSTSCB6QXXWYX5
variant_01K9FZ972NKCCGZDMKDRCKJ99C	optval_01K9FZ970VE1YAXS773MQZ5YKP
variant_01K9FZ972NCQR7JFFZYC1W3JSQ	optval_01K9FZ970VX3EBYQTXX2E4CPM0
\.


--
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K9FZ972MV93J0RDM0SZ2HMX2	pset_01K9FZ973W7H2SZ3JW3PVFJGA4	pvps_01K9FZ974NQPWHZCBDQP6530X5	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972MEPVJDVK598VTNF70	pset_01K9FZ973WEEMCREH4XV39KN8Z	pvps_01K9FZ974N1MN2V6Q0B5M3A190	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972MBBXEDSNZAP2KS02F	pset_01K9FZ973WE8V486M94HTA3XWZ	pvps_01K9FZ974NGTDQDQV2MHK543B4	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972MYNFJ43NMXN7NJAW3	pset_01K9FZ973X7Y16QZC1GNN955R9	pvps_01K9FZ974NHAN5042NY9BK4GPN	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972MN57MWNM1KF1BVWFM	pset_01K9FZ973XRRW49YKSJY321ZQP	pvps_01K9FZ974NDX1E281C42N8W0DW	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972MMJZ3DZKNS9EJ2JRF	pset_01K9FZ973XJWF9YVXRMAMWR2GT	pvps_01K9FZ974N2332AZH8YP3KYR58	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972M019PG9P12H4J2YH1	pset_01K9FZ973X2CDXF4A5YP421XK9	pvps_01K9FZ974NZDWEP5307ZCDBCHZ	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972MDMZM6WMYX7A3NEBS	pset_01K9FZ973X10YFF4GXNWF2GXGT	pvps_01K9FZ974NNY9RSMY6V8ABZXWY	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972MXZ72D22AYKRM3KHB	pset_01K9FZ973X58JC159DCEAJN7ZA	pvps_01K9FZ974NHSBF22XYD938HE3S	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972M8VNJD7RRH0Z11RBE	pset_01K9FZ973YSCAHYD5FR1J996SG	pvps_01K9FZ974N4SAG8KXKXXPKCKDH	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972N3SNEA1JP3DT7QH1T	pset_01K9FZ973YCF7B0V7YDN59P2Y2	pvps_01K9FZ974NFK7P67SSNFKYMZ2B	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972NTN62J8REDQ9B33KE	pset_01K9FZ973YHHNMVWH0HR8ZX7P9	pvps_01K9FZ974NHMPJH6BG9K6W2G0V	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972N7BSECTN0Y5YTGPYZ	pset_01K9FZ973YSJG4RRYNHQFCPW9V	pvps_01K9FZ974NA0ZRG6TM8X3X12Q1	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972N8K89VX7NXFQYD2NE	pset_01K9FZ973Y4PE3D5WDH3G49KXJ	pvps_01K9FZ974NB77NT14F67S6H6GD	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972N24YVRWS9TTGDF5VN	pset_01K9FZ973YQBYWN9A60F1WDE1E	pvps_01K9FZ974N2W82CX6NN5H4GQAK	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972NS2F17J286RG37RJF	pset_01K9FZ973Y4A7SNSD9JW0H5X4S	pvps_01K9FZ974PT8A8P3AV8R91TNNZ	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972NXDZPQ1GBNJX33E58	pset_01K9FZ973Y8H1ZN425W4CSN643	pvps_01K9FZ974PDXJX9R4YN2SC3C9W	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972N211TDNYYY21VX2AJ	pset_01K9FZ973ZA1NFKQP3CF1ZY925	pvps_01K9FZ974PJRW2HVR9WFJZ3SVR	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972NKCCGZDMKDRCKJ99C	pset_01K9FZ973ZW2F24Z6598S2VWDZ	pvps_01K9FZ974P21WSNTRCTVP2AQ9M	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_01K9FZ972NCQR7JFFZYC1W3JSQ	pset_01K9FZ973ZENQ8ST243CF8MSZX	pvps_01K9FZ974PFKG7WP6B3SVAPZVA	2025-11-07 17:14:17.748835-03	2025-11-07 17:14:17.748835-03	\N
variant_9173cb95160e3448	pset_cs200a_9f4d1e1bbdfba6e2ada836a0	pvps_cs200a_1bc5ab4962de2c466d187704	2025-11-07 22:38:47.296579-03	2025-11-07 22:38:47.296579-03	\N
\.


--
-- Data for Name: product_variant_product_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_variant_product_image (id, variant_id, image_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at, status, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code, attribute) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget_usage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_campaign_budget_usage (id, attribute_value, used, budget_id, raw_used, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at, deleted_at) FROM stdin;
01K9FZ84PRKJRY5BKHHX2PZ3TK	admin@example.com	emailpass	authid_01K9FZ84PR5NN9AZ8WRYZP87GS	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAeDaxIk5awmlZJCJbV7wRGRCU+JQ8k8OvfbhHgpZ0ijW9PzKzetNswB3ZhRpUwfWR9ocyoxc+aM7jv0zC8YB7m+k3WhjrRDO/lrs0gMXS3BB"}	2025-11-07 17:13:42.488-03	2025-11-07 17:13:42.488-03	\N
\.


--
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01K9FZ96ZVNY23NP4XVKAM23PS	sc_01K9FZ84KQM1PG94Q6YT6248EW	pksc_01K9FZ9703QR8TZ392MFB1EAQZ	2025-11-07 17:14:17.603191-03	2025-11-07 17:14:17.603191-03	\N
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at, code) FROM stdin;
refr_01K9FZ7QNZ8MTN2341KWE70433	Shipping Issue	Refund due to lost, delayed, or misdelivered shipment	\N	2025-11-07 17:13:29.111261-03	2025-11-07 17:13:29.111261-03	\N	shipping_issue
refr_01K9FZ7QNZXT8X51W1484NVN4V	Customer Care Adjustment	Refund given as goodwill or compensation for inconvenience	\N	2025-11-07 17:13:29.111261-03	2025-11-07 17:13:29.111261-03	\N	customer_care_adjustment
refr_01K9FZ7QNZRGAHYSBY9FCWHDK3	Pricing Error	Refund to correct an overcharge, missing discount, or incorrect price	\N	2025-11-07 17:13:29.111261-03	2025-11-07 17:13:29.111261-03	\N	pricing_error
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01K9FZ96V1AT4PGR95NE8VYZ8N	Europe	eur	\N	2025-11-07 17:14:17.447-03	2025-11-07 17:14:17.447-03	\N	t
reg_01JCARGENTINA2025	Argentina	ars	\N	2025-11-08 17:10:01.802528-03	2025-11-08 17:10:01.802528-03	\N	t
\.


--
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2025-11-07 17:13:30.857-03	2025-11-07 17:13:30.857-03	\N
al	alb	008	ALBANIA	Albania	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bd	bgd	050	BANGLADESH	Bangladesh	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
by	blr	112	BELARUS	Belarus	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bz	blz	084	BELIZE	Belize	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bj	ben	204	BENIN	Benin	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ca	can	124	CANADA	Canada	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
td	tcd	148	CHAD	Chad	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cl	chl	152	CHILE	Chile	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cn	chn	156	CHINA	China	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
km	com	174	COMOROS	Comoros	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cg	cog	178	CONGO	Congo	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cu	cub	192	CUBA	Cuba	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cw	cuw	531	CURAÇAO	Curaçao	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ar	arg	032	ARGENTINA	Argentina	reg_01JCARGENTINA2025	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
fj	fji	242	FIJI	Fiji	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
fi	fin	246	FINLAND	Finland	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ga	gab	266	GABON	Gabon	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gh	gha	288	GHANA	Ghana	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gr	grc	300	GREECE	Greece	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gu	gum	316	GUAM	Guam	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ht	hti	332	HAITI	Haiti	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
hu	hun	348	HUNGARY	Hungary	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
is	isl	352	ICELAND	Iceland	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
in	ind	356	INDIA	India	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
il	isr	376	ISRAEL	Israel	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
je	jey	832	JERSEY	Jersey	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ke	ken	404	KENYA	Kenya	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ly	lby	434	LIBYA	Libya	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mo	mac	446	MACAO	Macao	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ml	mli	466	MALI	Mali	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mt	mlt	470	MALTA	Malta	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mc	mco	492	MONACO	Monaco	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
nr	nru	520	NAURU	Nauru	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
np	npl	524	NEPAL	Nepal	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ne	ner	562	NIGER	Niger	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
nu	niu	570	NIUE	Niue	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mk	mkd	807	NORTH MACEDONIA	North Macedonia	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
no	nor	578	NORWAY	Norway	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
om	omn	512	OMAN	Oman	\N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:13:30.858-03	\N
pk	pak	586	PAKISTAN	Pakistan	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
pw	plw	585	PALAU	Palau	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
pa	pan	591	PANAMA	Panama	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
pe	per	604	PERU	Peru	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ph	phl	608	PHILIPPINES	Philippines	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
pl	pol	616	POLAND	Poland	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
qa	qat	634	QATAR	Qatar	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
re	reu	638	REUNION	Reunion	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
bl	blm	652	SAINT BARTHÉLEMY	Saint Barthélemy	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sk	svk	703	SLOVAKIA	Slovakia	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
so	som	706	SOMALIA	Somalia	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
th	tha	764	THAILAND	Thailand	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tg	tgo	768	TOGO	Togo	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
to	ton	776	TONGA	Tonga	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
us	usa	840	UNITED STATES	United States	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
ax	ala	248	ÅLAND ISLANDS	Åland Islands	\N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:13:30.859-03	\N
dk	dnk	208	DENMARK	Denmark	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:14:17.447-03	\N
fr	fra	250	FRANCE	France	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:14:17.447-03	\N
de	deu	276	GERMANY	Germany	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:14:17.447-03	\N
it	ita	380	ITALY	Italy	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	\N	2025-11-07 17:13:30.858-03	2025-11-07 17:14:17.448-03	\N
es	esp	724	SPAIN	Spain	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:14:17.447-03	\N
se	swe	752	SWEDEN	Sweden	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:14:17.448-03	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	reg_01K9FZ96V1AT4PGR95NE8VYZ8N	\N	2025-11-07 17:13:30.859-03	2025-11-07 17:14:17.447-03	\N
\.


--
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01K9FZ96V1AT4PGR95NE8VYZ8N	pp_system_default	regpp_01K9FZ96VRF0ZX6WASJAH2WZPA	2025-11-07 17:14:17.464435-03	2025-11-07 17:14:17.464435-03	\N
\.


--
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
\.


--
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01K9FZ84KQM1PG94Q6YT6248EW	Default Sales Channel	Created by Medusa	f	\N	2025-11-07 17:13:42.391-03	2025-11-07 17:13:42.391-03	\N
\.


--
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01K9FZ84KQM1PG94Q6YT6248EW	sloc_01K9FZ96WA8AZB10YV6GRWBM87	scloc_01K9FZ96ZPWZ3M4WYGH44ZEBFX	2025-11-07 17:14:17.590561-03	2025-11-07 17:14:17.590561-03	\N
\.


--
-- Data for Name: script_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.script_migrations (id, script_name, created_at, finished_at) FROM stdin;
1	migrate-product-shipping-profile.js	2025-11-07 17:13:31.319895-03	2025-11-07 17:13:31.337641-03
2	migrate-tax-region-provider.js	2025-11-07 17:13:31.33934-03	2025-11-07 17:13:31.348416-03
\.


--
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01K9FZ96X41VSMYTYDMT6K3NGK	Europe	\N	fuset_01K9FZ96X4Q0137FGQX26XCACZ	2025-11-07 17:14:17.508-03	2025-11-07 17:14:17.508-03	\N
\.


--
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01K9FZ96Y837HYK3Y8G4RQBG1Z	Standard Shipping	flat	serzo_01K9FZ96X41VSMYTYDMT6K3NGK	sp_01K9FZ7ST5YJX8DKJ2WQZ5ZJ6F	manual_manual	\N	\N	sotype_01K9FZ96Y8K6B9ZH71CV74REAH	2025-11-07 17:14:17.545-03	2025-11-07 17:14:17.545-03	\N
so_01K9FZ96Y9JJ5HETGTPPVD4CR0	Express Shipping	flat	serzo_01K9FZ96X41VSMYTYDMT6K3NGK	sp_01K9FZ7ST5YJX8DKJ2WQZ5ZJ6F	manual_manual	\N	\N	sotype_01K9FZ96Y98795YWAG5GFCVMC4	2025-11-07 17:14:17.545-03	2025-11-07 17:14:17.545-03	\N
\.


--
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01K9FZ96Y837HYK3Y8G4RQBG1Z	pset_01K9FZ96YSMGE9BESK0MMP4R1Q	sops_01K9FZ96ZJN5EESZ07XDKBZCNT	2025-11-07 17:14:17.586078-03	2025-11-07 17:14:17.586078-03	\N
so_01K9FZ96Y9JJ5HETGTPPVD4CR0	pset_01K9FZ96YSG4A29EKE1TGMP73X	sops_01K9FZ96ZJ52W43C8SDAH86609	2025-11-07 17:14:17.586078-03	2025-11-07 17:14:17.586078-03	\N
\.


--
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01K9FZ96Y8XT3CEXECEMYTKE5P	enabled_in_store	eq	"true"	so_01K9FZ96Y837HYK3Y8G4RQBG1Z	2025-11-07 17:14:17.545-03	2025-11-07 17:14:17.545-03	\N
sorul_01K9FZ96Y8VJW1K23SY9BTMEP7	is_return	eq	"false"	so_01K9FZ96Y837HYK3Y8G4RQBG1Z	2025-11-07 17:14:17.545-03	2025-11-07 17:14:17.545-03	\N
sorul_01K9FZ96Y9Y9XYY5CWPN4Y1JJE	enabled_in_store	eq	"true"	so_01K9FZ96Y9JJ5HETGTPPVD4CR0	2025-11-07 17:14:17.545-03	2025-11-07 17:14:17.545-03	\N
sorul_01K9FZ96Y956D0Z0ZP0PR1M8GE	is_return	eq	"false"	so_01K9FZ96Y9JJ5HETGTPPVD4CR0	2025-11-07 17:14:17.545-03	2025-11-07 17:14:17.545-03	\N
\.


--
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01K9FZ96Y8K6B9ZH71CV74REAH	Standard	Ship in 2-3 days.	standard	2025-11-07 17:14:17.545-03	2025-11-07 17:14:17.545-03	\N
sotype_01K9FZ96Y98795YWAG5GFCVMC4	Express	Ship in 24 hours.	express	2025-11-07 17:14:17.545-03	2025-11-07 17:14:17.545-03	\N
\.


--
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01K9FZ7ST5YJX8DKJ2WQZ5ZJ6F	Default Shipping Profile	default	\N	2025-11-07 17:13:31.333-03	2025-11-07 17:13:31.333-03	\N
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01K9FZ96WA8AZB10YV6GRWBM87	2025-11-07 17:14:17.482-03	2025-11-07 17:14:17.482-03	\N	European Warehouse	laddr_01K9FZ96WAQGBKDSZV6P19WRHE	\N
\.


--
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01K9FZ96WAQGBKDSZV6P19WRHE	2025-11-07 17:14:17.482-03	2025-11-07 17:14:17.482-03	\N		\N	\N	Copenhagen	DK	\N	\N	\N	\N
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01K9FZ84M0DNS87GJ63G77GJVS	Medusa Store	sc_01K9FZ84KQM1PG94Q6YT6248EW	\N	sloc_01K9FZ96WA8AZB10YV6GRWBM87	\N	2025-11-07 17:13:42.399741-03	2025-11-07 17:13:42.399741-03	\N
\.


--
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01K9FZ96TFGCPNM22YMB39MWWR	eur	t	store_01K9FZ84M0DNS87GJ63G77GJVS	2025-11-07 17:14:17.419573-03	2025-11-07 17:14:17.419573-03	\N
stocur_01K9FZ96TFKPA4GYXHFQS7FF8T	usd	f	store_01K9FZ84M0DNS87GJ63G77GJVS	2025-11-07 17:14:17.419573-03	2025-11-07 17:14:17.419573-03	\N
\.


--
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tax_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
tp_system	t	2025-11-07 17:13:30.852-03	2025-11-07 17:13:30.852-03	\N
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txrate_01JCAR_IVA_10_5	10.5	IVA_AR_10_5	IVA Argentina 10.5% - Bienes de Capital	t	f	txreg_01JCARGENTINA2025	\N	2025-11-08 17:10:28.392957-03	2025-11-08 17:10:28.392957-03	\N	\N
txrate_01JCAR_IVA_21	21	IVA_AR_21	IVA Argentina 21% - General	f	f	txreg_01JCARGENTINA2025	\N	2025-11-08 17:10:39.458573-03	2025-11-08 17:10:39.458573-03	\N	\N
\.


--
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txreg_01K9FZ96VZFBNQDPDDTGXPTF39	tp_system	es	\N	\N	\N	2025-11-07 17:14:17.472-03	2025-11-07 17:14:17.472-03	\N	\N
txreg_01JCARGENTINA2025	tp_system	ar	\N	\N	\N	2025-11-08 17:10:17.601421-03	2025-11-08 17:10:17.601421-03	\N	\N
txreg_01K9FZ96VZ9GX7EZP7M59522RK	tp_system	it	\N	\N	\N	2025-11-07 17:14:17.472-03	2025-11-08 17:13:15.711-03	\N	2025-11-08 17:13:15.707-03
txreg_01K9FZ96VZ3S96PSEDM98A862M	tp_system	se	\N	\N	\N	2025-11-07 17:14:17.472-03	2025-11-08 17:13:20.41-03	\N	2025-11-08 17:13:20.409-03
txreg_01K9FZ96VZFRKZ5BSK1NPZW1MS	tp_system	gb	\N	\N	\N	2025-11-07 17:14:17.471-03	2025-11-08 17:13:23.983-03	\N	2025-11-08 17:13:23.982-03
txreg_01K9FZ96VZQ7E6190BGCKHY1BJ	tp_system	fr	\N	\N	\N	2025-11-07 17:14:17.472-03	2025-11-08 17:13:27.527-03	\N	2025-11-08 17:13:27.527-03
txreg_01K9FZ96VZ0T36RF8A675BMTC3	tp_system	dk	\N	\N	\N	2025-11-07 17:14:17.471-03	2025-11-08 17:13:35.363-03	\N	2025-11-08 17:13:35.363-03
txreg_01K9FZ96VZ1YV9PRAZWVJRSPR1	tp_system	de	\N	\N	\N	2025-11-07 17:14:17.471-03	2025-11-08 17:13:39.155-03	\N	2025-11-08 17:13:39.15-03
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01K9FZ84MEBHSJNASQJ9P3XR5D	\N	\N	admin@example.com	\N	\N	2025-11-07 17:13:42.414-03	2025-11-07 17:13:42.414-03	\N
\.


--
-- Data for Name: user_preference; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_preference (id, user_id, key, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: view_configuration; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.view_configuration (id, entity, name, user_id, is_system_default, configuration, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at, retention_time, run_id) FROM stdin;
\.


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 18, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 141, true);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, false);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, false);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- Name: script_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.script_migrations_id_seq', 2, true);


--
-- Name: account_holder account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_holder
    ADD CONSTRAINT account_holder_pkey PRIMARY KEY (id);


--
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: credit_line credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_pkey PRIMARY KEY (id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- Name: customer_account_holder customer_account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_account_holder
    ADD CONSTRAINT customer_account_holder_pkey PRIMARY KEY (customer_id, account_holder_id);


--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- Name: order_credit_line order_credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_pkey PRIMARY KEY (id);


--
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- Name: product_shipping_profile product_shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_shipping_profile
    ADD CONSTRAINT product_shipping_profile_pkey PRIMARY KEY (product_id, shipping_profile_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- Name: product_variant_product_image product_variant_product_image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variant_product_image
    ADD CONSTRAINT product_variant_product_image_pkey PRIMARY KEY (id);


--
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget_usage promotion_campaign_budget_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_campaign_budget_usage
    ADD CONSTRAINT promotion_campaign_budget_usage_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- Name: script_migrations script_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.script_migrations
    ADD CONSTRAINT script_migrations_pkey PRIMARY KEY (id);


--
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_preference user_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_preference
    ADD CONSTRAINT user_preference_pkey PRIMARY KEY (id);


--
-- Name: view_configuration view_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.view_configuration
    ADD CONSTRAINT view_configuration_pkey PRIMARY KEY (id);


--
-- Name: workflow_execution workflow_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT workflow_execution_pkey PRIMARY KEY (workflow_id, transaction_id, run_id);


--
-- Name: IDX_account_holder_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_account_holder_deleted_at" ON public.account_holder USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON public.customer_account_holder USING btree (account_holder_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_provider_id_external_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_account_holder_provider_id_external_id_unique" ON public.account_holder USING btree (provider_id, external_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_redacted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_api_key_redacted" ON public.api_key USING btree (redacted) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_revoked_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_api_key_revoked_at" ON public.api_key USING btree (revoked_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- Name: IDX_auth_identity_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- Name: IDX_cart_credit_line_reference_reference_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_credit_line_reference_reference_id" ON public.credit_line USING btree (reference, reference_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_credit_line_cart_id" ON public.credit_line USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_credit_line_deleted_at" ON public.credit_line USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- Name: IDX_customer_address_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- Name: IDX_customer_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- Name: IDX_customer_group_customer_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_customer_id_5cb3a0c0" ON public.customer_account_holder USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17a262437; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_17a262437" ON public.product_shipping_profile USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_5cb3a0c0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON public.customer_account_holder USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- Name: IDX_id_17a262437; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_17a262437" ON public.product_shipping_profile USING btree (id);


--
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- Name: IDX_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_5cb3a0c0" ON public.customer_account_holder USING btree (id);


--
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- Name: IDX_image_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_image_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_image_product_id" ON public.image USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_sku; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_invite_email_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- Name: IDX_line_item_product_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_line_item_product_type_id" ON public.order_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));


--
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- Name: IDX_notification_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_notification_deleted_at" ON public.notification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_notification_provider_deleted_at" ON public.notification_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- Name: IDX_order_address_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_address_deleted_at" ON public.order_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_version; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_change_version" ON public.order_change USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_credit_line_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_credit_line_order_id_version; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_credit_line_order_id_version" ON public.order_credit_line USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_sales_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_sales_channel_id" ON public."order" USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_shipping_method_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_shipping_shipping_method_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_transaction_order_id" ON public.order_transaction USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- Name: IDX_payment_payment_session_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_payment_payment_session_id_unique" ON public.payment USING btree (payment_session_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_id_status_starts_at_ends_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_list_id_status_starts_at_ends_at" ON public.price_list USING btree (id, status, starts_at, ends_at) WHERE ((deleted_at IS NULL) AND (status = 'active'::text));


--
-- Name: IDX_price_list_rule_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_list_rule_attribute" ON public.price_list_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_list_rule_value" ON public.price_list_rule USING gin (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_rule_attribute" ON public.price_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_rule_attribute_value" ON public.price_rule USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value_price_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_rule_attribute_value_price_id" ON public.price_rule USING btree (attribute, value, price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_rule_operator; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);


--
-- Name: IDX_price_rule_operator_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_rule_operator_value" ON public.price_rule USING btree (operator, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id_attribute_operator_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_parent_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_17a262437; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_id_17a262437" ON public.product_shipping_profile USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_rank; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_image_rank" ON public.image USING btree (rank) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_rank_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_image_rank_product_id" ON public.image USING btree (rank, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_url_rank_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_image_url_rank_product_id" ON public.image USING btree (url, rank, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- Name: IDX_product_option_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_option_product_id" ON public.product_option USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_status" ON public.product USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_id_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_variant_id_product_id" ON public.product_variant USING btree (id, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_image_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_variant_product_image_deleted_at" ON public.product_variant_product_image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_image_image_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_variant_product_image_image_id" ON public.product_variant_product_image USING btree (image_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_image_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_product_variant_product_image_variant_id" ON public.product_variant_product_image USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_promotion_application_method_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_promotion_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_promotion_application_method_promotion_id_unique" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_campaign_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_campaign_id_unique" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_usage_attribute_value_budget_id_u; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_usage_attribute_value_budget_id_u" ON public.promotion_campaign_budget_usage USING btree (attribute_value, budget_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_usage_budget_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_campaign_budget_usage_budget_id" ON public.promotion_campaign_budget_usage USING btree (budget_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_usage_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_campaign_budget_usage_deleted_at" ON public.promotion_campaign_budget_usage USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_is_automatic; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_is_automatic" ON public.promotion USING btree (is_automatic) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- Name: IDX_promotion_rule_attribute_operator; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_rule_attribute_operator" ON public.promotion_rule USING btree (attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_attribute_operator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_rule_attribute_operator_id" ON public.promotion_rule USING btree (operator, attribute, id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- Name: IDX_promotion_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_promotion_rule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_rule_id_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_rule_value_rule_id_value" ON public.promotion_rule_value USING btree (promotion_rule_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_rule_value_value" ON public.promotion_rule_value USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_status" ON public.promotion USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- Name: IDX_provider_identity_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_reason_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_refund_reason_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_region_country_deleted_at" ON public.region_country USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_region_country_region_id" ON public.region_country USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_parent_return_reason_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_reason_parent_return_reason_id" ON public.return_reason USING btree (parent_return_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_id_17a262437; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_shipping_profile_id_17a262437" ON public.product_shipping_profile USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_address_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_stock_location_address_id_unique" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_currency_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_provider_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- Name: IDX_tax_region_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_unique_promotion_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_unique_promotion_code" ON public.promotion USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_user_email_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_preference_deleted_at" ON public.user_preference USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_preference_user_id" ON public.user_preference USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id_key_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_user_preference_user_id_key_unique" ON public.user_preference USING btree (user_id, key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_view_configuration_deleted_at" ON public.view_configuration USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_is_system_default; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_view_configuration_entity_is_system_default" ON public.view_configuration USING btree (entity, is_system_default) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_view_configuration_entity_user_id" ON public.view_configuration USING btree (entity, user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_view_configuration_user_id" ON public.view_configuration USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_retention_time_updated_at_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_retention_time_updated_at_state" ON public.workflow_execution USING btree (retention_time, updated_at, state) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL));


--
-- Name: IDX_workflow_execution_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_run_id" ON public.workflow_execution USING btree (run_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_state_updated_at" ON public.workflow_execution USING btree (state, updated_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_updated_at_retention_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_updated_at_retention_time" ON public.workflow_execution USING btree (updated_at, retention_time) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL) AND ((state)::text = ANY ((ARRAY['done'::character varying, 'failed'::character varying, 'reverted'::character varying])::text[])));


--
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_workflow_execution_workflow_id_transaction_id" ON public.workflow_execution USING btree (workflow_id, transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id_run_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IDX_workflow_execution_workflow_id_transaction_id_run_id_unique" ON public.workflow_execution USING btree (workflow_id, transaction_id, run_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_script_name_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_script_name_unique ON public.script_migrations USING btree (script_name);


--
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: credit_line credit_line_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE;


--
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: image image_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_credit_line order_credit_line_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_summary order_summary_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_col_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_col_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_pro_2d555_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_pro_2d555_foreign FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_product_image product_variant_product_image_image_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variant_product_image
    ADD CONSTRAINT product_variant_product_image_image_id_foreign FOREIGN KEY (image_id) REFERENCES public.image(id) ON DELETE CASCADE;


--
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget_usage promotion_campaign_budget_usage_budget_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_campaign_budget_usage
    ADD CONSTRAINT promotion_campaign_budget_usage_budget_id_foreign FOREIGN KEY (budget_id) REFERENCES public.promotion_campaign_budget(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 9yJmHPVvIF6TMmp7rqKW0bjegk37v3xbjEF9wAWdAAUdw8a9TWoRR0JHOgmglWC

