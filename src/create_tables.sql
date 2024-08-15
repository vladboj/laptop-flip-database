DROP TABLE addresses CASCADE CONSTRAINTS;

DROP TABLE customers CASCADE CONSTRAINTS;

DROP TABLE laptopmodels CASCADE CONSTRAINTS;

DROP TABLE laptops CASCADE CONSTRAINTS;

DROP TABLE orders CASCADE CONSTRAINTS;

DROP TABLE orderslaptops CASCADE CONSTRAINTS;

DROP TABLE carts CASCADE CONSTRAINTS;

DROP TABLE reviews CASCADE CONSTRAINTS;

DROP SEQUENCE customer_id_seq;

DROP VIEW customersandorders;

DROP TABLE newsellprices CASCADE CONSTRAINTS;

DROP TABLE ordersandcustomers CASCADE CONSTRAINTS;

DROP TABLE keydatalaptops CASCADE CONSTRAINTS;

CREATE TABLE addresses (
    address_id    NUMBER(5),
    country       VARCHAR2(2),
    city          VARCHAR2(20),
    street        VARCHAR2(50),
    street_number VARCHAR2(5),
    CONSTRAINT pk_addresses PRIMARY KEY ( address_id ),
    CONSTRAINT nn_addresses_county CHECK ( country IS NOT NULL ),
    CONSTRAINT nn_addresses_city CHECK ( city IS NOT NULL ),
    CONSTRAINT nn_addresses_street CHECK ( street IS NOT NULL ),
    CONSTRAINT nn_addresses_street_number CHECK ( street_number IS NOT NULL )
);

ALTER TABLE addresses RENAME COLUMN country TO county;

CREATE TABLE laptopmodels (
    model_id       NUMBER(2),
    brand          VARCHAR2(20),
    model_name     VARCHAR2(20),
    display_size   NUMBER(3, 1),
    processor_name VARCHAR2(20),
    ram_capacity   NUMBER(3),
    ssd_capacity   NUMBER(4),
    CONSTRAINT pk_laptopmodels PRIMARY KEY ( model_id ),
    CONSTRAINT nn_laptopmodels_brand CHECK ( brand IS NOT NULL ),
    CONSTRAINT nn_laptopmodels_model_name CHECK ( model_name IS NOT NULL ),
    CONSTRAINT nn_laptopmodels_display_size CHECK ( display_size IS NOT NULL ),
    CONSTRAINT nn_laptopmodels_processor_name CHECK ( processor_name IS NOT NULL ),
    CONSTRAINT nn_laptopmodels_ram_capacity CHECK ( ram_capacity IS NOT NULL ),
    CONSTRAINT nn_laptopmodels_ssd_capacity CHECK ( ssd_capacity IS NOT NULL )
);

ALTER TABLE laptopmodels ADD to_be_deleted NUMBER(1);

ALTER TABLE laptopmodels DROP COLUMN to_be_deleted;

CREATE TABLE customerswrongnamechangeme (
    customer_id  NUMBER(5),
    email        VARCHAR2(50),
    phone_number VARCHAR2(15),
    first_name   VARCHAR2(20),
    last_name    VARCHAR2(20),
    address_id   NUMBER(5),
    CONSTRAINT pk_customers PRIMARY KEY ( customer_id ),
    CONSTRAINT fk_customers_addresses FOREIGN KEY ( address_id )
        REFERENCES addresses ( address_id ),
    CONSTRAINT nn_customers_email CHECK ( email IS NOT NULL ),
    CONSTRAINT nn_customers_phone_number CHECK ( phone_number IS NOT NULL ),
    CONSTRAINT nn_customers_first_name CHECK ( first_name IS NOT NULL ),
    CONSTRAINT nn_customers_last_name CHECK ( last_name IS NOT NULL ),
    CONSTRAINT nn_customers_address_id CHECK ( address_id IS NOT NULL )
);

ALTER TABLE customerswrongnamechangeme RENAME TO customers;

CREATE TABLE carts (
    cart_id_change_me NUMBER(5),
    CONSTRAINT fk_carts_customers FOREIGN KEY ( cart_id_change_me )
        REFERENCES customers ( customer_id ),
    CONSTRAINT nn_carts_cart_id CHECK ( cart_id_change_me IS NOT NULL ),
    CONSTRAINT uq_carts_cart_id UNIQUE ( cart_id_change_me )
);

ALTER TABLE carts RENAME COLUMN cart_id_change_me TO cart_id;

CREATE TABLE laptops (
    laptop_id   NUMBER(7),
    model_id    NUMBER(2),
    price_buy   NUMBER(7, 2),
    price_sell  NUMBER(7, 2),
    condition   VARCHAR2(20),
    supplier_id NUMBER(5),
    buyer_id    NUMBER(5),
    cart_id     NUMBER(5),
    CONSTRAINT pk_laptops PRIMARY KEY ( laptop_id ),
    CONSTRAINT fk_laptops_laptopmodels FOREIGN KEY ( model_id )
        REFERENCES laptopmodels ( model_id ),
    CONSTRAINT fk_laptops_customers_supplier FOREIGN KEY ( supplier_id )
        REFERENCES customers ( customer_id ),
    CONSTRAINT fk_laptops_customers_buyer FOREIGN KEY ( buyer_id )
        REFERENCES customers ( customer_id ),
    CONSTRAINT fk_laptops_carts FOREIGN KEY ( cart_id )
        REFERENCES carts ( cart_id ),
    CONSTRAINT nn_laptops_model_id CHECK ( model_id IS NOT NULL ),
    CONSTRAINT nn_laptops_price_buy CHECK ( price_buy IS NOT NULL ),
    CONSTRAINT nn_laptops_price_sell CHECK ( price_sell IS NOT NULL ),
    CONSTRAINT nn_laptops_condition CHECK ( condition IS NOT NULL ),
    CONSTRAINT ch_laptops_condition CHECK ( condition IN ( 'Good', 'Very Good', 'Excellent', 'Like New' ) ),
    CONSTRAINT nn_laptops_supplier_id CHECK ( supplier_id IS NOT NULL )
);

CREATE TABLE orders (
    order_id    NUMBER(8),
    customer_id NUMBER(5),
    order_date  DATE,
    order_type  VARCHAR2(5),
    CONSTRAINT pk_orders PRIMARY KEY ( order_id ),
    CONSTRAINT fk_orders_customers FOREIGN KEY ( customer_id )
        REFERENCES customers ( customer_id ),
    CONSTRAINT nn_orders_customer_id CHECK ( customer_id IS NOT NULL ),
    CONSTRAINT nn_orders_order_date CHECK ( order_date IS NOT NULL ),
    CONSTRAINT nn_orders_order_type CHECK ( order_type IS NOT NULL ),
    CONSTRAINT ch_orders_order_type CHECK ( order_type IN ( 'Buy', 'Sell' ) )
);

CREATE TABLE orderslaptops (
    order_id  NUMBER(8),
    laptop_id NUMBER(7),
    CONSTRAINT fk_orderslaptops_orders FOREIGN KEY ( order_id )
        REFERENCES orders ( order_id ),
    CONSTRAINT fk_orderslaptops_laptops FOREIGN KEY ( laptop_id )
        REFERENCES laptops ( laptop_id ),
    CONSTRAINT nn_orderslaptops_order_id CHECK ( order_id IS NOT NULL ),
    CONSTRAINT nn_orderslaptops_laptop_id CHECK ( laptop_id IS NOT NULL )
);

CREATE TABLE reviews (
    review_id NUMBER(10),
    model_id  NUMBER(2),
    stars     NUMBER(1),
    message   VARCHAR2(500),
    CONSTRAINT pk_reviews PRIMARY KEY ( review_id ),
    CONSTRAINT fk_reviews_laptopmodels FOREIGN KEY ( model_id )
        REFERENCES laptopmodels ( model_id ),
    CONSTRAINT nn_reviews_model_id CHECK ( model_id IS NOT NULL ),
    CONSTRAINT nn_reviews_stars CHECK ( stars IS NOT NULL ),
    CONSTRAINT ch_reviews_stars CHECK ( stars BETWEEN 1 AND 5 )
);