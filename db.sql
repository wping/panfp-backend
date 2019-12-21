
CREATE TABLE public.brand
(
    web text COLLATE pg_catalog."default" NOT NULL,
    logo text COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    brand_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 100000000 CACHE 1 ),
    modified_time timestamp with time zone NOT NULL
);

CREATE TABLE public.customer
(
    customer_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    phone text COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default",
    gender boolean,
    point integer,
    birthday date,
    rank integer,
    balance double precision,
    register_time timestamp with time zone,
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT "customer info_pkey" PRIMARY KEY (customer_id)
);


CREATE TABLE public.customer_address
(
    customer_addr_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 10000000 CACHE 1 ),
    customer_id integer,
    zip integer NOT NULL,
    is_default boolean,
    province text COLLATE pg_catalog."default" NOT NULL,
    city text COLLATE pg_catalog."default" NOT NULL,
    district text COLLATE pg_catalog."default" NOT NULL,
    address text COLLATE pg_catalog."default" NOT NULL,
    modified_time timestamp(6) with time zone DEFAULT now(),
    CONSTRAINT customer_addr_pkey PRIMARY KEY (customer_addr_id)
);

CREATE TABLE public.customer_balance_log
(
    balance_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    customer_id integer NOT NULL,
    source integer NOT NULL,
    amount double precision NOT NULL,
    source_sn text COLLATE pg_catalog."default",
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT customer_balance_log_pkey PRIMARY KEY (balance_id)
);


CREATE TABLE public.customer_level_info
(
    customer_level_id integer,
    min_point integer,
    max_point integer,
    level_name text COLLATE pg_catalog."default",
    modified_time timestamp with time zone DEFAULT now()
);


CREATE TABLE public.customer_login
(
    customer_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 10000000 CACHE 1 ),
    user_status integer,
    login_name text COLLATE pg_catalog."default",
    password text COLLATE pg_catalog."default",
    modified_time time without time zone DEFAULT now(),
    CONSTRAINT customer_login_pkey PRIMARY KEY (customer_id)
);

CREATE TABLE public.customer_login_log
(
    login_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( CYCLE INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 100000000 CACHE 1 ),
    customer_id integer NOT NULL,
    login_type integer NOT NULL,
    login_time timestamp with time zone DEFAULT now(),
    login_ip text COLLATE pg_catalog."default",
    CONSTRAINT customer_login_log_pkey PRIMARY KEY (login_id)
);
CREATE TABLE public.customer_point_log
(
    point_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    customer_id integer NOT NULL,
    source integer NOT NULL,
    refer_number integer NOT NULL,
    change_point integer NOT NULL,
    create_time timestamp with time zone DEFAULT now(),
    CONSTRAINT customer_point_log_pkey PRIMARY KEY (point_id)
);
CREATE TABLE public.hotproduct
(
    hotproduct_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 10000000 CACHE 1 ),
    brand_id integer NOT NULL,
    status integer,
    order_id integer
);

CREATE TABLE public.order_cart
(
    cart_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 10000000 CACHE 1 ),
    customer_id integer NOT NULL,
    product_id integer NOT NULL,
    product_amount integer NOT NULL,
    price double precision NOT NULL,
    add_time timestamp with time zone DEFAULT now(),
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT order_cart_pkey PRIMARY KEY (cart_id)
);

CREATE TABLE public.order_detail
(
    order_detail_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    product_cnt integer NOT NULL,
    product_price double precision NOT NULL,
    average_cost double precision NOT NULL,
    weight double precision,
    fee_money double precision NOT NULL,
    w_id integer NOT NULL,
    product_name text COLLATE pg_catalog."default",
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT order_detail_pkey PRIMARY KEY (order_detail_id)
);
CREATE TABLE public.order_master
(
    order_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    customer_id integer NOT NULL,
    payment_method integer NOT NULL,
    order_money double precision NOT NULL,
    district_money double precision NOT NULL,
    shipping_money double precision NOT NULL,
    payment_money double precision NOT NULL,
    shipping_time timestamp(4) with time zone NOT NULL,
    pay_time timestamp(4) with time zone,
    receive_time timestamp(4) with time zone,
    order_status integer NOT NULL,
    order_point integer NOT NULL,
    shipping_user text COLLATE pg_catalog."default",
    province text COLLATE pg_catalog."default",
    city text COLLATE pg_catalog."default",
    district text COLLATE pg_catalog."default",
    address text COLLATE pg_catalog."default",
    invoice_title text COLLATE pg_catalog."default",
    shipping_comp_name text COLLATE pg_catalog."default",
    shipping_sn text COLLATE pg_catalog."default",
    order_sn text COLLATE pg_catalog."default",
    create_time timestamp with time zone,
    modified_time timestamp with time zone,
    CONSTRAINT order_master_pkey PRIMARY KEY (order_id)
);

CREATE TABLE public.product
(
    product_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    brand_id integer NOT NULL,
    one_category_id integer NOT NULL,
    two_category_id integer NOT NULL,
    supplier_id integer NOT NULL,
    price double precision NOT NULL,
    average_cost double precision NOT NULL,
    publish_status integer NOT NULL,
    audit_status integer NOT NULL,
    weight double precision,
    length double precision,
    height double precision,
    width double precision,
    production_date date NOT NULL,
    shelf_life integer NOT NULL,
    product_core text COLLATE pg_catalog."default",
    product_name text COLLATE pg_catalog."default",
    bar_code text COLLATE pg_catalog."default",
    color_type text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    indate timestamp with time zone,
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT product_info_pkey PRIMARY KEY (product_id)
);
CREATE TABLE public.product_category
(
    category_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 1000000000 CACHE 1 ),
    parent_id integer NOT NULL,
    category_level integer NOT NULL,
    category_status integer NOT NULL,
    category_name text COLLATE pg_catalog."default",
    category_code text COLLATE pg_catalog."default",
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT product_category_pkey PRIMARY KEY (category_id)
);
CREATE TABLE public.product_comment
(
    comment_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    product_id integer NOT NULL,
    order_id integer NOT NULL,
    customer_id integer NOT NULL,
    audit_status integer NOT NULL,
    title text COLLATE pg_catalog."default",
    content text COLLATE pg_catalog."default",
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT product_comment_pkey PRIMARY KEY (comment_id)
);
CREATE TABLE public.product_pic_info
(
    product_pic_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 1000000000 CACHE 1 ),
    product_id integer NOT NULL,
    pic_status integer NOT NULL,
    pic_desc text COLLATE pg_catalog."default",
    pic_url text COLLATE pg_catalog."default" NOT NULL,
    is_master boolean,
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT product_pic_info_pkey PRIMARY KEY (product_pic_id)
);
CREATE TABLE public.shipping
(
    ship_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    ship_name text COLLATE pg_catalog."default" NOT NULL,
    ship_contact text COLLATE pg_catalog."default" NOT NULL,
    phone text COLLATE pg_catalog."default",
    price double precision,
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT shipping_info_pkey PRIMARY KEY (ship_id)
);
CREATE TABLE public.supplier
(
    supplier_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    supplier_type integer NOT NULL,
    supplier_status integer NOT NULL,
    supplier_code text COLLATE pg_catalog."default",
    supplier_name text COLLATE pg_catalog."default",
    link_man text COLLATE pg_catalog."default",
    phone text COLLATE pg_catalog."default",
    bank_name text COLLATE pg_catalog."default",
    bank_account text COLLATE pg_catalog."default",
    address text COLLATE pg_catalog."default",
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT supplier_info_pkey PRIMARY KEY (supplier_id)
);
CREATE TABLE public.warehouse
(
    w_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 1000 CACHE 1 ),
    warehouse_status integer NOT NULL,
    warehouse_sn text COLLATE pg_catalog."default",
    warehouse_name text COLLATE pg_catalog."default",
    warehouse_phone text COLLATE pg_catalog."default",
    contact text COLLATE pg_catalog."default",
    city text COLLATE pg_catalog."default",
    district text COLLATE pg_catalog."default",
    address text COLLATE pg_catalog."default",
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT warehouse_info_pkey PRIMARY KEY (w_id)
);

CREATE TABLE public.warehouse_product
(
    wp_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 0 MINVALUE 0 MAXVALUE 100000000 CACHE 1 ),
    product_id integer NOT NULL,
    w_id integer NOT NULL,
    current_cnt integer NOT NULL,
    lock_cnt integer NOT NULL,
    in_transit_cnt integer NOT NULL,
    average_cost double precision NOT NULL,
    modified_time timestamp with time zone DEFAULT now(),
    CONSTRAINT warehouse_product_pkey PRIMARY KEY (wp_id)
);