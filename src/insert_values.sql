--ADDRESSES INSERT
INSERT INTO addresses VALUES (
    1,
    'OT',
    'Slatina',
    'Strada Shomoldoaca',
    '1'
);

INSERT INTO addresses VALUES (
    2,
    'OT',
    'Caracal',
    'Strada 1 Decembrie 1918',
    '71'
);

INSERT INTO addresses VALUES (
    3,
    'DJ',
    'Craiova',
    'Strada Harghita',
    '2B'
);

INSERT INTO addresses VALUES (
    4,
    'B',
    'Bucuresti',
    'Bulevardul Timisoara',
    '12'
);

INSERT INTO addresses VALUES (
    5,
    'B',
    'Bucuresti',
    'Strada Coricioaica',
    '7'
);

--LAPTOPMODELS INSERT
INSERT INTO laptopmodels VALUES (
    1,
    'Apple',
    'Macbook Pro',
    14,
    'M3 Pro',
    16,
    512
);

INSERT INTO laptopmodels VALUES (
    2,
    'Apple',
    'Macbook Air',
    15,
    'M2',
    8,
    256
);

INSERT INTO laptopmodels VALUES (
    3,
    'Lenovo',
    'Legion 5 Pro',
    16,
    'AMD Ryzen 7 5800H',
    16,
    512
);

INSERT INTO laptopmodels VALUES (
    4,
    'Asus',
    'Zenbook',
    14,
    'Intel Core i5 1280P',
    16,
    1024
);

INSERT INTO laptopmodels VALUES (
    5,
    'Lenovo',
    'Ideapad 5 Pro',
    14,
    'AMD Ryzen 7 5800U',
    16,
    1024
);


--create sequence for customer_id
CREATE SEQUENCE customer_id_seq MINVALUE 1 MAXVALUE 20000000 START WITH 1 INCREMENT BY 1 CACHE 20;

--CUSTOMERS INSERT
--firstly, i insert my name
INSERT INTO customers VALUES (
    customer_id_seq.NEXTVAL,
    'gygy.bos@gmail.com',
    '+40761231231',
    'Gigi',
    'Bosniescu',
    1
);

INSERT INTO customers VALUES (
    customer_id_seq.NEXTVAL,
    'mirceaxulescu12@gmail.com',
    '+374254894123',
    'Mircea',
    'Xulescu',
    2
);

INSERT INTO customers VALUES (
    customer_id_seq.NEXTVAL,
    'sexifoxx33@yahoo.fr',
    '+40745233897',
    'Alejandro',
    'Audi',
    3
);

INSERT INTO customers VALUES (
    customer_id_seq.NEXTVAL,
    'business_franco69@gmail.com',
    '+33555293323',
    'Jean',
    'Claude',
    4
);

INSERT INTO customers VALUES (
    customer_id_seq.NEXTVAL,
    'mironcosma@gmail.com',
    '+40755123898',
    'Miron',
    'Cosma',
    5
);

--create index for faster access of email
CREATE INDEX ix_customers_email ON
    customers (
        email
    );

--CARTS INSERT
INSERT INTO carts VALUES ( 1 );

INSERT INTO carts VALUES ( 2 );

INSERT INTO carts VALUES ( 3 );

INSERT INTO carts VALUES ( 4 );

INSERT INTO carts VALUES ( 5 );

--LAPTOPS INSERT
INSERT INTO laptops VALUES (
    1,
    1,
    12000,
    14999.99,
    'Excellent',
    1,
    2,
    NULL
);

INSERT INTO laptops VALUES (
    2,
    2,
    5000,
    6699.99,
    'Like New',
    3,
    NULL,
    NULL
);

INSERT INTO laptops VALUES (
    3,
    3,
    4500,
    5999.99,
    'Very Good',
    4,
    NULL,
    5
);

INSERT INTO laptops VALUES (
    4,
    4,
    2500,
    3799.99,
    'Excellent',
    2,
    NULL,
    NULL
);

INSERT INTO laptops VALUES (
    5,
    5,
    2800,
    4699.99,
    'Very Good',
    2,
    NULL,
    3
);

--ORDERS INSERT
INSERT INTO orders VALUES (
    1,
    1,
    TO_DATE('15-03-2023', 'DD-MM-YYYY'),
    'Sell'
);

INSERT INTO orders VALUES (
    2,
    2,
    TO_DATE('17-05-2023', 'DD-MM-YYYY'),
    'Buy'
);

INSERT INTO orders VALUES (
    3,
    3,
    TO_DATE('22-06-2023', 'DD-MM-YYYY'),
    'Sell'
);

INSERT INTO orders VALUES (
    4,
    4,
    TO_DATE('03-07-2023', 'DD-MM-YYYY'),
    'Sell'
);

INSERT INTO orders VALUES (
    5,
    2,
    TO_DATE('01-08-2023', 'DD-MM-YYYY'),
    'Sell'
);

INSERT INTO orders VALUES (
    6,
    2,
    TO_DATE('23-09-2023', 'DD-MM-YYYY'),
    'Sell'
);

--ORDERSLAPTOPS INSERT
INSERT INTO orderslaptops VALUES (
    1,
    1
);

INSERT INTO orderslaptops VALUES (
    2,
    1
);

INSERT INTO orderslaptops VALUES (
    3,
    2
);

INSERT INTO orderslaptops VALUES (
    4,
    3
);

INSERT INTO orderslaptops VALUES (
    5,
    4
);

INSERT INTO orderslaptops VALUES (
    6,
    5
);

--REVIEWS INSERT
INSERT INTO reviews VALUES (
    1,
    1,
    5,
    'Amazing service!! :D'
);

INSERT INTO reviews VALUES (
    2,
    2,
    5,
    'They gave me free pizza :p'
);

INSERT INTO reviews VALUES (
    3,
    3,
    5,
    'I bought it used but it looks like new <3'
);

INSERT INTO reviews VALUES (
    4,
    4,
    5,
    'This business is going to make millions $$$'
);

INSERT INTO reviews VALUES (
    5,
    5,
    5,
    'Top notch!'
);



------------------------------UPDATE,DELETE,MERGE-----------------------------------
------------UPDATE------------
--change a customer's name
UPDATE customers
SET
    first_name = 'Emanuel'
WHERE
    customer_id = 3;

SELECT
    customer_id, first_name
FROM
    customers
WHERE
    customer_id = 3;

--change a review's message
UPDATE reviews
SET
    message = 'Ultra mega top notch!!!'
WHERE
    review_id = 5;

SELECT
    review_id, message
FROM
    reviews
WHERE
    review_id = 5;

-----------------DELETE-----------------
--insert and delete address
INSERT INTO addresses VALUES (
    6,
    'OT',
    'London',
    'Strada Intrarea Mecanicilor',
    '65A'
);

DELETE FROM addresses
WHERE
    address_id = 6;

----------------MERGE------------------
--create table with new prices and merge
CREATE TABLE newsellprices (
    laptop_id      NUMBER(7),
    new_price_sell NUMBER(7, 2)
);

INSERT INTO newsellprices VALUES (
    1,
    13999.99
);

INSERT INTO newsellprices VALUES (
    2,
    6099.99
);

INSERT INTO newsellprices VALUES (
    3,
    5499.99
);

INSERT INTO newsellprices VALUES (
    4,
    3499.99
);

INSERT INTO newsellprices VALUES (
    5,
    4499.99
);

MERGE INTO laptops l
USING newsellprices nsp ON ( l.laptop_id = nsp.laptop_id )
WHEN MATCHED THEN UPDATE
SET l.price_sell = nsp.new_price_sell;

SELECT
    laptop_id, price_sell
FROM
    laptops;