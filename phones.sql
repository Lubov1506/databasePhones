SELECT sum(quantity) from orders_to_phones;

SELECT sum(quantity) from phones;

SELECT avg(price) from phones;

SELECT brand,avg(price) from phones
GROUP BY brand;

SELECT sum(quantity*price) FROM phones
WHERE price BETWEEN 1000 AND 2000;

SELECT brand, count(*) FROM phones
GROUP BY brand;

SELECT user_id, count(*) FROM orders
GROUP BY user_id
ORDER BY user_id;

SELECT avg(price) FROM phones
WHERE brand='Nokia';


/* sorting */

SELECT * FROM users
ORDER BY height, birthday ASC
LIMIT 10
OFFSET 100;

SELECT * FROM users
ORDER BY height, birthday ASC, first_name;

SELECT * FROM phones
ORDER BY quantity
LIMIT 10;

SELECT * FROM phones
ORDER BY price DESC;

SELECT first_name, extract('year' from age(birthday)) AS "Age" from users
ORDER BY  extract('year' from age(birthday)), first_name;

SELECT count(*), "Age" FROM
(SELECT first_name, extract('year' from age(birthday)) AS "Age" from users) AS "u_w_age"
GROUP BY "Age"
ORDER BY "Age";

/* filtering
HAVING */

SELECT count(*), "Age" FROM
(SELECT first_name, extract('year' from age(birthday)) AS "Age" from users) AS "u_w_age"
GROUP BY "Age"
HAVING count(*) >=10
ORDER BY count(*) DESC;


SELECT brand, sum(quantity) from phones
GROUP BY brand
HAVING sum(quantity) > 1000
ORDER BY brand



----





SELECT  char_length(concat(first_name, ' ', last_name))AS "FN_length", * from users 
ORDER BY "FN_length" DESC
LIMIT 1;

SELECT char_length(concat(first_name, ' ', last_name))AS "FN_length", count(*) from users 
GROUP BY "FN_length"
HAVING char_length(concat(first_name, ' ', last_name)) > 15
ORDER BY "FN_length";


DROP TABLE B
CREATE TABLE A (
    v char(3),
    t int
);
CREATE TABLE B (
    v char(3)
);
INSERT INTO A VALUES 
('XXX', 1),('XXY', 1),('XYX', 1),
('YXX', 2),('XYY', 2),('XYZ', 2),
('YXX', 3),('ZXX', 3),('XZX', 3),
('ZXY', 3),('YXZ', 3),('ZZZ', 3);

INSERT INTO B VALUES 
('XXX'),('XXY'),('XYX'),
('YXX'),('XYY'),('XYZ');


-- объединение, повтор значения вычитаются--
SELECT v FROM A
UNION
SELECT * FROM B;

-- пересечение, повтор значения --
SELECT v FROM A
INTERSECT
SELECT * FROM B;

-- вычитание, только те значения А, кот нет в В--
SELECT v FROM A
EXCEPT
SELECT * FROM B;

SELECT * FROM B
EXCEPT
SELECT v FROM A;

SELECT id FROM users
INTERSECT
SELECT user_id FROM orders;

SELECT id FROM users
EXCEPT
SELECT user_id FROM orders;


SELECT * FROM users
WHERE id=3

SELECT * FROM A, B
WHERE A.v=B.v;


--JOIN --
SELECT * 
FROM A JOIN B
ON A.v=B.v;

SELECT * 
FROM users JOIN orders
ON orders.user_id = users.id
WHERE users.id=3;

SELECT u.*, o.id FROM 
users AS u
JOIN 
orders AS o
ON o.user_id = u.id
WHERE u.id=3;

SELECT * FROM A JOIN B 
ON A.v=B.v 
JOIN phones ON A.t=phones.id;

SELECT o.id AS "order number", count(p.model)
FROM orders AS o
JOIN orders_to_phones AS otp
ON o.id=otp.order_id
JOIN phones AS p 
ON p.id = otp.phone_id
WHERE p.brand ILIKE 'samsung'
GROUP BY o.id
ORDER BY o.id;

SELECT otp.phone_id , p.model, sum(otp.quantity) AS "summary"
from orders_to_phones AS otp
JOIN phones AS p
ON p.id = otp.phone_id
GROUP BY phone_id, p.model
ORDER BY otp.phone_id;

SELECT otp.phone_id , p.model, sum(otp.quantity) AS "summary"
from orders_to_phones AS otp
FULL OUTER JOIN phones AS p
ON p.id = otp.phone_id
GROUP BY phone_id, p.model
ORDER BY otp.phone_id;


SELECT otp.phone_id , p.model, sum(otp.quantity) AS "summary"
from orders_to_phones AS otp
RIGHT JOIN phones AS p
ON p.id = otp.phone_id
GROUP BY phone_id, p.model
ORDER BY otp.phone_id;

SELECT DISTINCT u.email , o.user_id 
FROM users AS u 
JOIN orders AS o
ON u.id = o.user_id;

SELECT u.email
FROM users AS u 
JOIN orders AS o
ON u.id = o.user_id
GROUP BY u.email;

SELECT u.email 
FROM users AS u
JOIN orders AS o
ON u.id=o.user_id
JOIN orders_to_phones AS otp
ON o.id=otp.order_id
JOIN phones AS p 
ON otp.phone_id=p.id
WHERE p.brand ILIKE 'samsung'
GROUP BY u.email;

SELECT o.user_id, count(*) 
FROM users AS u 
left JOIN orders AS o 
ON u.id=o.user_id
GROUP BY o.user_id
ORDER BY o.user_id;



SELECT otp.order_id, sum(otp.quantity*p.price)
FROM orders_to_phones AS otp 
JOIN phones AS p 
ON otp.phone_id=p.id 
GROUP BY otp.order_id
ORDER BY otp.order_id


SELECT u.email, count(*) 
FROM users AS u 
JOIN orders AS o
ON u.id=o.user_id
GROUP BY u.id
ORDER BY u.id;



SELECT otp.order_id ,p.brand, p.model
FROM orders_to_phones AS otp 
JOIN phones AS p 
ON otp.phone_id = p.id 
WHERE p.model ILIKE '4%' AND p.brand ILIKE 'samsung';

SELECT p.id, p.brand, p.model, otp.quantity
FROM orders_to_phones as otp 
JOIN phones AS p 
ON otp.phone_id=p.id 
WHERE otp.order_id = 2;

SELECT sum(quantity) 
FROM orders_to_phones 
WHERE order_id = 3
GROUP BY order_id;

SELECT sum(otp.quantity) , p.brand, p.model
FROM orders_to_phones AS otp 
JOIN phones AS p 
ON otp.phone_id = p.id 
GROUP BY p.id
ORDER BY sum(otp.quantity)  DESC 
LIMIT 1;



SELECT  count("pid"), "uid"
FROM (
        SELECT u.id AS "uid", p.id AS "pid"
        FROM users AS u 
        JOIN orders AS o 
        ON u.id = o.user_id 
        JOIN orders_to_phones AS otp 
        ON o.id = otp.order_id 
        JOIN phones AS p 
        ON otp.phone_id = p.id 
        GROUP BY u.id, p.id    
) AS "uid_w_pid"
GROUP BY "uid"
ORDER BY "uid";


SELECT avg("sum")
FROM (
    SELECT sum(otp.quantity*p.price) AS "sum"
    FROM orders_to_phones AS otp 
    JOIN phones AS p 
    ON otp.phone_id = p.id 
    GROUP BY otp.order_id
) AS "Avg_check";

SELECT "sum"
FROM
    (SELECT avg("sum")
    FROM (
        SELECT sum(otp.quantity*p.price) AS "sum"
        FROM orders_to_phones AS otp 
        JOIN phones AS p 
        ON otp.phone_id = p.id 
        GROUP BY otp.order_id
    ) AS "sum_once_check") AS "Avg_check"
WHERE "sum_once_check"."sum" > "Avg_check"

--1 находим сумму каждого из заказов
    SELECT otp.order_id, sum(otp.quantity*p.price) AS "cost"
    FROM orders_to_phones AS otp 
    JOIN phones AS p 
    ON otp.phone_id = p.id 
    GROUP BY otp.order_id
--2 находим средний чек
    SELECT avg("cost")
    FROM (
        SELECT otp.order_id, sum(otp.quantity*p.price) AS "cost"
        FROM orders_to_phones AS otp 
        JOIN phones AS p 
        ON otp.phone_id = p.id 
        GROUP BY otp.order_id
    ) AS "owc"
--3 находим заказы, сумма которых выше среднего чека
    SELECT "owc".*
    FROM (
        SELECT otp.order_id, sum(otp.quantity*p.price) AS "cost"
        FROM orders_to_phones AS otp 
        JOIN phones AS p 
        ON otp.phone_id = p.id 
        GROUP BY otp.order_id
    ) AS "owc"
    WHERE "owc"."cost" > (
        SELECT avg("cost")
        FROM (
        SELECT otp.order_id, sum(otp.quantity*p.price) AS "cost"
        FROM orders_to_phones AS otp 
        JOIN phones AS p 
        ON otp.phone_id = p.id 
        GROUP BY otp.order_id
    ) AS "owc"
    )
-- refactor
    WITH "orders_with_costs" AS (
        SELECT otp.order_id, sum(otp.quantity*p.price) AS "cost"
        FROM orders_to_phones AS otp 
        JOIN phones AS p 
        ON otp.phone_id = p.id 
        GROUP BY otp.order_id
        )

    SELECT "owc".*
    FROM "orders_with_costs" AS "owc"
    WHERE "owc"."cost" >  (
        SELECT avg("owc"."cost")
        FROM "orders_with_costs" AS "owc"
    )



SELECT o.user_id, sum(otp.quantity)
FROM users AS u 
JOIN orders AS o 
ON u.id = o.user_id 
JOIN orders_to_phones AS otp 
ON o.id = otp.order_id
GROUP BY o.user_id

SELECT avg("sum")
FROM (
    SELECT o.user_id, sum(otp.quantity) AS "sum"
    FROM users AS u 
    JOIN orders AS o 
    ON u.id = o.user_id 
    JOIN orders_to_phones AS otp 
    ON o.id = otp.order_id
    GROUP BY o.user_id
    ) AS "owq"

SELECT "owq"."sum"
FROM (
    SELECT o.user_id, sum(otp.quantity)
    FROM users AS u 
    JOIN orders AS o 
    ON u.id = o.user_id 
    JOIN orders_to_phones AS otp 
    ON o.id = otp.order_id
    GROUP BY o.user_id
    ) AS "owq"
WHERE "owq"."sum" > (
    SELECT avg("sum")
    FROM (
    SELECT o.user_id, sum(otp.quantity) AS "sum"
    FROM users AS u 
    JOIN orders AS o 
    ON u.id = o.user_id 
    JOIN orders_to_phones AS otp 
    ON o.id = otp.order_id
    GROUP BY o.user_id
    ) AS "owq"
)

WITH "orders_with_quantities" AS (
    SELECT o.user_id, sum(otp.quantity) AS "quant"
    FROM users AS u 
    JOIN orders AS o 
    ON u.id = o.user_id 
    JOIN orders_to_phones AS otp 
    ON o.id = otp.order_id
    GROUP BY o.user_id
)
SELECT "owq".*
FROM "orders_with_quantities" AS "owq"
WHERE "owq"."quant" > (
    SELECT avg("owq"."quant")
    FROM "orders_with_quantities" AS "owq"
) 

WITH "orders_with_costs" AS (
        SELECT otp.order_id, sum(otp.quantity*p.price) AS "cost"
        FROM orders_to_phones AS otp 
        JOIN phones AS p 
        ON otp.phone_id = p.id 
        GROUP BY otp.order_id
        )
    SELECT "owc".*
    FROM "orders_with_costs" AS "owc"
    WHERE "owc"."cost" >  (
        SELECT avg("owc"."cost")
        FROM "orders_with_costs" AS "owc"
    )