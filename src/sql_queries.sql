--select all laptops which are not already sold
SELECT
    *
FROM
    laptops
WHERE
    buyer_id IS NULL
ORDER BY
    laptop_id ASC;

--select all laptops which have the condition of 'Very Good'
SELECT
    *
FROM
    laptops
WHERE
    condition LIKE 'Very Good'
ORDER BY
    laptop_id ASC;

--select all laptops which have the condition above 'Very Good'
SELECT
    *
FROM
    laptops
WHERE
    condition IN ( 'Excellent', 'Like New' )
ORDER BY
    laptop_id ASC;

--select all laptops which have a price between 5000 and 6000
SELECT
    *
FROM
    laptops
WHERE
    price_sell BETWEEN 5000 AND 6000
ORDER BY
    laptop_id ASC;

--select all laptops which have a price lower than 4000 and greater than 10000
SELECT
    *
FROM
    laptops
WHERE
    price_sell < 4000
    OR price_sell > 10000
ORDER BY
    laptop_id ASC;

--select all laptops which have the sell price larger than all buy prices
SELECT
    *
FROM
    laptops
WHERE
    price_sell > ALL (
        SELECT
            price_buy
        FROM
            laptops
    )
ORDER BY
    laptop_id ASC;

--select all laptops which have the buy price larger than at least one of the sell prices
SELECT
    *
FROM
    laptops
WHERE
    price_buy > ANY (
        SELECT
            price_sell
        FROM
            laptops
    )
ORDER BY
    laptop_id ASC;

--select all customers and all laptop models they either bought or sold
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    lm.*
FROM
         customers c
    JOIN laptops      l ON c.customer_id IN ( l.supplier_id, l.buyer_id )
    JOIN laptopmodels lm ON l.model_id = lm.model_id
ORDER BY
    c.customer_id ASC;

--select all carts and the laptops inside
SELECT
    c.cart_id,
    l.laptop_id
FROM
    carts   c
    LEFT OUTER JOIN laptops l ON c.cart_id = l.cart_id
UNION
SELECT
    c.cart_id,
    l.laptop_id
FROM
    carts   c
    RIGHT OUTER JOIN laptops l ON c.cart_id = l.cart_id;

SELECT
    c.cart_id,
    l.laptop_id
FROM
    carts   c
    FULL OUTER JOIN laptops l ON c.cart_id = l.cart_id;

--select carts which have a total value larger than 3000
SELECT
    cart_id,
    SUM(price_sell) cart_value
FROM
    laptops
GROUP BY
    cart_id
HAVING SUM(price_sell) > 3000
       AND cart_id IS NOT NULL;

--select all laptops and categorize them based on ssd size
SELECT
    l.laptop_id,
    lm.brand,
    lm.model_name,
    lm.ssd_capacity,
    CASE
        WHEN lm.ssd_capacity <= 256               THEN
            'Small'
        WHEN lm.ssd_capacity BETWEEN 257 AND 1023 THEN
            'Medium'
        WHEN lm.ssd_capacity >= 1024              THEN
            'Large'
    END AS ssd_category
FROM
         laptops l
    JOIN laptopmodels lm ON l.model_id = lm.model_id;

--select all orders made in june
SELECT
    order_id,
    order_date
FROM
    orders
WHERE
    EXTRACT(MONTH FROM order_date) = 6;

--select all the months in which orders were made
SELECT
    substr(to_char(order_date),
           4,
           3) months_with_orders
FROM
    orders;

--print the time between today and the last order
SELECT
    round(sysdate - order_date) days
FROM
    orders,
    dual
WHERE
    order_date >= ALL (
        SELECT
            order_date
        FROM
            orders
    );

--categorize laptops based on display size
SELECT
    brand,
    model_name,
    display_size,
    decode(sign(display_size - 15),
           - 1,
           'Small',
           0,
           'Medium',
           1,
           'Large')
FROM
    laptopmodels;

--select each laptop and its buyer or -1 if there is no buyer yet
SELECT
    laptop_id,
    nvl(buyer_id, - 1) buyer
FROM
    laptops;

--select people who have gmail intersected with people who have romanian phone number
SELECT
    customer_id,
    first_name,
    last_name,
    phone_number,
    email
FROM
    customers
WHERE
    email LIKE '%gmail%'
INTERSECT
SELECT
    customer_id,
    first_name,
    last_name,
    phone_number,
    email
FROM
    customers
WHERE
    phone_number LIKE '+40%';

--select union of people from caracal and people from craiova
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    a.city
FROM
         customers c
    JOIN addresses a ON a.address_id = c.address_id
WHERE
    a.city LIKE 'Caracal'
UNION
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    a.city
FROM
         customers c
    JOIN addresses a ON a.address_id = c.address_id
WHERE
    a.city LIKE 'Craiova';

--select all people who don't have romanian phone number
SELECT
    customer_id,
    first_name,
    last_name,
    phone_number
FROM
    customers
MINUS
SELECT
    customer_id,
    first_name,
    last_name,
    phone_number
FROM
    customers
WHERE
    phone_number LIKE '+40%';

--select laptops which have a price lower than the average of the laptops which have a condition of 'Excellent'
SELECT
    l1.laptop_id,
    l1.condition,
    l1.price_sell
FROM
    laptops l1
WHERE
    l1.condition LIKE 'Excellent'
    AND price_sell < (
        SELECT
            AVG(price_sell)
        FROM
            laptops l2
        WHERE
            l1.condition = l2.condition
    );
    
--create a table which contains every order and the customers who placed the order
CREATE TABLE ordersandcustomers
    AS
        (
            SELECT
                o.order_id,
                o.order_date,
                o.order_type,
                c.customer_id,
                c.first_name,
                c.last_name
            FROM
                     orders o
                JOIN customers c ON o.customer_id = c.customer_id
        );

SELECT
    *
FROM
    ordersandcustomers;

--create a table with fewer data about a laptop and insert the respective rows into it
CREATE TABLE keydatalaptops (
    laptop_id  NUMBER(7),
    model_id   NUMBER(2),
    price_sell NUMBER(7, 2)
);

INSERT INTO keydatalaptops
    SELECT
        laptop_id,
        model_id,
        price_sell
    FROM
        laptops;

SELECT
    *
FROM
    keydatalaptops;

--update prices on keydatalaptops with the buy prices of the laptops because we are bankrupt :P
UPDATE keydatalaptops
SET
    price_sell = (
        SELECT
            price_buy
        FROM
            laptops
        WHERE
            keydatalaptops.laptop_id = laptops.laptop_id
    );

--join customers and orders tables and use it as a view by selecting all orders which were placed more recently than 2018 together with their customers
CREATE VIEW customersandorders AS
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        o.order_id,
        o.order_date,
        o.order_type
    FROM
             customers c
        JOIN orders o ON c.customer_id = o.customer_id;

SELECT
    order_id,
    order_date,
    customer_id,
    first_name,
    last_name
FROM
    customersandorders
WHERE
    EXTRACT(YEAR FROM order_date) > 2018;