SELECT u.*, count(u.id) AS "order_count"
FROM users AS u
JOIN orders AS o 
ON u.id=o.user_id
GROUP BY u.id, u.email;

CREATE OR REPLACE VIEW "users_with_order_amount" AS (
    SELECT u.*, count(u.id) AS "order_count"
    FROM users AS u
    LEFT JOIN orders AS o 
    ON u.id=o.user_id
    GROUP BY u.id, u.email
)

SELECT * FROM "users_with_order_amount";


SELECT o.*, sum(p.price*otp.quantity) 
FROM orders AS o
JOIN orders_to_phones AS otp 
ON o.id=otp.order_id
JOIN phones AS p 
ON otp.phone_id = p.id
GROUP BY o.id

DROP VIEW "orders_with_price";

CREATE VIEW "orders_with_price" AS (
    SELECT o.*, sum(p.price*otp.quantity) 
    FROM orders AS o
    JOIN orders_to_phones AS otp 
    ON o.id=otp.order_id
    JOIN phones AS p 
    ON otp.phone_id = p.id
    GROUP BY o.id
    ORDER BY o.user_id
)

SELECT u.id, u.email, u.birthday 
FROM "orders_with_price" AS owp
JOIN users AS u 
ON u.id=owp.user_id

CREATE VIEW "spam_list" AS (
   SELECT u.id, u.email, u.birthday 
    FROM "orders_with_price" AS owp
    JOIN users AS u 
    ON u.id=owp.user_id 
)

CREATE VIEW "users_with_FN_age_gender" AS(
    SELECT concat(first_name, ' ', last_name) AS "Full name", extract(year from age(birthday)) AS "Age", gender AS "Gender"
    FROM users
    ORDER BY "Full name"
)

CREATE VIEW "top_10_expensive_orders" AS (
    SELECT concat(u.first_name, ' ', u.last_name) AS "Full name", u.email AS "Email", sum(otp.quantity*p.price) AS "Order sum"
    FROM users AS u 
    JOIN orders AS o
    ON u.id=o.user_id
    JOIN orders_to_phones as otp
    ON o.id=otp.order_id
    JOIN phones AS p 
    ON otp.phone_id=p.id
    GROUP BY otp.order_id, u.email, u.first_name, u.last_name
    ORDER BY "Order sum" DESC
    LIMIT 10
);

